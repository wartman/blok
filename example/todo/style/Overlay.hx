package todo.style;

// import blok.style.Centered;
// import blok.style.BoxPosition;
// import blok.style.Background;

using Blok;

class Overlay extends Style {
  
  override function render():Array<VStyleExpr> {
    return [
      // Background.export({
      //   color: Config.scrimColor
      // }),
      // Centered.export({}),
      // BoxPosition.export({
      //   type: Fixed,
      //   top: Px(0),
      //   bottom: Px(0),
      //   left: Px(0),
      //   right: Px(0)
      // })     
    ];
  }

}
