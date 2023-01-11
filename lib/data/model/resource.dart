class Resource<T> {
  T? data;
  Meta? meta;

  Resource({this.data, this.meta});
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  String? perPage;
  int? to;
  int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });
}
