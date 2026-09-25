# Riskonacci — ASO-lokalisaties (DRAFT)

_Gegenereerd door `marketing/aso_locales.py` (limieten gevalideerd). Nog NIET in App Store Connect._

**Waarom:** de app spreekt 10 talen, maar de store-listing bestaat alleen in en-US + nl-NL. Elke extra store-locale = extra geïndexeerde keywords + een listing in de eigen taal → meer vindbaarheid in DE/FR/ES/IT/BR/JP/KR/CN/RU. en-GB en es-MX zijn extra: de US-store indexeert ook es-MX, en en-GB geeft UK/Commonwealth een eigen keywordset.

**Hoe live:** keywords/subtitle/nieuwe locales kunnen alleen op een **bewerkbare versie** (Prepare for Submission). Dus meenemen bij de volgende Riskonacci-release (bv. 1.0.1): per locale `appStoreVersionLocalizations` (keywords, promo, beschrijving) + `appInfoLocalizations` (naam, subtitle) aanmaken via de ASC-API (key 5R3497VHF5). Promotional text kan wél zonder nieuwe versie worden aangepast (alleen bestaande locales).

**Let op:** en-US-keywords herhaalden 'planning poker' en 'risk' (staan al in subtitle/naam) → nu vervangen door 'matrix,likelihood,impact,story,points'. Native check gewenst voor: ja, ko, ru, zh-Hans (machinaal vertaald, termen gecontroleerd op gangbaar agile-jargon).

| Locale | Subtitle (≤30) | Keywords (≤100) |
|---|---|---|
| en-US | Planning poker with risk (24) | `scrum,agile,estimation,story,points,fibonacci,sprint,matrix,likelihood,impact,pointing,retro,team` (97) |
| en-GB | Scrum poker & risk matrix (25) | `planning,estimate,agile,story,points,fibonacci,sprint,likelihood,impact,pointing,refinement,team` (96) |
| nl-NL | Planning poker met risico (25) | `scrum,agile,schatten,story,points,fibonacci,sprint,risicomatrix,kans,impact,refinement,team` (91) |
| de-DE | Planning Poker mit Risiko (25) | `scrum,agile,schätzen,story,points,fibonacci,sprint,risikomatrix,eintritt,auswirkung,team` (88) |
| fr-FR | Planning poker et risques (25) | `scrum,agile,estimation,story,points,fibonacci,sprint,matrice,probabilité,impact,équipe` (86) |
| es-ES | Planning poker con riesgo (25) | `scrum,agile,ágil,estimación,story,points,fibonacci,sprint,matriz,probabilidad,impacto` (85) |
| es-MX | Scrum poker y riesgos (21) | `planning,agile,ágil,estimación,puntos,historia,fibonacci,sprint,matriz,probabilidad,equipo` (90) |
| it | Planning poker con rischio (26) | `scrum,agile,stima,story,points,fibonacci,sprint,matrice,probabilità,impatto,team` (80) |
| pt-BR | Planning poker com risco (24) | `scrum,agile,ágil,estimativa,story,points,fibonacci,sprint,matriz,probabilidade,impacto` (86) |
| ru | Планинг покер и риски (21) | `scrum,agile,скрам,оценка,спринт,фибоначчи,story,points,матрица,вероятность,команда` (82) |
| ja | リスクも見積もるプランニングポーカー (18) | `スクラム,アジャイル,見積もり,ストーリーポイント,フィボナッチ,スプリント,リスク,マトリクス,チーム,scrum,agile` (64) |
| ko | 리스크까지 추정하는 플래닝 포커 (17) | `스크럼,애자일,추정,스토리포인트,피보나치,스프린트,리스크,매트릭스,팀,scrum,agile` (50) |
| zh-Hans | 带风险评估的计划扑克 (10) | `敏捷,估算,故事点,斐波那契,冲刺,风险矩阵,团队,scrum,agile,planning,poker` (52) |

## Promotional text (≤170)

- **en-US** (151): Estimate effort and risk in one session: Fibonacci, T-shirt sizes or a dedicated Risk deck with a Likelihood × Impact matrix. Free, no account, no ads.
- **en-GB** (156): Estimate effort and risk together. Planning poker with a built-in Risk deck and Likelihood × Impact matrix — live on iPhone, iPad and Mac. Free, no sign-up.
- **nl-NL** (151): Schat effort én risico in één sessie: Fibonacci, T-shirtmaten of een apart Risk-deck met Kans × Impact-matrix. Gratis, geen account, geen advertenties.
- **de-DE** (147): Aufwand und Risiko in einer Runde schätzen: Fibonacci, T-Shirt-Größen oder ein eigenes Risiko-Deck mit Matrix. Kostenlos, ohne Konto, ohne Werbung.
- **fr-FR** (152): Estimez effort et risque en une seule session : Fibonacci, tailles de T-shirt ou un deck Risque avec matrice Probabilité × Impact. Gratuit, sans compte.
- **es-ES** (150): Estima esfuerzo y riesgo en una sola sesión: Fibonacci, tallas de camiseta o un mazo de Riesgo con matriz Probabilidad × Impacto. Gratis y sin cuenta.
- **es-MX** (131): Estima esfuerzo y riesgo en una sola sesión, en tiempo real con tu equipo en iPhone, iPad y Mac. Gratis, sin cuenta y sin anuncios.
- **it** (148): Stima impegno e rischio in un'unica sessione: Fibonacci, taglie T-shirt o un mazzo Rischio con matrice Probabilità × Impatto. Gratis, senza account.
- **pt-BR** (149): Estime esforço e risco na mesma sessão: Fibonacci, tamanhos de camiseta ou um baralho de Risco com matriz Probabilidade × Impacto. Grátis, sem conta.
- **ru** (152): Оценивайте трудозатраты и риски за одну сессию: Фибоначчи, размеры футболок или колода рисков с матрицей вероятность × влияние. Бесплатно, без аккаунта.
- **ja** (74): 工数とリスクを1回のセッションで見積もり。フィボナッチ、Tシャツサイズ、発生確率×影響度マトリクス付きリスクデッキ。無料・アカウント不要・広告なし。
- **ko** (83): 작업량과 리스크를 한 세션에서 추정하세요. 피보나치, 티셔츠 사이즈, 발생가능성×영향도 매트릭스가 있는 리스크 덱. 무료, 계정 불필요, 광고 없음.
- **zh-Hans** (56): 在同一次会议中估算工作量和风险：斐波那契、T恤尺码，或带“可能性×影响”矩阵的风险牌组。免费、无需账号、无广告。

## Nog te doen
- [ ] Beschrijving vertalen per locale (volgende marketing-actie).
- [ ] Bij volgende release: locales aanmaken + velden vullen via de API; screenshots mogen de en-US-set hergebruiken (fallback).
- [ ] Na 2-4 weken: ranking/impressies per land checken in App Analytics en keywords bijstellen.
