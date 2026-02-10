import Foundation

class NavigationManager: ObservableObject {
    @Published var history: [String] = []
    @Published var currentIndex: Int = -1
    
    var canGoBack: Bool {
        return currentIndex > 0
    }
    
    var canGoForward: Bool {
        return currentIndex < history.count - 1
    }
    
    func addToHistory(_ word: String) {
        // If we're not at the end of history, remove forward history
        if currentIndex < history.count - 1 {
            history.removeSubrange((currentIndex + 1)...)
        }
        
        // Don't add duplicate if it's the same as current
        if let current = currentWord, current == word {
            return
        }
        
        history.append(word)
        currentIndex = history.count - 1
    }
    
    func goBack() {
        guard canGoBack else { return }
        currentIndex -= 1
    }
    
    func goForward() {
        guard canGoForward else { return }
        currentIndex += 1
    }
    
    var currentWord: String? {
        guard currentIndex >= 0 && currentIndex < history.count else {
            return nil
        }
        return history[currentIndex]
    }
}
