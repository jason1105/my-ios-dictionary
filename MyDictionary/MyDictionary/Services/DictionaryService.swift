import Foundation

class DictionaryService: DictionaryProvider {
    static let shared = DictionaryService()
    
    private var words: [String: Word] = [:]
    private var wordList: [String] = []
    
    private init() {
        loadDictionary()
    }
    
    private func loadDictionary() {
        guard let url = Bundle.main.url(forResource: "dictionary_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let wordArray = try? JSONDecoder().decode([Word].self, from: data) else {
            // If no dictionary file, create sample data
            createSampleDictionary()
            return
        }
        
        for word in wordArray {
            words[word.word.lowercased()] = word
            wordList.append(word.word.lowercased())
        }
        wordList.sort()
    }
    
    private func createSampleDictionary() {
        let sampleWords: [Word] = [
            Word(word: "book", partOfSpeech: .noun, nounType: .countable, definitions: [
                Definition(meaning: "A written or printed work consisting of pages glued or sewn together along one side and bound in covers", examples: [
                    Example(sentence: "I read a book.", difficulty: 1),
                    Example(sentence: "She borrowed a book from the library.", difficulty: 2),
                    Example(sentence: "The comprehensive book provided detailed insights into quantum mechanics.", difficulty: 3)
                ])
            ]),
            Word(word: "gravity", partOfSpeech: .noun, nounType: .uncountable, definitions: [
                Definition(meaning: "The force that attracts a body toward the center of the earth, or toward any other physical body having mass", examples: [
                    Example(sentence: "Gravity pulls things down.", difficulty: 1),
                    Example(sentence: "The apple fell because of gravity.", difficulty: 2),
                    Example(sentence: "Einstein's theory of general relativity revolutionized our understanding of gravity.", difficulty: 3)
                ])
            ]),
            Word(word: "antigravity", partOfSpeech: .noun, nounType: .uncountable, definitions: [
                Definition(meaning: "A hypothetical force opposing gravity", examples: [
                    Example(sentence: "Antigravity is not real yet.", difficulty: 1),
                    Example(sentence: "Scientists explore the concept of antigravity.", difficulty: 2),
                    Example(sentence: "The theoretical framework for antigravity propulsion systems remains speculative.", difficulty: 3)
                ])
            ]),
            Word(word: "run", partOfSpeech: .verb, verbType: .intransitive, definitions: [
                Definition(meaning: "To move at a speed faster than a walk, never having both or all the feet on the ground at the same time", examples: [
                    Example(sentence: "I run every day.", difficulty: 1),
                    Example(sentence: "She runs five miles every morning.", difficulty: 2),
                    Example(sentence: "The athlete runs with remarkable endurance and determination.", difficulty: 3)
                ])
            ]),
            Word(word: "read", partOfSpeech: .verb, verbType: .transitive, definitions: [
                Definition(meaning: "To look at and comprehend the meaning of written or printed matter by mentally interpreting the characters or symbols", examples: [
                    Example(sentence: "I read books.", difficulty: 1),
                    Example(sentence: "He reads the newspaper every morning.", difficulty: 2),
                    Example(sentence: "She meticulously reads scientific journals to stay current with research.", difficulty: 3)
                ])
            ]),
            Word(word: "happy", partOfSpeech: .adjective, definitions: [
                Definition(meaning: "Feeling or showing pleasure or contentment", examples: [
                    Example(sentence: "I am happy.", difficulty: 1),
                    Example(sentence: "She felt happy about her achievement.", difficulty: 2),
                    Example(sentence: "The overwhelmingly positive results made everyone exceptionally happy.", difficulty: 3)
                ])
            ]),
            Word(word: "quickly", partOfSpeech: .adverb, definitions: [
                Definition(meaning: "At a fast speed; rapidly", examples: [
                    Example(sentence: "Run quickly!", difficulty: 1),
                    Example(sentence: "She finished her homework quickly.", difficulty: 2),
                    Example(sentence: "The emergency response team arrived quickly to assess the situation.", difficulty: 3)
                ])
            ]),
            Word(word: "understand", partOfSpeech: .verb, verbType: .transitive, definitions: [
                Definition(meaning: "To perceive the intended meaning of words, a language, or a speaker", examples: [
                    Example(sentence: "I understand you.", difficulty: 1),
                    Example(sentence: "She understands the concept clearly.", difficulty: 2),
                    Example(sentence: "To fully understand quantum mechanics requires extensive study and contemplation.", difficulty: 3)
                ])
            ]),
            Word(word: "beautiful", partOfSpeech: .adjective, definitions: [
                Definition(meaning: "Pleasing the senses or mind aesthetically", examples: [
                    Example(sentence: "The sunset is beautiful.", difficulty: 1),
                    Example(sentence: "She wore a beautiful dress to the party.", difficulty: 2),
                    Example(sentence: "The breathtakingly beautiful landscape captivated all who beheld it.", difficulty: 3)
                ])
            ]),
            Word(word: "think", partOfSpeech: .verb, verbType: .both, definitions: [
                Definition(meaning: "To have a particular opinion, belief, or idea about someone or something", examples: [
                    Example(sentence: "I think it's good.", difficulty: 1),
                    Example(sentence: "She thinks the movie was excellent.", difficulty: 2),
                    Example(sentence: "Philosophers think deeply about the nature of existence and consciousness.", difficulty: 3)
                ])
            ])
        ]
        
        for word in sampleWords {
            words[word.word.lowercased()] = word
            wordList.append(word.word.lowercased())
        }
        wordList.sort()
    }
    
    func searchWord(_ word: String) -> Word? {
        return words[word.lowercased()]
    }
    
    func getSuggestions(for input: String, limit: Int = 10) -> [String] {
        guard !input.isEmpty else { return [] }
        
        let lowercasedInput = input.lowercased()
        var suggestions: [(word: String, score: Int)] = []
        
        for word in wordList {
            // Exact prefix match (highest priority)
            if word.hasPrefix(lowercasedInput) {
                suggestions.append((word, 100))
                continue
            }
            
            // Fuzzy match with Levenshtein distance
            let distance = levenshteinDistance(lowercasedInput, word)
            if distance <= 2 {
                let score = 50 - distance * 10
                suggestions.append((word, score))
            }
        }
        
        // Sort by score (descending) and then alphabetically
        suggestions.sort { first, second in
            if first.score != second.score {
                return first.score > second.score
            }
            return first.word < second.word
        }
        
        return Array(suggestions.prefix(limit).map { $0.word })
    }
    
    func getAllWords() -> [String] {
        return wordList
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
