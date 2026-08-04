# Vocabulary Seed Specification

This document defines the permanent architecture for future `vocabulary_seed.json` records.

The vocabulary seed is a phrasebook-oriented lexical database. It is not a generic English-Somali dictionary. Every record must help a learner communicate in a real situation and must be traceable to the locked curriculum.

Locked curriculum files:

- `categories_seed.json`
- `subcategories_seed.json`

Do not modify those files during vocabulary authoring.

## Phase Boundary

Do not generate `vocabulary_seed.json` yet.

This phase delivers only:

- `vocabulary_schema.json`
- `vocabulary_seed_specification.md`
- Example vocabulary records inside this specification

The example records are documentation examples only. They are not seed content.

## Canonical Editorial Reference

The English-Somali Phrasebook with Useful Wordlist is the canonical editorial reference for vocabulary selection.

The reference guides what belongs in the app, but all authored content must be original:

- Do not copy long passages.
- Do not copy complete dialogues.
- Do not reproduce pages verbatim.
- Write original definitions.
- Write original Somali explanations.
- Write original examples.
- Write original practice sentences.
- Use the reference for alignment, not reproduction.

## Core Principle

Every vocabulary record must answer:

- Why is this word in the phrasebook?
- Where would a learner use it?
- What conversation does it belong to?
- Which category and subcategory introduce it?
- Which other subcategories can reuse it?

If those questions cannot be answered, the word probably does not belong.

## Machine Schema

The JSON Schema is:

`lib/data/seed/vocabulary_schema.json`

It validates one vocabulary record at a time using JSON Schema Draft 2020-12.

## Required Top-Level Fields

Every record must include:

- `id`
- `curriculum`
- `english`
- `somali`
- `linguistics`
- `senses`
- `collocations`
- `related_language`
- `usage_notes`
- `educational_metadata`
- `learning_relationships`
- `source_traceability`
- `review_workflow`

Fields are kept structurally stable so future features can use the same data without schema redesign.

## Identity

`id`

Stable globally unique ID.

Pattern:

`vocab_[a-z0-9]+(?:_[a-z0-9]+)*`

Examples:

- `vocab_passport`
- `vocab_restaurant`
- `vocab_appointment`
- `vocab_bill_payment` when a simple lemma needs sense disambiguation

Rules:

- Use lowercase snake case.
- Do not reuse IDs after publication.
- Do not encode UI order in IDs.
- Do not create duplicate records for normal multiple meanings. Use `senses`.

## Curriculum Placement

`curriculum.primary_category_code`

The category where the learner should first meet the word. Must match a `code` in `categories_seed.json`.

`curriculum.primary_subcategory_code`

The primary subcategory where the learner should first meet the word. Must match a `code` in `subcategories_seed.json`.

Cross-reference rule:

- The primary subcategory must belong to the primary category.

`curriculum.related_subcategory_codes`

Secondary subcategories where the word naturally appears.

Example:

`appointment` may be introduced in `time_appointments` and reused in doctor visits, job interviews, and government office conversations.

Rules:

- Use related subcategories to reuse vocabulary.
- Do not duplicate a vocabulary record just because it appears in another context.
- Related subcategory codes must exist in `subcategories_seed.json`.

`curriculum.placement_note`

Short editorial explanation of why the primary placement was chosen.

## English Block

`english.headword`

Learner-facing display form.

`english.lemma`

Base form for search, sorting, and deduplication.

`english.alternative_spellings`

Accepted spelling variants. Use an empty array when none exist.

`english.abbreviation`

Common abbreviation, or `null`.

`english.search_forms`

Searchable forms, including common plurals, spelling variants, and likely learner queries.

Rules:

- Must not be empty.
- Do not add noisy or obscure forms.
- Include only forms useful for app search.

## Somali Block

`somali.primary_translation`

The main Somali translation used in lists, cards, and quick lookup.

This is the default display translation for the primary sense. The first sense in the `senses` array is the primary display sense, and its `primary_translation` must exactly match `somali.primary_translation`.

`somali.alternative_translations`

Other natural Somali translations.

This field contains common cross-sense display alternatives only. Sense-specific translations must be authored inside the relevant sense and must not be stored only at the top level.

`somali.regional_variants`

Array of regional or spelling variants. Each item contains:

- `form`
- `region`
- `note`

`somali.native_somali_alternatives`

Native Somali alternatives when the primary translation is a loanword or when a more Somali phrasing is useful.

`somali.loanword_information`

Structured loanword metadata:

- `is_loanword`
- `source_language`
- `note`

Use `source_language: null` and `note: null` when not a loanword.

`somali.somali_explanation`

Plain Somali explanation for learners.

`somali.search_forms`

Somali forms users may search for, including common spelling variants.

Rules:

