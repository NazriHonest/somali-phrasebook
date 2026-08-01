# Content Audit Report

Command:

```bash
dart run tool/audit_content.dart
```

Latest result:

```text
seed_version: 2
total categories: 19
total subcategories: 95
total expressions: 38
total dialogues: 19
total dialogue lines: 114
total question-answer pairs: 38
total unique vocabulary entries: 39
total Somali translations: 39
total examples: 77
total signs: 25
duplicate count: 0
repeated-template count: 0
invalid-headword count: 0
generic-definition count: 0
generic-somali-explanation count: 0
generic-example count: 0
missing-translation count: 0
missing-example count: 0
invalid-relation count: 0
fake-pronunciation count: 0
invalid-part-of-speech count: 0
```

Category counts:

```text
Coping with the Language Barrier: sub=5 expr=2 dlg=1 qa=2 vocab=2
Useful Forms of Etiquette: sub=5 expr=2 dlg=1 qa=2 vocab=2
Giving Information About Yourself: sub=5 expr=2 dlg=1 qa=2 vocab=2
Recognizing Signs: sub=5 expr=2 dlg=1 qa=2 vocab=2
Weights and Measures: sub=5 expr=2 dlg=1 qa=2 vocab=2
Using Numbers: sub=5 expr=2 dlg=1 qa=2 vocab=2
Dealing with Money: sub=5 expr=2 dlg=1 qa=2 vocab=2
Dealing with Time: sub=5 expr=2 dlg=1 qa=2 vocab=3
Locating Things: sub=5 expr=2 dlg=1 qa=2 vocab=2
Describing Things and People: sub=5 expr=2 dlg=1 qa=2 vocab=2
Doing Things: sub=5 expr=2 dlg=1 qa=2 vocab=2
Going Places: sub=5 expr=2 dlg=1 qa=2 vocab=2
Conveying Information: sub=5 expr=2 dlg=1 qa=2 vocab=2
Health and Hygiene: sub=5 expr=2 dlg=1 qa=2 vocab=2
Food: sub=5 expr=2 dlg=1 qa=2 vocab=2
Clothing: sub=5 expr=2 dlg=1 qa=2 vocab=2
Housing: sub=5 expr=2 dlg=1 qa=2 vocab=2
Jobs: sub=5 expr=2 dlg=1 qa=2 vocab=2
About Schools: sub=5 expr=2 dlg=1 qa=2 vocab=2
```

The audit rejects template-generated filler, numbered headwords, generic definitions, generic Somali explanations, repeated expression examples, vocabulary examples that omit the target word or valid form, fake pronunciation fields, duplicate seeded content, missing translations, missing examples, and invalid relationships.
