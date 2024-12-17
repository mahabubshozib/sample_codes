import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:palooi/Controller/category_controller.dart';
import 'package:palooi/Controller/product_controller.dart';
import 'package:palooi/Helper/Constant.dart';
import 'package:palooi/Helper/Extension.dart';
import 'package:palooi/Helper/colors.dart';
import 'package:palooi/Model/CategoryTree.dart';
import 'package:palooi/Model/FilterOptions.dart';
import 'package:palooi/Util/Util%20Widgets/custom_check_box.dart';
import 'package:palooi/Util/Util%20Widgets/custom_divider.dart';
import 'package:palooi/Util/Util%20Widgets/custom_text_field.dart';
import 'package:palooi/Util/Util%20Widgets/secondary_app_bar.dart';
import 'package:palooi/Widget/custom_primary_button.dart';
import 'package:palooi/Widget/tree_view.dart';

class Category {
  final String name;
  final List<String> subcategories;

  Category(this.name, this.subcategories);
}

class Filters extends StatefulWidget {
  final int? navigatorId;
  final String? searchQuery;

  const Filters({Key? key, this.navigatorId, this.searchQuery}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final categoryController = Get.find<CategoryController>();
  final productController = Get.find<ProductController>();

  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();

  List<String> selectedCategories = [];
  List<String> selectedSubcategories = [];
  List<String> selectedAvailabilities = [];
  List<int> selectedRatings = [];
  List<String> selectedColors = [];

  int selectedSortByIndex = -1;
  int showCategoryCount = 5;
  String selectedSortByOption = "";
  RangeValues _currentRangeValues = RangeValues(0, MAX_PRICE);

  final List<String> sortByOptions = [
    "Rating",
    "Price: Low to High",
    "Price: High to Low",
    "Newest"
  ];

  final List<String> availabilitiesOptions = [
    "In-Stock",
    "Out of stock",
  ];

  final List<int> ratingsOptions = [5, 4, 3, 2, 1];

  final List<String> colorOptions = ["Black", "Red", "Green", "Blue"];

  int getSelectedFilter() {
    int sum = 0;
    if (selectedSortByIndex != -1) sum++;
    if (selectedAvailabilities.isNotEmpty) sum++;
    if (selectedCategories.isNotEmpty) sum++;
    if (selectedColors.isNotEmpty) sum++;
    if (selectedRatings.isNotEmpty) sum++;

    return sum;
  }

  bool allChecked(category) {
    return true;
  }

  void setCurrentPriceRange() {
    setState(() {
      _currentRangeValues = RangeValues(double.parse(minPriceController.text),
          double.parse(maxPriceController.text));
    });
  }

  void showAllCategories() {
    setState(() {
      showCategoryCount = categoryController.categories.length;
    });
  }

  void showLessCategories() {
    setState(() {
      showCategoryCount = 5;
    });
  }

  List<String> getSelectedCategoryNames(List<CategoryTree> categoryTree) {
    List<String> selectedNames = [];
    for (var category in categoryTree) {
      if (category.isSelected) {
        selectedNames.add(category.title);
      }
      if (category.children.isNotEmpty) {
        selectedNames.addAll(getSelectedCategoryNames(category.children));
      }
    }
    setState(() {
      selectedCategories = selectedNames;
    });
    return selectedNames;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MAX_HEIGHT,
      color: PINK_PINK1,
      child: Column(
        children: [
          VERTICAL_GAP_32,
          SecondaryAppbar(title: "Filters", navigatorId: widget.navigatorId),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const RoundedRectangleBorder(
                      side:
                          BorderSide(color: Colors.transparent), // Border side
                    ),
                    title: Text(
                      "Categories (${getSelectedCategoryNames(categoryController.categories).length})",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    children: [
                      SingleChildScrollView(
                        child: TreeView(
                          onChanged: (newCategories) {
                            setState(() {
                              categoryController.categories.value =
                                  newCategories;
                            });
                          },
                          categories: categoryController.categories
                              .take(showCategoryCount)
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            categoryController.categories.length >
                                    showCategoryCount
                                ? showAllCategories()
                                : showLessCategories();
                          },
                          child: Row(
                            children: [
                              Icon(
                                categoryController.categories.length >
                                        showCategoryCount
                                    ? Icons.add
                                    : Icons.remove,
                                weight: 1,
                                size: 18,
                                color: NEUTRAL_N700,
                              ),
                              HORIZONTAL_GAP_8,
                              Text(
                                categoryController.categories.length >
                                        showCategoryCount
                                    ? "See More"
                                    : "See Less",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const CustomDivider(),
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const RoundedRectangleBorder(
                      side:
                          BorderSide(color: Colors.transparent), // Border side
                    ),
                    title: Text(
                      "Sort by",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    children: [
                      ...sortByOptions.mapIndexed(
                        (option, index) => Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Radio(
                                    activeColor: PRIMARY_COLOR,
                                    value: selectedSortByIndex,
                                    groupValue: index,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSortByIndex = index;
                                        selectedSortByOption = option;
                                      });
                                    }),
                              ),
                            ),
                            Text(
                              option,
                              style: selectedSortByIndex == index
                                  ? Theme.of(context).textTheme.displayMedium
                                  : Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const CustomDivider(),
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const RoundedRectangleBorder(
                      side:
                          BorderSide(color: Colors.transparent), // Border side
                    ),
                    title: Text(
                      "Availability (${selectedAvailabilities.length})",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    children: [
                      Column(
                        children: availabilitiesOptions.map((option) {
                          String value = option == availabilitiesOptions[0] ? "inStock" : "outOfStock";

                          bool isChecked = selectedAvailabilities
                              .any((element) => element == value);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: CustomCheckBox(
                              checked: isChecked,
                              title: Text(
                                option,
                                style: isChecked
                                    ? Theme.of(context).textTheme.displayMedium
                                    : Theme.of(context).textTheme.bodyMedium,
                              ),
                              onChange: (value) {
                                setState(() {
                                  if (value) {
                                    selectedAvailabilities.add(option == availabilitiesOptions[0] ? "inStock" : "outOfStock");
                                  } else {
                                    selectedAvailabilities.remove(option == availabilitiesOptions[0] ? "inStock" : "outOfStock");
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  const CustomDivider(),
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const RoundedRectangleBorder(
                      side:
                          BorderSide(color: Colors.transparent), // Border side
                    ),
                    title: Text(
                      "Price",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: RangeSlider(
                          values: _currentRangeValues,
                          max: MAX_PRICE,
                          divisions: 1000,
                          activeColor: PRIMARY_COLOR,
                          labels: RangeLabels(
                            _currentRangeValues.start.round().toString(),
                            _currentRangeValues.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRangeValues = values;
                              minPriceController.text =
                                  "${values.start.round()}";
                              maxPriceController.text = "${values.end.round()}";
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                textInputType: TextInputType.number,
                                textEditingController: minPriceController,
                                hintText: "\$ Min Price",
                                onChange: (value) {
                                  setState(() {
                                    _currentRangeValues = RangeValues(
                                        double.parse(value!),
                                        double.parse(value));
                                  });
                                  return null;
                                },
                              ),
                            ),
                            HORIZONTAL_GAP_32,
                            Expanded(
                              child: CustomTextField(
                                textInputType: TextInputType.number,
                                textEditingController: maxPriceController,
                                hintText: "\$ Max Price",
                                onChange: (value) {
                                  setState(() {
                                    _currentRangeValues = RangeValues(
                                        double.parse(value!),
                                        double.parse(value));
                                  });
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const CustomDivider(),
                  // ExpansionTile(
                  //   initiallyExpanded: true,
                  //   shape: const RoundedRectangleBorder(
                  //     side:
                  //         BorderSide(color: Colors.transparent), // Border side
                  //   ),
                  //   title: Text(
                  //     "Ratings (${selectedRatings.length})",
                  //     style: Theme.of(context).textTheme.displayLarge,
                  //   ),
                  //   children: [
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: ratingsOptions.map((option) {
                  //         bool isChecked = selectedRatings.any((element) => element == option);
                  //         bool isFirstOption = ratingsOptions.indexOf(option) == 0;
                  //
                  //         return Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  //           child: CustomCheckBox(
                  //             checked: isChecked,
                  //             title: Row(
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     SizedBox(
                  //                       width: 10,
                  //                       child: Text(
                  //                         "$option",
                  //                         style: isChecked
                  //                             ? Theme.of(context).textTheme.displayMedium
                  //                             : Theme.of(context).textTheme.bodyMedium,
                  //                       ),
                  //                     ),
                  //                     if (!isFirstOption) HORIZONTAL_GAP_10,
                  //                     if (!isFirstOption)
                  //                       Row(
                  //                         children: [
                  //                           const Icon(
                  //                             PhosphorIcons.star_fill,
                  //                             color: STAR_COLOR,
                  //                             size: 15,
                  //                           ),
                  //                           HORIZONTAL_GAP_10,
                  //                           Text(
                  //                             "& Up",
                  //                             style: isChecked
                  //                                 ? Theme.of(context).textTheme.displayMedium
                  //                                 : Theme.of(context).textTheme.bodyMedium,
                  //                           ),
                  //                         ],
                  //                       ),
                  //                   ],
                  //                 ),
                  //                 HORIZONTAL_GAP_10,
                  //                 if (isFirstOption)
                  //                   Row(
                  //                     children: List.generate(
                  //                       option,
                  //                           (index) => const Icon(
                  //                         PhosphorIcons.star_fill,
                  //                         color: STAR_COLOR,
                  //                         size: 15,
                  //                       ),
                  //                     ),
                  //                   ),
                  //               ],
                  //             ),
                  //             onChange: (value) {
                  //               setState(() {
                  //                 if (value) {
                  //                   selectedRatings.add(option);
                  //                 } else {
                  //                   selectedRatings.remove(option);
                  //                 }
                  //               });
                  //             },
                  //           ),
                  //         );
                  //       }).toList(),
                  //     )
                  //
                  //   ],
                  // ),
                  // const CustomDivider(),
                  // ExpansionTile(
                  //   initiallyExpanded: false,
                  //   shape: const RoundedRectangleBorder(
                  //     side:
                  //         BorderSide(color: Colors.transparent), // Border side
                  //   ),
                  //   title: Text(
                  //     "Delivery Type",
                  //     style: Theme.of(context).textTheme.displayLarge,
                  //   ),
                  // ),
                  // const CustomDivider(),
                  // ExpansionTile(
                  //   initiallyExpanded: false,
                  //   shape: const RoundedRectangleBorder(
                  //     side:
                  //         BorderSide(color: Colors.transparent), // Border side
                  //   ),
                  //   title: Text(
                  //     "Brands",
                  //     style: Theme.of(context).textTheme.displayLarge,
                  //   ),
                  // ),
                  // const CustomDivider(),
                  ExpansionTile(
                    initiallyExpanded: true,
                    shape: const RoundedRectangleBorder(
                      side:
                          BorderSide(color: Colors.transparent), // Border side
                    ),
                    title: Text(
                      "Colors (${selectedColors.length})",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    children: [
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          itemCount: colorOptions.length,
                          itemBuilder: (BuildContext context, int index) {
                            String option = colorOptions[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: CustomCheckBox(
                                      checked: selectedColors
                                          .any((element) => element == option),
                                      title: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                option,
                                                style: selectedColors.any(
                                                        (element) =>
                                                            element == option)
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .displayMedium
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      onChange: (value) {
                                        setState(() {
                                          if (value) {
                                            selectedColors.add(option);
                                          } else {
                                            selectedColors.remove(option);
                                          }
                                        });
                                      }),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const CustomDivider(),
                  // ExpansionTile(
                  //   initiallyExpanded: false,
                  //   shape: const RoundedRectangleBorder(
                  //     side:
                  //         BorderSide(color: Colors.transparent), // Border side
                  //   ),
                  //   title: Text(
                  //     "Size",
                  //     style: Theme.of(context).textTheme.displayLarge,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 100,
                  // )
                ],
              ),
            ),
          ),
          Container(
            color: WHITE,
            height: 80,
            width: MAX_WIDTH,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSecondaryButton(
                      labelColor: Colors.black,
                      color: WHITE,
                      borderColor: Colors.black,
                      label: "Reset (${getSelectedFilter()})",
                      onClick: () {
                        setState(() {
                          selectedAvailabilities = [];
                          selectedSortByOption = "";
                          selectedCategories = [];
                          selectedColors = [];
                          selectedRatings = [];
                          selectedSortByIndex = -1;
                          selectedSubcategories = [];
                          minPriceController.text = MIN_PRICE.toString();
                          maxPriceController.text = MAX_PRICE.toString();
                          _currentRangeValues = RangeValues(0, MAX_PRICE);
                        });
                      },
                    ),
                  ),
                  HORIZONTAL_GAP_16,
                  Expanded(
                    child: CustomSecondaryButton(
                      label: "Apply",
                      onClick: () {
                        applyProductFilters();
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  applyProductFilters() async {
    Get.back();
    String categories = "category=";

    if (selectedCategories.isNotEmpty) {
      categories =
          selectedCategories.map((category) => "category=$category").join("&");
    }

    await productController.getAllProducts(
      categories: categories,
      filterOptions: FilterOptions(
        search: widget.searchQuery,
        minPrice:
            minPriceController.text.isNotEmpty ? minPriceController.text : "0",
        maxPrice: maxPriceController.text.isNotEmpty
            ? maxPriceController.text
            : "$MAX_PRICE",
        availability: selectedAvailabilities.join("&"),
        sortBy: selectedSortByOption.isNotEmpty
            ? selectedSortByIndex == 1 || selectedSortByIndex == 2
                ? selectedSortByOption
                    .split(":")[1]
                    .trim()
                    .split(" ")
                    .join(" ")
                    .toLowerCase()
                : selectedSortByOption.toLowerCase()
            : "",
      ),
    );
  }
}
