import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/auth/views/components/my_text_field.dart';
import 'package:kaloriabarat/screens/update_profile/views/goal_calculate_screen.dart';
import 'package:user_repository/user_repository.dart';

class UpdateProfileScreen extends StatefulWidget {
  final MyUser myUser;
  const UpdateProfileScreen(this.myUser, {Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.myUser.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: MyText('Profile Settings',"xl","b"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, widget.myUser),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: MyText('Name: ',"l","b")),
            Center(child: MyText(widget.myUser.name,"xl","b")),
            SpaceHeight('m'),
            ActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Center(child: MyText('Change Name',"l","b")),
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _nameController,
                        textAlignVertical:
                                              TextAlignVertical.center,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                                              isDense: true,
                                              filled: true,
                                              fillColor: getColorScheme(context).tertiary
                                                  .withOpacity(0.5),
                                              hintText: "Quantity",
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                               borderSide: BorderSide.none,     
                                              )),
                        ),
                      
                    ),
                    actions: [
                      ActionButton(onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({'name': _nameController.text});
                            setState(() {
                              widget.myUser.name = _nameController.text;
                            });
                            Navigator.pop(context);
                          }
                        },ctx: context, str:"Save"),
                    ],
                  ),
                );
              }, ctx: context,str:  "Change"
            ),

            SpaceHeight('l'),
            Center(child: MyText('Current calorie goal: ',"l","b")),
            Center(child: MyText(widget.myUser.goalCalories.toString(),"xl","b")),
            SpaceHeight('m'),
            ActionButton(onPressed: () async {
                final updatedUser = await Navigator.push<MyUser>(
                  context,
                  MaterialPageRoute(builder: (context) => GoalCalculateScreen(widget.myUser)),
                );

                if (updatedUser != null) {
                  setState(() {
                    widget.myUser.goalCalories = updatedUser.goalCalories;
                  });
                }
              }, ctx:context,str:"Update"),
          ],
        ),
      ),
    );
  }
}