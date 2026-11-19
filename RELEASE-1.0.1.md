# Riskonacci 1.0.1 — niet vergeten (uit de pre-release-check van 19 nov 2026)

Stand: iOS 1.0 en macOS 1.0 zijn live. In ASC staat build 4 (1.0.1, 6 nov) klaar; lokaal staat 1.0.1 (5).
Er hangt een lege, niet-ingediende reviewSubmission (READY_FOR_REVIEW, 0 items) — mag weg of hergebruikt worden.

**Al geregeld in de repo:**
- [x] Store-URL's in `fastlane/metadata/*/{support,marketing,privacy}_url.txt`. De live iOS-versie wijst nog naar
      `github.com/EdCafferata/riskonacci` (NL-support), `cafferata.info/riskonacci-support.html` (EN) en
      `cafferata.info` als marketing-URL; met deze bestanden zet `fastlane` ze bij 1.0.1 goed.
- [x] Release-notes 1.0.1 (stond nog "First public release").

**Opgelost 19 nov (via API, live, geen build nodig):**
- [x] Derde fooi (Aperitivo) werkte niet: `tip.aperetivo` stond op DEVELOPER_REMOVED_FROM_SALE. Weer in de verkoop
      gezet (175 landen, APPROVED, naam terug naar "Aperitivo Tip"); het halve NON_CONSUMABLE `tip.aperitivo` verwijderd.
      De code (`TipProduct.aperitivo` = `tip.aperetivo`) klopt dus en blijft zo.

**Verder:**
- [ ] Minimaal iOS/macOS 26.0 — overwegen omlaag te gaan (zoals Duski → 18.0) voor meer bereik.
- [ ] Testen op een echt toestel, daarna pre-release-check (skill `pre-release-app-review`) en indienen (iOS + macOS).
