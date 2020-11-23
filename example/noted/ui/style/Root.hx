package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Root extends Style {
  override function render():StyleExpr {
    return Css.properties([
      Box.export({ width: Pct(100) }),

      Css.global([
        Css.child('#root', [
          MediaQuery.minWidth(Config.mobileWidth, [
            Box.export({
              width: Config.mobileWidth,
              padding: EdgeInsets.symmetric(Config.smallGap, None)
            }),
          ]),
          MediaQuery.maxWidth(Config.mobileWidth, [
            Box.export({
              width: Pct(100),
              padding: EdgeInsets.all(Config.smallGap)
            })
          ])
        ]),

        Css.child('h1, h2, h3', [
          Font.export({ 
            size: Em(1),
            weight: Bold 
          }),
          Css.property('padding', None),
          Css.property('margin', None)
        ]),

        Css.child('body', [
          Flex.horizontallyCentered(),
          Font.export({
            family: 'sans-serif',
            size: Em(.8),
            color: Config.darkColor
          }),
          Css.property('background-color', Config.lightColor),
          Css.property('margin', EdgeInsets.all(None)),
          Css.property('padding', EdgeInsets.all(None))
        ]),

        Css.child('textarea, input', [
          Css.property('font', 'inherit')
        ]),

        Css.child('textarea, input, button', [
          Css.modifier(':focus', [
            Css.property('outline', 'none')
          ])
        ]),

        Css.raw('
          body, html {
            padding: 0;
            margin: 0;
          }
          
          html {
            box-sizing: border-box;
          }
          
          *, *:before, *:after {
            box-sizing: inherit;
          }
          
          ul, ol, li {
            margin: 0;
            padding: 0;
          }
          
          ul, ol {
            list-style: none;
          }
        ')
      ])
    ]);
  }
}
