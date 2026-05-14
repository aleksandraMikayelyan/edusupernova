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
    g1 INTEGER; g2 INTEGER; g3 INTEGER; g4 INTEGER; g5 INTEGER; g6 INTEGER; g7 INTEGER; g8 INTEGER; g9 INTEGER; g10 INTEGER; g11 INTEGER; g12 INTEGER; g13 INTEGER; g14 INTEGER; g15 INTEGER; g16 INTEGER;
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
     'ESSAY', 'HARD', g1, 4),
     (v_econ_id, v_dr_p, NULL,
     '(e) Explain the concept of opportunity cost and, with reference to Text B, explain the opportunity cost for a retailer who chooses to "absorb part of the cost increase" rather than passing it on to consumers. [3]',
     NULL, NULL, NULL, NULL,
     'Opportunity cost is the value of the next best alternative foregone when a choice is made. For a retailer who chooses to absorb the cost (accepting lower profit margins), the opportunity cost is the alternative use of those lost profits. This could include foregone investment in marketing, store renovations, or the ability to pay higher dividends to shareholders. By protecting customer volume, they sacrifice the financial resources that could have been used to expand or improve the business.',
     'Award 1 mark for a clear definition of opportunity cost. Award 2 marks for applying the concept specifically to the retailer’s situation (identifying what the lost profit could have otherwise been used for).',
     'SHORT_ANSWER', 'MEDIUM', g1, 5);

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
     'ESSAY', 'HARD', g2, 3),

     (v_econ_id, v_dr_p, NULL,
     '(d) With reference to the data in Table 2, explain how the change in the Bank of England Base Rate between 2021 and 2023 is likely to affect the UK housing market. [6]',
     NULL, NULL, NULL, NULL,
     'Analysis should link the sharp increase in interest rates (0.1% to 5.25%) to the cost of borrowing. (1) Cost of Mortgages: Higher base rates increase mortgage interest rates, reducing the discretionary income of existing homeowners with variable rates and increasing the entry cost for new buyers. (2) Shift in Demand: This leads to a leftward shift in the demand curve for housing as it becomes less affordable. (3) Effect on Prices: From the data, while prices rose to £285,000 in 2023, the rate of growth is likely to slow or reverse. (4) Supply Side: Higher rates also increase borrowing costs for developers, potentially further restricting the "New Homes Completed" which already sit below the 300,000 target. Candidates should use a demand and supply diagram to show a decrease in equilibrium price and quantity.',
     'Award 2 marks for explaining the mechanism of interest rates on mortgage costs. Award 2 marks for applying the 2021-2023 data specifically. Award 2 marks for analysis of the impact on both demand (buyers) and supply (developers).',
     'SHORT_ANSWER', 'MEDIUM', g2, 4),

    (v_econ_id, v_dr_p, NULL,
     '(e) Evaluate the impact of the "Stamp Duty Holiday" on the UK economy. [8]',
     NULL, NULL, NULL, NULL,
     'The Stamp Duty Holiday was a fiscal policy aimed at stimulating the housing market. POSITIVE IMPACTS: (1) Increased Mobility: The 40% surge in transactions suggests it successfully encouraged people to move, which can improve labor mobility. (2) Multiplier Effect: Higher housing turnover stimulates secondary markets (solicitors, removals, furniture, renovations), boosting AD and economic growth. (3) Consumer Confidence: Rising house prices (10% in one year) create a "wealth effect," encouraging further consumer spending. NEGATIVE IMPACTS/LIMITATIONS: (1) Price Inflation: As the text notes, prices rose by 10%, which may have completely offset the tax savings for buyers, benefiting sellers instead. (2) Fiscal Cost: Loss of tax revenue for the government. (3) Market Distortion: Created a "cliff-edge" effect where demand was pulled forward, leading to a potential slump after the holiday ended. EVALUATION: While effective at preventing a market collapse during the pandemic, it may be seen as a regressive policy that fueled house price inflation in an already supply-constrained market, worsening long-term affordability for the sake of short-term stimulus.',
     'Band 1 (7–8): Balanced evaluation of both micro (buyer/seller) and macro (AD/Growth) effects. Good use of Text B data. Band 2 (5–6): Discussion of pros and cons but lacks depth in economic theory. Band 3 (3–4): Mainly descriptive or one-sided. Band 4 (1–2): Identification of what stamp duty is without analysis of the "holiday" impact.',
     'ESSAY', 'HARD', g2, 5);

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
     'ESSAY', 'HARD', g3, 3),

     (v_econ_id, v_dr_p, NULL, 
     '(d) Explain the difference between a "nominal wage" and a "real wage," and identify from the data which year posed the greatest challenge to maintaining real living standards. [4]',
     NULL, NULL, NULL, NULL,
     'A nominal wage is the wage rate expressed in current monetary terms (e.g., £9.50/hr), whereas a real wage is adjusted for inflation to reflect its actual purchasing power. According to Table 3, 2022 posed the greatest challenge. While the NLW rose to £9.50, CPI inflation spiked to 9.1%, while "Average Earnings Growth" was only 4.7%. This suggests that for the average worker, price increases significantly outpaced wage growth, leading to a fall in real income and living standards during that specific year.',
     'Award 2 marks for clear definitions of nominal vs. real wages. Award 2 marks for identifying 2022 and using the relationship between inflation (9.1%) and earnings growth (4.7%) as evidence.',
     'SHORT_ANSWER', 'MEDIUM', g3, 4),

    (v_econ_id, v_dr_p, NULL,
     '(e) Evaluate the view that a National Living Wage is the most effective way for a government to reduce in-work poverty. [10]',
     NULL, NULL, NULL, NULL,
     'ARGUMENTS FOR: (1) Direct Income Boost: Increases the hourly rate for the lowest-paid, directly raising the floor of earnings. (2) Incentive Effects: High wages increase the opportunity cost of leisure, potentially increasing the labour supply and reducing benefit dependency. (3) Productivity: Efficiency Wage Theory suggests higher pay can lead to higher motivation and lower staff turnover, benefiting the firm’s long-term viability. ARGUMENTS AGAINST/LIMITATIONS: (1) Cost-Push Inflation: As seen in Text B, firms with "thin margins" may eventually pass costs to consumers, raising the cost of living and eroding the wage gain. (2) Labour Substitution: Text B notes the shift toward "self-service technology." If the NLW exceeds a worker’s Marginal Revenue Product (MRP), they may be replaced, leading to unemployment—the ultimate cause of poverty. (3) Fiscal Alternatives: Tax credits or reducing the basic rate of income tax might increase "take-home" pay without increasing the cost of labour for firms. EVALUATION: While the NLW is a powerful tool to narrow wage inequality (Text A), it is not a panacea. Its effectiveness depends on the price elasticity of demand for labour and whether the national inflation rate stays low. A holistic approach combining the NLW with supply-side policies (training/education to raise MRP) and fiscal adjustments is likely more sustainable than wage mandates alone.',
     'Band 1 (8–10): Sophisticated evaluation of NLW vs. other methods. Excellent use of economic concepts (MRP, Cost-push inflation, Elasticity). Clear, justified conclusion. Band 2 (5–7): Good discussion of pros and cons with some reference to the text. Band 3 (3–4): Identification of basic points without depth. Band 4 (1–2): Broadly descriptive.',
     'ESSAY', 'HARD', g3, 5);

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
     'ESSAY', 'HARD', g4, 3),

     (v_econ_id, v_dr_p, NULL,
     '(d) Using the data in Text A and Table 4, calculate the total increase in world output of wheat and cloth if both countries move from no trade (splitting workers equally) to complete specialisation based on comparative advantage. [6]',
     NULL, NULL, NULL, NULL,
     'STEP 1: Calculate "No Trade" production. Country A (50 workers wheat, 50 workers cloth) produces 400 tonnes wheat (50x8) and 200m cloth (50x4). Country B (50 workers wheat, 50 workers cloth) produces 300 tonnes wheat (50x6) and 300m cloth (50x6). Total World Output: 700 tonnes wheat, 500m cloth. STEP 2: Calculate "Specialisation" production. Country A (all 100 workers on wheat) produces 800 tonnes wheat. Country B (all 100 workers on cloth) produces 600m cloth. STEP 3: Calculate the Increase. Wheat output increases by 100 tonnes (800 - 700). Cloth output increases by 100 metres (600 - 500). Conclusion: Specialisation according to comparative advantage increases total world output for both goods.',
     'Award 2 marks for correct "No Trade" calculation. Award 2 marks for correct specialisation totals. Award 2 marks for identifying the net increase for both goods.',
     'SHORT_ANSWER', 'HARD', g4, 4),

    (v_econ_id, v_dr_p, NULL,
     '(e) Discuss the extent to which the government revenue generated by a tariff justifies its imposition. Use a diagram and the data in Table 5 to support your answer. [8]',
     NULL, NULL, NULL, NULL,
     'The tariff generated $600 million in government revenue. ARGUMENTS FOR: (1) Fiscal Revenue: This provides funds for public spending or can be used to retrain the 75,000 workers who lost jobs in downstream industries. (2) Reduced Dependence: May fulfill national security objectives. ANALYSIS WITH DIAGRAM: A tariff diagram should show the world price (Pw) and the tariff price (Pw+t). Government revenue is represented by the rectangle (quantity of imports multiplied by the tariff value). ARGUMENTS AGAINST: (1) Deadweight Loss: Table 5 shows the cost to consumers ($900m) exceeds the revenue ($600m). This $300m gap reflects the deadweight loss (efficiency loss) and the producer surplus gain. (2) Retaliation: Text B mentions retaliation by the EU, China, and Canada, which reduces export revenue in other sectors. EVALUATION: Government revenue is a direct benefit to the treasury, but in this case, it is significantly lower than the costs imposed on the wider economy (consumers and steel-using industries). Therefore, revenue alone is rarely a sufficient justification for a tariff unless the primary goal is fiscal rather than protective, or if the revenue is specifically used to offset the negative externalities of the trade policy.',
     'Band 1 (7–8): Accurate use of tariff diagram. Clear comparison of Table 5 figures ($600m revenue vs $900m cost). Nuanced conclusion on welfare. Band 2 (5–6): Good analysis of the diagram and revenue but lacks specific data application. Band 3 (3–4): Descriptive of tariffs with limited evaluation. Band 4 (1–2): Basic definition of a tariff only.',
     'ESSAY', 'HARD', g4, 5);

     -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 5: Market Failure and the Green Economy
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 5 — Externalities and Electric Vehicles',
'Read the following information carefully before answering the questions.

TEXT A: The Global Transition to Electric Vehicles (EVs)

The transport sector accounts for approximately 16% of global greenhouse gas emissions. To address this market failure, governments have implemented a "carrot and stick" approach: subsidising the purchase of low-emission vehicles while simultaneously increasing taxes on traditional Internal Combustion Engine (ICE) vehicles. The rapid expansion of the EV market is seen as a primary method for achieving "Net Zero" targets by 2050.

However, the transition is not without opportunity costs. The production of a single EV battery requires roughly 8kg of lithium and 14kg of cobalt. The mining of these minerals in regions such as the Democratic Republic of Congo has been linked to significant negative externalities, including groundwater contamination and hazardous labor conditions. Furthermore, the sustainability of an EV is intrinsically linked to the "generation mix" of a country’s national grid. In nations where coal remains a dominant energy source, an EV may generate 75% of the CO2 emissions of a modern petrol car over its lifetime, whereas in countries with renewable-heavy grids (like Norway or Iceland), this figure drops to less than 5%.

