class DialoguesFeature {
  const DialoguesFeature._();

  static const listRoute = '/category/:categoryId/dialogues';
  static String listPath(String categoryId) =>
      '/category/$categoryId/dialogues';

  static const detailRoute = '/dialogue/:id';
  static String detailPath(String id) => '/dialogue/$id';
}
