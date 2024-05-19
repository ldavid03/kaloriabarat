import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:user_repository/user_repository.dart';

class SetGoalScreen extends StatefulWidget {
  final MyUser myUser;
  const SetGoalScreen(this.myUser, {super.key});

  @override
  State<SetGoalScreen> createState() => _SetGoalScreenState();
}

class _SetGoalScreenState extends State<SetGoalScreen> {
  final users = FirebaseFirestore.instance.collection('users');
  final errorController = TextEditingController();
  late MyUser updatedUser;
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController diffWeightController = TextEditingController();
  bool isSufficitController = true;
  String genderController = 'female';
  DateTime goalDate = DateTime.now();
  double activityController = 1.2;

  TextEditingController goalDateController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  @override
  void initState() {
    genderController = widget.myUser.isMale ? 'male' : 'female';
    heightController.text =
        widget.myUser.height == 0 ? '' : widget.myUser.height.toString();
    birthDateController.text = widget.myUser.birthDate == DateTime(2000, 1, 1)
        ? ''
        : DateFormat('yyyy. MM. dd.').format(widget.myUser.birthDate);
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
          title: const MyText("Set your goal", "xl", "b"),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewInsets.bottom,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SpaceHeight("s"),
                Flexible(
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: kToolbarHeight,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
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
                                fontSize: 16,
                                color: colorScheme.onBackground,
                              ),
                              onChanged: (String? stringitem) {
                                setState(() {
                                  genderController = stringitem!;
                                });
                              },
                              items: const [
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
                      const SpaceHeight('m'),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                controller: heightController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor:
                                        colorScheme.tertiary.withOpacity(0.5),
                                    hintText: "Height",
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(12),
                                          right: Radius.zero),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            height: kToolbarHeight,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(12),
                                  left: Radius.zero),
                              color: colorScheme.tertiary.withOpacity(0.5),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: MyText("[ cm ]", "m", "n"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpaceHeight('m'),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                controller: weightController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor:
                                        colorScheme.tertiary.withOpacity(0.5),
                                    hintText: "Weight",
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(12),
                                          right: Radius.zero),
                                      borderSide: BorderSide.none,
                                    )),
                              ),
                            ),
                          ),
                          Container(
                            height: kToolbarHeight,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(12),
                                  left: Radius.zero),
                              color: colorScheme.tertiary.withOpacity(0.5),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: MyText("[ kg ]", "m", "n"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpaceHeight('m'),
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
                                  hintText: "Weight to ",
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(12),
                                        right: Radius.zero),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 100,
                              height: kToolbarHeight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: colorScheme.tertiary.withOpacity(0.8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isExpanded: true,
                                  isDense: true,
                                  dropdownColor: colorScheme.tertiary,
                                  value: isSufficitController,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  style: TextStyle(
                                    color: colorScheme.onBackground,
                                  ),
                                  onChanged: (dynamic nemValue) {
                                    setState(() {
                                      isSufficitController = nemValue!;
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: false,
                                      child: MyText("lose", "m", "n"),
                                    ),
                                    DropdownMenuItem(
                                      value: true,
                                      child: MyText("gain", "m", "n"),
                                    ),
                                  ],
                                  hint: const Text('chose'),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: kToolbarHeight,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(12),
                                  left: Radius.zero),
                              color: colorScheme.tertiary.withOpacity(0.5),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                child: MyText("[ kg ]", "m", "n"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SpaceHeight("m"),
                      TextFormField(
                        controller: birthDateController,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 100)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365)));
                          if (newDate != null) {
                            setState(() {
                              birthDateController.text =
                                  DateFormat('yyyy. MM. dd.').format(newDate);
                              updatedUser.birthDate = newDate;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: colorScheme.tertiary.withOpacity(0.5),
                          prefixIcon: const Icon(FontAwesomeIcons.calendar,
                              size: 16, color: Colors.black),
                          hintText: "Birth date",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SpaceHeight("m"),
                      TextFormField(
                        controller: goalDateController,
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365)));
                          if (newDate != null) {
                            setState(() {
                              goalDateController.text =
                                  DateFormat('yyyy. MM. dd.').format(newDate);
                              goalDate = newDate;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: colorScheme.tertiary.withOpacity(0.5),
                          prefixIcon: const Icon(FontAwesomeIcons.calendar,
                              size: 16, color: Colors.black),
                          hintText: "Diet end date",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SpaceHeight("m"),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 56,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.personRunning,
                                  color: colorScheme.onBackground),
                              const SpaceWidth("s"),
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
                                    items: const [
                                      DropdownMenuItem(
                                        value: 1.2,
                                        child: MyText("Sedentary", "m", "n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.375,
                                        child:
                                            MyText("Lightly Active", "m", "n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.55,
                                        child: MyText(
                                            "Moderately Active", "m", "n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.725,
                                        child: MyText("Very Active", "m", "n"),
                                      ),
                                      DropdownMenuItem(
                                        value: 1.9,
                                        child: MyText(
                                            "Extremely Active", "m", "n"),
                                      ),
                                    ],
                                    hint: const Text('Daily activity'),
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
                errorController.text == ""
                    ? Container()
                    : Column(
                        children: [
                          const SpaceHeight('m'),
                          MyText(errorController.text, "l", "b",
                              color: "error"),
                        ],
                      ),
                const SpaceHeight('m'),
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
                                ? 66 +
                                    (13.7 * weight) +
                                    (5 * updatedUser.height) -
                                    (6.8 * age)
                                : 655 +
                                    (9.6 * weight) +
                                    (1.8 * updatedUser.height) -
                                    (4.7 * age);
                            double tdee = bmr * activityController;
                            double goalWeightDiff = isSufficitController
                                ? double.parse(diffWeightController.text)
                                : -double.parse(diffWeightController.text);
                            updatedUser.goalCalories =
                                (tdee + (goalWeightDiff * 7700) / daysToDiet)
                                    .toInt();
                            users
                                .where('email', isEqualTo: updatedUser.email)
                                .get()
                                .then((querySnapshot) {
                              for (var document in querySnapshot.docs) {
                                document.reference.update({
                                  'isMale': updatedUser.isMale,
                                  'height': updatedUser.height,
                                  'goalCalories': updatedUser.goalCalories,
                                  'birthDate': updatedUser.birthDate,
                                });
                              }
                            }).then((_) {
                              Navigator.pop(context, updatedUser);
                            });
                          });
                        } on FormatException {
                          setState(() {
                            errorController.text =
                                "Please fill all fields correctly";
                          });
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