- Do not assume one Somali translation is always enough.
- Do not force regional variants when none are known.
- Translation, explanation, and examples must be natural Somali.
- The first sense must represent the primary sense.
- The first sense's `primary_translation` must equal `somali.primary_translation`.
- Every sense must contain its own precise Somali translation.
- Custom validation must fail when the top-level Somali translation does not match sense 1.

## Linguistics

`linguistics.part_of_speech`

Allowed values:

- `noun`
- `verb`
- `adjective`
- `adverb`
- `phrase`
- `preposition`
- `conjunction`
- `pronoun`
- `determiner`
- `interjection`
- `number`
- `abbreviation`

`linguistics.cefr_level`

Allowed values:

- `A1`
- `A2`
- `B1`
- `B2`

CEFR appears only here. Do not duplicate CEFR as educational difficulty.

`linguistics.frequency`

Allowed values:

- `very_common`
- `common`
- `useful`
- `specialized`

## Pronunciation

`linguistics.pronunciation.british_ipa`

British English IPA, or `null` when intentionally unavailable.

When present, it must be enclosed in slashes, for example `/ˈpɑːs.pɔːt/`.

`linguistics.pronunciation.american_ipa`

American English IPA, or `null` when intentionally unavailable.

When present, it must be enclosed in slashes, for example `/ˈpæs.pɔːrt/`.

`linguistics.pronunciation.syllables`

Syllable breakdown for pronunciation practice.

`linguistics.pronunciation.stress_index`

Zero-based index of the stressed syllable.

Example:

- `["ap", "point", "ment"]`
- `stress_index: 1`

`linguistics.pronunciation.audio_key`

Future stable audio key. This is not a local file path.

Rules:

- IPA must be reviewed, not guessed casually.
- IPA fields must not contain ordinary headword spelling.
- IPA values must be professionally verified.
- Syllables and stress index must agree.
- If `stress_index` is not `null`, it must point to an existing syllable.
- If `syllables` is empty, `stress_index` must be `null`.
- If syllables exist and stress applies, `stress_index` must not be `null`.
- Audio keys should be stable and content-addressable, such as `audio_vocab_appointment_en_us`.
- `audio_key` is a stable future asset key and must never be a local file path.
- Custom validation must check that `stress_index` is smaller than the number of syllables.

## Morphology

`linguistics.morphology.countability`

Allowed values:

- `countable`
- `uncountable`
- `both`
- `not_applicable`

Use `not_applicable` for non-nouns.

`linguistics.morphology.plural_form`

Manually authored plural form, or `null`.

`linguistics.morphology.transitivity`

Allowed values:

- `transitive`
- `intransitive`
- `both`
- `not_applicable`

Use `not_applicable` for non-verbs.

`linguistics.morphology.verb_forms`

Contains:

- `base`
- `third_person`
- `past_simple`
- `past_participle`
- `present_participle`

Use `null` values for non-verbs.

`linguistics.morphology.adjective_comparison`

Contains:

- `comparison_type`
- `comparative`
- `superlative`

Use `null` values for non-adjectives or adjectives that do not naturally compare.

Allowed `comparison_type` values:

- `regular`
- `irregular`
- `not_comparable`
- `not_applicable`

Rules:

- Non-adjectives must use `comparison_type: not_applicable`, `comparative: null`, and `superlative: null`.
- Comparable adjectives use `regular` or `irregular` and must include authored comparative and superlative forms.
- Non-comparable adjectives use `not_comparable`, `comparative: null`, and `superlative: null`.

Morphology rules:

- Never automatically generate plural forms.
- Never automatically generate verb forms.
- Irregular forms must always be authored manually.
- Regular forms must still be authored manually.
- Multi-word expressions must not receive fake plurals.
- Phrase records should use `countability: not_applicable`, `plural_form: null`, and `transitivity: not_applicable` unless the phrase is explicitly verbal and reviewed as such.

Conditional schema rules:

- Nouns may use `countable`, `uncountable`, or `both`; their `transitivity` must be `not_applicable`, and all verb forms must be `null`.
- Non-nouns must use `countability: not_applicable` and `plural_form: null`.
- Verbs may use `transitive`, `intransitive`, or `both`; all verb forms must be manually authored.
- Non-verbs must use `transitivity: not_applicable` and all verb-form fields must be `null`.
- Only adjectives may contain comparison forms.

## Senses

Some English words have multiple meanings, such as `bill`, `charge`, `bank`, `light`, `appointment`, and `address`.

Use `senses` to model meanings inside one vocabulary record.

Each sense contains:

- `sense_id`
- `sense_number`
- `english_definition`
- `somali_definition`
- `primary_translation`
- `alternative_translations`
- `examples`
- `origin`

Rules:

