import 'package:ascii_chart/ascii_chart.dart' as ascii_chart;


void main(List<String> arguments) {
  print(ascii_chart.plot([[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], [5, 3, 5, 3, 7, 1, 7, 1, 7, 1], [6, 6, 6, 6, 2, 2, 2, 2]], colors: [ascii_chart.red, ascii_chart.green, ascii_chart.yellow], height: 8, padding: 11, offset: 3, precision: 3));
}