TABLE 6: Global EV Market Trends and Infrastructure

Year | EV Share of New Sales (%) | Battery Cost ($/kWh) | Public Charging Points (m) | Global Lithium Price (Index)
2018 | 2.1                       | 180                  | 0.4                        | 100
2020 | 4.6                       | 140                  | 1.3                        | 85
2022 | 14.0                      | 153                  | 2.7                        | 320
2024 | 22.5                      | 125                  | 4.2                        | 145

TEXT B: The Norwegian Success Story and Equity Concerns

Norway is often cited as the global leader in EV adoption, with battery-electric vehicles accounting for nearly 90% of all new car registrations in 2024. This was achieved through a comprehensive suite of fiscal incentives:
1. Exemption from the 25% Value Added Tax (VAT).
2. Reduction in annual road tax and no registration tax.
3. Access to bus lanes and priority parking in urban centers.

Despite the success, critics argue the policy is regressive. A report by the Norwegian Ministry of Finance suggested that the VAT exemptions alone cost the treasury $4 billion annually in lost revenue—money that could have been reinvested into public rail or healthcare. Moreover, the benefits accrue largely to high-income households, while lower-income citizens, who rely on the used car market or public transport, see no direct benefit from these subsidies.',
5) RETURNING id INTO g5;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data handling
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Using Table 6, compare the change in the EV Share of New Sales with the change in the Global Lithium Price between 2020 and 2022. [2]
  (ii) Describe the trend in the provision of public charging points over the period shown. [2]',
 NULL, NULL, NULL, NULL,
 '(i) Between 2020 and 2022, the EV Share of New Sales rose significantly from 4.6% to 14.0% (a 204% increase), while the Lithium Price Index spiked dramatically from 85 to 320 (a 276% increase). (ii) The provision of public charging points shows a consistent and accelerating upward trend, increasing more than tenfold from 0.4 million in 2018 to 4.2 million in 2024.',
 'Award 1 mark for each comparison in (i) and 2 marks for the trend description with data in (ii).',
 'SHORT_ANSWER', 'EASY', g5, 1),

-- (b) Micro Theory
(v_econ_id, v_dr_p, NULL,
 '(b) With the aid of a diagram, explain how the negative externalities associated with lithium mining lead to an inefficient allocation of resources. [6]',
 NULL, NULL, NULL, NULL,
 'The diagram should show the Marginal Private Cost (MPC) and Marginal Social Cost (MSC), where MSC > MPC due to the negative external costs (groundwater contamination). Equilibrium is at MPC=MSB, leading to a quantity Qm. However, the social optimum is at MSC=MSB at quantity Qs. The market overproduces lithium (Qm > Qs), resulting in a welfare loss/deadweight loss triangle. This represents an inefficient allocation as the true cost to society is not reflected in the market price.',
 'Award 2 marks for a correct diagram (MSC/MPC/MSB). Award 2 marks for identifying the overproduction. Award 2 marks for explaining the divergence between private and social costs.',
 'SHORT_ANSWER', 'MEDIUM', g5, 2),

-- (c) Application
(v_econ_id, v_dr_p, NULL,
 '(c) Using the information in Text A, explain why the "Net Zero" target may not be achieved solely through the adoption of Electric Vehicles. [4]',
 NULL, NULL, NULL, NULL,
 'Text A notes that the "greenness" of an EV depends on the energy source of the national grid. In coal-reliant nations, an EV still produces 75% of the CO2 of a petrol car, meaning carbon emissions are merely shifted from the road to the power plant rather than eliminated. Additionally, mining and production create their own environmental degradation which contributes to the global carbon footprint before the car is even driven.',
 'Award 2 marks for the grid/energy source argument and 2 marks for the production/mining argument.',
 'SHORT_ANSWER', 'MEDIUM', g5, 3),

-- (d) Analysis
(v_econ_id, v_dr_p, NULL,
 '(d) Analyse the likely effect of the Norwegian fiscal incentives (Text B) on the market for used petrol-engine cars. [4]',
 NULL, NULL, NULL, NULL,
 'Fiscal incentives like VAT exemptions make new EVs significantly cheaper, increasing their demand. Since used petrol cars are substitutes for EVs, the cross-price elasticity of demand (XED) is positive. As the effective price of the substitute (EVs) falls, the demand for used petrol cars will shift to the left. This will likely lead to a fall in the equilibrium price and quantity of used petrol cars in the Norwegian market.',
 'Award 2 marks for identifying the substitute relationship (XED). Award 2 marks for the impact on demand and price of petrol cars.',
 'SHORT_ANSWER', 'MEDIUM', g5, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that the use of indirect tax exemptions is the best way for a government to achieve a sustainable transport system. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: Indirect tax exemptions (like VAT) are highly effective at changing relative prices, as seen in Norway where sales reached 90%. They encourage private sector investment in charging networks. AGAINST: (1) Regressive: As Text B states, high-income households benefit most, while the poor receive no help. (2) Opportunity Cost: The $4bn lost revenue could be spent on public transport, which is more space-efficient and reduces congestion better than EVs. (3) Fiscal Sustainability: As the market reaches 100% EVs, the government loses its tax base entirely. EVALUATION: While effective for rapid adoption, tax exemptions are fiscally expensive and socially inequitable. A more sustainable long-term approach may involve "polluter pays" taxes on ICE vehicles combined with direct investment in public infrastructure, rather than open-ended subsidies for private car owners.',
 'Band 1 (7–8): Balanced evaluation using Text B and economic concepts. Clear, justified conclusion. Band 2 (5–6): Discussion of pros/cons. Band 3 (3–4): Mainly descriptive. Band 4 (1–2): Limited understanding.',
 'ESSAY', 'HARD', g5, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 6: Macroeconomic Policy and Exchange Rates
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 6 — Emerging Economies: Inflation and Trade',
'Read the following information carefully before answering the questions.

TEXT A: The Challenge of Imported Inflation in Country X

Country X is a small, developing economy that relies heavily on imports for refined fuel and specialized machinery. In 2022, a global surge in energy prices, combined with a significant depreciation of Country X’s currency (the "Peso"), led to a sharp rise in the Consumer Price Index (CPI). 

The Central Bank of Country X faced a policy dilemma. To curb inflation, it considered raising interest rates. However, economists warned that higher rates might stifle domestic investment and increase the cost of debt for local businesses already struggling with high input costs. Furthermore, the depreciation of the Peso was partly attributed to a widening Current Account deficit, as the value of essential imports rose much faster than the revenue generated from Country X’s primary commodity exports (copper and agricultural products).

TABLE 7: Macroeconomic Indicators for Country X

Year | CPI Inflation (%) | Exchange Rate (Pesos per $1) | Current Account Balance (% of GDP) | GDP Growth (%)
2019 | 3.2               | 15.5                         | -1.2                               | 4.5
2020 | 2.1               | 16.2                         | -0.8                               | -2.0
2021 | 5.4               | 18.0                         | -2.5                               | 5.1
2022 | 12.8              | 24.5                         | -5.8                               | 1.8
2023 | 9.5               | 22.0                         | -4.2                               | 2.2

TEXT B: Government Response and Protectionist Pressures

In early 2023, the government of Country X introduced temporary subsidies on fuel to shield consumers from rising prices. While this slowed the rate of inflation, it significantly increased the government’s budget deficit. Local manufacturing unions began lobbying for the imposition of "emergency tariffs" on imported consumer goods. They argued that the depreciated currency made their exports more competitive abroad, but that they needed protection from "cheap imports" at home to recover from the high costs of imported raw materials. Critics of the tariff proposal suggested that such protectionism would only lead to further domestic price increases and invite retaliation from trading partners.',
6) RETURNING id INTO g6;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data handling (Comparison and Trend)
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Using Table 7, identify the year in which the Peso was at its weakest against the US Dollar and calculate the percentage depreciation of the Peso between 2019 and 2022. [2]
  (ii) Describe the relationship between the Exchange Rate and the Current Account Balance as shown in the data. [2]',
 NULL, NULL, NULL, NULL,
 '(i) The Peso was weakest in 2022 (24.5 Pesos per $1). Percentage depreciation: (24.5 - 15.5) / 15.5 * 100 = 58.1%. (ii) There is a positive correlation between the exchange rate (number of pesos per dollar) and the current account deficit. As the Peso depreciated (from 15.5 to 24.5), the Current Account deficit widened significantly (from -1.2% to -5.8% of GDP).',
 'Award 1 mark for correct identification and calculation in (i). Award 2 marks for correctly identifying the correlation with data support in (ii).',
 'SHORT_ANSWER', 'MEDIUM', g6, 1),

-- (b) Theory (Inflation Analysis)
(v_econ_id, v_dr_p, NULL,
 '(b) Explain the difference between "cost-push" inflation and "demand-pull" inflation. With reference to Text A, identify which type was more prevalent in Country X during 2022. [6]',
 NULL, NULL, NULL, NULL,
 'Demand-pull inflation occurs when Aggregate Demand (AD) exceeds Aggregate Supply (AS), often described as "too much money chasing too few goods." Cost-push inflation occurs when the costs of production rise, shifting the SRAS curve to the left. According to Text A, Country X experienced cost-push inflation in 2022. This was driven by two factors: (1) The "global surge in energy prices" (rising input costs) and (2) the "significant depreciation of the Peso," which made imported essential fuel and machinery more expensive.',
 'Award 2 marks for definitions. Award 2 marks for identifying Cost-Push. Award 2 marks for using Text A evidence (energy prices and currency depreciation).',
 'SHORT_ANSWER', 'MEDIUM', g6, 2),

-- (c) Exchange Rate Impact
(v_econ_id, v_dr_p, NULL,
 '(c) Explain how a depreciation of the Peso would be expected to affect the volume of Country X’s exports and imports. [4]',
 NULL, NULL, NULL, NULL,
 'A depreciation makes exports cheaper in foreign currency terms, which should lead to an increase in the volume of exports as they become more price-competitive. Conversely, it makes imports more expensive in local currency terms (the Peso), which should lead to a decrease in the volume of imports as consumers and firms switch to domestic substitutes or reduce consumption.',
 'Award 2 marks for the effect on exports (cheaper/higher volume) and 2 marks for the effect on imports (expensive/lower volume).',
 'SHORT_ANSWER', 'EASY', g6, 3),

