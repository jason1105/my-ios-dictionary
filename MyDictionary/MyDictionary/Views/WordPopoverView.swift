import SwiftUI

struct WordPopoverView: View {
    let word: String
    let onDetailsPressed: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let wordData = DictionaryService.shared.searchWord(word) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(wordData.word.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(wordData.posDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                    
                    Divider()
                    
                    ForEach(wordData.definitions.prefix(2)) { definition in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• \(definition.meaning)")
                                .font(.body)
                        }
                    }
                    
                    if wordData.definitions.count > 2 {
                        Text("...")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: onDetailsPressed) {
                        HStack {
                            Text("Details")
                            Image(systemName: "arrow.right.circle")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
            } else {
                Text("Word not found")
                    .padding()
            }
        }
        .frame(width: 300)
    }
}
