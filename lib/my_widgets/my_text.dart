part of 'my_widgets.dart';

class MyText extends StatelessWidget {
  final String text;
  final String size;
  final String weight;
  final String? color;

  MyText(this.text, this.size, this.weight, {this.color = 'onBackground'});

  @override
  Widget build(BuildContext context) {
    double fontSize;
    switch (size) {
      case 'xm':
        fontSize = 24.0;
        break;
      case 's':
        fontSize = 12.0;
        break;
      case 'm':
        fontSize = 16.0;
        break;
      case 'l':
        fontSize = 20.0;
        break;
      case 'xl':
        fontSize = 30.0;
        break;
      case 'xxl':
        fontSize = 40.0;
        break;
      default:
        throw ArgumentError('Invalid size: $size');
    }

    FontWeight fontWeight;
    switch (weight) {
      case 'n':
        fontWeight = FontWeight.normal;
        break;
      case 'b':
        fontWeight = FontWeight.bold;
        break;
      default:
        throw ArgumentError('Invalid weight: $weight');
    }

    Color textColor;
    switch (color) {
      case 'onPrimary':
        textColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case 'secondary':
        textColor = Theme.of(context).colorScheme.secondary;
        break;
      case 'primary':
        textColor = Theme.of(context).colorScheme.primary;
        break;
      case 'tertiary':
        textColor = Theme.of(context).colorScheme.tertiary;
        break;
      // Add more cases here for other colors
      default:
        textColor = Theme.of(context).colorScheme.onBackground;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }
}