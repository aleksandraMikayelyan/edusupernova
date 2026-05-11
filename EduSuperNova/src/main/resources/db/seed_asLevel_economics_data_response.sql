-- ============================================================
-- AS Level Economics (9708) — Paper 2: Data Response Questions
-- Each question_group contains the full stimulus text/data that
-- students read before answering. Questions are linked to groups.
-- Run once in the Supabase SQL editor.
-- ============================================================

DO $$
DECLARE
    v_econ_id INTEGER;
    v_dr_p    INTEGER;
    g1 INTEGER; g2 INTEGER; g3 INTEGER; g4 INTEGER;
BEGIN

    SELECT idcourse INTO v_econ_id
    FROM courses WHERE lower(coursename) LIKE '%as level econ%' LIMIT 1;

    IF v_econ_id IS NULL THEN
        RAISE EXCEPTION 'AS Level Economics course not found.';
    END IF;

    SELECT idpaper INTO v_dr_p
    FROM papers WHERE idcourse = v_econ_id
    AND (lower(papername) LIKE '%data%' OR lower(papername) LIKE '%essay%' OR lower(papername) LIKE '%paper 2%')
    LIMIT 1;

    IF v_dr_p IS NULL THEN
        SELECT idpaper INTO v_dr_p FROM papers WHERE idcourse = v_econ_id LIMIT 1;
    END IF;

    -- ══════════════════════════════════════════════════════════
    -- DATA RESPONSE 1: The Global Coffee Market
    -- ══════════════════════════════════════════════════════════
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_dr_p, 'Data Response 1 — The Global Coffee Market',
'Read the following information carefully before answering the questions.

TEXT A: The Coffee Market in 2023

Global coffee consumption reached a record 177 million 60-kg bags in 2023, driven by rising demand from Asia, particularly China and Vietnam. At the same time, supply was disrupted by severe frosts in Brazil — the world''s largest producer, accounting for around 40% of global output — and by prolonged drought in Vietnam, the second-largest producer.

As a result, the price of Arabica coffee beans on the New York commodity exchange rose from $1.40 per pound in January 2022 to $2.45 per pound by December 2023.

TABLE 1: Selected Indicators for the Global Coffee Market

Year | World Production (million bags) | World Consumption (million bags) | Average Price ($/lb)
2019 | 175.0                           | 169.5                            | 1.22
2020 | 169.3                           | 167.8                            | 1.26
2021 | 172.1                           | 170.4                            | 2.05
2022 | 168.5                           | 174.3                            | 1.85
2023 | 163.0 (est.)                    | 177.0 (est.)                     | 2.45

TEXT B: The Impact on Coffee Retailers

Major coffee chains have responded to higher wholesale coffee prices in different ways. Some premium brands have passed the full cost increase on to consumers, arguing that their loyal customer base has inelastic demand for their product. Others have absorbed part of the cost increase by accepting lower profit margins, while a third group has reduced portion sizes or changed blends — a practice sometimes called "shrinkflation."

