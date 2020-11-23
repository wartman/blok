package blok.core.style;

import blok.core.PluginPayload;

class StylePluginPayload implements PluginPayload<StyleList> {
  public final key = 'BLOK_STYLE';
  public final value:StyleList;
  public var handled:Bool = false;

  public function new(value) {
    this.value = value;
  }
}
