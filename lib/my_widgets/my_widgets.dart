import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaloriabarat/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

import 'package:kaloriabarat/static_data/apiData.dart' as localdata;
import 'package:kaloriabarat/static_data/mealTypes.dart' as mealTypes;
import 'package:http/http.dart' as http;

part 'color_scheme.dart';
part 'profile_pic.dart';
part 'spacing.dart';
part 'my_text.dart';
part 'my_log_out_button.dart';
part 'my_bottom_bar.dart';
part 'guest_alert_dialog.dart';
part 'meal_type_dropdown.dart';
part 'button_style.dart';
part 'action_button.dart';
part 'date_picker.dart';
part 'search_widget.dart';
