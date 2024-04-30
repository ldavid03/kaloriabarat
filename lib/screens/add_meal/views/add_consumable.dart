import 'dart:developer';

import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/add_meal/blocs/create_consumable_bloc/create_consumable_bloc.dart';
import 'package:uuid/uuid.dart';

Future getConsumableCreation(BuildContext context, String userId){
  return showDialog(
    context: context,
    builder: (ctx) {
      TextEditingController consumableNameController = TextEditingController();
      TextEditingController consumableCalorieController = TextEditingController();
      TextEditingController consumableReferenceQuantityController = TextEditingController();
      TextEditingController consumableUnitController = TextEditingController();
      bool isLoading = false;
      Consumable consumable = Consumable.empty;
      ColorScheme colorScheme = Theme.of(context).colorScheme;  
      String dropdownValue="ml";

      return BlocProvider.value(
        value: context.read<CreateConsumableBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            return BlocListener<CreateConsumableBloc, CreateConsumableState>(
              listener: (context, state) {
                if(state is CreateConsumableSuccess){
                  Navigator.pop(ctx, consumable);
                } else if(state is CreateConsumableLoading){
                  setState(() {
                    isLoading=true;
                  });
                }
            
              },

              //popup dialog
              child: AlertDialog(
                title: Center(
                  child: Text(
                    'Add consumable',
                    style: TextStyle(
                      color: colorScheme.onBackground,
                    )
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                contentPadding: const EdgeInsets.all(20),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //const SizedBox(height: 10,),
                      
                            //NAME
                            TextFormField(
                              controller: consumableNameController,
                              textAlignVertical:TextAlignVertical.center,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: colorScheme.secondary.withOpacity(0.1),
                                focusColor: colorScheme.tertiary,
                                hintText: "Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                )
                              ),
                            ),
                      
                            const SizedBox(height: 10,),
                      
                            //REFERENCE QUANTITY
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: consumableReferenceQuantityController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      focusColor: colorScheme.tertiary,
                                      fillColor: colorScheme.secondary.withOpacity(0.1),
                                      hintText: "Quantity",
                                      border: const OutlineInputBorder(
                                         borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(12), 
                                          right: Radius.zero
                                        ),
                                        borderSide: BorderSide.none,
                                      )
                                    ),
                                  ),
                                ),
                                Container(
                                    height: 56,  // Set the height as needed
                                
                                  decoration: BoxDecoration(
                                    borderRadius:const BorderRadius.horizontal(
                                      right: Radius.circular(12), 
                                      left: Radius.zero
                                    ),
                                    color:  colorScheme.secondary.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: DropdownButton(
                                        isDense: true,
                                        dropdownColor: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                        value:dropdownValue,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        underline: Container(),
                                        style: TextStyle(
                                          color: colorScheme.onBackground,
                                        ),
                                        onChanged: (String? nemValue){
                                          setState(() {
                                            dropdownValue = nemValue!;
                                          });
                                        },
                                        items: const [
                                          DropdownMenuItem(
                                            value: "ml",
                                            child: Text("ml"),
                                          ),
                                          DropdownMenuItem(
                                            value: "g",
                                            child: Text("g"),
                                          ),
                                        ], 
                                      
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                                                  
                            
                      
                            //unit
                            
                            const SizedBox(height: 10,),
                    
                            //CALORIES
                            TextFormField(
                              controller: consumableCalorieController,
                              textAlignVertical:TextAlignVertical.center,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: colorScheme.secondary.withOpacity(0.1),
                                hintText: "calories",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                )
                              ),
                            ),
                      
                            const SizedBox(height: 10,),
                            
                            
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),


                    ActionButton(
                              onPressed: () {
                          try{
                            setState(() {
                              consumable.consumableId = const Uuid().v1();
                              consumable.userId = userId;
                              consumable.name = consumableNameController.text;
                              consumable.referenceQuantity = int.parse(consumableReferenceQuantityController.text);
                              consumable.unit = dropdownValue;
                              consumable.calories = int.parse(consumableCalorieController.text);
                            },);
                            if(consumable.name.isEmpty || consumable.unit.isEmpty || consumable.referenceQuantity<=0 || consumable.calories<=0){
                              return;
                            }
                            context.read<CreateConsumableBloc>().add(CreateConsumable(consumable));
                          }
                          catch(e){
                            return;
                          }
                          //create consumable obj&pop
                          
              
                        },
                              ctx: context,
                              str: "Save"),

                    
                  ],
                ),
              ),
            );
          }
        ),
      );
    }
  );        
}