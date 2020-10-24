package blok.core;

/**
  A type that can be passed to a Provider.

  All States will statisfy this.

  Note that this is a typedef, not an interface, to allow more
  flexability in defining provideables (as a static class, for 
  example).
**/
typedef Providable<T> = {
  public final __id:String;
  public function __provide():T;
};
