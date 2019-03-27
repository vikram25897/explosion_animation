# Explode Animation

A Flutter package to create widgets with exploding animation.
Currently two types of animations are supported. More will be added in future.
Pull Requests are welcome.

## Installation

First, add `explosion_animation` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

No configuration required - the plugin should work out of the box.

### Example

![Animation Type Spread](https://media.giphy.com/media/3gNkOAh3YP88hwZPkb/source.gif)

``` dart
import 'package:exlosion_animation/exlosion_animation.dart';
import 'package:image_picker/image_picker.dart';

var key = Explode.getKey();
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String _imagePath;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Explode(
                      key: key,
                      size: Size(300, 300),
                      fit: BoxFit.cover,
                      particleCount: 200,
                      path: _imagePath,
                      type: ExplodeType.Spread,
                      isAsset: false,
                    ),
      ),
    );
  }
}
```
