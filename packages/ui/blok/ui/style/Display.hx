package blok.ui.style;

import blok.style.Style;
import blok.style.VStyle;

enum abstract DisplayKind(String) to String {
  var Block = 'block';
  var Inline = 'inline';
  var Table = 'table';
  var Flex = 'flex';
  var Grid = 'grid';
  var Inherit = 'inherit';
  var Initial = 'initial';
  var Unset = 'unset';
  var None = 'none';
  // var Flow = 'flow';
  // var FlowRoot = 'flow-root';
}

class Display extends Style {
  @prop var kind:DisplayKind;

  override function render():Array<VStyleExpr> {
    return [
      Style.property('display', kind)
    ];
  }
}
