import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../utils/log/print_debug_log.dart';

class RecordingService {
  html.MediaRecorder? _mediaRecorder;
  List<html.Blob> _recordedChunks = [];
  StreamController<double>? _durationController;
  Timer? _durationTimer;
  DateTime? _startTime;

  Stream<double>? get recordingDuration => _durationController?.stream;

  bool get isRecording => _mediaRecorder != null;

  Future<void> startRecording(MediaStream stream) async {
    if (!kIsWeb) {
      throw WebRTCException('Recording is only supported on web platform');
    }

    try {
      final nativeStream = stream as html.MediaStream;

      if (!html.MediaRecorder.isTypeSupported('video/webm;codecs=vp9')) {
        if (!html.MediaRecorder.isTypeSupported('video/webm;codecs=vp8')) {
          throw WebRTCException('Browser does not support video recording');
        }
      }

      _mediaRecorder = html.MediaRecorder(nativeStream, {
        'mimeType': 'video/webm;codecs=vp9',
        'videoBitsPerSecond': 2500000, // 2.5 Mbps
      });

      _recordedChunks = [];
      _startTime = DateTime.now();

      _mediaRecorder!.addEventListener('dataavailable', (event) {
        final blobEvent = event as html.BlobEvent;
        if (blobEvent.data!.size > 0) {
          _recordedChunks.add(blobEvent.data!);
        }
      });

      _mediaRecorder!.addEventListener('stop', (event) {
        _stopDurationTimer();
      });

      // Start recording with 10-second chunks
      _mediaRecorder!.start(10000);

      _startDurationTimer();

      printDebugLog(tag: 'RecordingService', message: 'Recording started');
    } catch (e) {
      throw WebRTCException('Failed to start recording: $e');
    }
  }

  Future<html.Blob> stopRecording() async {
    if (_mediaRecorder == null) {
      throw WebRTCException('No active recording');
    }

    final completer = Completer<html.Blob>();

    _mediaRecorder!.addEventListener('stop', (event) {
      final blob = html.Blob(_recordedChunks, 'video/webm');
      completer.complete(blob);
    });

    _mediaRecorder!.stop();
    _mediaRecorder = null;

    printDebugLog(tag: 'RecordingService', message: 'Recording stopped');

    return completer.future;
  }

  Future<void> downloadRecording(html.Blob blob, String filename) async {
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> uploadChunk(html.Blob chunk, String recordingId) async {
    try {
      final formData = html.FormData();
      formData.appendBlob('chunk', chunk, 'recording-chunk.webm');
      formData.append('recordingId', recordingId);

      final request = html.HttpRequest();
      request.open('POST', '/api/recordings/upload-chunk');
      request.send(formData);

      await request.onLoadEnd.first;

      if (request.status != 200) {
        throw Exception('Failed to upload chunk: ${request.statusText}');
      }
    } catch (e) {
      printDebugLog(tag: 'RecordingService', message: 'Failed to upload chunk: $e');
    }
  }

  void _startDurationTimer() {
    _durationController = StreamController<double>.broadcast();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        final duration =
            DateTime.now().difference(_startTime!).inSeconds.toDouble();
        _durationController?.add(duration);
      }
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
    _durationController?.close();
    _durationController = null;
  }

  void dispose() {
    _stopDurationTimer();
    _mediaRecorder = null;
    _recordedChunks.clear();
  }
}
