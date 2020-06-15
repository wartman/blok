package blok.core;

class IsolateComponent extends Component {
  
  @prop var children:Array<VNode>;

  override function render(context:Context):VNode {
    return VFragment(children);
  }

}
