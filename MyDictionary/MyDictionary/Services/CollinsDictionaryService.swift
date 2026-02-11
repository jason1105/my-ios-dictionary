import Foundation

class CollinsDictionaryService {
    static let shared = CollinsDictionaryService()
    
    private var collinsEntries: [String: String] = [:]
    private var sortedWords: [String] = []
    
    private init() {
        loadCollinsDictionary()
    }
    
    private func loadCollinsDictionary() {
        guard let url = Bundle.main.url(forResource: "collins_dictionary_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([String: String].self, from: data) else {
            return
        }
        collinsEntries = entries
        sortedWords = entries.keys.sorted()
    }
    
    func searchWord(_ word: String) -> String? {
        let key = word.lowercased()
        return collinsEntries[key]
    }
    
    func getAllWords() -> [String] {
        return sortedWords
    }
    
    func hasWord(_ word: String) -> Bool {
        return collinsEntries[word.lowercased()] != nil
    }
}
