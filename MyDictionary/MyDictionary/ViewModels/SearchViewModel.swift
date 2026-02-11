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
        let foundSynonym = synonymService.searchWord(word)

        if foundSynonym != nil {
            synonymHTML = foundSynonym
            showWordDetail = true
            navigationManager.addToHistory(word)
            suppressSuggestions = true
            searchText = word
            suggestions = []
            selectedTab = .synonym
        }
    }
    
    func searchCurrentText() {
        guard !searchText.isEmpty else { return }

        let synonym = synonymService.searchWord(searchText)

        if synonym != nil {
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
        let foundSynonym = synonymService.searchWord(word)

        if foundSynonym != nil {
            synonymHTML = foundSynonym
            showWordDetail = true
            suppressSuggestions = true
            searchText = word
            suggestions = []
            if addToHistory {
                navigationManager.addToHistory(word)
            }
            selectedTab = .synonym
        }
    }
    
    func lookupWordFromText(_ word: String) {
        selectWord(word)
    }
}
