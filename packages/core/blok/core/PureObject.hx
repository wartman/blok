package blok.core;

/**
  A simple class that enforces immutable objects.
**/
@:autoBuild(blok.core.PureObjectBuilder.build())
interface PureObject {}
