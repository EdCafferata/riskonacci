# Riskonacci

**Riskonacci** is een gratis, native iOS/iPadOS/Mac Catalyst-app (SwiftUI) voor agile/lean planning poker — met een ingebouwd **risico**-kaarttype naast de gebruikelijke story-point-schattingen, iets wat vrijwel geen bestaande planning-poker-app aanbiedt. De naam is een woordspeling op Fibonacci, de reeks die vrijwel elke planning-poker-app als standaarddeck gebruikt.

Idee geopperd door Oscar Sarruco ([LinkedIn](https://www.linkedin.com/in/oscarsarrucco/)).

## Functies

- 🃏 **Meerdere decks** — Fibonacci, Standaard, T-Shirt-maten, en een apart **Risk**-deck (None → Low → Medium → High → Critical, eigen kleuren/iconen, geen hergebruikte Fibonacci-cijfers)
- 🎯 **Likelihood × Impact-modus** — optionele twee-rondes-schatting (eerst Likelihood, dan Impact), gecombineerd getoond in een 5×5-risicomatrix (groen → rood heat map) met ieders stem als bolletje
- 👥 **Samen spelen (lokaal netwerk of online)** — lokaal via MultipeerConnectivity (geen server nodig, Bonjour), of overal via CloudKit; host deelt een kort 5-teken room-ID, deelnemers joinen ermee
- 💻 **Mac Catalyst** — draait ook als macOS-app, handig om de reveal te tonen op een gedeeld scherm/projector tijdens een sessie
- 🌍 **Meertalig** — 10 talen (nl, de, fr, es, it, pt, ja, ko, zh-Hans, ru)
- ✨ **Liquid Glass** — moderne SwiftUI-materials en `.glassEffect()`/`.glassProminent`-styling (iOS 26)
- 💶 **Gratis, met vrijwillige fooienpot** (StoreKit 2) — geen abonnement, geen betaalmuur

## Privacy

Alles blijft standaard lokaal op het toestel — geen cloud-opslag van stemmen, deck-keuzes of sessiegeschiedenis. Voor lokaal-netwerk-multiplayer wordt alleen Bonjour/MultipeerConnectivity gebruikt (geen server, geen externe partij). Voor online rooms gebruikt Riskonacci CloudKit uitsluitend als kortstondig koppelmechanisme (matchmaking/relay) — deelnemer- en stemrecords worden door het eigen toestel verwijderd zodra iemand een room verlaat.

## CloudKit-opzet (eenmalig, alleen nodig voor online rooms)

De lokaal-netwerkmodus (Nearby) werkt zonder verdere configuratie. Voor de online modus zijn eenmalig twee dingen nodig die niet via de command line kunnen — beide vereisen een ingelogde Apple Developer-sessie in Xcode:

1. **iCloud-capability provisionen** — open het project in Xcode, zorg dat je Apple ID is ingelogd (Xcode → Settings → Accounts), en laat Automatic Signing (al aan) het App ID + provisioning-profiel bijwerken met de iCloud/CloudKit-capability uit `Riskonacci.entitlements`. Dit lukt niet via `xcodebuild` vanaf de command line zonder die ingelogde sessie.
2. **CloudKit Dashboard-schema** ([icloud.developer.apple.com](https://icloud.developer.apple.com), container `iCloud.info.cafferata.riskonacci`, Development environment):
   - **Indexes**: op de record types `Participant` en `Vote` het veld `roomID` als **Queryable** markeren (nodig zodra de app voor het eerst een record van dat type opslaat, verschijnt het type vanzelf in de lijst).
   - **Security Roles**: op record type `Room` de rol **Authenticated: Read, Write** toevoegen naast de standaard Creator-rol. Zonder deze stap kan host-overdracht (zie hieronder) niet daadwerkelijk de gedeelde room-state overnemen — alleen de oorspronkelijke host kan er dan bij.

Zonder deze twee stappen blijft de Online-toggle zichtbaar en bruikbaar, maar blijven roster/stemmen niet syncen tussen toestellen.

## Vereisten

- iOS/iPadOS 26.0 of nieuwer, of macOS via Mac Catalyst
- Xcode 26+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) om het `.xcodeproj` te (her)genereren vanuit `project.yml`

## Zelf bouwen

```bash
git clone git@github.com:EdCafferata/riskonacci.git
cd riskonacci
xcodegen generate   # optioneel, alleen nodig na wijzigingen aan project.yml
open Riskonacci.xcodeproj
```

## Licentie

GPL-3.0 — zie [LICENSE](LICENSE). Bijdragen zijn welkom; bijdragers krijgen erkenning via commits/contributors.
