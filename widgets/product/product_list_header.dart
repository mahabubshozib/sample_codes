import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:palooi/Helper/Constant.dart';
import 'package:palooi/Util/Util.dart';

class ProductListHeader extends StatelessWidget {
  final int totalProducts;
  final int? navigatorId;
  final String selectedSortBy;
  final String? queryString;
  final Function(String) onSortByChange;
  final bool? showResult;

  const ProductListHeader(
      {super.key,
      required this.selectedSortBy,
      required this.onSortByChange,
      this.showResult = true,
      required this.totalProducts, this.navigatorId, this.queryString});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (showResult != false)
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         "$totalProducts ${getSingularPluralWord(quantity: totalProducts, word: "Result")}",
        //         style: Theme.of(context).textTheme.displayMedium,
        //       ),
        //     ],
        //   ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    showFiltersSlide(context, navigatorId, queryString);
                  },
                  icon: const Icon(PhosphorIcons.funnel_simple),
                ),
                HORIZONTAL_GAP_8,
                Text(
                  "Filters",
                  style: Theme.of(context).textTheme.displaySmall,
                )
              ],
            ),
            // DropdownButton<String>(
            //   value: selectedSortBy,
            //   icon: const Icon(
            //     PhosphorIcons.caret_down,
            //     size: 18,
            //   ),
            //   onChanged: (String? newValue) {
            //     if (newValue != null) {
            //       onSortByChange(newValue);
            //     }
            //   },
            //   selectedItemBuilder: (BuildContext context) {
            //     return Constants.sortOptions.map((String item) {
            //       return Container(
            //         alignment: Alignment.centerRight,
            //         padding: const EdgeInsets.symmetric(horizontal: 5),
            //         width: 150,
            //         child: Text(
            //           item,
            //           textAlign: TextAlign.end,
            //           style: Theme.of(context).textTheme.displaySmall,
            //         ),
            //       );
            //     }).toList();
            //   },
            //   items: Constants.sortOptions.map((sortBy) {
            //     return DropdownMenuItem<String>(
            //       value: sortBy,
            //       child: Text(
            //         sortBy,
            //         style: Theme.of(context).textTheme.displaySmall,
            //       ),
            //     );
            //   }).toList(),
            //   underline: Container(
            //     // Use Container or InputBorder.none to remove the underline
            //     height: 0,
            //     color: Colors.transparent,
            //   ),
            //   isExpanded: false,
            // )
            Text(
              "$totalProducts ${getSingularPluralWord(quantity: totalProducts, word: "Result")}",
              style: Theme.of(context).textTheme.displayMedium,
            )
          ],
        ),
      ],
    );
  }
}
