class PaginationHelper<T> {
  int currentPage = 1;
  final int limit;
  bool isLoadingMore = false;
  bool hasMore = true;
  List<T> items = [];

  PaginationHelper({this.limit = 10});

  void reset() {
    currentPage = 1;
    items.clear();
    hasMore = true;
  }

  void update(List<T> newItems) {
    hasMore = newItems.length == limit;
    items.addAll(newItems);
  }

  void startLoadingMore() {
    isLoadingMore = true;
    currentPage++;
  }

  void stopLoadingMore() {
    isLoadingMore = false;
  }
}
