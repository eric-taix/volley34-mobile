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

  Podium(this.placeValues, {this.title = "", this.active = true, this.highlightedIndex});

  @override
  _PodiumState createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  List<Place> places;
  PlaceValue max;
  List<PlaceValue> sortedValues;
  PlaceValue highlightedValue;
  bool showToolTip = false;
  int animationDuration = 400;

  @override
  void initState() {
    highlightedValue = widget.placeValues[widget.highlightedIndex];
    sortedValues = widget.placeValues..sort((pv1, pv2) => pv1.value.compareTo(pv2.value));
    places = List.generate(sortedValues.length, (index) => Place(PlaceValue("", 0), "", false));
    _updatePlaces();
    super.initState();
  }


  @override
  void didUpdateWidget(Podium oldWidget) {
    _updatePlaces();
    super.didUpdateWidget(oldWidget);
  }

  _updatePlaces() {
    max = sortedValues.fold(new PlaceValue("", 0), (max, placeValue) => placeValue.value > max.value ? placeValue : max);
    if (widget.active) {
      Future.delayed(Duration(milliseconds: 200), () {
        var length = sortedValues.length;
        setState(() {
          places = List.generate(length, (index) {
            var idx = (index < length / 2) ? index * 2 : length - (length - (index * 2) - 1).abs();
            idx = index;
            var diff = (sortedValues[idx].value - highlightedValue.value).round();
            var diffStr = //sortedValues[idx].id != highlightedValue.id &&
            ((idx > 0 && sortedValues[idx - 1].id == highlightedValue.id) ||
                (idx < sortedValues.length - 1 && sortedValues[idx + 1].id == highlightedValue.id))
                ? (diff > 0 ? "+$diff" : diff)
                : "";
            return Place(sortedValues[idx], "$diffStr", sortedValues[idx].id == highlightedValue.id);
          });
          Future.delayed(Duration(milliseconds: animationDuration + 800), () {
            setState(() {
              showToolTip = true;
            });
          });
        });
      });
    } else {
      setState(() {
        showToolTip = false;
        places = List.generate(sortedValues.length, (index) => Place(PlaceValue("", 0), "", false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child: _buildBarChart(context)),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(widget.title),
          ),
        ],
      ),
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
          ...places
              .asMap()
              .entries
              .map((entry) {
            return BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: entry.value.placeValue.value,
                  width: 9,
                  color: entry.value.highlight ? _getColor(entry.key, places.length, context) : Theme
                      .of(context)
                      .cardTheme
                      .color
                      .tiny(10),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: false,
                    y: max.value,
                    color: Theme
                        .of(context)
                        .primaryColor,
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
            tooltipBottomMargin: 4,
            getTooltipItem: (BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,) {
              return BarTooltipItem(
                showToolTip ? places[groupIndex].tooltip : "",
                TextStyle(color: Colors.white, fontSize: 10, fontFamily: "Raleway"),
              );
            },
          ),
        ),
      ),
      swapAnimationDuration: Duration(milliseconds: animationDuration),
    );
  }

  Color _getColor(int placeIndex, int podiumLength, BuildContext context) {
    if (placeIndex == podiumLength - 1) return Colors.green;
    if (placeIndex == podiumLength - 2) return Colors.greenAccent;
    if (placeIndex == podiumLength - 3) return Colors.lightGreenAccent;
    if (placeIndex == 2) return Colors.orangeAccent;
    if (placeIndex == 1) return Colors.deepOrangeAccent;
    if (placeIndex == 0) return Colors.redAccent;
    return Colors.blueAccent;
  }
}
