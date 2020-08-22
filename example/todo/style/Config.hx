package todo.style;

import blok.ui.style.Color;

using Blok;

class Config {
  static public final lightColor = Color.hex(0xCCCCCC).withKey('light');
  static public final midColor = Color.rgb(100, 100, 100).withKey('mid');
  static public final darkColor = Color.rgb(31, 31, 31).withKey('dark');
  static public final scrimColor = Color.rgba(31, 31, 31, 0.7).withKey('scrim');
  static public final smallGap:Unit = Px(15);
  static public final mediumGap:Unit = Px(20);
}
