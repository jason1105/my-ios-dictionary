import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var suggestions: [String] = []
    @Published var selectedWord: Word?
    @Published var showWordDetail: Bool = false
    
    private let dictionaryService = DictionaryService.shared
    private var cancellables = Set<AnyCancellable>()
    private var suppressSuggestions = false
    let navigationManager = NavigationManager()
    
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
        if let foundWord = dictionaryService.searchWord(word) {
            selectedWord = foundWord
            showWordDetail = true
            navigationManager.addToHistory(word)
            suppressSuggestions = true
            searchText = word
            suggestions = []
        }
    }
    
    func searchCurrentText() {
        guard !searchText.isEmpty else { return }
        
        if let word = dictionaryService.searchWord(searchText) {
            selectWord(word.word)
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
        if let foundWord = dictionaryService.searchWord(word) {
            selectedWord = foundWord
            showWordDetail = true
            suppressSuggestions = true
            searchText = word
            suggestions = []
            if addToHistory {
                navigationManager.addToHistory(word)
            }
        }
    }
    
    func lookupWordFromText(_ word: String) {
        selectWord(word)
    }
}
