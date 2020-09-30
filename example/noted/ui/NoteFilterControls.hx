package noted.ui;

import blok.ui.style.*;
import noted.ui.style.*;
import noted.state.NoteRepository;

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
                NoteRepository.from(context).setFilter(All);
              },
              child: Html.text('All Notes')
            }),
            Button.node({
              type: Normal,
              onClick: _ -> {
                setMode(ByTag);
                NoteRepository.from(context).setFilter(None);
              },
              child: Html.text('Filter by Tag')
            })
          ]
        }),
        switch mode {
          case All: null;
          case ByTag: Html.div({
            children: [
              Input.node({
                placeholder: 'Filter Tags',
                onSave: value -> NoteRepository
                  .from(context)
                  .setFilter(AllWithTag(value.toLowerCase())),
                onCancel: () -> setMode(ByTag)
              })
            ]
          });
        }
      ]
    });
  }
}