-- (d) Policy Dilemma Analysis
(v_econ_id, v_dr_p, NULL,
 '(d) Analyse the likely effect of the fuel subsidies mentioned in Text B on the Aggregate Demand (AD) and the Budget Deficit of Country X. [4]',
 NULL, NULL, NULL, NULL,
 'Fuel subsidies increase the discretionary income of consumers and reduce costs for firms, likely leading to a rightward shift in Aggregate Demand (AD). However, because these are government-funded, they represent a significant increase in government expenditure (G). Without a corresponding increase in tax revenue, this leads to a widening of the budget deficit (G > T).',
 'Award 2 marks for the AD shift analysis. Award 2 marks for the impact on the fiscal position (G > T).',
 'SHORT_ANSWER', 'MEDIUM', g6, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that imposing tariffs on consumer goods is the most effective way for Country X to reduce its Current Account deficit. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: Tariffs increase the price of imported consumer goods, reducing the quantity demanded and potentially improving the trade balance component of the Current Account. It protects domestic jobs in manufacturing (Text B). AGAINST: (1) Inelastic Demand: If Country X lacks domestic substitutes for these goods, the value of imports may not fall significantly despite the tariff. (2) Cost-Push Inflation: Tariffs on goods can further increase the CPI, as noted by critics in Text B. (3) Retaliation: Trading partners may impose tariffs on Country X’s copper or agricultural exports, worsening the deficit. EVALUATION: While tariffs provide short-term relief for local firms, they address the symptoms rather than the cause (currency depreciation and high energy costs). A more effective long-term strategy might involve supply-side policies to diversify exports or monetary policy to stabilize the exchange rate, despite the growth trade-offs.',
 'Band 1 (7–8): Balanced evaluation of tariffs vs. other methods. References Text B and Table 7. Clear, justified conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of tariffs. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g6, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 7: Supply-Side Policy and Productivity
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 7 — Productivity and Economic Growth',
'Read the following information carefully before answering the questions.

TEXT A: The Productivity Gap in Modern Economies

Economic growth is fundamentally driven by two factors: the quantity of resources and the efficiency with which they are used, known as productivity. In many developed nations, productivity growth has slowed since the 2008 financial crisis, a phenomenon economists call the "Productivity Puzzle." This stagnation limits the potential growth rate of the economy and places downward pressure on real wage increases.

To address this, governments often implement supply-side policies. These can be "market-based," such as reducing corporation tax to encourage private investment, or "interventionist," such as direct government spending on vocational training and transport infrastructure. While market-based policies aim to improve incentives and efficiency through competition, interventionist policies focus on overcoming market failures in education and infrastructure. However, the effectiveness of these policies is often hindered by significant time lags; an investment in a new high-speed rail network or a technical college may not shift the Long-Run Aggregate Supply (LRAS) curve for a decade or more.

TABLE 8: Economic Performance Indicators (Averages 2018–2024)

Country   | Investment (% of GDP) | Labor Productivity Growth (%) | Unemployment Rate (%) | R&D Spending (% of GDP)
Country Y | 14.5                  | 0.4                           | 7.2                   | 1.1
Country Z | 26.2                  | 2.8                           | 3.5                   | 3.8

TEXT B: The Case of Country Z’s "Innovation Grant"

In 2018, Country Z launched a massive "Innovation Grant" scheme, providing low-interest loans and tax credits to firms specializing in green technology and artificial intelligence. This was accompanied by a reform of the labor market, making it easier for firms to hire and fire staff, which proponents argued increased labor market flexibility.

Critics, however, point to the "crowding out" effect. By borrowing heavily to fund these grants, the government of Country Z caused market interest rates to rise, which potentially discouraged investment in traditional manufacturing sectors. Furthermore, while productivity rose (as seen in Table 8), trade unions argued that the benefits were not shared equally, as real wages for low-skilled workers remained stagnant while executive pay reached record highs.',
7) RETURNING id INTO g7;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Comparison
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Using Table 8, compare the economic performance of Country Y and Country Z. [3]
  (ii) Explain the likely relationship between R&D spending and Labor Productivity Growth. [2]',
 NULL, NULL, NULL, NULL,
 '(i) Country Z significantly outperforms Country Y across all indicators: it has nearly double the investment as a % of GDP (26.2% vs 14.5%), seven times the productivity growth (2.8% vs 0.4%), and a much lower unemployment rate (3.5% vs 7.2%). (ii) There is a positive correlation; higher R&D spending (as seen in Country Z at 3.8%) leads to technological innovation and better capital equipment, which increases the output per worker (labor productivity).',
 'Award 2 marks for a detailed comparison using at least two variables from (i). Award 2 marks for identifying and explaining the positive correlation in (ii).',
 'SHORT_ANSWER', 'EASY', g7, 1),

-- (b) Theory (AD/AS)
(v_econ_id, v_dr_p, NULL,
 '(b) Use an AD/AS diagram to explain how an increase in labor productivity affects the price level and real national output of an economy. [6]',
 NULL, NULL, NULL, NULL,
 'The diagram should show a rightward shift of the Long-Run Aggregate Supply (LRAS) curve (or the SRAS curve). This shift represents an increase in the economy’s productive capacity. As LRAS shifts right, the equilibrium level of real national output increases (Y1 to Y2), and the general price level falls (P1 to P2), assuming AD remains constant. This illustrates non-inflationary growth.',
 'Award 2 marks for a correct AD/AS diagram with a rightward AS/LRAS shift. Award 2 marks for explaining the increase in output. Award 2 marks for explaining the downward pressure on the price level.',
 'SHORT_ANSWER', 'MEDIUM', g7, 2),

-- (c) Distinguishing Policies
(v_econ_id, v_dr_p, NULL,
 '(c) With reference to Text B, distinguish between an "interventionist" and a "market-based" supply-side policy. [4]',
 NULL, NULL, NULL, NULL,
 'An interventionist policy involves direct government action to correct market failure, such as the "Innovation Grant" scheme in Country Z. A market-based policy aims to reduce government interference and allow markets to work more freely, such as the "reform of the labor market" mentioned in Text B, which increased flexibility by reducing hiring/firing regulations.',
 'Award 2 marks for the definition and example of interventionist. Award 2 marks for the definition and example of market-based.',
 'SHORT_ANSWER', 'MEDIUM', g7, 3),

-- (d) Concept Analysis (Crowding Out)
(v_econ_id, v_dr_p, NULL,
 '(d) Explain the concept of "crowding out" as mentioned in Text B. [4]',
 NULL, NULL, NULL, NULL,
 'Crowding out occurs when increased government borrowing (to fund spending like the Innovation Grants) leads to an increase in the demand for loanable funds. This drives up interest rates. Higher interest rates increase the cost of borrowing for private firms, which "crowds out" or discourages private sector investment, potentially neutralizing the initial boost from government spending.',
 'Award 2 marks for linking borrowing to interest rates. Award 2 marks for linking higher interest rates to reduced private investment.',
 'SHORT_ANSWER', 'MEDIUM', g7, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that supply-side policies are the most effective way for a government to achieve a sustained increase in the standard of living. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: Supply-side policies address the root causes of stagnation by increasing productivity (Table 8) and shifting LRAS. This allows for long-term growth without causing inflation. They can reduce structural unemployment by improving labor flexibility. AGAINST: (1) Time Lags: As Text A notes, these policies can take a decade to work. (2) Cost/Opportunity Cost: Interventionist policies are expensive and can lead to crowding out (Text B). (3) Equity: Benefits may not be shared equally, as seen in Country Z where low-skilled wages stagnated. (4) AD Dependency: If Aggregate Demand is low (e.g., during a recession), increasing productive capacity alone will not result in growth. EVALUATION: While supply-side policies are essential for increasing "potential" GDP and long-term standards of living, they are often insufficient on their own. They must be supported by stable demand-management (fiscal/monetary) policies and social safety nets to ensure growth is both inclusive and immediate.',
 'Band 1 (7–8): Balanced evaluation of supply-side vs. demand-side. References time lags and equity. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of policies. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g7, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 8: Monetary Policy and the Banking System
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 8 — Money Supply and Central Bank Intervention',
'Read the following information carefully before answering the questions.

TEXT A: The Functions of Money and the Role of Interest Rates

In a modern economy, money serves four essential functions: a medium of exchange, a unit of account, a store of value, and a standard for deferred payment. For these functions to be performed effectively, the value of money must remain relatively stable. Central Banks attempt to maintain this stability by managing the money supply and setting the "base rate"—the interest rate at which commercial banks borrow from the Central Bank.

When a Central Bank lowers interest rates, it aims to stimulate Aggregate Demand (AD) by reducing the cost of borrowing for households and firms. This usually leads to an increase in consumption and investment. However, if the money supply grows significantly faster than the real output of the economy (GDP), the result is often persistent inflation. Some economists argue that the broad money supply (M2) is a leading indicator of future price levels, while others suggest that in a globalized economy, domestic money supply is less influential than international capital flows.

TABLE 9: Monetary and Price Indicators (Country W)

Year | Broad Money Supply (M2) Growth (%) | Central Bank Base Rate (%) | CPI Inflation (%) | Household Savings Ratio (%)
2019 | 4.1                               | 2.5                        | 1.8               | 8.2
2020 | 12.5                              | 0.1                        | 0.9               | 15.4
2021 | 15.8                              | 0.1                        | 4.5               | 11.2
2022 | 8.2                               | 3.5                        | 9.2               | 6.5
2023 | 3.5                               | 5.25                       | 5.1               | 9.8

TEXT B: The "Liquidity Trap" and Commercial Bank Behavior

Following the economic slowdown in 2020, the Central Bank of Country W slashed interest rates to 0.1% to encourage spending. Despite this, commercial banks became "risk-averse," tightening their lending criteria and increasing the reserves they held at the Central Bank. This resulted in a situation where low interest rates failed to significantly boost private sector investment—a phenomenon similar to a "liquidity trap."

Furthermore, as inflation spiked in 2022, the Central Bank was forced to pivot aggressively, raising the base rate to 5.25% by 2023. While this was intended to reduce inflationary pressure, critics argued it placed an unfair burden on mortgage holders and small businesses, potentially leading to a recession. There were also concerns that the high rates would attract "hot money" inflows, causing the exchange rate to appreciate and damaging the competitiveness of Country W’s exports.',
8) RETURNING id INTO g8;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Analysis
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Using Table 9, identify the year in which the real interest rate was lowest. [2]
  (ii) Describe the relationship between the Base Rate and the Household Savings Ratio between 2021 and 2023. [2]',
 NULL, NULL, NULL, NULL,
 '(i) The real interest rate is calculated as the Nominal Rate minus Inflation. In 2022, the base rate was 3.5% while inflation was 9.2%, resulting in a real interest rate of -5.7%, which is the lowest in the table. (ii) There is a positive correlation; as the base rate rose from 0.1% in 2021 to 5.25% by 2023, the household savings ratio also moved from a low of 6.5% in 2022 back up to 9.8% in 2023, as the reward for saving increased.',
 'Award 1 mark for correct year and 1 mark for the real interest rate calculation in (i). Award 2 marks for describing the positive correlation with data in (ii).',
 'SHORT_ANSWER', 'MEDIUM', g8, 1),

-- (b) Theory (Functions of Money)
(v_econ_id, v_dr_p, NULL,
 '(b) Explain how high inflation, such as that seen in 2022, affects the ability of money to perform its functions as a "store of value" and a "standard for deferred payment." [4]',
 NULL, NULL, NULL, NULL,
 'As a "store of value," money is intended to hold its purchasing power over time. High inflation (9.2%) erodes this power, meaning the same amount of money buys fewer goods in the future, discouraging saving in cash form. As a "standard for deferred payment," money allows for contracts and loans to be settled in the future. High inflation makes it difficult for lenders and borrowers to agree on future values, as the real value of the debt will be significantly lower when repaid, effectively redistributing wealth from lenders to borrowers.',
 'Award 2 marks for the explanation of "store of value" and 2 marks for "standard for deferred payment" in the context of inflation.',
 'SHORT_ANSWER', 'MEDIUM', g8, 2),

