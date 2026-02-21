import 'package:bincang_visual_flutter/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:bincang_visual_flutter/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:bincang_visual_flutter/features/analytics/domain/usecases/get_user_analytics.dart';
import 'package:bincang_visual_flutter/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:bincang_visual_flutter/features/auth/domain/usecases/get_current_user.dart';
import 'package:bincang_visual_flutter/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:bincang_visual_flutter/features/auth/domain/usecases/sign_out.dart';
import 'package:bincang_visual_flutter/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bincang_visual_flutter/features/calendar/data/datasources/calendar_remote_datasource.dart';
import 'package:bincang_visual_flutter/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:bincang_visual_flutter/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:bincang_visual_flutter/features/calendar/domain/usecases/cancel_meeting.dart';
import 'package:bincang_visual_flutter/features/calendar/domain/usecases/get_upcoming_meetings.dart';
import 'package:bincang_visual_flutter/features/calendar/domain/usecases/schedule_meeting.dart';
import 'package:bincang_visual_flutter/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/usecases/get_ice_servers.dart';
import 'package:bincang_visual_flutter/features/meeting/domain/usecases/get_room.dart';
import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
// import 'package:google_sign_in/google_sign_in.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../features/analytics/data/datasources/analytics_remote_datasource.dart';
import '../features/meeting/data/datasources/meeting_remote_datasource.dart';
import '../features/meeting/data/repositories/meeting_repository_impl.dart';
import '../features/meeting/domain/repositories/meeting_repository.dart';
import '../features/meeting/domain/usecases/create_room.dart';
import '../features/meeting/domain/usecases/join_room.dart';
import '../features/meeting/presentation/cubit/meeting_cubit.dart';
import '../infrastructure/webrtc_service.dart';

final di = GetIt.asNewInstance();

Future<void> initDependency() async {
  // =========== External ===========
  di.registerLazySingleton(() => Dio());
  di.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sharedPreferences);
  // di.registerLazySingleton(
  //       () => GoogleSignIn(
  //     scopes: ['email', 'profile', 'https://www.googleapis.com/auth/calendar'],
  //   ),
  // );

  // =========== Core ===========
  di.registerFactory(() => WebRTCService());
  di.registerLazySingleton(() => WebSocketService());
  di.registerLazySingleton(() => ApiClient(dio: di(), sharedPreferences: di()));
  di.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di()));

  // Cubit
  di.registerFactory(
    () => MeetingCubit(
      createRoomUseCase: di(),
      joinRoom: di(),
      webrtcService: di(),
      websocketService: di(),
      getIceServers: di(),
      sharedPreferences: di(),
      getRoom: di(),
    ),
  );
  di.registerFactory(
    () =>
        AuthCubit(signInWithGoogle: di(), getCurrentUser: di(), signOut: di()),
  );
  di.registerFactory(() => AnalyticsCubit(getUserAnalytics: di()));
  di.registerFactory(
    () => CalendarCubit(
      scheduleMeeting: di(),
      getUpcomingMeetings: di(),
      cancelMeeting: di(),
    ),
  );

  // Use cases
  di.registerLazySingleton(() => CreateRoom(di()));
  di.registerLazySingleton(() => JoinRoom(di()));
  di.registerLazySingleton(() => GetIceServers(di()));
  di.registerLazySingleton(() => GetUserAnalytics(di()));
  di.registerLazySingleton(() => GetCurrentUser(di()));
  di.registerLazySingleton(() => SignInWithGoogle(di()));
  di.registerLazySingleton(() => SignOut(di()));
  di.registerLazySingleton(() => CancelMeeting(di()));
  di.registerLazySingleton(() => GetUpcomingMeetings(di()));
  di.registerLazySingleton(() => ScheduleMeeting(di()));
  di.registerLazySingleton(() => GetRoom(di()));

  // Repository
  di.registerLazySingleton<MeetingRepository>(
    () => MeetingRepositoryImpl(remoteDataSource: di(), networkInfo: di()),
  );
  di.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(remoteDataSource: di(), networkInfo: di()),
  );
  // di.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(remoteDataSource: di(), sharedPreferences: di()),
  // );
  di.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(remoteDataSource: di(), networkInfo: di()),
  );

  // Data sources
  di.registerLazySingleton<MeetingRemoteDataSource>(
    () => MeetingRemoteDataSourceImpl(apiClient: di()),
  );
  di.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSourceImpl(apiClient: di()),
  );
  // di.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(apiClient: di(), googleSignIn: di()),
  // );
  di.registerLazySingleton<CalendarRemoteDataSource>(
    () => CalendarRemoteDataSourceImpl(apiClient: di()),
  );
}
