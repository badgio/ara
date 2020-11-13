import 'package:ara/theme.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;

  const CommonAppBar({String title, Key key})
      : _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_title),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AriaTheme.appBarSize);
}
