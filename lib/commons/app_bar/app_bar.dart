const double kToolbarMargin = 76.0;
const double kSystemBarHeight = 28;

double Function(double min, double max) computeLinear(double shrinkOffset, double minExtent, double maxExtent) {
  return (double min, double max) {
    var result = -(max - min) / (maxExtent - minExtent) * shrinkOffset + max;
    return result;
  };
}
