### Example
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
