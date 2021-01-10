import 'package:ara/redux/app_state.dart';
import 'package:ara/redux/redeem/redeem_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class RedeemPage extends StatefulWidget {
  @override
  RedeemPageState createState() => RedeemPageState();
}

class RedeemPageState extends State<RedeemPage> {
  StreamSubscription<NDEFMessage> _stream;
  bool _supportsNFC = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    NFC.isNDEFSupported.then((bool isSupported) {
      print("É suportado?");
      print(isSupported);
      setState(() {
        _supportsNFC = isSupported;
      });
    });
    super.initState();
    _toggleScan();
  }

  void presentMessage(String message, Color color) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      margin: EdgeInsets.only(bottom: 30),
    ));
  }

  void _startScanning() {
    setState(() {
      _stream = NFC
          .readNDEF(alertMessage: "Custom message with readNDEF#alertMessage")
          .listen((NDEFMessage message) {
        if (message.isEmpty) {
          return;
        }
        RedeemTagAction redeemTagAction = RedeemTagAction(
          message: message,
        );
        presentMessage("Redeeming, please wait", Colors.black);
        StoreProvider.of<AppState>(context).dispatch(redeemTagAction);
        redeemTagAction.completer.future.then((value) => {
              _scaffoldKey.currentState.hideCurrentSnackBar(),
            });
        redeemTagAction.completer.future.catchError((error) {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          presentMessage(error, Colors.red);
        });
      }, onError: (error) {
        setState(() {
          _stream = null;
        });
        if (error is NFCUserCanceledSessionException) {
          print("User canceled");
        } else if (error is NFCSessionTimeoutException) {
          print("Session timed out");
        } else {
          print("error: $error");
        }
      }, onDone: () {
        setState(() {
          _stream = null;
        });
      });
    });
  }

  void _stopScanning() {
    _stream?.cancel();
    setState(() {
      _stream = null;
    });
  }

  void _toggleScan() {
    if (_stream == null) {
      _startScanning();
    } else {
      _stopScanning();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopScanning();
  }

  Widget text(message) {
    return Flexible(
      child: new Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget icon(icon, rotation) {
    return Transform.rotate(
      angle: rotation,
      child: Padding(
        child: Icon(icon, size: 200),
        padding: EdgeInsets.only(top: 25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        // appBar: CommonAppBar(),
        body: Container(
          alignment: Alignment(0.0, 0.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
                children: [
                  _supportsNFC
                      ? text("Hold your phone near the NFC tag")
                      : text("Please turn on your NFC"),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
            Row(
                children: [
                  _supportsNFC
                      ? icon(Icons.tap_and_play, 0.0)
                      : icon(Icons.wifi_off, 1.57),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
          ]),
        ));
  }
}
