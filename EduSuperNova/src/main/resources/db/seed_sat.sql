-- ============================================================
-- SAT Exam – Seed Data (Papers, Units & Questions)
--
-- Assumes the SAT exam and its two courses already exist.
-- Run in: Supabase SQL editor → New query → paste → Run
-- ============================================================

DO $$
DECLARE
    v_math_id   INTEGER;
    v_rw_id     INTEGER;
    v_math_p1   INTEGER;
    v_rw_p1     INTEGER;
    v_rw_p2     INTEGER;
    v_unit_id   INTEGER;
    v_rw_unit1  INTEGER;
    v_rw_unit2  INTEGER;
    v_rw_unit3  INTEGER;
    v_rw_unit4  INTEGER;
    v_group_id  INTEGER;
BEGIN

    -- ── Resolve existing course IDs ───────────────────────────
    SELECT idcourse INTO v_math_id
    FROM courses WHERE lower(coursename) = 'sat math' LIMIT 1;

    SELECT idcourse INTO v_rw_id
    FROM courses WHERE lower(coursename) = 'sat reading & writing' LIMIT 1;

    IF v_math_id IS NULL THEN
        RAISE EXCEPTION 'Course "SAT Math" not found.';
    END IF;

    IF v_rw_id IS NULL THEN
        RAISE EXCEPTION 'Course "SAT Reading & Writing" not found.';
    END IF;

    -- ════════════════════════════════════════════════════════
    -- COURSE 1 – SAT Math
    -- ════════════════════════════════════════════════════════
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_math_id,
        'Math Module',
        'Answer all questions. For multiple-choice questions, select the best answer. For student-produced response questions, enter your answer.',
        'MCQ',
        20,
        70,
        1
    )
    RETURNING idpaper INTO v_math_p1;

    -- ── Unit 1: Algebra ──────────────────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_math_id, 'Algebra', 'Summaries/SAT/sat_math_algebra.txt', 1)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p1, v_unit_id,
     'If 3x + 7 = 22, what is the value of x?',
     '3', '5', '7', '9',
     'B',
     '3x + 7 = 22 → 3x = 15 → x = 5.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'Which of the following is equivalent to 2(3x − 4) + 5x?',
     '11x − 8', '11x − 4', '6x − 8', '11x + 8',
     'A',
     '2(3x − 4) + 5x = 6x − 8 + 5x = 11x − 8.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'A line passes through (0, 3) and (4, 11). What is the slope of the line?',
     '2', '3', '4', '8',
     'A',
     'Slope = (11 − 3) / (4 − 0) = 8 / 4 = 2.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'If y = −2x + 6, for what value of x does y = 0?',
     '−3', '3', '6', '−6',
     'B',
     '0 = −2x + 6 → 2x = 6 → x = 3.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'Which system of equations has no solution?',
     '2x + y = 4 and 4x + 2y = 8',
     '2x + y = 4 and 4x + 2y = 10',
     'x − y = 1 and x + y = 3',
     'x + 2y = 6 and 2x − y = 2',
     'B',
     'Both equations represent lines with slope −2. The first has y-intercept 4, the second has y-intercept 5. Parallel lines → no solution.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 2: Advanced Math ─────────────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_math_id, 'Advanced Math', 'Summaries/SAT/sat_math_advanced.txt', 2)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p1, v_unit_id,
     'Which of the following is a factor of x² − 5x + 6?',
     '(x − 1)', '(x − 2)', '(x + 3)', '(x + 6)',
     'B',
     'x² − 5x + 6 = (x − 2)(x − 3). So (x − 2) is a factor.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'What are the solutions to x² − x − 12 = 0?',
     'x = 3 and x = −4', 'x = −3 and x = 4', 'x = 6 and x = −2', 'x = 4 and x = 3',
     'B',
     'Factor: (x − 4)(x + 3) = 0 → x = 4 or x = −3.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'If f(x) = 2x² − 3x + 1, what is f(−1)?',
     '−4', '4', '6', '−6',
     'C',
     'f(−1) = 2(1) − 3(−1) + 1 = 2 + 3 + 1 = 6.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'The expression (x² − 9) / (x − 3) simplifies to which of the following for x ≠ 3?',
     'x − 3', 'x + 3', 'x² + 3', 'x + 9',
     'B',
     'x² − 9 = (x − 3)(x + 3). Dividing by (x − 3) gives x + 3.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'If g(x) = 3^x, what is g(−2)?',
     '9', '−9', '1/9', '−1/9',
     'C',
     'g(−2) = 3^(−2) = 1/3² = 1/9.',
     'MULTIPLE_CHOICE', 'HARD');

    -- ── Unit 3: Problem-Solving & Data Analysis ───────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_math_id, 'Problem-Solving & Data Analysis', 'Summaries/SAT/sat_math_data.txt', 3)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p1, v_unit_id,
     'A store sells a jacket originally priced at $80 at a 25% discount. What is the sale price?',
     '$55', '$60', '$65', '$70',
     'B',
     '25% of $80 = $20. Sale price = $80 − $20 = $60.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'A data set has values 4, 7, 7, 9, 13. What is the mean?',
     '7', '8', '9', '10',
     'B',
     'Mean = (4 + 7 + 7 + 9 + 13) / 5 = 40 / 5 = 8.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'A car travels 240 miles in 4 hours. At the same rate, how many miles will it travel in 7 hours?',
     '360', '400', '420', '480',
     'C',
     'Rate = 240/4 = 60 mph. Distance in 7 hours = 60 × 7 = 420 miles.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'A survey of 200 students found that 35% prefer science. How many students prefer science?',
     '60', '65', '70', '75',
     'C',
     '35% of 200 = 0.35 × 200 = 70 students.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'A scatterplot shows a strong positive correlation between hours studied and test scores. Which conclusion is best supported?',
     'Studying more causes higher scores',
     'Students who study more tend to score higher',
     'There is no relationship between studying and scores',
     'Test scores cause students to study more',
     'B',
     'Correlation does not imply causation. The correct interpretation is that students who study more tend to score higher, not that studying causes the higher scores.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 4: Geometry & Trigonometry ──────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_math_id, 'Geometry & Trigonometry', 'Summaries/SAT/sat_math_geometry.txt', 4)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p1, v_unit_id,
     'A right triangle has legs of length 6 and 8. What is the length of the hypotenuse?',
     '10', '12', '14', '100',
     'A',
     'By the Pythagorean theorem: 6² + 8² = 36 + 64 = 100, so the hypotenuse = √100 = 10.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'What is the area of a circle with radius 5?',
     '10π', '25π', '5π', '50π',
     'B',
     'Area = πr² = π(5)² = 25π.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'Two parallel lines are cut by a transversal. Which pair of angles is always equal?',
     'Co-interior angles', 'Adjacent angles', 'Alternate interior angles', 'Supplementary angles',
     'C',
     'Alternate interior angles formed by a transversal cutting parallel lines are always equal (alternate interior angle theorem).',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'In a right triangle, sin(θ) = 3/5. What is cos(θ)?',
     '3/4', '4/5', '4/3', '5/3',
     'B',
     'Using the Pythagorean identity: cos²(θ) = 1 − sin²(θ) = 1 − 9/25 = 16/25, so cos(θ) = 4/5.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'A cylinder has radius 3 and height 10. What is its volume?',
     '30π', '60π', '90π', '100π',
     'C',
     'Volume = πr²h = π(3)²(10) = 90π.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ════════════════════════════════════════════════════════
    -- COURSE 2 – SAT Reading & Writing
    -- MODULE 1 (27 questions, 32 minutes)
    -- ════════════════════════════════════════════════════════
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_rw_id,
        'Reading & Writing Module 1',
        'Each question is based on a passage or pair of passages. Select the best answer for each question.',
        'MCQ',
        27,
        32,
        1
    )
    RETURNING idpaper INTO v_rw_p1;

    -- ── Unit 1: Information & Ideas (Module 1, 7 questions) ──
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_rw_id, 'Information & Ideas', 'Summaries/SAT/sat_rw_information.txt', 1)
    RETURNING idunit INTO v_rw_unit1;

    -- Group 1 – Language Origins
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Language Origins',
        'Language is one of humanity''s most defining characteristics, yet its origins remain deeply mysterious. Linguists, evolutionary biologists, and cognitive scientists have all proposed competing theories—from the idea that language evolved gradually from primate communication systems to the hypothesis that a single genetic mutation enabled symbolic thought. Despite decades of research, scientists have not reached a consensus on the origins of language. New fossil evidence and genetic data continue to complicate the picture rather than resolve it.',
        1)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit1,
     'The passage states: "Despite decades of research, scientists have not reached a consensus on the origins of language." Which of the following best describes the main idea of this sentence?',
     'Language research has been abandoned by scientists',
     'The origin of language remains a subject of ongoing debate',
     'Scientists agree that language evolved recently',
     'Decades of research have solved the language question',
     'B',
     'The sentence explicitly states that no consensus has been reached, indicating the topic remains debated.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 2 – Renewable Energy Adoption
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Renewable Energy Adoption',
        'A national survey tracking the spread of renewable energy found significant regional differences in adoption rates. In metropolitan areas, where government incentive programs are more accessible and installation networks are better developed, residential and commercial solar panels became far more common than in outlying regions. Solar adoption grew by 40% in urban areas while growing only 12% in rural areas over the same five-year period. Researchers attributed the slower rural growth to higher upfront costs, fewer qualified installers, and limited access to municipal financing programs.',
        2)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit1,
     'According to the passage about renewable energy: "Solar adoption grew by 40% in urban areas while growing only 12% in rural areas." Which conclusion is best supported?',
     'Rural areas use no solar energy',
     'Solar adoption grew faster in urban areas than in rural areas',
     'Solar energy is only practical in cities',
     'Rural areas will never adopt solar energy',
     'B',
     'The data directly supports that urban growth (40%) outpaced rural growth (12%). No absolute absence or impossibility is stated.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 3 – Fiction and Empathy
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Fiction and Empathy',
        'Psychologists have long debated whether consuming narrative fiction has measurable effects on readers'' social cognition. Some researchers argue that mentally inhabiting a fictional character''s perspective exercises the same capacities used in real-world empathy. A researcher claims that "reading fiction increases empathy," citing preliminary studies linking fiction consumption to higher scores on perspective-taking assessments. Critics note that these studies rely on correlational data and lack the experimental controls needed to distinguish fiction''s effects from those of general literacy or education.',
        3)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit1,
     'A researcher claims that "reading fiction increases empathy." Which evidence would most directly support this claim?',
     'A survey showing fiction readers own more books',
     'An experiment where fiction readers scored higher on empathy tests than non-readers',
     'Statistics showing fiction is the most popular book genre',
     'A study finding fiction readers spend more time reading than non-fiction readers',
     'B',
     'Directly measuring empathy in fiction vs. non-fiction readers tests the specific claim. The other options measure unrelated variables.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 4 – Climate Policy Dual Passage
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Climate Policy: Two Perspectives',
        'Passage 1: Reducing carbon emissions is one of the most urgent challenges facing modern economies. A well-designed carbon tax directly prices emissions, creating incentives for businesses and households to reduce their carbon footprints while generating government revenue for clean energy investment. Economists widely regard carbon pricing as the most efficient mechanism for meeting international climate targets.

