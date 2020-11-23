package blok.ui.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;

enum abstract FlexDirection(String) to String {
  var Column = 'column';
  var Row = 'row';
}

enum abstract FlexWrap(String) to String {
  var Wrap = 'wrap';
  var WrapReverse = 'wrap-reverse';
  var Inherit = 'inherit';
  var Initial = 'initial';
  var Unset = 'unset';
}

enum abstract FlexContentDistribution(String) to String {
  var SpaceBetween = 'space-between';
  var SpaceAround = 'space-around';
  var SpaceEvenly = 'space-evenly';
  var Stretch = 'stretch';
}

enum abstract FlexOverflowPosition(String) to String {
  var Safe = 'safe';
  var Unsafe = 'unsafe';
}

enum abstract FlexContentPosition(String) to String {
  var Center = 'center';
  var Start = 'start';
  var End = 'end';
  var FlexStart = 'flex-start';
  var FlexEnd = 'flex-end';
}

enum FlexJustifyContent {
  Normal;
  Inherit;
  Initial;
  Unset;
  Distribute(distribution:FlexContentDistribution);
  Content(position:FlexContentPosition, ?overflow:FlexOverflowPosition);
  Left(content:FlexContentPosition);
  Right(content:FlexContentPosition);
}

enum abstract FlexFirstOrLast(String) to String {
  var First = 'first';
  var Last = 'last';
}

enum abstract FlexSelfPosition(String) to String {
  var Center = 'center';
  var Start = 'start';
  var End = 'end';
  var SelfStart = 'self-start';
  var SelfEnd = 'self-end';
  var FlexStart = 'flex-start';
  var FlexEnd = 'flex-end';
}

enum FlexAlignItems {
  Normal;
  Stretch;
  Baseline(?pos:FlexFirstOrLast);
  Position(pos:FlexSelfPosition, ?overflow:FlexOverflowPosition);
}

/**
  Generates rules for CSS flexbox layouts.
**/
class Flex extends Style {
  public inline static function centered() {
    return Flex.export({
      direction: Row,
      justifyContent: Content(Center),
      alignItems: Position(Center)
    });
  }

  public inline static function horizontallyCentered() {
    return Flex.export({
      direction: Row,
      justifyContent: Content(Center)
    });
  }

  public inline static function verticallyCentered() {
    return Flex.export({
      direction: Column,
      justifyContent: Content(Center)
    });
  } 

  @prop var direction:FlexDirection;
  @prop var wrap:FlexWrap = null;
  @prop var justifyContent:FlexJustifyContent = null;
  @prop var alignItems:FlexAlignItems = null;

  override function render():StyleExpr {
    var styles:Array<StyleExpr> = [
      Css.property('display', 'flex'),
      Css.property('flex-direction', direction)
    ];

    if (wrap != null) styles.push(Css.property('flex-wrap', wrap));
    if (justifyContent != null) styles.push(Css.property('justify-content', switch justifyContent {
      case Normal: 'normal';
      case Inherit: 'inherit';
      case Initial: 'initial';
      case Unset: 'unset';
      case Distribute(distribution): distribution;
      case Content(position, overflow): if (overflow != null)
        '${overflow} ${position}'
      else
        position;
      case Left(content): 'left ${content}';
      case Right(content): 'right ${content}';
    }));
    if (alignItems != null) styles.push(Css.property('align-items', switch alignItems {
      case Normal: 'normal';
      case Stretch: 'stretch';
      case Baseline(pos) if (pos == null): 'baseline';
      case Baseline(pos): '${pos} baseline';
      case Position(pos, overflow) if (overflow == null): pos;
      case Position(pos, overflow): '$overflow $pos'; 
    }));

    return Css.properties(styles);
  }
}