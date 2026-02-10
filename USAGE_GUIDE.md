# iOS Dictionary - Usage Guide

## Overview
This SwiftUI-based iOS dictionary application provides comprehensive English word definitions with smart features for language learners.

## Main Features Walkthrough

### 1. Launch Screen & Auto-Focus
When you launch the app:
- The search field automatically receives focus
- Keyboard appears immediately
- Empty state shows instructions: "Start typing to search"
- Forward/back buttons are visible but disabled (grayed out)

### 2. Search with Autocomplete
As you type:
- Suggestions appear in real-time below the search bar
- Fuzzy matching provides spell correction
- Each suggestion is a tappable button
- Clear button (X) appears to reset search

Example searches:
```
Type: "bok"
Suggestions: bok, book

Type: "angravity"
Suggestions: agravity, antigravity, gravity

Type: "run"
Suggestions: run

Type: "boo"
Suggestions: book
```

### 3. Word Detail View
After selecting a word, you see:

**Header Section:**
- Word in large, bold text (e.g., "Book")
- Part of speech with details (e.g., "noun (countable)")

**Definition Sections:**
Each definition includes:
- "Definition 1", "Definition 2", etc.
- The meaning in plain English
- "Examples:" label
- Three example sentences with difficulty stars:
  - ⭐ (1 star) = Easy
  - ⭐⭐ (2 stars) = Medium
  - ⭐⭐⭐ (3 stars) = Hard

**Example for "Book":**
```
Book
noun (countable)

Definition 1
A written or printed work consisting of pages glued or sewn together...

Examples:
⭐ "I read a book."
⭐⭐ "She borrowed a book from the library."
⭐⭐⭐ "The comprehensive book provided detailed insights into quantum mechanics."
```

### 4. Clickable Words Feature
All words in definitions and examples are interactive:
- Words that exist in dictionary are blue and underlined
- Tap any blue word to see a popup
- Popup shows:
  - Word title
  - Part of speech
  - First 2 definitions (brief)
  - "Details" button (blue, full-width)

**Popup Example:**
```
┌─────────────────────────┐
│ Read                    │
│ verb (transitive)       │
│ ─────────────────────── │
│ • To look at and        │
│   comprehend the        │
│   meaning of written... │
│                         │
│ ┌─────────────────────┐ │
│ │   Details     →     │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

Tapping "Details" navigates to the full definition view for that word.

### 5. Navigation History
The top bar includes:
- **Back button** (◀): Returns to previous word
- **Forward button** (▶): Goes to next word (if available)
- **Search field**: Shows current word, can type new search

Navigation behavior:
- Searching a word adds it to history
- Clicking back moves backward in history
- Forward is available after going back
- New searches clear forward history

**Example navigation flow:**
```
Search "book" → Search "read" → Search "happy"
History: [book, read, happy]
Current: happy

Click back → Current: read (forward enabled)
Click back → Current: book (forward enabled)
Click forward → Current: read
```

### 6. Part of Speech Display

The app shows detailed grammatical information:

**For Nouns:**
- "noun (countable)" - can be counted (book, books)
- "noun (uncountable)" - cannot be counted (water, gravity)
- "noun (both)" - can be used both ways

**For Verbs:**
- "verb (transitive)" - takes an object (read a book)
- "verb (intransitive)" - no object needed (run fast)
- "verb (both)" - can be used both ways (think)

**For Adjectives/Adverbs:**
- "adjective" (beautiful, happy)
- "adverb" (quickly, slowly)

### 7. Search Behavior

**Autocomplete Priority:**
1. Exact prefix matches (highest priority)
   - "boo" → "book" appears first
2. Fuzzy matches within 2 edits
   - "bok" → "book" (1 character difference)
   - "angravity" → "antigravity" (2 character difference)

**Submit Search:**
- Press Enter/Return on keyboard
- Tap a suggestion
- If no exact match, first suggestion is used

### 8. Empty States & Error Handling

**No Search:**
- Shows book icon and instructions
- "Start typing to search"
- "Search for English words to see definitions and examples"

**Word Not Found:**
- If a clicked word doesn't exist in dictionary
- Popup shows: "Word not found"

**No Suggestions:**
- When input doesn't match any words
- Suggestion list remains empty
- Can still press Enter to search

## Keyboard Shortcuts & Gestures

- **Tap search field**: Edit search query
- **Tap X button**: Clear search
- **Press Enter**: Submit search
- **Tap suggestion**: Select that word
- **Tap blue word**: Show quick popup
- **Tap Details button**: Show full definition
- **Tap back/forward buttons**: Navigate history
- **Scroll**: View long definitions

## Example User Journeys

### Journey 1: Looking Up a Word
1. Launch app (search field auto-focused)
2. Type "grav"
3. See suggestion "gravity"
4. Tap "gravity"
5. Read definition with 3 examples
6. See "force" is blue and clickable
7. Tap "force" to learn more

### Journey 2: Correcting Spelling
1. Type "bok" (misspelling)
2. See suggestions: "bok", "book"
3. Tap "book" (the intended word)
4. View correct definition
5. Search history shows "book"

### Journey 3: Exploring Related Words
1. Search "run"
2. Read definition
3. Click "walk" in example (blue)
4. Popup appears
5. Click "Details" for full info
6. Use back button to return to "run"
7. Forward button now available

### Journey 4: Learning Progressively
1. Search "beautiful"
2. View Definition 1
3. Read example 1 (⭐): "The sunset is beautiful."
4. Read example 2 (⭐⭐): "She wore a beautiful dress..."
5. Read example 3 (⭐⭐⭐): "The breathtakingly beautiful landscape..."
6. See vocabulary progression from simple to complex

## Tips for Best Experience

1. **Use autocomplete**: Let suggestions guide your spelling
2. **Explore related words**: Click blue words to learn connections
3. **Use navigation**: Back/forward buttons help review multiple words
4. **Check examples**: Three difficulty levels help progressive learning
5. **Note grammar**: Part of speech info helps understand word usage

## Technical Notes

- Requires iOS 17.0 or later
- Runs on iPhone and iPad
- Supports portrait and landscape
- All content works offline
- Search is case-insensitive
- Real-time suggestions with 300ms debounce
- History unlimited size (memory permitting)

## Vocabulary Coverage

Current database includes:
- Common nouns: book, friend, school, water
- Common verbs: run, read, write, learn, think
- Adjectives: happy, beautiful
- Adverbs: quickly
- Academic words: science, mathematics, gravity
- Advanced words: antigravity, understand

Dictionary is extensible - more words can be added to the JSON file.
