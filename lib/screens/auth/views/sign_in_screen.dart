import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:kaloriabarat/screens/auth/views/components/my_text_field.dart';
import 'package:kaloriabarat/screens/home/views/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
	final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
	bool signInRequired = false;
	IconData iconPassword = CupertinoIcons.eye_fill;
	bool obscurePassword = true;
	String? _errorMsg;
	
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
			listener: (context, state) {
				if(state is SignInSuccess) {
					setState(() {
					  signInRequired = false;
					});
				} else if(state is SignInProcess) {
					setState(() {
					  signInRequired = true;
					});
				} else if(state is SignInFailure) {
					setState(() {
					  signInRequired = false;
						_errorMsg = 'Invalid email or password';
					});
				}
			},
			child: Form(
					key: _formKey,
					child: Column(
						children: [
							const SizedBox(height: 20),
							SizedBox(
								width: MediaQuery.of(context).size.width * 0.9,
								child: MyTextField(
									controller: emailController,
									hintText: 'Email',
									obscureText: false,
									keyboardType: TextInputType.emailAddress,
									prefixIcon: const Icon(CupertinoIcons.mail_solid),
									errorMsg: _errorMsg,
									validator: (val) {
										if (val!.isEmpty) {
											return 'Please fill in this field';
										} else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
											return 'Please enter a valid email';
										}
										return null;
									}
								)
							),
							const SizedBox(height: 10),
							SizedBox(
								width: MediaQuery.of(context).size.width * 0.9,
								child: MyTextField(
									controller: passwordController,
									hintText: 'Password',
									obscureText: obscurePassword,
									keyboardType: TextInputType.visiblePassword,
									prefixIcon: const Icon(CupertinoIcons.lock_fill),
									errorMsg: _errorMsg,
									validator: (val) {
										if (val!.isEmpty) {
											return 'Please fill in this field';
										} else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$').hasMatch(val)) {
											return 'Please enter a valid password';
										}
										return null;
									},
									suffixIcon: IconButton(
										onPressed: () {
											setState(() {
												obscurePassword = !obscurePassword;
												if(obscurePassword) {
													iconPassword = CupertinoIcons.eye_fill;
												} else {
													iconPassword = CupertinoIcons.eye_slash_fill;
												}
											});
										},
										icon: Icon(iconPassword),
									),
								),
							),
							const SizedBox(height: 20),
							!signInRequired
								? 
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: ActionButton(onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              context.read<SignInBloc>().add(SignInRequired(
                                                emailController.text,
                                                passwordController.text)
                                              );
                                            }
                                          },ctx: context, str: "Sign In"),
                )
							: const CircularProgressIndicator(),

              SizedBox(
										width: MediaQuery.of(context).size.width,
										child: TextButton(
											onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(userEmail: "",)), // Replace HomeScreen() with your home screen widget
                                );
                              },
											
											child:  Padding(
												padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
												child: MyText('continue as Guest',"m","b",color: "primary",),
											)
										),
									),
              
						],
					)
				),
		);
  }
}