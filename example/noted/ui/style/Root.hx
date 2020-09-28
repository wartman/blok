package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Root extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Box.export({
        width: Pct(100)
      }),
      Style.global([
        Style.child('#root', [
          Style.property('width', Pct(100)),
          Flex.horizontallyCentered()
        ]),
        Style.child('h1, h2, h3', [
          Font.export({ size: Em(1), weight: Bold }),
          Style.property('padding', Num(0)),
          Style.property('margin', Num(0))
        ]),
        Style.child('body', [
          Style.property('background-color', Config.lightColor),
          Style.property('margin', EdgeInsets.all(Num(0))),
          Style.property('padding', EdgeInsets.all(Num(0))),
          Font.export({
            family: 'sans-serif',
            size: Em(.8),
            color: Config.darkColor
          })
        ]),
        Style.child('textarea, input', [
          Style.property('font', 'inherit')
        ])
      ])
    ];
  }
}
