import blok.platform.dom.DomPlatform;
import todo.ui.App;

class Todo {

  static function main() {
    DomPlatform.mount(
      js.Browser.document.getElementById('root'),
      context -> App.node({})
    );
  }

}
