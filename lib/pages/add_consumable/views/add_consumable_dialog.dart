import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/pages/add_consumable/blocs/create_consumable_bloc/create_consumable_bloc.dart';
import 'package:uuid/uuid.dart';

Future getConsumableCreation(BuildContext context, String userId) {
  return showDialog(
      context: context,
      builder: (ctx) {
        TextEditingController consumableNameController =
            TextEditingController();
        TextEditingController consumableCalorieController =
            TextEditingController();
        TextEditingController consumableReferenceQuantityController =
            TextEditingController();
        Consumable consumable = Consumable.empty;
        ColorScheme colorScheme = Theme.of(context).colorScheme;
        String dropdownValue = "ml";
        final errorController = TextEditingController();

        return BlocProvider.value(
          value: context.read<CreateConsumableBloc>(),
          child: StatefulBuilder(builder: (ctx, setState) {
            return BlocListener<CreateConsumableBloc, CreateConsumableState>(
              listener: (context, state) {
                if (state is CreateConsumableSuccess) {
                  Navigator.pop(ctx, consumable);
                }
              },
              child: AlertDialog(
                title: Center(
                  child: Text('Add consumable',
                      style: TextStyle(
                        color: colorScheme.onBackground,
                      )),
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
                            TextFormField(
                              controller: consumableNameController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      colorScheme.secondary.withOpacity(0.1),
                                  focusColor: colorScheme.tertiary,
                                  hintText: "Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                            SpaceHeight('s'),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        consumableReferenceQuantityController,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        filled: true,
                                        focusColor: colorScheme.tertiary,
                                        fillColor: colorScheme.secondary
                                            .withOpacity(0.1),
                                        hintText: "Quantity",
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.horizontal(
                                              left: Radius.circular(12),
                                              right: Radius.zero),
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ),
                                Container(
                                  height: kToolbarHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(12),
                                        left: Radius.zero),
                                    color:
                                        colorScheme.secondary.withOpacity(0.1),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Center(
                                      child: MyText("[ g ]", "m", "n"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SpaceHeight('s'),
                            TextFormField(
                              controller: consumableCalorieController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      colorScheme.secondary.withOpacity(0.1),
                                  hintText: "Calories",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    errorController.text == ""
                        ? Container()
                        : Column(
                            children: [
                              SpaceHeight('s'),
                              MyText(errorController.text, "m", "b",
                                  color: "error"),
                            ],
                          ),
                    SpaceHeight('s'),
                    ActionButton(
                        onPressed: () {
                          try {
                            setState(
                              () {
                                consumable.consumableId = const Uuid().v1();
                                consumable.userId = userId;
                                consumable.name = consumableNameController.text;
                                consumable.referenceQuantity = int.parse(
                                    consumableReferenceQuantityController.text);
                                consumable.unit = dropdownValue;
                                consumable.calories =
                                    int.parse(consumableCalorieController.text);
                              },
                            );
                            if (consumable.name.isEmpty ||
                                consumable.unit.isEmpty ||
                                consumable.referenceQuantity <= 0 ||
                                consumable.calories <= 0) {
                              return;
                            }
                            context
                                .read<CreateConsumableBloc>()
                                .add(CreateConsumable(consumable));
                          } on FormatException {
                            setState(() {
                              errorController.text =
                                  "Please fill all fields correctly";
                            });
                          } catch (e) {
                            return;
                          }
                        },
                        ctx: context,
                        str: "Save"),
                  ],
                ),
              ),
            );
          }),
        );
      });
}
