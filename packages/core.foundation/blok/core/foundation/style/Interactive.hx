package blok.core.foundation.style;

import blok.core.html.Css;
import blok.core.style.Style;
import blok.core.style.StyleExpr;

enum abstract CursorType(String) to String {
  var None = 'none';
  var Auto = 'auto';
  var Pointer = 'pointer';
  var Default = 'default';
  var ContextMenu = 'context-menu';
  var Help = 'help';
  var Progress = 'progress';
  var Wait = 'wait';
  var Cell = 'cell';
  var Crosshair = 'crosshair';
  var Text = 'text';
  var VerticalText = 'vertical-text';
  var Alias = 'alias';
  var Copy = 'copy';
  var Move = 'move';
  var NoDrop = 'no-drop';
  var NotAllowed = 'not-allowed';
  var Grab = 'grab';
  var Grabbing = 'grabbing';
  var AllScroll = 'all-scroll';
  var ColResize = 'col-resize';
  var RowResize = 'row-resize';
  var NResize = 'n-resize';
  var EResize = 'e-resize';
  var SResize = 's-resize';
  var WResize = 'w-resize';
  var NEResize = 'ne-resize';
  var NWResize = 'nw-resize';
  var SEResize = 'se-resize';
  var SWResize = 'sw-resize';
  var EWResize = 'ew-resize';
  var NSResize = 'ns-resize';
  var NESWResize = 'nesw-resize';
  var NWSEResize = 'nwse-resize';
  var ZoomIn = 'zoom-in';
  var ZoomOut = 'zoom-out';
}

class Interactive extends Style {
  @prop var cursor:CursorType;

  override function render():StyleExpr {
    return Css.property('cursor', cursor);
  }
}