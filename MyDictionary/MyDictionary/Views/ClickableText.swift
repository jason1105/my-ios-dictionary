import SwiftUI

struct ClickableText: View {
    let text: String
    let onWordTap: (String) -> Void
    @State private var selectedWord: String?
    @State private var showPopover = false
    
    var body: some View {
        let words = text.split(separator: " ")
        
        FlowLayout(spacing: 4) {
            ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                let cleanWord = cleanWordForLookup(String(word))
                
                Text(word)
                    .foregroundColor(isWord(cleanWord) ? .blue : .primary)
                    .underline(isWord(cleanWord))
                    .onTapGesture {
                        if isWord(cleanWord) {
                            selectedWord = cleanWord
                            showPopover = true
                        }
                    }
                    .popover(isPresented: Binding(
                        get: { showPopover && selectedWord == cleanWord },
                        set: { if !$0 { showPopover = false } }
                    )) {
                        if let word = selectedWord {
                            WordPopoverView(word: word, onDetailsPressed: {
                                showPopover = false
                                onWordTap(word)
                            })
                        }
                    }
            }
        }
    }
    
    private func cleanWordForLookup(_ word: String) -> String {
        let cleaned = word.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        return cleaned.lowercased()
    }
    
    private func isWord(_ word: String) -> Bool {
        return DictionaryService.shared.searchWord(word) != nil
    }
}

// Flow layout for wrapping text
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                      y: bounds.minY + result.frames[index].minY),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
