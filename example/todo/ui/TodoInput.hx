package todo.ui;

using Blok;

class TodoInput extends Component {

  @prop var onSave:(value:String)->Void;
  @prop var onEscape:()->Void = null;
  @prop var initialValue:String = '';
  @prop var placeholder:String = '';
  var pendingValue:String;

  override function render(context:Context):VNode {
    // todo: this will be a lot cleaner if we implement
    //       some kind of `ref`
    return Html.input({
      attrs: {
        oninput: e -> {
          trace(e);
          e.preventDefault;
          var input:js.html.InputElement = cast e.target;
          pendingValue = input.value;
        },
        onkeydown: e -> {
          var ev:js.html.KeyboardEvent = cast e;
          if (ev.key == 'Enter') {
            onSave(pendingValue);
            pendingValue = '';
            if (onEscape != null) onEscape();
          } else if (ev.key == 'Escape') {
            pendingValue = '';
            if (onEscape != null) onEscape();
          }
        },
        value: initialValue,
        placeholder: placeholder
      }
    });
  }

}
