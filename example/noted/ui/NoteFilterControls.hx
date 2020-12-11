package noted.ui;

import blok.core.foundation.style.*;
import noted.ui.tag.TagList;
import noted.ui.style.*;
import noted.data.*;

using Blok;

class NoteFilterControls extends Component {
  override function render(context:Context) {
    return Html.div({
      style: [
        Card.style({}),
        List.style()
      ],
      children: [
        Html.header({
          children: [
            Html.h1({
              style: Font.style({ size: Em(3), color: Config.accentColor }),
              children: [ Html.text('noted') ]
            })
          ]
        }), 
        ButtonGroup.node({
          perRow: 4,
          perRowMobile: 2,
          style: switch Store.from(context).filter {
            case FilterAll: null;
            default: LineBreak.style({ spacing: None });
          },
          buttons: [
            Button.node({
              type: Important,
              onClick: _ -> Store.from(context).toggleEditor(true),
              child: Html.text('Add Note')
            }),
            Button.node({
              type: switch Store.from(context).filter {
                case FilterAll: Selected;
                default: Normal;
              },
              onClick: _ -> Store.from(context).setFilter(FilterAll),
              child: Html.text('All Notes')
            }),
            Button.node({
              type: switch Store.from(context).filter {
                case FilterByTags(_): Selected;
                default: Normal;
              },
              onClick: _ -> Store.from(context).setFilter(FilterByTags([])),
              child: Html.text('Filter by Tag')
            }),
            Button.node({
              type: switch Store.from(context).filter {
                case FilterByStatus(_): Selected;
                default: Normal;
              },
              onClick: _ -> Store.from(context).setFilter(FilterByStatus(Published)),
              child: Html.text('Filter by Status')
            })
          ]
        }),

        Store.select(context, store -> store.showEditor, editing -> if (editing)
          Modal.node({
            title: 'Create Note',
            requestClose: () -> Store.from(context).toggleEditor(false),
            child: NoteEditor.node({
              note: Note.empty(),
              tags: [],
              onSave: note -> {
                Store
                  .from(context)
                  .addNote(note.name, note.content, note.tags, note.status);
              },
              requestClose: () -> Store.from(context).toggleEditor(false)
            }) 
          }) 
        else null),

        switch Store.from(context).filter {
          case FilterAll | None: null;
          case FilterByTags(_):
            var store = Store.from(context);
            Html.div({
              children: [
                TagList.node({
                  showError: true,
                  tags: switch store.filter {
                    case FilterByTags(tags):
                      tags.map(id -> switch store.getTag(id) {
                        case Some(v): v;
                        case None: new Tag({
                          id: Id.invalid(),
                          name: 'Not Found',
                          notes: []
                        });
                      });
                    default: [];
                  },
                  addTag: name -> {
                    switch store.findTagByName(name) {
                      case None:
                        store.addTagToFilter(name);
                      case Some(tag):
                        store.setFilter(switch store.filter {
                          case FilterByTags(tags): 
                            if (tags.contains(tag.id)) store.filter;
                            else FilterByTags(tags.concat([ tag.id ]));
                          default: FilterByTags([ tag.id ]);
                        });
                    }
                  },
                  removeTag: id -> store.setFilter(switch store.filter {
                    case FilterByTags(tags):
                      FilterByTags(tags.filter(tag -> tag != id));
                    default: 
                      FilterByTags([]);
                  }),
                  requestSearch: null
                })
              ]
            });
          case FilterByStatus(_):
            var store = Store.from(context);
            Html.div({
              children: [
                ButtonGroup.node({
                  buttons: [
                    Button.node({
                      type: switch store.filter {
                        case FilterByStatus(status) if (status.equals(Published)): Selected;
                        default: Normal; 
                      },
                      onClick: _ -> store.setFilter(FilterByStatus(Published)),
                      child: Html.text('Published')
                    }),
                    Button.node({
                      type: switch store.filter {
                        case FilterByStatus(status) if (status.equals(Draft)): Selected;
                        default: Normal; 
                      },
                      onClick: _ -> store.setFilter(FilterByStatus(Draft)),
                      child: Html.text('Drafts')
                    }),
                    Button.node({
                      type: switch store.filter {
                        case FilterByStatus(status) if (status.equals(Trashed)): Selected;
                        default: Normal; 
                      },
                      onClick: _ -> store.setFilter(FilterByStatus(Trashed)),
                      child: Html.text('Trashed')
                    })
                  ]
                })
              ]
            });
        }
      ]
    });
  }
}
