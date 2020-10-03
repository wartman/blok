package noted.data;

abstract Id<T>(Int) from Int to Int {
  public static function invalid<T>():Id<T> {
    return new Id(-1);
  }

  public function new(id) {
    this = id;
  }

  public function isInvalid() {
    return this < 0;
  }
}
