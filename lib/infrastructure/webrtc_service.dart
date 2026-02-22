import 'dart:async';

import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../core/error/exceptions.dart';
import '../utils/log/print_debug_log.dart';
import '../utils/media/media_projection_service.dart';

class WebRTCService {
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, MediaStream> _remoteStreams = {};

  MediaStream? _localStream;
  MediaStream? _screenStream;

  final Map<String, RTCRtpSender> _screenShareSenders = {};

  final _remoteStreamController =
      StreamController<Map<String, MediaStream>>.broadcast();
  final _iceConnectionStateController =
      StreamController<Map<String, RTCIceConnectionState>>.broadcast();
  final _iceCandidateController =
      StreamController<Map<String, RTCIceCandidate>>.broadcast();
  final _screenShareStreams = <String, MediaStream>{};
  final _screenShareStreamController =
      StreamController<Map<String, MediaStream>>.broadcast();

  Stream<Map<String, MediaStream>> get remoteStreams =>
      _remoteStreamController.stream;

  Stream<Map<String, RTCIceConnectionState>> get iceConnectionStates =>
      _iceConnectionStateController.stream;

  Stream<Map<String, RTCIceCandidate>> get iceCandidates =>
      _iceCandidateController.stream;

  Stream<Map<String, MediaStream>> get screenShareStreams =>
      _screenShareStreamController.stream;

  Map<String, MediaStream> get currentScreenShares =>
      Map.unmodifiable(_screenShareStreams);

  bool _isDisposed = false;
  String? _localUserId;
  VoidCallback? onBrowserStopShare;

  void setLocalUserId(String userId) {
    _localUserId = userId;
  }

  Future<MediaStream> initializeLocalMedia({
    bool audio = true,
    bool video = true,
  }) async {
    if (_isDisposed) throw WebRTCException('Service is disposed');

    try {
      final Map<String, dynamic> mediaConstraints = {
        'audio': audio
            ? {
                'echoCancellation': true,
                'noiseSuppression': true,
                'autoGainControl': true,
              }
            : false,
        'video': video
            ? {
                'facingMode': 'user',
                'width': {'ideal': 1280, 'max': 1920},
                'height': {'ideal': 720, 'max': 1080},
                'frameRate': {'ideal': 30, 'max': 60},
              }
            : false,
      };

      _localStream = await navigator.mediaDevices.getUserMedia(
        mediaConstraints,
      );

      if (audio) {
        Helper.selectAudioOutput('speaker');
      }

      return _localStream!;
    } catch (e) {
      throw WebRTCException('Failed to initialize local media: $e');
    }
  }

