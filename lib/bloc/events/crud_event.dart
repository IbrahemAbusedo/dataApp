class CrudEvent {}

class CreateEvent<T> extends CrudEvent {
  final T t;

  CreateEvent(this.t);
}

class ReadEvent extends CrudEvent {}

class UpdateEvent<T> extends CrudEvent {
  final T t;

  UpdateEvent(this.t);
}

class DeleteEvent extends CrudEvent {
  final int index;

  DeleteEvent(this.index);
}
