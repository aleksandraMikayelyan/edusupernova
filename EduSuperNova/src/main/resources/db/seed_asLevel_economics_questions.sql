-- ============================================================
-- AS Level Economics (9708) — Multiple Choice Questions
-- Covers: Paper 1 (MCQ) and Paper 2 (Data Response / Essay)
-- Run once in the Supabase SQL editor after AS Level Economics courses exist.
-- ============================================================

DO $$
DECLARE
    v_econ_id   INTEGER;
    v_mcq_p     INTEGER;   -- Paper 1: Multiple Choice
    v_essay_p   INTEGER;   -- Paper 2: Data Response / Essays
BEGIN

    SELECT idcourse INTO v_econ_id
    FROM courses WHERE lower(coursename) LIKE '%as level econ%' LIMIT 1;

    IF v_econ_id IS NULL THEN
        RAISE EXCEPTION 'AS Level Economics course not found. Create it first.';
    END IF;

    SELECT idpaper INTO v_mcq_p   FROM papers WHERE idcourse = v_econ_id AND lower(papername) LIKE '%multiple choice%' LIMIT 1;
    SELECT idpaper INTO v_essay_p FROM papers WHERE idcourse = v_econ_id AND (lower(papername) LIKE '%essay%' OR lower(papername) LIKE '%data%') LIMIT 1;

    -- ══════════════════════════════════════════════════════════
    -- PAPER 1  — MULTIPLE CHOICE  (30 questions)
    -- ══════════════════════════════════════════════════════════

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty)
    VALUES

    -- ── BASIC ECONOMIC CONCEPTS ─────────────────────────────────
    (v_econ_id, v_mcq_p, NULL,
     'What is meant by the term "opportunity cost"?',
     'The value of the next best alternative foregone when a choice is made',
     'The total monetary cost of producing a good',
     'The sunk cost that cannot be recovered',
     'The additional cost of producing one more unit',
     'A',
     'Opportunity cost is the value of the best alternative sacrificed when making a choice. It is the fundamental concept behind scarcity and decision-making in economics.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_econ_id, v_mcq_p, NULL,
     'Which factor of production receives "rent" as its reward?',
     'Land', 'Labour', 'Capital', 'Enterprise',
     'A',
     'In economic theory: Land earns rent, Labour earns wages, Capital earns interest, and Enterprise earns profit.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_econ_id, v_mcq_p, NULL,
     'A production possibility frontier (PPF) shows an outward shift. Which of the following could cause this?',
     'An increase in the quantity of available resources',
     'A movement along the curve to produce more of one good',
     'Inefficient use of existing resources',
     'An increase in the price of one of the goods produced',
     'A',
     'An outward shift of the PPF represents economic growth — an increase in productive capacity caused by more resources, better technology, or improved productivity.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_econ_id, v_mcq_p, NULL,
     'A point inside the PPF indicates:',
     'Productive inefficiency — resources are not fully or efficiently used',
     'Productive efficiency — all resources are fully employed',
     'Economic growth — the economy has expanded',
     'An unattainable combination of output',
     'A',
     'A point inside the PPF means the economy is not using all of its resources or is using them inefficiently. A point on the curve represents productive efficiency, and a point outside is currently unattainable.',
     'MULTIPLE_CHOICE', 'EASY'),

    -- ── DEMAND AND SUPPLY ────────────────────────────────────────
    (v_econ_id, v_mcq_p, NULL,
     'If the price of good X falls, what happens to demand for good Y, a complement of X?',
     'Demand for Y increases',
     'Demand for Y decreases',
     'Demand for Y is unchanged',
     'The price of Y falls',
     'A',
     'Complements are goods consumed together. If X''s price falls, demand for X rises, which increases demand for its complement Y. Example: if petrol becomes cheaper, demand for cars rises.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'Which of the following would cause a leftward shift in the supply curve of a good?',
     'An increase in the cost of raw materials',
     'An improvement in production technology',
     'An increase in the number of producers',
     'A fall in the price of the good',
     'A',
     'An increase in production costs reduces profitability at every price level, causing producers to supply less at each price — shifting the supply curve to the left.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_econ_id, v_mcq_p, NULL,
     'When supply increases and demand remains constant, what happens to equilibrium price and quantity?',
     'Price falls, quantity rises',
     'Price rises, quantity rises',
     'Price falls, quantity falls',
     'Price and quantity both rise',
     'A',
     'An increase in supply (rightward shift) means producers offer more at each price. With unchanged demand, this creates excess supply at the original price, driving the price down and quantity exchanged up.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'A good has a price elasticity of demand of -2.5. This means the good is:',
     'Price elastic — demand is relatively sensitive to price changes',
     'Price inelastic — demand is relatively insensitive to price changes',
     'Perfectly inelastic — demand does not change when price changes',
     'Unit elastic — the percentage change in demand equals the percentage change in price',
     'A',
     'When |PED| > 1, demand is price elastic, meaning a given percentage change in price leads to a proportionately larger change in quantity demanded. |PED| = 2.5 > 1 confirms elasticity.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'If the cross elasticity of demand between goods A and B is positive, the goods are:',
     'Substitutes', 'Complements', 'Inferior goods', 'Normal goods',
     'A',
     'A positive cross elasticity means that when the price of one good rises, the demand for the other also rises — indicating the goods are substitutes (consumers switch from one to the other).',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'Income elasticity of demand for a good is -0.8. This good is classified as:',
     'An inferior good', 'A normal good', 'A luxury good', 'A Giffen good',
     'A',
     'Income elasticity of demand (YED) < 0 means that as income rises, demand for the good falls. This is the definition of an inferior good. A normal good has YED > 0.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'A firm is a price maker. This means it:',
     'Has market power to set its own price',
     'Must accept the market price',
     'Produces where price equals marginal cost',
     'Operates in a perfectly competitive market',
     'A',
     'Price makers have market power — they face a downward-sloping demand curve and can choose the price they charge. This is characteristic of monopolies and oligopolies. Price takers (perfect competition) must accept the market price.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    -- ── MARKET STRUCTURES ───────────────────────────────────────
    (v_econ_id, v_mcq_p, NULL,
     'In perfect competition, the demand curve facing an individual firm is:',
     'Perfectly elastic (horizontal)',
     'Perfectly inelastic (vertical)',
     'Downward sloping',
     'Upward sloping',
     'A',
     'In perfect competition, firms are price takers. They can sell any quantity at the market price but nothing above it — producing a horizontal (perfectly elastic) demand curve for each individual firm.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'A monopolist maximises profit by producing where:',
     'Marginal revenue (MR) = Marginal cost (MC)',
     'Price equals average total cost',
     'Total revenue is maximised',
     'Average revenue equals average variable cost',
     'A',
     'Profit maximisation occurs at the output level where MR = MC. This is true for all market structures. For a monopolist, price (AR) > MR, so the profit-maximising price is read off the demand curve at that output.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'Which of the following is a characteristic of an oligopoly?',
     'A few large firms with significant market power and interdependence',
     'Many small firms with no market power',
     'A single firm with no close substitutes',
     'Free entry and exit with identical products',
     'A',
     'Oligopoly is defined by a small number of large firms that dominate the market. They are mutually interdependent — each firm''s decisions affect and are affected by rivals. Barriers to entry are typically high.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    -- ── COSTS, REVENUE AND PROFIT ────────────────────────────────
    (v_econ_id, v_mcq_p, NULL,
     'A firm has total revenue of $500 and total costs of $380. What is the firm''s profit?',
     '$120', '$880', '$380', '$500',
     'A',
     'Profit = Total Revenue - Total Cost = 500 - 380 = $120.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_econ_id, v_mcq_p, NULL,
     'Which of the following is an example of a fixed cost for a manufacturing firm?',
     'Factory rent', 'Raw material costs', 'Wages of part-time workers', 'Electricity for production',
     'A',
     'Fixed costs do not vary with output in the short run. Factory rent is the same regardless of how much is produced. Variable costs (raw materials, energy used in production) change with output.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_econ_id, v_mcq_p, NULL,
     'Marginal cost is best defined as:',
     'The additional cost of producing one more unit of output',
     'Total cost divided by quantity produced',
     'The cost of the last unit minus the cost of the first unit',
     'Fixed costs plus variable costs',
     'A',
     'Marginal cost (MC) = ΔTC/ΔQ — the change in total cost from producing one additional unit. It is the key concept linking costs to the profit-maximising output decision.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_econ_id, v_mcq_p, NULL,
     'Economies of scale occur when:',
     'Long-run average costs fall as output increases',
     'Short-run average costs rise with output',
     'Fixed costs are spread over fewer units',
     'Marginal cost exceeds average cost',
     'A',
     'Economies of scale refer to the cost advantages a firm gains by expanding its scale of production. Long-run average cost (LRAC) falls as output increases, due to specialisation, bulk buying, or spreading fixed costs.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    -- ── MACROECONOMICS ───────────────────────────────────────────
    (v_econ_id, v_mcq_p, NULL,
     'Which of the following is NOT included in the calculation of GDP by the expenditure method?',
     'Transfer payments (e.g., unemployment benefits)',
     'Government spending on goods and services',
     'Gross private investment',
     'Net exports (exports minus imports)',
     'A',
     'GDP by expenditure = C + I + G + (X - M). Transfer payments are not included because they are not payments for goods or services produced — they simply redistribute income.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'Demand-pull inflation is caused by:',
     'Excessive aggregate demand relative to the economy''s productive capacity',
     'Rising costs of production pushing up prices',
     'A fall in the exchange rate reducing import costs',
     'A decrease in the money supply',
     'A',
     'Demand-pull inflation occurs when aggregate demand grows faster than aggregate supply — too much money chasing too few goods. This is contrasted with cost-push inflation, which results from rising production costs.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'An increase in the central bank''s interest rate is most likely to:',
     'Reduce consumer spending and investment, lowering inflationary pressure',
     'Increase government spending by reducing borrowing costs',
     'Stimulate aggregate demand by making borrowing cheaper',
     'Depreciate the exchange rate',
     'A',
     'Higher interest rates raise the cost of borrowing and increase the return on saving. This reduces consumer spending and business investment, decreasing aggregate demand and thereby reducing inflationary pressure.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'The multiplier effect describes how:',
     'An initial injection of spending leads to a larger final increase in national income',
     'Higher taxes always reduce economic output proportionally',
     'Exports always increase when imports decrease',
     'A cut in interest rates immediately eliminates unemployment',
     'A',
     'The multiplier effect occurs because an initial increase in spending (e.g., government investment) creates income for others, who in turn spend a fraction of it, creating further rounds of spending. The multiplier = 1 / (1 - MPC).',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'Cyclical unemployment is caused by:',
     'A fall in aggregate demand during a recession',
     'Workers transitioning between jobs',
     'A structural mismatch between workers'' skills and job requirements',
     'Seasonal variations in demand for labour',
     'A',
     'Cyclical (demand-deficient) unemployment arises when aggregate demand in the economy is insufficient to employ all workers willing to work at prevailing wages. It rises in recessions and falls during booms.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    -- ── INTERNATIONAL TRADE ──────────────────────────────────────
    (v_econ_id, v_mcq_p, NULL,
     'According to the principle of comparative advantage, a country should specialise in producing goods:',
     'For which it has the lowest opportunity cost of production relative to other countries',
     'In which it uses the most labour-intensive methods',
     'For which it has an absolute advantage in all factors',
     'That have the highest world market price',
     'A',
     'Comparative advantage exists when a country can produce a good at a lower opportunity cost than another. Specialising according to comparative advantage and trading leads to higher total output and gains from trade.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_econ_id, v_mcq_p, NULL,
     'A tariff imposed on imports is most likely to:',
     'Raise the domestic price of the good, reducing imports and protecting domestic producers',
     'Lower the domestic price by increasing domestic supply',
     'Increase consumer surplus by making imports cheaper',
     'Reduce government revenue',
     'A',
     'A tariff (import tax) raises the price of imported goods, making them less competitive. This reduces the quantity imported, raises the domestic price, increases domestic production, and generates tax revenue for the government.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ══════════════════════════════════════════════════════════
    -- PAPER 2  — DATA RESPONSE QUESTIONS (short structured)
    -- ══════════════════════════════════════════════════════════

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty)
    VALUES

    (v_econ_id, v_essay_p, NULL,
     'The price of crude oil rises by 40%. Explain two likely effects on the macroeconomy of an oil-importing country. [4]',
     NULL, NULL, NULL, NULL,
     'A strong response should identify: (1) Cost-push inflation — higher oil prices increase production costs across the economy, pushing up the price level. (2) Negative impact on the current account — higher import costs worsen the trade balance. Additional valid points: reduced real incomes reducing consumer spending, lower aggregate demand, possible recession.',
     'Award 2 marks per effect: 1 mark for identifying the effect, 1 mark for clear explanation with economic analysis.',
     'ESSAY', 'MEDIUM'),

    (v_econ_id, v_essay_p, NULL,
     'Using a supply and demand diagram, explain how an increase in consumer income affects the market for a normal good. [4]',
     NULL, NULL, NULL, NULL,
     'A strong response should include: A diagram showing a rightward shift of the demand curve (D to D1). Explanation: higher income raises consumers'' purchasing power, increasing willingness and ability to buy normal goods at every price level. This rightward shift creates excess demand at the original equilibrium price, causing both price and quantity to rise to a new equilibrium.',
     'Award 2 marks for a correctly labelled diagram showing the demand shift. Award 2 marks for a clear written explanation referencing the diagram and identifying the new equilibrium.',
     'ESSAY', 'MEDIUM'),

    (v_econ_id, v_essay_p, NULL,
     'Explain the difference between price elasticity of demand (PED) and income elasticity of demand (YED), and give one example of a good with PED < -1 and one with YED < 0. [6]',
     NULL, NULL, NULL, NULL,
     'PED measures the responsiveness of quantity demanded to a change in the good''s own price: PED = %ΔQd / %ΔP. YED measures responsiveness to a change in consumer income: YED = %ΔQd / %ΔY. PED < -1 (price elastic): luxury goods such as designer clothing or foreign holidays — consumers are sensitive to price changes. YED < 0 (inferior good): goods like instant noodles or cheap public transport — demand falls as income rises because consumers switch to superior alternatives.',
     'Award 2 marks for correct definitions of each concept. Award 1 mark per valid example with appropriate justification.',
     'ESSAY', 'HARD'),

    (v_econ_id, v_essay_p, NULL,
     'Analyse the likely effects on consumers and producers of the government imposing a maximum price (price ceiling) below the equilibrium price in the housing rental market. [8]',
     NULL, NULL, NULL, NULL,
     'Effects on consumers: (1) Reduced rent — those who secure housing pay below the equilibrium price, gaining consumer surplus. (2) Housing shortage — quantity demanded exceeds quantity supplied at the ceiling price, so some consumers cannot find accommodation. Non-price rationing (e.g., waiting lists, discrimination) may emerge. Effects on producers (landlords): (1) Reduced revenue and profit — lower rents reduce the incentive to supply rental property. (2) Long-run supply reduction — disinvestment from the rental market as returns fall below normal profit, worsening the shortage. Diagram required: supply and demand with the ceiling marked below equilibrium, showing excess demand.',
     'Award up to 4 marks for consumer analysis and up to 4 marks for producer analysis. Reward use of a diagram, identification of shortage, and analysis of long-run effects.',
     'ESSAY', 'HARD');

    RAISE NOTICE 'AS Level Economics questions inserted successfully for courseId = %', v_econ_id;

END $$;
