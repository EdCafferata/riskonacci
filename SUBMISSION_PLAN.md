# Riskonacci — App Store indien-plan (opgesteld 2026-08-30 's nachts)

## Stand van zaken (vannacht veilig voorbereid — géén account-acties gedaan)
- ✅ **iOS simulator-build SUCCEEDED** (Firebase + Swift 6 + iOS 26 compileert)
- ✅ **Mac Catalyst-build SUCCEEDED** ("op de Mac moet het ook werken")
- ✅ **Versie → 1.0** gezet (`project.yml` + `.xcodeproj`, build 1)
- ✅ **fastlane** opgezet (`fastlane/Appfile` + `Fastfile`) met Admin-key **5R3497VHF5**
- ✅ **Metadata-concept** en-US + nl-NL (`fastlane/metadata/…`) — binnen limieten
- Lokale build-kopie: `~/riskonacci-build` (bouw hier, niet vanaf de trage SMB-mount)

## Nog OPEN keuzes (met Ed, morgen)
- App-naam **"Riskonacci"** moet vrij zijn op de App Store (bevestigen bij record aanmaken)
- Mac: via **Mac App Store onder dezelfde app-record** (Catalyst) — extra binary + eigen Mac-screenshots
- URLs bevestigen: **privacy_url** (repo heeft `docs/privacy.html` → waarschijnlijk GitHub Pages), **support_url**, **marketing_url**

## Stappen morgen (samen; uitgaande/onomkeerbare stappen doet Ed of bevestigt Ed)
1. **ASC app-record aanmaken** voor `info.cafferata.riskonacci` (naam, primaire taal, SKU, categorie). Bundle ID registreren in Developer-portal (cloud-signing kan dit automatisch bij de archive).
2. **iOS-archive + upload** (proven flow, zie onder). Build via automatic signing + Admin-key cloud-signing.
3. **Mac Catalyst-archive + upload** naar Mac App Store (aparte binary; Mac-signing + `.pkg`). LET OP: iets complexer dan iOS — Mac-distributiecert/installer nodig; cloud-signing kan dit meestal.
4. **Metadata uploaden** (`fastlane metadata`) + **screenshots** maken (iPhone 6.7", iPad 12.9", Mac) en uploaden.
5. **App Privacy** invullen (zie onder), **leeftijdsclassificatie** (waarschijnlijk 4+), **export-compliance** (geen niet-exempt encryptie).
6. **Indienen ter review** — de laatste "Submit to App Review" doet Ed zelf (Claude Code's classifier blokkeert die stap; zie Duski-ervaring).

## App Privacy (Firebase) — concept, te bevestigen
Firebase is de enige derde partij (matchmaking/relay), gratis Spark-tier. Te declareren:
- **Identifiers → User ID**: Firebase Anonymous Auth geeft elk toestel een anoniem UID. Gebruik: **App Functionality**. **Niet** gekoppeld aan identiteit, **niet** voor tracking.
- **User Content**: de gebruiker typt een **nickname** (`TextField("Your name")` in `RoomEntryView.swift`), gedeeld met de room en opgeslagen in Firestore, plus de **stemmen**. Kortstondig, verwijderd bij verlaten. Gebruik: App Functionality, niet voor tracking.
- **Geen** advertenties, **geen** analytics, **geen** tracking → "Data Not Used to Track You".
> Bevestigd (2026-08-31): nickname is een vrij invoerveld → **User Content** is verdedigbaar (zelfgekozen, niet geverifieerd). Apple kán het strikt als "Name" willen; Ed kiest.

## Werkende build-commando's (bewezen bij Duski — zelfde toolchain)
iOS-archive (automatic signing + cloud-signing via Admin-key):
```
cd ~/riskonacci-build
xcodebuild -project Riskonacci.xcodeproj -scheme Riskonacci -configuration Release \
  -destination 'generic/platform=iOS' -archivePath build/Riskonacci.xcarchive archive \
  -allowProvisioningUpdates \
  -authenticationKeyPath ~/.appstoreconnect/private_keys/AuthKey_5R3497VHF5.p8 \
  -authenticationKeyID 5R3497VHF5 -authenticationKeyIssuerID 69a6de7f-a9c3-47e3-e053-5b8c7c11a4d1
```
Export (app-store, automatic) → `.ipa`, dan upload met `xcrun altool --upload-app -f <ipa> -t ios --apiKey 5R3497VHF5 --apiIssuer 69a6de7f-a9c3-47e3-e053-5b8c7c11a4d1`.
Mac Catalyst-archive: zelfde maar `-destination 'platform=macOS,variant=Mac Catalyst'` en Mac App Store-export/`.pkg`.

## Randvoorwaarde (Firebase, runtime — niet nodig voor App Store-goedkeuring)
De README vereist eenmalig Firestore-rules + Anonymous Auth aan in het Firebase-project (gedeeld met de Android-poort). `GoogleService-Info.plist` staat al in de repo. Zonder rules werkt de app wél, maar synct niet tussen toestellen.
