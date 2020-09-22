package blok.core;

enum UpdateMessage<T> {
  /**
    Take no action.
  **/
  None;

  /**
    Trigger an update but do not change state.
  **/
  Update;

  /**
    Trigger an update and change the state.
  **/
  UpdateState(data:T);

  /**
    Trigger an update and change the state, but do NOT invalidate
    the State or Component.
  **/
  UpdateStateSilent(data:T);
}