A senior economist at one chain commented: "Our research shows that a 10% rise in our coffee prices leads to approximately a 6% fall in cups sold. We are weighing up whether to raise prices or protect volume."',
    1) RETURNING id INTO g1;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES

    (v_econ_id, v_dr_p, NULL,
     '(a) Using the data in Table 1, identify TWO years in which the coffee market was in excess demand (shortage). [2]',
     NULL, NULL, NULL, NULL,
     '2022 and 2023 (est.). In both years, world consumption exceeds world production: 2022 (174.3m bags consumed vs 168.5m produced); 2023 (177.0m vs 163.0m). A shortage exists when Qd > Qs at the prevailing price.',
     'Award 1 mark per correct year identified with reference to the data (consumption > production). Accept any two years from 2022 and 2023.',
     'SHORT_ANSWER', 'EASY', g1, 1),

    (v_econ_id, v_dr_p, NULL,
     '(b) Using the data in Text B, calculate the price elasticity of demand (PED) for the coffee chain''s product. Show your working. [3]',
     NULL, NULL, NULL, NULL,
     'PED = % change in Qd / % change in P = -6% / +10% = -0.6. The negative sign indicates the inverse relationship between price and demand. Since |PED| = 0.6 < 1, demand is price inelastic.',
     'Award 1 mark for correct formula, 1 mark for correct calculation (-6/10 = -0.6), 1 mark for correct interpretation (inelastic, since |PED| < 1). Full credit requires working shown.',
     'SHORT_ANSWER', 'MEDIUM', g1, 2),

    (v_econ_id, v_dr_p, NULL,
     '(c) Using a supply and demand diagram, explain why the price of Arabica coffee beans rose between 2022 and 2023. [4]',
     NULL, NULL, NULL, NULL,
     'A correctly drawn diagram should show: (1) An initial equilibrium with supply S1 and demand D1. (2) A leftward shift of supply to S2 due to crop failures in Brazil and Vietnam, reflecting reduced output from the world''s largest producers. (3) A rightward shift of demand to D2 reflecting rising consumption in Asia. (4) A new equilibrium at a higher price P2 and potentially changed quantity Q2. Written explanation: reduced supply due to Brazilian frosts and Vietnamese drought, combined with increased demand from Asia, created excess demand at the original price, pushing prices upward to a new equilibrium.',
     'Award 2 marks for a correctly labelled diagram (axes labelled, both shifts correctly shown, new equilibrium identified). Award 2 marks for written explanation identifying both the supply reduction and demand increase with reference to the text.',
     'ESSAY', 'MEDIUM', g1, 3),

    (v_econ_id, v_dr_p, NULL,
     '(d) Evaluate the strategies available to coffee retailers facing rising wholesale coffee costs. Refer to the evidence in the texts. [8]',
     NULL, NULL, NULL, NULL,
     'The question requires evaluation of three strategies identified in Text B: (1) Pass costs to consumers (price increase): Suitable if demand is inelastic — the text''s PED of -0.6 supports this, as a 10% price rise only reduces volume by 6%. TR rises. Risk: competitor chains may not raise prices, causing market share loss. (2) Absorb costs (lower margins): Protects volume and customer loyalty but reduces profit. Unsustainable long-term if costs remain high. Only viable for financially strong firms. (3) Shrinkflation: Maintains headline price but reduces quantity per unit. Avoids sticker price shock but risks brand damage if consumers notice. Ethical questions. EVALUATION should consider: which strategy best fits the firm''s circumstances (premium vs. budget brand, loyalty of customer base, competitive environment). A nuanced answer will argue that there is no single correct response — it depends on PED, competitive pressures, brand positioning, and how long high costs persist.',
     'Band 1 (7–8): Three strategies explained and evaluated with reference to data and economic theory. Clear conclusion that is justified. Band 2 (5–6): Two or more strategies explained; some evaluation present. Band 3 (3–4): One or two strategies described with limited evaluation. Band 4 (1–2): Descriptive only.',
     'ESSAY', 'HARD', g1, 4);

    -- ══════════════════════════════════════════════════════════
    -- DATA RESPONSE 2: Housing Market and Government Intervention
    -- ══════════════════════════════════════════════════════════
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_dr_p, 'Data Response 2 — The UK Housing Market',
'Read the following information carefully before answering the questions.

TEXT A: UK House Prices and Housing Supply

Average UK house prices rose by 86% between 2010 and 2023, reaching a national average of £285,000. In London, the average exceeded £530,000. Over the same period, the number of new homes completed annually remained significantly below the government''s stated target of 300,000 new homes per year, averaging only 185,000 completions.

Economists identify several reasons for restricted housing supply: planning regulations that limit building on greenfield sites, the high cost of land, shortage of skilled construction workers, and lengthy approval processes. Meanwhile, population growth, rising incomes, and historically low interest rates (until 2022) sustained demand.

TABLE 2: UK Housing Market Indicators

