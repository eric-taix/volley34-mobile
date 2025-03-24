import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:v34/utils/extensions.dart';

class Place {
  final PlaceValue placeValue;
  final String tooltip;
  final bool highlight;
  Place(this.placeValue, this.tooltip, this.highlight);
}

class PlaceValue {
  final String? id;
  final double value;
  final int rank;

  PlaceValue(this.id, this.value, this.rank);

  @override
  String toString() {
    return 'PlaceValue{id: $id, value: $value, rank: $rank}';
  }
}

class Podium extends StatefulWidget {
  final String title;
  final List<PlaceValue> placeValues;
  final bool active;
  final int? highlightedIndex;
  final int? promoted;
  final int? relegated;
  final Widget? trailing;
  final bool showPromotedRelegated;

  Podium(
    this.placeValues, {
    this.title = "",
    this.active = true,
    this.highlightedIndex,
    this.promoted = 0,
    this.relegated = 0,
    this.trailing,
    this.showPromotedRelegated = true,
  });

  @override
  _PodiumState createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  late List<Place> places;
  late PlaceValue max;
  List<PlaceValue>? placeValues;
  late PlaceValue? highlightedValue;
  bool showToolTip = false;
  bool showPosition = false;
  int animationDuration = 200;
  int? position;

  @override
  void initState() {
    _updatePlaces();
    places = List.generate(placeValues!.length, (index) => Place(PlaceValue("", 0, -1), "", false));
    super.initState();
  }

  @override
  void didUpdateWidget(Podium oldWidget) {
    _updatePlaces();
    super.didUpdateWidget(oldWidget);
  }

  _updatePlaces() {
    placeValues = widget.placeValues
        .map((placeValue) => PlaceValue(placeValue.id, placeValue.value + 1, placeValue.rank))
        .toList();
    if (widget.highlightedIndex != -1) {
      highlightedValue = placeValues![widget.highlightedIndex!];
    } else {
      highlightedValue = null;
    }
    max = placeValues!
        .fold(new PlaceValue("", 0, -1), (max, placeValue) => placeValue.value > max.value ? placeValue : max);
    if (widget.active) {
      Future.delayed(Duration(milliseconds: 200), () {
        var length = placeValues!.length;
        if (this.mounted) {
          setState(() {
            places = List.generate(length, (index) {
              var diffStr = "";
              if (highlightedValue != null) {
                var diff = (placeValues![index].value - highlightedValue!.value).round();
                diffStr = ((index > 0 && placeValues![index - 1].id == highlightedValue!.id) ||
                        (index < placeValues!.length - 1 && placeValues![index + 1].id == highlightedValue!.id))
                    ? (diff > 0 ? "+$diff" : "$diff")
                    : "";
                if (placeValues![index].id == highlightedValue!.id) {
                  position = placeValues!.length - index;
                }
              }
              return Place(placeValues![index], "$diffStr",
                  highlightedValue != null && placeValues![index].id == highlightedValue!.id);
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
        places = List.generate(placeValues!.length, (index) => Place(PlaceValue("", 0, -1), "", false));
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
                      color: _getColor(placeValues!.length - position!, context),
                    ),
                  ),
                )
              : Text(""),
        ),
        Positioned(
          top: 10,
          left: position == 1 ? 57 : (position == 4 || position == 6 ? 65 : (position == 7 ? 74 : 70)),
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
                      color: _getColor(placeValues!.length - position!, context).withAlpha(200),
                    ),
                  ),
                )
              : Text(""),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 18.0, bottom: 0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: _buildBarChart(context)),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                  if (widget.trailing != null)
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [widget.trailing!]),
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
        titlesData: FlTitlesData(
          show: false,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        groupsSpace: 6,
        barGroups: [
          ...places.asMap().entries.map((entry) {
            var value = entry.value.placeValue.value;
            if (value < -5) value = -5;
            return BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 9,
                  color: entry.value.highlight
                      ? _getColor(entry.key, context)
                      : Theme.of(context).cardTheme.color!.tiny(10),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: false,
                    toY: max.value,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                ),
              ],
              showingTooltipIndicators: widget.showPromotedRelegated ? [0] : [],
            );
          }),
        ],
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipMargin: 0,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                showToolTip ? places[groupIndex].tooltip : "",
                TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: 10,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
      duration: Duration(milliseconds: animationDuration),
    );
  }

  Color _getColor(int placeIndex, BuildContext context) {
    var podiumLength = placeValues!.length;
    if (!widget.showPromotedRelegated) return Colors.blueAccent;
    if (placeIndex >= podiumLength - widget.promoted!) return Colors.green;
    if (placeIndex <= widget.relegated!) return Colors.deepOrangeAccent;
    return Colors.blueAccent;
  }
}
