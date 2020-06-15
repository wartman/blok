package todo.ui;

using Blok;

class AppStyle extends Style {

  override function render():Array<VStyle> {
    return [
      VGlobal([ VRaw('
        html, body {
          margin: 0;
          padding: 0;
        }

        body {
          font-size: 13px;
        }
      ') ])
    ];
  }

}