Year | Average House Price (£000s) | New Homes Completed (000s) | Bank of England Base Rate (%)
2010 | 166                         | 140                        | 0.5
2015 | 212                         | 171                        | 0.5
2019 | 248                         | 183                        | 0.75
2021 | 270                         | 177                        | 0.1
2023 | 285                         | 188                        | 5.25

TEXT B: Government Policy Responses

The government has attempted several interventions to improve housing affordability:

Help to Buy (2013–2023): An equity loan scheme allowing first-time buyers to purchase new-build homes with a 5% deposit, with the government providing a 20% equity loan. Critics argued this inflated demand without increasing supply, pushing prices higher.

Stamp Duty Holiday (2020–2021): Temporary suspension of stamp duty on properties below £500,000. Housing transactions surged by 40% in this period, with house prices rising by 10% in a single year.

Planning Reform: Proposed changes to simplify planning rules and unlock more land for development.',
    2) RETURNING id INTO g2;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES

    (v_econ_id, v_dr_p, NULL,
     '(a) Using Table 2, describe TWO trends in the UK housing market between 2010 and 2023. [4]',
     NULL, NULL, NULL, NULL,
     'Any two of the following with data support: (1) House prices rose consistently — from £166,000 in 2010 to £285,000 in 2023, an increase of approximately 72%. (2) New home completions remained below the government target of 300,000, fluctuating narrowly between 140,000 and 188,000. (3) The Bank of England base rate was held near-zero from 2010–2021 before rising sharply to 5.25% by 2023, which may moderate future demand. (4) The gap between completions and target remained persistently large, suggesting supply constraints have not been resolved.',
     'Award 2 marks per trend (1 for identifying the trend, 1 for using data as evidence). Maximum 4 marks for two trends.',
     'SHORT_ANSWER', 'EASY', g2, 1),

    (v_econ_id, v_dr_p, NULL,
     '(b) Explain why the "Help to Buy" scheme may have increased house prices rather than improved affordability. Use supply and demand analysis. [4]',
     NULL, NULL, NULL, NULL,
     'Help to Buy gave buyers access to larger deposits, increasing their purchasing power. This increased demand for new-build properties (rightward shift of the demand curve). However, housing supply remained inelastic in the short run — planning constraints, land availability, and construction capacity meant that supply could not respond quickly. With an inelastic supply curve, an increase in demand leads primarily to a price rise rather than a large increase in quantity. Critics therefore argued the scheme inflated demand without addressing the underlying supply shortage, resulting in higher prices rather than improved affordability.',
     'Award 2 marks for correct diagram (demand shift right, inelastic supply, higher price). Award 2 marks for written explanation linking scheme to demand increase and inelastic supply to higher price outcome.',
     'SHORT_ANSWER', 'MEDIUM', g2, 2),

    (v_econ_id, v_dr_p, NULL,
     '(c) Assess whether planning reform is a more effective solution to the housing affordability problem than demand-side subsidies such as Help to Buy. [8]',
     NULL, NULL, NULL, NULL,
     'The question requires comparison of supply-side (planning reform) vs demand-side (Help to Buy) approaches. FOR PLANNING REFORM: Addresses root cause — restricted supply. If successful, increases the quantity of housing, reducing prices sustainably. Benefits all buyers, not just those using specific schemes. Reduces market failure from planning regulations distorting the supply side. AGAINST / LIMITATIONS: Long lead times — planning reform takes years to feed through into completed homes. Political resistance — local communities often oppose new development. Does not help buyers immediately struggling to afford deposits. FOR HELP TO BUY: Immediate impact — helps specific buyers access the market now. Supports construction industry demand. AGAINST: As the text notes, it inflates demand without increasing supply, potentially worsening affordability. Mainly benefits developers, not existing homeowners or renters. Regressive — primarily helps those with some savings already. EVALUATION: Most economists agree that the fundamental problem is supply-side constraint. Demand-side subsidies can provide short-term relief but are likely to be self-defeating in a market with inelastic supply. Planning reform — though slow and politically difficult — is more likely to achieve lasting affordability. A nuanced answer should acknowledge both short-term and long-term perspectives.',
     'Band 1 (7–8): Both approaches analysed and compared with reference to data and economic theory. Clear, justified conclusion. Band 2 (5–6): Both approaches discussed with some evaluation. Band 3 (3–4): One approach mainly discussed; limited evaluation. Band 4 (1–2): Descriptive only.',
     'ESSAY', 'HARD', g2, 3);

    -- ══════════════════════════════════════════════════════════
    -- DATA RESPONSE 3: Labour Market and Minimum Wage
    -- ══════════════════════════════════════════════════════════
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_dr_p, 'Data Response 3 — The National Minimum Wage',
'Read the following information carefully before answering the questions.

