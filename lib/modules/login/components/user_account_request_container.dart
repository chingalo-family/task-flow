import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_flow/core/utils/app_modal_util.dart';
import 'package:task_flow/core/utils/app_util.dart';
import 'package:task_flow/modules/login/components/user_account_request_form.dart';

class UserAccountRequestContainer extends StatefulWidget {
  const UserAccountRequestContainer({super.key});

  @override
  State<UserAccountRequestContainer> createState() =>
      _UserAccountRequestContainerState();
}

class _UserAccountRequestContainerState
    extends State<UserAccountRequestContainer> {
  String _successUserRequestMessage = '';
  @override
  void initState() {
    _setMetadata();
    super.initState();
  }

  void _setMetadata() {
    _successUserRequestMessage = '';
    setState(() {});
  }

  void requestForUserAccount(BuildContext context) async {
    const maxHeightRatio = 0.85;
    var response = await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: const UserAccountRequestForm(),
      maxHeightRatio: maxHeightRatio,
      initialHeightRatio: maxHeightRatio,
    );
    if (response != null) {
      String fullName = response['fullName'] ?? '';
      onSuccessUserAccount(fullName);
    }
  }

  void onSuccessUserAccount(String fullName) {
    _successUserRequestMessage =
        'Hello $fullName, your request has been sent successfully, we will reach you within two business days. Thanks';
    AppUtil.showToastMessage(
      message: _successUserRequestMessage,
      position: ToastGravity.TOP,
    );
    setState(() {});
    Timer(const Duration(seconds: 5), () {
      _successUserRequestMessage = '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => requestForUserAccount(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 5.0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'You do not have account? Click to request',
                style: const TextStyle().copyWith(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        if (_successUserRequestMessage.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withValues(alpha: 0.3),
                            Colors.green.withValues(alpha: 0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Request Sent Successfully',
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _successUserRequestMessage,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