- `sense_number` starts at 1.
- Sense numbers must be unique inside the record.
- Sense IDs must be unique inside the record.
- Sense numbers must be consecutive.
- The first array item must use `sense_number: 1`.
- The first sense is the default display sense.
- The first sense's `primary_translation` must match top-level `somali.primary_translation`.
- Duplicate definitions are forbidden inside one record.
- Duplicate translation sets are forbidden inside one record.
- Do not split ordinary meanings into duplicate vocabulary records.
- Do split unrelated homographs only if they create different curriculum needs and different learning behavior.
- Sense definitions must be learner-friendly, not dictionary jargon.
- Exact duplicate sense objects are blocked by schema with `uniqueItems: true`, but semantic uniqueness requires custom validation.

`sense.origin`

Sense-level source traceability. Different meanings of the same headword may come from different origins.

Fields:

- `reference_type`
- `section`
- `page_reference`
- `source_term`

Use sense-level origin to avoid one top-level source label incorrectly describing all meanings.

## Examples

Each sense must include 2 to 5 examples.

Each example contains:

- `english`
- `somali`
- `situation`
- `cefr_level`

Rules:

- Examples must be original.
- Examples must sound like phrasebook language.
- Somali examples should translate meaning naturally, not mirror English word order.
- Do not duplicate examples inside a record.
- At least one example should match the primary subcategory.

## Collocations

`collocations`

Natural word combinations that help learners speak fluently.

Each item contains:

- `english`
- `somali`
- `usage`
- `sense_id`

Good examples:

- `make an appointment`
- `pay the bill`
- `catch a bus`
- `open an account`
- `brush your teeth`

Rules:

- Use natural English only.
- Do not invent awkward combinations to fill space.
- Use `sense_id` when the collocation belongs to one meaning.
- Use `sense_id: null` only when it applies generally to the headword.
- Collocations must not duplicate examples.

## Related Language

`related_language.synonyms`

Near-synonyms, with a note and optional `sense_id`.

Rules:

- Use only real, useful synonyms.
- Do not add weak thesaurus filler.
- Leave empty when no useful synonym belongs in phrasebook learning.

`related_language.antonyms`

True opposites, with a note and optional `sense_id`.

Rules:

- Leave empty when there is no true useful opposite.
- Do not use contextual alternatives as antonyms.

`related_language.word_family`

Morphological relatives only.

Allowed relationship labels:

- `base`
- `noun`
- `verb`
- `adjective`
- `adverb`
- `person_form`
- `derived_form`

Rules:

- `appoint`, `appointed`, and `appointment` may belong to the same word family.
- `passport office` is not a word family item.
- `restaurant staff` is not a word family item.
- Compounds belong in collocations or related vocabulary, not word family.

`related_language.related_vocabulary`

Vocabulary IDs for closely related records.

Rules:

- Use IDs, not display terms.
- IDs must exist once vocabulary generation begins.
- Related vocabulary must be useful for learning or communication.

## Usage Notes

`usage_notes.register`

Allowed values:

- `neutral`
- `formal`
- `informal`
- `polite`
- `spoken`
- `written`
- `technical`

`usage_notes.regional_labels`

Allowed values:

- `general`
- `British English`
- `American English`
- `Somali usage note`

`usage_notes.common_mistakes`

Practical learner mistakes.

`usage_notes.false_friends`

Misleading lookalikes or translation traps.

`usage_notes.cultural_notes`

Useful cultural or practical notes.

Rules:

- Do not add filler notes.
- Prefer empty arrays over generic advice.
- Notes must help real communication.

## Educational Metadata

`educational_metadata.learning_priority`

Allowed values:

- `essential`
- `high`
- `medium`
- `supporting`

This replaces the old duplicated educational difficulty field.

`educational_metadata.teaching_stage`

Allowed values:

- `survival_foundation`
- `core_phrasebook`
- `expanded_use`
- `contextual_fluency`

`educational_metadata.learning_order`

The ordering scope is explicitly `within_subcategory`.

Fields:

- `scope`
- `position`

Rules:

- `scope` must be `within_subcategory`.
- `position` is a positive integer.
- Lower positions are taught earlier inside the primary subcategory.
- Do not use this field as a global order.

`educational_metadata.search_keywords`

At least three useful search terms across English, Somali, and intent.

`educational_metadata.tags`

At least three tags for filtering and content generation.

`educational_metadata.communicative_situations`

Real situations where learners use the word.

`educational_metadata.why_in_phrasebook`

Short editorial justification for inclusion.

## Learning Relationships

Vocabulary should not know every future dialogue, quiz, story, or listening item.

Future content seeds should reference vocabulary IDs, not the other way around.

Keep only vocabulary-centric relationships:

- `prerequisite_vocabulary`
- `confused_with_vocabulary`
- `often_used_with_vocabulary`
- `grammar_points`
- `spaced_repetition`

`spaced_repetition.deck`

Allowed values:

- `survival`
- `daily_life`
- `travel`
- `services`
- `work_school`
- `health`
- `custom`

`spaced_repetition.priority`

Integer from 1 to 5, where 1 is highest.

