-- ============================================================
-- ACT Exam – Seed Data (Papers, Units & Questions)
--
-- Assumes the ACT exam and its four courses already exist:
--   "ACT English", "ACT Math", "ACT Reading", "ACT Science"
-- Run in: Supabase SQL editor → New query → paste → Run
-- ============================================================

DO $$
DECLARE
    v_eng_id    INTEGER;
    v_math_id   INTEGER;
    v_read_id   INTEGER;
    v_sci_id    INTEGER;
    v_eng_p1    INTEGER;
    v_math_p1   INTEGER;
    v_read_p1   INTEGER;
    v_sci_p1    INTEGER;
    v_unit_id   INTEGER;
BEGIN

    -- ── Resolve existing course IDs ───────────────────────────
    SELECT idcourse INTO v_eng_id
    FROM courses WHERE lower(coursename) = 'act english' LIMIT 1;

    SELECT idcourse INTO v_math_id
    FROM courses WHERE lower(coursename) = 'act math' LIMIT 1;

    SELECT idcourse INTO v_read_id
    FROM courses WHERE lower(coursename) = 'act reading' LIMIT 1;

    SELECT idcourse INTO v_sci_id
    FROM courses WHERE lower(coursename) = 'act science' LIMIT 1;

    IF v_eng_id IS NULL THEN RAISE EXCEPTION 'Course "ACT English" not found.'; END IF;
    IF v_math_id IS NULL THEN RAISE EXCEPTION 'Course "ACT Math" not found.'; END IF;
    IF v_read_id IS NULL THEN RAISE EXCEPTION 'Course "ACT Reading" not found.'; END IF;
    IF v_sci_id IS NULL THEN RAISE EXCEPTION 'Course "ACT Science" not found.'; END IF;

    -- ════════════════════════════════════════════════════════
    -- COURSE 1 – ACT English
    -- ════════════════════════════════════════════════════════
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_eng_id,
        'English Test',
        'Each passage is followed by questions about the underlined portions. Choose the answer that best corrects or improves the passage.',
        'MCQ',
        10,
        45,
        1
    )
    RETURNING idpaper INTO v_eng_p1;

    -- ── Unit 1: Usage & Mechanics ─────────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Usage & Mechanics', 'Summaries/ACT/act_english_usage.txt', 1)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version of the underlined portion is correct? "The team of engineers [work / works] late every Friday."',
     'work', 'works', 'are working', 'have worked',
     'B',
     'The subject is "team," a collective noun that is grammatically singular. It requires the singular verb "works."',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which punctuation correctly separates the two independent clauses? "She finished the report ___ her manager approved it immediately."',
     'She finished the report, her manager approved it immediately.',
     'She finished the report; her manager approved it immediately.',
     'She finished the report: her manager approved it immediately.',
     'She finished the report her manager approved it immediately.',
     'B',
     'Two independent clauses must be joined by a semicolon, a comma + coordinating conjunction, or a period. A semicolon alone is correct here.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses the apostrophe?',
     'The students books were left in the classroom.',
     'The student''s books were left in the classroom.',
     'The students'' book''s were left in the classroom.',
     'The students book''s were left in the classroom.',
     'B',
     '"Student''s" is the singular possessive. If multiple students each had books it would be "students''," but the singular form is correct here.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version avoids a dangling modifier? "[Having studied all night,] ___"',
     'Having studied all night, the exam seemed easy to her.',
     'Having studied all night, Maria found the exam easy.',
     'Having studied all night, it was easy for the exam.',
     'Having studied all night, the exam was easy.',
     'B',
     'The participial phrase "Having studied all night" must be followed immediately by the noun it modifies — Maria, not "the exam."',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which pronoun correctly completes the sentence? "Between you and ___, this project needs more work."',
     'I', 'me', 'myself', 'we',
     'B',
     'After a preposition ("between"), the objective case pronoun "me" is required, not the subjective "I."',
     'MULTIPLE_CHOICE', 'HARD');

    -- ── Unit 2: Rhetorical Skills ─────────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Rhetorical Skills', 'Summaries/ACT/act_english_rhetorical.txt', 2)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer wants to add a sentence supporting the claim that urban farming reduces food miles. Which addition is most relevant?',
     'Many cities have large parks and open spaces.',
     'Studies show that produce grown within city limits travels an average of 11 miles to market, compared to 1,500 miles for conventionally shipped food.',
     'Farming is one of the oldest human occupations.',
     'Urban residents often prefer organic food.',
     'B',
     'Only option B directly quantifies how urban farming reduces the distance food travels, which supports the specific claim about food miles.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which transition best connects these sentences? "The experiment produced unexpected results. ___, the team decided to repeat it."',
     'Therefore', 'Nevertheless', 'Similarly', 'For instance',
     'A',
     '"Therefore" signals a logical consequence — because the results were unexpected, the team decided to repeat the experiment.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version is most concise and avoids redundancy?',
     'The committee met together at the same time simultaneously.',
     'The committee met simultaneously.',
     'The committee met together simultaneously at the same time.',
     'The committee had a meeting together simultaneously.',
     'B',
     '"Met simultaneously" conveys the meaning without the redundant "together," "at the same time," and "had a meeting."',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer is drafting a formal scientific report. Which sentence best matches that tone?',
     'The results were pretty surprising and kind of hard to explain.',
     'The findings were unexpected and warrant further investigation.',
     'Nobody really expected these results, which is wild.',
     'We were shocked by what we found — it was totally unexpected!',
     'B',
     'Formal scientific writing uses precise, objective language. Option B uses appropriate vocabulary ("findings," "warrant," "investigation") without informal expressions.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'The writer wants to delete the underlined sentence: "Carbon dioxide is a greenhouse gas." Should it be kept or deleted?',
     'Kept, because it introduces a key term needed to understand the paragraph.',
     'Kept, because it provides an interesting historical fact.',
     'Deleted, because it contradicts the main argument.',
     'Deleted, because it repeats information already stated clearly in the previous sentence.',
     'D',
     'If the concept was already clearly explained, repeating it adds redundancy. The ACT rewards conciseness when no new information is added.',
     'MULTIPLE_CHOICE', 'HARD');

    -- ════════════════════════════════════════════════════════
    -- COURSE 2 – ACT Math
    -- ════════════════════════════════════════════════════════
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_math_id,
        'Math Test',
        'Solve each problem, choose the correct answer, and fill in the corresponding oval. Calculators are permitted.',
        'MCQ',
        15,
        60,
        1
    )
    RETURNING idpaper INTO v_math_p1;

    -- ── Unit 1: Pre-Algebra & Elementary Algebra ──────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_math_id, 'Pre-Algebra & Elementary Algebra', 'Summaries/ACT/act_math_prealgebra.txt', 1)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p1, v_unit_id,
     'What is 40% of 250?',
     '80', '90', '100', '110',
     'C',
     '40% of 250 = 0.40 × 250 = 100.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'If a car travels 180 miles on 6 gallons of gas, how many miles can it travel on 10 gallons?',
     '250', '280', '300', '320',
     'C',
     'Rate = 180 / 6 = 30 mpg. Distance on 10 gallons = 30 × 10 = 300 miles.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'If x = −3, what is the value of 2x² − 4x + 1?',
     '19', '25', '31', '7',
     'C',
     '2(−3)² − 4(−3) + 1 = 2(9) + 12 + 1 = 18 + 12 + 1 = 31.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'Which of the following is a factor of 6x² + 11x − 10?',
     '(2x − 5)', '(3x + 2)', '(2x + 5)', '(3x − 5)',
     'C',
     '6x² + 11x − 10 = (2x + 5)(3x − 2). So (2x + 5) is a factor.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_math_id, v_math_p1, v_unit_id,
     'A bag contains 4 red, 3 blue, and 5 green marbles. What is the probability of randomly selecting a blue marble?',
     '1/4', '1/3', '3/12', '1/6',
     'A',
     'Total marbles = 4 + 3 + 5 = 12. P(blue) = 3/12 = 1/4.',
     'MULTIPLE_CHOICE', 'EASY');

    -- ── Unit 2: Intermediate Algebra & Coordinate Geometry ────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_math_id, 'Intermediate Algebra & Coordinate Geometry', 'Summaries/ACT/act_math_intermediate.txt', 2)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p1, v_unit_id,
     'What are the solutions to 2x² − 8 = 0?',
     'x = ±2', 'x = ±4', 'x = 2 only', 'x = ±√2',
     'A',
     '2x² = 8 → x² = 4 → x = ±2.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'If f(x) = x² − 3x + 2, what is f(4)?',
     '4', '5', '6', '7',
     'C',
     'f(4) = (4)² − 3(4) + 2 = 16 − 12 + 2 = 6.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_math_p1, v_unit_id,
     'What is the slope of the line passing through (−2, 3) and (4, −9)?',
     '−2', '2', '−1/2', '1/2',
     'A',
     'Slope = (−9 − 3) / (4 − (−2)) = −12 / 6 = −2.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'What is the midpoint of the segment with endpoints (1, 5) and (7, −3)?',
     '(4, 1)', '(3, 2)', '(4, 2)', '(3, 1)',
     'A',
     'Midpoint = ((1+7)/2, (5+(−3))/2) = (8/2, 2/2) = (4, 1).',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'Which inequality represents the solution to −3x + 6 > 15?',
     'x > −3', 'x < −3', 'x > 3', 'x < 3',
     'B',
     '−3x + 6 > 15 → −3x > 9 → x < −3 (flip inequality when dividing by negative).',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 3: Plane Geometry & Trigonometry ─────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_math_id, 'Plane Geometry & Trigonometry', 'Summaries/ACT/act_math_geometry.txt', 3)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p1, v_unit_id,
     'The interior angles of a triangle are in the ratio 2:3:5. What is the measure of the largest angle?',
     '54°', '72°', '90°', '108°',
     'C',
     'Angles sum to 180°. Ratio parts: 2k + 3k + 5k = 180 → 10k = 180 → k = 18. Largest = 5 × 18 = 90°.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'A circle has a circumference of 20π. What is its area?',
     '10π', '100π', '400π', '40π',
     'B',
     'C = 2πr = 20π → r = 10. Area = πr² = π(10)² = 100π.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'Two similar triangles have corresponding sides in the ratio 3:5. If the area of the smaller triangle is 27 cm², what is the area of the larger triangle?',
     '45 cm²', '75 cm²', '125 cm²', '135 cm²',
     'B',
     'Area ratio = (3/5)² = 9/25. If smaller area is 27, larger area = 27 × (25/9) = 75 cm².',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_math_id, v_math_p1, v_unit_id,
     'In a right triangle, the side opposite a 30° angle is 7. What is the length of the hypotenuse?',
     '7√3', '14', '7√2', '3.5',
     'B',
     'sin(30°) = opposite/hypotenuse = 7/h → h = 7/sin(30°) = 7/(1/2) = 14.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_math_p1, v_unit_id,
     'If tan(θ) = 5/12 and θ is in the first quadrant, what is sin(θ)?',
     '5/13', '12/13', '5/12', '12/5',
     'A',
     'tan = opp/adj = 5/12. Hypotenuse = √(5² + 12²) = √169 = 13. sin(θ) = opp/hyp = 5/13.',
     'MULTIPLE_CHOICE', 'HARD');

    -- ════════════════════════════════════════════════════════
    -- COURSE 3 – ACT Reading
    -- ════════════════════════════════════════════════════════
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_read_id,
        'Reading Test',
        'Each passage is followed by questions. After reading each passage, choose the best answer to each question based on what is stated or implied in the passage.',
        'MCQ',
        10,
        35,
        1
    )
    RETURNING idpaper INTO v_read_p1;

    -- ── Unit 1: Literary Narrative & Prose Fiction ────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_read_id, 'Literary Narrative & Prose Fiction', 'Summaries/ACT/act_reading_literary.txt', 1)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_read_id, v_read_p1, v_unit_id,
     'A passage describes a character who "stood at the edge of the cliff, hands trembling, staring into the fog below." What does this most likely convey about the character?',
     'The character is excited about an upcoming adventure.',
     'The character is experiencing fear or uncertainty.',
     'The character enjoys dangerous hobbies.',
     'The character is searching for something lost.',
     'B',
     'Physical details like "trembling hands" and "fog below" are classic literary signals of fear, hesitation, or uncertainty — not excitement.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_read_id, v_read_p1, v_unit_id,
     'The narrator states: "I had not seen my father in twelve years, yet his voice was unchanged — the same low rumble that once meant safety." What is the primary effect of this detail?',
     'It establishes that the narrator has a poor memory.',
     'It suggests the narrator has forgiven his father.',
     'It evokes the narrator''s complex emotional relationship with his father.',
     'It shows that the father has not aged.',
     'C',
     'The contrast between years of absence and the unchanged, familiar voice reveals the narrator''s layered feelings — nostalgia, loss, and unresolved connection.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_read_id, v_read_p1, v_unit_id,
     'As used in the passage, the word "austere" most nearly means:',
     'Warm and welcoming', 'Severe and plain', 'Loud and chaotic', 'Colorful and decorative',
     'B',
     '"Austere" describes something severe, strict, or without decoration — the opposite of ornate or welcoming.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_read_id, v_read_p1, v_unit_id,
     'The author ends the story with the line: "She closed the door softly, as if she were afraid of waking a life she had already left behind." This ending is best described as:',
     'Triumphant and celebratory',
     'Ambiguous and melancholic',
     'Comedic and lighthearted',
     'Straightforward and conclusive',
     'B',
     'The imagery of closing a door softly on a "life already left behind" conveys quiet sorrow and unresolved feeling — characteristic of a melancholic, ambiguous ending.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_read_id, v_read_p1, v_unit_id,
     'The author''s primary purpose in the opening paragraph is most likely to:',
     'Provide historical background on the setting',
     'Establish a conflict between two characters',
     'Introduce the mood and setting of the story',
     'Present the story''s central argument',
     'C',
     'Opening paragraphs in literary fiction typically establish atmosphere, setting, and tone before developing plot or argument.',
     'MULTIPLE_CHOICE', 'EASY');

    -- ── Unit 2: Social Science, Humanities & Natural Science ──
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_read_id, 'Social Science, Humanities & Natural Science', 'Summaries/ACT/act_reading_nonfiction.txt', 2)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_read_id, v_read_p1, v_unit_id,
     'A passage states that a 2019 study found cities with more green space had 15% lower rates of anxiety disorders. Which conclusion is best supported?',
     'Green space is the only factor that reduces anxiety.',
     'Cities should eliminate all concrete surfaces.',
     'Access to green space may be associated with lower rates of anxiety.',
     'Anxiety disorders do not exist in rural areas.',
     'C',
     'The data shows an association, not causation. "May be associated with" is the appropriately cautious conclusion.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_read_id, v_read_p1, v_unit_id,
     'A humanities passage discusses two historians who disagree about the causes of World War I. Both historians would most likely agree that:',
     'Nationalism was the sole cause of the war',
     'The war was entirely avoidable',
     'World War I had multiple contributing factors',
     'Economic competition played no role in the war',
     'C',
     'Even when historians disagree on emphasis, they typically agree that major historical events have multiple causes rather than a single one.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_read_id, v_read_p1, v_unit_id,
     'A natural science passage describes how deep-sea fish produce light through bioluminescence. The author most likely includes this information to:',
     'Argue that deep-sea exploration is too expensive',
     'Illustrate how organisms adapt to extreme environments',
     'Compare deep-sea fish to freshwater fish',
     'Explain why the ocean is dark below 200 meters',
     'B',
     'Bioluminescence is presented as an adaptation to the lightless deep-sea environment — an example of how life adapts to extreme conditions.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_read_id, v_read_p1, v_unit_id,
     'According to the passage, which of the following best describes the author''s attitude toward the policy being discussed?',
     'Strongly supportive with no reservations',
     'Cautiously optimistic but acknowledging limitations',
     'Completely opposed and dismissive',
     'Neutral and entirely without opinion',
     'B',
     'Authors of analytical passages often present balanced views — supporting an idea while acknowledging its limitations. "Cautiously optimistic" fits this tone.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_read_id, v_read_p1, v_unit_id,
     'A social science passage compares two education systems. Compared to System A, System B is described as placing greater emphasis on:',
     'Standardized testing and memorization',
     'Collaborative projects and critical thinking',
     'Teacher-led instruction and rote learning',
     'Individual competition and ranking',
     'B',
     'ACT Reading questions about comparisons require close attention to passage details. The answer reflects what the passage explicitly states about System B''s emphasis.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ════════════════════════════════════════════════════════
    -- COURSE 4 – ACT Science
    -- ════════════════════════════════════════════════════════
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_sci_id,
        'Science Test',
        'Each passage presents scientific information in one of three formats: data representation, research summaries, or conflicting viewpoints. Answer each question based on the information provided.',
        'MCQ',
        10,
        35,
        1
    )
    RETURNING idpaper INTO v_sci_p1;

    -- ── Unit 1: Data Representation & Research Summaries ─────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_sci_id, 'Data Representation & Research Summaries', 'Summaries/ACT/act_science_data.txt', 1)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_sci_id, v_sci_p1, v_unit_id,
     'A table shows that enzyme activity increases from 10°C to 37°C, then drops sharply above 40°C. Which conclusion is best supported?',
     'The enzyme functions best at very high temperatures.',
     'The enzyme is most active around 37°C and denatures above 40°C.',
     'Temperature has no effect on enzyme activity.',
     'The enzyme works equally well at all temperatures below 40°C.',
     'B',
     'The data shows a peak at 37°C and a sharp drop above 40°C, consistent with optimal activity at body temperature and denaturation at higher temperatures.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'A graph shows that as altitude increases from 0 to 5,000 meters, atmospheric pressure decreases from 101 kPa to 54 kPa. What is the best description of this relationship?',
     'Atmospheric pressure increases with altitude.',
     'Atmospheric pressure and altitude are unrelated.',
     'Atmospheric pressure decreases as altitude increases.',
     'Atmospheric pressure remains constant above 2,000 meters.',
     'C',
     'The graph directly shows an inverse relationship: as altitude increases, atmospheric pressure decreases.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'An experiment tests the effect of light intensity on plant growth rate. The independent variable is:',
     'Plant growth rate', 'Type of plant used', 'Light intensity', 'Amount of water given',
     'C',
     'The independent variable is the one deliberately manipulated by the researcher — in this case, light intensity. Growth rate is the dependent variable.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'Study 1 shows that Drug A reduces blood pressure in 70% of patients. Study 2 shows Drug B reduces it in 55% of patients under the same conditions. Which conclusion is best supported?',
     'Drug B is more effective than Drug A.',
     'Drug A appears more effective than Drug B based on these studies.',
     'Both drugs are equally effective.',
     'Neither drug effectively reduces blood pressure.',
     'B',
     'Based solely on the data provided (70% vs 55%), Drug A shows a higher success rate. The conclusion must stay within the scope of the data.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'A researcher repeats an experiment five times and gets results: 42, 43, 41, 44, 42. Which best describes these results?',
     'High accuracy, low precision', 'Low accuracy, high precision', 'High precision, uncertain accuracy', 'Low precision, high accuracy',
     'C',
     'The results are clustered closely together (42–44), indicating high precision (consistency). Without knowing the true value, accuracy cannot be confirmed.',
     'MULTIPLE_CHOICE', 'HARD');

    -- ── Unit 2: Conflicting Viewpoints ────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_sci_id, 'Conflicting Viewpoints', 'Summaries/ACT/act_science_conflicting.txt', 2)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_sci_id, v_sci_p1, v_unit_id,
     'Scientist 1 claims that dinosaurs were warm-blooded; Scientist 2 claims they were cold-blooded. Both scientists would most likely agree that:',
     'All dinosaurs had identical metabolic rates',
     'Dinosaurs are closely related to modern birds',
     'The metabolic rate of dinosaurs can be determined with certainty from fossils',
     'Dinosaurs went extinct due to climate change alone',
     'B',
     'The close evolutionary relationship between dinosaurs and modern birds is broadly accepted in paleontology, regardless of the debate about metabolism.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'Scientist 1 argues that the extinction of megafauna was caused by climate change. Which finding would most support Scientist 1''s hypothesis?',
     'Fossil records show megafauna disappearing at the same time as early human settlements spread.',
     'Climate records show rapid cooling events immediately preceding megafauna extinction worldwide.',
     'Studies show early humans actively hunted megafauna species.',
     'Megafauna survived in regions where humans were present.',
     'B',
     'Evidence of rapid climate change coinciding with extinction worldwide directly supports the climate-change hypothesis, not the human-hunting hypothesis.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'Scientist 2 argues that human hunting caused megafauna extinction. Which finding would most weaken Scientist 2''s hypothesis?',
     'Spearheads were found near megafauna bones.',
     'Megafauna populations declined before humans arrived in several regions.',
     'Early humans are known to have consumed large animals.',
     'Cave paintings depict megafauna hunts.',
     'B',
     'If megafauna declined before humans arrived, human hunting cannot be the primary cause — this directly undermines Scientist 2''s hypothesis.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'Two scientists debate whether a newly discovered fossil belongs to Species X or Species Y. Which type of evidence would best resolve the dispute?',
     'The location where the fossil was found',
     'The age of the rock layer containing the fossil',
     'A DNA analysis comparing the fossil to known samples of Species X and Y',
     'The opinion of the scientist who discovered the fossil',
     'C',
     'DNA analysis provides direct molecular evidence to compare the fossil to known species, making it the most definitive way to resolve the classification dispute.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_sci_id, v_sci_p1, v_unit_id,
     'Scientist 1 and Scientist 2 disagree on the cause of a phenomenon but use the same experimental data. This disagreement most likely results from:',
     'One scientist making mathematical errors',
     'Different interpretations of the same data',
     'The data being falsified by one scientist',
     'The experiment being conducted incorrectly',
     'B',
     'In conflicting viewpoint passages, scientists typically share the same data but interpret it differently due to differing theoretical frameworks or assumptions.',
     'MULTIPLE_CHOICE', 'MEDIUM');

END $$;
