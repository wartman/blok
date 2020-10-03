package noted.ui;

import noted.ui.style.*;
import noted.data.Store;
import noted.data.Id;
import noted.data.Tag;

using Blok;

enum NoteFilterControlsMode {
  All;
  ByTag;
}

class NoteFilterControls extends Component {
  @prop var mode:NoteFilterControlsMode = All;
  
  @update
  function setMode(mode:NoteFilterControlsMode) {
    if (this.mode.equals(mode)) return None;
    return UpdateState({ mode: mode });
  }

  override function render(context:Context) {
    return Html.div({
      style: [
        Card.style({}),
        List.style()
      ],
      children: [
        ButtonGroup.node({
          buttons: [
            Button.node({
              type: Normal,
              onClick: _ -> {
                setMode(All);
                Store.from(context).setFilter(FilterAll);
              },
              child: Html.text('All Notes')
            }),
            Button.node({
              type: Normal,
              onClick: _ -> {
                setMode(ByTag);
                Store.from(context).setFilter(None);
              },
              child: Html.text('Filter by Tag')
            })
          ]
        }),
        switch mode {
          case All: null;
          case ByTag: Html.div({
            children: [
              NoteTags.node({
                tags: switch Store.from(context).filter {
                  case FilterByTags(tags): 
                    var store =  Store.from(context);
                    tags.map(id -> switch store.getTag(id) {
                      case Some(v): v;
                      case None: ({
                        id: Id.invalid(),
                        name: 'Not Found',
                        notes: []
                      }:Tag);
                    });
                  default: [];
                },
                addTag: name -> {
                  var store = Store.from(context);
                  switch store.findTagByName(name) {
                    case None: 
                      store.setFilter(switch store.filter {
                        case FilterByTags(tags): 
                          FilterByTags(tags.concat([ Id.invalid() ]));
                        default: 
                          FilterByTags([ Id.invalid() ]);
                      });
                    case Some(tag):
                      store.setFilter(switch store.filter {
                        case FilterByTags(tags): 
                          if (tags.contains(tag.id)) store.filter;
                          else FilterByTags(tags.concat([ tag.id ]));
                        default: FilterByTags([ tag.id ]);
                      });
                  }
                },
                removeTag: id -> Store
                  .from(context)
                  .setFilter(switch Store.from(context).filter {
                    case FilterByTags(tags):
                      FilterByTags(tags.filter(tag -> tag != id));
                    default: 
                      FilterByTags([]);
                  })
              })
            ]
          });
        }
      ]
    });
  }
}