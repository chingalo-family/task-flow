import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/modules/about/components/about_detail.dart';
import 'package:task_manager/modules/about/components/about_icon.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: SafeArea(
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(AppContant.appBarHeight),
            child: AppBarContainer(
              title: 'About',
              isAboutPage: true,
              isAddVisible: false,
              isViewChartVisible: false,
            ),
          ),
          body: Consumer<AppThemeState>(
            builder: (context, appThemeState, child) {
              String currentTheme = appThemeState.currentTheme;
              Color textColor = currentTheme == ThemeServices.darkTheme
                  ? AppContant.darkTextColor
                  : AppContant.ligthTextColor;
              return Consumer<AppInfoState>(
                builder: (context, appInfoState, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                AboutIcon(size: size),
                                AboutDetail(
                                  textColor: textColor,
                                  value:
                                      'App Name : ${appInfoState.currentAppName}',
                                ),
                                AboutDetail(
                                  textColor: textColor,
                                  value:
                                      'App Version : ${appInfoState.currentAppVersion}',
                                ),
                                AboutDetail(
                                  textColor: textColor,
                                  value:
                                      'App Id : ${appInfoState.currentAppId}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
