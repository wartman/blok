package noted.ui.style;

using Blok;

enum AlignmentPosition {
  End;
  Start;
}

class Alignment extends Style {
  public inline static function end() {
    return Alignment.style({ position: End });
  }

  public inline static function start() {
    return Alignment.style({ position: Start });
  }

  @prop var position:AlignmentPosition;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('margin-left', switch position {
        case End: 'auto';
        case Start: '0';
      })
    ];
  }
}
