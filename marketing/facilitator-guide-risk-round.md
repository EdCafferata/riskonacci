# Riskonacci — Facilitator guide: a risk round in 15 minutes (DRAFT)

_Draft 10 okt 2026 (routine 18:12). Plan §4 "Sjablonen: Likelihood×Impact-matrix uitleg". Niets gepubliceerd._

**Doel:** een gratis, deelbaar hulpmiddel (LinkedIn-document/carrousel, dev.to-post, of PDF op cafferata.info) dat ook
zonder de app bruikbaar is. Waarde eerst; de app staat alleen in de laatste regel. Sluit aan op artikel #01 en #02.

**Feiten-check (tegen de code, 10 okt):** schalen komen 1-op-1 uit `Sources/Models/RiskAxis.swift`
(Likelihood: Rare → Almost Certain; Impact: Negligible → Catastrophic); twee rondes staan standaard aan bij het
Risk-deck (`GameViewModel.isTwoRoundFlow`); speciale kaarten `?` en `☕` bestaan in elk deck (`Deck.swift`).
Platform: **iPhone en iPad** — geen Mac noemen (macOS 1.0 = REJECTED).

---

## EN — "Run a risk round in 15 minutes"

**When to use it.** Not for every backlog item. Use it when an item touches something you don't control (another
team, a vendor, a migration, a deadline set by someone else), or when the effort votes were close but the room still
feels uneasy.

**What you need.** The team, one item, and two five-step scales:

| Step | Likelihood — how likely is it to go wrong? | Impact — how bad is it if it does? |
|---|---|---|
| 1 | Rare | Negligible |
| 2 | Unlikely | Minor |
| 3 | Possible | Moderate |
| 4 | Likely | Major |
| 5 | Almost Certain | Catastrophic |

**The 15 minutes**

1. **Name the risk in one sentence (2 min).** "The payment provider's sandbox may not be ready in sprint 3." If you
   can't say it in one sentence, you have two risks — split them.
2. **Vote on likelihood, silently (1 min).** Everyone picks a card. No discussion before the reveal; that is the whole
   point of poker.
3. **Vote on impact, silently (1 min).** Same rule. Voting the two separately stops "scary" from being counted twice.
4. **Reveal and look at the spread, not the average (1 min).** Plot every vote on the 5×5 grid. A tight cluster means
   you agree. One dot far from the rest is the most valuable thing on the screen.
5. **Let the outlier talk first (5 min).** Ask: "What do you know that we don't?" Usually it is a past incident, a
   dependency, or an assumption nobody else checked.
6. **Decide one action (5 min).** Pick exactly one:
   - *Accept* — low on both axes; write it down and move on.
   - *Reduce* — add a spike, a test, or an earlier integration to the sprint.
   - *Split* — carve the risky part into its own item and estimate it separately.
   - *Escalate* — high impact and outside the team's control; the product owner takes it out of the room.

**Three rules that keep it honest**

- A `?` card is an answer. It means "I can't judge this", and it tells you who needs information.
- Don't re-vote until someone has said something new.
- Risk does not change the story points. It changes what you *do* before you start.

**A filled-in example**

> Item: "Switch login to the new identity provider."
> Likelihood votes: Possible, Possible, Likely, Unlikely, Almost Certain.
> Impact votes: Major, Major, Major, Catastrophic, Major.
> The "Almost Certain" voter did the previous provider switch and remembers the token-lifetime mismatch.
> Action: *Reduce* — a half-day spike on token lifetimes before the item enters the sprint.

_If you'd rather not draw the grid on a whiteboard: Riskonacci is a free planning-poker app for iPhone and iPad with
this two-round risk mode built in. No account needed. {App Store link}_

---

## NL — "Een risicoronde in 15 minuten"

**Wanneer.** Niet bij elk backlog-item. Wel als het item iets raakt waar jullie geen grip op hebben (een ander team,
een leverancier, een migratie, een opgelegde deadline), of als de effort-stemmen dicht bij elkaar lagen maar het toch
niet lekker voelt.

**Wat je nodig hebt.** Het team, één item en twee schalen van vijf stappen:

| Stap | Waarschijnlijkheid (kans) — hoe waarschijnlijk gaat het mis? | Impact — hoe erg is het dan? |
|---|---|---|
| 1 | Zeldzaam (Rare) | Verwaarloosbaar (Negligible) |
| 2 | Onwaarschijnlijk (Unlikely) | Klein (Minor) |
| 3 | Mogelijk (Possible) | Matig (Moderate) |
| 4 | Waarschijnlijk (Likely) | Groot (Major) |
| 5 | Vrijwel zeker (Almost Certain) | Catastrofaal (Catastrophic) |

_Labels gecheckt tegen de NL-strings in `Localizable.xcstrings` (identiek). De as heet in de app
"Waarschijnlijkheid"; in de lopende tekst gebruik ik het kortere "kans"._

**De 15 minuten**

1. **Benoem het risico in één zin (2 min).** "De sandbox van de betaalprovider is in sprint 3 misschien nog niet
   klaar." Lukt het niet in één zin, dan zijn het twee risico's — splits ze.
2. **Stem in stilte op kans (1 min).** Iedereen kiest een kaart. Geen discussie vóór het omdraaien.
3. **Stem in stilte op impact (1 min).** Zelfde regel. Door apart te stemmen tel je "eng" niet dubbel.
4. **Draai om en kijk naar de spreiding, niet naar het gemiddelde (1 min).** Zet elke stem in het 5×5-raster. Eén
   stip ver van de rest is het waardevolste op het scherm.
5. **De uitschieter praat eerst (5 min).** Vraag: "Wat weet jij dat wij niet weten?"
6. **Kies één actie (5 min).** *Accepteren* (laag op beide assen), *verkleinen* (spike, test of eerdere integratie),
   *splitsen* (het riskante deel wordt een eigen item) of *escaleren* (grote impact, buiten het team).

**Drie regels**

- Een `?`-kaart is een antwoord: "ik kan dit niet inschatten". Dan weet je wie informatie mist.
- Stem pas opnieuw als iemand iets nieuws heeft gezegd.
- Risico verandert de story points niet. Het verandert wat je doet vóórdat je begint.

_Liever geen raster op het whiteboard tekenen? Riskonacci is een gratis planning-poker-app voor iPhone en iPad met
deze risicoronde in twee stappen ingebouwd. Geen account nodig. {App Store-link}_

---

## Hergebruik

- **LinkedIn-carrousel (7 slides):** titel · wanneer · de twee schalen · stap 1–3 · stap 4–5 · de vier acties · drie regels.
- **Eerste reactie onder de post:** de App Store-link (niet in de post zelf).
- **Outreach:** bruikbaar als "iets nuttigs om te delen" in template B/C van `OUTREACH-PITCHES.md`.

## Ed doet dit

- [ ] Kiezen: LinkedIn-document, dev.to of PDF op cafferata.info (of alle drie).
- [ ] Carrousel-beelden: beheerde sessie nodig voor een echte matrix-screenshot.
