Style
=====

I'm not sure if the Style system is bringing anything to the table, really. We might be better off removing it, then using stuff like `cix` instead.

We could also do a Flutter-like thing and provide components for layout, something like:

```haxe
Container.node({
  width: Pct(100),
  padding: EdgeInsets.all(Em(1)),
  backgroundColor: Color.hex(0x666666),
  children: [
    // etc
  ]
})
```

Internally, these components could use a `StyleProvider` to manage CSS, something like:

```haxe
class Container extends Component {
  @prop var width:Unit;
  @prop var padding:EdgeInsets = null;
  @prop var backgroundColor:Color = null;
  @prop var children:Children;

  public function render(context:Context) {
    var styles = StyleProvider.from(context);
    return Html.div({
      attrs: {
        className: ClassNameBuilder.build([
          styles.width(width),
          styles.padding(padding),
          styles.background({ color: backgroundColor })
        ])
      },
      children: children
    });
  }
}
```

This would all exist in a completely separate library, allowing us to make Blok cross-platform a lot easier (as Heaps will already work like this, more or less).