`spaced_repetition.initial_interval_hint_days`

Positive integer for the seed's initial review suggestion.

Rules:

- This is only a default seed suggestion.
- It is not the learner's current interval.
- It must never be updated inside the seed file.
- Actual scheduling belongs to the learner-progress database.

## Source Traceability

`source_traceability`

Structured source auditing object.

Fields:

- `source`
- `reference_type`
- `section`
- `page_reference`
- `source_term`
- `copyright_policy_acknowledged`

Allowed `reference_type` values:

- `reference_structure`
- `reference_term`
- `editorial_addition`
- `modern_extension`

Rules:

- Use `reference_structure` when the book informed the category, topic, or communicative organization.
- Use `reference_term` when the vocabulary term is explicitly present in the reference.
- Use `editorial_addition` when editors add a word because it clearly belongs to an existing phrasebook situation.
- Use `modern_extension` for current practical language not present in the older reference.
- Do not use terminology that implies complete text was copied from the book.
- `page_reference.start_page` and `page_reference.end_page` may both be `null` for original editorial additions or modern extensions.
- If one page value exists, both must exist.
- `end_page` must be greater than or equal to `start_page`.
- Custom validation must fail incomplete or reversed page ranges.
- `copyright_policy_acknowledged` must be `true`.

## Review Workflow

Use independent review states:

- `english_review`
- `somali_review`
- `linguistic_review`
- `editorial_review`

Each review contains:

- `status`
- `reviewer`
- `reviewed_at`
- `notes`

Allowed statuses:

- `draft`
- `needs_review`
- `reviewed`
- `approved`

Rules:

- A record is publication-ready only when all review states are `approved`.
- `reviewer` and `reviewed_at` may be `null` before review.
- `reviewed_at` must be ISO 8601 date-time when present.
- `reviewed` and `approved` states must include a non-empty `reviewer`.
- `reviewed` and `approved` states must include a valid `reviewed_at` date-time.
- `draft` and `needs_review` states may use `reviewer: null` and `reviewed_at: null`.
- An approved record must not have any review section still marked `draft`; custom cross-review validation must enforce this before publication.

## Validation Rules

Machine validation:

- JSON must be valid UTF-8 JSON.
- Every record must pass `vocabulary_schema.json`.
- Unknown properties are not allowed.
- Required fields must always exist.
- Empty strings are not allowed where `non_empty_string` is used.
- Arrays with `uniqueItems` must not contain duplicates.

Cross-reference validation:

- `curriculum.primary_category_code` must exist in `categories_seed.json`.
- `curriculum.primary_subcategory_code` must exist in `subcategories_seed.json`.
- The primary subcategory must belong to the primary category.
- Every `related_subcategory_codes` value must exist in `subcategories_seed.json`.
- Related subcategories must belong to real curriculum topics and must not be placeholders.
- Every related vocabulary ID must exist once vocabulary generation begins.
- Vocabulary relationship arrays must not reference the current record's own ID.
- Relationship IDs must not be duplicated.
- Grammar point IDs must exist once grammar seeds are introduced.
- Prerequisite vocabulary links must not be circular.

Duplicate validation:

- Vocabulary IDs must be globally unique.
- Lemmas with indistinguishable senses must not be duplicated.
- Lemmas should not be duplicated for the same part of speech unless a reviewed editorial note explains why.
- Sense IDs must be unique inside a record.
- Sense numbers must be unique inside a record.
- Sense numbering must begin at 1 and be consecutive.
- The first array item must have `sense_number: 1`.
- Duplicate definitions are forbidden inside one record.
- Duplicate translation sets are forbidden inside one record.
- Duplicate primary translations inside one record must be audited and justified.
- Primary and alternative translations must not duplicate each other.
- Examples must not duplicate each other inside a sense or record.
- Examples must contain the target word or a valid inflected/translated form unless a reviewer documents why not.
- Collocations must not duplicate each other inside a record.
- Search forms must not be empty and must not duplicate each other.
- Exact duplicate objects are blocked with `uniqueItems: true` for `senses`, `collocations`, `regional_variants`, `synonyms`, `antonyms`, and `word_family`; semantic duplication still requires custom validation.

Pronunciation validation:

- `stress_index` must be `null` or a valid zero-based index into `syllables`.
- British IPA and American IPA should be reviewed independently.
- IPA strings must be slash-delimited and must not be plain headword spelling.
- Syllable breakdown must match the headword, not the Somali translation.
- `audio_key` must be stable when provided.

Morphology validation:

- Countable nouns should have a manually authored `plural_form`.
- Uncountable nouns should use `plural_form: null` unless a reviewed exception applies.
- Non-nouns should use `countability: not_applicable`.
- Verbs should have manually authored verb forms.
- Non-verbs should use null verb-form values and `transitivity: not_applicable`.
- Multi-word expressions must not receive fake plural or verb forms.

