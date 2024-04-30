import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
	late final StreamSubscription<User?> _userSubscription;

	AuthenticationBloc({
		required this.userRepository
	}) : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
			add(AuthenticationUserChanged(user));
		});
		on<AuthenticationUserChanged>((event, emit) async {
			if(event.user != null && event.user!.email != null) {
        MyUser currentUser = await userRepository.getUser(event.user!.email!);
				emit(AuthenticationState.authenticated(event.user!, currentUser ));
        
			} else {
				emit(const AuthenticationState.unauthenticated());
			}
		});
  }
	
	@override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}