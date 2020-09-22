import noted.ui.App;

using Blok;

class Noted {
  static function main() {
    Platform.mount(
      js.Browser.document.getElementById('root'),
      context -> App.node({})
    );
  }
}
