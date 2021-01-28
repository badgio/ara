import 'dart:convert';
import 'dart:io';
import 'package:ara/configuration.dart';
import 'package:ara/models/badge.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:ara/redux/app_state.dart';
import 'package:ara/views/common/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';

class BadgeView extends StatelessWidget {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _BadgeViewModel>(
      builder: (context, vm) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Screenshot(
              controller: screenshotController,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                ),
                Text(
                  vm.b.name ?? '',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: GreyImage(
                    badge: vm.b,
                    radius: 100,
                    key: key,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () async {
                          SocialShare.shareTwitter("Visitei",
                                  hashtags: [
                                    vm.b.name.replaceAll(' ', ''),
                                    "Badgio"
                                  ],
                                  url: "https://badgio.pt",
                                  trailingText: "\nJunte-se ao Badgio!")
                              .then((data) {
                            print(data);
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(Configuration.ICON_TWITTER),
                          radius: 30,
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          await screenshotController
                              .capture()
                              .then((image) async {
                            SocialShare.shareInstagramStory(
                                    image.path,
                                    "#444444",
                                    "#987654",
                                    "https://deep-link-url")
                                .then((data) {
                              print(data);
                            });
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(Configuration.ICON_INSTAGRAM),
                          radius: 30,

                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          await screenshotController
                              .capture()
                              .then((image) async {
                            //facebook appId is mandatory for android or else share won't work
                            Platform.isAndroid
                                ? SocialShare.shareFacebookStory(
                                        image.path,
                                        "#ffffff",
                                        "#000000",
                                        "https://google.com",
                                        appId: "171357121398480")
                                    .then((data) {
                                    print(data);
                                  })
                                : SocialShare.shareFacebookStory(
                                        image.path,
                                        "#ffffff",
                                        "#000000",
                                        "https://google.com")
                                    .then((data) {
                                    print(data);
                                  });
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(Configuration.ICON_FACEBOOK),
                          radius: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                  child: Text(vm.b.description ?? ''),
                ),
              ]),
            ),
          ),
        );
      },
      converter: _BadgeViewModel.fromStore,
      distinct: true,
    );
  }
}

class _BadgeViewModel {
  MobileUser user;
  Badge b;

  static _BadgeViewModel fromStore(Store<AppState> store) {
    return _BadgeViewModel(
      b: store.state.selectedBadge,
      user: store.state.user,
    );
  }

  _BadgeViewModel({this.b, this.user});
}