TEXT A: The UK National Living Wage

The UK''s National Living Wage (NLW) — the statutory minimum wage for workers aged 23 and over — was introduced in April 2016 at £7.20 per hour and increased to £11.44 per hour by April 2024, a rise of 59% over eight years.

Proponents argue the policy has improved the living standards of low-paid workers, reduced in-work poverty, and narrowed wage inequality. Critics — particularly business groups — warned that higher labour costs would lead to job losses, price increases, and reduced hours. Economists at the Centre for Economic Performance found that employment in low-wage sectors had not fallen significantly following past increases, suggesting that labour demand in these sectors may be less elastic than classical theory predicts.

TABLE 3: UK Labour Market Indicators

Year | NLW (£/hr) | Employment Rate (%) | Average Earnings Growth (%) | CPI Inflation (%)
2016 | 7.20       | 74.5                | 2.2                         | 0.7
2018 | 7.83       | 75.6                | 3.1                         | 2.4
2020 | 8.72       | 75.0                | 1.1                         | 0.9
2022 | 9.50       | 75.5                | 4.7                         | 9.1
2024 | 11.44      | 74.8                | 6.0                         | 3.2

TEXT B: A Small Business Owner''s Perspective

"Every time they raise the minimum wage, I have to make hard choices. I''ve reduced my staff hours, taken on fewer seasonal workers, and started looking at self-service technology to replace some roles. My margins are already razor thin, and I can''t just raise prices because customers will go elsewhere. The people this policy is supposed to help are the ones I''m having to cut first."',
    3) RETURNING id INTO g3;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES

    (v_econ_id, v_dr_p, NULL,
     '(a) Using Table 3, calculate the real wage growth for workers on the National Living Wage between 2022 and 2024. Show your working. [3]',
     NULL, NULL, NULL, NULL,
     'Nominal NLW growth (2022 to 2024): (11.44 - 9.50) / 9.50 × 100 = 20.4%. CPI inflation 2022 = 9.1%, CPI inflation 2024 = 3.2% (use average or 2024 figure depending on instruction — if using 2024 CPI of 3.2%): Real wage growth ≈ 20.4% - 3.2% = 17.2% over the period. Alternatively, accept calculation using the average inflation for the period. The key is that real wages rose substantially — nominal increases outpaced inflation by 2024.',
     'Award 1 mark for correct nominal wage change calculation, 1 mark for subtracting inflation figure, 1 mark for correct result with working shown. Accept a range of valid approaches.',
     'SHORT_ANSWER', 'MEDIUM', g3, 1),

    (v_econ_id, v_dr_p, NULL,
     '(b) Using a labour market diagram, explain the expected effect of a minimum wage set above the equilibrium wage. [4]',
     NULL, NULL, NULL, NULL,
     'Diagram should show: (1) Downward-sloping labour demand curve (Ld) and upward-sloping labour supply curve (Ls). (2) Original equilibrium at wage W* and employment level E*. (3) Minimum wage line drawn ABOVE W* (the effective/binding condition). (4) At the minimum wage Wm: quantity of labour supplied (Qs) > quantity of labour demanded (Qd), creating a labour surplus = unemployment of (Qs - Qd). Written explanation: at Wm, firms reduce labour demand (some jobs lost or hours cut) while more workers wish to work (supply rises). The gap (Qs - Qd) represents the potential unemployment created by the minimum wage.',
     'Award 2 marks for correct diagram (minimum wage above equilibrium, surplus/unemployment clearly shown). Award 2 marks for written explanation identifying reduced demand, increased supply, and resulting unemployment.',
     'SHORT_ANSWER', 'MEDIUM', g3, 2),

    (v_econ_id, v_dr_p, NULL,
     '(c) To what extent does the evidence in the texts support or contradict the classical theory that minimum wages cause unemployment? [8]',
     NULL, NULL, NULL, NULL,
     'Classical theory predicts: a minimum wage above equilibrium reduces quantity of labour demanded, creating unemployment (as shown in the diagram above). EVIDENCE SUPPORTING THE THEORY: Text B describes a small business owner cutting staff hours, taking on fewer seasonal workers, and investing in self-service technology to replace labour — exactly the substitution away from labour that classical theory predicts. EVIDENCE CONTRADICTING THE THEORY: Text A states that economists found employment in low-wage sectors did not fall significantly following past NLW increases. Table 3 shows that overall employment rates remained broadly stable (74.5% to 74.8%) across the period despite large nominal wage increases. POSSIBLE REASONS WHY UNEMPLOYMENT DID NOT RISE: (1) Monopsony power — if employers previously had wage-setting power, the minimum wage may correct market failure without creating unemployment. (2) Increased worker productivity from higher morale and lower turnover. (3) Demand effect — higher wages increase purchasing power, raising aggregate demand and product market demand for labour. (4) Anecdotal evidence from one business owner (Text B) may not reflect the national picture. EVALUATION: The evidence is mixed. Classical theory applies most strongly to competitive labour markets with elastic labour demand. In markets with monopsony power or where demand is inelastic, minimum wages may raise wages without significant employment effects. The truth depends on the specific sector, size of the wage increase, and macroeconomic conditions.',
     'Band 1 (7–8): Both sides of the argument analysed with reference to data and theory. Classical prediction explained. Evidence from both texts used critically. Clear, nuanced conclusion. Band 2 (5–6): Both sides identified with some use of evidence. Band 3 (3–4): One perspective mainly discussed. Band 4 (1–2): Descriptive only.',
     'ESSAY', 'HARD', g3, 3);

    -- ══════════════════════════════════════════════════════════
    -- DATA RESPONSE 4: International Trade — Comparative Advantage
    -- ══════════════════════════════════════════════════════════
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_dr_p, 'Data Response 4 — Trade, Specialisation and Protectionism',
'Read the following information carefully before answering the questions.

