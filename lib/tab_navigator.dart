import 'package:bb/pages/CategoryListPage.dart';
import 'package:bb/pages/HomePage.dart';
import 'package:bb/pages/MainPage.dart';
import 'package:bb/pages/ProducListPage.dart';
import 'package:bb/pages/ProductPage.dart';
import 'package:bb/pages/ShoppingCartPage.dart';
import 'package:flutter/material.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  int tabIndex;
  TabNavigator({this.navigatorKey, this.tabIndex, this.selectTab});
  final GlobalKey<NavigatorState> navigatorKey;
  final ValueChanged<int> selectTab;

  void _push(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => routeBuilders[TabNavigatorRoutes.detail](context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    // print(tabIndex.toString());
    return {
      // TabNavigatorRoutes.root: (context) => ColorsListPage(
      //       color: activeTabColor[tabItem],
      //       title: tabName[tabItem],
      //       onPush: (materialIndex) => _push(context),
      //     ),
      // TabNavigatorRoutes.detail: (context) => ColorDetailPage(
      //       color: activeTabColor[tabItem],
      //       title: tabName[tabItem],
      //       materialIndex: materialIndex,
      //     ),
      //navigatorKey.currentWidget
      TabNavigatorRoutes.root: (context) {
        switch (tabIndex) {
          case 0:
            return HomePage(
              onPush: (categoryParent) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryListPage(
                    currentCategory: categoryParent,
                    onPush: (categoryChild) {
                      if (categoryChild.noChildren)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListPage(
                              currentCategory: categoryChild,
                              onPush: (selectedProduct) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    selectedProduct,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      else
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryListPage(
                              currentCategory: categoryChild,
                              onPush: (nextCategoryChild) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListPage(
                                      currentCategory: nextCategoryChild,
                                      onPush: (selectedProduct) =>
                                          Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductPage(
                                            selectedProduct,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                    },
                  ),
                ),
              ),
            );
          case 1:
            return ShoppingCartPage(
              onPush: (selectedProduct) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    selectedProduct,
                  ),
                ),
              ),
              navigatorKey: navigatorKey,
              selectTab: selectTab,
            );
          case 2:
            return MainPage();
          default:
        }
        // return tabIndex == 0
        //     ? HomePage(
        //         onPush: (categoryParent) => Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => CategoryListPage(
        //               currentCategory: categoryParent,
        //               onPush: (categoryChild) => Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                   builder: (context) => ProductListPage(
        //                     currentCategory: categoryChild,
        //                     onPush: (selectedProduct) => Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => ProductPage(
        //                           selectedProduct,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       )
        //     : ShoppingCartPage(
        //         onPush: (selectedProduct) => Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => ProductPage(
        //               selectedProduct,
        //             ),
        //           ),
        //         ),
        //         navigatorKey: navigatorKey,
        //         selectTab: selectTab,
        //       );
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      },
    );
  }
}
