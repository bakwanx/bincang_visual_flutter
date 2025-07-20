import 'package:bincang_visual_flutter/infrastructure/logging_interceptor.dart';
import 'package:bincang_visual_flutter/src/data/datasource/remote_datasource.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/remote_repository.dart';
import 'package:bincang_visual_flutter/src/domain/usecase/remote_usecase.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/banner_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/call_cubit.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/remote_cubit.dart';
import 'package:bincang_visual_flutter/utils/const/api_path.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:bincang_visual_flutter/src/data/datasource/signaling_datasource.dart';
import 'package:bincang_visual_flutter/src/data/repositories/signaling_repository_impl.dart';
import 'package:bincang_visual_flutter/src/domain/repositories/signaling_repository.dart';
import 'package:bincang_visual_flutter/src/domain/usecase/signaling_usecase.dart';
import 'package:bincang_visual_flutter/src/presentation/cubit/signaling_cubit.dart';
import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';

import '../src/data/repositories/remote_repository_impl.dart';

final di = GetIt.asNewInstance();

Future<void> initDependency() async {
  di.registerLazySingleton(
    () => Dio(
      BaseOptions(
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        baseUrl: ApiPath.httpBaseUrl,
      ),
    ),
  );

  di<Dio>().interceptors.add(LoggingInterceptor());

  di.registerLazySingleton(() => WebSocketService());

  // Datasource
  di.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(di()));
  di.registerLazySingleton<SignalingDataSource>(
    () => SignalingDataSourceImpl(webSocketService: di()),
  );

  // Repository
  di.registerLazySingleton<SignalingRepository>(
    () => SignalingRepositoryImpl(signalingDataSource: di()),
  );
  di.registerLazySingleton<RemoteRepository>(() => RemoteRepositoryImpl(di()));

  // UseCase
  di.registerLazySingleton<SignalingUseCase>(
    () => SignalingUseCase(repository: di()),
  );
  di.registerLazySingleton<RemoteUseCase>(
    () => RemoteUseCase(repository: di()),
  );

  // Cubit
  di.registerFactory<SignalingCubit>(
    () => SignalingCubit(signalingUseCase: di(), webSocketService: di()),
  );
  di.registerFactory<CallCubit>(() => CallCubit());
  di.registerFactory<RemoteCubit>(() => RemoteCubit(remoteUseCase: di()));
  di.registerFactory<BannerCubit>(() => BannerCubit());
}
