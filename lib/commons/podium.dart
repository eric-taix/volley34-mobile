import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:v34/utils/extensions.dart';

class Place {
  final PlaceValue placeValue;
  final String tooltip;
  final bool highlight;
  Place(this.placeValue, this.tooltip, this.highlight);
}

class PlaceValue {
  final String id;
  final double value;

  PlaceValue(this.id, this.value);
}

class Podium extends StatefulWidget {
  final String title;
  final List<PlaceValue> placeValues;
  final bool active;
  final int highlightedIndex;
  final int promoted;
  final int relegated;

  Podium(this.placeValues,
      {this.title = "",
      this.active = true,
      this.highlightedIndex,
      this.promoted = 0,
      this.relegated = 0});

  @override
  _PodiumState createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  List<Place> places;
  PlaceValue max;
  List<PlaceValue> placeValues;
  PlaceValue highlightedValue;
  bool showToolTip = false;
  bool showPosition = false;
  int animationDuration = 200;
  int position;

  @override
  void initState() {
    _updatePlaces();
    places = List.generate(
        placeValues.length, (index) => Place(PlaceValue("", 0), "", false));
    super.initState();
  }

  @override
  void didUpdateWidget(Podium oldWidget) {
    _updatePlaces();
    super.didUpdateWidget(oldWidget);
  }

  _updatePlaces() {
    placeValues = widget.placeValues;
    highlightedValue = placeValues[widget.highlightedIndex];
    max = placeValues.fold(new PlaceValue("", 0),
        (max, placeValue) => placeValue.value > max.value ? placeValue : max);
    if (widget.active) {
      Future.delayed(Duration(milliseconds: 200), () {
        var length = placeValues.length;
        if (this.mounted) {
          setState(() {
            places = List.generate(length, (index) {
              var diff =
                  (placeValues[index].value - highlightedValue.value).round();
              var diffStr = ((index > 0 &&
                          placeValues[index - 1].id == highlightedValue.id) ||
                      (index < placeValues.length - 1 &&
                          placeValues[index + 1].id == highlightedValue.id))
                  ? (diff > 0 ? "+$diff" : "$diff")
                  : "";
              if (placeValues[index].id == highlightedValue.id) {
                position = placeValues.length - index;
              }
              return Place(placeValues[index], "$diffStr",
                  placeValues[index].id == highlightedValue.id);
            });
            Future.delayed(Duration(milliseconds: animationDuration + 0), () {
              if (this.mounted) {
                setState(() {
                  showToolTip = true;
                });
              }
            });
            Future.delayed(Duration(milliseconds: animationDuration), () {
              if (this.mounted) {
                setState(() {
                  showPosition = true;
                });
              }
            });
          });
        }
      });
    } else {
      setState(() {
        showToolTip = false;
        showPosition = false;
        position = null;
        places = List.generate(
            placeValues.length, (index) => Place(PlaceValue("", 0), "", false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -10,
          left: 6,
          child: position != null && placeValues != null
              ? AnimatedOpacity(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  opacity: showPosition ? 1.0 : 0.0,
                  child: Text(
                    "$position",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 108,
                      fontWeight: FontWeight.w500,
                      color: _getColor(placeValues.length - position, context)
                          .tiny(5)
                          .withAlpha(70),
                    ),
                  ),
                )
              : Text(""),
        ),
        Positioned(
          top: 10,
          left: position == 1
              ? 57
              : (position == 4 || position == 6
                  ? 65
                  : (position == 7 ? 74 : 70)),
          child: position != null && placeValues != null
              ? AnimatedOpacity(
                  duration: Duration(milliseconds: 2000),
                  curve: Curves.easeInOut,
                  opacity: showPosition ? 1.0 : 0.0,
                  child: Text(
                    position == 1 ? "er" : "ème",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getColor(placeValues.length - position, context)
                          .withAlpha(200),
                    ),
                  ),
                )
              : Text(""),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 38.0, bottom: 0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(child: _buildBarChart(context)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(widget.title,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildBarChart(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: max.value,
        alignment: BarChartAlignment.center,
        gridData: FlGridData(show: false),
        axisTitleData: FlAxisTitleData(show: false),
        groupsSpace: 6,
        barGroups: [
          ...places.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: entry.value.placeValue.value,
                  width: 9,
                  color: entry.value.highlight
                      ? _getColor(entry.key, context)
                      : Theme.of(context).cardTheme.color.tiny(10),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: false,
                    y: max.value,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
              showingTooltipIndicators: [0],
            );
          }),
        ],
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipBottomMargin: 0,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                showToolTip ? places[groupIndex].tooltip : "",
                TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontSize: 10,
                    fontFamily: "Raleway"),
              );
            },
          ),
        ),
      ),
      swapAnimationDuration: Duration(milliseconds: animationDuration),
    );
  }

  Color _getColor(int placeIndex, BuildContext context) {
    var podiumLength = placeValues.length;
    if (placeIndex >= podiumLength - widget.promoted)
      return Colors.lightGreenAccent;
    if (placeIndex <= widget.relegated) return Colors.deepOrangeAccent;
    return Colors.blueAccent;
  }
}
