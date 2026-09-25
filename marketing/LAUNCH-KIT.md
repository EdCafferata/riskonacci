# Riskonacci — Launch-kit: Product Hunt · Show HN · Indie Hackers · AlternativeTo (DRAFT)

_Opgesteld 2026-09-25 door de marketing-routine. Niets ingediend: alle accounts/inlog/posten = Ed.
Alles feitelijk volgens README/app-code; niet claimen wat niet bevestigd is (zie "Niet claimen")._

## Feitenblad (bron voor alle teksten)
| | |
|---|---|
| Naam | Riskonacci (woordspeling op Fibonacci) |
| Platforms | iPhone, iPad (iOS/iPadOS 26+), Mac (Catalyst — **status ASC bevestigen**) |
| Prijs | Gratis, geen abonnement, geen advertenties; optionele fooienpot (3 tiers) |
| Kern | Planning poker (Fibonacci / Standaard / T-shirt) + apart **Risk-deck** (None→Critical) + optionele **Likelihood × Impact**-modus met 5×5-heatmap, ieders stem als bolletje |
| Multiplayer | Realtime via 5-teken room-code, geen account (Firebase anonymous auth), stemmen worden bij verlaten verwijderd |
| Talen | 11 (en + nl, de, fr, es, it, pt, ja, ko, zh-Hans, ru) |
| Open source | GPL-3.0 — github.com/EdCafferata/riskonacci (+ Android-poort-repo) |
| Maker | Ed Cafferata / The IT Crowd. Idee: Oscar Sarruco (credit geven, met zijn akkoord taggen) |
| Link | https://apps.apple.com/app/riskonacci/id6807144804 |

**Niet claimen tot bevestigd:** Android/Google Play-beschikbaarheid, Mac App Store-beschikbaarheid,
gebruikersaantallen, "de enige" (zeg "most planning poker tools only estimate effort").

---

## 1. Product Hunt

**Name:** Riskonacci
**Tagline (≤60):** `Planning poker that estimates risk, not just effort` (51)
  - alt: `Free planning poker with a built-in risk matrix` (47)
**Topics:** Productivity · Developer Tools · Task Management · iOS (Mac als bevestigd)
**Pricing:** Free

**Description (≤260):**
> Free planning poker for agile teams — with a separate risk deck and an optional likelihood × impact
> round that plots everyone's vote on a 5×5 matrix. Realtime with a room code, no account, open source.
> iPhone, iPad & Mac.

**Maker's first comment:**
> Hi Product Hunt 👋 I'm Ed.
>
> In almost every refinement I've been in, the team agrees on "5 points" and nobody mentions that the
> item depends on something that might not be ready. Story points measure effort — they don't show risk.
>
> Riskonacci is planning poker with a second question built in:
> • the usual Fibonacci / T-shirt decks
> • a separate Risk deck (None → Critical)
> • an optional two-round Likelihood × Impact mode — everyone's vote shows up as a dot on a 5×5 heat map,
>   so disagreement is visible at a glance
>
> Join with a 5-character room code, no sign-up. Stuff is deleted when you leave. It's free (there's a
> tip jar if you like it) and the code is GPL-3.0 on GitHub.
>
> The idea came from my colleague Oscar Sarruco — credit where it's due.
>
> I'd love to hear: does your team talk about risk during estimation, or only in the retro?

**Gallery (1270×760, 5 stuks):** (1) hero "Estimate effort *and* risk" + deck, (2) 5×5-matrix-reveal met
bolletjes, (3) room-code join-scherm "No account. Just a code.", (4) iPad/Mac op projector "Reveal on
the big screen", (5) talenlijst + "Free & open source". → maken met screenshots uit de simulator in een
beheerde sessie (UI-tools werken niet in geplande runs).
**Launch-dag:** dinsdag of woensdag, 00:01 PT (09:01 NL). Ed moet de hele dag reacties kunnen beantwoorden.
**Niet doen:** upvotes vragen in groepen/DM-blasts (PH straft dat af). Wél: vooraf 1 LinkedIn-post
"we launchen dinsdag op PH" en de dag zelf de link delen.

## 2. Show HN

**Title (≤80):** `Show HN: Riskonacci – open-source planning poker with a likelihood×impact round`
**URL:** https://github.com/EdCafferata/riskonacci (HN waardeert de repo boven de App Store-link)
**Tekst (eerste reactie door Ed):**
> I built this after too many sprints where a "5" quietly depended on another team's API. Besides the
> normal Fibonacci/T-shirt decks it has a risk deck and an optional two-round mode (likelihood, then
> impact) that plots every vote on a 5×5 grid, so a lone "this is risky" vote stands out.
>
> Tech: SwiftUI (iOS 26 / Mac Catalyst), Firestore as the only backend for realtime rooms, anonymous
> auth so there are no accounts; participant and vote docs are deleted by the client when leaving.
> Security rules are in the README. There's a Kotlin Android port sharing the same Firebase project.
> GPL-3.0.
>
> Happy to hear criticism of the risk-estimation idea itself — is a second round worth the time, or is
> this better handled with spikes?

**Timing:** di–do, 15:00–17:00 NL (ochtend US-oost). Eén keer posten; niet herposten als hij niet
aanslaat (hooguit later via de "second chance"-mail van de mods).

## 3. Indie Hackers (product + post)
**Post-titel:** `Launched a free, open-source planning poker app — what I'd do differently`
Invalshoek: eerlijk bouwverhaal (idee van collega, SwiftUI + Firebase zonder eigen server, App
Review-lessen, tip-jar i.p.v. abo en waarom). Geen cijfers verzinnen — alleen echte cijfers uit ASC
Analytics als Ed ze wil delen.

## 4. AlternativeTo (listing)
**Als alternatief voor:** Planning Poker Online, PlanITpoker, Scrum Poker Online, Pointing Poker
(Ed checkt bij indienen dat deze op AlternativeTo staan).
**Beschrijving:**
> Riskonacci is a free, open-source planning poker app for iPhone, iPad and Mac. Besides Fibonacci and
> T-shirt decks it includes a dedicated risk deck and an optional likelihood × impact round shown on a
> 5×5 heat map. Teams join a realtime room with a short code — no account needed. Available in 11 languages.
**Tags:** planning-poker, scrum, agile, estimation, risk-management, open-source, no-registration
**Licentie:** Open Source (GPL-3.0) · **Platforms:** iPhone, iPad, Mac

## 5. Volgorde (voorstel)
1. Eerst artikel #01 (`article-01-estimate-risk.md`) + 2–3 LinkedIn-posts → wat publiek opbouwen.
2. AlternativeTo-listing (evergreen, geen timing nodig).
3. Show HN (open-source-hoek) — los van PH, andere week.
4. Product Hunt als de gallery-beelden klaar zijn en Mac-status bevestigd is.
5. Indie Hackers-post een week na PH met de echte lessen.

## Ed doet dit (checklist)
- [ ] Mac App Store- en Play-status bevestigen (bepaalt wat we mogen claimen).
- [ ] Accounts: Product Hunt, Hacker News, Indie Hackers, AlternativeTo (Claude maakt geen accounts).
- [ ] Oscar Sarruco vragen of hij genoemd/getagd mag worden.
- [ ] Beheerde sessie plannen voor de 5 gallery-beelden (simulator-screenshots + overlay).
- [ ] Launch-datum PH kiezen en die dag vrijhouden voor reacties.
