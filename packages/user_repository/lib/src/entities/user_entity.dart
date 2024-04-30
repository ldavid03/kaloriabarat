import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
	final String userId;
	final String email;
	String name;
  bool isMale;
  int height;
  int goalCalories; 
  DateTime birthDate;

	MyUserEntity({
		required this.userId,
		required this.email,
		required this.name,
    required this.isMale,
    required this.height,
    required this.goalCalories,
    required this.birthDate
	});

	Map<String, Object?> toDocument() {
		return {
			'userId': userId,
			'email': email,
			'name': name,
      'isMale': isMale,
      'height': height,
      'goalCalories': goalCalories,
      'birthDate': birthDate
		};
	}

	static MyUserEntity fromDocument(Map<String, dynamic> doc) {
		return MyUserEntity(
			userId: doc['userId'],
			email: doc['email'], 
			name: doc['name'],
      isMale: doc['isMale'] as bool,
      height: doc['height'] as int,
      goalCalories: doc['goalCalories'] as int,
      birthDate: (doc['birthDate'] as Timestamp).toDate()
		);
	}

	@override
	List<Object?> get props => [userId, email, name, isMale, height, goalCalories, birthDate];

}