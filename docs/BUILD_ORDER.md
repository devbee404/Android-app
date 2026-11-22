# Step-by-step build order

## Phase 1 — Noorani Qaida (start here)
1. Agree a lesson syllabus with a qualified qari/scholar: isolated letters, letter forms, harakat, tanween, sukoon, madd, shaddah, joined reading and practice.
2. Author original lesson records in `assets/data/qaida/lessons.json`; every lesson and item must have `source` and review status.
3. Record each letter/word audio with a qualified qari. Obtain written distribution permission; store compressed mono audio and metadata.
4. Build a Qaida lesson list and lesson reader. Make each Arabic token tappable and play its local audio with `just_audio`.
5. Save completed lessons and quiz scores locally. Add a short lesson quiz.
6. Add tests for JSON validation, lesson ordering, audio missing-file behavior and progress persistence.
7. Have the entire module reviewed before marking any item `verified`.

## Phase 2 — Namaz Shikkha
1. Define wudu and salah lesson sequence with local scholar review.
2. Add per-step Arabic, Bangla pronunciation, meaning and instruction only when verified.
3. Create original illustrations or obtain CC0/CC-BY assets and record per-image credits.
4. Add offline audio and step navigation.

## Phase 3 — Dua and Zikr
1. Confirm exact Hisnul Muslim Bangla edition and written reuse permission.
2. Enter Arabic, transliteration, meaning, hadith reference and source.
3. Implement category filters, bookmarks and a persistent zikr counter.
4. Do not publish entries with missing references or unresolved rights.

## Phase 4 — Short Surahs
1. Import the exact Tanzil Arabic text verbatim; preserve its copyright notice.
2. Select a Bangla translation with explicit redistribution rights.
3. Select one reciter and obtain rights for the exact offline audio recordings.
4. Implement surah/ayah reader and repeat/loop controls.

## Phase 5 — Prayer times
1. Bundle Bangladesh district coordinates with source/version metadata.
2. Add manual district selection first; GPS is optional.
3. Calculate on-device using `adhan_dart`, Karachi calculation parameters and Hanafi Asr.
4. Add local notifications and handle Android notification/exact-alarm permission changes.
5. Validate sample dates against a trusted local timetable and document expected calculation differences.

## Phase 6 — Quiz, settings and monetization
1. Write quiz questions from verified content and store source IDs.
2. Add levels, score, local progress and rewarded hint flow.
3. Add light/dark/AMOLED theme, font size, language and notification settings.
4. Add banner ads only to list screens; never show ads in Quran, Dua or Qaida readers.
5. Add one-time ad-free product with `in_app_purchase`. Treat client-side/local purchase state as convenience, not tamper-proof verification; query Play purchase state, acknowledge/complete purchases as required, and provide restore purchases. Do not claim secure local verification is possible without a trusted verifier.
6. Test airplane mode, denied permissions, empty ad response, billing errors, low storage and app restart.

## Release checklist
- All religious content reviewed by qualified people.
- Every content item has `source`; hadith/dua records have explicit references.
- All bundled fonts, images, text and audio have documented redistribution rights.
- Tanzil text remains unchanged and attribution is present.
- No content API, login, backend or analytics network calls.
- App remains fully usable in airplane mode.
