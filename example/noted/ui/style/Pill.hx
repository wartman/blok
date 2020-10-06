package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Pill extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var outlined:Bool = false;
  @prop var centered:Bool = true;
  @prop var padding:Unit = Em(.5);

  override function render():Array<VStyleExpr> {
    var radius = switch padding {
      case Em(value): Em(1 + value);
      default: Em(1); 
    }
    return [
      if (outlined) Style.properties([
        Background.export({
          color: Color.name('transparent')
        }),
        Border.export({
          radius: radius,
          width: Px(1),
          type: Solid,
          color: color
        }),
        Style.property('color', color)
      ]) else Style.properties([
        AutoColor.export({ color: color }),
        Border.export({ 
          type: None,
          width: Px(0),
          radius: radius 
        })
      ]),
      Font.export({
        size: Em(1),
        lineHeight: Em(2),
        align: centered ? Center : null
      }),
      Box.export({
        height: switch padding {
          case Em(value): Em((value * 2) + 2);
          default: Em(2);
        },
        padding: switch padding {
          case None: EdgeInsets.symmetric(None, Em(1));
          default: EdgeInsets.symmetric(padding, switch padding {
            case Em(value): Em(value * 2);
            default: padding;
          });
        }
      })
    ];
  }
}