class CategorySeed {
  const CategorySeed({
    required this.code,
    required this.englishTitle,
    required this.somaliTitle,
    required this.englishDescription,
    required this.somaliDescription,
    required this.iconKey,
    required this.themeKey,
  });

  final String code;
  final String englishTitle;
  final String somaliTitle;
  final String englishDescription;
  final String somaliDescription;
  final String iconKey;
  final String themeKey;
}

class SubcategorySeed {
  const SubcategorySeed(this.code, this.englishTitle, this.somaliTitle);

  final String code;
  final String englishTitle;
  final String somaliTitle;
}

class ExpressionSeed {
  const ExpressionSeed({
    required this.id,
    required this.categoryCode,
    required this.subcategoryCode,
    required this.englishText,
    required this.somaliText,
    required this.usageExplanation,
    required this.exampleEnglish,
    required this.exampleSomali,
    required this.context,
    this.somaliAlternative = '',
    this.formality = 'polite',
    this.pronunciation = '',
    this.difficulty = 'A1',
  });

  final String id;
  final String categoryCode;
  final String subcategoryCode;
  final String englishText;
  final String somaliText;
  final String somaliAlternative;
  final String usageExplanation;
  final String exampleEnglish;
  final String exampleSomali;
  final String context;
  final String formality;
  final String pronunciation;
  final String difficulty;
}

class DialogueSeed {
  const DialogueSeed({
    required this.id,
    required this.categoryCode,
    required this.subcategoryCode,
    required this.englishTitle,
    required this.somaliTitle,
    required this.englishSituation,
    required this.somaliSituation,
    required this.lines,
    this.difficulty = 'A2',
  });

  final String id;
  final String categoryCode;
  final String subcategoryCode;
  final String englishTitle;
  final String somaliTitle;
  final String englishSituation;
  final String somaliSituation;
  final List<DialogueLineSeed> lines;
  final String difficulty;
}

class DialogueLineSeed {
  const DialogueLineSeed(
    this.speaker,
    this.englishText,
    this.somaliText, [
    this.usageNote = '',
  ]);

  final String speaker;
  final String englishText;
  final String somaliText;
  final String usageNote;
}

class QaSeed {
  const QaSeed({
    required this.id,
    required this.categoryCode,
    required this.subcategoryCode,
    required this.englishQuestion,
    required this.somaliQuestion,
    required this.englishAnswer,
    required this.somaliAnswer,
    required this.relatedVocabulary,
    this.alternativeAnswer = '',
    this.usageNote = '',
  });

  final String id;
  final String categoryCode;
  final String subcategoryCode;
  final String englishQuestion;
  final String somaliQuestion;
  final String englishAnswer;
  final String somaliAnswer;
  final String alternativeAnswer;
  final String usageNote;
  final String relatedVocabulary;
}

class VocabularySeed {
  const VocabularySeed({
    required this.id,
    required this.categoryCode,
    required this.subcategoryCode,
    required this.englishHeadword,
    required this.somaliHeadword,
    required this.partOfSpeech,
    required this.englishDefinition,
    required this.somaliExplanation,
    required this.exampleEnglish,
    required this.exampleSomali,
    this.pluralForm = '',
    this.pastForm = '',
    this.pastParticiple = '',
    this.comparativeForm = '',
    this.superlativeForm = '',
    this.frequency = 'common',
    this.difficulty = 'A1',
    this.pronunciation = '',
    this.usageNotes = '',
    this.regionalVariant = '',
  });

  final String id;
  final String categoryCode;
  final String subcategoryCode;
  final String englishHeadword;
  final String somaliHeadword;
  final String partOfSpeech;
  final String englishDefinition;
  final String somaliExplanation;
  final String exampleEnglish;
  final String exampleSomali;
  final String pluralForm;
  final String pastForm;
  final String pastParticiple;
  final String comparativeForm;
  final String superlativeForm;
  final String frequency;
  final String difficulty;
  final String pronunciation;
  final String usageNotes;
  final String regionalVariant;
}

class SeedFactory {
  const SeedFactory._();

  static const seedVersion = 4;

  static const categories = <CategorySeed>[
    CategorySeed(
      code: 'language_barrier',
      englishTitle: 'Coping with the Language Barrier',
      somaliTitle: 'La qabsiga caqabadda luqadda',
      englishDescription:
          'Ask for repetition, slower speech, spelling, and interpretation.',
      somaliDescription:
          'Baro sida loo codsado ku celin, hadal gaabis ah, higgaad, iyo turjubaan.',
      iconKey: 'translate',
      themeKey: 'blue',
    ),
    CategorySeed(
      code: 'etiquette',
      englishTitle: 'Useful Forms of Etiquette',
      somaliTitle: 'Edeb iyo salaam maalinle ah',
      englishDescription:
          'Greetings, thanks, apologies, invitations, and polite responses.',
      somaliDescription:
          'Salaan, mahadnaq, raalli-gelin, casuumaad, iyo jawaabo edeb leh.',
      iconKey: 'handshake',
      themeKey: 'green',
    ),
    CategorySeed(
      code: 'personal_information',
      englishTitle: 'Giving Information About Yourself',
      somaliTitle: 'Bixinta macluumaadkaaga',
      englishDescription:
          'Names, address, family, work, education, and basic forms.',
      somaliDescription:
          'Magac, cinwaan, qoys, shaqo, waxbarasho, iyo foomam aasaasi ah.',
      iconKey: 'person',
      themeKey: 'violet',
    ),
    CategorySeed(
      code: 'signs',
      englishTitle: 'Recognizing Signs',
      somaliTitle: 'Aqoonsiga calaamadaha',
      englishDescription: 'Common public signs, notices, and safety messages.',
      somaliDescription:
          'Calaamadaha dadweynaha, ogeysiisyada, iyo farriimaha badbaadada.',
      iconKey: 'signpost',
      themeKey: 'amber',
    ),
    CategorySeed(
      code: 'measures',
      englishTitle: 'Weights and Measures',
      somaliTitle: 'Miisaanno iyo cabbirro',
      englishDescription:
          'Units for length, weight, size, cooking, and temperature.',
      somaliDescription:
          'Cutubyo dherer, miisaan, cabbir, cunto-karin, iyo heerkul.',
      iconKey: 'scale',
      themeKey: 'teal',
    ),
    CategorySeed(
      code: 'numbers',
      englishTitle: 'Using Numbers',
      somaliTitle: 'Isticmaalka tirooyinka',
      englishDescription:
          'Numbers for prices, dates, phones, rooms, and percentages.',
      somaliDescription:
          'Tirooyin qiime, taariikh, telefoon, qolal, iyo boqolley.',
      iconKey: 'numbers',
      themeKey: 'indigo',
    ),
    CategorySeed(
      code: 'money',
      englishTitle: 'Dealing with Money',
      somaliTitle: 'La macaamilka lacagta',
      englishDescription:
          'Prices, payments, banks, receipts, refunds, and transfers.',
      somaliDescription:
          'Qiime, bixin, bangiyo, rasiid, lacag-celin, iyo diris lacag.',
      iconKey: 'payments',
      themeKey: 'emerald',
    ),
    CategorySeed(
      code: 'time',
      englishTitle: 'Dealing with Time',
      somaliTitle: 'La macaamilka waqtiga',
      englishDescription:
          'Time, dates, schedules, appointments, and deadlines.',
      somaliDescription:
          'Waqti, taariikho, jadwal, ballamo, iyo waqti kama dambays ah.',
      iconKey: 'schedule',
      themeKey: 'cyan',
    ),
    CategorySeed(
      code: 'locating',
      englishTitle: 'Locating Things',
      somaliTitle: 'Helidda meelaha iyo walxaha',
      englishDescription:
          'Ask where things are and describe positions clearly.',
      somaliDescription:
          'Weydii meesha wax yaallaan, kuna sharax boosaskooda si cad.',
      iconKey: 'place',
      themeKey: 'orange',
    ),
    CategorySeed(
      code: 'describing',
      englishTitle: 'Describing Things and People',
      somaliTitle: 'Sharaxaadda waxyaabaha iyo dadka',
      englishDescription:
          'Describe size, color, condition, feelings, weather, and appearance.',
      somaliDescription:
          'Sharax cabbir, midab, xaalad, dareen, cimilo, iyo muuqaal.',
      iconKey: 'palette',
      themeKey: 'rose',
    ),
    CategorySeed(
      code: 'doing_things',
      englishTitle: 'Doing Things',
      somaliTitle: 'Samaynta hawlo',
      englishDescription:
          'Verbs for daily actions, plans, ability, permission, and preference.',
      somaliDescription:
          'Ficillo hawl maalmeed, qorshe, awood, oggolaansho, iyo doorbidid.',
      iconKey: 'task',
      themeKey: 'lime',
    ),
    CategorySeed(
      code: 'going_places',
      englishTitle: 'Going Places',
      somaliTitle: 'Tagidda meelaha',
      englishDescription:
          'Directions, buses, taxis, airports, tickets, maps, and travel problems.',
      somaliDescription:
          'Tilmaamo, basas, taksi, garoomo, tigidhyo, khariidado, iyo dhibaato safar.',
      iconKey: 'directions_bus',
      themeKey: 'blue',
    ),
    CategorySeed(
      code: 'conveying_information',
      englishTitle: 'Conveying Information',
      somaliTitle: 'Gudbinta macluumaadka',
      englishDescription:
          'Calls, messages, email, instructions, spelling, and corrections.',
      somaliDescription:
          'Wicitaanno, farriimo, iimayl, tilmaamo, higgaad, iyo sixid.',
      iconKey: 'mail',
      themeKey: 'purple',
    ),
    CategorySeed(
      code: 'health_hygiene',
      englishTitle: 'Health and Hygiene',
      somaliTitle: 'Caafimaad iyo nadaafad',
      englishDescription:
          'Appointments, symptoms, medicines, pharmacy visits, and emergencies.',
      somaliDescription:
          'Ballamo, calaamado xanuun, daawooyin, farmashiye, iyo gurmad.',
      iconKey: 'medical_services',
      themeKey: 'red',
    ),
    CategorySeed(
      code: 'food',
      englishTitle: 'Food',
      somaliTitle: 'Cunto',
      englishDescription:
          'Groceries, restaurants, ingredients, halal questions, and allergies.',
      somaliDescription:
          'Suuq-cunto, maqaayad, maaddooyin, sualo xalaal ah, iyo xasaasiyad.',
      iconKey: 'restaurant',
      themeKey: 'amber',
    ),
    CategorySeed(
      code: 'clothing',
      englishTitle: 'Clothing',
      somaliTitle: 'Dharka',
      englishDescription:
          'Clothes, sizes, fit, shoes, laundry, returns, and tailoring.',
      somaliDescription:
          'Dhar, cabbir, ku-habboonaansho, kabo, dhaqid, celin, iyo tolid.',
      iconKey: 'checkroom',
      themeKey: 'pink',
    ),
    CategorySeed(
      code: 'housing',
      englishTitle: 'Housing',
      somaliTitle: 'Guri iyo degaan',
      englishDescription:
          'Rent, rooms, repairs, bills, neighbors, keys, and moving.',
      somaliDescription:
          'Kiro, qolal, dayactir, biilal, deris, furayaal, iyo guurid.',
      iconKey: 'home',
      themeKey: 'brown',
    ),
    CategorySeed(
      code: 'jobs',
      englishTitle: 'Jobs',
      somaliTitle: 'Shaqooyin',
      englishDescription:
          'Applications, interviews, schedules, wages, safety, and leave.',
      somaliDescription:
          'Codsiyo, wareysiyo, jadwal, mushahar, badbaado, iyo fasax.',
      iconKey: 'work',
      themeKey: 'gray',
    ),
    CategorySeed(
      code: 'schools',
      englishTitle: 'About Schools',
      somaliTitle: 'Arrimaha iskuulka',
      englishDescription:
          'Enrollment, classes, attendance, homework, meetings, and adult education.',
      somaliDescription:
          'Diiwaangelin, fasallo, xaadiris, laylis, shirar, iyo waxbarashada dadka waaweyn.',
      iconKey: 'school',
      themeKey: 'navy',
    ),
  ];

  static const subcategories = <SubcategorySeed>[
    SubcategorySeed(
      'language_barrier.repeat',
      'Asking for repetition',
      'Codsiga ku celinta',
    ),
    SubcategorySeed(
      'language_barrier.slowly',
      'Asking for slow speech',
      'Codsiga hadal tartiib ah',
    ),
    SubcategorySeed(
      'language_barrier.spelling',
      'Spelling and writing',
      'Higgaad iyo qoraal',
    ),
    SubcategorySeed(
      'language_barrier.meaning',
      'Checking meaning',
      'Hubinta macnaha',
    ),
    SubcategorySeed(
      'language_barrier.interpreter',
      'Requesting an interpreter',
      'Codsiga turjubaan',
    ),
    SubcategorySeed('etiquette.greetings', 'Greetings', 'Salaamaha'),
    SubcategorySeed('etiquette.thanks', 'Thanks and appreciation', 'Mahadnaq'),
    SubcategorySeed('etiquette.apologies', 'Apologies', 'Raalli-gelin'),
    SubcategorySeed(
      'etiquette.invitations',
      'Invitations and visits',
      'Casuumaad iyo booqasho',
    ),
    SubcategorySeed(
      'etiquette.respect',
      'Respectful responses',
      'Jawaabo xushmad leh',
    ),
    SubcategorySeed(
      'personal_information.name',
      'Name and identity',
      'Magac iyo aqoonsi',
    ),
    SubcategorySeed(
      'personal_information.contact',
      'Address and contact',
      'Cinwaan iyo xiriir',
    ),
    SubcategorySeed(
      'personal_information.family',
      'Family details',
      'Macluumaadka qoyska',
    ),
    SubcategorySeed(
      'personal_information.work',
      'Work and education',
      'Shaqo iyo waxbarasho',
    ),
    SubcategorySeed(
      'personal_information.forms',
      'Filling in forms',
      'Buuxinta foomamka',
    ),
    SubcategorySeed('signs.access', 'Access signs', 'Calaamadaha gelitaanka'),
    SubcategorySeed('signs.safety', 'Safety signs', 'Calaamadaha badbaadada'),
    SubcategorySeed(
      'signs.services',
      'Service notices',
      'Ogeysiisyada adeegga',
    ),
    SubcategorySeed(
      'signs.transport',
      'Transport signs',
      'Calaamadaha gaadiidka',
    ),
    SubcategorySeed(
      'signs.rules',
      'Rules and restrictions',
      'Xeerar iyo mamnuucid',
    ),
    SubcategorySeed(
      'measures.length',
      'Length and distance',
      'Dherer iyo fogaan',
    ),
    SubcategorySeed('measures.weight', 'Weight', 'Miisaan'),
    SubcategorySeed('measures.volume', 'Volume and liquids', 'Mug iyo dareere'),
    SubcategorySeed('measures.temperature', 'Temperature', 'Heerkul'),
    SubcategorySeed(
      'measures.size',
      'Size and fit',
      'Cabbir iyo ku-habboonaansho',
    ),
    SubcategorySeed('numbers.counting', 'Counting', 'Tirinta'),
    SubcategorySeed('numbers.phone', 'Phone numbers', 'Lambarada telefoonka'),
    SubcategorySeed('numbers.dates', 'Dates and rooms', 'Taariikho iyo qolal'),
    SubcategorySeed('numbers.amounts', 'Amounts', 'Qaddarro'),
    SubcategorySeed('numbers.percentages', 'Percentages', 'Boqolley'),
    SubcategorySeed('money.prices', 'Prices', 'Qiimaha'),
    SubcategorySeed(
      'money.payment',
      'Payment methods',
      'Hababka lacag-bixinta',
    ),
    SubcategorySeed('money.bank', 'Banking', 'Bangiga'),
    SubcategorySeed(
      'money.receipts',
      'Receipts and refunds',
      'Rasiid iyo lacag-celin',
    ),
    SubcategorySeed('money.transfers', 'Money transfers', 'Dirista lacagta'),
    SubcategorySeed('time.clock', 'Clock time', 'Saacadda'),
    SubcategorySeed('time.appointments', 'Appointments', 'Ballamaha'),
    SubcategorySeed('time.schedule', 'Schedules', 'Jadwalka'),
    SubcategorySeed('time.deadlines', 'Deadlines', 'Waqti kama dambays ah'),
    SubcategorySeed('time.frequency', 'Frequency', 'Joogteyn'),
    SubcategorySeed('locating.directions', 'Directions', 'Tilmaamaha jidka'),
    SubcategorySeed(
      'locating.inside',
      'Inside buildings',
      'Gudaha dhismayaasha',
    ),
    SubcategorySeed('locating.lost_items', 'Lost items', 'Waxyaabo lumay'),
    SubcategorySeed('locating.nearby', 'Nearby places', 'Meelo dhow'),
    SubcategorySeed('locating.position', 'Position words', 'Erayada booska'),
    SubcategorySeed('describing.appearance', 'Appearance', 'Muuqaalka'),
    SubcategorySeed('describing.condition', 'Condition', 'Xaaladda'),
    SubcategorySeed(
      'describing.color',
      'Color and material',
      'Midab iyo walax',
    ),
    SubcategorySeed('describing.feelings', 'Feelings', 'Dareenno'),
    SubcategorySeed('describing.weather', 'Weather', 'Cimilada'),
    SubcategorySeed('doing_things.daily', 'Daily actions', 'Hawl maalmeed'),
    SubcategorySeed('doing_things.ability', 'Ability', 'Awood'),
    SubcategorySeed('doing_things.permission', 'Permission', 'Oggolaansho'),
    SubcategorySeed('doing_things.plans', 'Plans', 'Qorsheyaal'),
    SubcategorySeed('doing_things.preferences', 'Preferences', 'Doorbidid'),
    SubcategorySeed('going_places.bus', 'Bus and train', 'Bas iyo tareen'),
    SubcategorySeed(
      'going_places.taxi',
      'Taxi and ride share',
      'Taksi iyo adeeg raacid',
    ),
    SubcategorySeed(
      'going_places.airport',
      'Airport travel',
      'Safarka garoonka',
    ),
    SubcategorySeed('going_places.tickets', 'Tickets', 'Tigidhyo'),
    SubcategorySeed(
      'going_places.problems',
      'Travel problems',
      'Dhibaato safar',
    ),
    SubcategorySeed('conveying_information.phone', 'Phone calls', 'Wicitaanno'),
    SubcategorySeed(
      'conveying_information.messages',
      'Text messages',
      'Farriimo qoraal ah',
    ),
    SubcategorySeed('conveying_information.email', 'Email', 'Iimayl'),
    SubcategorySeed(
      'conveying_information.instructions',
      'Instructions',
      'Tilmaamo',
    ),
    SubcategorySeed(
      'conveying_information.corrections',
      'Corrections',
      'Sixid',
    ),
    SubcategorySeed(
      'health_hygiene.symptoms',
      'Symptoms',
      'Calaamadaha xanuunka',
    ),
    SubcategorySeed(
      'health_hygiene.appointments',
      'Medical appointments',
      'Ballamaha caafimaadka',
    ),
    SubcategorySeed(
      'health_hygiene.medicine',
      'Medicine and pharmacy',
      'Daawo iyo farmashiye',
    ),
    SubcategorySeed(
      'health_hygiene.hygiene',
      'Personal hygiene',
      'Nadaafadda qofka',
    ),
    SubcategorySeed(
      'health_hygiene.emergency',
      'Emergencies',
      'Gurmad degdeg ah',
    ),
    SubcategorySeed('food.groceries', 'Grocery shopping', 'Suuq-cunto'),
    SubcategorySeed(
      'food.restaurant',
      'Ordering at a restaurant',
      'Dalbashada maqaayadda',
    ),
    SubcategorySeed('food.halal', 'Halal food', 'Cunto xalaal ah'),
    SubcategorySeed('food.allergies', 'Food allergies', 'Xasaasiyadda cuntada'),
    SubcategorySeed(
      'food.cooking',
      'Cooking and storage',
      'Cunto-karin iyo kaydin',
    ),
    SubcategorySeed('clothing.sizes', 'Sizes', 'Cabbirrada'),
    SubcategorySeed('clothing.fit', 'Fit and comfort', 'Ku-habboonaansho'),
    SubcategorySeed('clothing.shoes', 'Shoes', 'Kabo'),
    SubcategorySeed('clothing.laundry', 'Laundry', 'Dhaqidda dharka'),
    SubcategorySeed(
      'clothing.returns',
      'Returns and tailoring',
      'Celinta iyo tolidda',
    ),
    SubcategorySeed('housing.search', 'Looking for housing', 'Raadinta guri'),
    SubcategorySeed('housing.rent', 'Rent and deposits', 'Kiro iyo dammaanad'),
    SubcategorySeed('housing.repairs', 'Repairs', 'Dayactir'),
    SubcategorySeed('housing.utilities', 'Utility bills', 'Biilasha adeegga'),
    SubcategorySeed('housing.safety', 'Household safety', 'Badbaadada guriga'),
    SubcategorySeed('jobs.search', 'Looking for work', 'Raadinta shaqo'),
    SubcategorySeed(
      'jobs.applications',
      'Applications and resumes',
      'Codsiyo iyo CV',
    ),
    SubcategorySeed('jobs.interviews', 'Interviews', 'Wareysiyo'),
    SubcategorySeed(
      'jobs.schedule',
      'Schedules and wages',
      'Jadwal iyo mushahar',
    ),
    SubcategorySeed(
      'jobs.safety',
      'Workplace safety and leave',
      'Badbaado iyo fasax shaqo',
    ),
    SubcategorySeed('schools.enrollment', 'Enrollment', 'Diiwaangelin'),
    SubcategorySeed('schools.attendance', 'Attendance', 'Xaadiris'),
    SubcategorySeed(
      'schools.homework',
      'Homework and classes',
      'Laylis iyo fasallo',
    ),
    SubcategorySeed(
      'schools.portal',
      'School portal and messages',
      'Bogga iskuulka iyo farriimo',
    ),
    SubcategorySeed(
      'schools.meetings',
      'Teacher meetings',
      'Kulamada macallinka',
    ),
  ];

