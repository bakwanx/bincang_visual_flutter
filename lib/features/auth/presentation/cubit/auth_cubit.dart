import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_out.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final GetCurrentUser getCurrentUser;
  final SignOut signOut;

  AuthCubit({
    required this.signInWithGoogle,
    required this.getCurrentUser,
    required this.signOut,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await getCurrentUser(NoParams());

    result.fold(
          (failure) => emit(Unauthenticated()),
          (user) => emit(Authenticated(user)),
    );
  }

  Future<void> signIn() async {
    emit(AuthLoading());

    final result = await signInWithGoogle(NoParams());

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(Authenticated(user)),
    );

  }

  Future<void> logout() async {
    final result = await signOut(NoParams());

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(Unauthenticated()),
    );
  }
}