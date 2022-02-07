class Score {
  final List<SetPoint> sets = [SetPoint()];

  int get hostSets =>
      sets.where((set) => set.hostPoint > set.visitorPoint && (set.hostPoint >= 25 || set.visitorPoint >= 25)).length;
  int get visitorSets =>
      sets.where((set) => set.visitorPoint > set.hostPoint && (set.hostPoint >= 25 || set.visitorPoint >= 25)).length;
  int get hostCurrentPoint => sets.last.hostPoint;
  int get visitorCurrentPoint => sets.last.visitorPoint;
}

class SetPoint {
  final int hostPoint;
  final int visitorPoint;

  SetPoint({this.hostPoint = 0, this.visitorPoint = 0});

  operator +(SetPoint set) =>
      SetPoint(hostPoint: hostPoint + set.hostPoint, visitorPoint: visitorPoint + set.visitorPoint);
}
