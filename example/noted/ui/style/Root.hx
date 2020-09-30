package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Root extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Box.export({ width: Pct(100) }),

      Style.global([
        Style.child('#root', [
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

        Style.child('h1, h2, h3', [
          Font.export({ 
            size: Em(1),
            weight: Bold 
          }),
          Style.property('padding', None),
          Style.property('margin', None)
        ]),

        Style.child('body', [
          Flex.horizontallyCentered(),
          Font.export({
            family: 'sans-serif',
            size: Em(.8),
            color: Config.darkColor
          }),
          Style.property('background-color', Config.lightColor),
          Style.property('margin', EdgeInsets.all(None)),
          Style.property('padding', EdgeInsets.all(None))
        ]),

        Style.child('textarea, input', [
          Style.property('font', 'inherit')
        ]),

        Style.child('textarea, input, button', [
          Style.modifier(':focus', [
            Style.property('outline', 'none')
          ])
        ])
      ])
    ];
  }
}
