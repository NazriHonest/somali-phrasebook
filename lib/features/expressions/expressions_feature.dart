class ExpressionsFeature {
  const ExpressionsFeature._();

  static const detailRoute = '/expression/:id';
  static const listRoute = '/category/:categoryId/expressions/:subcategoryId';
  static String listPath(String categoryId, String subcategoryId) =>
      '/category/$categoryId/expressions/${subcategoryId.isEmpty ? 'all' : subcategoryId}';
  static String detailPath(String id) => '/expression/$id';
}
