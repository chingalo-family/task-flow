import 'package:flutter/material.dart';

class AppModalUtil {
  static Future showActionSheetModal({
    required BuildContext context,
    required Widget actionSheetContainer,
    double initialHeightRatio = 0.3,
    double minHeightRatio = 0.1,
    double maxHeightRatio = 0.85,
    double topBorderRadius = 20.0,
  }) {
    maxHeightRatio = maxHeightRatio > 0 ? maxHeightRatio : 0.85;
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: initialHeightRatio,
            maxChildSize: maxHeightRatio < initialHeightRatio
                ? initialHeightRatio
                : maxHeightRatio,
            minChildSize: minHeightRatio < initialHeightRatio
                ? minHeightRatio
                : initialHeightRatio,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(topBorderRadius),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(topBorderRadius),
                      ),
                    ),
                    child: actionSheetContainer,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