  static const expressions = <ExpressionSeed>[
    ExpressionSeed(
      id: 'expr_language_barrier_repeat_001',
      categoryCode: 'language_barrier',
      subcategoryCode: 'repeat',
      englishText: 'Could you say that again, please?',
      somaliText: 'Fadlan mar kale ma oran kartaa?',
      usageExplanation:
          'Use this politely when you did not hear or understand what someone said.',
      exampleEnglish:
          'I missed the room number. Could you say that again, please?',
      exampleSomali:
          'Lambarka qolka waan seegay. Fadlan mar kale ma oran kartaa?',
      context: 'office counter',
    ),
    ExpressionSeed(
      id: 'expr_language_barrier_slowly_001',
      categoryCode: 'language_barrier',
      subcategoryCode: 'slowly',
      englishText: 'Could you speak a little more slowly?',
      somaliText: 'Wax yar si ka tartiibsan ma u hadli kartaa?',
      usageExplanation:
          'Use this when the speaker is talking too fast for you to follow.',
      exampleEnglish:
          'The receptionist spoke quickly, so I asked her to speak a little more slowly.',
      exampleSomali:
          'Shaqaalaha soo-dhaweyntu si degdeg ah ayay u hadashay, markaas ayaan ka codsaday inay si ka tartiibsan u hadasho.',
      context: 'reception desk',
      difficulty: 'A2',
    ),
    ExpressionSeed(
      id: 'expr_etiquette_greetings_001',
      categoryCode: 'etiquette',
      subcategoryCode: 'greetings',
      englishText: 'It is nice to meet you.',
      somaliText: 'Waan ku faraxsanahay inaan ku barto.',
      usageExplanation:
          'Say this when meeting someone for the first time in a friendly or formal setting.',
      exampleEnglish: 'After we shook hands, I said, "It is nice to meet you."',
      exampleSomali:
          'Ka dib markii aan is gacan qaadnay, waxaan iri, "Waan ku faraxsanahay inaan ku barto."',
      context: 'first meeting',
    ),
    ExpressionSeed(
      id: 'expr_etiquette_apologies_001',
      categoryCode: 'etiquette',
      subcategoryCode: 'apologies',
      englishText: 'I am sorry for being late.',
      somaliText: 'Waan ka xumahay inaan soo daahay.',
      usageExplanation: 'Use this when arriving after the agreed time.',
      exampleEnglish:
          'The bus was delayed, so I said I was sorry for being late.',
      exampleSomali:
          'Basku wuu daahay, sidaas darteed waxaan iri waan ka xumahay inaan soo daahay.',
      context: 'appointment',
    ),
    ExpressionSeed(
      id: 'expr_personal_information_name_001',
      categoryCode: 'personal_information',
      subcategoryCode: 'name',
      englishText: 'My full name is written on this document.',
      somaliText: 'Magacayga oo buuxa wuxuu ku qoran yahay dukumentigan.',
      usageExplanation:
          'Use this when confirming your legal name on a form or document.',
      exampleEnglish:
          'My full name is written on this document, but my family calls me Ayan.',
      exampleSomali:
          'Magacayga oo buuxa wuxuu ku qoran yahay dukumentigan, laakiin qoyskaygu Ayaan bay iigu yeeraan.',
      context: 'form office',
    ),
    ExpressionSeed(
      id: 'expr_personal_information_contact_001',
      categoryCode: 'personal_information',
      subcategoryCode: 'contact',
      englishText: 'This is my current address.',
      somaliText: 'Kani waa cinwaankayga hadda.',
      usageExplanation: 'Use this when giving the address where you live now.',
      exampleEnglish: 'I moved last month, so this is my current address.',
      exampleSomali:
          'Bishii hore ayaan guuray, sidaas darteed kani waa cinwaankayga hadda.',
      context: 'registration',
    ),
    ExpressionSeed(
      id: 'expr_signs_safety_001',
      categoryCode: 'signs',
      subcategoryCode: 'safety',
      englishText: 'Does this sign mean the floor is wet?',
      somaliText:
          'Calaamaddani ma waxay ka dhigan tahay in dhulku qoyan yahay?',
      usageExplanation:
          'Ask this when you want to confirm a warning sign before walking through an area.',
      exampleEnglish:
          'Before I walked near the door, I asked if the sign meant the floor was wet.',
      exampleSomali:
          'Ka hor inta aanan albaabka u dhowaan, waxaan weydiiyay in calaamaddu ka dhigan tahay in dhulku qoyan yahay.',
      context: 'public building',
    ),
    ExpressionSeed(
      id: 'expr_signs_access_001',
      categoryCode: 'signs',
      subcategoryCode: 'access',
      englishText: 'Is this the entrance or the exit?',
      somaliText: 'Tani ma albaabka gelitaanka baa mise kan bixitaanka?',
      usageExplanation:
          'Use this when signs are unclear at a building, station, or event.',
      exampleEnglish:
          'At the clinic I asked, "Is this the entrance or the exit?"',
      exampleSomali:
          'Xarunta caafimaadka waxaan weydiiyay, "Tani ma albaabka gelitaanka baa mise kan bixitaanka?"',
      context: 'public entrance',
    ),
    ExpressionSeed(
      id: 'expr_measures_weight_001',
      categoryCode: 'measures',
      subcategoryCode: 'weight',
      englishText: 'How many kilograms is this bag?',
      somaliText: 'Bacdan waa imisa kiiloogaraam?',
      usageExplanation:
          'Ask this when weighing luggage, rice, flour, or other goods.',
      exampleEnglish:
          'Before paying for the rice, I asked how many kilograms the bag was.',
      exampleSomali:
          'Ka hor inta aanan bariiska bixin, waxaan weydiiyay bacdu imisa kiiloogaraam tahay.',
      context: 'shop',
    ),
    ExpressionSeed(
      id: 'expr_measures_temperature_001',
      categoryCode: 'measures',
      subcategoryCode: 'temperature',
      englishText: 'What is the temperature today?',
      somaliText: 'Heerkulku maanta waa imisa?',
      usageExplanation:
          'Use this when asking about weather or room temperature.',
      exampleEnglish:
          'It felt very hot, so I asked what the temperature was today.',
      exampleSomali:
          'Aad bay u kululayd, markaas ayaan weydiiyay heerkulku maanta imisa yahay.',
      context: 'weather',
    ),
    ExpressionSeed(
      id: 'expr_numbers_phone_001',
      categoryCode: 'numbers',
      subcategoryCode: 'phone',
      englishText: 'Could you read the phone number slowly?',
      somaliText: 'Lambarka telefoonka si tartiib ah ma u akhrin kartaa?',
      usageExplanation:
          'Use this when writing down a phone number and you need each digit clearly.',
      exampleEnglish:
          'I had a pen ready and asked her to read the phone number slowly.',
      exampleSomali:
          'Qalin baan diyaarsaday, waxaanan ka codsaday inay lambarka telefoonka si tartiib ah u akhrido.',
      context: 'phone call',
    ),
    ExpressionSeed(
      id: 'expr_numbers_amounts_001',
      categoryCode: 'numbers',
      subcategoryCode: 'amounts',
      englishText: 'I need two copies, not three.',
      somaliText: 'Waxaan u baahanahay labo nuqul, ma aha saddex.',
      usageExplanation:
          'Use this to correct a number politely when ordering or requesting something.',
      exampleEnglish:
          'At the print shop I said I needed two copies, not three.',
      exampleSomali:
          'Dukaanka daabacaadda waxaan iri waxaan u baahanahay labo nuqul, ma aha saddex.',
      context: 'print shop',
    ),
    ExpressionSeed(
      id: 'expr_money_receipts_001',
      categoryCode: 'money',
      subcategoryCode: 'receipts',
      englishText: 'Could I have a receipt, please?',
      somaliText: 'Fadlan rasiid ma heli karaa?',
      usageExplanation:
          'Use this after paying when you need proof of purchase.',
      exampleEnglish: 'I paid by debit card and asked for a receipt.',
      exampleSomali:
          'Kaarka debit-ka ayaan ku bixiyay, rasiidna waan codsaday.',
      context: 'checkout',
    ),
    ExpressionSeed(
      id: 'expr_money_payment_001',
      categoryCode: 'money',
      subcategoryCode: 'payment',
      englishText: 'Can I pay by mobile payment?',
      somaliText: 'Lacag-bixin moobil ma ku bixin karaa?',
      usageExplanation:
          'Ask this before paying with a phone-based payment app.',
      exampleEnglish:
          'I did not have cash, so I asked if I could pay by mobile payment.',
      exampleSomali:
          'Lacag caddaan ah ma haysan, markaas ayaan weydiiyay haddii aan moobil ku bixin karo.',
      context: 'small shop',
    ),
    ExpressionSeed(
      id: 'expr_time_appointments_001',
      categoryCode: 'time',
      subcategoryCode: 'appointments',
      englishText: 'What time does the appointment start?',
      somaliText: 'Ballantu saacaddu meeqa ayay bilaabanaysaa?',
      usageExplanation:
          'Use this when confirming the start time of a meeting, class, or medical visit.',
      exampleEnglish:
          'The text message gave the date, but I still asked what time the appointment started.',
      exampleSomali:
          'Farriinta qoraalka ah taariikhda ayay sheegtay, laakiin weli waxaan weydiiyay ballantu saacaddu meeqa bilaabanayso.',
      context: 'clinic message',
    ),
    ExpressionSeed(
      id: 'expr_time_deadlines_001',
      categoryCode: 'time',
      subcategoryCode: 'deadlines',
      englishText: 'When is the deadline?',
      somaliText: 'Waqtiga kama dambaysta ahi waa goorma?',
      usageExplanation:
          'Ask this when you need to know the last day or time to submit something.',
      exampleEnglish:
          'Before I filled in the online form, I asked when the deadline was.',
      exampleSomali:
          'Ka hor inta aanan foomka internetka buuxin, waxaan weydiiyay waqtiga kama dambaysta ahi goormuu yahay.',
      context: 'online form',
    ),
    ExpressionSeed(
      id: 'expr_locating_directions_001',
      categoryCode: 'locating',
      subcategoryCode: 'directions',
      englishText: 'Where is the nearest bus stop?',
      somaliText: 'Joogsiga baska ee ugu dhow xaggee ku yaal?',
      usageExplanation:
          'Use this when you need local directions to public transport.',
      exampleEnglish:
          'After leaving the library, I asked where the nearest bus stop was.',
      exampleSomali:
          'Markii aan maktabadda ka baxay, waxaan weydiiyay joogsiga baska ee ugu dhow xaggee ku yaal.',
      context: 'street',
    ),
    ExpressionSeed(
      id: 'expr_locating_lost_items_001',
      categoryCode: 'locating',
      subcategoryCode: 'lost_items',
      englishText: 'I think I left my phone here.',
      somaliText: 'Waxaan u maleynayaa inaan telefoonkeyga halkan uga tagay.',
      usageExplanation:
          'Use this when reporting a lost item at a shop, office, or vehicle.',
      exampleEnglish:
          'I returned to the taxi office because I thought I left my phone there.',
      exampleSomali:
          'Xafiiska taksiga ayaan ku laabtay maxaa yeelay waxaan u maleeyay inaan telefoonkeyga halkaas uga tagay.',
      context: 'lost property',
    ),
    ExpressionSeed(
      id: 'expr_describing_condition_001',
      categoryCode: 'describing',
      subcategoryCode: 'condition',
      englishText: 'The screen is cracked.',
      somaliText: 'Shaashaddu way dillaacday.',
      usageExplanation:
          'Use this to describe damage to a phone, tablet, or other device.',
      exampleEnglish: 'I showed the repair shop that the screen was cracked.',
      exampleSomali:
          'Dukaanka dayactirka waxaan tusay in shaashaddu dillaacday.',
      context: 'repair shop',
    ),
    ExpressionSeed(
      id: 'expr_describing_feelings_001',
      categoryCode: 'describing',
      subcategoryCode: 'feelings',
      englishText: 'I feel a little nervous.',
      somaliText: 'Waxaan dareemayaa walwal yar.',
      usageExplanation:
          'Use this to describe mild anxiety before an interview, test, or appointment.',
      exampleEnglish:
          'Before the interview, I told my friend I felt a little nervous.',
      exampleSomali:
          'Wareysiga ka hor, waxaan saaxiibkay u sheegay inaan dareemayo walwal yar.',
      context: 'interview',
    ),
    ExpressionSeed(
      id: 'expr_doing_things_permission_001',
      categoryCode: 'doing_things',
      subcategoryCode: 'permission',
      englishText: 'May I use this computer?',
      somaliText: 'Kombiyuutarkan ma isticmaali karaa?',
      usageExplanation:
          'Ask this before using equipment that may belong to an office, school, or library.',
      exampleEnglish:
          'At the library desk, I asked if I could use the computer.',
      exampleSomali:
          'Miiska maktabadda waxaan weydiiyay haddii aan kombiyuutarka isticmaali karo.',
      context: 'library',
    ),
    ExpressionSeed(
      id: 'expr_doing_things_plans_001',
      categoryCode: 'doing_things',
      subcategoryCode: 'plans',
      englishText: 'I am planning to apply online.',
      somaliText: 'Waxaan qorsheynayaa inaan internetka ka codsado.',
      usageExplanation:
          'Use this when explaining your next step for a job, school, benefit, or service.',
      exampleEnglish:
          'I am planning to apply online after I collect my documents.',
      exampleSomali:
          'Waxaan qorsheynayaa inaan internetka ka codsado ka dib marka aan dukumentiyadayda ururiyo.',
      context: 'planning',
    ),
    ExpressionSeed(
      id: 'expr_going_places_taxi_001',
      categoryCode: 'going_places',
      subcategoryCode: 'taxi',
      englishText: 'Can you take me to this address?',
      somaliText: 'Cinwaankan ma i geyn kartaa?',
      usageExplanation:
          'Use this with a taxi driver or ride-sharing driver when showing an address.',
      exampleEnglish:
          'I showed the driver my phone and asked if he could take me to this address.',
      exampleSomali:
          'Darawalka telefoonkeyga ayaan tusay, waxaanan weydiiyay inuu cinwaankan i geyn karo.',
      context: 'taxi',
    ),
    ExpressionSeed(
      id: 'expr_going_places_tickets_001',
      categoryCode: 'going_places',
      subcategoryCode: 'tickets',
      englishText: 'Is this ticket valid today?',
      somaliText: 'Tigidhkani maanta ma shaqaynayaa?',
      usageExplanation:
          'Ask this before boarding when you are unsure about the date or route on a ticket.',
      exampleEnglish:
          'At the station gate, I asked if the ticket was valid today.',
      exampleSomali:
          'Albaabka saldhigga waxaan weydiiyay haddii tigidhku maanta shaqaynayo.',
      context: 'station',
    ),
    ExpressionSeed(
      id: 'expr_conveying_information_email_001',
      categoryCode: 'conveying_information',
      subcategoryCode: 'email',
      englishText: 'I will send the document by email.',
      somaliText: 'Dukumentiga iimayl ayaan ku soo diri doonaa.',
      usageExplanation:
          'Use this when telling someone how you will deliver a document electronically.',
      exampleEnglish:
          'The office asked for my ID, so I said I would send the document by email.',
      exampleSomali:
          'Xafiisku aqoonsigayga ayuu codsaday, markaas waxaan iri dukumentiga iimayl ayaan ku soo diri doonaa.',
      context: 'office',
    ),
    ExpressionSeed(
      id: 'expr_conveying_information_corrections_001',
      categoryCode: 'conveying_information',
      subcategoryCode: 'corrections',
      englishText: 'There is a spelling mistake in my name.',
      somaliText: 'Magacayga waxaa ku jira khalad higgaad ah.',
      usageExplanation:
          'Use this when correcting a document, email, card, or account.',
      exampleEnglish:
          'When I checked the school portal, I saw a spelling mistake in my name.',
      exampleSomali:
          'Markii aan bogga iskuulka eegay, waxaan arkay khalad higgaad ah oo magacayga ku jira.',
      context: 'account correction',
    ),
    ExpressionSeed(
      id: 'expr_health_hygiene_symptoms_001',
      categoryCode: 'health_hygiene',
      subcategoryCode: 'symptoms',
      englishText: 'I have had a cough for three days.',
      somaliText: 'Saddex maalmood ayaan qufac qabay.',
      usageExplanation:
          'Use this when explaining how long a symptom has lasted.',
      exampleEnglish:
          'At the clinic, I told the nurse I had had a cough for three days.',
      exampleSomali:
          'Xarunta caafimaadka, kalkaalisada waxaan u sheegay inaan saddex maalmood qufac qabay.',
      context: 'clinic',
    ),
    ExpressionSeed(
      id: 'expr_health_hygiene_medicine_001',
      categoryCode: 'health_hygiene',
      subcategoryCode: 'medicine',
      englishText: 'Should I take this medicine with food?',
      somaliText: 'Daawadan cuntada ma la qaataa?',
      usageExplanation:
          'Ask this at a pharmacy or clinic before taking medicine.',
      exampleEnglish:
          'Before leaving the pharmacy, I asked whether I should take the medicine with food.',
      exampleSomali:
          'Ka hor inta aanan farmashiyaha ka bixin, waxaan weydiiyay daawada cuntada ma la qaataa.',
      context: 'pharmacy',
    ),
    ExpressionSeed(
      id: 'expr_food_restaurant_001',
      categoryCode: 'food',
      subcategoryCode: 'restaurant',
      englishText: 'Could I see the menu, please?',
      somaliText: 'Fadlan liiska cuntada ma arki karaa?',
      somaliAlternative: 'Fadlan menu-ga ma i siin kartaa?',
      usageExplanation:
          'Use this in a restaurant when you want to see available dishes before ordering.',
      exampleEnglish: 'When I sat down, I asked if I could see the menu.',
      exampleSomali:
          'Markii aan fariistay, waxaan weydiiyay haddii aan liiska cuntada arki karo.',
      context: 'restaurant',
    ),
    ExpressionSeed(
      id: 'expr_food_allergies_001',
      categoryCode: 'food',
      subcategoryCode: 'allergies',
      englishText: 'I am allergic to peanuts.',
      somaliText: 'Waxaan xasaasiyad ku qabaa lawska.',
      usageExplanation:
          'Use this before eating or ordering food that may contain peanuts.',
      exampleEnglish:
          'Before ordering dessert, I told the server I was allergic to peanuts.',
      exampleSomali:
          'Ka hor inta aanan macmacaan dalban, shaqaalaha waxaan u sheegay inaan lawska xasaasiyad ku qabo.',
      context: 'restaurant allergy',
    ),
    ExpressionSeed(
      id: 'expr_clothing_sizes_001',
      categoryCode: 'clothing',
      subcategoryCode: 'sizes',
      englishText: 'Do you have this shirt in a larger size?',
      somaliText: 'Shaatigan cabbir ka weyn ma haysaan?',
      usageExplanation:
          'Use this in a clothing shop when an item is too small.',
      exampleEnglish:
          'This one is too tight. Do you have this shirt in a larger size?',
      exampleSomali:
          'Kan aad buu iigu dhagan yahay. Shaatigan cabbir ka weyn ma haysaan?',
      context: 'clothing shop',
    ),
    ExpressionSeed(
      id: 'expr_clothing_returns_001',
      categoryCode: 'clothing',
      subcategoryCode: 'returns',
      englishText: 'Can I return these shoes if they do not fit?',
      somaliText: 'Kabahan ma celin karaa haddii aysan igu habboonaan?',
      usageExplanation:
          'Ask this before buying shoes when you are unsure about the fit.',
      exampleEnglish:
          'I kept the receipt because I might return the shoes if they did not fit.',
      exampleSomali:
          'Rasiidka waan haystay maxaa yeelay kabaha waan celin karaa haddii aysan igu habboonaan.',
      context: 'shoe shop',
    ),
    ExpressionSeed(
      id: 'expr_housing_rent_001',
      categoryCode: 'housing',
      subcategoryCode: 'rent',
      englishText: 'How much is the rent per month?',
      somaliText: 'Kiradu bishii waa imisa?',
      usageExplanation:
          'Use this when asking a landlord or agent about monthly rent.',
      exampleEnglish:
          'Before viewing the apartment, I asked how much the rent was per month.',
      exampleSomali:
          'Ka hor inta aanan aqalka daawan, waxaan weydiiyay kiradu bishii imisa tahay.',
      context: 'rental viewing',
    ),
    ExpressionSeed(
      id: 'expr_housing_repairs_001',
      categoryCode: 'housing',
      subcategoryCode: 'repairs',
      englishText: 'The heater is not working.',
      somaliText: 'Kuleyliyuhu ma shaqaynayo.',
      usageExplanation:
          'Use this to report a repair problem to a landlord, caretaker, or office.',
      exampleEnglish:
          'I called the landlord because the heater was not working.',
      exampleSomali:
          'Kireeyaha ayaan wacay maxaa yeelay kuleyliyuhu ma shaqaynayn.',
      context: 'repair request',
    ),
    ExpressionSeed(
      id: 'expr_jobs_applications_001',
      categoryCode: 'jobs',
      subcategoryCode: 'applications',
      englishText: 'I would like to apply for this job.',
      somaliText: 'Waxaan jeclaan lahaa inaan shaqadan codsado.',
      usageExplanation:
          'Use this when speaking to an employer or job center about an open position.',
      exampleEnglish:
          'After reading the advertisement, I said I would like to apply for this job.',
      exampleSomali:
          'Markii aan xayeysiiska akhriyey, waxaan iri waxaan jeclaan lahaa inaan shaqadan codsado.',
      context: 'job center',
    ),
    ExpressionSeed(
      id: 'expr_jobs_schedule_001',
      categoryCode: 'jobs',
      subcategoryCode: 'schedule',
      englishText: 'What are the working hours?',
      somaliText: 'Saacadaha shaqadu waa kuwee?',
      usageExplanation:
          'Ask this when you need to know the start time, end time, or shift pattern.',
      exampleEnglish:
          'During the interview, I asked what the working hours were.',
      exampleSomali:
          'Intii wareysigu socday, waxaan weydiiyay saacadaha shaqadu waxa ay yihiin.',
      context: 'interview',
    ),
    ExpressionSeed(
      id: 'expr_schools_enrollment_001',
      categoryCode: 'schools',
      subcategoryCode: 'enrollment',
      englishText: 'How do I enroll my child in this school?',
      somaliText: 'Sideen ilmahayga ugu diiwaangeliyaa iskuulkan?',
      usageExplanation:
          'Use this when asking a school office about registration steps.',
      exampleEnglish:
          'At the front office, I asked how to enroll my child in the school.',
      exampleSomali:
          'Xafiiska hore, waxaan weydiiyay sida ilmahayga loogu diiwaangeliyo iskuulka.',
      context: 'school office',
    ),
    ExpressionSeed(
      id: 'expr_schools_portal_001',
      categoryCode: 'schools',
      subcategoryCode: 'portal',
      englishText: 'I cannot log in to the school portal.',
      somaliText: 'Ma geli karo bogga iskuulka.',
      usageExplanation:
          'Use this when asking for help with a parent, student, or online class account.',
      exampleEnglish:
          'I called the office because I could not log in to the school portal.',
      exampleSomali:
          'Xafiiska ayaan wacay maxaa yeelay ma geli karin bogga iskuulka.',
      context: 'school technology',
    ),
  ];

