import Foundation

// Enum representing available dictionary tabs
enum DictionaryTab: String, CaseIterable, Identifiable {
    case collins = "Collins"
    case synonym = "Synonym"

    var id: String { rawValue }
}

// Protocol for extensible dictionary architecture
protocol DictionaryProvider {
    func searchWord(_ word: String) -> Word?
    func getSuggestions(for input: String, limit: Int) -> [String]
    func getAllWords() -> [String]
}

// Part of speech enumeration
enum PartOfSpeech: String, Codable {
    case noun = "noun"
    case verb = "verb"
    case adjective = "adjective"
    case adverb = "adverb"
    case pronoun = "pronoun"
    case preposition = "preposition"
    case conjunction = "conjunction"
    case interjection = "interjection"
}

// Noun type
enum NounType: String, Codable {
    case countable = "countable"
    case uncountable = "uncountable"
    case both = "both"
}

// Verb type
enum VerbType: String, Codable {
    case transitive = "transitive"
    case intransitive = "intransitive"
    case both = "both"
}

// Example sentence with difficulty level
struct Example: Codable, Identifiable {
    let id: UUID
    let sentence: String
    let difficulty: Int // 1 = easy, 2 = medium, 3 = hard
    
    init(sentence: String, difficulty: Int) {
        self.id = UUID()
        self.sentence = sentence
        self.difficulty = difficulty
    }
    
    enum CodingKeys: String, CodingKey {
        case sentence, difficulty
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.sentence = try container.decode(String.self, forKey: .sentence)
        self.difficulty = try container.decode(Int.self, forKey: .difficulty)
    }
}

// Definition with examples
struct Definition: Codable, Identifiable {
    let id: UUID
    let meaning: String
    let examples: [Example]
    
    init(meaning: String, examples: [Example]) {
        self.id = UUID()
        self.meaning = meaning
        self.examples = examples
    }
    
    enum CodingKeys: String, CodingKey {
        case meaning, examples
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.meaning = try container.decode(String.self, forKey: .meaning)
        self.examples = try container.decode([Example].self, forKey: .examples)
    }
}

// Word model
struct Word: Codable, Identifiable {
    let id: UUID
    let word: String
    let partOfSpeech: PartOfSpeech
    let nounType: NounType?
    let verbType: VerbType?
    let definitions: [Definition]
    
    init(word: String, partOfSpeech: PartOfSpeech, nounType: NounType? = nil, verbType: VerbType? = nil, definitions: [Definition]) {
        self.id = UUID()
        self.word = word
        self.partOfSpeech = partOfSpeech
        self.nounType = nounType
        self.verbType = verbType
        self.definitions = definitions
    }
    
    enum CodingKeys: String, CodingKey {
        case word, partOfSpeech, nounType, verbType, definitions
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.word = try container.decode(String.self, forKey: .word)
        self.partOfSpeech = try container.decode(PartOfSpeech.self, forKey: .partOfSpeech)
        self.nounType = try container.decodeIfPresent(NounType.self, forKey: .nounType)
        self.verbType = try container.decodeIfPresent(VerbType.self, forKey: .verbType)
        self.definitions = try container.decode([Definition].self, forKey: .definitions)
    }
    
    var posDescription: String {
        var desc = partOfSpeech.rawValue
        if let nounType = nounType {
            desc += " (\(nounType.rawValue))"
        }
        if let verbType = verbType {
            desc += " (\(verbType.rawValue))"
        }
        return desc
    }
}
