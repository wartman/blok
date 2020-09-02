package blok.ui.history;

import js.Browser;

class BrowserRouterState<Route:EnumValue> extends State {
  @state var router:RouterState<Route>;
  @subscribe(target = router) var route:Route;
  @subscribe(target = router) var history:History;

  @init
  function subscribeToBrowser() {
    Browser.window.addEventListener('popstate', (e) -> {
      router.setUrl(history.getLocation(), false);
    });
  }
}