Translation validation:

- Top-level `somali.primary_translation` must equal the first sense's `primary_translation`.
- Sense-specific translations must not be placed only in the top-level Somali block.

Source validation:

- Source page ranges must not be reversed.
- Source page ranges must not be incomplete.
- Null page ranges are valid only where the reference type does not require a specific page.
- Sense-level origins must be present for every sense.

Review validation:

- `reviewed` and `approved` review states must include a reviewer and valid date-time.
- A publication-approved record must not contain any review section still marked `draft`.
- The audit must exit with a non-zero status when critical errors are found.

Editorial validation:

- Reject placeholder translations.
- Reject template examples.
- Reject generated word-number combinations.
- Reject generic definitions.
- Reject generic Somali explanations.
- Reject fake pronunciation.
- Reject automatic plurals.
- Reject automatic verb forms.
- Reject long copied reference passages.
- Reject complete copied dialogues.
- Reject obscure academic words with no phrasebook situation.
- Reject unnecessary business jargon unless required by the curriculum.
- Reject weak synonyms, fake antonyms, and compound phrases placed in word family.
- Reject repeated examples across unrelated words.
- Reject template sentences with only the headword replaced.
- Reject filler metadata added only to meet array targets.

## Future Feature Support

This schema supports future features without structural changes:

- Search
- Favorites
- Flashcards
- Word of the Day
- Daily Review
- Offline learning
- Pronunciation practice
- Listening
- AI conversation
- Role plays
- Stories
- Quizzes
- Grammar

Future content seeds should reference `vocab_*` IDs as needed.

## Example Records

The following records demonstrate the schema. They are examples only and should not be treated as generated vocabulary seed content.