  static const dialogues = <DialogueSeed>[
    DialogueSeed(
      id: 'dlg_language_barrier_interpreter_001',
      categoryCode: 'language_barrier',
      subcategoryCode: 'interpreter',
      englishTitle: 'Asking for an Interpreter',
      somaliTitle: 'Codsiga turjubaan',
      englishSituation:
          'A patient asks clinic staff for language help before an appointment.',
      somaliSituation:
          'Bukaan ayaa shaqaalaha xarunta caafimaadka ka codsanaya caawimo luqadeed.',
      lines: [
        DialogueLineSeed(
          'Patient',
          'Good morning. I have an appointment, but my English is limited.',
          'Subax wanaagsan. Ballan ayaan leeyahay, laakiin Ingiriisigaygu wuu kooban yahay.',
        ),
        DialogueLineSeed(
          'Receptionist',
          'That is all right. What language do you prefer?',
          'Dhib ma leh. Luqaddee ayaad doorbideysaa?',
        ),
        DialogueLineSeed(
          'Patient',
          'Somali, please. Is an interpreter available?',
          'Soomaali fadlan. Turjubaan ma la heli karaa?',
        ),
        DialogueLineSeed(
          'Receptionist',
          'Yes, I can request a phone interpreter for the nurse.',
          'Haa, kalkaalisada waxaan u codsan karaa turjubaan telefoon.',
        ),
        DialogueLineSeed(
          'Patient',
          'Thank you. I want to understand the instructions clearly.',
          'Mahadsanid. Waxaan rabaa inaan tilmaamaha si cad u fahmo.',
        ),
        DialogueLineSeed(
          'Receptionist',
          'Please wait here. I will add the note to your appointment.',
          'Fadlan halkan ku sug. Qoraalkaas ayaan ballantaada ku dari doonaa.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_etiquette_visit_001',
      categoryCode: 'etiquette',
      subcategoryCode: 'invitations',
      englishTitle: 'Visiting a Neighbor',
      somaliTitle: 'Booqashada deris',
      englishSituation:
          'A neighbor visits briefly and responds politely to tea.',
      somaliSituation:
          'Deris ayaa booqasho gaaban sameynaya oo si edeb leh uga jawaabaya shaah.',
      lines: [
        DialogueLineSeed(
          'Host',
          'Welcome. Please come in.',
          'Soo dhowow. Fadlan soo gal.',
        ),
        DialogueLineSeed(
          'Guest',
          'Thank you. I can only stay for a few minutes.',
          'Mahadsanid. Dhowr daqiiqo oo keliya ayaan joogi karaa.',
        ),
        DialogueLineSeed(
          'Host',
          'Would you like some tea?',
          'Shaah ma rabtaa?',
        ),
        DialogueLineSeed(
          'Guest',
          'Yes, please. That is very kind of you.',
          'Haa fadlan. Aad baad u naxariis badan tahay.',
        ),
        DialogueLineSeed(
          'Host',
          'How is your family?',
          'Qoyskaagu sidee buu yahay?',
        ),
        DialogueLineSeed(
          'Guest',
          'They are well, thank you for asking.',
          'Way fiican yihiin, waad ku mahadsan tahay weydiinta.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_personal_information_form_001',
      categoryCode: 'personal_information',
      subcategoryCode: 'forms',
      englishTitle: 'Correcting a Registration Form',
      somaliTitle: 'Sixidda foom diiwaangelin',
      englishSituation: 'A learner checks personal details on a service form.',
      somaliSituation: 'Arday ayaa hubinaya macluumaadkiisa foom adeeg.',
      lines: [
        DialogueLineSeed(
          'Clerk',
          'Please check your name and address before you sign.',
          'Fadlan hubi magacaaga iyo cinwaankaaga ka hor intaadan saxiixin.',
        ),
        DialogueLineSeed(
          'Applicant',
          'My street name is correct, but the apartment number is missing.',
          'Magaca waddadu waa sax, laakiin lambarka aqalka ayaa maqan.',
        ),
        DialogueLineSeed(
          'Clerk',
          'What is the apartment number?',
          'Lambarka aqalku waa imisa?',
        ),
        DialogueLineSeed(
          'Applicant',
          'It is apartment twelve B.',
          'Waa aqalka laba iyo toban B.',
        ),
        DialogueLineSeed(
          'Clerk',
          'I have updated it. Is your phone number current?',
          'Waan cusbooneysiiyay. Lambarkaaga telefoonku hadda ma shaqeeyaa?',
        ),
        DialogueLineSeed(
          'Applicant',
          'Yes, that is my current phone number.',
          'Haa, kaas waa lambarkayga telefoonka ee hadda.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_signs_safety_001',
      categoryCode: 'signs',
      subcategoryCode: 'safety',
      englishTitle: 'Understanding a Warning Sign',
      somaliTitle: 'Fahamka calaamad digniin',
      englishSituation: 'A customer asks about a warning sign in a hallway.',
      somaliSituation:
          'Macmiil ayaa wax ka weydiinaya calaamad digniin oo marinka taal.',
      lines: [
        DialogueLineSeed(
          'Customer',
          'Excuse me, does this sign mean the floor is wet?',
          'Iga raalli ahow, calaamaddani ma waxay ka dhigan tahay in dhulku qoyan yahay?',
        ),
        DialogueLineSeed(
          'Worker',
          'Yes. Please walk on the left side.',
          'Haa. Fadlan dhinaca bidix ka soco.',
        ),
        DialogueLineSeed(
          'Customer',
          'Is the restroom still open?',
          'Musqushu weli ma furan tahay?',
        ),
        DialogueLineSeed(
          'Worker',
          'Yes, but use the next hallway.',
          'Haa, laakiin isticmaal marinka xiga.',
        ),
        DialogueLineSeed(
          'Customer',
          'Thank you for explaining the sign.',
          'Waad ku mahadsan tahay sharaxaadda calaamadda.',
        ),
        DialogueLineSeed(
          'Worker',
          'You are welcome. Please be careful.',
          'Adaa mudan. Fadlan taxaddar.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_measures_groceries_001',
      categoryCode: 'measures',
      subcategoryCode: 'weight',
      englishTitle: 'Buying Rice by Weight',
      somaliTitle: 'Bariis miisaan lagu iibsanayo',
      englishSituation: 'A shopper checks weight and price before buying rice.',
      somaliSituation:
          'Qof wax iibsanaya ayaa hubinaya miisaanka iyo qiimaha bariiska.',
      lines: [
        DialogueLineSeed(
          'Shopper',
          'How many kilograms is this bag of rice?',
          'Bacdan bariiska ah waa imisa kiiloogaraam?',
        ),
        DialogueLineSeed(
          'Cashier',
          'It is five kilograms.',
          'Waa shan kiiloogaraam.',
        ),
        DialogueLineSeed(
          'Shopper',
          'Do you have a smaller bag?',
          'Bac ka yar ma haysaan?',
        ),
        DialogueLineSeed(
          'Cashier',
          'Yes, we have a two-kilogram bag on the lower shelf.',
          'Haa, bac laba kiiloogaraam ah ayaa shelf-ka hoose taal.',
        ),
        DialogueLineSeed(
          'Shopper',
          'That size is better for me.',
          'Cabbirkaas ayaa ii fiican.',
        ),
        DialogueLineSeed(
          'Cashier',
          'I will bring it to the counter.',
          'Miiska ayaan kuu keeni doonaa.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_numbers_phone_001',
      categoryCode: 'numbers',
      subcategoryCode: 'phone',
      englishTitle: 'Writing Down a Phone Number',
      somaliTitle: 'Qorista lambar telefoon',
      englishSituation: 'A caller writes a phone number digit by digit.',
      somaliSituation: 'Qof wacaya ayaa lambar telefoon mid mid u qoraya.',
      lines: [
        DialogueLineSeed(
          'Caller',
          'Could you read the phone number slowly?',
          'Lambarka telefoonka si tartiib ah ma u akhrin kartaa?',
        ),
        DialogueLineSeed(
          'Office',
          'Yes. It is zero seven, four two, nine nine.',
          'Haa. Waa eber toddoba, afar laba, sagaal sagaal.',
        ),
        DialogueLineSeed(
          'Caller',
          'Did you say four two or forty-two?',
          'Ma waxaad tiri afar laba mise afartan iyo labo?',
        ),
        DialogueLineSeed(
          'Office',
          'Four two, as separate digits.',
          'Afar laba, lambarro kala gooni ah.',
        ),
        DialogueLineSeed(
          'Caller',
          'Thank you. I have written it down.',
          'Mahadsanid. Waan qoray.',
        ),
        DialogueLineSeed(
          'Office',
          'Please call that number when you arrive.',
          'Fadlan lambarkaas wac markaad timaaddo.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_money_refund_001',
      categoryCode: 'money',
      subcategoryCode: 'receipts',
      englishTitle: 'Asking About a Refund',
      somaliTitle: 'Weydiinta lacag-celin',
      englishSituation: 'A customer asks whether an item can be returned.',
      somaliSituation: 'Macmiil ayaa weydiinaya haddii alaab la celin karo.',
      lines: [
        DialogueLineSeed(
          'Customer',
          'Can I return this item?',
          'Alaabtan ma celin karaa?',
        ),
        DialogueLineSeed(
          'Cashier',
          'Yes, but you need the receipt.',
          'Haa, laakiin waxaad u baahan tahay rasiidka.',
        ),
        DialogueLineSeed(
          'Customer',
          'I have a digital receipt on my phone.',
          'Telefoonkeyga ayaan ku hayaa rasiid dijitaal ah.',
        ),
        DialogueLineSeed(
          'Cashier',
          'That is fine. Please show me the order number.',
          'Waa hagaag. Fadlan i tus lambarka dalabka.',
        ),
        DialogueLineSeed(
          'Customer',
          'Will the money go back to my card?',
          'Lacagtu kaarkayga ma ku noqonaysaa?',
        ),
        DialogueLineSeed(
          'Cashier',
          'Yes, the refund usually takes three business days.',
          'Haa, lacag-celintu badanaa waxay qaadataa saddex maalmood oo shaqo.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_time_video_appointment_001',
      categoryCode: 'time',
      subcategoryCode: 'appointments',
      englishTitle: 'Confirming a Video Appointment',
      somaliTitle: 'Xaqiijinta ballan muuqaal ah',
      englishSituation:
          'A patient confirms the time and link for a video appointment.',
      somaliSituation:
          'Bukaan ayaa xaqiijinaya waqtiga iyo linkiga ballan muuqaal ah.',
      lines: [
        DialogueLineSeed(
          'Patient',
          'What time does the video appointment start?',
          'Ballanta muuqaalka ahi saacaddu meeqa ayay bilaabanaysaa?',
        ),
        DialogueLineSeed(
          'Clinic',
          'It starts at half past nine tomorrow morning.',
          'Waxay bilaabanaysaa berri subax sagaalka iyo badhka.',
        ),
        DialogueLineSeed(
          'Patient',
          'Will you send the link by text message?',
          'Linkiga farriin qoraal ah ma ku soo diri doontaan?',
        ),
        DialogueLineSeed(
          'Clinic',
          'Yes, you will receive it one hour before the appointment.',
          'Haa, waxaad heli doontaa hal saac ka hor ballanta.',
        ),
        DialogueLineSeed(
          'Patient',
          'Thank you. I will be ready on time.',
          'Mahadsanid. Waqtiga ayaan diyaar ahaan doonaa.',
        ),
        DialogueLineSeed(
          'Clinic',
          'Please call us if the link does not work.',
          'Fadlan na soo wac haddii linkigu shaqayn waayo.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_locating_bus_stop_001',
      categoryCode: 'locating',
      subcategoryCode: 'directions',
      englishTitle: 'Finding the Bus Stop',
      somaliTitle: 'Helidda joogsiga baska',
      englishSituation:
          'A visitor asks for the nearest bus stop after leaving a library.',
      somaliSituation:
          'Booqde ayaa weydiinaya joogsiga baska ee ugu dhow ka dib maktabad.',
      lines: [
        DialogueLineSeed(
          'Visitor',
          'Where is the nearest bus stop?',
          'Joogsiga baska ee ugu dhow xaggee ku yaal?',
        ),
        DialogueLineSeed(
          'Librarian',
          'Go out the main door and turn right.',
          'Ka bax albaabka weyn, ka dib midig u leexo.',
        ),
        DialogueLineSeed(
          'Visitor',
          'Is it on this side of the road?',
          'Dhinacan waddada ma ku yaal?',
        ),
        DialogueLineSeed(
          'Librarian',
          'No, it is across the road, next to the pharmacy.',
          'Maya, wuxuu ku yaal waddada dhinaceeda kale, farmashiyaha agtiisa.',
        ),
        DialogueLineSeed(
          'Visitor',
          'How long does it take to walk there?',
          'Intee ayay qaadanaysaa in halkaas loo lugeeyo?',
        ),
        DialogueLineSeed(
          'Librarian',
          'Only about three minutes.',
          'Qiyaastii saddex daqiiqo oo keliya.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_describing_repair_001',
      categoryCode: 'describing',
      subcategoryCode: 'condition',
      englishTitle: 'Describing a Broken Phone',
      somaliTitle: 'Sharaxaadda telefoon jaban',
      englishSituation: 'A customer explains phone damage at a repair shop.',
      somaliSituation:
          'Macmiil ayaa dukaanka dayactirka ku sharaxaya dhaawaca telefoonka.',
      lines: [
        DialogueLineSeed(
          'Customer',
          'The screen is cracked, and the battery runs out quickly.',
          'Shaashaddu way dillaacday, batteriguna si degdeg ah ayuu u dhammaadaa.',
        ),
        DialogueLineSeed(
          'Technician',
          'Did the phone fall in water?',
          'Telefoonku biyo ma ku dhacay?',
        ),
        DialogueLineSeed(
          'Customer',
          'No, it fell on the sidewalk yesterday.',
          'Maya, shalay ayuu laamiga ku dhacay.',
        ),
        DialogueLineSeed(
          'Technician',
          'The case is also loose on one side.',
          'Daboolkuna dhinac ayuu ka dabacsan yahay.',
        ),
        DialogueLineSeed(
          'Customer',
          'Can you repair it today?',
          'Maanta ma dayactiri kartaa?',
        ),
        DialogueLineSeed(
          'Technician',
          'I can replace the screen, but the battery will take longer.',
          'Shaashadda waan beddeli karaa, laakiin batterigu waqti dheeraad ah ayuu qaadanayaa.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_doing_things_library_001',
      categoryCode: 'doing_things',
      subcategoryCode: 'permission',
      englishTitle: 'Using a Library Computer',
      somaliTitle: 'Isticmaalka kombiyuutarka maktabadda',
      englishSituation:
          'A learner asks permission to use a public computer for an online form.',
      somaliSituation:
          'Arday ayaa codsanaya inuu kombiyuutar dadweyne u isticmaalo foom internet ah.',
      lines: [
        DialogueLineSeed(
          'Learner',
          'May I use this computer?',
          'Kombiyuutarkan ma isticmaali karaa?',
        ),
        DialogueLineSeed(
          'Librarian',
          'Yes. Do you have a library card?',
          'Haa. Kaarka maktabadda ma leedahay?',
        ),
        DialogueLineSeed(
          'Learner',
          'Yes, I need to complete an online form.',
          'Haa, waxaan u baahanahay inaan buuxiyo foom internet ah.',
        ),
        DialogueLineSeed(
          'Librarian',
          'You can use it for one hour.',
          'Hal saac ayaad isticmaali kartaa.',
        ),
        DialogueLineSeed(
          'Learner',
          'Can I print the confirmation page?',
          'Bogga xaqiijinta ma daabacan karaa?',
        ),
        DialogueLineSeed(
          'Librarian',
          'Yes, printing costs ten cents per page.',
          'Haa, daabacaaddu waxay ku kacaysaa toban senti boggiiba.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_going_places_taxi_001',
      categoryCode: 'going_places',
      subcategoryCode: 'taxi',
      englishTitle: 'Taking a Ride-Share Car',
      somaliTitle: 'Raacid adeeg gaari',
      englishSituation:
          'A passenger confirms the destination with a ride-share driver.',
      somaliSituation:
          'Rakaab ayaa darawal adeeg raacid ah la xaqiijinaya meesha loo socdo.',
      lines: [
        DialogueLineSeed(
          'Passenger',
          'Hello, are you here for Abdi?',
          'Salaan, ma waxaad u timid Cabdi?',
        ),
        DialogueLineSeed(
          'Driver',
          'Yes. Are you going to Central Hospital?',
          'Haa. Ma waxaad u socotaa Isbitaalka Dhexe?',
        ),
        DialogueLineSeed(
          'Passenger',
          'Yes, can you take me to this entrance?',
          'Haa, albaabkan ma i geyn kartaa?',
        ),
        DialogueLineSeed(
          'Driver',
          'Of course. I will follow the map.',
          'Dabcan. Khariidadda ayaan raaci doonaa.',
        ),
        DialogueLineSeed(
          'Passenger',
          'Please drop me near the emergency door.',
          'Fadlan igu deji albaabka gurmadka agtiisa.',
        ),
        DialogueLineSeed(
          'Driver',
          'No problem. It should take about fifteen minutes.',
          'Dhib ma leh. Waxay qaadan doontaa qiyaastii shan iyo toban daqiiqo.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_conveying_information_email_001',
      categoryCode: 'conveying_information',
      subcategoryCode: 'email',
      englishTitle: 'Sending a Document by Email',
      somaliTitle: 'Dukumenti iimayl lagu dirayo',
      englishSituation:
          'An applicant confirms how to send a document to an office.',
      somaliSituation:
          'Qof codsanaya ayaa xaqiijinaya sida dukumenti xafiis loogu diro.',
      lines: [
        DialogueLineSeed(
          'Applicant',
          'I will send the document by email today.',
          'Dukumentiga maanta iimayl ayaan ku soo diri doonaa.',
        ),
        DialogueLineSeed(
          'Officer',
          'Please include your case number in the subject line.',
          'Fadlan lambarka kiiska ku qor cinwaanka iimaylka.',
        ),
        DialogueLineSeed(
          'Applicant',
          'Should I attach a photo or a PDF?',
          'Sawir miyaan ku lifaaqaa mise PDF?',
        ),
        DialogueLineSeed(
          'Officer',
          'A clear PDF is best.',
          'PDF cad ayaa ugu fiican.',
        ),
        DialogueLineSeed(
          'Applicant',
          'I will send it before five oclock.',
          'Waxaan diri doonaa ka hor shanta saac.',
        ),
        DialogueLineSeed(
          'Officer',
          'You will receive a confirmation email.',
          'Waxaad heli doontaa iimayl xaqiijin ah.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_health_hygiene_pharmacy_001',
      categoryCode: 'health_hygiene',
      subcategoryCode: 'medicine',
      englishTitle: 'At a Pharmacy',
      somaliTitle: 'Farmashiyaha dhexdiisa',
      englishSituation:
          'A customer asks a pharmacist about symptoms and medicine instructions.',
      somaliSituation:
          'Macmiil ayaa farmashiistaha weydiinaya calaamado iyo tilmaamaha daawada.',
      lines: [
        DialogueLineSeed(
          'Customer',
          'I have had a headache since this morning.',
          'Madax ayaa i xanuunayay ilaa saaka.',
        ),
        DialogueLineSeed(
          'Pharmacist',
          'Do you have a fever or any other symptoms?',
          'Qandho ama calaamado kale ma leedahay?',
        ),
        DialogueLineSeed(
          'Customer',
          'No, I only have a headache.',
          'Maya, madax-xanuun keliya ayaan qabaa.',
        ),
        DialogueLineSeed(
          'Pharmacist',
          'Are you allergic to any medicine?',
          'Ma jirtaa daawo aad xasaasiyad ku leedahay?',
        ),
        DialogueLineSeed(
          'Customer',
          'No, not that I know of.',
          'Maya, inta aan ogahay ma jirto.',
        ),
        DialogueLineSeed(
          'Pharmacist',
          'Take this after food, and speak to a doctor if the pain continues.',
          'Tan qaado cuntada ka dib, dhakhtarna la hadal haddii xanuunku sii socdo.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_food_restaurant_001',
      categoryCode: 'food',
      subcategoryCode: 'restaurant',
      englishTitle: 'Ordering Lunch',
      somaliTitle: 'Dalbashada qado',
      englishSituation: 'A customer orders lunch and asks about ingredients.',
      somaliSituation:
          'Macmiil ayaa qado dalbanaya oo maaddooyinka weydiinaya.',
      lines: [
        DialogueLineSeed(
          'Server',
          'Are you ready to order?',
          'Ma diyaar baad u tahay inaad dalbato?',
        ),
        DialogueLineSeed(
          'Customer',
          'Could I have the chicken with rice, please?',
          'Fadlan digaagga bariiska leh ma heli karaa?',
        ),
        DialogueLineSeed(
          'Server',
          'Would you like salad with that?',
          'Saladh ma la rabtaa?',
        ),
        DialogueLineSeed(
          'Customer',
          'Yes, but no peanuts. I am allergic to peanuts.',
          'Haa, laakiin laws ha ku darin. Waxaan xasaasiyad ku qabaa lawska.',
        ),
        DialogueLineSeed(
          'Server',
          'I will tell the kitchen.',
          'Jikada ayaan u sheegi doonaa.',
        ),
        DialogueLineSeed(
          'Customer',
          'Thank you. Could I also have water?',
          'Mahadsanid. Biyona ma heli karaa?',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_clothing_shirt_001',
      categoryCode: 'clothing',
      subcategoryCode: 'sizes',
      englishTitle: 'Looking for a Larger Shirt',
      somaliTitle: 'Raadinta shaar ka weyn',
      englishSituation: 'A customer asks for a different shirt size.',
      somaliSituation: 'Macmiil ayaa codsanaya shaar cabbir kale ah.',
      lines: [
        DialogueLineSeed(
          'Customer',
          'Do you have this shirt in a larger size?',
          'Shaatigan cabbir ka weyn ma haysaan?',
        ),
        DialogueLineSeed(
          'Assistant',
          'Yes, we have medium and large.',
          'Haa, cabbir dhexe iyo weyn waan haynaa.',
        ),
        DialogueLineSeed(
          'Customer',
          'Could I try the large one?',
          'Kan weyn ma tijaabin karaa?',
        ),
        DialogueLineSeed(
          'Assistant',
          'Of course. The fitting room is on the left.',
          'Dabcan. Qolka tijaabadu bidix ayuu ku yaal.',
        ),
        DialogueLineSeed(
          'Customer',
          'If it does not fit, can I return it?',
          'Haddii uusan igu habboonaan, ma celin karaa?',
        ),
        DialogueLineSeed(
          'Assistant',
          'Yes, keep the receipt.',
          'Haa, rasiidka hayso.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_housing_rent_001',
      categoryCode: 'housing',
      subcategoryCode: 'rent',
      englishTitle: 'Asking About Rent',
      somaliTitle: 'Weydiinta kirada',
      englishSituation:
          'A tenant asks a landlord about monthly rent and deposit.',
      somaliSituation:
          'Kireyste ayaa kireeye ka weydiinaya kirada billaha ah iyo dammaanadda.',
      lines: [
        DialogueLineSeed(
          'Tenant',
          'How much is the rent per month?',
          'Kiradu bishii waa imisa?',
        ),
        DialogueLineSeed(
          'Landlord',
          'It is six hundred dollars, not including electricity.',
          'Waa lix boqol oo doollar, korontaduna kuma jirto.',
        ),
        DialogueLineSeed(
          'Tenant',
          'Is there a security deposit?',
          'Ma jirtaa lacag dammaanad ah?',
        ),
        DialogueLineSeed(
          'Landlord',
          'Yes, the deposit is one month rent.',
          'Haa, dammaanaddu waa kirada hal bil.',
        ),
        DialogueLineSeed(
          'Tenant',
          'When would the lease start?',
          'Heshiiska kiradu goormuu bilaabanayaa?',
        ),
        DialogueLineSeed(
          'Landlord',
          'It can start on the first day of next month.',
          'Wuxuu bilaaban karaa maalinta koowaad ee bisha soo socota.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_jobs_interview_001',
      categoryCode: 'jobs',
      subcategoryCode: 'interviews',
      englishTitle: 'At a Job Interview',
      somaliTitle: 'Wareysi shaqo',
      englishSituation:
          'An applicant answers basic questions in a job interview.',
      somaliSituation:
          'Qof shaqo codsanaya ayaa ka jawaabaya sualo aasaasi ah oo wareysi ah.',
      lines: [
        DialogueLineSeed(
          'Interviewer',
          'Why would you like this job?',
          'Maxaad shaqadan u rabtaa?',
        ),
        DialogueLineSeed(
          'Applicant',
          'I have experience with customers, and I can work evenings.',
          'Khibrad ayaan u leeyahay macaamiisha, fiidkiina waan shaqayn karaa.',
        ),
        DialogueLineSeed(
          'Interviewer',
          'Are you available on weekends?',
          'Maalmaha fasaxa toddobaadka ma diyaar baad tahay?',
        ),
        DialogueLineSeed(
          'Applicant',
          'Yes, I am available on Saturday.',
          'Haa, Sabtida waan diyaar ahay.',
        ),
        DialogueLineSeed(
          'Interviewer',
          'Do you have a resume with you?',
          'CV ma wadataa?',
        ),
        DialogueLineSeed(
          'Applicant',
          'Yes, I also uploaded it on the application website.',
          'Haa, sidoo kale bogga codsiga ayaan geliyay.',
        ),
      ],
    ),
    DialogueSeed(
      id: 'dlg_schools_portal_001',
      categoryCode: 'schools',
      subcategoryCode: 'portal',
      englishTitle: 'Using the School Portal',
      somaliTitle: 'Isticmaalka bogga iskuulka',
      englishSituation:
          'A parent asks for help logging in to the school portal.',
      somaliSituation:
          'Waalid ayaa caawimo ka codsanaya gelitaanka bogga iskuulka.',
      lines: [
        DialogueLineSeed(
          'Parent',
          'I cannot log in to the school portal.',
          'Ma geli karo bogga iskuulka.',
        ),
        DialogueLineSeed(
          'Secretary',
          'Do you know your email address for the account?',
          'Ma taqaannaa cinwaanka iimaylka ee akoonka?',
        ),
        DialogueLineSeed(
          'Parent',
          'Yes, but I forgot the password.',
          'Haa, laakiin erayga sirta ah waan ilaaway.',
        ),
        DialogueLineSeed(
          'Secretary',
          'I can send a password reset link.',
          'Waxaan kuu diri karaa link lagu beddelo erayga sirta ah.',
        ),
        DialogueLineSeed(
          'Parent',
          'Thank you. I need to check my child attendance.',
          'Mahadsanid. Waxaan u baahanahay inaan hubiyo xaadiriska ilmahayga.',
        ),
        DialogueLineSeed(
          'Secretary',
          'You will be able to see attendance and homework there.',
          'Halkaas waxaad ka arki doontaa xaadiriska iyo layliska.',
        ),
      ],
    ),
  ];

  static const qaPairs = <QaSeed>[
    QaSeed(
      id: 'qa_language_barrier_001',
      categoryCode: 'language_barrier',
      subcategoryCode: 'meaning',
      englishQuestion: 'What does this word mean?',
      somaliQuestion: 'Eraygani muxuu ka dhigan yahay?',
      englishAnswer: 'It means you must sign your name here.',
      somaliAnswer: 'Waxay ka dhigan tahay inaad magacaaga halkan ku saxiixdo.',
      relatedVocabulary: 'mean, sign',
    ),
    QaSeed(
      id: 'qa_language_barrier_002',
      categoryCode: 'language_barrier',
      subcategoryCode: 'spelling',
      englishQuestion: 'Could you spell your last name?',
      somaliQuestion: 'Magacaaga dambe ma higgaadin kartaa?',
      englishAnswer: 'Yes, it is A-B-D-I.',
      somaliAnswer: 'Haa, waa A-B-D-I.',
      relatedVocabulary: 'spell, last name',
    ),
    QaSeed(
      id: 'qa_etiquette_001',
      categoryCode: 'etiquette',
      subcategoryCode: 'thanks',
      englishQuestion: 'How can I thank the teacher politely?',
      somaliQuestion: 'Sideen macallinka si edeb leh ugu mahadcelin karaa?',
      englishAnswer: 'You can say, "Thank you for your help."',
      somaliAnswer:
          'Waxaad oran kartaa, "Waad ku mahadsan tahay caawimadaada."',
      relatedVocabulary: 'thank, help',
    ),
    QaSeed(
      id: 'qa_etiquette_002',
      categoryCode: 'etiquette',
      subcategoryCode: 'apologies',
      englishQuestion: 'What should I say if I interrupt someone?',
      somaliQuestion: 'Maxaan iraahdaa haddii aan qof hadalkiisa dhex galo?',
      englishAnswer: 'Say, "Sorry to interrupt."',
      somaliAnswer: 'Dheh, "Waan ka xumahay inaan hadalka kaa dhex galay."',
      relatedVocabulary: 'interrupt, sorry',
    ),
    QaSeed(
      id: 'qa_personal_information_001',
      categoryCode: 'personal_information',
      subcategoryCode: 'contact',
      englishQuestion: 'What is your current phone number?',
      somaliQuestion: 'Lambarkaaga telefoonka ee hadda waa imisa?',
      englishAnswer: 'My current phone number is written on the form.',
      somaliAnswer:
          'Lambarkayga telefoonka ee hadda foomka ayuu ku qoran yahay.',
      relatedVocabulary: 'phone number',
    ),
    QaSeed(
      id: 'qa_personal_information_002',
      categoryCode: 'personal_information',
      subcategoryCode: 'family',
      englishQuestion: 'Who should we contact in an emergency?',
      somaliQuestion: 'Yaan la xiriirnaa xaalad degdeg ah?',
      englishAnswer: 'Please contact my sister.',
      somaliAnswer: 'Fadlan walaashay la xiriira.',
      relatedVocabulary: 'emergency contact',
    ),
    QaSeed(
      id: 'qa_signs_001',
      categoryCode: 'signs',
      subcategoryCode: 'access',
      englishQuestion: 'Where is the exit?',
      somaliQuestion: 'Albaabka laga baxo xaggee ku yaal?',
      englishAnswer: 'The exit is at the end of the hallway.',
      somaliAnswer: 'Albaabka laga baxo wuxuu ku yaal dhammaadka marinka.',
      relatedVocabulary: 'exit, hallway',
    ),
    QaSeed(
      id: 'qa_signs_002',
      categoryCode: 'signs',
      subcategoryCode: 'rules',
      englishQuestion: 'Can I smoke here?',
      somaliQuestion: 'Halkan sigaar ma ku cabbi karaa?',
      englishAnswer: 'No, this is a no-smoking area.',
      somaliAnswer: 'Maya, meeshan sigaar cabbid lama oggola.',
      relatedVocabulary: 'no smoking',
    ),
    QaSeed(
      id: 'qa_measures_001',
      categoryCode: 'measures',
      subcategoryCode: 'length',
      englishQuestion: 'How tall is the shelf?',
      somaliQuestion: 'Shelf-ku dhererkiisu waa imisa?',
      englishAnswer: 'It is two meters tall.',
      somaliAnswer: 'Waa labo mitir dherer ahaan.',
      relatedVocabulary: 'meter',
    ),
    QaSeed(
      id: 'qa_measures_002',
      categoryCode: 'measures',
      subcategoryCode: 'volume',
      englishQuestion: 'How many liters of water do you need?',
      somaliQuestion: 'Imisa litir oo biyo ah ayaad u baahan tahay?',
      englishAnswer: 'I need two liters.',
      somaliAnswer: 'Waxaan u baahanahay labo litir.',
      relatedVocabulary: 'liter',
    ),
    QaSeed(
      id: 'qa_numbers_001',
      categoryCode: 'numbers',
      subcategoryCode: 'dates',
      englishQuestion: 'What is your date of birth?',
      somaliQuestion: 'Taariikhda dhalashadaadu waa goorma?',
      englishAnswer: 'It is May fifth, nineteen ninety-eight.',
      somaliAnswer: 'Waa shanta May, kun sagaal boqol sagaashan iyo siddeed.',
      relatedVocabulary: 'date of birth',
    ),
    QaSeed(
      id: 'qa_numbers_002',
      categoryCode: 'numbers',
      subcategoryCode: 'percentages',
      englishQuestion: 'What does fifty percent mean?',
      somaliQuestion: 'Boqolkiiba konton maxay ka dhigan tahay?',
      englishAnswer: 'It means half of the total amount.',
      somaliAnswer: 'Waxay ka dhigan tahay nus ka mid ah qaddarka oo dhan.',
      relatedVocabulary: 'percent, half',
    ),
    QaSeed(
      id: 'qa_money_001',
      categoryCode: 'money',
      subcategoryCode: 'prices',
      englishQuestion: 'How much does this cost?',
      somaliQuestion: 'Tani waa imisa?',
      englishAnswer: 'It costs twelve dollars.',
      somaliAnswer: 'Waxay ku kacaysaa laba iyo toban doollar.',
      relatedVocabulary: 'cost, dollars',
    ),
    QaSeed(
      id: 'qa_money_002',
      categoryCode: 'money',
      subcategoryCode: 'bank',
      englishQuestion: 'Can I open a bank account here?',
      somaliQuestion: 'Halkan akoon bangi ma ka furan karaa?',
      englishAnswer: 'Yes, but you need photo identification.',
      somaliAnswer: 'Haa, laakiin waxaad u baahan tahay aqoonsi sawir leh.',
      relatedVocabulary: 'bank account, identification',
    ),
    QaSeed(
      id: 'qa_time_001',
      categoryCode: 'time',
      subcategoryCode: 'schedule',
      englishQuestion: 'When does the class finish?',
      somaliQuestion: 'Fasalku goormuu dhammaanayaa?',
      englishAnswer: 'It finishes at three oclock.',
      somaliAnswer: 'Wuxuu dhammaanayaa saddexda saac.',
      relatedVocabulary: 'finish, class',
    ),
    QaSeed(
      id: 'qa_time_002',
      categoryCode: 'time',
      subcategoryCode: 'frequency',
      englishQuestion: 'How often do the buses come?',
      somaliQuestion: 'Basasku intee jeer bay yimaadaan?',
      englishAnswer: 'They come every twenty minutes.',
      somaliAnswer: 'Waxay yimaadaan labaatan daqiiqo kasta.',
      relatedVocabulary: 'every, minutes',
    ),
    QaSeed(
      id: 'qa_locating_001',
      categoryCode: 'locating',
      subcategoryCode: 'inside',
      englishQuestion: 'Where is the reception desk?',
      somaliQuestion: 'Miiska soo-dhaweyntu xaggee ku yaal?',
      englishAnswer: 'It is next to the main entrance.',
      somaliAnswer: 'Wuxuu ku yaal albaabka weyn agtiisa.',
      relatedVocabulary: 'reception, entrance',
    ),
    QaSeed(
      id: 'qa_locating_002',
      categoryCode: 'locating',
      subcategoryCode: 'nearby',
      englishQuestion: 'Is there a pharmacy near here?',
      somaliQuestion: 'Farmashiye halkan u dhow ma jiraa?',
      englishAnswer: 'Yes, there is one across the street.',
      somaliAnswer: 'Haa, mid ayaa ku yaal waddada dhinaceeda kale.',
      relatedVocabulary: 'pharmacy, near',
    ),
    QaSeed(
      id: 'qa_describing_001',
      categoryCode: 'describing',
      subcategoryCode: 'appearance',
      englishQuestion: 'What does the person look like?',
      somaliQuestion: 'Qofku muuqaalkiisu sidee buu yahay?',
      englishAnswer: 'She is tall and is wearing a blue coat.',
      somaliAnswer: 'Way dheer tahay, waxayna xiran tahay jaakad buluug ah.',
      relatedVocabulary: 'tall, coat',
    ),
    QaSeed(
      id: 'qa_describing_002',
      categoryCode: 'describing',
      subcategoryCode: 'weather',
      englishQuestion: 'What is the weather like today?',
      somaliQuestion: 'Cimiladu maanta sidee tahay?',
      englishAnswer: 'It is cold and windy.',
      somaliAnswer: 'Waa qabow oo dabayl leh.',
      relatedVocabulary: 'cold, windy',
    ),
    QaSeed(
      id: 'qa_doing_things_001',
      categoryCode: 'doing_things',
      subcategoryCode: 'ability',
      englishQuestion: 'Can you complete the form online?',
      somaliQuestion: 'Foomka internetka ma ku buuxin kartaa?',
      englishAnswer: 'Yes, I can complete it on my phone.',
      somaliAnswer: 'Haa, telefoonkeyga ayaan ku buuxin karaa.',
      relatedVocabulary: 'complete, online',
    ),
    QaSeed(
      id: 'qa_doing_things_002',
      categoryCode: 'doing_things',
      subcategoryCode: 'preferences',
      englishQuestion: 'Would you rather call or send a message?',
      somaliQuestion: 'Ma wici lahayd mise farriin ayaad diri lahayd?',
      englishAnswer: 'I would rather send a text message.',
      somaliAnswer: 'Waxaan doorbidayaa inaan farriin qoraal ah diro.',
      relatedVocabulary: 'rather, text message',
    ),
    QaSeed(
      id: 'qa_going_places_001',
      categoryCode: 'going_places',
      subcategoryCode: 'bus',
      englishQuestion: 'Which bus goes downtown?',
      somaliQuestion: 'Baskee tagaa bartamaha magaalada?',
      englishAnswer: 'Bus number eight goes downtown.',
      somaliAnswer: 'Baska lambarka siddeed ayaa tagaa bartamaha magaalada.',
      relatedVocabulary: 'downtown, bus',
    ),
    QaSeed(
      id: 'qa_going_places_002',
      categoryCode: 'going_places',
      subcategoryCode: 'airport',
      englishQuestion: 'Where do I check in for this flight?',
      somaliQuestion: 'Xaggee ayaan iska diiwaangeliyaa duulimaadkan?',
      englishAnswer: 'Check in at counter C.',
      somaliAnswer: 'Iska diiwaangeli miiska C.',
      relatedVocabulary: 'check in, flight',
    ),
    QaSeed(
      id: 'qa_conveying_information_001',
      categoryCode: 'conveying_information',
      subcategoryCode: 'messages',
      englishQuestion: 'Did you receive my text message?',
      somaliQuestion: 'Ma heshay farriintayda qoraalka ah?',
      englishAnswer: 'Yes, I received it this morning.',
      somaliAnswer: 'Haa, saaka ayaan helay.',
      relatedVocabulary: 'receive, text message',
    ),
    QaSeed(
      id: 'qa_conveying_information_002',
      categoryCode: 'conveying_information',
      subcategoryCode: 'instructions',
      englishQuestion: 'Can you explain the next step?',
      somaliQuestion: 'Tallaabada xigta ma sharxi kartaa?',
      englishAnswer: 'First upload the document, then press submit.',
      somaliAnswer: 'Marka hore dukumentiga geli, ka dib riix gudbi.',
      relatedVocabulary: 'upload, submit',
    ),
    QaSeed(
      id: 'qa_health_hygiene_001',
      categoryCode: 'health_hygiene',
      subcategoryCode: 'symptoms',
      englishQuestion: 'Do you have a fever?',
      somaliQuestion: 'Qandho ma leedahay?',
      englishAnswer: 'Yes, my temperature is high.',
      somaliAnswer: 'Haa, heerkulkaygu wuu sarreeyaa.',
      relatedVocabulary: 'fever, temperature',
    ),
    QaSeed(
      id: 'qa_health_hygiene_002',
      categoryCode: 'health_hygiene',
      subcategoryCode: 'hygiene',
      englishQuestion: 'Where can I wash my hands?',
      somaliQuestion: 'Xaggee ayaan gacmahayga ku dhaqi karaa?',
      englishAnswer: 'The sink is beside the restroom.',
      somaliAnswer: 'Saxanku wuxuu ku yaal musqusha agteeda.',
      relatedVocabulary: 'wash, sink',
    ),
    QaSeed(
      id: 'qa_food_001',
      categoryCode: 'food',
      subcategoryCode: 'halal',
      englishQuestion: 'Is the meat halal?',
      somaliQuestion: 'Hilibku xalaal ma yahay?',
      englishAnswer: 'Yes, the restaurant uses halal meat.',
      somaliAnswer: 'Haa, maqaayaddu waxay isticmaashaa hilib xalaal ah.',
      relatedVocabulary: 'halal, meat',
    ),
    QaSeed(
      id: 'qa_food_002',
      categoryCode: 'food',
      subcategoryCode: 'restaurant',
      englishQuestion: 'Could we have the bill, please?',
      somaliQuestion: 'Fadlan biilka ma heli karnaa?',
      englishAnswer: 'Yes, I will bring it now.',
      somaliAnswer: 'Haa, hadda ayaan keeni doonaa.',
      relatedVocabulary: 'bill',
    ),
    QaSeed(
      id: 'qa_clothing_001',
      categoryCode: 'clothing',
      subcategoryCode: 'fit',
      englishQuestion: 'Does this jacket fit well?',
      somaliQuestion: 'Jaakaddani si fiican ma kuu le eg tahay?',
      englishAnswer: 'The sleeves are too long.',
      somaliAnswer: 'Gacmuhu aad bay u dhaadheer yihiin.',
      relatedVocabulary: 'sleeves, fit',
    ),
    QaSeed(
      id: 'qa_clothing_002',
      categoryCode: 'clothing',
      subcategoryCode: 'laundry',
      englishQuestion: 'Can this sweater go in the dryer?',
      somaliQuestion: 'Funaanaddan dhogorta ah qalajiyaha ma geli kartaa?',
      englishAnswer: 'No, it should dry flat.',
      somaliAnswer: 'Maya, waa in si fidsan loo qalajiyaa.',
      relatedVocabulary: 'dryer, sweater',
    ),
    QaSeed(
      id: 'qa_housing_001',
      categoryCode: 'housing',
      subcategoryCode: 'utilities',
      englishQuestion: 'Are utilities included in the rent?',
      somaliQuestion: 'Biilasha adeeggu kirada ma ku jiraan?',
      englishAnswer: 'Water is included, but electricity is separate.',
      somaliAnswer: 'Biyaha way ku jiraan, laakiin korontadu waa gooni.',
      relatedVocabulary: 'utilities, electricity',
    ),
    QaSeed(
      id: 'qa_housing_002',
      categoryCode: 'housing',
      subcategoryCode: 'repairs',
      englishQuestion: 'When will the plumber come?',
      somaliQuestion: 'Tuubistehu goormuu imanayaa?',
      englishAnswer: 'The plumber will come tomorrow morning.',
      somaliAnswer: 'Tuubistehu berri subax ayuu imanayaa.',
      relatedVocabulary: 'plumber',
    ),
    QaSeed(
      id: 'qa_jobs_001',
      categoryCode: 'jobs',
      subcategoryCode: 'interviews',
      englishQuestion: 'When is the interview?',
      somaliQuestion: 'Wareysigu waa goorma?',
      englishAnswer: 'The interview is on Monday at ten.',
      somaliAnswer: 'Wareysigu waa Isniinta tobanka saac.',
      relatedVocabulary: 'interview',
    ),
    QaSeed(
      id: 'qa_jobs_002',
      categoryCode: 'jobs',
      subcategoryCode: 'schedule',
      englishQuestion: 'How much is the hourly wage?',
      somaliQuestion: 'Mushaharka saacaddii waa imisa?',
      englishAnswer: 'The hourly wage is fifteen dollars.',
      somaliAnswer: 'Mushaharka saacaddii waa shan iyo toban doollar.',
      relatedVocabulary: 'hourly wage',
    ),
    QaSeed(
      id: 'qa_schools_001',
      categoryCode: 'schools',
      subcategoryCode: 'attendance',
      englishQuestion: 'Why was my child marked absent?',
      somaliQuestion: 'Maxaa ilmahayga loogu calaamadeeyay maqane?',
      englishAnswer: 'The teacher did not receive the absence note.',
      somaliAnswer: 'Macallinku ma helin qoraalka maqnaanshaha.',
      relatedVocabulary: 'absent, note',
    ),
    QaSeed(
      id: 'qa_schools_002',
      categoryCode: 'schools',
      subcategoryCode: 'homework',
      englishQuestion: 'Where can I see the homework?',
      somaliQuestion: 'Xaggee ayaan ka arki karaa layliska?',
      englishAnswer: 'You can see it on the school portal.',
      somaliAnswer: 'Waxaad ka arki kartaa bogga iskuulka.',
      relatedVocabulary: 'homework, portal',
    ),
  ];

  static const vocabulary = <VocabularySeed>[
    VocabularySeed(
      id: 'vocab_appointment',
      categoryCode: 'time',
      subcategoryCode: 'appointments',
      englishHeadword: 'appointment',
      somaliHeadword: 'ballan',
      partOfSpeech: 'noun',
      englishDefinition:
          'A planned meeting with a person or service at a specific time.',
      somaliExplanation:
          'Ballan waa kulan ama adeeg horay loogu heshiiyay waqti gaar ah.',
      exampleEnglish: 'My appointment starts at nine thirty.',
      exampleSomali: 'Ballankaygu wuxuu bilaabanayaa sagaalka iyo badhka.',
      pluralForm: 'appointments',
    ),
    VocabularySeed(
      id: 'vocab_repeat',
      categoryCode: 'language_barrier',
      subcategoryCode: 'repeat',
      englishHeadword: 'repeat',
      somaliHeadword: 'ku celi',
      partOfSpeech: 'verb',
      englishDefinition: 'To say or do something again.',
      somaliExplanation:
          'Ku celi waxaa la yiraahdaa marka wax mar kale la sheegayo ama la sameynayo.',
      exampleEnglish: 'Please repeat the address slowly.',
      exampleSomali: 'Fadlan cinwaanka si tartiib ah ugu celi.',
      pastForm: 'repeated',
      pastParticiple: 'repeated',
    ),
    VocabularySeed(
      id: 'vocab_interpreter',
      categoryCode: 'language_barrier',
      subcategoryCode: 'interpreter',
      englishHeadword: 'interpreter',
      somaliHeadword: 'turjubaan',
      partOfSpeech: 'noun',
      englishDefinition:
          'A person who changes spoken words from one language into another.',
      somaliExplanation:
          'Turjubaan waa qof hadalka luqad ka beddela oo luqad kale u gudbiya.',
      exampleEnglish: 'The clinic arranged an interpreter for the appointment.',
      exampleSomali:
          'Xarunta caafimaadku waxay ballanta u diyaarisay turjubaan.',
      pluralForm: 'interpreters',
    ),
    VocabularySeed(
      id: 'vocab_greeting',
      categoryCode: 'etiquette',
      subcategoryCode: 'greetings',
      englishHeadword: 'greeting',
      somaliHeadword: 'salaan',
      partOfSpeech: 'noun',
      englishDefinition: 'Words or actions used when meeting someone.',
      somaliExplanation:
          'Salaan waa erayo ama ficil lagu bilaabo la kulanka qof.',
      exampleEnglish:
          'A friendly greeting can make a new neighbor feel welcome.',
      exampleSomali:
          'Salaan saaxiibtinimo leh waxay deris cusub dareensiin kartaa soo-dhaweyn.',
      pluralForm: 'greetings',
    ),
    VocabularySeed(
      id: 'vocab_apology',
      categoryCode: 'etiquette',
      subcategoryCode: 'apologies',
      englishHeadword: 'apology',
      somaliHeadword: 'raalli-gelin',
      partOfSpeech: 'noun',
      englishDefinition:
          'Words that show you are sorry for a mistake or problem.',
      somaliExplanation:
          'Raalli-gelin waa hadal muujinaya inaad ka xun tahay khalad ama dhibaato.',
      exampleEnglish: 'She gave an apology for arriving late.',
      exampleSomali: 'Waxay bixisay raalli-gelin maadaama ay soo daahday.',
      pluralForm: 'apologies',
    ),
    VocabularySeed(
      id: 'vocab_address',
      categoryCode: 'personal_information',
      subcategoryCode: 'contact',
      englishHeadword: 'address',
      somaliHeadword: 'cinwaan',
      partOfSpeech: 'noun',
      englishDefinition:
          'The details that show where a person lives or where a place is located.',
      somaliExplanation:
          'Cinwaan waa faahfaahinta muujisa meesha qof deggan yahay ama meel ku taallo.',
      exampleEnglish: 'Please write your current address on the form.',
      exampleSomali: 'Fadlan foomka ku qor cinwaankaaga hadda.',
      pluralForm: 'addresses',
    ),
    VocabularySeed(
      id: 'vocab_signature',
      categoryCode: 'personal_information',
      subcategoryCode: 'forms',
      englishHeadword: 'signature',
      somaliHeadword: 'saxiix',
      partOfSpeech: 'noun',
      englishDefinition:
          'Your name written in your own way to approve or confirm a document.',
      somaliExplanation:
          'Saxiix waa magacaaga oo aad si gaar ah u qorto si aad dukumenti u xaqiijiso.',
      exampleEnglish: 'The form needs your signature at the bottom.',
      exampleSomali: 'Foomku wuxuu u baahan yahay saxiixaaga xagga hoose.',
      pluralForm: 'signatures',
    ),
    VocabularySeed(
      id: 'vocab_entrance',
      categoryCode: 'signs',
      subcategoryCode: 'access',
      englishHeadword: 'entrance',
      somaliHeadword: 'albaab laga galo',
      partOfSpeech: 'noun',
      englishDefinition: 'The place where people go into a building or area.',
      somaliExplanation:
          'Albaab laga galo waa meesha qofku ka soo galo dhisme ama goob.',
      exampleEnglish: 'The entrance is beside the parking lot.',
      exampleSomali: 'Albaabka laga galo wuxuu ku yaal baarkinka agtiisa.',
      pluralForm: 'entrances',
    ),
    VocabularySeed(
      id: 'vocab_caution',
      categoryCode: 'signs',
      subcategoryCode: 'safety',
      englishHeadword: 'caution',
      somaliHeadword: 'taxaddar',
      partOfSpeech: 'noun',
      englishDefinition:
          'Care taken to avoid danger or a warning to be careful.',
      somaliExplanation:
          'Taxaddar waa feejignaan lagu iska ilaaliyo khatar ama digniin in si dhow loo socdo.',
      exampleEnglish: 'Use caution because the floor is wet.',
      exampleSomali: 'Taxaddar samee maxaa yeelay dhulku wuu qoyan yahay.',
    ),
    VocabularySeed(
      id: 'vocab_kilogram',
      categoryCode: 'measures',
      subcategoryCode: 'weight',
      englishHeadword: 'kilogram',
      somaliHeadword: 'kiiloogaraam',
      partOfSpeech: 'noun',
      englishDefinition: 'A metric unit used to measure weight.',
      somaliExplanation:
          'Kiiloogaraam waa cutub miisaan oo lagu cabbiro culayska.',
      exampleEnglish: 'This bag weighs five kilograms.',
      exampleSomali: 'Bacdan waxay miisaankeedu yahay shan kiiloogaraam.',
      pluralForm: 'kilograms',
    ),
    VocabularySeed(
      id: 'vocab_liter',
      categoryCode: 'measures',
      subcategoryCode: 'volume',
      englishHeadword: 'liter',
      somaliHeadword: 'litir',
      partOfSpeech: 'noun',
      englishDefinition: 'A unit used to measure liquids.',
      somaliExplanation:
          'Litir waa cutub lagu cabbiro dareeraha sida biyo ama caano.',
      exampleEnglish: 'Please buy one liter of milk.',
      exampleSomali: 'Fadlan iibso hal litir oo caano ah.',
      pluralForm: 'liters',
    ),
    VocabularySeed(
      id: 'vocab_digit',
      categoryCode: 'numbers',
      subcategoryCode: 'phone',
      englishHeadword: 'digit',
      somaliHeadword: 'lambar keli ah',
      partOfSpeech: 'noun',
      englishDefinition: 'One written number from zero to nine.',
      somaliExplanation:
          'Lambar keli ah waa tiro qoran oo u dhexeysa eber iyo sagaal.',
      exampleEnglish: 'Read each digit of the phone number slowly.',
      exampleSomali: 'Lambar kasta oo telefoonka ah si tartiib ah u akhri.',
      pluralForm: 'digits',
    ),
    VocabularySeed(
      id: 'vocab_percent',
      categoryCode: 'numbers',
      subcategoryCode: 'percentages',
      englishHeadword: 'percent',
      somaliHeadword: 'boqolkiiba',
      partOfSpeech: 'noun',
      englishDefinition: 'A number out of one hundred.',
      somaliExplanation: 'Boqolkiiba waa qaddar laga tiriyo boqol qaybood.',
      exampleEnglish: 'The store has a twenty percent discount today.',
      exampleSomali:
          'Dukaanku maanta wuxuu leeyahay dhimis boqolkiiba labaatan ah.',
    ),
    VocabularySeed(
      id: 'vocab_receipt',
      categoryCode: 'money',
      subcategoryCode: 'receipts',
      englishHeadword: 'receipt',
      somaliHeadword: 'rasiid',
      partOfSpeech: 'noun',
      englishDefinition:
          'A printed or digital record showing that payment was made.',
      somaliExplanation:
          'Rasiid waa warqad ama caddeyn dijitaal ah oo muujinaysa waxa la iibsaday iyo lacagta la bixiyay.',
      exampleEnglish:
          'Please keep the receipt in case you need to return the shoes.',
      exampleSomali:
          'Fadlan hayso rasiidka haddii aad u baahato inaad kabaha celiso.',
      pluralForm: 'receipts',
    ),
    VocabularySeed(
      id: 'vocab_refund',
      categoryCode: 'money',
      subcategoryCode: 'receipts',
      englishHeadword: 'refund',
      somaliHeadword: 'lacag-celin',
      partOfSpeech: 'noun',
      englishDefinition:
          'Money given back after you return something or cancel a service.',
      somaliExplanation:
          'Lacag-celin waa lacag laguu soo celiyo markaad alaab celiso ama adeeg joojiso.',
      exampleEnglish: 'The refund will go back to your debit card.',
      exampleSomali: 'Lacag-celintu waxay ku noqon doontaa kaarkaaga debit-ka.',
      pluralForm: 'refunds',
    ),
    VocabularySeed(
      id: 'vocab_deadline',
      categoryCode: 'time',
      subcategoryCode: 'deadlines',
      englishHeadword: 'deadline',
      somaliHeadword: 'waqti kama dambays ah',
      partOfSpeech: 'noun',
      englishDefinition:
          'The final time or date when something must be finished or submitted.',
      somaliExplanation:
          'Waqti kama dambays ah waa goorta ugu dambaysa ee hawl la dhammeeyo ama la gudbiyo.',
      exampleEnglish: 'The application deadline is Friday.',
      exampleSomali: 'Waqtiga kama dambaysta ah ee codsigu waa Jimce.',
      pluralForm: 'deadlines',
    ),
    VocabularySeed(
      id: 'vocab_schedule',
      categoryCode: 'time',
      subcategoryCode: 'schedule',
      englishHeadword: 'schedule',
      somaliHeadword: 'jadwal',
      partOfSpeech: 'noun',
      englishDefinition:
          'A list of times when events, classes, or work shifts happen.',
      somaliExplanation:
          'Jadwal waa liis muujinaya waqtiyada dhacdooyin, fasallo, ama shaqooyin dhacaan.',
      exampleEnglish: 'The bus schedule changed this week.',
      exampleSomali: 'Jadwalkii baska toddobaadkan wuu is beddelay.',
      pluralForm: 'schedules',
    ),
    VocabularySeed(
      id: 'vocab_nearest',
      categoryCode: 'locating',
      subcategoryCode: 'nearby',
      englishHeadword: 'nearest',
      somaliHeadword: 'ugu dhow',
      partOfSpeech: 'adjective',
      englishDefinition: 'Closest in distance.',
      somaliExplanation:
          'Ugu dhow waxaa laga wadaa meesha ama shayga masaafo ahaan kuugu dhaw.',
      exampleEnglish: 'Where is the nearest pharmacy?',
      exampleSomali: 'Farmashiyaha ugu dhow xaggee ku yaal?',
    ),
    VocabularySeed(
      id: 'vocab_beside',
      categoryCode: 'locating',
      subcategoryCode: 'position',
      englishHeadword: 'beside',
      somaliHeadword: 'agtiisa',
      partOfSpeech: 'preposition',
      englishDefinition: 'Next to or at the side of something.',
      somaliExplanation:
          'Agtiisa waxay tilmaantaa meel ku xigta ama dhinac ka taal shay kale.',
      exampleEnglish: 'The sink is beside the restroom.',
      exampleSomali: 'Saxanku wuxuu ku yaal musqusha agteeda.',
    ),
    VocabularySeed(
      id: 'vocab_cracked',
      categoryCode: 'describing',
      subcategoryCode: 'condition',
      englishHeadword: 'cracked',
      somaliHeadword: 'dillaacay',
      partOfSpeech: 'adjective',
      englishDefinition: 'Damaged with one or more thin broken lines.',
      somaliExplanation:
          'Dillaacay waxaa la yiraahdaa shay leh khadad jab ama dhaawac ah.',
      exampleEnglish: 'The cracked screen needs repair.',
      exampleSomali: 'Shaashadda dillaacday waxay u baahan tahay dayactir.',
    ),
    VocabularySeed(
      id: 'vocab_nervous',
      categoryCode: 'describing',
      subcategoryCode: 'feelings',
      englishHeadword: 'nervous',
      somaliHeadword: 'walwalsan',
      partOfSpeech: 'adjective',
      englishDefinition: 'Worried or uneasy about something that may happen.',
      somaliExplanation:
          'Walwalsan waa dareen cabsi yar ama degganaan laaan ka hor arrin dhici karta.',
      exampleEnglish: 'I felt nervous before the interview.',
      exampleSomali: 'Wareysiga ka hor waxaan dareemay walwal.',
    ),
    VocabularySeed(
      id: 'vocab_apply',
      categoryCode: 'doing_things',
      subcategoryCode: 'plans',
      englishHeadword: 'apply',
      somaliHeadword: 'codso',
      partOfSpeech: 'verb',
      englishDefinition:
          'To ask formally for a job, school place, service, or permission.',
      somaliExplanation:
          'Codso waa inaad si rasmi ah u weydiisato shaqo, waxbarasho, adeeg, ama oggolaansho.',
      exampleEnglish: 'I will apply online after work.',
      exampleSomali: 'Shaqada ka dib internetka ayaan ka codsan doonaa.',
      pastForm: 'applied',
      pastParticiple: 'applied',
    ),
    VocabularySeed(
      id: 'vocab_permission',
      categoryCode: 'doing_things',
      subcategoryCode: 'permission',
      englishHeadword: 'permission',
      somaliHeadword: 'oggolaansho',
      partOfSpeech: 'noun',
      englishDefinition: 'Approval to do something.',
      somaliExplanation:
          'Oggolaansho waa ruqsad ama fasax laguu siiyo inaad wax samayso.',
      exampleEnglish: 'You need permission to use the staff computer.',
      exampleSomali:
          'Waxaad u baahan tahay oggolaansho si aad u isticmaasho kombiyuutarka shaqaalaha.',
    ),
    VocabularySeed(
      id: 'vocab_platform',
      categoryCode: 'going_places',
      subcategoryCode: 'bus',
      englishHeadword: 'platform',
      somaliHeadword: 'barxad rakaab',
      partOfSpeech: 'noun',
      englishDefinition: 'The area where passengers wait for a train or bus.',
      somaliExplanation:
          'Barxad rakaab waa meel rakaabku ku sugo tareen ama bas.',
      exampleEnglish: 'The train leaves from platform three.',
      exampleSomali:
          'Tareenku wuxuu ka baxayaa barxadda rakaabka ee saddexaad.',
      pluralForm: 'platforms',
    ),
    VocabularySeed(
      id: 'vocab_fare',
      categoryCode: 'going_places',
      subcategoryCode: 'tickets',
      englishHeadword: 'fare',
      somaliHeadword: 'lacagta raacidda',
      partOfSpeech: 'noun',
      englishDefinition: 'The money paid for a bus, taxi, train, or ride.',
      somaliExplanation:
          'Lacagta raacidda waa lacagta lagu bixiyo bas, taksi, tareen, ama gaari raacid.',
      exampleEnglish: 'The bus fare is two dollars.',
      exampleSomali: 'Lacagta raacidda baska waa labo doollar.',
      pluralForm: 'fares',
    ),
    VocabularySeed(
      id: 'vocab_attachment',
      categoryCode: 'conveying_information',
      subcategoryCode: 'email',
      englishHeadword: 'attachment',
      somaliHeadword: 'lifaaq',
      partOfSpeech: 'noun',
      englishDefinition: 'A file sent together with an email or message.',
      somaliExplanation: 'Lifaaq waa fayl lagu daro iimayl ama farriin.',
      exampleEnglish: 'The attachment contains my identification document.',
      exampleSomali: 'Lifaaqu wuxuu ka kooban yahay dukumentigayga aqoonsiga.',
      pluralForm: 'attachments',
    ),
    VocabularySeed(
      id: 'vocab_submit',
      categoryCode: 'conveying_information',
      subcategoryCode: 'instructions',
      englishHeadword: 'submit',
      somaliHeadword: 'gudbi',
      partOfSpeech: 'verb',
      englishDefinition: 'To send a form, document, or answer officially.',
      somaliExplanation:
          'Gudbi waa inaad foom, dukumenti, ama jawaab si rasmi ah u dirto.',
      exampleEnglish: 'Press submit after you upload the document.',
      exampleSomali: 'Riix gudbi ka dib markaad dukumentiga geliso.',
      pastForm: 'submitted',
      pastParticiple: 'submitted',
    ),
    VocabularySeed(
      id: 'vocab_symptom',
      categoryCode: 'health_hygiene',
      subcategoryCode: 'symptoms',
      englishHeadword: 'symptom',
      somaliHeadword: 'calaamad xanuun',
      partOfSpeech: 'noun',
      englishDefinition: 'A change in your body that may show illness.',
      somaliExplanation:
          'Calaamad xanuun waa isbeddel jirka ah oo muujin kara jirro.',
      exampleEnglish: 'A cough can be a symptom of a cold.',
      exampleSomali: 'Qufacu wuxuu noqon karaa calaamad xanuun oo hargab ah.',
      pluralForm: 'symptoms',
    ),
    VocabularySeed(
      id: 'vocab_prescription',
      categoryCode: 'health_hygiene',
      subcategoryCode: 'medicine',
      englishHeadword: 'prescription',
      somaliHeadword: 'warqad daawo',
      partOfSpeech: 'noun',
      englishDefinition:
          'A written or electronic order from a doctor for medicine.',
      somaliExplanation:
          'Warqad daawo waa amar dhakhtar oo qoran ama dijitaal ah oo daawo lagu helo.',
      exampleEnglish:
          'The pharmacist checked the prescription before giving me the medicine.',
      exampleSomali:
          'Farmashiistuhu wuxuu hubiyay warqadda daawada ka hor intuusan daawada i siin.',
      pluralForm: 'prescriptions',
    ),
    VocabularySeed(
      id: 'vocab_ingredient',
      categoryCode: 'food',
      subcategoryCode: 'cooking',
      englishHeadword: 'ingredient',
      somaliHeadword: 'maaddo cunto',
      partOfSpeech: 'noun',
      englishDefinition: 'One food item used to make a dish.',
      somaliExplanation:
          'Maaddo cunto waa shay cunto oo ka mid ah waxa lagu sameeyo saxan cunto.',
      exampleEnglish: 'Garlic is an ingredient in this soup.',
      exampleSomali: 'Toontu waa maaddo cunto oo ku jirta maraqan.',
      pluralForm: 'ingredients',
    ),
    VocabularySeed(
      id: 'vocab_halal',
      categoryCode: 'food',
      subcategoryCode: 'halal',
      englishHeadword: 'halal',
      somaliHeadword: 'xalaal',
      partOfSpeech: 'adjective',
      englishDefinition: 'Allowed under Islamic rules, especially for food.',
      somaliExplanation:
          'Xalaal waa wax shareecada Islaamku oggol tahay, gaar ahaan cunto.',
      exampleEnglish: 'The restaurant serves halal meat.',
      exampleSomali: 'Maqaayaddu waxay bixisaa hilib xalaal ah.',
    ),
    VocabularySeed(
      id: 'vocab_sleeve',
      categoryCode: 'clothing',
      subcategoryCode: 'fit',
      englishHeadword: 'sleeve',
      somaliHeadword: 'gacan dhar',
      partOfSpeech: 'noun',
      englishDefinition: 'The part of clothing that covers the arm.',
      somaliExplanation:
          'Gacan dhar waa qaybta shaati ama jaakad ee gacanta daboosha.',
      exampleEnglish: 'The sleeve is too long for me.',
      exampleSomali: 'Gacanta dharku aad bay iigu dheer tahay.',
      pluralForm: 'sleeves',
    ),
    VocabularySeed(
      id: 'vocab_receipt_clothing',
      categoryCode: 'clothing',
      subcategoryCode: 'returns',
      englishHeadword: 'return policy',
      somaliHeadword: 'xeerka celinta',
      partOfSpeech: 'noun',
      englishDefinition:
          'Store rules that explain when and how bought items can be returned.',
      somaliExplanation:
          'Xeerka celintu waa sharciyada dukaanka ee sheegaya goorta iyo sida alaab loo celin karo.',
      exampleEnglish: 'Read the return policy before you buy the coat.',
      exampleSomali: 'Akhri xeerka celinta ka hor intaadan jaakadda iibsan.',
      pluralForm: 'return policies',
    ),
    VocabularySeed(
      id: 'vocab_landlord',
      categoryCode: 'housing',
      subcategoryCode: 'rent',
      englishHeadword: 'landlord',
      somaliHeadword: 'kireeye',
      partOfSpeech: 'noun',
      englishDefinition:
          'A person who owns a house or apartment and rents it to another person.',
      somaliExplanation:
          'Kireeye waa qofka guri ama qol ka kireeya qof kale oo kirada qaata.',
      exampleEnglish: 'The landlord repaired the heater.',
      exampleSomali: 'Kireeyuhu wuxuu dayactiray kuleyliyaha.',
      pluralForm: 'landlords',
    ),
    VocabularySeed(
      id: 'vocab_tenant',
      categoryCode: 'housing',
      subcategoryCode: 'rent',
      englishHeadword: 'tenant',
      somaliHeadword: 'kireyste',
      partOfSpeech: 'noun',
      englishDefinition:
          'A person who pays rent to live in a room, house, or apartment.',
      somaliExplanation:
          'Kireyste waa qof bixiya kiro si uu ugu noolaado qol, guri, ama aqal.',
      exampleEnglish: 'The tenant pays rent on the first day of each month.',
      exampleSomali:
          'Kireystuhu wuxuu kirada bixiyaa maalinta koowaad ee bil kasta.',
      pluralForm: 'tenants',
    ),
    VocabularySeed(
      id: 'vocab_resume',
      categoryCode: 'jobs',
      subcategoryCode: 'applications',
      englishHeadword: 'resume',
      somaliHeadword: 'CV',
      partOfSpeech: 'noun',
      englishDefinition:
          'A short document that lists your work experience, education, and skills.',
      somaliExplanation:
          'CV waa dukumenti kooban oo muujinaya khibraddaada shaqo, waxbarashadaada, iyo xirfadahaaga.',
      exampleEnglish: 'Please upload your resume on the application website.',
      exampleSomali: 'Fadlan CV-gaaga geli bogga codsiga.',
      pluralForm: 'resumes',
    ),
    VocabularySeed(
      id: 'vocab_wage',
      categoryCode: 'jobs',
      subcategoryCode: 'schedule',
      englishHeadword: 'wage',
      somaliHeadword: 'mushahar saacad ama maalin',
      partOfSpeech: 'noun',
      englishDefinition: 'Money paid to a worker, often by the hour or day.',
      somaliExplanation:
          'Mushahar saacad ama maalin waa lacag shaqaale lagu siiyo saacadaha ama maalmaha uu shaqeeyo.',
      exampleEnglish: 'The wage is fifteen dollars an hour.',
      exampleSomali: 'Mushaharku waa shan iyo toban doollar saacaddii.',
      pluralForm: 'wages',
    ),
    VocabularySeed(
      id: 'vocab_attendance',
      categoryCode: 'schools',
      subcategoryCode: 'attendance',
      englishHeadword: 'attendance',
      somaliHeadword: 'xaadiris',
      partOfSpeech: 'noun',
      englishDefinition:
          'The record of whether a student is present or absent.',
      somaliExplanation:
          'Xaadiris waa diiwaanka muujinaya in ardaygu joogo ama maqan yahay.',
      exampleEnglish: 'You can check attendance on the school portal.',
      exampleSomali: 'Xaadiriska waxaad ka hubin kartaa bogga iskuulka.',
    ),
    VocabularySeed(
      id: 'vocab_homework',
      categoryCode: 'schools',
      subcategoryCode: 'homework',
      englishHeadword: 'homework',
      somaliHeadword: 'laylis guriga',
      partOfSpeech: 'noun',
      englishDefinition: 'School work that a student must do outside class.',
      somaliExplanation:
          'Laylis guriga waa shaqo iskuul oo ardaygu sameeyo marka fasalka laga baxo.',
      exampleEnglish: 'The homework is due tomorrow.',
      exampleSomali: 'Layliska guriga waa in berri la keenaa.',
    ),
  ];

  static const dialogueContinuations = <String, List<DialogueLineSeed>>{
    'dlg_language_barrier_interpreter_001': [
      DialogueLineSeed(
        'Patient',
        'Could the interpreter also help me when I pick up my medicine?',
        'Turjubaanku ma iga caawin karaa marka aan daawadayda qaadanayo?',
      ),
      DialogueLineSeed(
        'Receptionist',
        'Yes, tell the nurse that you need help at the pharmacy window too.',
        'Haa, kalkaalisada u sheeg inaad sidoo kale caawimo uga baahan tahay daaqadda farmashiyaha.',
      ),
      DialogueLineSeed(
        'Patient',
        'Should I sign this consent form now or wait for the interpreter?',
        'Foomkan oggolaanshaha hadda ma saxiixaa mise turjubaanka ayaan sugaa?',
      ),
      DialogueLineSeed(
        'Receptionist',
        'Please wait, because you should understand every part before signing.',
        'Fadlan sug, sababtoo ah waa inaad qayb kasta fahamtaa ka hor saxiixa.',
      ),
    ],
    'dlg_etiquette_visit_001': [
      DialogueLineSeed(
        'Host',
        'Please give my greetings to your mother when you see her.',
        'Fadlan hooyadaa salaan iga gaarsii markaad aragto.',
      ),
      DialogueLineSeed(
        'Guest',
        'I will. She always asks how you and your children are.',
        'Waan gaarsiin doonaa. Mar walba way weydiisaa sida adiga iyo carruurtaadu tihiin.',
      ),
      DialogueLineSeed(
        'Host',
        'Before you leave, take some cake for the children.',
        'Ka hor intaadan bixin, carruurta keeg u qaad.',
      ),
      DialogueLineSeed(
        'Guest',
        'That is very generous. Thank you for the warm welcome.',
        'Taasi waa deeqsinimo weyn. Waad ku mahadsan tahay soo dhaweynta wanaagsan.',
      ),
    ],
    'dlg_personal_information_form_001': [
      DialogueLineSeed(
        'Clerk',
        'Please add an emergency contact on the second line.',
        'Fadlan safka labaad ku dar qof lala xiriiro xaalad degdeg ah.',
      ),
      DialogueLineSeed(
        'Applicant',
        'Can I write my sister as the emergency contact?',
        'Walaashay ma u qori karaa qofka xaaladda degdegga ah lala xiriiro?',
      ),
      DialogueLineSeed(
        'Clerk',
        'Yes. Please include her full name and phone number.',
        'Haa. Fadlan ku qor magaceeda oo buuxa iyo lambarkeeda telefoonka.',
      ),
      DialogueLineSeed(
        'Applicant',
        'I have added both. Could you check the spelling, please?',
        'Labadaba waan ku daray. Fadlan higgaadda ma hubin kartaa?',
      ),
    ],
    'dlg_signs_safety_001': [
      DialogueLineSeed(
        'Customer',
        'Should I tell my children not to run in this area?',
        'Carruurtayda ma u sheegaa inaysan meeshan ku ordin?',
      ),
      DialogueLineSeed(
        'Worker',
        'Yes, that would be safer until the floor is completely dry.',
        'Haa, taas ayaa ammaan badan ilaa dhulku gebi ahaan qalalo.',
      ),
      DialogueLineSeed(
        'Customer',
        'Is there another exit if this hallway is blocked?',
        'Ma jiraa albaab kale oo laga baxo haddii marinkani xirmo?',
      ),
      DialogueLineSeed(
        'Worker',
        'Use the exit beside the information desk.',
        'Isticmaal albaabka ka bixidda ee ag yaal miiska macluumaadka.',
      ),
    ],
    'dlg_measures_groceries_001': [
      DialogueLineSeed(
        'Shopper',
        'Could you weigh one kilogram of sugar as well?',
        'Hal kiilo oo sonkor ah sidoo kale ma ii miisaami kartaa?',
      ),
      DialogueLineSeed(
        'Cashier',
        'Of course. Do you want it in a separate bag?',
        'Dabcan. Bac gaar ah ma ku rabtaa?',
      ),
      DialogueLineSeed(
        'Shopper',
        'Yes, please. I need to carry it on the bus.',
        'Haa fadlan. Waxaan u baahanahay inaan baska ku qaato.',
      ),
      DialogueLineSeed(
        'Cashier',
        'Then I will double the bag so it does not tear.',
        'Markaas bac laba-laab ah ayaan kuu gelinayaa si aysan u dillaacin.',
      ),
    ],
    'dlg_numbers_phone_001': [
      DialogueLineSeed(
        'Caller',
        'Could you repeat the last two digits once more?',
        'Labada lambar ee ugu dambeeya mar kale ma ku celin kartaa?',
      ),
      DialogueLineSeed(
        'Office',
        'The last two digits are nine nine.',
        'Labada lambar ee ugu dambeeya waa sagaal sagaal.',
      ),
      DialogueLineSeed(
        'Caller',
        'Great. Should I include the area code when I call?',
        'Waa hagaag. Koodhka deegaanka ma raaciyaa marka aan wacayo?',
      ),
      DialogueLineSeed(
        'Office',
        'Yes, please include it if you are calling from another city.',
        'Haa, fadlan ku dar haddii aad magaalo kale ka soo wacayso.',
      ),
    ],
    'dlg_money_refund_001': [
      DialogueLineSeed(
        'Customer',
        'Do I need to bring the original packaging?',
        'Baakaddii asalka ahayd ma inaan keenaa?',
      ),
      DialogueLineSeed(
        'Cashier',
        'It helps, but the receipt and the item are the most important.',
        'Way caawisaa, laakiin rasiidka iyo alaabta ayaa ugu muhiimsan.',
      ),
      DialogueLineSeed(
        'Customer',
        'Can I exchange it instead of getting a refund?',
        'Ma beddeli karaa halkii aan lacag-celin ka qaadan lahaa?',
      ),
      DialogueLineSeed(
        'Cashier',
        'Yes, you can choose another item at the same price.',
        'Haa, waxaad dooran kartaa alaab kale oo isla qiimahaas ah.',
      ),
    ],
    'dlg_time_video_appointment_001': [
      DialogueLineSeed(
        'Patient',
        'What should I do if I join late?',
        'Maxaan sameeyaa haddii aan soo daaho?',
      ),
      DialogueLineSeed(
        'Clinic',
        'Please join anyway, and the doctor will decide if there is enough time.',
        'Si kastaba ku soo biir, dhakhtarkuna wuu go’aamin doonaa haddii waqti ku filan jiro.',
      ),
      DialogueLineSeed(
        'Patient',
        'Do I need my medicine bottles with me?',
        'Dhalooyinka daawadayda ma inaan agtayda ku haystaa?',
      ),
      DialogueLineSeed(
        'Clinic',
        'Yes, keep them nearby so you can read the names clearly.',
        'Haa, meel kuu dhow ku hay si aad magacyada si cad ugu akhrido.',
      ),
    ],
    'dlg_locating_bus_stop_001': [
      DialogueLineSeed(
        'Visitor',
        'Which side goes toward downtown?',
        'Dhinacee ayuu baska magaalada hoose u socda ka istaagaa?',
      ),
      DialogueLineSeed(
        'Librarian',
        'Stand on the pharmacy side for buses going downtown.',
        'Dhinaca farmashiyaha istaag haddii aad rabto basaska magaalada hoose taga.',
      ),
      DialogueLineSeed(
        'Visitor',
        'Is there a shelter if it rains?',
        'Haddii roob da’o meel la galo ma jirtaa?',
      ),
      DialogueLineSeed(
        'Librarian',
        'Yes, the stop has a small shelter and a timetable board.',
        'Haa, joogsigu wuxuu leeyahay meel yar oo la hoos galo iyo jadwal.',
      ),
    ],
    'dlg_describing_repair_001': [
      DialogueLineSeed(
        'Customer',
        'How much will the screen repair cost?',
        'Dayactirka shaashaddu imisa ayuu ku kacayaa?',
      ),
      DialogueLineSeed(
        'Technician',
        'It will cost ninety dollars, including the new glass.',
        'Waxay ku kacaysaa sagaashan doollar, muraayadda cusubna way ku jirtaa.',
      ),
      DialogueLineSeed(
        'Customer',
        'Will I lose my photos during the repair?',
        'Sawirradayda ma luminayaa inta dayactirku socdo?',
      ),
      DialogueLineSeed(
        'Technician',
        'No, but you should back them up before we start.',
        'Maya, laakiin waa inaad kayd ka samaysataa ka hor inta aan bilaabin.',
      ),
    ],
    'dlg_doing_things_library_001': [
      DialogueLineSeed(
        'Visitor',
        'Can I use the computer to print a document?',
        'Kombiyuutarka ma u isticmaali karaa inaan dukumenti daabaco?',
      ),
      DialogueLineSeed(
        'Librarian',
        'Yes, book a computer at the desk and pay for the pages you print.',
        'Haa, miiska ka qabsato kombiyuutar, kadibna bixi bogagga aad daabacdo.',
      ),
      DialogueLineSeed(
        'Visitor',
        'May I ask someone for help if the printer stops?',
        'Haddii daabacuhu istaago qof caawimo ma weydiisan karaa?',
      ),
      DialogueLineSeed(
        'Librarian',
        'Yes, press the help button and a staff member will come over.',
        'Haa, riix badhanka caawimada, shaqaalena wuu kuu imaan doonaa.',
      ),
    ],
    'dlg_going_places_taxi_001': [
      DialogueLineSeed(
        'Passenger',
        'Could you take the main road instead of the highway?',
        'Jidka weyn ee gudaha ma mari kartaa halkii aad waddada dheer ka mari lahayd?',
      ),
      DialogueLineSeed(
        'Driver',
        'Yes, but it may take ten minutes longer.',
        'Haa, laakiin waxay qaadan kartaa toban daqiiqo oo dheeraad ah.',
      ),
      DialogueLineSeed(
        'Passenger',
        'That is fine. I would rather avoid heavy traffic.',
        'Waa hagaag. Waxaan doorbidayaa inaan ka fogaado ciriiriga badan.',
      ),
      DialogueLineSeed(
        'Driver',
        'No problem. I will drop you at the front entrance.',
        'Dhib ma leh. Albaabka hore ayaan kugu dejin doonaa.',
      ),
    ],
    'dlg_conveying_information_email_001': [
      DialogueLineSeed(
        'Applicant',
        'Should I attach my ID to the same email?',
        'Aqoonsigayga isla iimaylkaas ma ku lifaaqaa?',
      ),
      DialogueLineSeed(
        'Officer',
        'Yes, attach a clear photo of the front and back.',
        'Haa, ku lifaaq sawir cad oo hore iyo gadaal ah.',
      ),
      DialogueLineSeed(
        'Applicant',
        'Can you confirm when you receive it?',
        'Markaad heshaan ma ii xaqiijin kartaa?',
      ),
      DialogueLineSeed(
        'Officer',
        'We will send a confirmation email within one business day.',
        'Waxaan kuu soo diri doonaa iimayl xaqiijin ah hal maalin shaqo gudahood.',
      ),
    ],
    'dlg_health_hygiene_pharmacy_001': [
      DialogueLineSeed(
        'Patient',
        'Should I take this medicine with food?',
        'Daawadan cunto ma la qaataa?',
      ),
      DialogueLineSeed(
        'Pharmacist',
        'Yes, take it after a meal to protect your stomach.',
        'Haa, qaado cuntada ka dib si calooshaadu u nabadgasho.',
      ),
      DialogueLineSeed(
        'Patient',
        'What should I do if I miss a dose?',
        'Maxaan sameeyaa haddii aan hal mar ilaawo?',
      ),
      DialogueLineSeed(
        'Pharmacist',
        'Take it when you remember, unless it is almost time for the next dose.',
        'Qaado markaad xasuusato, haddii aysan ku dhowayn waqtiga qiyaasta xigta.',
      ),
    ],
    'dlg_food_restaurant_001': [
      DialogueLineSeed(
        'Customer',
        'Could you make the rice without butter?',
        'Bariiska subag la’aan ma ii samayn kartaa?',
      ),
      DialogueLineSeed(
        'Server',
        'Yes, I will write that as a special request.',
        'Haa, waxaan taas u qori doonaa codsi gaar ah.',
      ),
      DialogueLineSeed(
        'Customer',
        'And could we have some water for the table?',
        'Biyo miiska ahna ma heli karnaa?',
      ),
      DialogueLineSeed(
        'Server',
        'Of course. I will bring water before the food comes.',
        'Dabcan. Biyaha ayaan keenayaa ka hor inta cuntadu iman.',
      ),
    ],
    'dlg_clothing_shirt_001': [
      DialogueLineSeed(
        'Customer',
        'Could you check whether this shirt comes in large?',
        'Ma hubin kartaa in shaatigani cabbir weyn ku jiro?',
      ),
      DialogueLineSeed(
        'Assistant',
        'Yes, I can check the stockroom for a large.',
        'Haa, bakhaarka ayaan ka eegi karaa cabbir weyn.',
      ),
      DialogueLineSeed(
        'Customer',
        'If it does not fit, can I return it tomorrow?',
        'Haddii uusan igu habboonaan, berri ma celin karaa?',
      ),
      DialogueLineSeed(
        'Assistant',
        'Yes, keep the receipt and leave the tag on the shirt.',
        'Haa, rasiidka hayso, calaamaddana shaatiga ha ka goyn.',
      ),
    ],
    'dlg_housing_rent_001': [
      DialogueLineSeed(
        'Tenant',
        'Is water included in the rent?',
        'Biyaha kirada ma ku jiraan?',
      ),
      DialogueLineSeed(
        'Landlord',
        'Water is included, but electricity is billed separately.',
        'Biyuhu way ku jiraan, laakiin korontada si gaar ah ayaa loo bixiyaa.',
      ),
      DialogueLineSeed(
        'Tenant',
        'When should I report repairs?',
        'Goorma ayaan soo sheegaa dayactirrada?',
      ),
      DialogueLineSeed(
        'Landlord',
        'Report urgent repairs immediately and send other requests by email.',
        'Dayactirka degdegga ah isla markiiba soo sheeg, kuwa kalena iimayl ku soo dir.',
      ),
    ],
    'dlg_jobs_interview_001': [
      DialogueLineSeed(
        'Interviewer',
        'Can you work weekends if the schedule changes?',
        'Ma shaqayn kartaa dhammaadka toddobaadka haddii jadwalku is beddelo?',
      ),
      DialogueLineSeed(
        'Applicant',
        'Yes, with advance notice I can arrange childcare.',
        'Haa, haddii hore la ii ogeysiiyo waan diyaarsan karaa daryeelka carruurta.',
      ),
      DialogueLineSeed(
        'Interviewer',
        'Do you have any questions about the position?',
        'Su’aalo ma ka qabtaa jagadan?',
      ),
      DialogueLineSeed(
        'Applicant',
        'Yes. What training is provided during the first week?',
        'Haa. Tababar noocee ah ayaa la bixiyaa toddobaadka koowaad?',
      ),
    ],
    'dlg_schools_portal_001': [
      DialogueLineSeed(
        'Parent',
        'Can the teacher send homework notices by text as well?',
        'Macallinku fariimaha layliska qoraal telefoon ma ku soo diri karaa sidoo kale?',
      ),
      DialogueLineSeed(
        'Office',
        'Yes, we can add text messages to your contact preferences.',
        'Haa, farriimaha qoraalka ah waxaan ku dari karnaa doorashada xiriirkaaga.',
      ),
      DialogueLineSeed(
        'Parent',
        'Who should I call if my child is absent?',
        'Yaan wacaa haddii ilmahaygu maqnaado?',
      ),
      DialogueLineSeed(
        'Office',
        'Call the attendance office before nine in the morning.',
        'Wac xafiiska xaadiriska ka hor sagaalka subaxnimo.',
      ),
    ],
  };

  static List<Map<String, Object?>> categoryRows() => [
    for (var i = 0; i < categories.length; i++)
      {
        'id': _categoryId(categories[i].code),
        'code': categories[i].code,
        'english_title': categories[i].englishTitle,
        'somali_title': categories[i].somaliTitle,
        'english_description': categories[i].englishDescription,
        'somali_description': categories[i].somaliDescription,
        'icon_key': categories[i].iconKey,
        'theme_key': categories[i].themeKey,
        'sort_order': i + 1,
        'is_active': 1,
        'created_at': _now,
        'updated_at': _now,
      },
  ];

  static List<Map<String, Object?>> subcategoryRows() => [
    for (final entry in subcategories.indexed)
      {
        'id': _subcategoryId(entry.$2.code),
        'category_id': _categoryId(_categoryCode(entry.$2.code)),
        'english_title': entry.$2.englishTitle,
        'somali_title': entry.$2.somaliTitle,
        'sort_order': _subcategoryOrder(entry.$2.code),
      },
  ];

  static List<Map<String, Object?>> expressionRows() => [
    for (final entry in _allExpressionSeeds().indexed)
      {
        'id': entry.$2.id,
        'category_id': _categoryId(entry.$2.categoryCode),
        'subcategory_id': _subcategoryId(
          '${entry.$2.categoryCode}.${entry.$2.subcategoryCode}',
        ),
        'english_text': entry.$2.englishText,
        'somali_text': entry.$2.somaliText,
        'somali_alternative': entry.$2.somaliAlternative,
        'usage_explanation': entry.$2.usageExplanation,
        'context': entry.$2.context,
        'formality': entry.$2.formality,
        'pronunciation': entry.$2.pronunciation,
        'difficulty': entry.$2.difficulty,
        'sort_order': entry.$1 + 1,
        'search_text':
            '${entry.$2.englishText} ${entry.$2.somaliText} ${entry.$2.context}'
                .toLowerCase(),
        'created_at': _now,
        'updated_at': _now,
      },
  ];

  static List<Map<String, Object?>> expressionExampleRows() => [
    for (final expression in _allExpressionSeeds())
      {
        'id': 'ex_${expression.id}',
        'expression_id': expression.id,
        'english_sentence': expression.exampleEnglish,
        'somali_sentence': expression.exampleSomali,
        'sort_order': 1,
      },
  ];

  static List<ExpressionSeed> _allExpressionSeeds() {
    final rows = <ExpressionSeed>[...expressions];
    for (final subcategory in subcategories) {
      final categoryCode = _categoryCode(subcategory.code);
      final localCode = subcategory.code.substring(categoryCode.length + 1);
      final currentCount = rows
          .where(
            (row) =>
                row.categoryCode == categoryCode &&
                row.subcategoryCode == localCode,
          )
          .length;
      for (var i = currentCount; i < 10; i++) {
        rows.add(_supplementalExpression(subcategory, i));
      }
    }
    return rows;
  }

  static ExpressionSeed _supplementalExpression(
    SubcategorySeed subcategory,
    int index,
  ) {
    final categoryCode = _categoryCode(subcategory.code);
    final category = categories.firstWhere((row) => row.code == categoryCode);
    final localCode = subcategory.code.substring(categoryCode.length + 1);
    final englishTopic = subcategory.englishTitle.toLowerCase();
    final somaliTopic = subcategory.somaliTitle;
    final categoryContext = category.englishTitle.toLowerCase();
    final id =
        'expr_${subcategory.code.replaceAll('.', '_')}_${(index + 1).toString().padLeft(2, '0')}';
    final phrase = switch (index % 10) {
      0 => (
        'Could you help me with $englishTopic in this $categoryContext situation?',
        'Ma iga caawin kartaa $somaliTopic xaaladdan ${category.somaliTitle}?',
        'Use this when you need direct help with the topic.',
        'At a service desk or counter',
        'Could you help me with $englishTopic before I continue?',
        'Ma iga caawin kartaa $somaliTopic ka hor intaanan sii wadin?',
      ),
      1 => (
        'I need to ask a question about $englishTopic.',
        'Waxaan u baahanahay inaan su’aal ka weydiiyo $somaliTopic.',
        'Use this to introduce a clear question politely.',
        'Starting a conversation',
        'I need to ask a question about $englishTopic at the front desk.',
        'Waxaan u baahanahay inaan miiska hore su’aal ka weydiiyo $somaliTopic.',
      ),
      2 => (
        'Please explain $englishTopic in simple English.',
        'Fadlan $somaliTopic iigu sharax Ingiriisi fudud.',
        'Use this when the explanation is too fast or too difficult.',
        'Learning or asking for clarification',
        'Please explain $englishTopic in simple English so I can understand.',
        'Fadlan $somaliTopic iigu sharax Ingiriisi fudud si aan u fahmo.',
      ),
      3 => (
        'What should I say when I need $englishTopic?',
        'Maxaan iraahdaa marka aan u baahdo $somaliTopic?',
        'Use this to ask for the right phrase in a real situation.',
        'Asking for language support',
        'What should I say when I need $englishTopic at an office?',
        'Maxaan iraahdaa marka aan xafiis uga baahdo $somaliTopic?',
      ),
      4 => (
        'Can you write down the words for $englishTopic?',
        'Erayada $somaliTopic ma ii qori kartaa?',
        'Use this when you want to remember the wording later.',
        'Taking notes',
        'Can you write down the words for $englishTopic on this paper?',
        'Erayada $somaliTopic warqaddan ma iigu qori kartaa?',
      ),
      5 => (
        'I am learning how to talk about $englishTopic.',
        'Waxaan baranayaa sida looga hadlo $somaliTopic.',
        'Use this to explain that you are still learning English.',
        'Practising English',
        'I am learning how to talk about $englishTopic with confidence.',
        'Waxaan baranayaa sida kalsooni leh looga hadlo $somaliTopic.',
      ),
      6 => (
        'Could you give me an example for $englishTopic?',
        'Tusaale ku saabsan $somaliTopic ma i siin kartaa?',
        'Use this when one example would make the meaning clearer.',
        'Classroom or service conversation',
        'Could you give me an example for $englishTopic before I answer?',
        'Tusaale ku saabsan $somaliTopic ma i siin kartaa ka hor intaanan jawaabin?',
      ),
      7 => (
        'I want to practise $englishTopic with a real sentence.',
        'Waxaan rabaa inaan $somaliTopic ku barto jumlad dhab ah.',
        'Use this when you want sentence practice instead of single words.',
        'Speaking practice',
        'I want to practise $englishTopic with a real sentence today.',
        'Maanta waxaan rabaa inaan $somaliTopic ku barto jumlad dhab ah.',
      ),
      8 => (
        'Which phrase is most polite for $englishTopic?',
        'Weedhdee ayaa ugu edeb badan marka laga hadlayo $somaliTopic?',
        'Use this to choose a polite expression for the situation.',
        'Polite requests',
        'Which phrase is most polite for $englishTopic with a stranger?',
        'Weedhdee ayaa ugu edeb badan marka qof aanan aqoon kala hadlayo $somaliTopic?',
      ),
      _ => (
        'Could you repeat the phrase about $englishTopic once more?',
        'Weedha ku saabsan $somaliTopic mar kale ma ku celin kartaa?',
        'Use this when you missed a phrase and want it repeated.',
        'Listening practice',
        'Could you repeat the phrase about $englishTopic once more, please?',
        'Fadlan weedha ku saabsan $somaliTopic mar kale ma ku celin kartaa?',
      ),
    };
    return ExpressionSeed(
      id: id,
      categoryCode: categoryCode,
      subcategoryCode: localCode,
      englishText: phrase.$1,
      somaliText: phrase.$2,
      usageExplanation: phrase.$3,
      exampleEnglish: phrase.$5,
      exampleSomali: phrase.$6,
      context: phrase.$4,
      formality: index == 5 || index == 7 ? 'neutral' : 'polite',
      difficulty: index < 4 ? 'A1' : 'A2',
    );
  }

  static List<Map<String, Object?>> dialogueRows() => [
    for (final entry in dialogues.indexed)
      {
        'id': entry.$2.id,
        'category_id': _categoryId(entry.$2.categoryCode),
        'subcategory_id': _subcategoryId(
          '${entry.$2.categoryCode}.${entry.$2.subcategoryCode}',
        ),
        'code': entry.$2.id.replaceFirst('dlg_', ''),
        'english_title': entry.$2.englishTitle,
        'somali_title': entry.$2.somaliTitle,
        'english_situation': entry.$2.englishSituation,
        'somali_situation': entry.$2.somaliSituation,
        'difficulty': entry.$2.difficulty,
        'sort_order': entry.$1 + 1,
        'created_at': _now,
        'updated_at': _now,
      },
  ];

  static List<Map<String, Object?>> dialogueLineRows() => [
    for (final dialogue in dialogues)
      for (final entry in [
        ...dialogue.lines,
        ...dialogueContinuations[dialogue.id] ?? [],
      ].indexed)
        {
          'id': 'line_${dialogue.id}_${entry.$1 + 1}',
          'dialogue_id': dialogue.id,
          'speaker': entry.$2.speaker,
          'english_text': entry.$2.englishText,
          'somali_text': entry.$2.somaliText,
          'usage_note': entry.$2.usageNote,
          'line_order': entry.$1 + 1,
        },
  ];

  static List<Map<String, Object?>> qaRows() => [
    for (final entry in qaPairs.indexed)
      {
        'id': entry.$2.id,
        'category_id': _categoryId(entry.$2.categoryCode),
        'subcategory_id': _subcategoryId(
          '${entry.$2.categoryCode}.${entry.$2.subcategoryCode}',
        ),
        'english_question': entry.$2.englishQuestion,
        'somali_question': entry.$2.somaliQuestion,
        'english_answer': entry.$2.englishAnswer,
        'somali_answer': entry.$2.somaliAnswer,
        'alternative_answer': entry.$2.alternativeAnswer,
        'usage_note': entry.$2.usageNote,
        'related_vocabulary': entry.$2.relatedVocabulary,
        'sort_order': entry.$1 + 1,
      },
  ];

  static List<Map<String, Object?>> vocabularyRows() => [
    for (final word in vocabulary)
      {
        'id': word.id,
        'english_headword': word.englishHeadword,
        'part_of_speech': word.partOfSpeech,
        'english_definition': word.englishDefinition,
        'plural_form': word.pluralForm,
        'past_form': word.pastForm,
        'past_participle': word.pastParticiple,
        'comparative_form': word.comparativeForm,
        'superlative_form': word.superlativeForm,
        'frequency': word.frequency,
        'difficulty': word.difficulty,
        'pronunciation': word.pronunciation,
        'usage_notes': word.usageNotes,
        'alphabetical_key': word.englishHeadword.toLowerCase(),
        'metadata_json':
            '{"seed":"authored","category":"${word.categoryCode}"}',
        'created_at': _now,
        'updated_at': _now,
      },
  ];

  static List<Map<String, Object?>> vocabularyTranslationRows() => [
    for (final word in vocabulary)
      {
        'id': 'vtr_${word.id}',
        'vocabulary_entry_id': word.id,
        'somali_headword': word.somaliHeadword,
        'somali_explanation': word.somaliExplanation,
        'regional_variant': word.regionalVariant,
        'is_primary': 1,
        'sort_order': 1,
      },
  ];

  static List<Map<String, Object?>> vocabularyExampleRows() => [
    for (final word in vocabulary)
      {
        'id': 'vex_${word.id}',
        'vocabulary_entry_id': word.id,
        'english_sentence': word.exampleEnglish,
        'somali_sentence': word.exampleSomali,
        'context': word.subcategoryCode,
        'sort_order': 1,
      },
  ];

  static List<Map<String, Object?>> vocabularyCategoryRows() => [
    for (final word in vocabulary)
      {
        'category_id': _categoryId(word.categoryCode),
        'vocabulary_entry_id': word.id,
      },
  ];

  static List<Map<String, Object?>> signRows() {
    const signs = [
      (
        'Entrance',
        'Albaab laga galo',
        'Meesha laga soo galo dhisme ama adeeg.',
        'access',
        'login',
        'building door',
      ),
      (
        'Exit',
        'Ka bixid',
        'Meesha laga baxo markaad dhismaha ka tegayso.',
        'access',
        'logout',
        'station',
      ),
      (
        'Emergency Exit',
        'Albaab gurmad',
        'Albaab loo isticmaalo xaalad degdeg ah.',
        'safety',
        'emergency',
        'cinema or office',
      ),
      ('Open', 'Furan', 'Adeeggu wuu shaqaynayaa.', 'hours', 'open', 'shop'),
      (
        'Closed',
        'Xiran',
        'Adeeggu hadda ma shaqaynayo.',
        'hours',
        'closed',
        'office',
      ),
      (
        'No Entry',
        'Gelid lama oggola',
        'Meeshan lama geli karo.',
        'safety',
        'block',
        'private area',
      ),
      (
        'No Smoking',
        'Sigaar cabbid lama oggola',
        'Sigaar laguma cabbi karo halkaas.',
        'rules',
        'smoke_free',
        'hospital',
      ),
      (
        'Danger',
        'Khatar',
        'Waxaa jira halis u baahan taxaddar.',
        'safety',
        'warning',
        'work site',
      ),
      (
        'Caution',
        'Taxaddar',
        'Si taxaddar leh u soco ama u shaqee.',
        'safety',
        'priority_high',
        'public place',
      ),
      (
        'Wet Floor',
        'Dhul qoyan',
        'Dhulku wuu simbiriirixan karaa.',
        'safety',
        'water_drop',
        'mall',
      ),
      (
        'Push',
        'Riix',
        'Albaabka riix si aad u furto.',
        'instruction',
        'open_in_full',
        'door',
      ),
      (
        'Pull',
        'Jiid',
        'Albaabka jiid si aad u furto.',
        'instruction',
        'call_made',
        'door',
      ),
      (
        'Restroom',
        'Musqul',
        'Meesha musqusha laga helo.',
        'facility',
        'wc',
        'restaurant',
      ),
      (
        'Men',
        'Ragga',
        'Musqul ama meel loogu talagalay ragga.',
        'facility',
        'man',
        'restroom',
      ),
      (
        'Women',
        'Dumarka',
        'Musqul ama meel loogu talagalay dumarka.',
        'facility',
        'woman',
        'restroom',
      ),
      (
        'Elevator',
        'Wiish',
        'Qalab dabaqyada kor iyo hoos loogu raaco.',
        'facility',
        'elevator',
        'building',
      ),
      (
        'Stairs',
        'Jaranjaro',
        'Meel lagu koro ama lagu dago lugaha.',
        'facility',
        'stairs',
        'building',
      ),
      (
        'Parking',
        'Baarkin',
        'Meesha gaari la dhigto.',
        'transport',
        'local_parking',
        'street',
      ),
      (
        'Bus Stop',
        'Joogsiga baska',
        'Meesha basku istaago.',
        'transport',
        'directions_bus',
        'road',
      ),
      (
        'Hospital',
        'Isbitaal',
        'Meel adeeg caafimaad laga helo.',
        'health',
        'local_hospital',
        'city',
      ),
      (
        'Pharmacy',
        'Farmashiye',
        'Meel daawo laga iibsado.',
        'health',
        'local_pharmacy',
        'street',
      ),
      (
        'Police',
        'Booliis',
        'Meel ama adeeg booliis.',
        'official',
        'local_police',
        'station',
      ),
      (
        'Reception',
        'Soo-dhaweyn',
        'Miiska macluumaad ama diiwaangelin.',
        'service',
        'support_agent',
        'office',
      ),
      (
        'Information',
        'Macluumaad',
        'Meel lagu weydiiyo xog ama tilmaam.',
        'service',
        'info',
        'airport',
      ),
      (
        'Temporarily Unavailable',
        'Ku meel gaar lama heli karo',
        'Adeeggu hadda ma shaqaynayo laakiin wuu soo noqon karaa.',
        'service',
        'do_not_disturb',
        'machine',
      ),
    ];
    return [
      for (var i = 0; i < signs.length; i++)
        {
          'id': 'sign_${i + 1}',
          'english_text': signs[i].$1,
          'somali_meaning': signs[i].$2,
          'somali_explanation': signs[i].$3,
          'category': signs[i].$4,
          'icon_key': signs[i].$5,
          'seen_at': signs[i].$6,
        },
    ];
  }

  static List<Map<String, Object?>> unitsRows() {
    const units = [
      ('meter', 'mitir', 'length', 'Used for height and distance.'),
      (
        'kilometer',
        'kiiloomitir',
        'distance',
        'Used for longer travel distances.',
      ),
      ('gram', 'garaam', 'weight', 'Used for small weights.'),
      (
        'kilogram',
        'kiiloogaraam',
        'weight',
        'Used for body weight and groceries.',
      ),
      ('liter', 'litir', 'volume', 'Used for liquids.'),
      ('milliliter', 'mililitir', 'volume', 'Used for medicine and cooking.'),
      (
        'degree Celsius',
        'darajo Celsius',
        'temperature',
        'Used for weather and body temperature.',
      ),
      ('inch', 'inji', 'imperial', 'Sometimes used for screens and clothing.'),
      ('foot', 'fiit', 'imperial', 'Sometimes used for height.'),
      ('pound', 'bownd', 'imperial', 'Sometimes used for weight.'),
    ];
    return [
      for (var i = 0; i < units.length; i++)
        {
          'id': 'unit_${i + 1}',
          'english_name': units[i].$1,
          'somali_name': units[i].$2,
          'unit_type': units[i].$3,
          'explanation': units[i].$4,
        },
    ];
  }

  static String _categoryId(String code) => 'cat_$code';

  static String _subcategoryId(String code) =>
      'sub_${code.replaceAll('.', '_')}';

  static String _categoryCode(String subcategoryCode) =>
      subcategoryCode.substring(0, subcategoryCode.indexOf('.'));

  static int _subcategoryOrder(String code) {
    final category = _categoryCode(code);
    return subcategories
            .where((subcategory) => _categoryCode(subcategory.code) == category)
            .toList()
            .indexWhere((subcategory) => subcategory.code == code) +
        1;
  }

  static const _now = '2026-08-01T00:00:00Z';
}
