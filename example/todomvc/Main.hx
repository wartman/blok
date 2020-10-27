package todomvc;

// This example was taken directly from Elm's TodoMVC example,
// to show how Blok can be similar to the Elm architecture.
//
// https://github.com/evancz/elm-todomvc/blob/master/src/Main.elm
//
// We're also _not_ using the `blok.core.style` package here -- instead,
// we're relying on an exterior css file. This is in part to show that
// Blok's style system is an optional plugin, and in part because it
// was a lot easier not re-implementing all those styles. 
//
// If you want to see how `blok.core.style` works, check the `noted` 
// example in the `example` directory.

import haxe.Json;

using StringTools;
using Lambda;
using Blok;

class Main {
  static function main() {
    Platform.mount(
      js.Browser.document.getElementById('root'),
      ctx -> Root.node({ model: Model.load() })
    );
  }
}

// Most data in Blok should be handled with simple classes
// or typedefs.
typedef Entry = {
  public var id:Int;
  public var description:String;
  public var completed:Bool;
  public var editing:Bool;
}

enum abstract Visibility(String) to String {
  var All;
  var Completed;
  var Active;
}

// A `State` is like a mix of the Model and Updates in the Elm architecture.
//
// Think of each `@update` method as a message in elm.
class Model implements State {
  static inline final BLOK_TODO_MODEL = 'blok-todo-model';

  public static function load():Model {
    var stored = js.Browser.window.localStorage.getItem(BLOK_TODO_MODEL);
    var model = if (stored == null) 
      new Model({
        uid: 0,
        visibility: All,
        entries: []
      })
    else 
      new Model(cast Json.parse(stored));

    model.getObservable().observe(save);
    
    return model;
  }

  static function save(model:Model) {
    js.Browser.window.localStorage.setItem(BLOK_TODO_MODEL, Json.stringify({
      uid: model.uid,
      visibility: model.visibility,
      entries: model.entries
    }));
  }

  @prop var entries:Array<Entry>;
  @prop var field:String = '';
  @prop var uid:Int;
  @prop var visibility:Visibility;

  @update
  public function add() {
    if (field.trim().length == 0) return None;
    return UpdateState({
      field: '',
      uid: uid + 1,
      entries: entries.concat([
        {
          id: uid,
          description: field,
          editing: false,
          completed: false
        }
      ])
    });
  }

  @update
  public function updateField(value:String) {
    return UpdateStateSilent({
      field: value
    });
  }

  @update
  public function editingEntry(id:Int, isEditing:Bool) {
    var entry = entries.find(e -> e.id == id);
    if (entry == null) return None;
    entry.editing = isEditing;
    return Update;
  }

  @update
  public function updateEntry(id:Int, description:String) {
    var entry = entries.find(e -> e.id == id);
    if (entry == null) return None;
    entry.description = description;
    return Update;
  }

  @update
  public function deleteEntry(id:Int) {
    if (!entries.exists(e -> e.id == id)) return None;
    return UpdateState({
      entries: entries.filter(e -> e.id != id)
    });
  }

  @update
  public function deleteCompleted() {
    return UpdateState({
      entries: entries.filter(e -> !e.completed)
    });
  }

  @update
  public function check(id:Int, isCompleted:Bool) {
    var entry = entries.find(e -> e.id == id);
    if (entry == null) return None;
    entry.completed = isCompleted;
    return Update;
  }

  @update
  public function checkAll(isCompleted:Bool) {
    return UpdateState({
      entries: entries.map(e -> {
        e.completed = isCompleted;
        e;
      })
    });
  }

  @update
  public function changeVisibility(visibility:Visibility) {
    if (this.visibility == visibility) return None;
    return UpdateState({
      visibility: visibility
    });
  }
}

class Root extends Component {
  @prop var model:Model;

  override function render(context:Context):VNode {
    return Html.div({
      attrs: {
        className: 'todomvc-wrapper',
        // style: 'visibility: hidden'
      },
      children: [
        Html.section({
          attrs: {
            className: 'todoapp'
          },
          children: [
            Provider.provide([ model ], ctx -> Html.fragment([
              ViewInput.node({ task: Model.from(ctx).field }),
              ViewEntries.node({}),
              ViewControls.node({})
            ]))
          ]
        })
      ]
    });
  }
}

class ViewInput extends Component {
  @prop var task:String;
  var ref:js.html.InputElement;

  override function render(context:Context):VNode {
    return Html.header({
      attrs: {
        className: 'header'
      },
      children: [
        Html.h1({ children: [ Html.text('todos') ] }),
        Html.input({
          ref: el -> ref = cast el,
          attrs: {
            className: 'new-todo',
            placeholder: 'What needs doing?',
            autofocus: true,
            value: task,
            oninput: e -> {
              Model.from(context).updateField(ref.value);
            },
            onkeydown: e -> {
              var ev:js.html.KeyboardEvent = cast e;
              if (ev.key == 'Enter') {
                ref.value = '';
                Model.from(context).add();
              }
            }
          }
        })
      ]
    });
  }
}

