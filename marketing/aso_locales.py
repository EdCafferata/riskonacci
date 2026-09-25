#!/usr/bin/env python3
"""ASO-drafts per store-locale voor Riskonacci.

Draai: python3 marketing/aso_locales.py  -> valideert Apple-limieten en schrijft
marketing/ASO-LOCALIZATIONS.md. Regels: subtitle <= 30, keywords <= 100 tekens
(komma's, geen spaties), promo <= 170. Woorden uit naam/subtitle NIET herhalen in
keywords (Apple indexeert die al) — dat verspilt ruimte.
"""
import pathlib

L = {
 "en-US": dict(
  subtitle="Planning poker with risk",
  keywords="scrum,agile,estimation,story,points,fibonacci,sprint,matrix,likelihood,impact,pointing,retro,team",
  promo="Estimate effort and risk in one session: Fibonacci, T-shirt sizes or a dedicated Risk deck with a Likelihood × Impact matrix. Free, no account, no ads."),
 "en-GB": dict(
  subtitle="Scrum poker & risk matrix",
  keywords="planning,estimate,agile,story,points,fibonacci,sprint,likelihood,impact,pointing,refinement,team",
  promo="Estimate effort and risk together. Planning poker with a built-in Risk deck and Likelihood × Impact matrix — live on iPhone, iPad and Mac. Free, no sign-up."),
 "nl-NL": dict(
  subtitle="Planning poker met risico",
  keywords="scrum,agile,schatten,story,points,fibonacci,sprint,risicomatrix,kans,impact,refinement,team",
  promo="Schat effort én risico in één sessie: Fibonacci, T-shirtmaten of een apart Risk-deck met Kans × Impact-matrix. Gratis, geen account, geen advertenties."),
 "de-DE": dict(
  subtitle="Planning Poker mit Risiko",
  keywords="scrum,agile,schätzen,story,points,fibonacci,sprint,risikomatrix,eintritt,auswirkung,team",
  promo="Aufwand und Risiko in einer Runde schätzen: Fibonacci, T-Shirt-Größen oder ein eigenes Risiko-Deck mit Matrix. Kostenlos, ohne Konto, ohne Werbung."),
 "fr-FR": dict(
  subtitle="Planning poker et risques",
  keywords="scrum,agile,estimation,story,points,fibonacci,sprint,matrice,probabilité,impact,équipe",
  promo="Estimez effort et risque en une seule session : Fibonacci, tailles de T-shirt ou un deck Risque avec matrice Probabilité × Impact. Gratuit, sans compte."),
 "es-ES": dict(
  subtitle="Planning poker con riesgo",
  keywords="scrum,agile,ágil,estimación,story,points,fibonacci,sprint,matriz,probabilidad,impacto",
  promo="Estima esfuerzo y riesgo en una sola sesión: Fibonacci, tallas de camiseta o un mazo de Riesgo con matriz Probabilidad × Impacto. Gratis y sin cuenta."),
 "es-MX": dict(
  subtitle="Scrum poker y riesgos",
  keywords="planning,agile,ágil,estimación,puntos,historia,fibonacci,sprint,matriz,probabilidad,equipo",
  promo="Estima esfuerzo y riesgo en una sola sesión, en tiempo real con tu equipo en iPhone, iPad y Mac. Gratis, sin cuenta y sin anuncios."),
 "it": dict(
  subtitle="Planning poker con rischio",
  keywords="scrum,agile,stima,story,points,fibonacci,sprint,matrice,probabilità,impatto,team",
  promo="Stima impegno e rischio in un'unica sessione: Fibonacci, taglie T-shirt o un mazzo Rischio con matrice Probabilità × Impatto. Gratis, senza account."),
 "pt-BR": dict(
  subtitle="Planning poker com risco",
  keywords="scrum,agile,ágil,estimativa,story,points,fibonacci,sprint,matriz,probabilidade,impacto",
  promo="Estime esforço e risco na mesma sessão: Fibonacci, tamanhos de camiseta ou um baralho de Risco com matriz Probabilidade × Impacto. Grátis, sem conta."),
 "ru": dict(
  subtitle="Планинг покер и риски",
  keywords="scrum,agile,скрам,оценка,спринт,фибоначчи,story,points,матрица,вероятность,команда",
  promo="Оценивайте трудозатраты и риски за одну сессию: Фибоначчи, размеры футболок или колода рисков с матрицей вероятность × влияние. Бесплатно, без аккаунта."),
 "ja": dict(
  subtitle="リスクも見積もるプランニングポーカー",
  keywords="スクラム,アジャイル,見積もり,ストーリーポイント,フィボナッチ,スプリント,リスク,マトリクス,チーム,scrum,agile",
  promo="工数とリスクを1回のセッションで見積もり。フィボナッチ、Tシャツサイズ、発生確率×影響度マトリクス付きリスクデッキ。無料・アカウント不要・広告なし。"),
 "ko": dict(
  subtitle="리스크까지 추정하는 플래닝 포커",
  keywords="스크럼,애자일,추정,스토리포인트,피보나치,스프린트,리스크,매트릭스,팀,scrum,agile",
  promo="작업량과 리스크를 한 세션에서 추정하세요. 피보나치, 티셔츠 사이즈, 발생가능성×영향도 매트릭스가 있는 리스크 덱. 무료, 계정 불필요, 광고 없음."),
 "zh-Hans": dict(
  subtitle="带风险评估的计划扑克",
  keywords="敏捷,估算,故事点,斐波那契,冲刺,风险矩阵,团队,scrum,agile,planning,poker",
  promo="在同一次会议中估算工作量和风险：斐波那契、T恤尺码，或带“可能性×影响”矩阵的风险牌组。免费、无需账号、无广告。"),
}

