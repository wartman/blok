Styles
======

Looking at `elm-ui` again, and thinking that will be a better direction to go than trying to recreate all of CSS in our style system (as is sorta happening now).

Could look something more like (stealing this directly from `elm-ui`'s example):

```haxe
Ui.row({
  style: [
    Element.width(Fill),
    Layout.style({
      position: CenterY,
      spacing: 30
    })
    // // Or, using shortcuts:
    // Layout.centerY(),
    // Layout.spacing(30)
  ],
  children: [
    Ui.element({
      style: [
        Background.color(Color.rgb(240, 0, 245)),
        Font.color(Color.rgb(255 255 255)),
        Border.rounded(3),
        Element.padding(30)
      ],
      child: Ui.text('Stylish!')
    })
  ]
});
```

This would use the existing `Style` system, but would expose a lot of shortcuts (like `Element.width(Fill`). `Ui` would be fairly simple, exposing `Ui.row`, `Ui.element`, `Ui.text`. Other elements will require using `Html`. The `Ui` module is mostly just some helpers to make sure base styles are applied (`elm-ui` does go harder, and has its own `Input` module and everything, but I don't think that will be needed with our system.).
