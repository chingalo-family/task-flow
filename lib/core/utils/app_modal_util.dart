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
      context: context, // The BuildContext required for showModalBottomSheet.
      isDismissible: false, // Whether the user can dismiss the bottom sheet by
      // dragging it down.
      isScrollControlled: true, // Whether the bottom sheet can be scrolled.
      backgroundColor: Colors.transparent, // Transparent background color.
      builder: (context) => GestureDetector(
        // A GestureDetector widget that detects gestures and triggers callbacks
        // when a gesture is recognized.
        behavior: HitTestBehavior.opaque, // Makes the GestureDetector opaque.
        onTap: () => Navigator.of(context).pop(), // Closes the bottom sheet.
        child: GestureDetector(
          // Another GestureDetector that does not react to taps.
          onTap: () {},
          child: DraggableScrollableSheet(
            // A scrollable sheet that can be dragged to reveal or hide its content.
            initialChildSize: initialHeightRatio, // Initial height ratio.
            maxChildSize: maxHeightRatio < initialHeightRatio
                ? initialHeightRatio
                : maxHeightRatio, // Maximum height ratio.
            minChildSize: minHeightRatio < initialHeightRatio
                ? minHeightRatio
                : initialHeightRatio, // Minimum height ratio.
            builder: (
              BuildContext context,
              ScrollController scrollController,
            ) {
              // The builder function that returns the content of the sheet.
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ), // Adds padding to the bottom of the sheet to avoid covering
                // the on-screen keyboard.
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // White background color.
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(topBorderRadius),
                    ), // Top border radius.
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 1.0,
                    ), // Horizontal margin for the inner container.
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(topBorderRadius),
                      ), // Top border radius for the inner container.
                    ),
                    child:
                        actionSheetContainer, // Dynamic widget for content of a specific action sheet
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static void showPopUpConfirmation(
    BuildContext context, {
    String title = '',
    String cancelActionLabel = 'Cancel',
    String confirmActionLabel = 'Confirm',
    double borderRadius = 16.0,
    double confirmationContainerPadding = 5.0,
    double confirmationContainerMargin = 10.0,
    Color themColor = const Color(0xFF619E51),
    Color confirmationButtomThemColor = const Color(0xFF619E51),
    MainAxisAlignment actionButtomAlignment = MainAxisAlignment.center,
    Widget? confirmationContent,
    List<Widget> customConfirmationActionButtons = const [],
    VoidCallback? onConfirm,
  }) async {
    double width = MediaQuery.of(context).size.width;

    // Display the dialog using showDialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create a SimpleDialog with a custom shape, padding,
        // margin, background color, and alignment
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          insetPadding: EdgeInsets.all(confirmationContainerMargin),
          titlePadding: title.isNotEmpty
              ? EdgeInsets.all(confirmationContainerPadding)
              : const EdgeInsets.all(0.0),
          backgroundColor: Colors.white,
          alignment: Alignment.center,
          // Display the title if it is not empty
          title: Visibility(
            visible: title.isNotEmpty,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                vertical: confirmationContainerPadding,
              ),
              child: Text(
                title,
                style: const TextStyle().copyWith(
                  color: themColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // Add padding to the content
          contentPadding: EdgeInsets.all(confirmationContainerPadding),
          children: [
            // Display the confirmation content if it is not null
            Visibility(
              visible: confirmationContent != null,
              child: Container(
                width: width,
                margin: EdgeInsets.symmetric(
                  horizontal: confirmationContainerPadding,
                  vertical: confirmationContainerMargin,
                ),
                child: confirmationContent,
              ),
            ),
            // Display the custom confirmation action buttons or a default row of buttons
            Container(
              width: width,
              margin: EdgeInsets.symmetric(
                vertical: confirmationContainerPadding,
              ),
              child: Row(
                mainAxisAlignment: actionButtomAlignment,
                children: customConfirmationActionButtons.isNotEmpty
                    ? customConfirmationActionButtons
                    : [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: OutlinedButton(
                            style: const ButtonStyle().copyWith(
                              foregroundColor:
                                  WidgetStatePropertyAll(themColor),
                              side: WidgetStatePropertyAll(
                                const BorderSide().copyWith(
                                  color: themColor,
                                ),
                              ),
                              textStyle: WidgetStateProperty.all(
                                const TextStyle().copyWith(
                                  color: themColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text(cancelActionLabel),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                          ),
                          child: FilledButton(
                            style: const ButtonStyle().copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                  confirmationButtomThemColor),
                              textStyle: WidgetStateProperty.all(
                                const TextStyle().copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            onPressed: onConfirm,
                            child: Text(confirmActionLabel),
                          ),
                        ),
                      ],
              ),
            )
          ],
        );
      },
    );
  }
}