-- (c) Mechanism Analysis
(v_econ_id, v_dr_p, NULL,
 '(c) With reference to the "risk-averse" behavior mentioned in Text B, explain why a decrease in the base rate might not always lead to an increase in the money supply. [4]',
 NULL, NULL, NULL, NULL,
 'The money supply is largely created by commercial banks through the process of credit creation (lending). If commercial banks are risk-averse, they may choose to hold excess reserves rather than lending to the public, even if the base rate is low (0.1%). If banks do not increase their lending, the "money multiplier" effect is weakened, and the total money supply (M2) may not grow as much as the Central Bank intended.',
 'Award 2 marks for the role of commercial bank lending in money creation. Award 2 marks for explaining how high reserves/low lending prevents money supply growth.',
 'SHORT_ANSWER', 'MEDIUM', g8, 3),

-- (d) Exchange Rate Link
(v_econ_id, v_dr_p, NULL,
 '(d) Analyse how the increase in the base rate in 2023 might lead to an appreciation of Country W’s exchange rate. [4]',
 NULL, NULL, NULL, NULL,
 'A higher base rate (5.25%) offers a higher return for international investors compared to countries with lower rates. This attracts "hot money" inflows as investors move funds into Country W’s banks. To do this, they must buy Country W’s currency, increasing the demand for the currency on the foreign exchange market, which causes the exchange rate to appreciate (rise in value).',
 'Award 2 marks for the "hot money" concept. Award 2 marks for the impact on demand for the currency and the resulting appreciation.',
 'SHORT_ANSWER', 'MEDIUM', g8, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that managing the money supply is the most effective way for a Central Bank to control inflation. [10]',
 NULL, NULL, NULL, NULL,
 'FOR: Monetarists argue that "inflation is always and everywhere a monetary phenomenon." By restricting M2 growth (as seen in the drop from 15.8% to 3.5% in Table 9), the Central Bank can directly reduce the inflationary pressure caused by "too much money chasing too few goods." AGAINST: (1) Cost-Push Factors: Money supply control does not address inflation caused by rising global energy prices or supply chain disruptions. (2) Interest Rate Impact: Using high rates to control the money supply can cause a recession, as it reduces AD and increases the cost of debt (Text B). (3) Velocity of Circulation: If the speed at which money changes hands increases, inflation can still rise even if the supply is controlled. EVALUATION: While controlling the money supply is a fundamental tool, it is often a "blunt instrument." It is effective for demand-pull inflation but less so for cost-push inflation. A balanced approach involving supply-side policies and fiscal discipline is often more effective than relying solely on monetary aggregates.',
 'Band 1 (8–10): Balanced evaluation of Monetarist vs. Keynesian/Cost-push views. Good use of Table 9 data. Clear conclusion. Band 2 (5–7): Good discussion of pros/cons. Band 3 (3–4): Basic explanation of monetary policy. Band 4 (1–2): Descriptive only.',
 'ESSAY', 'HARD', g8, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 9: Terms of Trade and Export Dependency
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 9 — Terms of Trade and Economic Welfare',
'Read the following information carefully before answering the questions.

TEXT A: Understanding the Terms of Trade

The Terms of Trade (ToT) index measures the ratio of a country’s export prices to its import prices. It is a crucial indicator of a nation’s "buying power" on the global market. An improvement in the ToT occurs when export prices rise relative to import prices, allowing a country to purchase more imports for every unit of exports sold.

However, an improvement in the ToT is not always beneficial for the Balance of Payments. If a country’s export prices rise because of high domestic inflation or inefficiency, the quantity demanded for those exports may fall significantly, especially if the price elasticity of demand (PED) for exports is elastic. This can lead to a worsening of the Current Account deficit despite the "favorable" movement in the ToT index. Conversely, many developing nations face a long-term decline in their ToT because they export primary commodities with low income elasticity of demand (YED) while importing manufactured goods with high YED.

TABLE 10: Trade Indicators for Country V (Index 2018 = 100)

Year | Export Price Index | Import Price Index | Terms of Trade Index | Current Account Balance ($bn)
2019 | 102                | 104                | 98.1                 | -2.4
2020 | 95                 | 90                 | 105.6                | +1.2
2021 | 110                | 105                | 104.8                | -0.5
2022 | 125                | 135                | 92.6                 | -4.8
2023 | 130                | 132                | 98.5                 | -3.1

TEXT B: The Commodity Price Rollercoaster

Country V is a major exporter of iron ore and a major importer of crude oil and food. In 2022, global supply chain disruptions led to a massive spike in the price of oil and wheat (imports), while a slowdown in global manufacturing reduced the demand for iron ore (exports). This "double blow" resulted in a sharp deterioration of the ToT.

The government responded by devaluing the currency to make exports more attractive. While this was intended to fix the $4.8bn Current Account deficit, labor unions warned that devaluing the currency in a country that imports essential food and fuel would lead to a "cost-of-living crisis." Economists noted that for the devaluation to work, the Marshall-Lerner condition must be satisfied—the sum of the price elasticities of demand for exports and imports must be greater than one.',
9) RETURNING id INTO g9;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Calculation and Interpretation
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Define "Terms of Trade" and show how the index for 2022 (92.6) was calculated using the data in Table 10. [3]
  (ii) Compare the trend in the Terms of Trade index with the Current Account Balance between 2020 and 2022. [3]',
 NULL, NULL, NULL, NULL,
 '(i) Terms of Trade is the ratio of the index of export prices to the index of import prices. Calculation: (Export Price Index / Import Price Index) x 100. For 2022: (125 / 135) x 100 = 92.59 (rounded to 92.6). (ii) Between 2020 and 2022, the Terms of Trade deteriorated from 105.6 to 92.6. During the same period, the Current Account balance moved from a surplus of $1.2bn to a significant deficit of $4.8bn. This suggests that the rising cost of imports relative to exports contributed to the worsening trade position.',
 'Award 1 mark for definition and 2 marks for correct calculation in (i). Award 3 marks for the comparison using 2020 and 2022 data points in (ii).',
 'SHORT_ANSWER', 'MEDIUM', g9, 1),

-- (b) Theory Application (PED and ToT)
(v_econ_id, v_dr_p, NULL,
 '(b) Explain how an improvement in the Terms of Trade could actually lead to a worsening of the Current Account deficit. [4]',
 NULL, NULL, NULL, NULL,
 'An improvement in the ToT means export prices have risen relative to import prices. If the price elasticity of demand (PED) for exports is elastic (PED > 1), a small increase in price will lead to a proportionately larger fall in the quantity demanded. Consequently, total export revenue will fall. If this fall in revenue is greater than any savings from cheaper imports, the overall Current Account balance will worsen despite the ToT index looking "better."',
 'Award 2 marks for the link between ToT improvement and higher export prices. Award 2 marks for the application of PED and its impact on total export revenue.',
 'SHORT_ANSWER', 'MEDIUM', g9, 2),

-- (c) Micro-Macro Link (YED)
(v_econ_id, v_dr_p, NULL,
 '(c) With reference to Text A, explain why developing countries exporting primary commodities often face a long-term decline in their Terms of Trade. [4]',
 NULL, NULL, NULL, NULL,
 'Primary commodities (like iron ore) often have a low Income Elasticity of Demand (YED), meaning as global incomes rise, the demand for these exports grows slowly. However, the manufactured goods these countries import have high YED, meaning demand for imports rises rapidly as the country grows. Over time, the prices of manufactured imports tend to rise faster than the prices of primary exports, leading to a long-term downward trend in the ToT.',
 'Award 2 marks for explaining low YED for primary products. Award 2 marks for the comparison with high YED for manufactured imports.',
 'SHORT_ANSWER', 'MEDIUM', g9, 3),

-- (d) Technical Condition (Marshall-Lerner)
(v_econ_id, v_dr_p, NULL,
 '(d) Explain the "Marshall-Lerner condition" mentioned in Text B and its relevance to Country V’s decision to devalue its currency. [4]',
 NULL, NULL, NULL, NULL,
 'The Marshall-Lerner condition states that for a currency devaluation to improve the Current Account balance, the sum of the price elasticities of demand for exports and imports must be greater than one (|PEDx + PEDm| > 1). For Country V, if demand for its iron ore exports and its food/fuel imports is very inelastic (less than 1), devaluing the currency will actually increase the deficit because the higher cost of imports will outweigh the small increase in export volume.',
 'Award 2 marks for the definition of the condition. Award 2 marks for the application to Country V’s deficit and the importance of elasticity.',
 'SHORT_ANSWER', 'MEDIUM', g9, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that a deterioration in the Terms of Trade is the most significant obstacle to economic growth for a developing country. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: A deterioration in ToT (as seen in 2022) means the country must export more just to buy the same amount of essential imports (food/fuel). This reduces the "real income" of the nation and limits the funds available for investment in infrastructure or education. AGAINST: (1) Other Obstacles: Lack of human capital, poor infrastructure, and political instability may be more significant. (2) Volume vs. Price: If the volume of exports increases enough, a country can still grow despite falling prices (ToT). (3) Diversification: ToT dependency can be reduced if a country moves into manufacturing or services. EVALUATION: While a falling ToT creates a significant "leakage" from the economy and complicates the Balance of Payments, it is often a symptom of a lack of diversification. Therefore, while it is a major obstacle, the underlying lack of industrialization and human capital is arguably a more fundamental barrier to sustained growth.',
 'Band 1 (7–8): Balanced evaluation of ToT vs. other growth obstacles. References Table 10 and Text B. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of ToT. Band 4 (1–2): Basic definition.',
 'ESSAY', 'HARD', g9, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 10: Consumption and the Multiplier Effect
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 10 — Investment and the Multiplier',
'Read the following information carefully before answering the questions.

TEXT A: Determinants of Aggregate Demand

Aggregate Demand (AD) is the total spending on domestic goods and services at a given price level. Its largest component, Consumption (C), is primarily determined by disposable income. However, the relationship between income and consumption is not constant; as households earn more, they tend to save a higher proportion of their marginal income. This is reflected in the Marginal Propensity to Consume (MPC).

Investment (I), the second-largest component, is more volatile and influenced by interest rates and business confidence (animal spirits). According to the Multiplier theory, any autonomous increase in investment will lead to a more-than-proportionate increase in national income. This occurs because one person’s spending becomes another person’s income, circulating through the economy. The size of this multiplier effect depends on the "leakages" from the circular flow: savings (S), taxes (T), and imports (M). If the Marginal Propensity to Withdraw (MPW) is high, the multiplier effect will be significantly diminished.

TABLE 11: National Income Data for Country U ($ billions)

Year | National Income (Y) | Consumption (C) | Investment (I) | Gov. Spending (G)
2020 | 500                 | 400             | 40             | 60
2021 | 580                 | 460             | 55             | 65
2022 | 650                 | 510             | 70             | 70
2023 | 700                 | 545             | 75             | 80
2024 | 740                 | 573             | 77             | 90

TEXT B: The Fiscal Stimulus Debate in Country U

Following a period of slow growth in 2020, the government of Country U increased infrastructure spending by $30 billion. While the government expected this to generate a massive "boost" to the economy through the multiplier, the results were mixed. 

Economists pointed out that Country U has a high Marginal Propensity to Import (MPM), as consumers prefer foreign-made electronics and luxury goods. Consequently, much of the stimulus "leaked" out of the domestic circular flow of income. Furthermore, as the government borrowed to fund the stimulus, interest rates rose slightly, leading to some crowding out of private investment. Critics argued that instead of direct spending, the government should have cut income taxes to increase the MPC, though others countered that in times of uncertainty, households might simply save the tax cut (increasing the Marginal Propensity to Save), rendering the policy ineffective.',10) RETURNING id INTO g10;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Quantitative Calculation
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Calculate the Marginal Propensity to Consume (MPC) for Country U between 2020 and 2021. [2]
  (ii) Using your answer to (i), calculate the value of the investment multiplier, assuming no other leakages. [2]',
 NULL, NULL, NULL, NULL,
 '(i) MPC = Change in Consumption / Change in Income. (460 - 400) / (580 - 500) = 60 / 80 = 0.75. (ii) Multiplier formula = 1 / (1 - MPC). 1 / (1 - 0.75) = 1 / 0.25 = 4.',
 'Award 2 marks for the correct MPC calculation and 2 marks for the correct multiplier calculation.',
 'SHORT_ANSWER', 'MEDIUM', g10, 1),

