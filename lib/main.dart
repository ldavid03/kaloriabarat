import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloriabarat/app.dart';
import 'firebase_options.dart';
import 'package:user_repository/user_repository.dart';
import 'dart:developer';
import 'simple_bloc_observer.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    log('FlutterError: ${details.exception}', name: 'FlutterError');
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}

