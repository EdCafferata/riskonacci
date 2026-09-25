# Artikel #01 — "Schat ook risico" (DRAFT, NL + EN)

_Opgesteld 2026-09-25 door de marketing-routine. Niet gepubliceerd. Bedoeld als LinkedIn-artikel (Ed),
dev.to / Hashnode / Medium-crosspost (EN) en later evt. als blogpagina op `cafferata.info/riskonacci/`._
_Eerlijkheidsregels: geen verzonnen cijfers, klanten of quotes. De app wordt pas aan het eind genoemd;
het artikel moet ook zonder de app waardevol zijn (dat is wat communities accepteren)._

**Canonieke link:** https://apps.apple.com/app/riskonacci/id6807144804 · broncode: https://github.com/EdCafferata/riskonacci
**Lengte:** ~800 woorden (EN), ~750 (NL) — leesbaar in 4 min.
**Header-beeld (idee):** 5×5-matrixscreenshot uit de app (RiskMatrixRevealView) met de titel erover.

---

## EN — "Story points measure effort. Your sprint dies of risk."

Every refinement session I've been in has had the same moment. The team flips their cards, everyone
shows a 5, the facilitator says "great, 5 it is", and we move on. Two weeks later that 5 turned into
a 13, and in the retro somebody says: *"Yeah, I kind of expected that — we depended on the other
team's API."*

The estimate wasn't wrong. It answered the question we asked: **how much work is this?** We just
never asked the second question: **how likely is it that this goes sideways, and how bad would that be?**

### Effort and risk are different axes

Story points blend a lot of things — complexity, effort, uncertainty — into one number. That's by
design, and it's fine for capacity planning. But blending hides information. A "5 that's routine" and
a "5 that depends on a vendor nobody has talked to yet" get the same card, the same place in the
sprint, and the same amount of attention.

Risk has two parts that are worth separating:

- **Likelihood** — how probable is it that something blocks or derails this item?
- **Impact** — if it happens, how much does it hurt (the sprint goal, a release, a customer)?

This is the classic likelihood × impact matrix that project managers have used for decades. Agile
teams mostly left it behind with the big-upfront-risk-register, which is a pity, because the
*conversation* it forces is exactly what refinement is for.

### A 60-second risk round

You don't need a risk register or a separate meeting. Add one quick round to the items that matter:

1. **Estimate effort as usual.** Planning poker, Fibonacci, T-shirts — whatever you use.
2. **Second round: likelihood (1–5).** Everyone votes silently, reveal together. Same rule as
   planning poker: no anchoring, the quiet person's vote counts as much as the architect's.
3. **Third round: impact (1–5).** Same thing.
4. **Look at the spread, not just the average.** If one developer votes likelihood 5 while the rest
   vote 1, that's the most valuable minute of your refinement. Ask them why.
5. **Decide what to do with high-risk items:** spike first, split off the risky part, schedule it
   early in the sprint, or make the dependency explicit on the board.

Only do this for items where it's worth it — anything bigger than a few points, anything with
external dependencies, anything new to the team. Doing it for every typo fix is ceremony.

### What changes when you do this

- **Hidden knowledge surfaces.** The person who knows the legacy code is fragile finally says so,
  because the format asks them to.
- **Risky work moves earlier.** Items with high likelihood × impact get picked up at the start of the
  sprint, when there's still time to react.
- **Retro conversations get shorter.** "We saw this coming" becomes "we saw this coming and planned
  for it."
- **Stakeholders get a better answer than "it's a 5".** "It's a 5, with a real chance of slipping
  because of X" is more honest and easier to plan around.

### Keep it lightweight

The failure mode is turning this into a heavy process. Some guardrails:

- Use a 1–5 scale; nobody can meaningfully tell a likelihood of 7 from 8.
- Don't multiply numbers into a pseudo-precise score and rank by it. Use the matrix as a picture:
  top-right = talk about it now.
- Timebox it. If the risk discussion takes longer than the estimate, it's probably a spike.

### A tool, if you want one

You can do all of this with sticky notes or two fingers in the air. I built a small free app for it
because I wanted it in the same flow as planning poker: **Riskonacci** has the usual Fibonacci /
T-shirt decks plus a separate risk deck, and an optional likelihood × impact mode that shows
everyone's votes as dots on a 5×5 matrix. It runs on iPhone, iPad and Mac, works in real time with
a short room code, needs no account, and it's open source.

But the tool is the least important part. Try the extra round in your next refinement — manually —
and see which item surprises you.

*How does your team make risk visible today?*

---

## NL — "Story points meten werk. Je sprint sneuvelt op risico."

