import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var suggestions: [String] = []
    @Published var showWordDetail: Bool = false
    @Published var selectedTab: DictionaryTab = .synonym
    @Published var synonymHTML: String?

    private let dictionaryService = DictionaryService.shared
    private let synonymService = SynonymDictionaryService.shared
    private var cancellables = Set<AnyCancellable>()
    private var suppressSuggestions = false
    let navigationManager = NavigationManager()

    // Compute which tabs have content for the current word
    var availableTabs: [DictionaryTab] {
        var tabs: [DictionaryTab] = []
        if synonymHTML != nil {
            tabs.append(.synonym)
        }
        return tabs
    }
    
    init() {
        // Set up search text monitoring with debounce
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.updateSuggestions(for: text)
            }
            .store(in: &cancellables)
    }
    
    private func updateSuggestions(for text: String) {
        if suppressSuggestions {
            suppressSuggestions = false
            return
        }
        if text.isEmpty {
            suggestions = []
        } else {
            suggestions = dictionaryService.getSuggestions(for: text, limit: 10)
        }
    }
    
    func selectWord(_ word: String) {
        if let foundSynonym = synonymService.searchWord(word) {
            synonymHTML = foundSynonym
        } else if let wordData = dictionaryService.searchWord(word) {
            synonymHTML = Self.generateHTML(from: wordData)
        } else {
            return
        }

        showWordDetail = true
        navigationManager.addToHistory(word)
        suppressSuggestions = true
        searchText = word
        suggestions = []
        selectedTab = .synonym
    }
    
    func searchCurrentText() {
        guard !searchText.isEmpty else { return }

        let hasSynonym = synonymService.searchWord(searchText) != nil
        let hasRichWord = dictionaryService.searchWord(searchText) != nil

        if hasSynonym || hasRichWord {
            selectWord(searchText)
        } else if let firstSuggestion = suggestions.first {
            selectWord(firstSuggestion)
        }
    }
    
    func goBack() {
        navigationManager.goBack()
        if let word = navigationManager.currentWord {
            loadWord(word, addToHistory: false)
        }
    }
    
    func goForward() {
        navigationManager.goForward()
        if let word = navigationManager.currentWord {
            loadWord(word, addToHistory: false)
        }
    }
    
    private func loadWord(_ word: String, addToHistory: Bool = true) {
        if let foundSynonym = synonymService.searchWord(word) {
            synonymHTML = foundSynonym
        } else if let wordData = dictionaryService.searchWord(word) {
            synonymHTML = Self.generateHTML(from: wordData)
        } else {
            return
        }

        showWordDetail = true
        suppressSuggestions = true
        searchText = word
        suggestions = []
        if addToHistory {
            navigationManager.addToHistory(word)
        }
        selectedTab = .synonym
    }
    
    func lookupWordFromText(_ word: String) {
        selectWord(word)
    }

    private static func generateHTML(from word: Word) -> String {
        var html = "<h2>\(word.word.capitalized) <span style=\"font-weight: normal; font-size: 0.7em; color: #666;\">\(word.posDescription)</span></h2>"

        for (index, definition) in word.definitions.enumerated() {
            html += "<h4>Definition \(index + 1)</h4>"
            html += "<p>\(definition.meaning)</p>"

            if !definition.examples.isEmpty {
                html += "<p><strong>Examples:</strong></p>"
                for example in definition.examples {
                    html += "<p style=\"padding-left: 10px;\">\u{2022} \(example.sentence)</p>"
                }
            }
        }

        return html
    }
}
