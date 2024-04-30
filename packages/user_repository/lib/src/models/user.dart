import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable  {
	final String userId;
	final String email;
	String name;
  bool isMale;
  int height;
  int goalCalories; 
  DateTime birthDate;

	MyUser({
		required this.userId,
		required this.email,
		required this.name,
    required this.isMale,
    required this.height,
    required this.goalCalories,
    required this.birthDate
	});

	static var empty = MyUser(
		userId: '', 
		email: '', 
		name: '',
    isMale: false,
    height: 0,
    goalCalories: 0,
    birthDate: DateTime(2000, 1, 1)
	);

	MyUser copyWith({
		String? userId,
		String? email,
		String? name
	}) {
		return MyUser(
			userId: userId ?? this.userId, 
			email: email ?? this.email, 
			name: name ?? this.name,
      isMale: false,
      height: 0,
      goalCalories:0,
      birthDate: DateTime(2000, 1, 1)
		);
	}

	MyUserEntity toEntity() {
		return MyUserEntity(
			userId: userId, 
			email: email, 
			name: name,
      isMale: isMale,
      height: height,
      goalCalories: goalCalories,
      birthDate: birthDate
		);
	}

	static MyUser fromEntity(MyUserEntity entity) {
  return MyUser(
    userId: entity.userId ?? '', 
    email: entity.email ?? '', 
    name: entity.name ?? '',
    isMale: entity.isMale ?? false,
    height: entity.height ?? 0,
    goalCalories: entity.goalCalories ?? 0,
    birthDate: entity.birthDate ?? DateTime.now(),
  );
}
	
	@override
	List<Object?> get props => [userId, email, name, isMale, height, goalCalories, birthDate];
}