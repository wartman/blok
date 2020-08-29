Null Safe
=========

We should make Blok strictly null safe! This will require some changes.

If a prop is not marked explicitly as `Null<T>`, it should require a default expression. This will be used whenever no value is explicitly provided.

We also might consider _never_ allowing `Null<...>` -- instead, nullable values could use `haxe.ds.Option`.

This might influence other design decisions, as it would be nice to make this library more functional.
