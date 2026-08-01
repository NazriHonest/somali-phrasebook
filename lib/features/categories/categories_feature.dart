class CategoriesFeature {
  const CategoriesFeature._();

  static const route = '/categories';
  static const detailRoute = '/category/:id';
  static String detailPath(String id) => '/category/$id';
}
