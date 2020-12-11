package noted.ui.style;

import blok.core.foundation.style.*;

using Blok;

class Pill extends Style {
  @prop var color:Color = Config.lightColor;
  @prop var outlined:Bool = false;
  @prop var centered:Bool = true;
  @prop var padding:CssUnit = Em(.5);

  override function render():StyleExpr {
    var radius = switch padding {
      case Em(value): Em(1 + value);
      default: Em(1); 
    }
    return Css.properties([
      if (outlined) Box.export({
        backgroundColor: Color.name('transparent'),
        borderRadius: radius,
        borderWidth: Px(1),
        borderStyle: Solid,
        borderColor: color,
        contentColor: color
      }) else Css.properties([
        AutoColor.export({ color: color }),
        Box.export({ 
          borderStyle: None,
          borderWidth: Px(0),
          borderRadius: radius 
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
    ]);
  }
}