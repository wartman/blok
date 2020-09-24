package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Config {
  static public final whiteColor = Color.hex(0xFFFFFF).withKey('white');
  static public final lightColor = Color.hex(0xCCCCCC).withKey('light');
  static public final midColor = Color.rgb(100, 100, 100).withKey('mid');
  static public final darkColor = Color.rgb(31, 31, 31).withKey('dark');
  static public final scrimColor = Color.rgba(31, 31, 31, 0.7).withKey('scrim');
  static public final smallGap:Unit = Em(1);
  static public final mediumGap:Unit = Em(1.5);
}
