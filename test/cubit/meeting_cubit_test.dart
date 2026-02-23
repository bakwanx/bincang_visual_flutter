// import 'package:bincang_visual_flutter/core/error/failures.dart';
// import 'package:bincang_visual_flutter/features/meeting/domain/usecases/create_room.dart';
// import 'package:bincang_visual_flutter/features/meeting/domain/usecases/get_ice_servers.dart';
// import 'package:bincang_visual_flutter/features/meeting/domain/usecases/get_room.dart';
// import 'package:bincang_visual_flutter/features/meeting/presentation/cubit/meeting_cubit.dart';
// import 'package:bincang_visual_flutter/infrastructure/webrtc_service.dart';
// import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';
// import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:either_dart/src/either.dart';
// import 'package:mockito/annotations.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// @GenerateMocks([
//   CreateRoom,
//   GetRoom,
//   WebRTCService,
//   WebSocketService,
//   GetIceServers,
//   SharedPreferences
// ])
// import 'meeting_cubit_test.mocks.dart';
//
// void main() {
//   late MeetingCubit cubit;
//   late MockCreateRoom mockCreateRoom;
//   late MockGetRoom mockGetRoom;
//   late MockWebRTCService mockWebRTCService;
//   late MockWebSocketService mockWebSocketService;
//   late MockGetIceServers mockGetIceServers;
//   late MockSharedPreferences mockSharedPreferences;
//
//   setUp(() {
//     mockCreateRoom = MockCreateRoom();
//     mockGetRoom = MockGetRoom();
//     mockWebRTCService = MockWebRTCService();
//     mockWebSocketService = MockWebSocketService();
//     mockGetIceServers = MockGetIceServers();
//     mockSharedPreferences = MockSharedPreferences();
//
//     cubit = MeetingCubit(
//       createRoomUseCase: mockCreateRoom,
//       getRoom: ,
//       webrtcService: mockWebRTCService,
//       websocketService: mockWebSocketService,
//       getIceServers: mockGetIceServers,
//       sharedPreferences: mockSharedPreferences,
//     );
//   });
//
//   tearDown(() {
//     cubit.close();
//   });
//
//   group('MeetingCubit', () {
//     var tRoom = Room(
//       id: 'room-123',
//       name: 'Test Room',
//       hostId: 'user-123',
//       createdAt: DateTime.now(),
//       maxParticipants: 100,
//       isRecording: false,
//       settings: RoomSettings(),
//     );
//
//     test('initial state is MeetingInitial', () {
//       expect(cubit.state, equals(MeetingInitial()));
//     });
//
//     group('createMeeting', () {
//       blocTest<MeetingCubit, MeetingState>(
//         'emits [MeetingLoading, MeetingJoined] when create room succeeds',
//         build: () {
//           when(mockCreateRoom(any)).thenAnswer((_) async => Right(tRoom));
//           when(mockJoinRoom(any)).thenAnswer((_) async => Right(tRoom));
//           // when(mockWebRTCService.initializeLocalMedia())
//           //     .thenAnswer((_) async => MockMediaStream());
//           when(
//             mockWebSocketService.connect(
//               roomId: anyNamed('roomId'),
//               userId: anyNamed('userId'),
//               displayName: anyNamed('displayName')
//             ),
//           ).thenAnswer((_) async {});
//
//           return cubit;
//         },
//         act:
//             (cubit) =>
//                 cubit.createRoom(),
//         expect:
//             () => [
//               const MeetingLoading(message: 'Creating room...'),
//               isA<MeetingLoading>(),
//               isA<MeetingRoomCreated>(),
//               isA<MeetingJoined>(),
//             ],
//       );
//
//       blocTest<MeetingCubit, MeetingState>(
//         'emits [MeetingLoading, MeetingError] when create room fails',
//         build: () {
//           when(mockCreateRoom(any)).thenAnswer(
//             (_) async => const Left(ServerFailure('Failed to create room')),
//           );
//           return cubit;
//         },
//         act:
//             (cubit) =>
//                 cubit.createRoom(),
//         expect:
//             () => [
//               const MeetingLoading(message: 'Creating room...'),
//               const MeetingError('Failed to create room'),
//             ],
//       );
//     });
//
//     group('toggleMute', () {
//       blocTest<MeetingCubit, MeetingState>(
//         'toggles mute state',
//         build: () {
//           when(mockWebRTCService.toggleAudio(any)).thenAnswer((_) async {});
//           return cubit;
//         },
//         seed:
//             () => const MeetingJoined(
//               roomId: 'room-123',
//               localUserId: 'participant-123',
//               remoteStreams: {},
//               participants: [],
//               chatMessages: [],
//               isMuted: false,
//             ),
//         act: (cubit) => cubit.toggleMute(),
//         expect:
//             () => [
//               const MeetingJoined(
//                 roomId: 'room-123',
//                 localUserId: 'participant-123',
//                 remoteStreams: {},
//                 participants: [],
//                 chatMessages: [],
//                 isMuted: true,
//               ),
//             ],
//         verify: (_) {
//           verify(mockWebRTCService.toggleAudio(true)).called(1);
//         },
//       );
//     });
//
//     group('sendChatMessage', () {
//       blocTest<MeetingCubit, MeetingState>(
//         'adds message to chat and sends via websocket',
//         build: () => cubit,
//         seed:
//             () => const MeetingJoined(
//               roomId: 'room-123',
//               localUserId: 'participant-123',
//               remoteStreams: {},
//               participants: [],
//               chatMessages: [],
//             ),
//         act: (cubit) => cubit.sendChatMessage('Hello!'),
//         expect:
//             () => [
//               predicate<MeetingJoined>(
//                 (state) =>
//                     state.chatMessages.length == 1 &&
//                     state.chatMessages.first.message == 'Hello!',
//               ),
//             ],
//         verify: (_) {
//           verify(mockWebSocketService.send(any)).called(1);
//         },
//       );
//     });
//   });
// }
