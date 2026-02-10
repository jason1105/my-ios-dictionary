import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var suggestions: [String] = []
    @Published var selectedWord: Word?
    @Published var showWordDetail: Bool = false
    @Published var selectedTab: DictionaryTab = .dictionary
    @Published var synonymHTML: String?
    
    private let dictionaryService = DictionaryService.shared
    private let synonymService = SynonymDictionaryService.shared
    private var cancellables = Set<AnyCancellable>()
    private var suppressSuggestions = false
    let navigationManager = NavigationManager()
    
    // Compute which tabs have content for the current word
    var availableTabs: [DictionaryTab] {
        var tabs: [DictionaryTab] = []
        if selectedWord != nil {
            tabs.append(.dictionary)
        }
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
        let foundWord = dictionaryService.searchWord(word)
        let foundSynonym = synonymService.searchWord(word)
        
        if foundWord != nil || foundSynonym != nil {
            selectedWord = foundWord
            synonymHTML = foundSynonym
            showWordDetail = true
            navigationManager.addToHistory(word)
            suppressSuggestions = true
            searchText = word
            suggestions = []
            
            // Auto-select the first available tab
            if foundWord != nil {
                selectedTab = .dictionary
            } else if foundSynonym != nil {
                selectedTab = .synonym
            }
        }
    }
    
    func searchCurrentText() {
        guard !searchText.isEmpty else { return }
        
        let word = dictionaryService.searchWord(searchText)
        let synonym = synonymService.searchWord(searchText)
        
        if word != nil || synonym != nil {
            selectWord(word?.word ?? searchText)
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
        let foundWord = dictionaryService.searchWord(word)
        let foundSynonym = synonymService.searchWord(word)
        
        if foundWord != nil || foundSynonym != nil {
            selectedWord = foundWord
            synonymHTML = foundSynonym
            showWordDetail = true
            suppressSuggestions = true
            searchText = word
            suggestions = []
            if addToHistory {
                navigationManager.addToHistory(word)
            }
            
            // Auto-select the first available tab
            if foundWord != nil {
                selectedTab = .dictionary
            } else if foundSynonym != nil {
                selectedTab = .synonym
            }
        }
    }
    
    func lookupWordFromText(_ word: String) {
        selectWord(word)
    }
}
