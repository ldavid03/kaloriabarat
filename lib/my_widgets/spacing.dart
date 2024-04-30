part of 'my_widgets.dart';

class SpaceHeight extends StatelessWidget {
  final String size;

  SpaceHeight(this.size);

  @override
  Widget build(BuildContext context) {
    double height;
    switch (size) {
      case 'xs':
        height = 5.0;
        break;
      case 's':
        height = 15.0;
        break;
      case 'm':
        height = 20.0;
        break;
      case 'l':
        height = 30.0;
        break;
      default:
        throw ArgumentError('Invalid size: $size');
    }

    return SizedBox(height: height);
  }
}

class SpaceWidth extends StatelessWidget {
  final String size;

  SpaceWidth(this.size);

  @override
  Widget build(BuildContext context) {
    double width;
    switch (size) {
      case 'xs':
        width = 8.0;
        break;
      case 's':
        width = 15.0;
        break;
      case 'm':
        width = 20.0;
        break;
      case 'l':
        width = 30.0;
        break;
      default:
        throw ArgumentError('Invalid size: $size');
    }

    return SizedBox(width: width);
  }
}