package noted.ui.style;

using Blok;

class Layout extends Style {
  override function render():StyleExpr {
    return Css.export({
      display: 'flex',
      'flex-direction': 'row'
    });
  }
}
