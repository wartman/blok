package blok.core;

/**
  A simple class that enforces immutable objects.

  The `RecordBuilder` macro will create `with`, `equals` and `copy` methods
  that will allow you to change your record in an immutable way.
**/
@:autoBuild(blok.core.RecordBuilder.build())
interface Record {}
