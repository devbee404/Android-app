# Content JSON contracts (v1)

All records must include `id` and `source`. Religious content must also include a reference where applicable and a review status. Do not ship unresolved placeholders as verified content.

## Shared status values
- `verified`
- `needs_scholar_review`
- `todo_verify_license`
- `placeholder`
- `sample_needs_review`

## Qaida lesson
```json
{
  "id": "qaida-001",
  "titleBn": "Lesson title",
  "order": 1,
  "lessonType": "letters|harakat|tanween|sukoon|madd|practice",
  "items": [
    {
      "id": "item-001",
      "arabic": "ا",
      "nameBn": "Bangla label",
      "pronunciationBn": "reviewed pronunciation guide",
      "audio": "assets/audio/qaida/item-001.mp3",
      "source": "In-house content; qari reviewer and recording metadata",
      "status": "needs_scholar_review"
    }
  ],
  "quizIds": ["qaida-q001"],
  "source": "In-house curriculum reference",
  "status": "needs_scholar_review"
}
```

## Namaz / wudu step
```json
{
  "id": "wudu-001",
  "titleBn": "Step title",
  "order": 1,
  "category": "wudu|salah",
  "image": "assets/images/namaz/wudu-001.webp",
  "imageCredit": {"author": "Author", "license": "CC-BY-4.0", "attribution": "Required credit"},
  "instructionBn": "Reviewed Bangla instruction",
  "arabic": null,
  "pronunciationBn": null,
  "meaningBn": null,
  "audio": null,
  "source": "Book/edition/page or verified source",
  "status": "needs_scholar_review"
}
```

## Dua / zikr
```json
{
  "id": "dua-001",
  "category": "morning|evening|food|travel|sleep|other",
  "titleBn": "Title",
  "arabic": "Verified Arabic text",
  "pronunciationBn": "Reviewed Bangla transliteration",
  "meaningBn": "Reviewed meaning",
  "reference": "Hadith collection and number / edition details",
  "audio": "assets/audio/duas/dua-001.mp3",
  "source": "Exact edition, publisher, page and reuse permission",
  "status": "needs_scholar_review"
}
```

## Surah
```json
{
  "id": "surah-112",
  "surahNumber": 112,
  "nameBn": "Surah name",
  "arabicAyahs": [{"ayahNumber": 1, "text": "verbatim Tanzil text"}],
  "translationBnAyahs": [{"ayahNumber": 1, "text": "licensed Bangla translation"}],
  "audio": "assets/audio/surahs/112.mp3",
  "reciter": {"name": "Reciter", "recordingSource": "Source", "license": "Permission evidence"},
  "source": "Tanzil attribution + translation source + audio rights",
  "status": "needs_scholar_review"
}
```

## Quiz
```json
{
  "id": "quiz-001",
  "level": "beginner|intermediate|advanced",
  "questionBn": "Question",
  "options": ["A", "B", "C", "D"],
  "correctOptionIndex": 0,
  "explanationBn": "Reviewed explanation",
  "source": "Content item ID plus authoritative source",
  "status": "needs_scholar_review"
}
```

## District
```json
{
  "id": "chattogram",
  "nameBn": "চট্টগ্রাম",
  "latitude": 22.3569,
  "longitude": 91.7832,
  "source": "Coordinate dataset and version"
}
```