  Future<RTCPeerConnection> establishedPeerConnection(
    String peerId,
    RoomConfig config,
  ) async {
    if (_isDisposed) throw WebRTCException('Service is disposed');
    if (_peerConnections.containsKey(peerId)) {
      return _peerConnections[peerId]!;
    }

    try {
      final Map<String, dynamic> configuration = {
        'iceServers': config.iceServers.map((server) {
          final serverConfig = <String, dynamic>{'urls': server.urls};
          if (server.username != null) {
            serverConfig['username'] = server.username;
          }
          if (server.credential != null) {
            serverConfig['credential'] = server.credential;
          }
          return serverConfig;
        }).toList(),
        'sdpSemantics': 'unified-plan',
        'iceTransportPolicy': 'all',
        'bundlePolicy': 'max-bundle',
        'rtcpMuxPolicy': 'require',
      };

      final Map<String, dynamic> constraints = {
        'optional': [
          {'DtlsSrtpKeyAgreement': true},
        ],
      };

      final pc = await createPeerConnection(configuration, constraints);

      if (_localStream != null) {
        _localStream!.getTracks().forEach((track) {
          pc.addTrack(track, _localStream!);
        });
      }

      if (_screenStream != null) {
        final screenTrack = _screenStream!.getVideoTracks().firstOrNull;
        if (screenTrack != null) {
          final sender = await pc.addTrack(screenTrack, _screenStream!);
          _screenShareSenders[peerId] = sender;
          printDebugLog(
            tag: '$peerId',
            message: 'Added existing screen share track',
          );
        }
      }

      pc.onTrack = (RTCTrackEvent event) {
        printDebugLog(
          tag: '$peerId',
          message:
              'onTrack: kind=${event.track.kind}, trackId=${event.track.id}',
        );

        if (event.streams.isEmpty) {
          printDebugLog(tag: '$peerId', message: 'No streams in track event');
          return;
        }

        for (var stream in event.streams) {
          final streamId = stream.id;

          final existingCamera = _remoteStreams[peerId];
          final existingScreen = _screenShareStreams[peerId];

          if (existingCamera?.id == streamId) {
            printDebugLog(
              tag: '$peerId',
              message:
                  'Camera stream updated (track toggle), keeping existing stream',
            );

            _remoteStreams[peerId] = stream;
            _remoteStreamController.add(Map.from(_remoteStreams));
            continue;
          }

          if (existingScreen?.id == streamId) {
            printDebugLog(
              tag: '$peerId',
              message: 'Screen share stream updated, keeping existing stream',
            );
            _screenShareStreams[peerId] = stream;
            _screenShareStreamController.add(Map.from(_screenShareStreams));
            continue;
          }

          printDebugLog(tag: '$peerId', message: 'New stream: $streamId');

          final hasAudio = stream.getAudioTracks().isNotEmpty;
          final hasVideo = stream.getVideoTracks().isNotEmpty;
          final hasCamera = _remoteStreams.containsKey(peerId);

          printDebugLog(
            tag: peerId,
            message:
                'Stream analysis: hasAudio=$hasAudio, hasVideo=$hasVideo, hasCamera=$hasCamera',
          );

          if (!hasCamera) {
            // first stream = camera (regardless of audio state, in case mic is off)
            printDebugLog(tag: peerId, message: 'Added CAMERA stream');
            _remoteStreams[peerId] = stream;
            _remoteStreamController.add(Map.from(_remoteStreams));
          } else if (hasCamera && hasVideo && !hasAudio) {
            // second stream with video but no audio = screen share
            printDebugLog(tag: peerId, message: 'Added SCREEN SHARE stream');
            _screenShareStreams[peerId] = stream;
            _screenShareStreamController.add(Map.from(_screenShareStreams));
          } else {
            printDebugLog(
              tag: peerId,
              message: 'Unexpected stream configuration, skipping',
            );
          }
        }
      };

      pc.onRemoveTrack = (stream, track) {
        printDebugLog(
          tag: peerId,
          message: 'onRemoveTrack: trackId=${track.id}, streamId=${stream.id}',
        );

        if (_screenShareStreams[peerId]?.id == stream.id) {
          printDebugLog(tag: peerId, message: 'Removing screen share stream');
          _screenShareStreams.remove(peerId);
          _screenShareStreamController.add(Map.from(_screenShareStreams));
        }
      };

      pc.onIceCandidate = (RTCIceCandidate candidate) {
        _iceCandidateController.add({peerId: candidate});
      };

      pc.onIceConnectionState = (RTCIceConnectionState state) {
        printDebugLog(tag: peerId, message: 'ICE Connection State: $state');
        _iceConnectionStateController.add({peerId: state});

        switch (state) {
          case RTCIceConnectionState.RTCIceConnectionStateFailed:
            _handleIceConnectionFailure(peerId);
            break;
          case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
            _handleIceDisconnection(peerId);
            break;
          default:
            break;
        }
      };

      _peerConnections[peerId] = pc;
      return pc;
    } catch (e) {
      throw WebRTCException('Failed to create peer connection: $e');
    }
  }

  Future<RTCSessionDescription> createOffer(String peerId) async {
    final pc = _peerConnections[peerId];
    if (pc == null) throw WebRTCException('Peer connection not found');

    try {
      final offer = await pc.createOffer({
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      });

      await pc.setLocalDescription(offer);
      return offer;
    } catch (e) {
      throw WebRTCException('Failed to create offer: $e');
    }
  }

