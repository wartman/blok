package blok;

@:autoBuild(blok.core.StateBuilder.build('blok.Node'))
interface State extends blok.core.State<blok.Node> {}
