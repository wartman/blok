package todomvc;

// This example was taken directly from Elm's TodoMVC example,
// to show how Blok can be similar to the Elm architecture.
//
// https://github.com/evancz/elm-todomvc/blob/master/src/Main.elm

import haxe.Json;

using StringTools;
using Lambda;
using Blok;

class Main {
  static function main() {
    Platform.mountNoBaseStyle(
      js.Browser.document.getElementById('root'),
      ctx -> Root.node({
        model: Model.load()
      })
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
      style: TodoMvcStyle.style(),
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
      function isVisible(entry:Entry) {
        return switch model.visibility {
          case Completed: entry.completed;
          case Active: !entry.completed;
          case All: true;
        }
      }

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

// This is not a good way to use Blok's style system, but it's easy
// for this example.
class TodoMvcStyle extends Style {
  override function render():Array<VStyleExpr> {
    return [
      Style.global([
        Style.raw("
          html,
          body {
            margin: 0;
            padding: 0;
          }
          
          button {
            margin: 0;
            padding: 0;
            border: 0;
            background: none;
            font-size: 100%;
            vertical-align: baseline;
            font-family: inherit;
            font-weight: inherit;
            color: inherit;
            -webkit-appearance: none;
            appearance: none;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
          }
          
          body {
            font: 14px 'Helvetica Neue', Helvetica, Arial, sans-serif;
            line-height: 1.4em;
            background: #f5f5f5;
            color: #111111;
            min-width: 230px;
            max-width: 550px;
            margin: 0 auto;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
            font-weight: 300;
          }
          
          :focus {
            outline: 0;
          }
          
          .hidden {
            display: none;
          }
          
          .todoapp {
            background: #fff;
            margin: 130px 0 40px 0;
            position: relative;
            box-shadow: 0 2px 4px 0 rgba(0, 0, 0, 0.2),
                        0 25px 50px 0 rgba(0, 0, 0, 0.1);
          }
          
          .todoapp input::-webkit-input-placeholder {
            font-style: italic;
            font-weight: 300;
            color: rgba(0, 0, 0, 0.4);
          }
          
          .todoapp input::-moz-placeholder {
            font-style: italic;
            font-weight: 300;
            color: rgba(0, 0, 0, 0.4);
          }
          
          .todoapp input::input-placeholder {
            font-style: italic;
            font-weight: 300;
            color: rgba(0, 0, 0, 0.4);
          }
          
          .todoapp h1 {
            position: absolute;
            top: -140px;
            width: 100%;
            font-size: 80px;
            font-weight: 200;
            text-align: center;
            color: #b83f45;
            -webkit-text-rendering: optimizeLegibility;
            -moz-text-rendering: optimizeLegibility;
            text-rendering: optimizeLegibility;
          }
          
          .new-todo,
          .edit {
            position: relative;
            margin: 0;
            width: 100%;
            font-size: 24px;
            font-family: inherit;
            font-weight: inherit;
            line-height: 1.4em;
            color: inherit;
            padding: 6px;
            border: 1px solid #999;
            box-shadow: inset 0 -1px 5px 0 rgba(0, 0, 0, 0.2);
            box-sizing: border-box;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
          }
          
          .new-todo {
            padding: 16px 16px 16px 60px;
            border: none;
            background: rgba(0, 0, 0, 0.003);
            box-shadow: inset 0 -2px 1px rgba(0,0,0,0.03);
          }
          
          .main {
            position: relative;
            z-index: 2;
            border-top: 1px solid #e6e6e6;
          }
          
          .toggle-all {
            width: 1px;
            height: 1px;
            border: none; /* Mobile Safari */
            opacity: 0;
            position: absolute;
            right: 100%;
            bottom: 100%;
          }
          
          .toggle-all + label {
            width: 60px;
            height: 34px;
            font-size: 0;
            position: absolute;
            top: -52px;
            left: -13px;
            -webkit-transform: rotate(90deg);
            transform: rotate(90deg);
          }
          
          .toggle-all + label:before {
            content: '❯';
            font-size: 22px;
            color: #e6e6e6;
            padding: 10px 27px 10px 27px;
          }
          
          .toggle-all:checked + label:before {
            color: #737373;
          }
          
          .todo-list {
            margin: 0;
            padding: 0;
            list-style: none;
          }
          
          .todo-list li {
            position: relative;
            font-size: 24px;
            border-bottom: 1px solid #ededed;
          }
          
          .todo-list li:last-child {
            border-bottom: none;
          }
          
          .todo-list li.editing {
            border-bottom: none;
            padding: 0;
          }
          
          .todo-list li.editing .edit {
            display: block;
            width: calc(100% - 43px);
            padding: 12px 16px;
            margin: 0 0 0 43px;
          }
          
          .todo-list li.editing .view {
            display: none;
          }
          
          .todo-list li .toggle {
            text-align: center;
            width: 40px;
            /* auto, since non-WebKit browsers doesn't support input styling */
            height: auto;
            position: absolute;
            top: 0;
            bottom: 0;
            margin: auto 0;
            border: none; /* Mobile Safari */
            -webkit-appearance: none;
            appearance: none;
          }
          
          .todo-list li .toggle {
            opacity: 0;
          }
          
          .todo-list li .toggle + label {
            /*
              Firefox requires `#` to be escaped - https://bugzilla.mozilla.org/show_bug.cgi?id=922433
              IE and Edge requires *everything* to be escaped to render, so we do that instead of just the `#` - https://developer.microsoft.com/en-us/microsoft-edge/platform/issues/7157459/
            */
            background-image: url('data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20width%3D%2240%22%20height%3D%2240%22%20viewBox%3D%22-10%20-18%20100%20135%22%3E%3Ccircle%20cx%3D%2250%22%20cy%3D%2250%22%20r%3D%2250%22%20fill%3D%22none%22%20stroke%3D%22%23ededed%22%20stroke-width%3D%223%22/%3E%3C/svg%3E');
            background-repeat: no-repeat;
            background-position: center left;
          }
          
          .todo-list li .toggle:checked + label {
            background-image: url('data:image/svg+xml;utf8,%3Csvg%20xmlns%3D%22http%3A//www.w3.org/2000/svg%22%20width%3D%2240%22%20height%3D%2240%22%20viewBox%3D%22-10%20-18%20100%20135%22%3E%3Ccircle%20cx%3D%2250%22%20cy%3D%2250%22%20r%3D%2250%22%20fill%3D%22none%22%20stroke%3D%22%23bddad5%22%20stroke-width%3D%223%22/%3E%3Cpath%20fill%3D%22%235dc2af%22%20d%3D%22M72%2025L42%2071%2027%2056l-4%204%2020%2020%2034-52z%22/%3E%3C/svg%3E');
          }
          
          .todo-list li label {
            word-break: break-all;
            padding: 15px 15px 15px 60px;
            display: block;
            line-height: 1.2;
            transition: color 0.4s;
            font-weight: 400;
            color: #4d4d4d;
          }
          
          .todo-list li.completed label {
            color: #cdcdcd;
            text-decoration: line-through;
          }
          
          .todo-list li .destroy {
            display: none;
            position: absolute;
            top: 0;
            right: 10px;
            bottom: 0;
            width: 40px;
            height: 40px;
            margin: auto 0;
            font-size: 30px;
            color: #cc9a9a;
            margin-bottom: 11px;
            transition: color 0.2s ease-out;
          }
          
          .todo-list li .destroy:hover {
            color: #af5b5e;
          }
          
          .todo-list li .destroy:after {
            content: '×';
          }
          
          .todo-list li:hover .destroy {
            display: block;
          }
          
          .todo-list li .edit {
            display: none;
          }
          
          .todo-list li.editing:last-child {
            margin-bottom: -1px;
          }
          
          .footer {
            padding: 10px 15px;
            height: 20px;
            text-align: center;
            font-size: 15px;
            border-top: 1px solid #e6e6e6;
          }
          
          .footer:before {
            content: '';
            position: absolute;
            right: 0;
            bottom: 0;
            left: 0;
            height: 50px;
            overflow: hidden;
            box-shadow: 0 1px 1px rgba(0, 0, 0, 0.2),
                        0 8px 0 -3px #f6f6f6,
                        0 9px 1px -3px rgba(0, 0, 0, 0.2),
                        0 16px 0 -6px #f6f6f6,
                        0 17px 2px -6px rgba(0, 0, 0, 0.2);
          }
          
          .todo-count {
            float: left;
            text-align: left;
          }
          
          .todo-count strong {
            font-weight: 300;
          }
          
          .filters {
            margin: 0;
            padding: 0;
            list-style: none;
            position: absolute;
            right: 0;
            left: 0;
          }
          
          .filters li {
            display: inline;
          }
          
          .filters li a {
            color: inherit;
            margin: 3px;
            padding: 3px 7px;
            text-decoration: none;
            border: 1px solid transparent;
            border-radius: 3px;
          }
          
          .filters li a:hover {
            border-color: rgba(175, 47, 47, 0.1);
          }
          
          .filters li a.selected {
            border-color: rgba(175, 47, 47, 0.2);
          }
          
          .clear-completed,
          html .clear-completed:active {
            float: right;
            position: relative;
            line-height: 20px;
            text-decoration: none;
            cursor: pointer;
          }
          
          .clear-completed:hover {
            text-decoration: underline;
          }
          
          .info {
            margin: 65px auto 0;
            color: #4d4d4d;
            font-size: 11px;
            text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);
            text-align: center;
          }
          
          .info p {
            line-height: 1;
          }
          
          .info a {
            color: inherit;
            text-decoration: none;
            font-weight: 400;
          }
          
          .info a:hover {
            text-decoration: underline;
          }
          
          /*
            Hack to remove background from Mobile Safari.
            Can't use it globally since it destroys checkboxes in Firefox
          */
          @media screen and (-webkit-min-device-pixel-ratio:0) {
            .toggle-all,
            .todo-list li .toggle {
              background: none;
            }
          
            .todo-list li .toggle {
              height: 40px;
            }
          }
          
          @media (max-width: 430px) {
            .footer {
              height: 50px;
            }
          
            .filters {
              bottom: 10px;
            }
          }
        ")
      ])
    ];
  }
}
