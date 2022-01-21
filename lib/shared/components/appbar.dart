import 'package:flutter/material.dart';
import 'package:shipbay/screens/notifications/notifications.dart';
import 'package:shipbay/shared/components/asset_image.dart';
import 'package:shipbay/shared/components/slide_right_route.dart';
import 'package:shipbay/shared/services/colors.dart';

class MovingAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  MovingAppBar(
    this.title, {
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Tingsapp.transparent,
      elevation: 0,
      title: _buildLogo(context),
      centerTitle: true,
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () =>
                Navigator.push(context, SlideRightRoute(page: Notifications())),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );
  }

  SizedBox _buildLogo(context) {
    return SizedBox(
        height: 30, width: 30, child: assetImage(context, "logo.png"));
  }
}