  Future<RTCSessionDescription> createAnswer(String peerId) async {
    final pc = _peerConnections[peerId];
    if (pc == null) throw WebRTCException('Peer connection not found');

    try {
      final answer = await pc.createAnswer({
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      });

      await pc.setLocalDescription(answer);
      return answer;
    } catch (e) {
      throw WebRTCException('Failed to create answer: $e');
    }
  }

  Future<void> setRemoteDescription(
    String peerId,
    RTCSessionDescription description,
  ) async {
    final pc = _peerConnections[peerId];
    if (pc == null) throw WebRTCException('Peer connection not found');

    try {
      await pc.setRemoteDescription(description);
    } catch (e) {
      throw WebRTCException('Failed to set remote description: $e');
    }
  }

  Future<void> addIceCandidate(String peerId, RTCIceCandidate candidate) async {
    final pc = _peerConnections[peerId];
    if (pc == null) {
      printDebugLog(
        tag: peerId,
        message: 'Peer connection not found, cannot add ICE candidate',
      );
      return;
    }

    try {
      await pc.addCandidate(candidate);
    } catch (e) {
      printDebugLog(tag: peerId, message: 'Failed to add ICE candidate: $e');
    }
  }

  Future<void> toggleAudio(bool muted) async {
    if (_localStream == null) return;
    _localStream!.getAudioTracks().forEach((track) {
      track.enabled = !muted;
    });
  }

  Future<void> toggleVideo(bool videoOff) async {
    if (_localStream == null) return;
    _localStream!.getVideoTracks().forEach((track) {
      track.enabled = !videoOff;
    });
  }

  Future<void> switchCamera() async {
    if (_localStream == null) return;
    final videoTrack = _localStream!.getVideoTracks().firstOrNull;
    if (videoTrack != null) {
      await Helper.switchCamera(videoTrack);
    }
  }

