package noted.ui.style;

import blok.ui.style.*;

using Blok;

class Config {
  static public final accentColor = Color.rgb(187, 185, 230).withKey('accent');
  static public final errorColor = Color.rgb(206, 105, 105).withKey('error');
  static public final whiteColor = Color.hex(0xFFFFFF).withKey('white');
  static public final lightColor = Color.hex(0xCCCCCC).withKey('light');
  static public final midColor = Color.rgb(150, 150, 150).withKey('mid');
  static public final darkColor = Color.rgb(31, 31, 31).withKey('dark');
  static public final scrimColor = Color.rgba(31, 31, 31, 0.7).withKey('scrim');
  static public final smallGap:Unit = Em(1);
  static public final mediumGap:Unit = Em(1.5);
  static public final mobileWidth:Unit = Px(900);
  static public final defaultItemsPerRow = 5;
  static public final defaultItemsPerRowMobile = 3;
}
