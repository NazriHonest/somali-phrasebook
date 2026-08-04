class CategoriesFeature {
  const CategoriesFeature._();

  static const route = '/categories';
  static const detailRoute = '/category/:id';
  static const subcategoryRoute =
      '/category/:categoryId/subcategory/:subcategoryId';
  static String detailPath(String id) => '/category/$id';
  static String subcategoryPath(String categoryId, String subcategoryId) =>
      '/category/$categoryId/subcategory/$subcategoryId';
}
