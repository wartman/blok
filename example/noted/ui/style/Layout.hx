package noted.ui.style;

using Blok;

class Layout extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Style.property('display', 'flex'),
      Style.property('flex-direction', 'row')
    ];
  }
}
