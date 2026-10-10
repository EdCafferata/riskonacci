# Artikel #02 — "Planning poker of risk poker: wanneer speel je welke ronde?" (DRAFT, NL + EN)

_Opgesteld 2026-10-10 door de marketing-routine. Niets gepubliceerd; publiceren = Ed (LinkedIn-artikel, dev.to/Hashnode).
Vergelijkingsartikel op **methode**-niveau (inspanning schatten vs. risico schatten) — bewust géén vergelijking met
concurrerende apps bij naam: daar zijn geen geverifieerde feiten over. Feiten over Riskonacci volgen het feitenblad in
`LAUNCH-KIT.md`. **Niet claimen:** Mac App Store (macOS-versie staat per 10 okt 2026 op REJECTED in ASC), Google Play,
gebruikersaantallen, "de enige"._

---

## EN — Effort round or risk round: which one does this backlog item need?

Most teams run one kind of estimation round: everyone picks a card, the cards flip, you talk about the outliers.
That round answers a single question — *how much work is this?* It does not answer *how likely is this to go wrong,
and how much would that hurt?* Those are different questions, and mixing them into one number is how a "5" quietly
turns into three sprints.

Here is a simple way to decide which round an item needs.

### 1. The effort round (classic planning poker)
**Use it when** the work is understood and the only open question is size.
- Signals: the team has built something similar before; dependencies are known; the acceptance criteria fit on one screen.
- Deck: Fibonacci, a standard deck, or T-shirt sizes — whatever your team already uses.
- What the spread tells you: a wide spread means people picture *different work*. Talk about scope.

### 2. The risk round (one card, None → Critical)
**Use it when** the size feels fine but someone is uneasy.
- Signals: "it depends on team X", "we've never touched that module", "the API isn't final", a hard deadline.
- Deck: a short risk scale — None, Low, Medium, High, Critical.
- What the spread tells you: a wide spread means people *know different things*. The person holding "High" usually
  knows something the rest of the room doesn't. That is the most valuable minute of the refinement.

### 3. The likelihood × impact round (two answers, one matrix)
**Use it when** the risk round came back "High" or split, and you need to know *what kind* of risk it is.
- Everyone answers two things: how likely is it, and how bad is it if it happens.
- Plot the votes on a 5×5 grid. Unlikely-but-catastrophic and likely-but-harmless both average out to "medium" on a
  single scale — on a matrix they land in opposite corners, and they need opposite responses (a fallback plan vs. just
  accepting it).

### A rule of thumb for a one-hour refinement
| Item looks like… | Round |
|---|---|
| Routine, known work | Effort only |
| Known work, external dependency or deadline | Effort + risk |
| New territory, or risk round came back High/split | Effort + likelihood × impact |
| Nobody can size it at all | Don't estimate — spike it first |

The risk round costs about a minute per item. You don't need it for everything; you need it for the two or three items
per sprint that would otherwise surprise you.

### Trying it
You can do all of this with paper cards and a whiteboard grid. If your team is remote or you'd rather not draw the
grid each time: Riskonacci is a free planning poker app for iPhone and iPad with the usual effort decks, a separate
risk deck, and an optional likelihood × impact round that shows everyone's vote as a dot on a 5×5 heatmap. Realtime
via a room code, no account, no ads, open source (GPL-3.0).

App Store: https://apps.apple.com/app/riskonacci/id6807144804 · Source: https://github.com/EdCafferata/riskonacci

---

## NL — Inspanningsronde of risicoronde: welke heeft dit backlog-item nodig?

De meeste teams spelen één soort schattingsronde: iedereen kiest een kaart, de kaarten draaien om, je bespreekt de
uitschieters. Die ronde beantwoordt één vraag — *hoeveel werk is dit?* Ze beantwoordt niet *hoe groot is de kans dat
het misgaat, en hoe erg is dat dan?* Dat zijn verschillende vragen, en wie ze in één getal stopt, ziet een "5"
ongemerkt uitgroeien tot drie sprints.

Zo kies je welke ronde een item nodig heeft.

### 1. De inspanningsronde (klassieke planning poker)
**Gebruik hem als** het werk begrepen is en alleen de omvang nog open staat.
- Signalen: het team heeft iets vergelijkbaars eerder gebouwd; afhankelijkheden zijn bekend; de acceptatiecriteria
  passen op één scherm.
- Deck: Fibonacci, een standaarddeck of T-shirtmaten — wat je team al gebruikt.
- Wat de spreiding zegt: grote spreiding betekent dat mensen *ander werk* voor zich zien. Praat over scope.

### 2. De risicoronde (één kaart, Geen → Kritiek)
**Gebruik hem als** de omvang prima voelt, maar iemand er niet gerust op is.
- Signalen: "het hangt af van team X", "die module hebben we nooit aangeraakt", "de API is nog niet definitief", een
  harde deadline.
- Deck: een korte risicoschaal — Geen, Laag, Midden, Hoog, Kritiek.
- Wat de spreiding zegt: grote spreiding betekent dat mensen *verschillende dingen weten*. Wie "Hoog" omhooghoudt,
  weet meestal iets wat de rest niet weet. Dat is de waardevolste minuut van de refinement.

### 3. De kans × impact-ronde (twee antwoorden, één matrix)
**Gebruik hem als** de risicoronde op "Hoog" uitkwam of verdeeld was, en je wilt weten *wat voor* risico het is.
- Iedereen beantwoordt twee dingen: hoe waarschijnlijk is het, en hoe erg is het als het gebeurt.
- Zet de stemmen in een 5×5-raster. Onwaarschijnlijk-maar-rampzalig en waarschijnlijk-maar-onschuldig middelen op één
  schaal allebei uit tot "midden" — in een matrix belanden ze in tegenovergestelde hoeken, en ze vragen om een
  tegenovergestelde reactie (een terugvalplan tegenover gewoon accepteren).

### Vuistregel voor een refinement van een uur
| Item ziet eruit als… | Ronde |
|---|---|
| Routine, bekend werk | Alleen inspanning |
| Bekend werk, externe afhankelijkheid of deadline | Inspanning + risico |
| Nieuw terrein, of risicoronde kwam op Hoog/verdeeld | Inspanning + kans × impact |
| Niemand kan het schatten | Niet schatten — eerst een spike |

De risicoronde kost ongeveer een minuut per item. Je hebt hem niet overal voor nodig; wel voor de twee of drie items
per sprint die je anders zouden verrassen.

### Zelf proberen
Dit kan allemaal met papieren kaarten en een raster op het whiteboard. Werkt je team op afstand, of wil je het raster
niet elke keer tekenen: Riskonacci is een gratis planning-poker-app voor iPhone en iPad met de gebruikelijke
inspanningsdecks, een apart risicodeck en een optionele kans × impact-ronde die ieders stem als bolletje op een
5×5-heatmap toont. Realtime via een roomcode, geen account, geen advertenties, open source (GPL-3.0).

App Store: https://apps.apple.com/nl/app/riskonacci/id6807144804 · Broncode: https://github.com/EdCafferata/riskonacci

---

## Publicatie-notities (voor Ed)
- Volgorde: eerst artikel #01 (`article-01-estimate-risk.md`), dit stuk 1–2 weken later; onderling linken.
- Reddit/communities: alleen zonder de slotalinea "Trying it" (waarde-eerst, geen app-plug).
- Controleer vóór publicatie de exacte kaartlabels van het risicodeck in de app-taal waarin je publiceert.
- Zodra de macOS-versie is goedgekeurd: "iPhone and iPad" → "iPhone, iPad and Mac".
