import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:user_repository/user_repository.dart';

class GoalCalculateScreen extends StatefulWidget {
  final MyUser myUser;
  const GoalCalculateScreen(this.myUser, {super.key});

  @override
  State<GoalCalculateScreen> createState() => _GoalCalculateScreenState();
}

class _GoalCalculateScreenState extends State<GoalCalculateScreen> {
  final users = FirebaseFirestore.instance.collection('users');

  late MyUser updatedUser;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController diffWeightController = TextEditingController();
  bool isDeficitController = true;
  String genderController = 'female';
  DateTime goalDate = DateTime.now();
  double activityController = 1.2;

  TextEditingController goalDateController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  @override
  void initState() {
    genderController = widget.myUser.isMale ? 'male' : 'female';
    heightController.text = widget.myUser.height == 0 ? '' : widget.myUser.height.toString();
    birthDateController.text = widget.myUser.birthDate == DateTime(2000, 1, 1) ? '' : DateFormat('yyyy. MM. dd.').format(widget.myUser.birthDate);
    super.initState();
    updatedUser = widget.myUser;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: MyText("Set my Goal!", "xl", "b"),
            ),
        body: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                const SizedBox(
                  height: 32,
                ),

                Flexible(
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      //gender selector
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: kToolbarHeight,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              isDense: true,
                              dropdownColor: colorScheme.tertiary,
                              value: genderController,
                              icon: const Icon(Icons.arrow_drop_down),
                              style: TextStyle(
                                color: colorScheme.onBackground,
                              ),
                              onChanged: (String? stringitem) {
                                setState(() {
                                  genderController = stringitem!;
                                });
                              },
                              items:  [
                                DropdownMenuItem(
                                  value: "male",
                                  child: MyText("male", "l", "n"),
                                ),
                                DropdownMenuItem(
                                  value: "female",
                                  child: MyText("female", "l", "n"),
                                ),
                              ],
                              hint: const Text('select a gender'),
                            ),
                          ),
                        ),
                      ),
                      SpaceHeight('m'),

                      //Height
                      TextFormField(
                        controller: heightController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: colorScheme.tertiary.withOpacity(0.5),
                            focusColor: colorScheme.tertiary,
                            hintText: "height",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            )),
                      ),
                      
                                            SpaceHeight('m'),


                      //CurrentWeight
                      TextFormField(
                        controller: weightController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: colorScheme.tertiary.withOpacity(0.5),
                            focusColor: colorScheme.tertiary.withOpacity(0.5),
                            hintText: "weight",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      //GoalWeightDiff
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: diffWeightController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      colorScheme.tertiary.withOpacity(0.5),
                                  focusColor: colorScheme.tertiary,
                                  hintText: "weight to ",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),

                          SpaceWidth('m'),

                          Center(
  child: Container(
    width: 100,
    height: kToolbarHeight,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: colorScheme.tertiary.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        isDense: true,
        dropdownColor: colorScheme.tertiary,
        value: isDeficitController,
        icon: const Icon(Icons.arrow_drop_down),
        style: TextStyle(
          color: colorScheme.onBackground,
        ),
        onChanged: (dynamic nemValue) {
          setState(() {
            isDeficitController = nemValue!;
          });
        },
        items:  [
          DropdownMenuItem(
            value: true,
            child: MyText("lose","m","n"),
          ),
          DropdownMenuItem(
            value: false,
            child: MyText("gain","m","n"),
          ),
        ],
        hint: const Text('chose'),
      ),
    ),
  ),
),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      //birth DATE
                      TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365*100)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          if (newDate != null) {
                            setState(() {
                              birthDateController.text =
                                  DateFormat('yyyy. MM. dd.').format(newDate);
                              //selectedDate = newDate;
                              updatedUser.birthDate = newDate;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: colorScheme.tertiary.withOpacity(0.5),
                          prefixIcon: const Icon(FontAwesomeIcons.calendar,
                              size: 16, color: Colors.grey),
                          hintText: "birth date",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //GOAL DATE
                      TextFormField(
                        controller: goalDateController,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          if (newDate != null) {
                            setState(() {
                              goalDateController.text =
                                  DateFormat('yyyy. MM. dd.').format(newDate);
                              //selectedDate = newDate;
                              goalDate = newDate;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: colorScheme.tertiary.withOpacity(0.5),
                          prefixIcon: const Icon(FontAwesomeIcons.calendar,
                              size: 16, color: Colors.grey),
                          hintText: "diet end date",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),

                      //daily activity
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 56,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.personRunning,
                                  color: colorScheme.onBackground),
                              SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    isDense: true,
                                    dropdownColor: colorScheme.tertiary,
                                    value: activityController,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    style: TextStyle(
                                      color: colorScheme.onBackground,
                                    ),
                                    onChanged: (dynamic activityRate) {
                                      setState(() {
                                        activityController = activityRate!;
                                      });
                                    },
                                    items:  [
                                      DropdownMenuItem(
                                        value: 1.2,
                                        child: MyText("unactive","m","n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.375,
                                        child: MyText("slightly active","m","n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.55,
                                        child: MyText("moderatly active","m","n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.725,
                                        child: MyText("very active","m","n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.9,
                                        child: MyText("extra active","m","n"),
                                      ),
                                    ],
                                    hint: const Text('daily activity'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ),

                const SizedBox(
                  height: 32,
                ),

                //SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: kToolbarHeight,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        try {
                          setState(() {
                            updatedUser.isMale = genderController == 'male';
                            updatedUser.height =
                                int.parse(heightController.text);
                            int daysToDiet =
                                goalDate.difference(DateTime.now()).inDays;
                            double weight = double.parse(weightController.text);
                            int age = DateTime.now()
                                    .difference(updatedUser.birthDate)
                                    .inDays ~/
                                365;
                            double bmr = updatedUser.isMale
                                ? 88.362 +
                                    (13.397 * weight) +
                                    (4.799 * updatedUser.height) -
                                    (5.677 * age)
                                : 447.593 +
                                    (9.247 * weight) +
                                    (3.098 * updatedUser.height) -
                                    (4.330 * age);
                            double tdee = bmr * activityController;
                            double goalWeightDiff = isDeficitController
                                ? double.parse(diffWeightController.text)
                                : -double.parse(diffWeightController.text);
                            updatedUser.goalCalories =
                                (tdee + (goalWeightDiff * 7700) / daysToDiet)
                                    .toInt();
                                    users
                            .where('email', isEqualTo: updatedUser.email)
                            .get()
                            .then((querySnapshot) {
                              querySnapshot.docs.forEach((document) {
                                document.reference.update({
                                  'isMale': updatedUser.isMale,
                                  'height': updatedUser.height,
                                  'goalCalories': updatedUser.goalCalories,
                                  'birthDate': updatedUser.birthDate,
                                });
                              });
                            }).then((_) {
                              Navigator.pop(context, updatedUser);
                            });
                              
                          });
                          //inpuit
                        } catch (e) {
                          return;
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
