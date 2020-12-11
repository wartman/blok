package noted.ui.tag;

import blok.core.foundation.style.*;
import noted.ui.style.*;
import noted.data.Id;
import noted.data.Tag;

using Blok;

class TagList extends Component {
  @prop var tags:Array<Tag>;
  @prop var addTag:(name:String)->Void;
  @prop var removeTag:(id:Id<Tag>)->Void;
  @prop var requestSearch:Null<(id:Id<Tag>)->Void>;
  @prop var showError:Bool = false;
  @prop var adding:Bool = false;

  @update
  function stopAdding() {
    return UpdateState({ adding: false });
  }

  @update
  function startAdding() {
    return UpdateState({ adding: true });
  }

  override function render(context:Context) {
    return Html.ul({
      style: BaseGrid.style({}),
      children: [
        for (tag in tags) TagItem.node({
          tag: tag,
          showError: showError,
          requestSearch: requestSearch,
          requestRemove: removeTag
        })
      ].concat([
        Html.li({
          key: 'add-tag',
          children: [
            if (adding) Input.node({
              style: [
                Box.style({ width: Pct(100) }),
              ],
              onSave: value -> {
                addTag(value);
                stopAdding();
              },
              onCancel: stopAdding
            }) else Html.button({
              style: [
                Box.style({ 
                  display: Block,
                  width: Pct(100) 
                }),
                Selectable.style({
                  color: Config.midColor
                }),
                Pill.style({
                  color: Config.midColor,
                  padding: Em(.5),
                  outlined: true
                }),
                Css.define({ cursor: 'pointer' }),
              ],
              attrs: {
                onclick: _ -> startAdding()
              },
              children: [ Html.text('Add Tag') ]
            })
          ]
        })
      ])
    });
  }
}
