import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/profile.dart';
import '../../domain/sign_up_exception.dart';
import '../../domain/usecases/sign_up_use_case.dart';

// ---------- Eventos ----------
sealed class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String fullName;
  final String email;
  final String password;

  RegisterSubmitted({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
  });
}

// ---------- Estado ----------
enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  final RegisterStatus status;
  final Profile? profile;
  final String? errorMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.profile,
    this.errorMessage,
  });
}

// ---------- Bloc ----------
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignUpUseCase _signUp;

  RegisterBloc(this._signUp) : super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState(status: RegisterStatus.loading));
    try {
      // Una sola llamada: el Bloc no sabe que son dos pasos.
      final profile = await _signUp(
        username: event.username,
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      emit(RegisterState(status: RegisterStatus.success, profile: profile));
    } on SignUpException catch (e) {
      emit(RegisterState(
        status: RegisterStatus.failure,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(const RegisterState(
        status: RegisterStatus.failure,
        errorMessage: 'Ocurrió un error inesperado',
      ));
    }
  }
}
