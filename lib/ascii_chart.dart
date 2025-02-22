var black = "\x1b[30m";
var red = "\x1b[31m";
var green = "\x1b[32m";
var yellow = "\x1b[33m";
var blue = "\x1b[34m";
var magenta = "\x1b[35m";
var cyan = "\x1b[36m";
var lightgray = "\x1b[37m";
var defaultgrey = "\x1b[39m";
var darkgray = "\x1b[90m";
var lightred = "\x1b[91m";
var lightgreen = "\x1b[92m";
var lightyellow = "\x1b[93m";
var lightblue = "\x1b[94m";
var lightmagenta = "\x1b[95m";
var lightcyan = "\x1b[96m";
var white = "\x1b[97m";
var reset = "\x1b[0m";

String colored (String character, { String? color }) {
  if (color == null) {
    return character;
  } else {
    return color + character + reset;
  }
}

plot(List<List<num>> series, { int offset = 3, int padding = 11, int height = 10, List<String> colors = const ["\x1b[39m"], int precision = 2 }) {
  // find minimum and maximum value
  var min = series[0][0];
  var max = series[0][0];
  
  for (var i = 0; i < series.length; i++) {
    for (var j = 0; j < series[i].length; j++) {
      if (series[i][j] < min) min = series[i][j];
      if (series[i][j] > max) max = series[i][j];
    }
  }

  // define overall variables for plotting
  var defaultSymbols = [ '┼', '┤', '╶', '╴', '─', '╰', '╭', '╮', '╯', '│' ];
  var range = (max - min).abs();
  var ratio = range == 0 ? 1 : height / range;
  var min2 = (min * ratio).round();
  var max2 = (max * ratio).round();
  var rows = (max2 - min2).abs();
  var width = 0;
  for (var i = 0; i < series.length; i++) {
    if (series[i].length > width) {
      width = series[i].length;
    }
  }
  width = width + offset;
  
  // generate the output --
  // - generate empty matrix
  var result = <List<String>>[];
  for (var i = 0; i < rows + 1; i++) {
    result.add([]);
    for (var j = 0; j < width; j++) {
      result[i].add(" ");
    }
  }

  // - generate axis and labels
  for (var y = min2; y <= max2; y++) {
    var label = (rows > 0 ? max - (y - min2) * range / rows : y /* , y - min2 */).toStringAsFixed(precision).padLeft(padding);
    result[y - min2][offset - label.length > 0 ? offset - label.length : 0] = label;
    result[y - min2][offset - 1] = y == 0 ? defaultSymbols[0] : defaultSymbols[1];
  }

  // - generate plots
  for (var j = 0; j < series.length; j++) {
    var currentColor = colors[j % colors.length];
    var y0 = (series[j][0] * ratio - min2).round();
    result[rows - y0][offset - 1] = colored(defaultSymbols[0], color: currentColor);

    for (var x = 0; x < series[j].length - 1; x++) {
       var y00 = (series[j][x + 0] * ratio).round() - min2;     
       var y1 = (series[j][x + 1] * ratio).round() - min2;

       if (y00 == y1) {
          result[rows - y00][x + offset] = colored(defaultSymbols[4], color: currentColor);
       } else {
          result[rows - y1][x + offset] = colored(y00 > y1 ? defaultSymbols[5] : defaultSymbols[6], color: currentColor);
          result[rows - y00][x + offset] = colored(y00 > y1 ? defaultSymbols[7] : defaultSymbols[8], color: currentColor);
          var from = y00 < y1 ? y00 : y1;
          var to = y00 > y1 ? y00 : y1;

          for (var y = from + 1; y < to; y++) {
            result[rows - y][x + offset] = colored(defaultSymbols[9], color: currentColor);
          }
       }
    }
  }
  return result.map((x) => x.join('')).join('\n');
}
