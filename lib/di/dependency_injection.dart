import 'package:bincang_visual_flutter/features/room/data/datasource/remote_datasource.dart';
import 'package:bincang_visual_flutter/features/room/domain/repositories/remote_repository.dart';
import 'package:bincang_visual_flutter/features/room/domain/usecase/remote_usecase.dart';
import 'package:bincang_visual_flutter/features/room/presentation/cubit/remote_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:bincang_visual_flutter/features/room/data/datasource/signaling_datasource.dart';
import 'package:bincang_visual_flutter/features/room/data/repositories/signaling_repository_impl.dart';
import 'package:bincang_visual_flutter/features/room/domain/repositories/signaling_repository.dart';
import 'package:bincang_visual_flutter/features/room/domain/usecase/signaling_usecase.dart';
import 'package:bincang_visual_flutter/features/room/presentation/cubit/signaling_cubit.dart';
import 'package:bincang_visual_flutter/infrastructure/websocket_service.dart';

import '../features/room/data/repositories/remote_repository_impl.dart';

final di = GetIt.asNewInstance();

Future<void> initDependency() async {}

Future<void> initWebSocketDependency() async {
  di.registerLazySingleton(
        () => Dio(),
  );
  di.registerLazySingleton(
    () => WebSocketService(),
  );

  // Datasource
  di.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<SignalingDataSource>(
        () => SignalingDataSourceImpl(webSocketService: di()),
  );

  // Repository
  di.registerLazySingleton<SignalingRepository>(
    () => SignalingRepositoryImpl(signalingDataSource: di()),
  );
  di.registerLazySingleton<RemoteRepository>(
        () => RemoteRepositoryImpl(di()),
  );

  // UseCase
  di.registerLazySingleton<SignalingUseCase>(
    () => SignalingUseCase(repository: di()),
  );
  di.registerLazySingleton<RemoteUseCase>(
        () => RemoteUseCase(repository: di()),
  );

  // Cubit
  di.registerFactory<SignalingCubit>(
    () => SignalingCubit(signalingUseCase: di()),
  );
  di.registerFactory<RemoteCubit>(
        () => RemoteCubit(remoteUseCase: di()),
  );
}
