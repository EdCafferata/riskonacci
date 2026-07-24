import SwiftUI
import StoreKit

struct TipJarView: View {
    @State private var store = TipJarStore()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(.red)
                            Text("Riskonacci is free, always.")
                                .font(.title3.bold())
                            Text("If it saves your team time, a small tip is always appreciated — never required.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top, 24)

                        if store.isLoading {
                            ProgressView()
                        } else {
                            GlassEffectContainer(spacing: 14) {
                                VStack(spacing: 14) {
                                    ForEach(store.products) { product in
                                        tipButton(for: product)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        if let message = store.lastTipMessage {
                            Text(message)
                                .font(.headline)
                                .foregroundStyle(Color.accentColor)
                        }

                        thanksSection
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 32)
                    .frame(maxWidth: 480)
                    .frame(maxWidth: .infinity)
                }
                // Fixed at 80% of the screen height, independent of the
                // scroll content's length, instead of living inline where
                // it would drift depending on how much is above it.
                .overlay(alignment: .top) {
                    rateButton
                        .padding(.top, geometry.size.height * 0.8)
                }
            }
            .navigationTitle("Tip Jar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .task {
            await store.loadProducts()
        }
    }

    private var rateButton: some View {
        Button {
            requestReview()
        } label: {
            Label("Rate Riskonacci", systemImage: "star.fill")
        }
        .buttonStyle(.glass)
    }

    private var thanksSection: some View {
        VStack(spacing: 10) {
            Divider()
                .padding(.horizontal, 40)

            Text("Grazie 🇮🇹")
                .font(.headline)

            Text("Built by The IT Crowd, made better by everyone who tests it and sends feedback. Once Riskonacci moves to GitHub, code contributors will be credited here too.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Link(destination: URL(string: "https://www.linkedin.com/in/oscarsarrucco/")!) {
                HStack(spacing: 4) {
                    Text("Idea by Oscar Sarruco")
                    Image(systemName: "arrow.up.right")
                        .font(.caption2)
                }
                .font(.footnote.bold())
                .foregroundStyle(Color.accentColor)
            }
            .padding(.top, 4)
        }
    }

    private func tipButton(for product: Product) -> some View {
        let tip = TipProduct(rawValue: product.id)

        return Button {
            Task { await store.tip(product) }
        } label: {
            HStack {
                Image(systemName: tip?.symbolName ?? "heart")
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 28)
                Text(tip?.displayName ?? product.displayName)
                Spacer()
                Text(product.displayPrice)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
    }
}
