# My iOS Dictionary

A comprehensive SwiftUI-based iOS dictionary application with advanced features for English language learners.

## Features

### 1. Auto-Focus Search
- Search field automatically receives focus when the app launches
- Immediate access to word lookup functionality

### 2. Smart Autocomplete and Spell Correction
- Real-time word suggestions as you type
- Fuzzy matching algorithm for spelling corrections
- Examples:
  - Typing "bok" suggests "bok" and "book"
  - Typing "angravity" suggests "agravity" and "antigravity"

### 3. English-Only Interface
- All UI text is in English
- Clean, professional interface
- Non-English text only appears in definitions when citing sources

### 4. Extensible Dictionary Architecture
- Protocol-based design (`DictionaryProvider`)
- Easy to add new dictionary sources
- Modular and maintainable codebase

### 5. Comprehensive Word Information
- Part of speech identification
- Noun types: countable/uncountable
- Verb types: transitive/intransitive
- Multiple definitions per word

### 6. Difficulty-Graded Examples
- Three example sentences per definition
- Graded from simple to complex (1-3 stars)
- Progressive learning support

### 7. Interactive Clickable Words
- All words in definitions and examples are clickable
- Quick popup with brief definition
- "Details" button for full word information
- Seamless word-to-word navigation

### 8. Navigation History
- Forward and back buttons
- Browse through search history
- Easy navigation between previously searched words

### 9. K-12 Vocabulary Coverage
- Dictionary includes words from elementary through high school levels
- Open-source word database
- Comprehensive educational vocabulary

## Project Structure

```
MyDictionary/
├── MyDictionary/
│   ├── Models/
│   │   └── WordModel.swift          # Data models for words, definitions, examples
│   ├── Services/
│   │   ├── DictionaryService.swift  # Dictionary lookup and suggestions
│   │   └── NavigationManager.swift  # History navigation management
│   ├── ViewModels/
│   │   └── SearchViewModel.swift    # Search logic and state management
│   ├── Views/
│   │   ├── ContentView.swift        # Main search interface
│   │   ├── WordDetailView.swift     # Detailed word view with examples
│   │   ├── WordPopoverView.swift    # Quick word popup
│   │   └── ClickableText.swift      # Interactive text component
│   ├── Resources/
│   │   └── dictionary_data.json     # Word database
│   └── Assets.xcassets/             # App assets
└── MyDictionary.xcodeproj/          # Xcode project file
```

## Technical Details

### Architecture
- **MVVM Pattern**: Separation of concerns between UI and business logic
- **Protocol-Oriented**: Extensible dictionary provider system
- **Reactive**: Combine framework for reactive data flow
- **SwiftUI**: Modern declarative UI framework

### Key Technologies
- SwiftUI for UI
- Combine for reactive programming
- JSON for data storage
- Levenshtein distance for fuzzy matching

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## How to Build

1. Open `MyDictionary.xcodeproj` in Xcode
2. Select a simulator or connected iOS device
3. Press ⌘R to build and run

## Usage

1. **Search for Words**: Start typing in the search bar - suggestions appear automatically
2. **View Definitions**: Tap a suggestion or press Enter to see full word details
3. **Explore Related Words**: Click any word in definitions or examples to look it up
4. **Navigate History**: Use back/forward buttons to browse search history
5. **Quick Definitions**: Click words to see quick popup definitions

## Extending the Dictionary

To add a new dictionary source:

1. Implement the `DictionaryProvider` protocol
2. Add your implementation to the `DictionaryService`
3. Update the initialization logic to include your source

Example:
```swift
class MyCustomDictionary: DictionaryProvider {
    func searchWord(_ word: String) -> Word? {
        // Your implementation
    }
    
    func getSuggestions(for input: String, limit: Int) -> [String] {
        // Your implementation
    }
    
    func getAllWords() -> [String] {
        // Your implementation
    }
}
```

## License

MIT License - feel free to use and modify as needed.