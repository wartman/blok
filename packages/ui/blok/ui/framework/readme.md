This hopefully will become something similar to `elm-ui`.

It will look something like:

```haxe
Html.div({
  style: Layout.style({ 
    direction: Row,
    spacing: Em(1) 
  }),
  children: [
    Html.div({
      style: [
        Align.left(),
        Box.style({ width: Pct(25) }),
        Background.style({ color: Color.hex(0x666666) })
      ],
      children: [ Html.text('Hello') ]
    }),
    Html.div({
      style: [
        Box.style({ width: Pct(25) }),
        Background.style({ color: Color.hex(0xCCC) })
      ],
      children: [ Html.text('...') ]
    }),
    Html.div({
      style: [
        Align.right()
      ],
      children: [ Html.text('World!') ]
    })
  ]
});
```