-- (b) Theory (Circular Flow)
(v_econ_id, v_dr_p, NULL,
 '(b) Explain the difference between an "injection" and a "withdrawal" in the circular flow of income, providing one example of each from Text A. [4]',
 NULL, NULL, NULL, NULL,
 'An injection is an exogenous addition to the circular flow of income that increases AD. Examples from Text A include Investment (I) or Government Spending (G). A withdrawal (or leakage) is a diversion of income away from the circular flow that reduces AD. Examples from Text A include Savings (S), Taxes (T), or Imports (M).',
 'Award 2 marks for definitions. Award 2 marks for correct examples from the text.',
 'SHORT_ANSWER', 'EASY', g10, 2),

-- (c) Mechanism Analysis
(v_econ_id, v_dr_p, NULL,
 '(c) With reference to Text B, explain how a high Marginal Propensity to Import (MPM) affects the size of the multiplier. [4]',
 NULL, NULL, NULL, NULL,
 'The multiplier effect depends on money remaining within the domestic economy to create further rounds of spending. A high MPM means that a large portion of any increase in income is spent on foreign goods rather than domestic ones. This constitutes a "leakage" from the domestic circular flow, reducing the amount of money available for subsequent rounds of domestic spending, thereby lowering the final value of the multiplier.',
 'Award 2 marks for defining MPM as a leakage. Award 2 marks for explaining how leakages diminish the rounds of spending.',
 'SHORT_ANSWER', 'MEDIUM', g10, 3),

-- (d) AD/AS Application
(v_econ_id, v_dr_p, NULL,
 '(d) Analyse the effect of a fall in "animal spirits" (business confidence) on the equilibrium level of national income. Use an AD/AS diagram to support your answer. [6]',
 NULL, NULL, NULL, NULL,
 'A fall in business confidence (animal spirits) leads to a reduction in planned Investment (I). Since Investment is a component of AD (AD = C+I+G+X-M), the AD curve will shift to the left. On an AD/AS diagram, this shift results in a decrease in the equilibrium level of real national output (Y1 to Y2) and a fall in the general price level (P1 to P2), potentially leading to a recessionary gap.',
 'Award 2 marks for the diagram (AD shift left). Award 2 marks for the link between confidence and investment. Award 2 marks for the impact on output and price level.',
 'SHORT_ANSWER', 'MEDIUM', g10, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that increasing government spending is more effective than cutting taxes as a way to stimulate an economy. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: Government spending (G) is a direct injection into AD, whereas tax cuts rely on households choosing to spend. If the MPC is low, a tax cut might be saved rather than spent (Text B). Spending on infrastructure can also have supply-side benefits, increasing LRAS. AGAINST: (1) Time Lags: Infrastructure projects take years to implement. (2) Crowding Out: Increased G may lead to higher interest rates, reducing private I. (3) Inefficiency: Tax cuts allow the market/consumers to decide where resources go, which may be more efficient than government-directed spending. EVALUATION: The "best" policy depends on the state of the economy. In a deep recession with low confidence, direct G might be necessary to jumpstart the multiplier. However, if the goal is long-term efficiency and the MPW is high, tax reforms to incentivize domestic production might be more sustainable.',
 'Band 1 (7–8): Balanced evaluation of G vs. T. References the multiplier and MPC. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of fiscal policy. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g10, 5);

-- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 11: Price Controls and Indirect Taxation
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 11 — Government Intervention in the Sugar Market',
'Read the following information carefully before answering the questions.

TEXT A: The Rationale for a Sugar Tax

In response to rising rates of obesity and type-2 diabetes, several governments have introduced a "Sugar Tax"—an indirect excise tax on sugar-sweetened beverages. From an economic perspective, sugary drinks are considered "demerit goods" because they create negative externalities in consumption, such as increased healthcare costs for the public health system. 

The effectiveness of such a tax depends heavily on the Price Elasticity of Demand (PED). If demand is inelastic, consumers will continue to purchase the drinks despite the price increase, and the primary result will be higher tax revenue for the government rather than a significant reduction in consumption. Furthermore, the "incidence of the tax" depends on the relative elasticities of supply and demand. If demand is more inelastic than supply, the consumer will bear the majority of the tax burden in the form of higher prices.

TABLE 12: Market Data for Soft Drinks (Country S)

Year | Average Price ($/Litre) | Quantity Consumed (m Litres) | Tax Revenue ($m) | Obesity Rate (%)
2020 | 1.20                    | 500                         | 0               | 22.5
2021 | 1.50                    | 480                         | 120             | 22.8
2022 | 1.55                    | 475                         | 125             | 22.4
2023 | 1.80* | 410                         | 180             | 21.9
2024 | 1.85                    | 405                         | 185             | 21.5
*Note: A significant tax increase was implemented in 2023.

TEXT B: Maximum Prices and the "Black Market"

As part of a wider "Healthy Living" initiative, the government of Country S also considered imposing a Maximum Price (Price Ceiling) on fresh fruit and vegetables to make healthy food more affordable for low-income households. 

However, economists warned that if the maximum price is set below the natural market equilibrium, it would lead to a shortage (excess demand). Producers might find it less profitable to supply fresh produce, leading to "empty shelves" in supermarkets. This often results in the emergence of a "black market" or informal economy, where goods are sold illegally at prices much higher than the government-mandated limit. Instead of price controls, some suggested that a subsidy for farmers would be more effective at increasing the quantity supplied and reducing the market price without causing shortages.',11) RETURNING id INTO g11;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Calculation (PED)
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Calculate the Price Elasticity of Demand (PED) for soft drinks between 2020 and 2021. [2]
  (ii) State, giving a reason, whether the demand for soft drinks in Country S is elastic or inelastic. [2]',
 NULL, NULL, NULL, NULL,
 '(i) PED = % Change in Quantity Demanded / % Change in Price. %ΔQD = (480-500)/500 = -4%. %ΔP = (1.50-1.20)/1.20 = +25%. PED = -4 / 25 = -0.16. (ii) The demand is inelastic because the absolute value of PED (0.16) is less than 1. This means consumers are relatively unresponsive to price changes.',
 'Award 2 marks for the correct PED calculation and 2 marks for the correct identification of elasticity with a valid reason.',
 'SHORT_ANSWER', 'MEDIUM', g11, 1),

-- (b) Theory (Tax Incidence)
(v_econ_id, v_dr_p, NULL,
 '(b) Use a demand and supply diagram to show the effect of an indirect tax on the market for soft drinks. Identify the area representing the tax burden on the consumer. [6]',
 NULL, NULL, NULL, NULL,
 'The diagram should show an upward/leftward shift of the supply curve (S to S+tax). This leads to a higher equilibrium price (P1 to P2) and a lower quantity (Q1 to Q2). Because demand for demerit goods is often inelastic, the demand curve should be drawn steeply. The tax burden on the consumer is the rectangle formed by the price increase (P2 - P1) multiplied by the new quantity (Q2).',
 'Award 2 marks for the correct diagram with a supply shift. Award 2 marks for showing the new equilibrium. Award 2 marks for correctly identifying the consumer tax incidence area.',
 'SHORT_ANSWER', 'MEDIUM', g11, 2),

-- (c) Mechanism (Maximum Price)
(v_econ_id, v_dr_p, NULL,
 '(c) With the aid of a diagram, explain how a Maximum Price on fresh vegetables could lead to a shortage in the market. [4]',
 NULL, NULL, NULL, NULL,
 'A maximum price diagram must show the price ceiling (Pmax) drawn BELOW the equilibrium price. At this lower price, the quantity demanded (Qd) by consumers exceeds the quantity supplied (Qs) by producers. The horizontal distance between Qd and Qs represents the shortage or "excess demand."',
 'Award 2 marks for a correct diagram showing Pmax below equilibrium. Award 2 marks for explaining the gap between Qs and Qd.',
 'SHORT_ANSWER', 'MEDIUM', g11, 3),

