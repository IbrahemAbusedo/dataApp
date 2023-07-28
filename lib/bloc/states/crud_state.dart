class CrudState {}

enum ProcessType { create, update, delete }

class ReadState<T> extends CrudState {
  final List<T> data;

  ReadState(this.data);
}

/// class CreateState extends CrudState {}
/// class UpdateState extends CrudState {}
/// class DeleteState extends CrudState {}
/// TODO: Short Solution

class ProcessState extends CrudState {
  final String message;
  final bool success;
  final ProcessType processType;

  ProcessState(this.message, this.success, this.processType);
}

/// TODO: Used As InitialState In main
class LoadingState extends CrudState {}
