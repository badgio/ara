import 'package:flutter/material.dart';

import 'common/app_bar.dart';

class RedeemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: "Redeem Badge",
        ),
        body: Container(
          alignment: Alignment(0.0, 0.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
                children: [
                  Flexible(
                    child: new Text(
                      "Hold your phone near the NFC tag",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
                crossAxisAlignment:
                    CrossAxisAlignment.center //Center Row contents vertically,
                ),
            Row(
                children: [
                  Padding(
                    child: Icon(Icons.tap_and_play, size: 200),
                    padding: EdgeInsets.only(top: 25),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
          ]),
        ));
  }
}
