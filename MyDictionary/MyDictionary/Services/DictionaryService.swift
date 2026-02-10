import Foundation

class DictionaryService: DictionaryProvider {
    static let shared = DictionaryService()
    
    // Rich dictionary with full definitions (from dictionary_data.json)
    private var richWords: [String: Word] = [:]
    // Comprehensive sorted word list (from words_alpha.txt)
    private var wordList: [String] = []
    // Set for O(1) word existence checks
    private var wordSet: Set<String> = []
    
    private init() {
        loadWordList()
        loadRichDictionary()
    }
    
    // Load the comprehensive word list from words_alpha.txt
    private func loadWordList() {
        guard let url = Bundle.main.url(forResource: "words_alpha", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return
        }
        
        let words = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
            .filter { !$0.isEmpty }
        
        wordSet = Set(words)
        wordList = words.sorted()
    }
    
    // Load the rich dictionary with definitions from dictionary_data.json
    private func loadRichDictionary() {
        guard let url = Bundle.main.url(forResource: "dictionary_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let wordArray = try? JSONDecoder().decode([Word].self, from: data) else {
            return
        }
        
        for word in wordArray {
            let key = word.word.lowercased()
            richWords[key] = word
            // Ensure rich dictionary words are also in the word list
            if !wordSet.contains(key) {
                wordSet.insert(key)
                // Insert into sorted position
                let insertIndex = wordList.firstIndex(where: { $0 > key }) ?? wordList.endIndex
                wordList.insert(key, at: insertIndex)
            }
        }
    }
    
    func searchWord(_ word: String) -> Word? {
        let key = word.lowercased()
        // Return rich definition if available
        if let richWord = richWords[key] {
            return richWord
        }
        // If word exists in word list but has no rich definition, return a basic entry
        if wordSet.contains(key) {
            return Word(
                word: key,
                partOfSpeech: .noun,
                definitions: [
                    Definition(meaning: "Word found in dictionary. Detailed definition not yet available.", examples: [])
                ]
            )
        }
        return nil
    }
    
    func getSuggestions(for input: String, limit: Int = 10) -> [String] {
        guard !input.isEmpty else { return [] }
        
        let lowercasedInput = input.lowercased()
        
        // Use binary search for efficient prefix matching on the sorted word list
        let prefixMatches = findPrefixMatches(for: lowercasedInput, limit: limit)
        
        if prefixMatches.count >= limit {
            return Array(prefixMatches.prefix(limit))
        }
        
        // If not enough prefix matches, add fuzzy matches from nearby words
        var results = prefixMatches
        let resultSet = Set(prefixMatches)
        
        // Only apply Levenshtein on a bounded subset of words near the input alphabetically
        let startIdx = lowerBound(for: String(lowercasedInput.prefix(1)))
        let endPrefix = String(lowercasedInput.prefix(1)).nextAlphaPrefix()
        let endIdx = endPrefix != nil ? min(lowerBound(for: endPrefix!), wordList.count) : wordList.count
        
        let candidateRange = startIdx..<min(endIdx, wordList.count)
        var fuzzyMatches: [(word: String, distance: Int)] = []
        
        for i in candidateRange {
            let word = wordList[i]
            if resultSet.contains(word) { continue }
            // Only consider words with similar length to avoid unnecessary computation
            if abs(word.count - lowercasedInput.count) > 2 { continue }
            let distance = levenshteinDistance(lowercasedInput, word)
            if distance <= 2 {
                fuzzyMatches.append((word, distance))
            }
        }
        
        fuzzyMatches.sort { $0.distance < $1.distance || ($0.distance == $1.distance && $0.word < $1.word) }
        
        for match in fuzzyMatches {
            if results.count >= limit { break }
            results.append(match.word)
        }
        
        return results
    }
    
    func getAllWords() -> [String] {
        return wordList
    }
    
    // MARK: - Binary search helpers for efficient prefix matching
    
    /// Find the lower bound index where prefix would be inserted in sorted wordList
    private func lowerBound(for prefix: String) -> Int {
        var lo = 0
        var hi = wordList.count
        while lo < hi {
            let mid = lo + (hi - lo) / 2
            if wordList[mid] < prefix {
                lo = mid + 1
            } else {
                hi = mid
            }
        }
        return lo
    }
    
    /// Find all words with the given prefix using binary search, up to limit
    private func findPrefixMatches(for prefix: String, limit: Int) -> [String] {
        let startIdx = lowerBound(for: prefix)
        var results: [String] = []
        
        var i = startIdx
        while i < wordList.count && results.count < limit {
            if wordList[i].hasPrefix(prefix) {
                results.append(wordList[i])
            } else {
                break
            }
            i += 1
        }
        
        return results
    }
    
    // Levenshtein distance algorithm for fuzzy matching
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let s1 = Array(s1)
        let s2 = Array(s2)
        var distance = Array(repeating: Array(repeating: 0, count: s2.count + 1), count: s1.count + 1)
        
        for i in 0...s1.count {
            distance[i][0] = i
        }
        
        for j in 0...s2.count {
            distance[0][j] = j
        }
        
        for i in 1...s1.count {
            for j in 1...s2.count {
                if s1[i-1] == s2[j-1] {
                    distance[i][j] = distance[i-1][j-1]
                } else {
                    distance[i][j] = min(
                        distance[i-1][j] + 1,      // deletion
                        distance[i][j-1] + 1,      // insertion
                        distance[i-1][j-1] + 1     // substitution
                    )
                }
            }
        }
        
        return distance[s1.count][s2.count]
    }
}

// Helper to compute the next alphabetical prefix for range bounds
private extension String {
    func nextAlphaPrefix() -> String? {
        guard let lastChar = self.last,
              let scalar = lastChar.unicodeScalars.first,
              let nextScalar = Unicode.Scalar(scalar.value + 1) else {
            return nil
        }
        return String(self.dropLast()) + String(nextScalar)
    }
}
