part of 'authentication_bloc.dart';

enum AuthenticationStatus {authenticated, unauthenticated, unknown}

class AuthenticationState extends Equatable {
	const AuthenticationState._({
		this.status = AuthenticationStatus.unknown,
		this.user,
    this.myUser
	});

	const AuthenticationState.unknown() : this._();

	const AuthenticationState.authenticated(User user, MyUser myUser) : 
		this._(status: AuthenticationStatus.authenticated, user: user, myUser: myUser);
	
	const AuthenticationState.unauthenticated() : 
		this._(status: AuthenticationStatus.unauthenticated);

	final AuthenticationStatus status;
	final User? user;
  final MyUser? myUser;
		
		@override
		List<Object?> get props => [status, user];
}