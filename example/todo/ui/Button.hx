package todo.ui;

import blok.html.HtmlEvents;
import blok.style.*;

using Blok;

class Button extends Component {
  
  @prop var label:String;
  @prop var action:(event:Event)->Void;

  override function render(context:Context):VNode {
    return Html.button({
      style: [
        Box.style({ 
          height: Px(30), 
          padding: EdgeInsets.symmetric(None, Px(20)) 
        }),
        Border.style({ radius: Px(15) }),
        Background.style({ color: Color.name('red') })
      ],
      attrs: {
        onclick: action
      },
      children: [ Html.text(label) ]
    });
  }

}
