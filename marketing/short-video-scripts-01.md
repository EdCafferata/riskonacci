# Riskonacci — Short-video-scripts #01 + screenshot-overlayteksten (DRAFT)

_Opgesteld 2026-09-26 door de marketing-routine. Niets gepost of opgenomen: opnemen (simulator-/schermopname)
kan alleen in een beheerde sessie, posten = Ed. Feiten volgens `LAUNCH-KIT.md` → Feitenblad; niet claimen
wat daar onder "Niet claimen" staat (Android/Play, Mac App Store, gebruikersaantallen, "de enige")._

**Formaat:** 9:16, 15–30 s, ingebrande ondertitels (de meeste LinkedIn-/Shorts-kijkers kijken zonder geluid).
**Kanalen:** LinkedIn-native video (primair, B2B-publiek), YouTube Shorts (evergreen zoekbaar), Instagram Reels (optioneel).
**Beeldmateriaal:** schermopnames uit de simulator (iPhone 17 Pro Max + iPad) met de UI-labels zoals ze in de app
staan: *Play together*, *Host a room*, *Join*, *Share code*, *Reveal*, *Reset*, *New round*, *Likelihood*, *Impact*.
Multiplayer-shots: 2–3 simulators naast elkaar in dezelfde room (DEBUG auto-host/auto-join-hooks in
`DebugLaunchOptions.swift`) zodat je de realtime-reveal ziet.
**Afsluiter (elke clip, 2 s):** logo + "Riskonacci — free on the App Store" / "gratis in de App Store". Link in
eerste reactie (LinkedIn) of beschrijving (Shorts), niet in de videotekst.

---

## 1. "The 5 that wasn't" (hook-verhaal) — 25 s
| t | Beeld | Tekst in beeld |
|---|---|---|
| 0–3 | Kaartenwaaier Fibonacci, iedereen kiest 5 | "Everyone voted 5." |
| 3–7 | Zelfde scherm, zoom op één deelnemer | "Nobody mentioned it depends on another team's API." |
| 7–14 | Wissel naar Risk-deck, stemmen: None, Low, **High** | "Riskonacci adds a second question: how risky is it?" |
| 14–20 | *Reveal* → het ene High valt op | "One vote says High. Now you talk about it — before the sprint." |
| 20–25 | Afsluiter | "Estimate effort *and* risk. Free." |

## 2. "Room in 10 seconds" (frictie wegnemen) — 15 s
0–3 *Host a room* → 5-teken-code verschijnt · "No account." · 3–7 *Share code* → tweede toestel typt code, *Join* ·
"No sign-up." · 7–12 beide toestellen tonen de deelnemers · "Just a code." · 12–15 afsluiter.

## 3. "Likelihood × Impact in one round" (unieke feature) — 30 s
0–4 Host zet de Likelihood×Impact-modus aan · "Risk has two sides." · 4–12 ronde 1 *Likelihood*, iedereen stemt ·
"How likely?" · 12–20 ronde 2 *Impact* · "How bad?" · 20–27 5×5-heatmap met ieders stem als bolletje ·
"Every vote on one matrix. Outliers jump out." · 27–30 afsluiter.

## 4. "Planning poker in 60 seconds" (tutorial, YouTube Shorts-titel = zoekterm) — 30 s (versneld)
Voice-over/ondertitel stap voor stap: open app → *Play together* → *Host a room* → *Share code* → team joint →
deck kiezen (Fibonacci / Standard / T-shirt) → iedereen kiest verdekt → *Reveal* → bespreken → *New round*.
Titel: "How to run planning poker in 60 seconds (free app)".

## 5. "Fibonacci, Standard or T-shirt?" (educatief) — 25 s
Deck-picker in beeld, per deck 5 s met één zin: Fibonacci (0–89) = "gaps grow with uncertainty"; Standard
(0, 1, 2, 3, 5, 8, 13, 20, 40, 100) = "the classic scrum deck"; T-shirt (XS–XXL) = "rough sizing for early roadmap items". Slot: "Pick per session. Switch any time."

## 6. "Why hide the cards?" (agile-uitleg, waarde-eerst) — 20 s
Kaarten liggen omgedraaid → *Reveal*. Tekst: "Anchoring: the first number said out loud pulls everyone toward it."
→ "Hidden votes, revealed together = honest estimates." Geen hard sell; alleen afsluiter.

## 7. "The big screen" (iPad/Mac in de meetingroom) — 20 s
iPad-opname (of Mac als bevestigd) met de reveal groot in beeld, telefoons stemmen. Tekst: "Phones vote. The big
screen reveals." Mac pas noemen als de Mac App Store-status bevestigd is — anders "iPad".

## 8. "Leave no trace" (privacy) — 15 s
*Leave* tikken → deelnemerslijst leeg. Tekst: "No account. No ads. Your votes are deleted when you leave."
(Klopt: anonieme Firebase-auth, client verwijdert participant- en vote-docs bij verlaten.)

## 9. "Open source" (dev-publiek, voor Show HN-week) — 20 s
Split: app links, GitHub-repo rechts scrollend door SwiftUI-code. Tekst: "SwiftUI. Firestore. GPL-3.0." →
"Read the code, file an issue, send a PR." → repo-URL als eindkaart (i.p.v. App Store).