```json
[
  {
    "id": "vocab_passport",
    "curriculum": {
      "primary_category_code": "transportation",
      "primary_subcategory_code": "transportation_airport",
      "related_subcategory_codes": ["personal_information_nationality"],
      "placement_note": "Introduced in airport travel because learners usually need this word first at check-in, security, and passport control."
    },
    "english": {
      "headword": "passport",
      "lemma": "passport",
      "alternative_spellings": [],
      "abbreviation": null,
      "search_forms": ["passport", "passports", "travel document"]
    },
    "somali": {
      "primary_translation": "baasaboor",
      "alternative_translations": ["dukumenti safar"],
      "regional_variants": [],
      "native_somali_alternatives": ["dukumenti safar"],
      "loanword_information": {
        "is_loanword": true,
        "source_language": "English",
        "note": "Baasaboor is a common Somali loanword used for passport."
      },
      "somali_explanation": "Baasaboor waa dukumenti rasmi ah oo lagu aqoonsado qofka marka uu safar dibadda ah galayo.",
      "search_forms": ["baasaboor", "baasabooro", "dukumenti safar"]
    },
    "linguistics": {
      "part_of_speech": "noun",
      "cefr_level": "A1",
      "frequency": "very_common",
      "pronunciation": {
        "british_ipa": "/ˈpɑːs.pɔːt/",
        "american_ipa": "/ˈpæs.pɔːrt/",
        "syllables": ["pass", "port"],
        "stress_index": 0,
        "audio_key": "audio_vocab_passport_en"
      },
      "morphology": {
        "countability": "countable",
        "plural_form": "passports",
        "transitivity": "not_applicable",
        "verb_forms": {
          "base": null,
          "third_person": null,
          "past_simple": null,
          "past_participle": null,
          "present_participle": null
        },
        "adjective_comparison": {
          "comparison_type": "not_applicable",
          "comparative": null,
          "superlative": null
        }
      }
    },
    "senses": [
      {
        "sense_id": "sense_travel_document",
        "sense_number": 1,
        "english_definition": "An official document that shows who you are and lets you travel to another country.",
        "somali_definition": "Dukumenti rasmi ah oo muujinaya aqoonsigaaga, laguna isticmaalo safarka dalalka kale.",
        "primary_translation": "baasaboor",
        "alternative_translations": ["dukumenti safar"],
        "examples": [
          {
            "english": "Please keep your passport with you at the airport.",
            "somali": "Fadlan baasaboorkaaga ha kula jiro garoonka diyaaradaha.",
            "situation": "airport check-in",
            "cefr_level": "A1"
          },
          {
            "english": "Can I see your passport, please?",
            "somali": "Ma arki karaa baasaboorkaaga, fadlan?",
            "situation": "passport control",
            "cefr_level": "A1"
          },
          {
            "english": "I need to renew my passport before I travel.",
            "somali": "Waxaan u baahanahay inaan cusbooneysiiyo baasaboorkayga ka hor inta aanan safrin.",
            "situation": "preparing for travel",
            "cefr_level": "A2"
          }
        ],
        "origin": {
          "reference_type": "reference_term",
          "section": "Travel and airport vocabulary",
          "page_reference": {
            "start_page": null,
            "end_page": null
          },
          "source_term": "passport"
        }
      }
    ],
    "collocations": [
      {
        "english": "show your passport",
        "somali": "tus baasaboorkaaga",
        "usage": "Used when an officer or staff member needs to check identity.",
        "sense_id": "sense_travel_document"
      },
      {
        "english": "renew a passport",
        "somali": "cusbooneysii baasaboor",
        "usage": "Used when replacing an old or expired passport.",
        "sense_id": "sense_travel_document"
      },
      {
        "english": "passport control",
        "somali": "kontoroolka baasaboorka",
        "usage": "Used at the airport or border where passports are checked.",
        "sense_id": "sense_travel_document"
      }
    ],
    "related_language": {
      "synonyms": [
        {
          "term": "travel document",
          "sense_id": "sense_travel_document",
          "note": "Broader phrase; not every travel document is a passport."
        }
      ],
      "antonyms": [],
      "word_family": [],
      "related_vocabulary": []
    },
    "usage_notes": {
      "register": ["neutral"],
      "regional_labels": ["general"],
      "common_mistakes": ["Do not use passport for every ID card. A passport is specifically for international travel."],
      "false_friends": [],
      "cultural_notes": ["At airports, learners may need to show a passport several times: check-in, security, and passport control."]
    },
    "educational_metadata": {
      "learning_priority": "essential",
      "teaching_stage": "survival_foundation",
      "learning_order": {
        "scope": "within_subcategory",
        "position": 1
      },
      "search_keywords": ["passport", "baasaboor", "airport", "travel", "identity"],
      "tags": ["travel", "airport", "documents", "identity"],
      "communicative_situations": ["checking in at the airport", "crossing a border", "renewing travel documents"],
      "why_in_phrasebook": "Learners need this word for airport, border, hotel, and official travel conversations."
    },
    "learning_relationships": {
      "prerequisite_vocabulary": [],
      "confused_with_vocabulary": [],
      "often_used_with_vocabulary": [],
      "grammar_points": ["countable_nouns"],
      "spaced_repetition": {
        "deck": "travel",
        "priority": 1,
        "initial_interval_hint_days": 1
      }
    },
    "source_traceability": {
      "source": "English-Somali Phrasebook with Useful Wordlist",
      "reference_type": "reference_term",
      "section": "Travel and airport vocabulary",
      "page_reference": {
        "start_page": null,
        "end_page": null
      },
      "source_term": "passport",
      "copyright_policy_acknowledged": true
    },
    "review_workflow": {
      "english_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "somali_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "linguistic_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "editorial_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      }
    }
  },
  {
    "id": "vocab_restaurant",
    "curriculum": {
      "primary_category_code": "food",
      "primary_subcategory_code": "food_restaurant",
      "related_subcategory_codes": ["locations_asking_directions"],
      "placement_note": "Introduced in food because learners need it when choosing where to eat, asking directions, and ordering meals."
    },
    "english": {
      "headword": "restaurant",
      "lemma": "restaurant",
      "alternative_spellings": [],
      "abbreviation": null,
      "search_forms": ["restaurant", "restaurants", "place to eat"]
    },
    "somali": {
      "primary_translation": "maqaayad",
      "alternative_translations": ["makhaayad"],
      "regional_variants": [
        {
          "form": "makhaayad",
          "region": "general Somali spelling variant",
          "note": "Common spelling variant for the same everyday meaning."
        }
      ],
      "native_somali_alternatives": [],
      "loanword_information": {
        "is_loanword": false,
        "source_language": null,
        "note": null
      },
      "somali_explanation": "Maqaayad waa meel cunto iyo cabitaan lagu dalbado laguna cuno.",
      "search_forms": ["maqaayad", "makhaayad", "meel cunto"]
    },
    "linguistics": {
      "part_of_speech": "noun",
      "cefr_level": "A1",
      "frequency": "very_common",
      "pronunciation": {
        "british_ipa": "/ˈres.tər.ɒnt/",
        "american_ipa": "/ˈres.tə.rɑːnt/",
        "syllables": ["res", "tau", "rant"],
        "stress_index": 0,
        "audio_key": "audio_vocab_restaurant_en"
      },
      "morphology": {
        "countability": "countable",
        "plural_form": "restaurants",
        "transitivity": "not_applicable",
        "verb_forms": {
          "base": null,
          "third_person": null,
          "past_simple": null,
          "past_participle": null,
          "present_participle": null
        },
        "adjective_comparison": {
          "comparison_type": "not_applicable",
          "comparative": null,
          "superlative": null
        }
      }
    },
    "senses": [
      {
        "sense_id": "sense_place_to_eat",
        "sense_number": 1,
        "english_definition": "A place where people pay to sit and eat a meal.",
        "somali_definition": "Meel dadka cunto ka dalbadaan, lacag bixiyaan, kuna cunaan.",
        "primary_translation": "maqaayad",
        "alternative_translations": ["makhaayad"],
        "examples": [
          {
            "english": "Is there a good restaurant near here?",
            "somali": "Ma jirtaa maqaayad fiican oo halkan u dhow?",
            "situation": "asking for a place to eat",
            "cefr_level": "A1"
          },
          {
            "english": "The restaurant is open until ten o'clock.",
            "somali": "Maqaayaddu waxay furan tahay ilaa tobanka fiidnimo.",
            "situation": "checking opening hours",
            "cefr_level": "A2"
          },
          {
            "english": "We are going to a Somali restaurant tonight.",
            "somali": "Caawa waxaan aadaynaa maqaayad Soomaali ah.",
            "situation": "making plans",
            "cefr_level": "A2"
          }
        ],
        "origin": {
          "reference_type": "reference_term",
          "section": "Food and restaurant vocabulary",
          "page_reference": {
            "start_page": null,
            "end_page": null
          },
          "source_term": "restaurant"
        }
      }
    ],
    "collocations": [
      {
        "english": "book a table",
        "somali": "miis sii qabsasho",
        "usage": "Used when arranging a place to sit before going to a restaurant.",
        "sense_id": "sense_place_to_eat"
      },
      {
        "english": "order at a restaurant",
        "somali": "cunto ka dalbo maqaayad",
        "usage": "Used when asking for food or drink from staff.",
        "sense_id": "sense_place_to_eat"
      },
      {
        "english": "pay the bill",
        "somali": "bixi biilka",
        "usage": "Used at the end of a meal.",
        "sense_id": "sense_place_to_eat"
      }
    ],
    "related_language": {
      "synonyms": [],
      "antonyms": [],
      "word_family": [],
      "related_vocabulary": []
    },
    "usage_notes": {
      "register": ["neutral"],
      "regional_labels": ["general"],
      "common_mistakes": ["Do not confuse restaurant with kitchen. A kitchen is where food is cooked; a restaurant is where customers eat."],
      "false_friends": [],
      "cultural_notes": ["Restaurant is often learned together with table, menu, bill, waiter, and order."]
    },
    "educational_metadata": {
      "learning_priority": "essential",
      "teaching_stage": "survival_foundation",
      "learning_order": {
        "scope": "within_subcategory",
        "position": 1
      },
      "search_keywords": ["restaurant", "maqaayad", "food", "eat", "menu"],
      "tags": ["food", "restaurant", "ordering", "daily life"],
      "communicative_situations": ["finding somewhere to eat", "ordering food", "paying after a meal"],
      "why_in_phrasebook": "Learners need this word for food, travel, invitations, directions, and everyday meal conversations."
    },
    "learning_relationships": {
      "prerequisite_vocabulary": [],
      "confused_with_vocabulary": [],
      "often_used_with_vocabulary": [],
      "grammar_points": ["countable_nouns"],
      "spaced_repetition": {
        "deck": "daily_life",
        "priority": 1,
        "initial_interval_hint_days": 1
      }
    },
    "source_traceability": {
      "source": "English-Somali Phrasebook with Useful Wordlist",
      "reference_type": "reference_term",
      "section": "Food and restaurant vocabulary",
      "page_reference": {
        "start_page": null,
        "end_page": null
      },
      "source_term": "restaurant",
      "copyright_policy_acknowledged": true
    },
    "review_workflow": {
      "english_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "somali_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "linguistic_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "editorial_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      }
    }
  },
  {
    "id": "vocab_appointment",
    "curriculum": {
      "primary_category_code": "time",
      "primary_subcategory_code": "time_appointments",
      "related_subcategory_codes": ["health_doctor_visit", "jobs_interviews", "jobs_office"],
      "placement_note": "Introduced in time because the core meaning is arranging a planned time; it is reused in health, job interview, and office conversations."
    },
    "english": {
      "headword": "appointment",
      "lemma": "appointment",
      "alternative_spellings": [],
      "abbreviation": null,
      "search_forms": ["appointment", "appointments", "booking", "meeting time"]
    },
    "somali": {
      "primary_translation": "ballan",
      "alternative_translations": ["waqti ballansan"],
      "regional_variants": [
        {
          "form": "balan",
          "region": "informal spelling variant",
          "note": "Common unstandardized spelling without doubled l."
        }
      ],
      "native_somali_alternatives": ["waqti ballansan"],
      "loanword_information": {
        "is_loanword": false,
        "source_language": null,
        "note": null
      },
      "somali_explanation": "Ballan waa waqti horay loo sii qorsheeyay oo qof ama adeeg lala kulmayo.",
      "search_forms": ["ballan", "balan", "waqti ballansan"]
    },
    "linguistics": {
      "part_of_speech": "noun",
      "cefr_level": "A2",
      "frequency": "common",
      "pronunciation": {
        "british_ipa": "/əˈpɔɪnt.mənt/",
        "american_ipa": "/əˈpɔɪnt.mənt/",
        "syllables": ["ap", "point", "ment"],
        "stress_index": 1,
        "audio_key": "audio_vocab_appointment_en"
      },
      "morphology": {
        "countability": "countable",
        "plural_form": "appointments",
        "transitivity": "not_applicable",
        "verb_forms": {
          "base": null,
          "third_person": null,
          "past_simple": null,
          "past_participle": null,
          "present_participle": null
        },
        "adjective_comparison": {
          "comparison_type": "not_applicable",
          "comparative": null,
          "superlative": null
        }
      }
    },
    "senses": [
      {
        "sense_id": "sense_planned_time",
        "sense_number": 1,
        "english_definition": "A planned time to meet someone or receive a service.",
        "somali_definition": "Waqti la sii qorsheeyay oo aad qof, dhakhtar, xafiis, ama adeeg kula kulmayso.",
        "primary_translation": "ballan",
        "alternative_translations": ["waqti ballansan"],
        "examples": [
          {
            "english": "I have a doctor's appointment at nine.",
            "somali": "Waxaan leeyahay ballan dhakhtar sagaalka.",
            "situation": "talking about a medical visit",
            "cefr_level": "A2"
          },
          {
            "english": "Can I make an appointment for tomorrow?",
            "somali": "Ma samaysan karaa ballan berri?",
            "situation": "booking a service",
            "cefr_level": "A2"
          },
          {
            "english": "I need to cancel my appointment.",
            "somali": "Waxaan u baahanahay inaan baajiyo ballantayda.",
            "situation": "changing plans",
            "cefr_level": "A2"
          }
        ],
        "origin": {
          "reference_type": "reference_term",
          "section": "Time and appointments vocabulary",
          "page_reference": {
            "start_page": null,
            "end_page": null
          },
          "source_term": "appointment"
        }
      }
    ],
    "collocations": [
      {
        "english": "make an appointment",
        "somali": "samayso ballan",
        "usage": "Used when arranging a time to meet or receive a service.",
        "sense_id": "sense_planned_time"
      },
      {
        "english": "cancel an appointment",
        "somali": "baaji ballan",
        "usage": "Used when you cannot attend a planned time.",
        "sense_id": "sense_planned_time"
      },
      {
        "english": "confirm an appointment",
        "somali": "xaqiiji ballan",
        "usage": "Used when checking that a planned time is still correct.",
        "sense_id": "sense_planned_time"
      }
    ],
    "related_language": {
      "synonyms": [
        {
          "term": "booking",
          "sense_id": "sense_planned_time",
          "note": "Useful for services and reservations, but not always for medical or official appointments."
        }
      ],
      "antonyms": [],
      "word_family": [
        {
          "term": "appoint",
          "relationship": "verb",
          "note": "Related verb, but it usually means choosing someone for a job or role."
        },
        {
          "term": "appointed",
          "relationship": "derived_form",
          "note": "Related form used in phrases such as appointed time or appointed person."
        }
      ],
      "related_vocabulary": []
    },
    "usage_notes": {
      "register": ["neutral", "polite"],
      "regional_labels": ["general"],
      "common_mistakes": ["Use make an appointment, not do an appointment."],
      "false_friends": [],
      "cultural_notes": ["Appointment is useful for clinics, offices, banks, schools, and many public services."]
    },
    "educational_metadata": {
      "learning_priority": "high",
      "teaching_stage": "core_phrasebook",
      "learning_order": {
        "scope": "within_subcategory",
        "position": 1
      },
      "search_keywords": ["appointment", "ballan", "booking", "doctor", "meeting"],
      "tags": ["time", "appointments", "health", "services"],
      "communicative_situations": ["booking a doctor visit", "changing a planned time", "checking an office appointment"],
      "why_in_phrasebook": "Learners need this word when arranging services, visiting clinics, speaking with offices, and managing time politely."
    },
    "learning_relationships": {
      "prerequisite_vocabulary": [],
      "confused_with_vocabulary": [],
      "often_used_with_vocabulary": [],
      "grammar_points": ["countable_nouns", "make_collocations"],
      "spaced_repetition": {
        "deck": "services",
        "priority": 2,
        "initial_interval_hint_days": 2
      }
    },
    "source_traceability": {
      "source": "English-Somali Phrasebook with Useful Wordlist",
      "reference_type": "reference_term",
      "section": "Time and appointments vocabulary",
      "page_reference": {
        "start_page": null,
        "end_page": null
      },
      "source_term": "appointment",
      "copyright_policy_acknowledged": true
    },
    "review_workflow": {
      "english_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "somali_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "linguistic_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      },
      "editorial_review": {
        "status": "draft",
        "reviewer": null,
        "reviewed_at": null,
        "notes": []
      }
    }
  }
]
```