NATIVE_CHECK = {"ru", "ja", "ko", "zh-Hans"}

def check():
    errs = []
    for loc, d in L.items():
        if len(d["subtitle"]) > 30: errs.append(f"{loc} subtitle {len(d['subtitle'])}>30")
        if len(d["keywords"]) > 100: errs.append(f"{loc} keywords {len(d['keywords'])}>100")
        if " ," in d["keywords"] or ", " in d["keywords"]: errs.append(f"{loc} keywords bevat spatie rond komma")
        if len(d["promo"]) > 170: errs.append(f"{loc} promo {len(d['promo'])}>170")
        kws = [k.lower() for k in d["keywords"].split(",")]
        if len(kws) != len(set(kws)): errs.append(f"{loc} dubbele keywords")
    return errs

def render():
    out = ["# Riskonacci — ASO-lokalisaties (DRAFT)", "",
           "_Gegenereerd door `marketing/aso_locales.py` (limieten gevalideerd). Nog NIET in App Store Connect._", "",
           "**Waarom:** de app spreekt 10 talen, maar de store-listing bestaat alleen in en-US + nl-NL. "
           "Elke extra store-locale = extra geïndexeerde keywords + een listing in de eigen taal → meer vindbaarheid in DE/FR/ES/IT/BR/JP/KR/CN/RU. "
           "en-GB en es-MX zijn extra: de US-store indexeert ook es-MX, en en-GB geeft UK/Commonwealth een eigen keywordset.", "",
           "**Hoe live:** keywords/subtitle/nieuwe locales kunnen alleen op een **bewerkbare versie** (Prepare for Submission). "
           "Dus meenemen bij de volgende Riskonacci-release (bv. 1.0.1): per locale `appStoreVersionLocalizations` (keywords, promo, beschrijving) + "
           "`appInfoLocalizations` (naam, subtitle) aanmaken via de ASC-API (key 5R3497VHF5). Promotional text kan wél zonder nieuwe versie worden aangepast (alleen bestaande locales).", "",
           "**Let op:** en-US-keywords herhaalden 'planning poker' en 'risk' (staan al in subtitle/naam) → nu vervangen door 'matrix,likelihood,impact,story,points'. "
           f"Native check gewenst voor: {', '.join(sorted(NATIVE_CHECK))} (machinaal vertaald, termen gecontroleerd op gangbaar agile-jargon).", "",
           "| Locale | Subtitle (≤30) | Keywords (≤100) |", "|---|---|---|"]
    for loc, d in L.items():
        out.append(f"| {loc} | {d['subtitle']} ({len(d['subtitle'])}) | `{d['keywords']}` ({len(d['keywords'])}) |")
    out += ["", "## Promotional text (≤170)", ""]
    for loc, d in L.items():
        out.append(f"- **{loc}** ({len(d['promo'])}): {d['promo']}")
    out += ["", "## Nog te doen", "- [ ] Beschrijving vertalen per locale (volgende marketing-actie).",
            "- [ ] Bij volgende release: locales aanmaken + velden vullen via de API; screenshots mogen de en-US-set hergebruiken (fallback).",
            "- [ ] Na 2-4 weken: ranking/impressies per land checken in App Analytics en keywords bijstellen.", ""]
    return "\n".join(out)

if __name__ == "__main__":
    e = check()
    if e:
        raise SystemExit("\n".join(e))
    p = pathlib.Path(__file__).with_name("ASO-LOCALIZATIONS.md")
    p.write_text(render(), encoding="utf-8")
    print("OK", len(L), "locales ->", p)
