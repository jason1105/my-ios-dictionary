import SwiftUI

struct WordDetailView: View {
    let word: Word
    let onWordTap: (String) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Word header
                VStack(alignment: .leading, spacing: 8) {
                    Text(word.word.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(word.posDescription)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .padding(.bottom, 10)
                
                Divider()
                
                // Definitions
                ForEach(Array(word.definitions.enumerated()), id: \.element.id) { index, definition in
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Definition \(index + 1)")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ClickableText(text: definition.meaning, onWordTap: onWordTap)
                            .font(.body)
                            .padding(.leading, 10)
                        
                        if !definition.examples.isEmpty {
                            Text("Examples:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.top, 8)
                            
                            ForEach(definition.examples.sorted(by: { $0.difficulty < $1.difficulty })) { example in
                                HStack(alignment: .top, spacing: 10) {
                                    difficultyIcon(for: example.difficulty)
                                    
                                    ClickableText(text: example.sentence, onWordTap: onWordTap)
                                        .font(.body)
                                }
                                .padding(.leading, 10)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    
                    if index < word.definitions.count - 1 {
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
    
    private func difficultyIcon(for level: Int) -> some View {
        HStack(spacing: 2) {
            ForEach(0..<3) { i in
                Image(systemName: i < level ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundColor(i < level ? .yellow : .gray)
            }
        }
    }
}