TEXT A: Comparative Advantage between Country A and Country B

The table below shows the output per worker per day in two countries if they devote all resources to producing either wheat or cloth.

TABLE 4: Output per Worker per Day

Country   | Wheat (tonnes) | Cloth (metres)
Country A | 8              | 4
Country B | 6              | 6

Before trade, each country divides its workers equally between the two goods.
Country A has 100 workers; Country B has 100 workers.

TEXT B: The Steel Tariff Debate

In 2018, the United States imposed a 25% tariff on imported steel, citing national security and the need to protect domestic steelworkers'' jobs. The EU, China, and Canada retaliated with tariffs on US goods. By 2020, studies estimated that the US tariff had saved approximately 1,800 steelworker jobs but cost around 75,000 jobs in downstream steel-using industries (e.g. car manufacturing, construction) due to higher input costs.

TABLE 5: Impact of US Steel Tariff (estimated)

Indicator                                          | Change
Domestic steel production (tonnes)                 | +3%
Domestic steel price                               | +25%
Employment in steel industry                       | +1,800 jobs
Employment in steel-using industries               | -75,000 jobs
Annual cost to US consumers (higher prices)        | $900 million
Annual government tariff revenue                   | $600 million',
    4) RETURNING id INTO g4;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES

    (v_econ_id, v_dr_p, NULL,
     '(a) Using Table 4, identify which country has a comparative advantage in producing wheat and which has a comparative advantage in producing cloth. Show your calculations of opportunity cost. [4]',
     NULL, NULL, NULL, NULL,
     'Country A: Opportunity cost of 1 tonne wheat = 4/8 = 0.5 metres cloth. Opportunity cost of 1 metre cloth = 8/4 = 2 tonnes wheat. Country B: Opportunity cost of 1 tonne wheat = 6/6 = 1 metre cloth. Opportunity cost of 1 metre cloth = 6/6 = 1 tonne wheat. CONCLUSION: Country A has a comparative advantage in wheat (lower OC: 0.5 cloth vs 1 cloth). Country B has a comparative advantage in cloth (lower OC: 1 wheat vs 2 wheat). Country A should specialise in wheat; Country B should specialise in cloth.',
     'Award 1 mark per correct opportunity cost calculation (x4), 1 mark per correct comparative advantage conclusion (x2). Maximum 4 marks — award for correct conclusion with working even if method is slightly unconventional.',
     'SHORT_ANSWER', 'HARD', g4, 1),

    (v_econ_id, v_dr_p, NULL,
     '(b) Explain one benefit and one cost of the US steel tariff, using evidence from Table 5. [4]',
     NULL, NULL, NULL, NULL,
     'BENEFIT: Protected domestic steel production and employment. Table 5 shows domestic steel production rose 3% and 1,800 steelworker jobs were saved. This supports the national security and employment protection arguments for the tariff. COST: Higher prices for domestic consumers and downstream industry job losses. The tariff raised the domestic steel price by 25%, costing consumers $900 million annually and leading to approximately 75,000 job losses in steel-using industries — a net loss to the overall economy. The tariff generated only $600 million in government revenue, insufficient to offset consumer losses.',
     'Award 2 marks per point (1 mark for identifying the benefit/cost, 1 mark for using data as evidence). Maximum 4 marks.',
     'SHORT_ANSWER', 'MEDIUM', g4, 2),

    (v_econ_id, v_dr_p, NULL,
     '(c) Assess the view that a country should always pursue free trade rather than protectionism. Use the evidence from the texts and your own economic knowledge. [8]',
     NULL, NULL, NULL, NULL,
     'FOR FREE TRADE: Allows countries to specialise according to comparative advantage (Table 4 illustrates this), raising total world output. Lower prices for consumers — without the steel tariff, US consumers would have saved $900 million (Table 5). Promotes competition, improving efficiency and innovation. Arguments for protectionism can be self-defeating — retaliatory tariffs (Text B) may wipe out the original gains. AGAINST FREE TRADE / FOR PROTECTIONISM: Infant industry argument — developing industries may need temporary protection to build scale. National security — some industries (defence, food, energy) should not be entirely dependent on foreign supply, as Text B notes. Job protection — even if aggregate welfare falls, the distributional impact matters: 1,800 steelworkers saved their jobs. Dumping — if foreign firms sell below cost to destroy domestic competitors, temporary protection may be justified. EVALUATION: The evidence from Text B suggests that the steel tariff was economically costly in aggregate (75,000 jobs lost vs 1,800 saved), but produced visible benefits for a concentrated group. Free trade maximises aggregate welfare but its gains and losses are unevenly distributed. Protectionism may be justified temporarily for specific reasons (infant industries, national security) but broad, permanent protection typically reduces overall efficiency and invites retaliation. A nuanced answer acknowledges trade-offs between efficiency and equity.',
     'Band 1 (7–8): Both arguments developed with evidence from texts and economic theory. Counter-arguments to free trade are recognised and assessed, not just dismissed. Justified, nuanced conclusion. Band 2 (5–6): Both perspectives present with some use of evidence. Band 3 (3–4): One perspective mainly covered. Band 4 (1–2): Descriptive only.',
     'ESSAY', 'HARD', g4, 3);

    RAISE NOTICE 'AS Level Economics data response questions inserted — courseId = %, paperId = %', v_econ_id, v_dr_p;

END $$;