class ViewEntries extends Component {
  override function render(context:Context):VNode {
    return Model.observe(context, model -> {
      var allCompleted = model.entries.filter(e -> !e.completed).length == 0;
      var isVisible = (entry:Entry) -> switch model.visibility {
        case Completed: entry.completed;
        case Active: !entry.completed;
        case All: true;
      };

      Html.section({
        attrs: {
          className: 'main',
          style: if (model.entries.length == 0) 'visibility: hidden' else null
        },
        children: [
          Html.input({
            attrs: {
              className: 'toggle-all',
              id: 'toggle-all',
              type: Checkbox,
              name: 'toggle-all',
              checked: allCompleted,
              onclick: _ -> model.checkAll(!allCompleted)
            }
          }),
          Html.label({
            attrs: {
              htmlFor: 'toggle-all'
            },
            children: [ Html.text('Mark all as complete') ]
          }),
          Html.ul({
            attrs: {
              className: 'todo-list'
            },
            children: [ for (entry in model.entries.filter(isVisible)) 
              ViewEntry.node({ entry: entry })
            ]
          })
        ]
      });
    });
  }
}

class ViewEntry extends Component {
  @prop var entry:Entry;
  var ref:js.html.InputElement;

  override function render(context:Context):VNode {
    return Html.li({
      key: entry.id,
      attrs: {
        className: [
          if (entry.completed) 'completed' else null,
          if (entry.editing) 'editing' else null
        ].filter(c -> c != null).join(' ')
      },
      children: [
        Html.div({
          attrs: {
            className: 'view'
          },
          children: [
            Html.input({
              attrs: {
                className: 'toggle',
                type: Checkbox,
                checked: entry.completed,
                onclick: _ -> Model.from(context).check(entry.id, !entry.completed)
              }
            }),
            Html.label({
              attrs: {
                ondblclick: _ -> Model.from(context).editingEntry(entry.id, true)
              },
              children: [ Html.text(entry.description) ]
            }),
            Html.button({
              attrs: {
                className: 'destroy',
                onclick: _ ->  Model.from(context).deleteEntry(entry.id)
              }
            })
          ]
        }),
        Html.input({
          ref: e -> ref = cast e,
          attrs: {
            className: 'edit',
            value: entry.description,
            name: 'title',
            id: 'todo-${entry.id}',
            oninput: _ -> Model.from(context).updateEntry(entry.id, ref.value),
            onblur: _ -> Model.from(context).editingEntry(entry.id, false),
            onkeydown: e -> {
              var ev:js.html.KeyboardEvent = cast e;
              if (ev.key == 'Enter') {
                Model.from(context).editingEntry(entry.id, false);
              }
            }
          }
        })
      ]
    });
  }
}

class ViewControls extends Component {
  override function render(context:Context):VNode {
    return Model.observe(context, model -> {
      var entriesCompleted = model.entries.filter(e -> e.completed).length;
      var entriesLeft = model.entries.length - entriesCompleted;
      return Html.footer({
        attrs: {
          className: 'footer',
          style: if (model.entries.length == 0) 'display: none' else null
        },
        children: [
          Html.span({
            attrs: { className: 'todo-count' },
            children: [
              Html.strong({
                children: [ 
                  Html.text(switch entriesLeft {
                    case 1: '${entriesLeft} item left';
                    default: '${entriesLeft} items left';
                  })
                ]
              })
            ]
          }),
          Html.ul({
            attrs: {
              className: 'filters'
            },
            children: [
              visibilityControl('#/', All, model.visibility, model),
              visibilityControl('#/active', Active, model.visibility, model),
              visibilityControl('#/completed', Completed, model.visibility, model)
            ]
          }),
          Html.button({
            attrs: {
              className: 'clear-completed',
              style: if (entriesCompleted == 0) 'visibility: hidden' else null,
              onclick: _ -> model.deleteCompleted()
            },
            children: [ Html.text('Clear completed (${entriesCompleted})') ]
          })
        ]
      });
    });
  }

  function visibilityControl(
    url:String,
    visibility:Visibility,
    actualVisibility:Visibility,
    model:Model
  ) {
    return Html.li({
      attrs: {
        onclick: _ -> model.changeVisibility(visibility)
      },
      children: [
        Html.a({
          attrs: {
            href: url,
            className: if (visibility == actualVisibility) 'selected' else null
          },
          children: [ Html.text(visibility) ]
        })
      ]
    });
  }
}
