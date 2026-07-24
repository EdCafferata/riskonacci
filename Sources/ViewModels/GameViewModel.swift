import SwiftUI
import Observation

enum RiskRound: Codable {
    case likelihood
    case impact
}

@Observable
final class GameViewModel {
    var selectedDeck: Deck?
    var selectedCard: PokerCard?
    var isRevealed = false

    /// Two-round Likelihood × Impact mode for the Risk deck. On by default;
    /// in a multiplayer room only the host will be able to toggle this —
    /// for the local single-device MVP the local player stands in as host.
    var twoRoundsEnabled = true
    var likelihoodCard: PokerCard?
    var impactCard: PokerCard?
    var currentRiskRound: RiskRound = .likelihood

    var isTwoRoundFlow: Bool {
        selectedDeck == .risk && twoRoundsEnabled
    }

    var currentCards: [PokerCard] {
        guard let selectedDeck else { return [] }
        guard isTwoRoundFlow else { return selectedDeck.cards }
        return currentRiskRound == .likelihood ? RiskAxis.likelihood.cards : RiskAxis.impact.cards
    }

    var currentTitle: LocalizedStringResource {
        guard let selectedDeck else { return "" }
        guard isTwoRoundFlow else { return selectedDeck.localizedName }
        return currentRiskRound == .likelihood ? RiskAxis.likelihood.localizedName : RiskAxis.impact.localizedName
    }

    func chooseDeck(_ deck: Deck) {
        selectedDeck = deck
        reset()
    }

    func isSelected(_ card: PokerCard) -> Bool {
        if isTwoRoundFlow {
            currentRiskRound == .likelihood ? likelihoodCard == card : impactCard == card
        } else {
            selectedCard == card
        }
    }

    func pick(_ card: PokerCard) {
        guard isTwoRoundFlow else {
            selectedCard = card
            isRevealed = true
            return
        }

        switch currentRiskRound {
        case .likelihood:
            likelihoodCard = card
            currentRiskRound = .impact
        case .impact:
            impactCard = card
            isRevealed = true
        }
    }

    /// True once Likelihood has been picked — i.e. there's a previous
    /// round to step back to and change.
    var canGoBack: Bool {
        isTwoRoundFlow && likelihoodCard != nil
    }

    /// Steps back one round (Impact → Likelihood) to change an answer,
    /// without discarding the other round's already-cast pick.
    func goBack() {
        if impactCard != nil {
            impactCard = nil
            currentRiskRound = .impact
        } else if likelihoodCard != nil {
            likelihoodCard = nil
            currentRiskRound = .likelihood
        }
    }

    func reset() {
        selectedCard = nil
        likelihoodCard = nil
        impactCard = nil
        currentRiskRound = .likelihood
        isRevealed = false
    }

    func backToDecks() {
        selectedDeck = nil
        reset()
    }
}
