package blok.core;

/**
  Any object that has an `__id` may be used as a Providable (this
  includes all states).

  @todo: Maybe make this an abstract type to allow for easier casting?
**/
typedef Providable = {
  public final __id:String;
};