-- (d) Concept Analysis (Black Markets)
(v_econ_id, v_dr_p, NULL,
 '(d) Explain why a "black market" might emerge following the imposition of a maximum price. [4]',
 NULL, NULL, NULL, NULL,
 'A black market emerges because the government-imposed maximum price creates a shortage where many consumers are willing to pay more than the legal limit to secure the scarce good. Since producers cannot legally raise prices in stores, "underground" trading occurs where the good is sold at a higher, non-regulated price to those with the highest marginal benefit, often bypassing the law to satisfy the excess demand.',
 'Award 2 marks for linking the shortage to consumer willingness to pay. Award 2 marks for explaining the illegal price increase as a response to scarcity.',
 'SHORT_ANSWER', 'MEDIUM', g11, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that subsidies for "merit goods" are more effective than taxes on "demerit goods" in improving the health of a nation. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: Subsidies on fresh food (merit goods) reduce prices and increase consumption without the "regressive" impact of a sugar tax, which hits low-income families harder. It encourages positive externalities. AGAINST: (1) Opportunity Cost: Subsidies require government funding/revenue, whereas taxes generate it (as seen in the $185m revenue in Table 12). (2) Elasticity: If demand for healthy food is inelastic, a subsidy might not actually increase consumption much. (3) Effectiveness: A sugar tax directly targets the cause of health issues (demerit goods), whereas a subsidy only offers an alternative. EVALUATION: Neither policy is a "silver bullet." A sugar tax is effective at raising revenue and discouraging bad habits, but it can be socially unfair. A subsidy is popular but expensive. Most economists argue for a "revenue-neutral" approach where the money raised from the sugar tax is used to fund the fresh food subsidy.',
 'Band 1 (7–8): Balanced evaluation of taxes vs. subsidies. References Table 12 and Text B. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of intervention. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g11, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 12: Measuring and Managing Inflation
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 12 — The Dynamics of the Price Level',
'Read the following information carefully before answering the questions.

TEXT A: The Mechanics of the Consumer Price Index (CPI)

The Consumer Price Index (CPI) is the primary measure of inflation used by governments to monitor changes in the cost of living. It is calculated by tracking the price changes of a "representative basket of goods and services" consumed by the average household. Because consumers spend more of their income on certain items than others, each category in the basket is assigned a specific "weight." For example, a 10% increase in the price of food will have a much larger impact on the total CPI than a 10% increase in the price of cinema tickets.

To ensure the CPI remains accurate, the weights and the contents of the basket are updated annually to reflect changing consumer tastes, such as the shift from physical DVDs to digital streaming services. However, the CPI has limitations: it represents the "average" household and may not accurately reflect the inflation experienced by specific groups, such as the elderly or low-income families, who spend a higher proportion of their income on essentials like heating and bread.

TABLE 13: Price Indices and Weights for Country R (Base Year 2020 = 100)

Category        | Weight | Price Index 2022 | Price Index 2024
Food & Drink    | 300    | 110              | 125
Housing & Fuel  | 400    | 115              | 140
Transport       | 200    | 105              | 112
Other Services  | 100    | 102              | 108
TOTAL           | 1000   | ?                | ?

TEXT B: The Redistributive Effects of Inflation

In 2024, Country R experienced a significant spike in the price of "Housing & Fuel" due to a disruption in global energy supplies. While the government maintained its inflation target of 2%, the actual CPI inflation rate climbed much higher. 

This unexpected inflation led to a redistribution of income within the economy. Workers with weak bargaining power found that their nominal wages remained frozen, leading to a fall in their real wages. Meanwhile, debtors (borrowers) benefited as the real value of their outstanding debt decreased. Conversely, the "shoe-leather costs"—the time and effort people spend searching for the lowest prices—and "menu costs"—the cost to firms of constantly updating price lists—began to drag on economic efficiency. The Central Bank warned that if inflation expectations became "unanchored," a wage-price spiral could develop, making it even harder to return to the 2% target.',12) RETURNING id INTO g12;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Quantitative Calculation (Weighted Index)
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Using Table 13, calculate the weighted CPI for Country R in 2022. [3]
  (ii) Calculate the percentage change in the price of "Housing & Fuel" between 2022 and 2024. [2]',
 NULL, NULL, NULL, NULL,
 '(i) Weighted Index = Σ (Index × Weight) / Σ Weights. 2022: [(110 × 300) + (115 × 400) + (105 × 200) + (102 × 100)] / 1000 = [33,000 + 46,000 + 21,000 + 10,200] / 1000 = 110,200 / 1000 = 110.2. (ii) % Change = (New - Old) / Old × 100. (140 - 115) / 115 × 100 = 25 / 115 × 100 = 21.7%.',
 'Award 3 marks for the correct weighted average calculation in (i) and 2 marks for the correct percentage change in (ii).',
 'SHORT_ANSWER', 'HARD', g12, 1),

-- (b) Theory (Nominal vs. Real)
(v_econ_id, v_dr_p, NULL,
 '(b) Explain how it is possible for a worker’s nominal wage to increase while their real wage decreases. [4]',
 NULL, NULL, NULL, NULL,
 'The nominal wage is the face value of the money earned (e.g., $500 per week), while the real wage is the nominal wage adjusted for inflation, representing purchasing power. If a worker receives a 3% increase in their nominal wage, but the CPI inflation rate is 10%, the cost of living has risen faster than their earnings. Therefore, the worker can afford fewer goods and services than before, meaning their real wage has decreased despite the nominal increase.',
 'Award 2 marks for the distinction between nominal and real. Award 2 marks for the explanation using a comparison between wage growth and inflation rate.',
 'SHORT_ANSWER', 'MEDIUM', g12, 2),

-- (c) Mechanism (Wage-Price Spiral)
(v_econ_id, v_dr_p, NULL,
 '(c) With reference to Text B, explain how a "wage-price spiral" is created. [4]',
 NULL, NULL, NULL, NULL,
 'A wage-price spiral begins when high inflation leads workers to demand higher nominal wages to protect their real income. If firms grant these wage increases, their production costs rise. To maintain profit margins, firms then raise the prices of their goods and services. This increase in the price level leads workers to demand even higher wages in the next round, creating a continuous cycle of rising costs and prices.',
 'Award 2 marks for linking wage demands to inflation expectations. Award 2 marks for linking higher wages to firm costs and subsequent price increases.',
 'SHORT_ANSWER', 'MEDIUM', g12, 3),

