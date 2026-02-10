import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar with navigation buttons
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.goBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(viewModel.navigationManager.canGoBack ? .blue : .gray)
                    }
                    .disabled(!viewModel.navigationManager.canGoBack)
                    
                    Button(action: {
                        viewModel.goForward()
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(viewModel.navigationManager.canGoForward ? .blue : .gray)
                    }
                    .disabled(!viewModel.navigationManager.canGoForward)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search for a word...", text: $viewModel.searchText)
                            .focused($isSearchFocused)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.search)
                            .onSubmit {
                                viewModel.searchCurrentText()
                            }
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                                viewModel.suggestions = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
                
                // Suggestions list
                if !viewModel.suggestions.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.suggestions, id: \.self) { suggestion in
                                Button(action: {
                                    viewModel.selectWord(suggestion)
                                    isSearchFocused = false
                                }) {
                                    HStack {
                                        Text(suggestion)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "arrow.up.left")
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                    .padding()
                                }
                                
                                Divider()
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                } else if viewModel.showWordDetail {
                    // Tab picker for dictionaries
                    if viewModel.availableTabs.count > 1 {
                        Picker("Dictionary", selection: $viewModel.selectedTab) {
                            ForEach(viewModel.availableTabs) { tab in
                                Text(tab.rawValue).tag(tab)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.top, 4)
                    }
                    
                    // Show content based on selected tab
                    if viewModel.selectedTab == .dictionary, let word = viewModel.selectedWord {
                        WordDetailView(word: word, onWordTap: { tappedWord in
                            viewModel.lookupWordFromText(tappedWord)
                        })
                    } else if viewModel.selectedTab == .synonym, let html = viewModel.synonymHTML {
                        HTMLContentView(htmlContent: html)
                    } else if let word = viewModel.selectedWord {
                        WordDetailView(word: word, onWordTap: { tappedWord in
                            viewModel.lookupWordFromText(tappedWord)
                        })
                    } else if let html = viewModel.synonymHTML {
                        HTMLContentView(htmlContent: html)
                    }
                } else {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "book")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("Start typing to search")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text("Search for English words to see definitions and examples")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Spacer()
            }
            .navigationTitle("Dictionary")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Auto-focus on search field when app opens
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isSearchFocused = true
            }
        }
    }
}

#Preview {
    ContentView()
}
