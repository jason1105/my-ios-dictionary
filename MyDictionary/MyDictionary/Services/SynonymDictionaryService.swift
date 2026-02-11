import Foundation

class SynonymDictionaryService {
    static let shared = SynonymDictionaryService()
    
    private var synonymEntries: [String: String] = [:]
    
    private init() {
        loadSynonymDictionary()
    }
    
    private func loadSynonymDictionary() {
        guard let url = Bundle.main.url(forResource: "easier_synonym_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let entries = try? JSONDecoder().decode([String: String].self, from: data) else {
            return
        }
        synonymEntries = entries
    }
    
    func searchWord(_ word: String) -> String? {
        let key = word.lowercased()
        return synonymEntries[key]
    }
    
    func getAllWords() -> [String] {
        return Array(synonymEntries.keys).sorted()
    }
    
    func hasWord(_ word: String) -> Bool {
        return synonymEntries[word.lowercased()] != nil
    }
}