-- (d) Concept Analysis (Redistribution)
(v_econ_id, v_dr_p, NULL,
 '(d) Explain why debtors (borrowers) tend to benefit from high inflation while creditors (lenders) tend to lose. [4]',
 NULL, NULL, NULL, NULL,
 'Inflation reduces the purchasing power of money over time. When a debtor repays a loan during a period of high inflation, they are paying back the debt with money that is worth less than when they originally borrowed it. For the creditor, the real value of the interest and principal they receive is lower than expected, resulting in a fall in the real rate of return on their investment.',
 'Award 2 marks for the impact on the debtor (lower real value of repayment). Award 2 marks for the impact on the creditor (lower real return).',
 'SHORT_ANSWER', 'MEDIUM', g12, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that the Consumer Price Index (CPI) is a completely reliable measure of the cost of living for all households in an economy. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: The CPI is a standardized, objective measure based on a huge sample of prices, allowing for easy comparisons over time and between countries. It is regularly updated (Text A) to remain relevant to modern spending habits. AGAINST: (1) Basket Composition: As Text A notes, it reflects an "average" household. A low-income family spends a much higher proportion of their income on "Housing & Fuel" (which rose by 21.7% in the data), making their personal inflation rate higher than the national CPI. (2) Quality Bias: Improvements in product quality (e.g., smartphones) are hard to distinguish from simple price rises. (3) Substitution Bias: Consumers often switch to cheaper brands when prices rise, but the CPI basket may not capture this shift immediately. EVALUATION: While the CPI is a highly effective tool for general macroeconomic policy, it is an imperfect measure of individual welfare. It is a reliable "general indicator," but must be used alongside other data—such as the Producer Price Index or group-specific indices—to truly understand the impact of inflation on different social classes.',
 'Band 1 (7–8): Balanced evaluation of CPI strengths and weaknesses. Specific reference to the data in Table 13 and Text A. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of CPI. Band 4 (1–2): Basic definition.',
 'ESSAY', 'HARD', g12, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 13: Economic Growth and Standards of Living
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 13 — Measuring Development: GDP vs HDI',
'Read the following information carefully before answering the questions.

TEXT A: Limitations of GDP as a Measure of Welfare

Gross Domestic Product (GDP) measures the total market value of all final goods and services produced within a country in a given period. While GDP per capita is often used as a proxy for the standard of living, economists have long recognized its limitations. GDP does not account for the distribution of income, the quality of the environment, or "non-market" activities such as subsistence farming and volunteer work.

To provide a more holistic view of development, the United Nations uses the Human Development Index (HDI). The HDI is a composite index that combines three dimensions: health (life expectancy at birth), education (mean and expected years of schooling), and standard of living (GNI per capita at purchasing power parity). A country may have a high GDP due to natural resource extraction but a low HDI if its wealth is not reinvested in healthcare and schools. Furthermore, GDP fails to capture the "hidden economy" and the negative externalities of production, such as pollution, which can reduce the long-term sustainability of growth.

TABLE 14: Development Indicators (2024 Estimates)

Country   | GDP per Capita ($) | Life Expectancy (Years) | Adult Literacy (%) | HDI Rank (of 190)
Country M | 42,500             | 72.5                    | 88.0               | 65
Country N | 18,200             | 81.4                    | 99.2               | 32
Country O | 3,100              | 58.2                    | 62.5               | 158
Country P | 65,000             | 76.8                    | 94.0               | 41

TEXT B: The "Middle-Income Trap" and Structural Change

Country N is currently being studied by international organizations for its unique development trajectory. Despite having a much lower GDP per capita than Country M or Country P, it ranks significantly higher on the HDI scale. This is attributed to the government’s long-term "Inclusion Strategy," which prioritizes universal primary healthcare and high-quality vocational training.

However, Country N faces the "middle-income trap." As wages rise, it is losing its comparative advantage in low-cost manufacturing to countries like Country O. To continue growing, it must transition into high-value services and technology. This requires massive investment in Research and Development (R&D) and digital infrastructure. Critics argue that the heavy taxes required to fund Country N’s social programs may eventually discourage the very private sector investment needed for this structural shift. Proponents, however, point out that a healthy and educated workforce is the most valuable "supply-side" asset a nation can possess.',13) RETURNING id INTO g13;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Comparison (GDP vs HDI)
(v_econ_id, v_dr_p, NULL,
 '(a) (i) Using Table 14, identify which country has the highest "Standard of Living" according to GDP per capita and which has the highest according to the HDI rank. [2]
  (ii) Explain one reason why Country N has a better HDI rank than Country P, despite having a much lower GDP per capita. [2]',
 NULL, NULL, NULL, NULL,
 '(i) Country P has the highest GDP per capita ($65,000), while Country N has the highest standard of living according to HDI rank (ranked 32nd). (ii) HDI is a composite index; Table 14 shows Country N significantly outperforms Country P in life expectancy (81.4 vs 76.8 years) and adult literacy (99.2% vs 94.0%). This suggests Country N invests more effectively in health and education, which are key components of the HDI.',
 'Award 1 mark for each correct identification in (i). Award 2 marks for using specific data (life expectancy/literacy) to explain the HDI difference in (ii).',
 'SHORT_ANSWER', 'EASY', g13, 1),

-- (b) Theory (Hidden Economy)
(v_econ_id, v_dr_p, NULL,
 '(b) Explain why the existence of a "hidden economy" makes GDP an unreliable measure of economic activity in developing nations like Country O. [4]',
 NULL, NULL, NULL, NULL,
 'The hidden (or informal) economy consists of legal and illegal activities that are not reported to the government for tax purposes, such as street vending or subsistence farming. In developing nations like Country O, a large portion of the population may rely on these non-market activities. Since GDP only counts official transactions, it significantly underestimates the actual level of production and income within the country, making it an inaccurate reflection of total economic activity.',
 'Award 2 marks for defining the hidden/informal economy. Award 2 marks for explaining why it leads to an underestimation of GDP in a developing context.',
 'SHORT_ANSWER', 'MEDIUM', g13, 2),

-- (c) Mechanism (Purchasing Power Parity)
(v_econ_id, v_dr_p, NULL,
 '(c) Define "Purchasing Power Parity" (PPP) and explain its importance when comparing the GDP of different countries. [4]',
 NULL, NULL, NULL, NULL,
 'Purchasing Power Parity (PPP) is an exchange rate adjustment that accounts for the differences in the cost of living between countries. It measures how much of a common "basket of goods" a currency can buy in different nations. It is important because a dollar goes further in a country with low prices (like Country O) than in a country with high prices. Using PPP allows for a fairer comparison of real living standards rather than just comparing nominal incomes at market exchange rates.',
 'Award 2 marks for the definition involving cost of living/basket of goods. Award 2 marks for the importance of comparing real purchasing power.',
 'SHORT_ANSWER', 'MEDIUM', g13, 3),

-- (d) Concept Analysis (Opportunity Cost)
(v_econ_id, v_dr_p, NULL,
 '(d) Analyse the opportunity cost for Country N’s government of prioritizing healthcare and education over Research and Development (R&D). [4]',
 NULL, NULL, NULL, NULL,
 'Opportunity cost is the value of the next best alternative foregone. By allocating tax revenue to healthcare and education to maintain its high HDI, the government of Country N is unable to use those same funds for R&D or digital infrastructure. As noted in Text B, this may prevent the structural shift needed to escape the "middle-income trap," potentially leading to slower long-term GDP growth and a loss of global competitiveness.',
 'Award 2 marks for the definition/application of opportunity cost. Award 2 marks for linking the lack of R&D to the middle-income trap or structural change.',
 'SHORT_ANSWER', 'MEDIUM', g13, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that the Human Development Index (HDI) is a better indicator of economic progress than the growth rate of Real GDP. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: HDI is a broader measure that captures essential qualitative improvements in life, such as health and literacy, which GDP ignores. It highlights when growth is "hollow" (e.g., Country P), where high income doesn''t translate to better social outcomes. It encourages governments to focus on long-term human capital. AGAINST: (1) Complexity: HDI is harder to calculate and less frequent than GDP data. (2) Narrowness: It still ignores factors like political freedom, inequality (Gini coefficient), and environmental sustainability. (3) Correlation: In many cases, high GDP growth provides the tax revenue needed to improve HDI, so GDP remains the primary engine. EVALUATION: HDI is a superior measure of "well-being" and development, but Real GDP remains the best measure of "economic activity" and productive capacity. Most economists agree that both should be used together; GDP tells us how much a country *can* do, while HDI tells us what a country *is actually doing* for its citizens.',
 'Band 1 (7–8): Balanced evaluation of HDI vs. GDP. References Table 14 data and Text A limitations. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of the two measures. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g13, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 14: Fiscal Policy and Public Finance
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 14 — Taxation, Spending, and the Budget',
'Read the following information carefully before answering the questions.

TEXT A: The Structure of Taxation and Government Expenditure

Governments utilize fiscal policy to influence the level of Aggregate Demand (AD) and to achieve socio-economic objectives, such as income redistribution. Taxation is broadly categorized into direct taxes, which are levied on income and wealth (e.g., Personal Income Tax, Corporation Tax), and indirect taxes, which are levied on spending (e.g., Value Added Tax, Excise Duties). 

A progressive tax system is one where the marginal rate of tax increases as income rises, aiming to reduce vertical inequity. Conversely, many indirect taxes are criticized for being regressive, as they take a higher percentage of income from low-income earners than from high-income earners. On the expenditure side, government spending can be classified as current expenditure (day-to-day running costs like salaries) and capital expenditure (investment in long-term assets like roads and hospitals). When total government spending exceeds total tax revenue in a single year, the government runs a budget deficit, which must be financed through borrowing, adding to the national debt.

TABLE 15: Fiscal Indicators for Country Q ($ billions)

Year | Direct Tax Revenue | Indirect Tax Revenue | Gov. Expenditure | Real GDP Growth (%)
2020 | 120                | 80                   | 250              | -3.2
2021 | 135                | 90                   | 260              | 2.1
2022 | 145                | 105                  | 275              | 3.5
2023 | 160                | 115                  | 285              | 2.8
2024 | 175                | 120                  | 290              | 2.4

TEXT B: The Dilemma of Deficit Reduction

Following the recession in 2020, Country Q saw its budget deficit widen significantly as the government implemented an expansionary fiscal stance to support households. By 2024, although the economy had recovered, the accumulated national debt had reached record levels. 

The Finance Minister is now facing a "fiscal squeeze." To reduce the deficit, the government is considering "austerity measures"—a combination of cutting capital expenditure and increasing the standard rate of indirect tax. Critics argue that cutting capital spending will damage the economy’s long-run aggregate supply (LRAS) and that raising indirect taxes will fuel cost-push inflation. Furthermore, there is concern that if the government continues to borrow heavily from domestic markets, it will lead to a rise in interest rates, further discouraging private sector investment and slowing down the 2.4% GDP growth rate.', 14) RETURNING id INTO g14;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Calculation (Budget Deficit)
(v_econ_id, v_dr_p, NULL, 
 '(a) (i) Using Table 15, calculate the budget deficit for Country Q in 2020 and 2024. [2]
  (ii) Describe the trend in total tax revenue relative to government expenditure over the period shown. [2]',
 NULL, NULL, NULL, NULL,
 '(i) Budget Deficit = Gov. Expenditure - (Direct Tax + Indirect Tax). 2020: 250 - (120 + 80) = $50bn. 2024: 290 - (175 + 120) = -($5bn) or a $5bn surplus. (ii) Total tax revenue has grown faster than government expenditure. Revenue rose from $200bn to $295bn (a 47.5% increase), while expenditure rose from $250bn to $290bn (a 16% increase), causing the deficit to shrink and eventually turn into a small surplus by 2024.',
 'Award 1 mark for each correct deficit calculation in (i). Award 2 marks for describing the narrowing deficit with data points in (ii).',
 'SHORT_ANSWER', 'MEDIUM', g14, 1),

-- (b) Theory (Direct vs Indirect)
(v_econ_id, v_dr_p, NULL,
 '(b) Distinguish between a direct tax and an indirect tax, providing one example of each from Text A. [4]',
 NULL, NULL, NULL, NULL,
 'A direct tax is levied directly on an individual or organization’s income or wealth and cannot be shifted to another person; an example from Text A is Personal Income Tax or Corporation Tax. An indirect tax is levied on the sale of goods and services and can be shifted from the producer to the consumer; an example from Text A is Value Added Tax (VAT) or Excise Duties.',
 'Award 2 marks for the distinction regarding the ability to shift the tax. Award 2 marks for correct examples from the text.',
 'SHORT_ANSWER', 'EASY', g14, 2),

-- (c) Mechanism (Regressive Taxation)
(v_econ_id, v_dr_p, NULL,
 '(c) Explain why an increase in the standard rate of indirect tax might be considered "regressive." [4]',
 NULL, NULL, NULL, NULL,
 'A regressive tax is one where the proportion of income paid in tax falls as income rises. Indirect taxes are usually flat-rate charges on goods. Since low-income earners spend a much larger proportion of their total income on consumption than high-income earners (who save more), a tax on spending takes a larger percentage of a poor person’s total income, thus worsening income inequality.',
 'Award 2 marks for the definition of a regressive tax. Award 2 marks for explaining why it affects low-income earners more in terms of percentage of income.',
 'SHORT_ANSWER', 'MEDIUM', g14, 3),

-- (d) AD/AS Application (Capital Expenditure)
(v_econ_id, v_dr_p, NULL,
 '(d) Analyse the effect of a cut in capital expenditure on an economy’s Long-Run Aggregate Supply (LRAS). [4]',
 NULL, NULL, NULL, NULL,
 'Capital expenditure refers to investment in infrastructure, such as roads, hospitals, and telecommunications. These investments increase the productive capacity and efficiency of an economy. A cut in this spending means that the quality or quantity of the nation’s capital stock will stagnate or decline over time. Consequently, the LRAS curve will fail to shift to the right (or may shift left), leading to lower potential economic growth in the future.',
 'Award 2 marks for identifying capital expenditure as a driver of productive capacity. Award 2 marks for the impact on the LRAS curve and potential growth.',
 'SHORT_ANSWER', 'MEDIUM', g14, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that a government should always prioritize a balanced budget over economic growth. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: A balanced budget prevents the accumulation of national debt and avoids "crowding out" the private sector through high interest rates (Text B). It maintains international investor confidence and prevents future generations from being burdened by debt repayment. AGAINST: (1) Recessionary Gap: During a downturn (like 2020 in the data), a budget deficit is necessary to provide a stimulus to AD and prevent high unemployment. (2) Multiplier Effect: Government spending can lead to a more-than-proportionate increase in GDP, which eventually increases tax revenue. (3) Supply-side Benefits: Deficit-funded capital spending can increase LRAS. EVALUATION: The "best" approach is often cyclical. In a recession, growth should be the priority (expansionary fiscal policy), while in periods of stable growth (like 2022-2024), the government should move toward a balanced budget or surplus to ensure long-term fiscal sustainability. A rigid "always" approach is likely to worsen economic downturns.',
 'Band 1 (7–8): Balanced evaluation of fiscal objectives. Specific reference to the data and trade-offs. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of the budget. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g14, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 15: Balance of Payments and the J-Curve
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 15 — Trade Deficits and Currency Fluctuations',
'Read the following information carefully before answering the questions.

TEXT A: The Components of the Balance of Payments

The Balance of Payments (BoP) is a record of all economic transactions between the residents of a country and the rest of the world. It is divided into the Current Account, the Capital Account, and the Financial Account. The Current Account is the most widely monitored, consisting of the trade in goods (visibles), the trade in services (invisibles), primary income (e.g., profit and interest from overseas investments), and secondary income (e.g., workers'' remittances and foreign aid).

A persistent Current Account deficit occurs when a country’s total debits (outflows) exceed its total credits (inflows). While a deficit can allow residents to enjoy a higher standard of living by consuming more than they produce, it must be financed by a surplus on the Financial Account, often through foreign direct investment (FDI) or by increasing external debt. Long-term deficits may signal a lack of international competitiveness, particularly if the deficit is driven by a structural decline in the manufacturing sector.

TABLE 16: Balance of Payments Data for Country Z ($ billions)

Year | Trade in Goods | Trade in Services | Net Primary Income | Current Account Balance
2020 | -85            | +25               | -10                | -70
2021 | -90            | +30               | -12                | -72
2022 | -110           | +35               | -15                | -90
2023 | -125           | +40               | -18                | -103
2024 | -105           | +45               | -20                | -80

TEXT B: Currency Depreciation and the J-Curve Effect

In late 2023, the government of Country Z allowed its currency to depreciate by 15% against its major trading partners to correct the widening $103bn Current Account deficit. Initially, however, the deficit continued to worsen, reaching a peak before finally beginning to narrow in mid-2024 (as seen in Table 16). 

Economists explain this phenomenon using the J-Curve effect. In the short run, the trade balance often deteriorates following a depreciation because the price elasticity of demand (PED) for both imports and exports is inelastic. Consumers and firms have pre-existing contracts and cannot immediately switch to cheaper domestic substitutes or find new export markets. Therefore, the total value of imports rises (as they are now more expensive in local currency) while export revenue remains stagnant. Over time, as elasticities increase and the Marshall-Lerner condition is met, the trade balance improves. However, critics point out that if the depreciation leads to significant "imported inflation," any competitive gains may be quickly eroded by rising domestic production costs.',15) RETURNING id INTO g15;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Calculation and Comparison
(v_econ_id, v_dr_p, NULL, 
 '(a) (i) Using Table 16, calculate the value of "Secondary Income" for Country Z in 2024, assuming the Current Account balance is -80. [2]
  (ii) Compare the performance of the "Trade in Goods" with the "Trade in Services" between 2020 and 2024. [2]',
 NULL, NULL, NULL, NULL,
 '(i) Current Account = Goods + Services + Primary Income + Secondary Income. -80 = -105 + 45 - 20 + X. -80 = -80 + X. Therefore, Secondary Income = 0. (ii) The Trade in Goods has remained in a consistent and large deficit, which peaked at -$125bn in 2023 before improving. In contrast, the Trade in Services has maintained a consistent and growing surplus, rising from +$25bn to +$45bn over the period.',
 'Award 1 mark for the correct calculation method and 1 mark for the result in (i). Award 2 marks for the comparative description with data points in (ii).',
 'SHORT_ANSWER', 'MEDIUM', g15, 1),

-- (b) Theory (BoP Components)
(v_econ_id, v_dr_p, NULL,
 '(b) Distinguish between "Primary Income" and "Secondary Income" as components of the Current Account. [4]',
 NULL, NULL, NULL, NULL,
 'Primary income (formerly called income) refers to the flows of money resulting from the ownership of factors of production, such as profits, dividends, and interest earned on assets held abroad. Secondary income (formerly called current transfers) refers to transactions where there is no corresponding exchange of a good or service, such as government payments for foreign aid, international gifts, or workers sending remittances back to their home country.',
 'Award 2 marks for the definition and examples of primary income. Award 2 marks for the definition and examples of secondary income.',
 'SHORT_ANSWER', 'MEDIUM', g15, 2),

-- (c) Mechanism Analysis (J-Curve)
(v_econ_id, v_dr_p, NULL,
 '(c) With the aid of a diagram, explain the "J-Curve effect" following a currency depreciation. [6]',
 NULL, NULL, NULL, NULL,
 'The diagram should show the time on the x-axis and the Current Account balance on the y-axis, with a curve that initially dips below the starting point before rising above it. The explanation should state that in the short run, the trade balance worsens (the dip) because demand is price inelastic (contracts/habits). In the long run, as consumers and firms adjust, demand becomes more elastic, the Marshall-Lerner condition is satisfied, and the trade balance improves (the rise).',
 'Award 2 marks for a correctly labeled J-Curve diagram. Award 2 marks for explaining the short-run deterioration (inelasticity). Award 2 marks for explaining the long-run improvement (elasticity/Marshall-Lerner).',
 'SHORT_ANSWER', 'HARD', g15, 3),

-- (d) Concept Analysis (Competitive Gains)
(v_econ_id, v_dr_p, NULL,
 '(d) Explain why "imported inflation" might erode the competitive gains of a currency depreciation. [4]',
 NULL, NULL, NULL, NULL,
 'Depreciation makes imported raw materials and energy more expensive in local currency. If a country relies heavily on these imports for production, its domestic costs of production will rise. This leads to cost-push inflation. As domestic prices rise, the initial price advantage that exports gained from the depreciation is neutralized, making exports less competitive again on the global market.',
 'Award 2 marks for linking depreciation to higher import costs/cost-push inflation. Award 2 marks for linking inflation to the loss of export price competitiveness.',
 'SHORT_ANSWER', 'MEDIUM', g15, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate the view that a persistent Current Account deficit is always a sign of economic weakness. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: A persistent deficit suggests a lack of structural competitiveness in the goods sector (as seen in Table 16) and a reliance on foreign capital to finance consumption. It can lead to a build-up of external debt and a vulnerability to "capital flight" if foreign investors lose confidence. AGAINST: (1) Investment-led: If the deficit is caused by importing capital goods (machinery/tech), it could increase future LRAS and growth. (2) Standard of Living: It allows for higher consumption than current production. (3) Service Sector Strength: A deficit in goods may be offset by a growing surplus in services (Text B). EVALUATION: Whether a deficit is a "weakness" depends on its cause. A deficit driven by high consumption and low savings is a sign of weakness; however, a deficit driven by a surge in FDI and capital imports for a developing nation can be a sign of future strength and transition.',
 'Band 1 (7–8): Balanced evaluation of BoP deficits. Specific reference to Country Z’s goods vs. services data. Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of the Current Account. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g15, 5);

 -- ══════════════════════════════════════════════════════════
-- DATA RESPONSE 16: Exchange Rate Systems and Stability
-- ══════════════════════════════════════════════════════════
INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
VALUES (v_dr_p, 'Data Response 16 — Exchange Rate Management and the Macroeconomy',
'Read the following information carefully before answering the questions.

TEXT A: Floating vs Fixed Exchange Rate Systems

The exchange rate is the price of one currency in terms of another. In a freely floating exchange rate system, the value of the currency is determined solely by the market forces of demand and supply. Factors such as relative inflation rates, interest rates, and the demand for a country’s exports determine its strength. The primary advantage of a floating system is that it allows the exchange rate to act as an automatic stabilizer for the Balance of Payments.

In contrast, some nations opt for a fixed (or pegged) exchange rate, where the government or Central Bank maintains the currency’s value against another major currency or a basket of currencies. This provides certainty for international trade and reduces "exchange rate risk" for investors. However, maintaining a fixed rate requires the Central Bank to hold significant foreign currency reserves and may force the government to use interest rates to manage the currency rather than domestic inflation or unemployment. A formal increase in the value of a fixed currency is known as a revaluation, while a decrease is called a devaluation.

TABLE 17: Exchange Rate and Monetary Data (Country K)

Year | Exchange Rate ($ per 1K) | Foreign Reserves ($bn) | Interest Rate (%) | Inflation Rate (%)
2020 | 0.50 (Fixed)             | 45                     | 2.0               | 2.5
2021 | 0.50 (Fixed)             | 38                     | 3.5               | 4.1
2022 | 0.40 (Devalued)          | 30                     | 5.0               | 6.8
2023 | 0.42 (Floating)          | 32                     | 4.5               | 5.2
2024 | 0.45 (Floating)          | 35                     | 4.0               | 3.8

TEXT B: The Transition to a Floating Regime in Country K

For years, Country K maintained a fixed peg of $0.50 per 1K. However, by 2021, high domestic inflation made Country K’s exports less competitive, leading to a massive outflow of capital. To defend the peg, the Central Bank was forced to sell its foreign reserves and raise interest rates to 3.5%. Despite these efforts, the pressure became unsustainable, and in 2022, the government devalued the currency to $0.40 before finally allowing it to float freely in 2023.

Since adopting the floating system, the currency has seen a modest appreciation to $0.45. Proponents argue that the Central Bank is now free to focus on lowering interest rates to support the 3.8% inflation target. However, importers of essential raw materials have complained that the volatility of the floating rate makes long-term planning difficult. Economists note that the recent appreciation was likely driven by an improvement in the "Terms of Trade" and a surge in demand for Country K’s high-tech manufacturing exports.',16) RETURNING id INTO g16;

INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                    correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
VALUES

-- (a) Data Interpretation
(v_econ_id, v_dr_p, NULL, 
 '(a) (i) Using Table 17, calculate the percentage devaluation of Country K’s currency between 2021 and 2022. [2]
  (ii) Describe what happened to Country K’s foreign reserves while it was attempting to maintain the fixed peg between 2020 and 2022. [2]',
 NULL, NULL, NULL, NULL,
 '(i) % Change = (0.40 - 0.50) / 0.50 × 100 = -20%. (ii) While maintaining the fixed peg, foreign reserves fell consistently from $45bn in 2020 to $30bn in 2022 (a 33.3% decrease). This occurred because the Central Bank had to sell its reserves of foreign currency and buy its own currency to support the $0.50 value.',
 'Award 2 marks for correct calculation in (i). Award 2 marks for describing the falling trend with data points in (ii).',
 'SHORT_ANSWER', 'MEDIUM', g16, 1),

-- (b) Theory (Fixed vs Floating)
(v_econ_id, v_dr_p, NULL,
 '(b) Distinguish between a "devaluation" and a "depreciation" of a currency. [4]',
 NULL, NULL, NULL, NULL,
 'A devaluation is a deliberate downward adjustment of a currency’s value by the government or Central Bank within a fixed exchange rate system. A depreciation is a decrease in the value of a currency due to market forces of demand and supply within a floating exchange rate system. While both result in a weaker currency, the mechanism and the exchange rate regime differ.',
 'Award 2 marks for the definition of devaluation and its link to fixed systems. Award 2 marks for the definition of depreciation and its link to floating systems.',
 'SHORT_ANSWER', 'EASY', g16, 2),

-- (c) Mechanism (Interest Rates)
(v_econ_id, v_dr_p, NULL,
 '(c) Explain how the increase in interest rates to 5.0% in 2022 was intended to support the value of the currency. [4]',
 NULL, NULL, NULL, NULL,
 'Higher interest rates provide a higher rate of return for international investors holding assets in that currency. This attracts "hot money" inflows as investors move funds into Country K’s banks. To do this, they must buy the currency, which increases the demand for the currency on the foreign exchange market, putting upward pressure on its value and helping the Central Bank defend the rate.',
 'Award 2 marks for the "hot money" concept and higher returns. Award 2 marks for the impact on demand for the currency.',
 'SHORT_ANSWER', 'MEDIUM', g16, 3),

-- (d) Analysis (Floating as Stabilizer)
(v_econ_id, v_dr_p, NULL,
 '(d) Analyse how a floating exchange rate can act as an "automatic stabilizer" for a country with a large trade deficit. [4]',
 NULL, NULL, NULL, NULL,
 'A large trade deficit means the supply of the currency (to buy imports) exceeds the demand for it (from exports). In a floating system, this excess supply causes the currency to depreciate. As the currency weakens, exports become cheaper and more competitive abroad, while imports become more expensive for domestic consumers. This should lead to an increase in export revenue and a decrease in import expenditure, naturally narrowing the trade deficit over time without government intervention.',
 'Award 2 marks for the link between trade deficit and currency supply/depreciation. Award 2 marks for the impact on export/import competitiveness and the trade balance.',
 'SHORT_ANSWER', 'MEDIUM', g16, 4),

-- (e) Evaluation
(v_econ_id, v_dr_p, NULL,
 '(e) Evaluate whether a floating exchange rate system is always preferable to a fixed exchange rate system for a developing economy. [8]',
 NULL, NULL, NULL, NULL,
 'FOR: A floating system allows the Central Bank to use monetary policy (interest rates) to target domestic objectives like inflation (as seen in Country K in 2024) rather than defending a rate. It avoids the need for massive foreign reserves (Text A) and adjusts automatically to trade shocks. AGAINST: (1) Volatility: As noted in Text B, floating rates can be unpredictable, making long-term investment and trade planning difficult for businesses. (2) Cost-Push Inflation: A sudden depreciation can lead to "imported inflation" for essential goods. (3) Discipline: A fixed rate provides a "nominal anchor," forcing the government to keep inflation low to maintain the peg. EVALUATION: Neither is "always" better. A floating rate is often better for countries prone to external shocks or those wanting independent monetary policy. However, for a small developing economy with a high dependency on trade with a single partner, a fixed peg can provide the stability necessary to attract foreign direct investment (FDI).',
 'Band 1 (7–8): Balanced evaluation of both systems. References the data in Table 17 and specific points from Text B (interest rates/stability). Clear conclusion. Band 2 (5–6): Good discussion of pros/cons. Band 3 (3–4): Descriptive of the systems. Band 4 (1–2): Basic definitions.',
 'ESSAY', 'HARD', g16, 5);
    RAISE NOTICE 'AS Level Economics data response questions inserted — courseId = %, paperId = %', v_econ_id, v_dr_p;

END $$;
