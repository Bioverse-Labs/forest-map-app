abstract class Model<T, A> {
  Map<String, dynamic> toMap();
  A toHiveAdapter();
  T copyWith();
}
