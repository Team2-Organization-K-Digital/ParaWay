class ConfusionPred {
  final int on;
  final int off;
  final double oconfusion;
  final double fconfusion;

  ConfusionPred({
    required this.on,
    required this.off,
    required this.oconfusion,
    required this.fconfusion,
  });

  factory ConfusionPred.fromJSON(Map<String, dynamic> json) {
    return ConfusionPred(
      on: json['on'],
      off: json['off'],
      oconfusion: json['oconfusion'],
      fconfusion: json['fconfusion'],
    );
  }
}
// {'on':int(opeople),'off':int(fpeople),'oconfusion':round(float((oconfusion)),2),'fconfusion':round(float((fconfusion)),2)}