package blok.ui.style;

import blok.core.style.Style;
import blok.core.style.StyleExpr;
import blok.core.html.Css;

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

  override function render():StyleExpr {
    return Css.export({
      display: kind
    });
  }
}
