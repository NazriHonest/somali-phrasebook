class ReferenceFeature {
  const ReferenceFeature._();

  static const route = '/reference';
  static const detailRoute = '/reference/:type/:id';
  static const signsRoute = '/signs';
  static const measuresRoute = '/measures';

  static String detailPath(String type, String id) => '/reference/$type/$id';

  static bool isReferenceType(String type) => const {
    'reference_expression',
    'common_question',
    'everyday_response',
    'phrasal_verb',
    'idiom',
    'phrase',
  }.contains(type);
}
