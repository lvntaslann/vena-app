import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_state.dart';
import '../../model/user/user.dart';
import '../../services/auth/auth_services.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthServices _authServices;
  AuthCubit(this._authServices) : super(AuthState()) {
    loadNameFromPrefs();
  }
  void nameChanged(String name) => emit(state.copyWith(name: name));
  void emailChanged(String val) {
    emit(state.copyWith(email: val));
  }

  void passwordChanged(String val) {
    emit(state.copyWith(password: val));
  }

  Future<void> loadNameFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    emit(state.copyWith(name: name));
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await _authServices.login(state.email, state.password);
      if (result['success']) {
        final data = result['user'];
        final user = User(
          data['uid'],
          name: data['name'] ?? '',
          email: data['email'],
          password: state.password,
        );
        emit(state.copyWith(user: user, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: result['error']));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> register() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result =
          await _authServices.register(state.name, state.email, state.password);
      if (result['success']) {
        final dummyUser = User('',
            name: state.name, email: state.email, password: state.password);
        emit(state.copyWith(isLoading: false, user: dummyUser));
      } else {
        emit(state.copyWith(isLoading: false, error: result['error']));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final result = await _authServices.signInWithGoogle();
      if (result['success']) {
        final data = result['user'];
        final user = User(
          data['uid']?.toString() ?? '',
          name: data['name']?.toString() ?? '',
          email: data['email']?.toString() ?? '',
          password: '',
        );
        emit(state.copyWith(user: user, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false, error: result['error']));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
