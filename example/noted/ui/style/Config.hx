package noted.ui.style;

import blok.core.foundation.style.*;

using Blok;

class Config {
  static public final accentColor = Color.rgb(187, 185, 230);
  static public final errorColor = Color.rgb(206, 105, 105);
  static public final whiteColor = Color.hex(0xFFFFFF);
  static public final lightColor = Color.hex(0xCCCCCC);
  static public final midColor = Color.rgb(150, 150, 150);
  static public final darkColor = Color.rgb(31, 31, 31);
  static public final scrimColor = Color.rgba(31, 31, 31, 0.7);
  static public final smallGap:CssUnit = Em(1);
  static public final mediumGap:CssUnit = Em(1.5);
  static public final mobileWidth:CssUnit = Px(900);
  static public final defaultItemsPerRow = 5;
  static public final defaultItemsPerRowMobile = 3;
}