  Future<Map<String, RTCSessionDescription>> startScreenShare() async {
    if (_screenStream != null) {
      throw WebRTCException('Screen share already active');
    }

    try {
      if (!kIsWeb) {
        await MediaProjectionService.start();
        _screenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': {
            'width': {'ideal': 1280}, // Lower than desktop
            'height': {'ideal': 720},
            'frameRate': {'ideal': 15}, // Lower frame rate
          },
          'audio': false,
        });
      } else {
        _screenStream = await navigator.mediaDevices.getDisplayMedia({
          'video': {'cursor': 'always'},
          'audio': false,
        });
      }

      printDebugLog(
        tag: 'WebRTC',
        message: 'Screen share stream created: ${_screenStream!.id}',
      );

      final screenTrack = _screenStream!.getVideoTracks()[0];
      final offersToSend = <String, RTCSessionDescription>{};

      for (var entry in _peerConnections.entries) {
        final peerId = entry.key;
        final pc = entry.value;

        try {
          final sender = await pc.addTrack(screenTrack, _screenStream!);
          _screenShareSenders[peerId] = sender;
          printDebugLog(tag: peerId, message: 'Added screen share track');

          final offer = await pc.createOffer();
          await pc.setLocalDescription(offer);

          offersToSend[peerId] = offer;

          printDebugLog(tag: peerId, message: 'Created renegotiation offer');
        } catch (e) {
          printDebugLog(
            tag: peerId,
            message: 'Failed to add screen share track: $e',
          );
        }
      }

      if (_localUserId != null) {
        _screenShareStreams[_localUserId!] = _screenStream!;
        _screenShareStreamController.add(Map.from(_screenShareStreams));
        printDebugLog(
          tag: 'WebRTC',
          message: 'Added LOCAL screen share to own view',
        );
      }

      screenTrack.onEnded = () async {
        await stopScreenShare();
        onBrowserStopShare?.call();
      };

      return offersToSend;
    } catch (e) {
      _screenStream = null;
      throw WebRTCException('Failed to start screen share: $e');
    }
  }

  Future<Map<String, RTCSessionDescription>> stopScreenShare() async {
    if (_screenStream == null) return {};

    _screenStream!.getTracks().forEach((track) {
      track.stop();
    });

    final offersToSend = <String, RTCSessionDescription>{};

    for (var entry in _screenShareSenders.entries) {
      final peerId = entry.key;
      final sender = entry.value;
      final pc = _peerConnections[peerId];

      if (pc != null) {
        try {
          await pc.removeTrack(sender);
          printDebugLog(tag: peerId, message: 'Removed screen share track');

          final offer = await pc.createOffer();
          await pc.setLocalDescription(offer);

          offersToSend[peerId] = offer;

          printDebugLog(
            tag: peerId,
            message: 'Created renegotiation offer (stop)',
          );
        } catch (e) {
          printDebugLog(
            tag: peerId,
            message: 'Failed to remove screen share track: $e',
          );
        }
      }
    }

    _screenShareSenders.clear();

    if (_localUserId != null) {
      _screenShareStreams.remove(_localUserId!);
      _screenShareStreamController.add(Map.from(_screenShareStreams));
      printDebugLog(tag: 'WebRTC', message: 'Removed LOCAL screen share');
    }

    _screenStream = null;
    return offersToSend;
  }

  Future<void> _handleIceConnectionFailure(String peerId) async {
    printDebugLog(
      tag: peerId,
      message: 'ICE connection failed, attempting ICE restart',
    );
    final pc = _peerConnections[peerId];
    if (pc == null) return;

    try {
      final offer = await pc.createOffer({'iceRestart': true});
      await pc.setLocalDescription(offer);
    } catch (e) {
      printDebugLog(tag: peerId, message: 'ICE restart failed: $e');
    }
  }

  void _handleIceDisconnection(String peerId) {
    printDebugLog(
      tag: peerId,
      message: 'ICE disconnected, monitoring for reconnection',
    );
    Future.delayed(const Duration(seconds: 5), () {
      final pc = _peerConnections[peerId];
      if (pc != null &&
          pc.iceConnectionState ==
              RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        _handleIceConnectionFailure(peerId);
      }
    });
  }

  Future<void> closePeerConnection(String peerId) async {
    final pc = _peerConnections.remove(peerId);
    if (pc != null) {
      await pc.close();
    }

    _remoteStreams.remove(peerId);
    _remoteStreamController.add(Map.from(_remoteStreams));

    _screenShareSenders.remove(peerId);
    _screenShareStreams.remove(peerId);
    _screenShareStreamController.add(Map.from(_screenShareStreams));
  }

  Future<void> closeAllConnections() async {
    final peerIds = List<String>.from(_peerConnections.keys);
    for (final peerId in peerIds) {
      await closePeerConnection(peerId);
    }

    for (final stream in _screenShareStreams.values) {
      await stream.dispose();
    }
    _screenShareStreams.clear();
    _screenShareStreamController.add({});
  }

  Future<void> stopLocalMedia() async {
    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) => track.stop());
      await _localStream!.dispose();
      _localStream = null;
    }
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;

    for (var pc in _peerConnections.values) {
      await pc.close();
    }
    _peerConnections.clear();

    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream?.dispose();
    _localStream = null;

    _screenStream?.getTracks().forEach((track) => track.stop());
    _screenStream?.dispose();
    _screenStream = null;

    _remoteStreams.clear();
    _screenShareSenders.clear();

    await _remoteStreamController.close();
    await _iceConnectionStateController.close();
    await _iceCandidateController.close();
    await _screenShareStreamController.close();
  }

  void removeScreenShareStream(String peerId) {
    if (_screenShareStreams.remove(peerId) != null) {
      _screenShareStreamController.add(Map.from(_screenShareStreams));
      printDebugLog(
        tag: 'WebRTC',
        message: 'Manually removed screen share for $peerId',
      );
    }
  }

  MediaStream? get localStream => _localStream;

  MediaStream? get screenStream => _screenStream;

  Map<String, MediaStream> get remoteStreamMap => Map.from(_remoteStreams);

  bool get isScreenSharing => _screenStream != null;

  Map<String, RTCPeerConnection> get peerConnections =>
      Map.from(_peerConnections);
}