## 10. "Remote team, 3 time zones" (use-case) — 25 s
Drie simulators met verschillende taalinstellingen (en / nl / ja) in dezelfde room. Tekst: "Same room. Three
languages." → "Riskonacci speaks 11." → reveal synchroon op alle drie. Afsluiter.

**Posting-ritme (voorstel):** LinkedIn 1 clip/week (di of wo, 08:00–09:00 NL), afwisselen met de posts uit
`linkedin-batch-01.md`; Shorts mogen 2/week. Volgorde: 1 → 3 → 2 → 6 → 4 → 10 → 8 → 5 → 7 → 9 (9 in Show HN-week).

---

## Screenshot-overlayteksten (App Store-set, 6 schermen)

Voor de volgende screenshot-set (iPhone 6.9" + iPad 13", later Mac). Kop ≤ ~28 tekens zodat hij op iPhone in
twee regels past. Volgorde volgt het verhaal: wat → uniek → hoe samen → privacy → decks → gratis.

| # | Scherm | en | nl | de |
|---|---|---|---|---|
| 1 | Kaartenwaaier | Planning poker, done right | Planning poker, maar dan goed | Planning Poker, richtig gemacht |
| 2 | Risk-deck reveal | Estimate risk, not just effort | Schat risico, niet alleen effort | Risiko schätzen, nicht nur Aufwand |
| 3 | 5×5-matrix | Likelihood × Impact at a glance | Kans × impact in één oogopslag | Wahrscheinlichkeit × Auswirkung |
| 4 | Room-code | Join with a code. No account. | Meedoen met een code. Geen account. | Mit Code beitreten. Kein Konto. |
| 5 | Deck-picker | Fibonacci, Standard or T-shirt | Fibonacci, standaard of T-shirt | Fibonacci, Standard oder T-Shirt |
| 6 | Reveal op iPad | Free. No ads. Open source. | Gratis. Geen advertenties. Open source. | Kostenlos. Keine Werbung. Open Source. |

| # | fr | es | it | pt-BR |
|---|---|---|---|---|
| 1 | Le planning poker, bien fait | Planning poker, bien hecho | Planning poker, fatto bene | Planning poker do jeito certo |
| 2 | Estimez le risque, pas que l'effort | Estima el riesgo, no solo el esfuerzo | Stima il rischio, non solo lo sforzo | Estime o risco, não só o esforço |
| 3 | Probabilité × impact d'un coup d'œil | Probabilidad × impacto de un vistazo | Probabilità × impatto a colpo d'occhio | Probabilidade × impacto num relance |
| 4 | Un code, sans compte | Únete con un código. Sin cuenta. | Entra con un codice. Senza account. | Entre com um código. Sem conta. |
| 5 | Fibonacci, standard ou T-shirt | Fibonacci, estándar o talla | Fibonacci, standard o taglie | Fibonacci, padrão ou camiseta |
| 6 | Gratuit. Sans pub. Open source. | Gratis. Sin anuncios. Código abierto. | Gratis. Senza pubblicità. Open source. | Grátis. Sem anúncios. Código aberto. |

| # | ja | ko | zh-Hans | ru |
|---|---|---|---|---|
| 1 | プランニングポーカーを、もっと快適に | 플래닝 포커, 제대로 | 更好用的计划扑克 | Planning poker как надо |
| 2 | 工数だけでなくリスクも見積もる | 공수뿐 아니라 리스크도 추정 | 不只估工作量，也估风险 | Оценивайте риск, а не только трудозатраты |
| 3 | 発生確率 × 影響度をひと目で | 발생 가능성 × 영향도를 한눈에 | 可能性 × 影响，一目了然 | Вероятность × влияние — сразу видно |
| 4 | コードで参加、アカウント不要 | 코드로 참여, 계정 불필요 | 输入代码即可加入，无需账号 | Вход по коду. Без аккаунта. |
| 5 | フィボナッチ・標準・Tシャツ | 피보나치, 표준, 티셔츠 | 斐波那契、标准或 T 恤尺码 | Фибоначчи, стандарт или футболки |
| 6 | 無料・広告なし・オープンソース | 무료 · 광고 없음 · 오픈 소스 | 免费 · 无广告 · 开源 | Бесплатно. Без рекламы. Open source. |

**Let op:** de woorden voor *Likelihood*/*Impact*/deck-namen moeten gelijk zijn aan wat de app in die taal toont —
bij het maken van de set tegen `Sources/Resources/Localizable.xcstrings` checken en de overlay aanpassen, niet
andersom. ja/ko/zh-Hans/ru: native check gewenst (zelfde kanttekening als `ASO-LOCALIZATIONS.md`).

## Ed doet dit
- [ ] Beheerde sessie plannen voor schermopnames (simulator-UI-tools werken niet in geplande runs) — Claude kan
      dan opnemen + ondertitelen + overlay-screenshots renderen.
- [ ] Clips posten (LinkedIn / YouTube Shorts); YouTube-kanaal is nog een account-actie van Ed.
- [ ] Mac App Store-status bevestigen vóór clip 7 met Mac-beeld.
