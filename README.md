# Riskonacci

🔒 Laatste security check: 2026-08-08 22:56 CEST

**Riskonacci** is een gratis, native iOS/iPadOS/Mac Catalyst-app (SwiftUI) voor agile/lean planning poker — met een ingebouwd **risico**-kaarttype naast de gebruikelijke story-point-schattingen, iets wat vrijwel geen bestaande planning-poker-app aanbiedt. De naam is een woordspeling op Fibonacci, de reeks die vrijwel elke planning-poker-app als standaarddeck gebruikt.

Idee geopperd door Oscar Sarruco ([LinkedIn](https://www.linkedin.com/in/oscarsarrucco/)).

## Functies

- 🃏 **Meerdere decks** — Fibonacci, Standaard, T-Shirt-maten, en een apart **Risk**-deck (None → Low → Medium → High → Critical, eigen kleuren/iconen, geen hergebruikte Fibonacci-cijfers)
- 🎯 **Likelihood × Impact-modus** — optionele twee-rondes-schatting (eerst Likelihood, dan Impact), gecombineerd getoond in een 5×5-risicomatrix (groen → rood heat map) met ieders stem als bolletje
- 👥 **Samen spelen (overal, ook cross-platform)** — via Firebase, hetzelfde voor "in de buurt" en "overal": host deelt een kort 5-teken room-ID, deelnemers joinen ermee. Werkt tussen iPhone én Android — zie de [Android-poort](https://github.com/EdCafferata/riskonacci-android)
- 💻 **Mac Catalyst** — draait ook als macOS-app, handig om de reveal te tonen op een gedeeld scherm/projector tijdens een sessie
- 🌍 **Meertalig** — 10 talen (nl, de, fr, es, it, pt, ja, ko, zh-Hans, ru)
- ✨ **Liquid Glass** — moderne SwiftUI-materials en `.glassEffect()`/`.glassProminent`-styling (iOS 26)
- 💶 **Gratis, met vrijwillige fooienpot** (StoreKit 2) — geen abonnement, geen betaalmuur

## Privacy

Alles blijft zoveel mogelijk kortstondig: Firebase Anonymous Auth geeft elk toestel een eigen ID zonder dat er een account/inlog nodig is, en deelnemer-/stemrecords worden door het eigen toestel verwijderd zodra iemand een room verlaat. Er is geen eigen server — Firebase is de enige derde partij, uitsluitend als matchmaking/relay tussen deelnemers.

## Firebase-opzet (eenmalig, gedeeld met de Android-poort)

Beide apps (deze repo en [riskonacci-android](https://github.com/EdCafferata/riskonacci-android)) praten met hetzelfde Firebase-project, zodat iPhone- en Android-gebruikers in dezelfde room kunnen spelen. Eenmalig in te stellen op [console.firebase.google.com](https://console.firebase.google.com) (gratis Spark-tier, geen betaling nodig):

1. Firestore Database aanmaken (production mode)
2. **Authentication → Sign-in method → Anonymous** aanzetten
3. Een iOS-app toevoegen met bundle ID `info.cafferata.riskonacci` → `GoogleService-Info.plist` downloaden en in de projectroot zetten (dit bestand is bewust gitignored, net als andere API-sleutels in deze repo — vraag het bestand op bij wie het Firebase-project beheert)
4. **Firestore → Rules**, plak:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /rooms/{roomId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      // Elke huidige deelnemer mag de room-state schrijven — dat is wat
      // host-overdracht laat werken: wie de client-side verkiezing ook
      // kiest, kan gewoon gaan schrijven, geen creator-only-restrictie.
      allow update: if request.auth != null &&
        exists(/databases/$(database)/documents/rooms/$(roomId)/participants/$(request.auth.uid));

      match /participants/{participantId} {
        allow read: if request.auth != null;
        // Document-ID is letterlijk de Firebase Auth UID, dus dit is een
        // simpele exacte match, geen query.
        allow write: if request.auth != null && request.auth.uid == participantId;
      }

      match /votes/{voteId} {
        allow read: if request.auth != null;
        allow create, update: if request.auth != null &&
          request.auth.uid == request.resource.data.participantID;
        allow delete: if request.auth != null &&
          request.auth.uid == resource.data.participantID;
      }
    }
  }
}
```

Zonder deze rules blijft de app bruikbaar (alle Firestore-aanroepen falen stil, geen crash), maar syncen roster/stemmen niet tussen toestellen.

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