Passage 2: A fixed carbon tax risks placing disproportionate burdens on lower-income households, which spend a higher share of their income on energy. A cap-and-trade system is preferable: it establishes a declining ceiling on total emissions and allows businesses to buy and sell permits, harnessing market forces to achieve environmental goals. Both approaches reflect the shared conviction that reducing carbon emissions is a moral and economic imperative.',
        4)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit1,
     'Two passages discuss climate policy. Passage 1 supports a carbon tax; Passage 2 prefers cap-and-trade. Both agree on which of the following?',
     'Carbon taxes are more effective than cap-and-trade',
     'Reducing carbon emissions is an important goal',
     'Government should not regulate emissions',
     'Economic growth is more important than environmental policy',
     'B',
     'Both passages advocate for a specific policy to reduce emissions, implying they agree that reducing emissions matters, even if they differ on the method.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 5 – Research Sample Size
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Research on Nature Documentaries',
        'Researchers at a prominent university published findings suggesting that exposure to nature documentaries significantly reduces stress levels in young adults. The study measured cortisol concentrations before and after participants watched a series of nature films over two weeks. Although results showed a statistically significant reduction in stress markers, the study used a sample of 50 college students drawn entirely from a single introductory psychology course. The researchers acknowledged this limitation but argued that their findings offered a useful starting point for broader investigation.',
        5)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit1,
     'A passage notes that a study used a sample of 50 college students. A critic argues the findings cannot be generalized. The critic is most likely concerned about:',
     'The length of the study',
     'Whether the sample is representative of the broader population',
     'The cost of the research',
     'The credentials of the researchers',
     'B',
     'Generalizability depends on whether the sample represents the population. A small, specific sample may not reflect the general population.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- Group 6 – Migratory Birds (new)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Migratory Bird Navigation',
        'Scientists have long known that migratory birds navigate partly by detecting Earth''s magnetic field, but the mechanism has remained controversial. Recent experiments suggest that quantum processes in birds'' eyes—involving light-sensitive proteins called cryptochromes—generate quantum states sensitive to the field''s orientation. Laboratory studies in European robins found that disrupting these quantum processes caused the birds to lose directional accuracy entirely. Critics of the quantum hypothesis note that direct behavioral evidence in wild populations remains limited and that alternative magnetic-sensing mechanisms in the birds'' beaks have not been ruled out.',
        6)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit1,
     'Which finding, if true, would most directly support the quantum hypothesis for bird navigation described in the passage?',
     'Birds navigate equally well in daylight and in complete darkness',
     'The magnetic sensitivity of birds varies significantly by age',
     'Migratory birds that lack functional cryptochrome genes lose their ability to orient in a magnetic field',
     'Disrupting birds'' vision has no measurable effect on their magnetic orientation',
     'C',
     'The quantum hypothesis centers on cryptochromes as the mechanism. Finding that birds without functional cryptochrome genes lose magnetic orientation directly links the protein to the navigation ability the hypothesis proposes.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 7 – Urban Farming (new)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Urban Agriculture',
        'Urban agriculture advocates argue that growing food in cities reduces transportation emissions, strengthens food security, and revitalizes neglected land. A pilot program in Detroit converted fifteen vacant lots into community gardens and tracked food production over three years. The program generated roughly twelve tons of produce annually—enough to supplement the diets of approximately two hundred families. Program evaluators also documented secondary benefits: participants reported increased social connection, and crime rates in the surrounding blocks declined measurably during the program''s operation.',
        7)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit1,
     'Which of the following best describes what the Detroit pilot program evaluated, according to the passage?',
     'Whether urban farming is more productive than rural farming per acre',
     'Whether urban food production is commercially viable at scale',
     'The food yield and community impacts of converting vacant urban lots into gardens',
     'The relationship between neighborhood crime rates and food access',
     'C',
     'The program tracked food production and documented secondary community benefits—both yield and broader impacts are described, making C the most complete and accurate description.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- ── Unit 2: Craft & Structure (Module 1, 7 questions) ────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_rw_id, 'Craft & Structure', 'Summaries/SAT/sat_rw_craft.txt', 2)
    RETURNING idunit INTO v_rw_unit2;

    -- Group 8 – Alpine Meadows / ephemeral
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Alpine Meadow Blooms',
        'The wildflowers that bloom on the slopes of Mount Rainier exist in a state of perpetual impermanence. Alpine meadows receive sunlight only during the brief weeks between snowmelt and the first autumn frost—a window so narrow that ecologists describe the bloom as "ephemeral." Visitors who time their hike precisely may witness carpets of Indian paintbrush and lupine; those who arrive days later find only fading petals and seed heads bending in the wind. This fleeting quality makes alpine ecosystems especially sensitive to even small shifts in seasonal timing brought on by climate change.',
        8)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit2,
     'As used in the passage, the word "ephemeral" most nearly means:',
     'Lasting forever', 'Short-lived', 'Extremely important', 'Widely known',
     'B',
     '"Ephemeral" means lasting for a very short time. The passage describes the bloom window as so narrow that visitors who arrive days late find only fading petals, reinforcing the meaning of brevity.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 9 – Books as Cultural Memory / personal anecdote
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Books as Cultural Memory',
        'When I was seven years old, my grandmother placed a worn novel in my hands—a book she had carried from her village in eastern Europe when she emigrated. I could not read the language, but I turned each page carefully, as though the illustrations spoke directly to me. That encounter shaped my understanding of literature as a form of cultural memory. Scholars in reader-response theory have since confirmed what I sensed intuitively: the personal and emotional contexts readers bring to texts are not incidental to literary meaning but central to it.',
        9)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit2,
     'The author begins the passage with a personal anecdote primarily to:',
     'Provide statistical evidence for the argument',
     'Introduce a counterargument',
     'Engage the reader and illustrate the central theme personally',
     'Define a key term used later in the passage',
     'C',
     'Personal anecdotes in introductions typically create reader engagement and ground the abstract argument in a relatable experience.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 10 – National Debt / ticking time bomb
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'The National Debt',
        'The United States federal debt has exceeded thirty trillion dollars—a figure abstract enough that most citizens struggle to grasp its consequences. Economists and policy analysts increasingly warn that the current trajectory of deficit spending is unsustainable. Writing in a recent policy journal, one analyst described the mounting national debt as a "ticking time bomb," arguing that the convergence of aging demographics, rising entitlement costs, and stagnant revenue growth could produce a fiscal crisis within a generation if elected officials continue to defer action.',
        10)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit2,
     'The author uses the phrase "ticking time bomb" to describe the rising national debt. This is an example of:',
     'Simile', 'Metaphor', 'Personification', 'Alliteration',
     'B',
     '"Ticking time bomb" is a metaphor — a direct comparison without using "like" or "as," equating the debt to a dangerous, urgent threat.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 11 – Urban Flooding / problem-solution structure
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Urban Flooding and Green Infrastructure',
        'Urban flooding has become one of the most serious infrastructure challenges facing American cities. As impervious surfaces—concrete roads, parking lots, and rooftops—have replaced natural ground cover, stormwater that once soaked into soil now races into overloaded drainage systems during heavy rains. Cities like Philadelphia and Chicago have responded by investing in "green infrastructure": bioswales, permeable pavements, and restored wetlands that capture water before it reaches pipes. Preliminary data from Philadelphia''s Green City, Clean Waters program indicate that targeted green infrastructure can reduce stormwater runoff by up to 85% in treated neighborhoods, at a fraction of the cost of replacing underground pipes.',
        11)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit2,
     'The structure of the passage is best described as:',
     'A problem is introduced, followed by analysis and a proposed solution',
     'A chronological narrative of historical events',
     'A series of unrelated observations',
     'A rebuttal of a specific opposing argument only',
     'A',
     'The passage identifies urban flooding as a problem, explains its cause (impervious surfaces), then presents green infrastructure as the solution with supporting data—a classic problem-solution structure.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 12 – Black-footed Ferret / optimistic tone
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'The Black-Footed Ferret Recovery',
        'For decades, conservationists watching the black-footed ferret''s decline feared the species was beyond rescue. Once mistakenly declared extinct, its rediscovery in 1981 triggered one of the most ambitious captive breeding programs in wildlife history. Early efforts were plagued by canine distemper and severe genetic bottlenecks, and the population languished below a hundred individuals for years. Scientists painstakingly refined their protocols, studying ferret immunity and behavior with unprecedented rigor. Today, more than four hundred black-footed ferrets inhabit reintroduced ranges across eight states and Mexico. Their recovery remains incomplete—but it demonstrates that with sustained investment and scientific creativity, humanity can pull species back from the very threshold of disappearance.',
        12)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit2,
     'The author''s tone in the final paragraph is best described as:',
     'Dismissive and sarcastic', 'Optimistic and encouraging', 'Neutral and detached', 'Pessimistic and fearful',
     'B',
     'The final sentence—"humanity can pull species back from the very threshold of disappearance"—signals hope and possibility. Despite acknowledging the recovery is incomplete, the author''s word choice ("demonstrates," "sustained investment," "scientific creativity") is encouraging rather than fearful.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- Group 13 – Precipitous decline / vocabulary (new)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Emerging-Market Currency Volatility',
        'Financial analysts tracking emerging-market currencies noted a sudden and dramatic reversal in late autumn. Several currencies that had traded stably for months fell sharply against major reserve currencies within a matter of days. Analysts attributed the precipitous decline to a combination of rising interest rates in developed economies and a sharp reduction in commodity export revenues. The speed of the fall caught many investors off guard, leaving some institutions holding positions they had no time to unwind before sustaining significant losses.',
        13)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit2,
     'As used in the passage, "precipitous" most nearly means:',
     'Dangerous and unpredictable',
     'Gradual and steady',
     'Sudden and steep',
     'Long anticipated',
     'C',
     '"Precipitous" means extremely steep or abrupt. The passage describes currencies falling "sharply... within a matter of days," catching investors "off guard"—all reinforcing the meaning of a sudden, steep drop.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 14 – Mandatory Minimum Sentencing / author's purpose (new)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Mandatory Minimum Sentencing',
        'Opponents of mandatory minimum sentencing have long argued that such policies lead to racially disproportionate incarceration. A landmark study found that Black defendants convicted of identical offenses under mandatory minimums received sentences an average of 19.5% longer than white defendants—a disparity the authors attributed to prosecutorial discretion in charge selection. The study''s authors cited these figures not to impugn individual prosecutors, but to argue that structural features of mandatory minimum statutes systematically produce unequal outcomes regardless of individual intent.',
        14)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit2,
     'The authors'' primary purpose in citing the 19.5% sentencing disparity is to:',
     'Blame individual prosecutors for intentional racial bias',
     'Demonstrate that mandatory minimum laws produce racially unequal outcomes through structural means',
     'Argue that all mandatory minimum sentences should be immediately abolished',
     'Show that defendants of different races always receive different sentences',
     'B',
     'The passage explicitly states the figures were cited to show "structural features" produce "unequal outcomes regardless of individual intent"—supporting systemic critique, not individual blame or blanket abolition.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Unit 3: Expression of Ideas (Module 1, 7 questions) ──
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_rw_id, 'Expression of Ideas', 'Summaries/SAT/sat_rw_expression.txt', 3)
    RETURNING idunit INTO v_rw_unit3;

    -- Group 15 – Sentence combining
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Wind-Tunnel Research (Sentence Revision)',
        'A research team investigating whether altering a bird''s wing angle could improve sustained gliding efficiency designed a series of wind-tunnel trials. The experiment failed. The results were still valuable. The team planned to revise their methodology based on what they learned about the limits of their measurement equipment.',
        15)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit3,
     'Which choice most effectively combines the two sentences: "The experiment failed. The results were still valuable."?',
     'The experiment failed, so the results were still valuable.',
     'Although the experiment failed, the results were still valuable.',
     'The experiment failed because the results were still valuable.',
     'The experiment failed; therefore the results were not valuable.',
     'B',
     '"Although" correctly signals a contrast between the failure and the value of the results. "So" and "because" imply incorrect cause-effect relationships.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 16 – Exercise and mental health / supporting evidence
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Exercise and Mental Health (Draft)',
        'A student is writing a research paper on physical activity and psychological well-being. The student has drafted the following argument: "Regular exercise appears to benefit not only physical health but also mental health, offering a low-cost supplement to medication for common mood disorders. [Blank sentence] For these reasons, healthcare providers should consider recommending structured exercise programs alongside traditional treatments for depression."',
        16)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit3,
     'A student wants to add a sentence to support the claim that exercise improves mental health. Which addition is most relevant?',
     'Many gyms have opened in the past decade.',
     'Studies show that regular aerobic exercise reduces symptoms of depression and anxiety.',
     'Exercise equipment can be expensive.',
     'Athletes often follow strict dietary plans.',
     'B',
     'Only option B directly links exercise to mental health outcomes, which supports the specific claim.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 17 – Formal tone
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Coastal Wetlands Policy Brief (Tone)',
        'A student is drafting a policy brief for a university environmental law seminar. The brief argues that recent scientific data necessitate stronger federal protections for coastal wetland ecosystems. In one section, the student attempts to characterize the scientific community''s current position on the severity of coastal habitat loss. The student wants the sentence to maintain the formal, academic tone of the rest of the document.',
        17)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit3,
     'The writer wants to maintain a formal tone. Which version of the sentence is most appropriate?',
     'Lots of scientists think climate change is a big problem.',
     'Many researchers regard climate change as a critical global challenge.',
     'Climate change is, like, really bad according to science.',
     'Scientists are kinda worried about what climate change might do.',
     'B',
     'Option B uses precise, formal vocabulary ("researchers," "critical global challenge") appropriate for academic writing.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 18 – Transition word
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Flexible Work Policy Report (Transition)',
        'A management consultant published a report analyzing the effects of a flexible scheduling policy at a mid-sized technology firm. The first section detailed cost savings generated by reduced office space requirements. A subsequent section discussed workforce outcomes: "The new policy reduced costs; ___, employee satisfaction also improved." The consultant wanted the transition to accurately reflect the logical relationship between the two findings.',
        18)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit3,
     'Which transition word best fills the blank: "The new policy reduced costs; ___, employee satisfaction also improved."?',
     'however', 'furthermore', 'although', 'therefore',
     'B',
     '"Furthermore" adds an additional positive outcome, which fits the context of two separate benefits. "However" implies contrast, which is logically incorrect here.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 19 – Urban green spaces / weakening argument
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Urban Green Spaces Debate',
        'A city planning commission is deliberating whether to invest municipal funds in converting three vacant industrial parcels into neighborhood parks. The commission chair argues that the investment is justified because urban green spaces improve residents'' quality of life. A dissenting commissioner requests that the chair identify the strongest counterargument to this position.',
        19)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit3,
     'A passage argues that urban green spaces improve quality of life. Which sentence, if added, would most weaken this argument?',
     'Several cities have increased park funding in recent years.',
     'Residents near parks report higher life satisfaction.',
     'A study found no significant difference in well-being between residents near parks and those who are not.',
     'Green spaces can reduce urban heat island effects.',
     'C',
     'A study showing no difference in well-being directly contradicts the claim that green spaces improve quality of life.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- Group 20 – Public libraries / supporting detail (new)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Public Libraries (Draft)',
        'A student is writing an essay arguing that public libraries are essential community institutions. The student has written: "Libraries provide free access to books and digital resources for people who might otherwise not afford them. [Blank sentence] They also offer quiet study spaces and computer access that are particularly valuable to job seekers and students without reliable home internet."',
        20)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit3,
     'Which sentence, if added in the blank, would best support the student''s argument that libraries are essential community institutions?',
     'Many libraries offer free Wi-Fi to patrons regardless of library card status.',
     'Libraries originated in ancient civilizations as repositories for government records.',
     'Some libraries have reduced their hours in response to budget cuts.',
     'Studies show that library users borrow an average of twelve books per year.',
     'A',
     'Option A directly supports the argument that libraries provide free, accessible resources to the community. The other options are either historical context, a counterpoint, or a measure of volume rather than access.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 21 – Concision revision (new)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'School Start Times (Concision)',
        'A student is editing a persuasive essay about school scheduling. The draft contains the following wordy sentence: "Due to the fact that many teenagers in today''s modern world do not get sufficient amounts of sleep on a nightly basis, school start times that begin at an early hour in the morning have come under increasing scrutiny from a number of researchers and educators who study these kinds of issues."',
        21)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit3,
     'Which revision most effectively improves the sentence''s concision while preserving its meaning?',
     'Because many teenagers do not get enough sleep, early school start times have drawn increasing scrutiny from researchers and educators.',
     'The fact that teenagers don''t sleep means school start times are bad.',
     'Many researchers who study sleep think schools start too early because teenagers often don''t sleep enough.',
     'Teenagers need sleep, and school start times are being studied.',
     'A',
     'Option A eliminates all major redundancies ("due to the fact that"→"because", "today''s modern world"→removed, "sufficient amounts of"→"enough", "on a nightly basis"→removed, "early hour in the morning"→"early", "a number of"→removed) while preserving the full logical meaning.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Unit 4: Standard English Conventions (Module 1, 6 questions) ──
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_rw_id, 'Standard English Conventions', 'Summaries/SAT/sat_rw_conventions.txt', 4)
    RETURNING idunit INTO v_rw_unit4;

    -- Group 22 – Subject-verb agreement
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Science Fair Letter (Subject-Verb Agreement)',
        'A high school principal is reviewing a draft letter to parents about the upcoming regional science fair. The letter contains the following sentence: "Each of the students [have / has] submitted their assignment outlining their proposed project and will present their findings on March 15."',
        22)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit4,
     'Which version of the sentence is grammatically correct?',
     'Each of the students have submitted their assignment.',
     'Each of the students has submitted their assignment.',
     'Each of the students have submitted his assignment.',
     'Each of the students submitting their assignment.',
     'B',
     '"Each" is singular and takes a singular verb ("has"). "Their" is accepted as a singular gender-neutral pronoun.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 23 – Punctuation / comma splice
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Product Launch Memo (Punctuation)',
        'A junior analyst is editing an internal memo about a product launch delay. The memo contains the following sentence, where the punctuation between the two clauses must be corrected: "The report was late[BLANK] it caused delays in the project timeline."',
        23)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit4,
     'Which punctuation correctly joins two independent clauses?',
     'The report was late, it caused delays.',
     'The report was late; it caused delays.',
     'The report was late it caused delays.',
     'The report was late: it caused delays.',
     'B',
     'A semicolon correctly joins two closely related independent clauses. A comma alone creates a comma splice.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 24 – Apostrophe
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Board Meeting Minutes (Apostrophe)',
        'A legal assistant is proofreading the minutes from a corporate board meeting. The minutes contain the following sentence: "The [committee''s / committees / committees''] final decision was unanimous and will be binding on all affiliated parties."',
        24)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit4,
     'Which sentence uses the apostrophe correctly?',
     'The committee made it''s final decision.',
     'The committees final decision was unanimous.',
     'The committee''s final decision was unanimous.',
     'The committees'' final decision was unanimous.',
     'C',
     '"Committee''s" shows singular possessive correctly. "It''s" is always a contraction of "it is," never a possessive.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 25 – Complete sentence
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'University Application Writing Samples (Sentence Completeness)',
        'An editor is reviewing writing samples submitted by university applicants. The editor must identify and flag any sentence fragments—word groups that lack a subject, a complete predicate, or both—before forwarding the samples to the admissions committee.',
        25)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit4,
     'Which of the following is a complete sentence?',
     'Running through the park every morning.',
     'Although she studied hard for the exam.',
     'The scientist published her findings in a peer-reviewed journal.',
     'Because the weather was unpredictable that day.',
     'C',
     'Option C has a subject ("The scientist") and a complete predicate. Options A, B, and D are fragments—they lack a main clause.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 26 – Dangling modifier
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'Time Management Essay (Modifier Placement)',
        'A writing instructor is grading student essays on time management. One student''s essay contains the sentence: "Running to catch the bus, the keys were dropped by Maria." The instructor identifies this as a dangling modifier error and asks the student to revise the sentence so the participial phrase correctly modifies its intended subject.',
        26)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit4,
     'Which sentence correctly uses a modifier?',
     'Running to catch the bus, the keys were dropped by Maria.',
     'Running to catch the bus, Maria dropped her keys.',
     'Maria dropped her keys, running to catch the bus.',
     'The keys were dropped, running to catch the bus, by Maria.',
     'B',
     'The participial phrase "Running to catch the bus" must be placed directly before the noun it modifies (Maria). Other options create dangling or misplaced modifiers.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- Group 27 – Parallel structure (new)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p1,
        'College Application Essay (Parallel Structure)',
        'A student is editing their college application essay. The essay describes three qualities developed through competitive swimming: "Through years of competitive swimming, I have learned to set ambitious goals, [working through setbacks / to work through setbacks], and [the celebration of / to celebrate] small victories." The student wants to maintain parallel grammatical structure throughout the list.',
        27)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p1, v_rw_unit4,
     'Which version of the underlined phrases maintains parallel structure with "to set ambitious goals"?',
     'working through setbacks / the celebration of small victories',
     'to work through setbacks / to celebrate small victories',
     'working through setbacks / to celebrate small victories',
     'to work through setbacks / celebrating small victories',
     'B',
     'The list uses the infinitive form "to set." Parallel structure requires all items to follow the same pattern: "to set... to work... to celebrate."',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ════════════════════════════════════════════════════════
    -- COURSE 2 – SAT Reading & Writing
    -- MODULE 2 (27 new questions, 32 minutes)
    -- ════════════════════════════════════════════════════════
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_rw_id,
        'Reading & Writing Module 2',
        'Each question is based on a passage or pair of passages. Select the best answer for each question.',
        'MCQ',
        27,
        32,
        2
    )
    RETURNING idpaper INTO v_rw_p2;

    -- ── Unit 1: Information & Ideas (Module 2, 7 questions) ──
    -- (reuses v_rw_unit1 — units are course-level, not paper-level)

    -- Group 28 – Coral Reefs
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Coral Reef Biodiversity',
        'Coral reefs, which occupy less than one percent of the ocean floor, support an estimated twenty-five percent of all marine species. Scientists classify reefs as "biodiversity hotspots"—ecosystems where an unusually high concentration of species coexist in a small area. Over the past three decades, rising ocean temperatures and acidification driven by increased atmospheric carbon dioxide have caused widespread bleaching events. A 2022 global survey found that approximately half of the world''s reef area had experienced significant bleaching since 1990, with mortality rates highest in the Indian Ocean and the Great Barrier Reef.',
        1)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit1,
     'According to the passage, scientists classify coral reefs as "biodiversity hotspots" primarily because:',
     'They cover a large portion of the ocean floor',
     'They are distributed across all of the world''s oceans',
     'They support a disproportionately large number of species relative to their small area',
     'They have experienced more bleaching than any other marine ecosystem',
     'C',
     'The passage defines "biodiversity hotspots" as ecosystems where an unusually high concentration of species coexist in a small area—directly linking the classification to species density relative to size.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 29 – Social Media and Loneliness (2-question group)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Social Media and Loneliness',
        'Sociologist Amara Chen surveyed 1,200 adults between the ages of 18 and 35 about their social media habits and subjective feelings of social connection. Chen found that participants who spent more than four hours daily on social media reported higher rates of loneliness than those who spent less than one hour, even after controlling for factors such as living alone and employment status. Chen cautioned, however, that the survey design could not establish causality: it was equally plausible that lonely individuals seek more social media use rather than that social media causes loneliness.',
        2)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit1,
     'Which claim does Chen''s survey most directly support?',
     'Social media use causes loneliness in young adults',
     'Lonely individuals are incapable of forming real-world friendships',
     'Heavy social media use is associated with greater reported loneliness',
     'Adults who live alone use social media more than those who live with others',
     'C',
     'The survey shows a correlation between high social media use and reported loneliness. Chen explicitly cautions against inferring causation, making C the most accurately scoped claim.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit1,
     'According to the passage, why does Chen caution against concluding that social media causes loneliness?',
     'The sample size was too small to be statistically reliable',
     'The survey could not rule out that loneliness drives social media use rather than the reverse',
     'Social media platforms were not designed to be measured for emotional impact',
     'The study did not control for age differences among participants',
     'B',
     'Chen explicitly notes that "it was equally plausible that lonely individuals seek more social media use"—this is the alternative causal direction that the survey design cannot eliminate.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 30 – Roman Aqueducts
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Roman Aqueducts',
        'The Roman aqueduct system, built over several centuries beginning around 312 BCE, represents one of antiquity''s most sophisticated feats of civil engineering. At its peak, eleven major aqueducts delivered more than one million cubic meters of fresh water daily to Rome''s one million inhabitants—a per-capita supply comparable to that of many modern cities. Engineers relied entirely on gravity, constructing precisely calibrated gradients across hundreds of kilometers of terrain. The system''s longevity, with some aqueducts remaining in partial use into the medieval period, testifies to the durability of Roman construction techniques.',
        3)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit1,
     'The passage most strongly supports which of the following conclusions about Roman aqueducts?',
     'Roman aqueducts were less efficient than modern water systems',
     'Roman engineers used pumping technology to move water across long distances',
     'The aqueduct system delivered water at a per-capita rate comparable to many modern cities',
     'Aqueduct construction began during the height of the Roman Empire',
     'C',
     'The passage explicitly states that the per-capita supply was "comparable to that of many modern cities." Option B contradicts the passage (gravity, not pumps). Option D is incorrect—construction began around 312 BCE, before the peak of empire.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 31 – Bee Colony Collapse
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Bee Colony Collapse Disorder',
        'Since 2006, beekeepers in the United States have reported average annual colony losses of approximately 30%, far above the historically typical 10–15%. Researchers have proposed several contributing factors, including pesticide exposure, habitat loss, parasitic mites, and viral pathogens. A series of controlled studies found that exposure to neonicotinoid pesticides—widely used on corn, soy, and canola—impaired bees'' navigation and memory, reducing their ability to return to the hive. However, field studies conducted under realistic agricultural conditions have produced more ambiguous results, leading some scientists to argue that colony collapse is best understood as a syndrome caused by multiple interacting stressors rather than a single agent.',
        4)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit1,
     'The passage suggests that field studies on neonicotinoids and bee colonies have complicated the research picture primarily because:',
     'Field studies used different bee species than controlled laboratory studies',
     'Results under realistic agricultural conditions were less clear-cut than controlled study results',
     'Field researchers failed to control for parasitic mite infestations',
     'Neonicotinoids were banned before field studies could be completed',
     'B',
     'The passage states that "field studies conducted under realistic agricultural conditions have produced more ambiguous results"—directly supporting B. No mention is made of different species, mite controls, or bans.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 32 – Harlem Renaissance
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'The Harlem Renaissance',
        'The Harlem Renaissance, which flourished between roughly 1920 and 1940, was a watershed moment in African American cultural history. Writers such as Langston Hughes and Zora Neale Hurston, musicians including Duke Ellington, and visual artists like Aaron Douglas collectively forged a new aesthetic that celebrated Black identity and challenged prevailing stereotypes. Scholars have debated whether the movement constituted a genuine cultural revolution or primarily served a white audience hungry for an exoticized vision of Black urban life. Hughes himself addressed this tension directly, insisting in his 1926 essay "The Negro Artist and the Racial Mountain" that Black artists must create for their own community first.',
        5)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit1,
     'According to the passage, Hughes'' 1926 essay primarily argued that Black artists should:',
     'Abandon traditional African American musical forms in favor of classical styles',
     'Prioritize creating work for their own community rather than for white audiences',
     'Reject the commercial success that came with the Harlem Renaissance',
     'Collaborate with white publishers to reach a broader audience',
     'B',
     'The passage states Hughes insisted Black artists "must create for their own community first," directly supporting B. The essay addressed the tension between authentic expression and white-audience appeal.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 33 – Urban Heat Islands
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Urban Heat Islands',
        'Urban heat islands form when cities replace natural land surfaces with pavement, buildings, and other heat-absorbing materials, causing metropolitan areas to experience significantly higher temperatures than surrounding rural regions. Studies in major U.S. cities have documented temperature differentials of up to 7°C between urban cores and nearby rural areas on calm summer nights. Researchers have proposed several mitigation strategies, including expanding urban tree canopy, installing reflective "cool roofs," and increasing green spaces. A meta-analysis of forty-three intervention studies found that tree planting had the greatest average cooling effect per unit area, reducing local surface temperatures by 2–8°C depending on tree species and placement.',
        6)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit1,
     'Based on the passage, which mitigation strategy was found to have the greatest average cooling effect per unit area?',
     'Installing reflective cool roofs',
     'Increasing impervious surface coverage',
     'Expanding urban tree canopy',
     'Reducing the number of buildings in urban cores',
     'C',
     'The passage explicitly states that the meta-analysis found "tree planting had the greatest average cooling effect per unit area." Cool roofs are mentioned as a strategy but not ranked highest.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Unit 2: Craft & Structure (Module 2, 7 questions) ────

    -- Group 34 – Nascent / vocabulary
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'The Early Cinema Industry',
        'In the first decade of the twentieth century, cinema was still a nascent industry, operating out of cramped storefront theaters called nickelodeons and relying on short films no longer than a few minutes. Entrepreneurs and showmen—rather than artists or storytellers—dominated the business, and the medium was widely dismissed by cultural critics as a passing novelty for the working classes. It was not until D.W. Griffith and other pioneering directors began experimenting with editing techniques and narrative structure that film began its evolution into a recognized art form.',
        7)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit2,
     'As used in the passage, "nascent" most nearly means:',
     'Declining and obsolete',
     'Newly emerging and undeveloped',
     'Highly profitable',
     'Internationally recognized',
     'B',
     '"Nascent" means just beginning to develop or exist. The passage describes early cinema as operating from cramped storefronts with short films and dismissed as a novelty—consistent with an undeveloped, emerging industry.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 35 – Plastic Pollution / figurative language
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'The Plastic Tide',
        'Every year, an estimated eight million metric tons of plastic enter the world''s oceans, where it breaks into microparticles that infiltrate the tissues of marine life and eventually work their way into the human food chain. Marine biologists describe the accumulation of plastic debris in ocean gyres as a "slow-motion catastrophe"—one that lacks the dramatic immediacy of an oil spill but may ultimately prove more pervasive and harder to reverse. Unlike a discrete pollution event, plastic contamination is diffuse, borderless, and self-perpetuating as long as production continues at its current rate.',
        8)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit2,
     'The phrase "slow-motion catastrophe" in the passage is best understood as:',
     'A simile comparing ocean pollution to a film being played slowly',
     'A metaphor conveying that plastic pollution is a serious disaster unfolding gradually',
     'Personification giving human qualities to the ocean''s plastic debris',
     'An understatement minimizing the environmental impact of plastic',
     'B',
     '"Slow-motion catastrophe" is a metaphor—a direct comparison (no "like" or "as") that frames the pollution as a disaster characterized by its gradual, rather than sudden, development. The context reinforces severity, not understatement.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 36 – Corroborate / vocabulary
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Archaeological Dating Methods',
        'For decades, archaeologists relied primarily on stratigraphy—the analysis of soil layers—to assign relative dates to artifacts. The advent of radiocarbon dating in the 1950s provided an independent, absolute chronological tool that allowed researchers to corroborate or challenge dates previously inferred from stratigraphic position alone. When the two methods agreed, scholars gained confidence in their timelines; when they diverged, it prompted re-examination of assumptions embedded in both techniques. Today, a third method—dendrochronology, or tree-ring dating—provides yet another independent check on disputed chronologies.',
        9)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit2,
     'As used in the passage, "corroborate" most nearly means:',
     'Replace and make obsolete',
     'Contradict with new evidence',
     'Confirm or support with independent evidence',
     'Complicate beyond resolution',
     'C',
     'The passage sets up a binary: radiocarbon dating could "corroborate or challenge" earlier dates. When the two methods "agreed," scholars gained confidence—showing that corroborate means to confirm or support.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 37 – Space Exploration / passage structure
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'The Case for Deep Space Exploration',
        'Critics of deep space exploration argue that the billions of dollars devoted to missions beyond Mars could be better spent addressing immediate terrestrial problems such as poverty and climate change. Proponents counter that space programs have historically generated technologies—including memory foam, water filtration systems, and scratch-resistant lenses—that have improved life on Earth. A more fundamental argument, however, holds that humanity''s long-term survival depends on becoming a multi-planetary species: no single catastrophic event—an asteroid impact, a pandemic, or a supervolcano eruption—could then eliminate the entire human population. Whether this existential justification outweighs near-term humanitarian concerns is ultimately a question of values, not science.',
        10)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit2,
     'The organization of the passage is best described as:',
     'A personal narrative about a scientist''s career in space exploration',
     'A chronological history of major space missions',
     'A presentation of opposing viewpoints followed by a more fundamental argument and a concluding observation',
     'A refutation of all arguments against deep space exploration',
     'C',
     'The passage presents critics'' view, then proponents'' counter, then a "more fundamental argument," and concludes that the question is one of values—a multi-perspective structure ending with a broader observation, not a one-sided refutation.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 38 – Public Transit / author's purpose
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Investing in Public Transportation',
        'Every dollar invested in public transportation generates approximately five dollars in economic returns, according to a 2020 analysis by the American Public Transportation Association. Despite this compelling figure, transit funding in the United States has consistently lagged behind highway investment for decades. Advocates argue that robust public transit reduces traffic congestion, lowers household transportation costs, and cuts greenhouse gas emissions. Yet millions of Americans live in regions with no meaningful transit access, effectively excluding them from labor markets and services concentrated in city centers. Closing this access gap will require not incremental adjustments but a fundamental reorientation of national transportation policy.',
        11)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit2,
     'The author''s primary purpose in the passage is to:',
     'Describe the history of public transportation funding in the United States',
     'Argue that the United States should fundamentally change its approach to transportation investment',
     'Present a balanced comparison of public transit and highway investment',
     'Explain the economic methodology used to calculate transit returns',
     'B',
     'The passage builds toward a call for "a fundamental reorientation of national transportation policy." The economic statistic and list of benefits all serve to support this central argument, not to neutrally compare or explain methodology.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 39 – Technology and Attention / tone
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Technology and Sustained Attention',
        'Researchers studying the effects of digital technology on cognition have documented a troubling pattern: average sustained attention spans in task-completion studies have declined measurably over the past two decades, a period that coincides almost exactly with the mass adoption of smartphones and social media. Notifications, algorithmically curated feeds, and infinite scroll mechanisms are designed by engineers to maximize engagement—which, in practice, means maximizing interruption. We are not merely distracted; we are being systematically trained to be distractible. The implications for education, productivity, and democratic deliberation are not yet fully understood, but the early evidence is not reassuring.',
        12)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit2,
     'The author''s tone throughout the passage is best described as:',
     'Celebratory and enthusiastic about technological innovation',
     'Neutral and objective, presenting findings without judgment',
     'Alarmed and critical of the effects of digital technology on attention',
     'Nostalgic and resigned to inevitable technological change',
     'C',
     'Words such as "troubling," "systematically trained to be distractible," and "not reassuring" signal alarm and critical judgment. The author is not neutral (word choice is evaluative) nor merely nostalgic (the focus is present harm, not past loss).',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- Group 40 – Marie Curie / point of view
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Marie Curie''s Scientific Legacy',
        'Marie Curie remains the only person to have won Nobel Prizes in two different scientific disciplines—Physics in 1903 and Chemistry in 1911. Her isolation of radium and polonium fundamentally transformed the understanding of atomic structure and laid groundwork for nuclear medicine. Yet biographers have noted that the French Academy of Sciences refused to admit her as a member, and contemporaries frequently attributed her achievements to her husband Pierre rather than to her own intellect. Curie''s career thus illuminates both the power of individual genius to transcend institutional barriers and the durability of those barriers in limiting recognition.',
        13)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit2,
     'The passage''s final sentence primarily serves to:',
     'Criticize the French Academy of Sciences for its historical decisions',
     'Summarize the key scientific discoveries Curie made during her career',
     'Acknowledge both Curie''s exceptional achievement and the persistent institutional obstacles she faced',
     'Argue that modern science institutions are still as exclusionary as they were in Curie''s era',
     'C',
     'The final sentence explicitly holds two ideas in tension: "the power of individual genius to transcend institutional barriers and the durability of those barriers." This balanced framing acknowledges both achievement and obstacle—matching C.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Unit 3: Expression of Ideas (Module 2, 7 questions) ──

    -- Group 41 – Biodiversity supporting detail
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Biodiversity and Ecosystem Stability (Draft)',
        'A student is writing a science essay arguing that biodiversity is essential to ecosystem health. The student has written: "Ecosystems with greater species diversity tend to be more resilient to disturbances such as drought or disease. [Blank sentence] For this reason, conservation efforts should prioritize protecting habitats that shelter the greatest variety of species."',
        14)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit3,
     'Which sentence best fills the blank to support the student''s argument?',
     'Scientists have classified over 8.7 million species on Earth.',
     'Studies show that plots with more plant species recover faster after drought than low-diversity plots.',
     'Tropical rainforests are the most biodiverse ecosystems on the planet.',
     'Extinctions have accelerated over the past century due to habitat loss.',
     'B',
     'Option B directly supports the claim that diversity increases resilience by providing evidence that high-diversity plots recover faster after a specific disturbance (drought). The other options provide context but do not directly support the resilience argument.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 42 – Nutrition essay transition
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Dietary Fiber Essay (Transition)',
        'A student is drafting an essay on the health benefits of dietary fiber. One paragraph ends: "Soluble fiber has been shown to lower LDL cholesterol levels, reducing the risk of cardiovascular disease." The next sentence begins: "[Blank], insoluble fiber promotes healthy digestion by speeding the movement of food through the intestines." The student wants the transition to signal that a second, related benefit is being introduced.',
        15)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit3,
     'Which transition word or phrase best fills the blank to signal that a second related benefit is being introduced?',
     'However',
     'In contrast',
     'Similarly',
     'In addition',
     'D',
     '"In addition" signals that a new, supplementary benefit is being added to the previous one. "However" and "In contrast" imply opposition, and "Similarly" implies the two benefits work in the same way, which is inaccurate since one is soluble and one is insoluble.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 43 – Recycling essay / relevance
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Municipal Recycling Programs (Relevance)',
        'A student is writing a persuasive essay arguing that cities should expand curbside recycling programs. The student wants to add a sentence to the following paragraph: "Expanding curbside recycling reduces the volume of waste sent to landfills and lowers greenhouse gas emissions from decomposing organic materials. [Blank sentence] Cities that have expanded recycling infrastructure report significant long-term savings in waste disposal costs."',
        16)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit3,
     'Which sentence, if added in the blank, is most relevant to the paragraph''s argument?',
     'Recycling programs were first introduced in the United States in the 1970s.',
     'Some residents find sorting recyclables inconvenient.',
     'Recycling aluminum requires 95% less energy than producing aluminum from raw ore.',
     'Many countries rank recycling as a lower environmental priority than reducing consumption.',
     'C',
     'Option C directly supports the argument by providing a concrete environmental benefit of recycling (energy savings), which fits between the emissions reduction point and the cost savings point. The other options are either historical background, a counterpoint, or an off-topic comparison.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 44 – Social media and body image / weakening
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Social Media and Body Image (Argument Evaluation)',
        'A student''s essay argues: "Exposure to idealized body images on social media platforms directly causes negative body image and reduced self-esteem in teenage girls. Platforms should therefore be required to label digitally altered images." A classmate challenges the student to identify what evidence would most undermine the causal claim at the heart of this argument.',
        17)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit3,
     'Which finding, if true, would most weaken the student''s causal argument?',
     'Teenage girls spend an average of four hours per day on social media.',
     'Idealized body images in magazines were associated with negative body image before social media existed.',
     'Several social media platforms have voluntarily introduced image-labeling features.',
     'Teenage girls report feeling worse about their bodies after viewing social media.',
     'B',
     'If negative body image existed before social media, then social media cannot be the direct cause—it suggests a pre-existing vulnerability or a cause rooted in idealized imagery more broadly, not social media specifically. This directly attacks the causal claim.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- Group 45 – Urban planning / concision
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Mixed-Use Zoning Report (Concision)',
        'A city planner is editing a report on mixed-use zoning for a public meeting. The draft contains the following sentence: "The implementation of mixed-use zoning policies in the downtown area has the potential to result in a reduction in the number of car trips that residents make on a daily basis by allowing people to live in closer proximity to the places where they work and shop."',
        18)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit3,
     'Which revision most effectively improves the concision of the sentence?',
     'Mixed-use zoning downtown could reduce daily car trips by placing homes closer to workplaces and shops.',
     'Mixed-use zoning has the potential to reduce the number of car trips if implemented in the downtown area.',
     'The implementation of mixed-use zoning could possibly result in fewer daily car trips for downtown residents.',
     'Mixed-use zoning in the downtown area may have the potential to reduce car trips residents make each day.',
     'A',
     'Option A eliminates all major redundancies while preserving full meaning: "has the potential to result in a reduction"→"could reduce," "the number of car trips that residents make on a daily basis"→"daily car trips," "living in closer proximity to the places where they work and shop"→"placing homes closer to workplaces and shops."',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 46 – Education funding / logic (new, HARD)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'School Funding Equity (Draft)',
        'A policy student is drafting an argument about school funding reform. The student has written: "Schools in low-income districts consistently receive less funding per pupil than schools in wealthy districts, largely because school funding is tied to local property taxes. [Blank sentence] Reforming the funding formula is therefore essential to ensuring that all students have access to quality education."',
        19)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit3,
     'Which sentence best fills the blank to strengthen the logical connection between the funding gap and the call for reform?',
     'Property taxes have been the primary source of school funding since the nineteenth century.',
     'This funding gap translates directly into fewer qualified teachers, outdated materials, and inferior facilities in the schools that need the most support.',
     'Many affluent districts use private donations to supplement their already generous public funding.',
     'Several states have attempted school funding reforms with mixed results.',
     'B',
     'Option B completes the logical chain: the funding gap → concrete educational harms → need for reform. Without this link, the call for reform is less compelling. The other options add context or counterpoint but do not strengthen the core logical progression.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- Group 47 – AI introduction choice (HARD)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Artificial Intelligence in Healthcare (Introduction Choice)',
        'A student is writing an essay arguing that artificial intelligence will transform medical diagnosis over the next decade. The student is deciding between two possible opening sentences. Sentence 1: "Artificial intelligence is a technology that has been developed over many decades." Sentence 2: "When a machine learning algorithm correctly identified a rare form of eye disease from a retinal scan in 0.3 seconds—faster and more accurately than any human specialist—it signaled that medicine''s diagnostic future had already arrived."',
        20)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit3,
     'Which opening sentence would most effectively introduce an essay arguing that AI will transform medical diagnosis?',
     'Sentence 1, because it provides essential background on AI''s development',
     'Sentence 2, because it immediately engages the reader with a specific, compelling example that supports the essay''s central argument',
     'Sentence 1, because beginning with a definition is always the clearest way to open a persuasive essay',
     'Sentence 2, because statistics are always more persuasive than general claims',
     'B',
     'Sentence 2 opens with a vivid, specific anecdote that directly illustrates the transformative potential being argued. Sentence 1 provides generic background that does not engage the reader or advance the argument. Effective introductions typically hook the reader and connect immediately to the thesis.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Unit 4: Standard English Conventions (Module 2, 6 questions) ──

    -- Group 48 – Pronoun-antecedent agreement
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Community Center Proposal (Pronoun Agreement)',
        'A city council member is reviewing a proposal for a new community center. The proposal contains the following sentence: "The planning committee submitted [their / its] final recommendation to the mayor after six months of community consultations."',
        21)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit4,
     'Which version of the sentence correctly handles pronoun-antecedent agreement?',
     'The planning committee submitted their final recommendation to the mayor.',
     'The planning committee submitted its final recommendation to the mayor.',
     'The planning committee submitted it''s final recommendation to the mayor.',
     'The planning committee submitted they''re final recommendation to the mayor.',
     'B',
     '"Committee" is a singular collective noun acting as a unified body. It takes the singular pronoun "its." "Their" would apply if the committee members were acting individually. "It''s" is a contraction of "it is," not a possessive.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 49 – Parallel structure
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Environmental Science Report (Parallel Structure)',
        'A student is editing a report on sustainable agriculture. The report lists the benefits of crop rotation: "Crop rotation improves soil health, [reduces / reducing] pest populations, and [can prevent / prevents] the depletion of specific nutrients." The student wants to ensure the three items in the list are grammatically parallel.',
        22)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit4,
     'Which version of the sentence maintains parallel grammatical structure throughout the list?',
     'Crop rotation improves soil health, reducing pest populations, and can prevent the depletion of specific nutrients.',
     'Crop rotation improves soil health, reduces pest populations, and prevents the depletion of specific nutrients.',
     'Crop rotation improves soil health, reduces pest populations, and the depletion of specific nutrients is prevented.',
     'Crop rotation is improving soil health, reduces pest populations, and prevents the depletion of nutrients.',
     'B',
     'Option B uses three parallel simple present-tense verbs: "improves," "reduces," and "prevents." The other options mix verb forms (gerunds, modal verbs, passive voice, or progressive tense) inconsistently.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 50 – Nonrestrictive clause / comma usage
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Museum Press Release (Comma with Clause)',
        'A museum communications officer is editing a press release. The press release contains the following sentence: "The new exhibit which opens on June 1 will feature over two hundred artifacts from ancient Egypt." The officer must decide whether to set the clause "which opens on June 1" off with commas.',
        23)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit4,
     'Which version of the sentence correctly punctuates the underlined clause?',
     'The new exhibit which opens on June 1 will feature over two hundred artifacts from ancient Egypt.',
     'The new exhibit, which opens on June 1, will feature over two hundred artifacts from ancient Egypt.',
     'The new exhibit; which opens on June 1, will feature over two hundred artifacts from ancient Egypt.',
     'The new exhibit which, opens on June 1 will feature over two hundred artifacts from ancient Egypt.',
     'B',
     '"Which opens on June 1" is a nonrestrictive clause—it adds supplementary information but is not essential to identifying which exhibit is being discussed. Nonrestrictive clauses must be set off by commas. "That" (no commas) would be used for restrictive clauses.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 51 – Verb tense consistency
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'History Essay on the Moon Landing (Verb Tense)',
        'A student is writing a historical essay about the Apollo 11 mission. The essay contains the following passage: "On July 20, 1969, Neil Armstrong descended the lunar module''s ladder and [sets / set] foot on the surface of the Moon. He [looks / looked] across the barren landscape and [speaks / spoke] the famous words that would be broadcast to hundreds of millions of people on Earth."',
        24)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit4,
     'Which version of the sentence maintains consistent verb tense throughout the passage?',
     'Armstrong descended the ladder and sets foot on the Moon. He looks across the landscape and spoke the famous words.',
     'Armstrong descended the ladder and set foot on the Moon. He looked across the landscape and spoke the famous words.',
     'Armstrong descends the ladder and set foot on the Moon. He looked across the landscape and speaks the famous words.',
     'Armstrong descended the ladder and set foot on the Moon. He looks across the landscape and spoke the famous words.',
     'B',
     'A historical narrative describing a past event should use consistent simple past tense throughout. Option B uses "descended," "set," "looked," and "spoke"—all simple past. The other options mix past and present tense inconsistently.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- Group 52 – Run-on sentence
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Climate Journalism Draft (Run-on Sentence)',
        'A student journalist is editing an article for the school newspaper. The article contains the following run-on sentence: "The glacier has retreated by more than two kilometers since measurements began in 1950 scientists attribute this loss primarily to rising regional temperatures driven by climate change."',
        25)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit4,
     'Which revision correctly fixes the run-on sentence?',
     'The glacier has retreated by more than two kilometers since measurements began in 1950, scientists attribute this loss primarily to rising regional temperatures.',
     'The glacier has retreated by more than two kilometers since measurements began in 1950 and scientists attribute this loss primarily to rising regional temperatures driven by climate change.',
     'The glacier has retreated by more than two kilometers since measurements began in 1950; scientists attribute this loss primarily to rising regional temperatures driven by climate change.',
     'The glacier has retreated by more than two kilometers, since measurements began in 1950 scientists attribute this to rising temperatures.',
     'C',
     'A semicolon correctly joins two independent clauses without a coordinating conjunction. Option A creates a comma splice. Option B omits the trailing phrase "driven by climate change." Option D restructures the sentence incorrectly and changes its meaning.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- Group 53 – Sentence fragment
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_rw_p2,
        'Travel Writing Sample (Sentence Fragment)',
        'An editor is reviewing a travel writing submission. The editor must identify which of the following is a complete sentence and which are fragments that must be revised before publication.',
        26)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_rw_id, v_rw_p2, v_rw_unit4,
     'Which of the following is a complete sentence that requires no revision?',
     'Wandering through the narrow cobblestone streets of the old city at dawn.',
     'A skyline unlike any other, glittering with lights reflected in the harbor.',
     'The market opened at six every morning, filling the square with the scent of fresh bread and spices.',
     'Because the train arrived two hours late and the hotel had given away our reservation.',
     'C',
     'Option C has a clear subject ("The market"), a complete predicate ("opened at six every morning"), and a participial phrase adding description. Options A and B are noun phrases or participial phrases with no predicate. Option D is a subordinate clause with no main clause.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

END $$;
