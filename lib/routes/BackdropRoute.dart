import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:udacity_flutter_app/routes/CategoryRoute.dart';
import 'package:udacity_flutter_app/CategoryWidget.dart' as catWidget;

class BackdropRoute extends StatelessWidget {

  const BackdropRoute();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BackdropScaffold(
      title: Text("backdropRoute"),
      backpanel: CategoryRoute(),
      body: Center(
        child: Text(
          "yooooo brooo",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      actions: <Widget>[
        Icon(Icons.favorite),
        Icon(Icons.cake),
      ],
    );
  }

}