Elke refinement kent hetzelfde moment. Het team draait de kaarten om, iedereen heeft een 5, de
facilitator zegt "mooi, 5 dan" en we gaan door. Twee weken later is die 5 een 13 geworden, en in de
retro zegt iemand: *"Ja, dat zag ik eigenlijk wel aankomen — we waren afhankelijk van die API van
het andere team."*

De schatting was niet fout. Hij beantwoordde de vraag die we stelden: **hoeveel werk is dit?** We
stelden alleen nooit de tweede vraag: **hoe groot is de kans dat dit misgaat, en hoe erg is dat dan?**

### Werk en risico zijn twee verschillende assen

Story points vatten complexiteit, werk en onzekerheid samen in één getal. Dat is bewust, en prima
voor capaciteitsplanning. Maar samenvatten verbergt informatie. Een "5 die routine is" en een "5 die
afhangt van een leverancier die nog niemand gesproken heeft" krijgen dezelfde kaart en dezelfde
aandacht.

Risico heeft twee delen die je los wilt zien:

- **Kans** — hoe waarschijnlijk is het dat iets dit item blokkeert of laat ontsporen?
- **Impact** — als het gebeurt, hoeveel pijn doet het (sprintdoel, release, klant)?

Dat is de klassieke kans × impact-matrix uit het projectmanagement. Agile teams hebben die grotendeels
achtergelaten samen met het dikke risicoregister — jammer, want het *gesprek* dat hij afdwingt is
precies waar refinement voor is.

### Een risicoronde van 60 seconden

1. **Schat het werk zoals altijd.** Planning poker, Fibonacci, T-shirtmaten.
2. **Tweede ronde: kans (1–5).** Iedereen stemt tegelijk, samen omdraaien. Geen anchoring; de stille
   collega telt net zo zwaar als de architect.
3. **Derde ronde: impact (1–5).** Idem.
4. **Kijk naar de spreiding, niet alleen naar het gemiddelde.** Stemt één developer kans 5 en de rest
   1? Dan is dít de waardevolste minuut van je refinement. Vraag waarom.
5. **Beslis wat je met hoog risico doet:** eerst een spike, het risicovolle deel afsplitsen, vroeg in
   de sprint oppakken, of de afhankelijkheid zichtbaar maken op het bord.

Doe dit alleen waar het loont: grotere items, externe afhankelijkheden, nieuw terrein. Voor elke
typfout is het ceremonie.

### Wat het oplevert

- **Verborgen kennis komt boven.** Wie weet dat de legacy-code breekbaar is, zegt het nu wél.
- **Risicovol werk schuift naar voren** in de sprint, als er nog tijd is om bij te sturen.
- **Kortere retro's.** "Zagen we aankomen" wordt "zagen we aankomen, en hadden we ingepland".
- **Eerlijker antwoord aan stakeholders** dan "het is een 5".

### Houd het licht

- Schaal 1–5; niemand ziet het verschil tussen kans 7 en 8.
- Vermenigvuldig niet tot een schijnprecieze score. Gebruik de matrix als plaatje: rechtsboven = nu
  bespreken.
- Timebox het. Duurt de risicodiscussie langer dan de schatting? Dan is het waarschijnlijk een spike.

### Een tool, als je die wilt

Dit kan prima met post-its of twee vingers in de lucht. Ik heb er een kleine, gratis app voor gebouwd
omdat ik het in dezelfde flow als planning poker wilde: **Riskonacci** heeft naast Fibonacci en
T-shirtmaten een apart risk-deck en een optionele kans × impact-modus die ieders stem als bolletje op
een 5×5-matrix toont. Werkt op iPhone, iPad en Mac, realtime met een korte roomcode, zonder account,
en open source.

Maar de tool is het minst belangrijke deel. Probeer de extra ronde in je volgende refinement —
gewoon handmatig — en kijk welk item je verrast.

*Hoe maakt jouw team risico zichtbaar?*

---

## Distributie (door Ed)
- [ ] LinkedIn-artikel (NL of EN) vanaf Eds profiel; korte teaser-post erbij (hergebruik post #1 uit `linkedin-batch-01.md`).
- [ ] EN crosspost op dev.to (tags: `agile`, `scrum`, `productivity`, `career`) en/of Hashnode — canonical URL naar het eerste exemplaar.
- [ ] Reddit r/scrum / r/agile: **alleen** de methode delen als tekstpost (zonder app-alinea), link hooguit in een reactie als ernaar gevraagd wordt — die subs zijn allergisch voor self-promo.
- [ ] Na publicatie: link toevoegen aan `MARKETING-LOG.md`.
