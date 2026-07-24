import StoreKit
import Observation

@MainActor
@Observable
final class TipJarStore {
    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var lastTipMessage: String?

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let ids = TipProduct.allCases.map(\.rawValue)
            products = try await Product.products(for: ids).sorted { $0.price < $1.price }
        } catch {
            products = []
        }
    }

    func tip(_ product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    lastTipMessage = "Grazie mille! 🍇"
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            lastTipMessage = nil
        }
    }
}
