package features;

import js.Browser;

using Blok;

class Main {
  static function main() {
    Platform.mount(
      Browser.document.getElementById('root'),
      context -> Html.div({
        children: [
          SvgExample.node({})
        ]
      })
    );
  }
}
