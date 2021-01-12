import 'dart:io';

import 'package:ara/models/badge.dart';
import 'package:ara/models/mobile_user.dart';
import 'package:ara/redux/app_state.dart';
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
          body: Screenshot(
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
                child: CircleAvatar(
                  backgroundImage: NetworkImage(vm.b.imageUrl) ?? '',
                  radius: 100,
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
                    ElevatedButton(
                      onPressed: () async {
                        SocialShare.shareTwitter(
                            "Visitei",
                            hashtags: [vm.b.name.replaceAll(' ', ''), "Badgio"],
                            url: "https://badgio.pt",
                            trailingText: "\nJunte-se ao Badgio!")
                            .then((data) {
                          print(data);
                        });
                      },
                      child: Text("T"),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await screenshotController.capture().then((image) async {
                          SocialShare.shareInstagramStory(image.path,
                              "#444444", "#987654", "https://deep-link-url")
                              .then((data) {
                            print(data);
                          });
                        });
                      },
                      child: Text("I"),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await screenshotController.capture().then((image) async {
                          //facebook appId is mandatory for android or else share won't work
                          Platform.isAndroid
                              ? SocialShare.shareFacebookStory(image.path,
                              "#ffffff", "#000000", "https://google.com",
                              appId: "171357121398480")
                              .then((data) {
                            print(data);
                          })
                              : SocialShare.shareFacebookStory(image.path,
                              "#ffffff", "#000000", "https://google.com")
                              .then((data) {
                            print(data);
                          });
                        });
                      },
                      child: Text("F"),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
                child: Text(vm.b.description ?? ''),
              ),
            ]),
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
