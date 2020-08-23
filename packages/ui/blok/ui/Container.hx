package blok.ui;

import blok.core.StyleList;

/**
  A simple, cross-platform container.
**/
class Container extends Component {
  @prop var style:StyleList = null;
  @prop var children:Children = null;

  // todo: handle some simple style stuff in here?
  
  override function render(context:Context):VNode {
    return context.engine.createContainer({
      style: style,
      children: children
    });
  }
}
