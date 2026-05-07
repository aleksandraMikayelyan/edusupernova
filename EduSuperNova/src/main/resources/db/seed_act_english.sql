-- ============================================================
-- ACT English – Full Seed Data (75 questions, 45 min)
-- Units:
--   1. Punctuation         (13 questions)
--   2. Grammar & Usage     (13 questions)
--   3. Sentence Structure  (12 questions)
--   4. Strategy            (12 questions)
--   5. Organization        (13 questions)
--   6. Style               (12 questions)
-- Assumes "ACT English" course already exists.
-- Run in: Supabase SQL editor → New query → paste → Run
-- ============================================================

DO $$
DECLARE
    v_eng_id  INTEGER;
    v_eng_p1  INTEGER;
    v_unit_id INTEGER;
BEGIN

    SELECT idcourse INTO v_eng_id
    FROM courses WHERE lower(coursename) = 'act english' LIMIT 1;

    IF v_eng_id IS NULL THEN
        RAISE EXCEPTION 'Course "ACT English" not found.';
    END IF;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_eng_id,
        'English Test',
        'Each passage is followed by questions. Choose the answer that best corrects or improves the underlined portion, or best answers the question about the passage.',
        'MCQ', 75, 45, 1
    )
    RETURNING idpaper INTO v_eng_p1;

    -- ════════════════════════════════════════════════════════
    -- UNIT 1 – Punctuation (13 questions)
    -- ════════════════════════════════════════════════════════
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Punctuation', 'Summaries/ACT/act_english_punctuation.txt', 1)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version correctly uses a comma after an introductory phrase?',
     'After years of hard work Maria finally received her promotion.',
     'After years of hard work, Maria finally received her promotion.',
     'After years of hard work; Maria finally received her promotion.',
     'After years, of hard work Maria finally received her promotion.',
     'B',
     'A comma is required after an introductory adverbial phrase to separate it from the main clause.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses "its" or "it''s"?',
     'The committee released it''s final report on Monday.',
     'Its been a difficult year for the organization.',
     'The school updated its curriculum last spring.',
     'The company celebrated it''s anniversary with a gala.',
     'C',
     '"Its" (no apostrophe) is the possessive pronoun. "It''s" is always a contraction of "it is" or "it has."',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly punctuates a nonrestrictive (nonessential) clause?',
     'My brother who lives in Tokyo is visiting next month.',
     'My brother, who lives in Tokyo, is visiting next month.',
     'My brother who lives in Tokyo, is visiting next month.',
     'My brother, who lives in Tokyo is visiting next month.',
     'B',
     'A nonrestrictive clause adds extra information that is not essential to identify the noun. It must be set off with commas on both sides.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses a semicolon?',
     'The storm knocked out power; but the generator kept the lights on.',
     'She loves hiking; especially on mountain trails.',
     'The project was due Friday; the team submitted it Thursday evening.',
     'He studied all night; hoping to pass the exam.',
     'C',
     'A semicolon joins two closely related independent clauses. It should not precede a coordinating conjunction or introduce a phrase/fragment.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version avoids an unnecessary comma?',
     'She, ran quickly to catch the bus.',
     'He studied hard, and passed the exam.',
     'The tall old oak tree fell during the storm.',
     'We need, to leave early tomorrow morning.',
     'C',
     '"Tall" and "old" are cumulative adjectives (tall modifies "old oak tree"), not coordinate adjectives, so no comma is needed between them.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses a colon?',
     'She needed: milk, eggs, and butter from the store.',
     'He had only one ambition: to become a concert pianist.',
     'The teacher announced: that the exam would be rescheduled.',
     'We traveled to: Paris, Rome, and Berlin last summer.',
     'B',
     'A colon correctly follows a complete independent clause to introduce an explanation, list, or elaboration. Do not use a colon immediately after a verb or preposition.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses em dashes as parenthetical interruption?',
     'The proposal—despite its many flaws—was approved unanimously.',
     'The proposal—despite its many flaws, was approved unanimously.',
     'The proposal, despite its many flaws—was approved unanimously.',
     'The proposal despite its many flaws—was approved unanimously.',
     'A',
     'Em dashes used as parenthetical interruptions must appear in pairs — one before and one after the interrupting phrase — mirroring the function of commas or parentheses.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly joins two independent clauses with a comma and coordinating conjunction?',
     'She wanted to study medicine but her grades needed improvement.',
     'She wanted to study medicine, but her grades needed improvement.',
     'She wanted to study medicine; but her grades needed improvement.',
     'She wanted to study medicine: but her grades needed improvement.',
     'B',
     'Two independent clauses joined by a coordinating conjunction (FANBOYS) require a comma before the conjunction. A semicolon is not used with a coordinating conjunction.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence uses the serial (Oxford) comma correctly?',
     'The recipe calls for flour, sugar and butter.',
     'The recipe calls for flour, sugar, and butter.',
     'The recipe calls for flour sugar, and butter.',
     'The recipe calls for, flour, sugar, and butter.',
     'B',
     'The serial comma appears after each item in a list of three or more, including before the final "and," to prevent ambiguity.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses parentheses?',
     'The study (published in 2021 revealed) a significant drop in air pollution.',
     'The study (published in 2021) revealed a significant drop in air pollution.',
     'The (study published in 2021) revealed a significant drop in air pollution.',
     'The study published (in 2021 revealed a significant) drop in air pollution.',
     'B',
     'Parentheses enclose supplemental information not essential to the main clause. The main clause must remain grammatically complete outside the parentheses.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly punctuates coordinate adjectives?',
     'It was a long tedious meeting that lasted four hours.',
     'It was a long, tedious meeting that lasted four hours.',
     'It was a long, tedious, meeting that lasted four hours.',
     'It was a, long tedious meeting that lasted four hours.',
     'B',
     'Coordinate adjectives independently modify the noun and are separated by a comma. Test: "a tedious, long meeting" works and "and" can be inserted between them, confirming they are coordinate.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly shows plural possessive?',
     'The athletes equipment was checked before the race.',
     'The athlete''s equipment were checked before the race.',
     'The athletes'' equipment was checked before the race.',
     'The athletes''s equipment was checked before the race.',
     'C',
     'For plural nouns ending in -s, the possessive is formed by adding only an apostrophe after the -s. "Athletes''" is the correct plural possessive.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly punctuates a subordinate clause at the beginning of a sentence?',
     'Because the road was icy the driver reduced her speed.',
     'Because the road was icy, the driver reduced her speed.',
     'Because, the road was icy, the driver reduced her speed.',
     'Because the road was icy; the driver reduced her speed.',
     'B',
     'When a subordinate (dependent) clause begins a sentence, it is followed by a comma before the main (independent) clause.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ════════════════════════════════════════════════════════
    -- UNIT 2 – Grammar & Usage (13 questions)
    -- ════════════════════════════════════════════════════════
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Grammar & Usage', 'Summaries/ACT/act_english_grammar.txt', 2)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version correctly completes the sentence? "The jury ___ reached its verdict after three days of deliberation."',
     'have', 'has', 'are having', 'were',
     'B',
     '"Jury" is a collective noun that functions as a single unit in American English. It takes a singular verb ("has") and singular pronoun ("its").',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version is correct? "The results of the experiment ___ published in a leading journal."',
     'was', 'were', 'has been', 'is',
     'B',
     'The subject is "results" (plural), not "experiment." Crossing out the prepositional phrase "of the experiment" reveals the plural subject requiring "were."',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence uses the correct pronoun case?',
     'The award was given to Sarah and I.',
     'The award was given to Sarah and me.',
     'The award was given to Sarah and myself.',
     'The award was given to Sarah and we.',
     'B',
     'After a preposition ("to"), the objective case pronoun "me" is required. "I" is the subjective case; "myself" is reflexive and cannot substitute for "me."',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses "who" or "whom"?',
     'Who did the manager choose for the position?',
     'Whom won the award at last night''s ceremony?',
     'The candidate whom impressed the committee was hired.',
     'Whom should I contact about the application?',
     'D',
     '"Whom" is the objective case. In "Whom should I contact," "whom" is the object of "contact." Substituting "him" — "I should contact him" — confirms the objective case is correct.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence maintains correct verb tense consistency?',
     'She walked into the room, sat down, and begins reading her book.',
     'She walks into the room, sat down, and began reading her book.',
     'She walked into the room, sat down, and began reading her book.',
     'She walked into the room, sits down, and began reading her book.',
     'C',
     'All three verbs in a past narrative sequence must be in the past tense: "walked," "sat," and "began."',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses an adverb to modify a verb?',
     'The athlete performed incredible at the championship.',
     'The athlete performed incrediblely at the championship.',
     'The athlete performed incredibly at the championship.',
     'The athlete performed incredible good at the championship.',
     'C',
     'Adverbs, not adjectives, modify verbs. "Incredibly" (adverb) correctly modifies the verb "performed." "Incredible" is an adjective.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses the comparative or superlative form?',
     'Of the two proposals, hers is the best.',
     'Of the two proposals, hers is the better.',
     'Of the three candidates, he is the more qualified.',
     'Between the four options, this one is the good.',
     'B',
     'When comparing exactly two things, use the comparative form ("better"). The superlative ("best") is reserved for comparisons of three or more.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence is correctly parallel?',
     'She enjoys hiking, to swim, and riding horses.',
     'She enjoys hiking, swimming, and to ride horses.',
     'She enjoys hiking, swimming, and riding horses.',
     'She enjoys to hike, swim, and riding horses.',
     'C',
     'Items in a list must be in the same grammatical form. "Hiking, swimming, and riding" maintains consistent gerund (-ing) form throughout.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses the subjunctive mood?',
     'If I was the president, I would reform the tax code.',
     'If I were the president, I would reform the tax code.',
     'If I am the president, I would reform the tax code.',
     'If I be the president, I would reform the tax code.',
     'B',
     'The subjunctive mood uses "were" (not "was") for hypothetical or contrary-to-fact conditions in all persons. "If I were" signals an unreal situation.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence has a clear, unambiguous pronoun reference?',
     'When Maria met Dr. Chen, she explained the new procedure.',
     'After the report and the memo were reviewed, it was filed.',
     'The manager told the assistant that he needed to revise the draft.',
     'Dr. Patel informed the committee that its recommendation had been accepted.',
     'D',
     'In option D, "its" clearly refers to "the committee." In options A, B, and C, the pronoun reference is ambiguous — it is unclear to whom or what "she," "it," or "he" refers.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses the simple past tense?',
     'Scientists have discovered a new species of frog last year.',
     'Scientists discovered a new species of frog last year.',
     'Scientists had discovered a new species of frog last year.',
     'Scientists are discovering a new species of frog last year.',
     'B',
     'The simple past ("discovered") is correct when a specific past time is mentioned ("last year"). The present perfect ("have discovered") is used without a specific past time marker.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses "neither...nor"?',
     'Neither the manager nor the employees was informed.',
     'Neither the manager nor the employees were informed.',
     'Neither the manager or the employees is informed.',
     'Neither the manager or the employees were informed.',
     'B',
     'With "neither...nor," the verb agrees with the nearer subject. "Employees" (plural) is closer to the verb, so "were" is correct. "Neither...or" is incorrect; it must be "neither...nor."',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence uses a reflexive pronoun correctly?',
     'Please send your application to my supervisor or myself.',
     'My colleague and myself prepared the presentation.',
     'The director herself approved the budget.',
     'Myself will handle the report this afternoon.',
     'C',
     'Reflexive pronouns (myself, herself) are used for emphasis or when subject and object are the same. "Herself" in option C adds correct emphasis. In A, B, and D, "myself" incorrectly replaces "me" or "I."',
     'MULTIPLE_CHOICE', 'HARD');

    -- ════════════════════════════════════════════════════════
    -- UNIT 3 – Sentence Structure (12 questions)
    -- ════════════════════════════════════════════════════════
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Sentence Structure', 'Summaries/ACT/act_english_structure.txt', 3)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version correctly fixes this run-on sentence: "The concert was sold out fans waited in line for hours hoping to get tickets"?',
     'The concert was sold out, fans waited in line for hours hoping to get tickets.',
     'The concert was sold out; fans waited in line for hours hoping to get tickets.',
     'The concert was sold out fans, waited in line for hours hoping to get tickets.',
     'The concert was sold out fans waited in line for hours, hoping to get tickets.',
     'B',
     'A comma alone cannot join two independent clauses (comma splice). A semicolon correctly separates two related independent clauses without a coordinating conjunction.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which of the following is a complete sentence?',
     'Running through the airport to catch the last flight home.',
     'Although the presentation received positive feedback from the audience.',
     'The engineer designed a bridge that could withstand extreme weather conditions.',
     'Despite the team''s best efforts and months of careful preparation.',
     'C',
     'A complete sentence needs a subject and a predicate forming an independent clause. Only option C has both a subject ("The engineer") and a complete predicate ("designed a bridge...").',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version correctly fixes the comma splice: "The library closes at nine, students must finish their research by then"?',
     'The library closes at nine students must finish their research by then.',
     'The library closes at nine, but students must finish their research by then.',
     'The library closes at nine, and, students must finish their research by then.',
     'The library closes at nine, so, students must finish their research by then.',
     'B',
     'A comma splice is fixed by adding a coordinating conjunction after the comma ("but"), using a semicolon, or making two separate sentences. Option B is the most natural correction.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which subordinating conjunction best completes the sentence? "___ the new policy was unpopular, the board implemented it anyway."',
     'Because', 'Although', 'Unless', 'Since',
     'B',
     '"Although" signals a contrast — the policy was unpopular, yet it was implemented. "Because" and "since" imply causation; "unless" implies a condition, both logically incorrect here.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence uses correct parallel structure in a list?',
     'The job requires answering phones, to file documents, and scheduling meetings.',
     'The job requires answering phones, filing documents, and scheduling meetings.',
     'The job requires to answer phones, filing documents, and schedule meetings.',
     'The job requires answering phones, filing documents, and to schedule meetings.',
     'B',
     'All items in a list must use the same grammatical form. "Answering, filing, and scheduling" maintains consistent gerund (-ing) form.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence makes a logically correct comparison?',
     'The population of New York is larger than Los Angeles.',
     'The population of New York is larger than that of Los Angeles.',
     'New York''s population is larger than Los Angeles''s city.',
     'New York is more populated than the population of Los Angeles.',
     'B',
     'A comparison must be logically parallel. You must compare "population" to "population" (using "that of"), not "population" to a city.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses "either...or" with subject-verb agreement?',
     'Either the manager or the supervisors needs to approve the request.',
     'Either the manager or the supervisors need to approve the request.',
     'Either the manager or the supervisors is needing to approve the request.',
     'Either the manager or the supervisors are going to need to approve the request.',
     'B',
     'With "either...or," the verb agrees with the subject closer to the verb. "Supervisors" (plural) is closer, so the plural verb "need" is correct.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version best combines these two sentences? "The museum exhibit opened last week. It features artifacts from ancient Rome."',
     'The museum exhibit opened last week, it features artifacts from ancient Rome.',
     'The museum exhibit, opened last week, it features artifacts from ancient Rome.',
     'The museum exhibit, which opened last week, features artifacts from ancient Rome.',
     'The museum exhibit opened last week and it features artifacts from ancient Rome.',
     'C',
     'Option C smoothly combines both ideas using a relative clause ("which opened last week") without creating a comma splice (A), awkward structure (B), or a loose compound (D).',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly punctuates the appositive phrase?',
     'My mentor Dr. Elena Ruiz has published over fifty research papers.',
     'My mentor, Dr. Elena Ruiz, has published over fifty research papers.',
     'My mentor Dr. Elena Ruiz, has published over fifty research papers.',
     'My mentor, Dr. Elena Ruiz has published over fifty research papers.',
     'B',
     'An appositive phrase that renames or identifies the noun must be set off with commas on both sides. "Dr. Elena Ruiz" renames "my mentor" and requires commas before and after.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly distinguishes between "that" (restrictive) and "which" (nonrestrictive)?',
     'The book, that she recommended, was fascinating.',
     'The book which I lost was a first edition.',
     'The report that was submitted yesterday contained an error.',
     'The experiment, that produced unexpected results, was repeated.',
     'C',
     '"That" introduces a restrictive clause — essential to identify the noun, no commas needed. "Which" introduces a nonrestrictive clause — extra info, set off with commas. Option C correctly uses "that" without commas.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly places the participial modifier?',
     'Covered in mud, the park rangers discovered the lost hikers.',
     'The park rangers discovered the lost hikers, covered in mud.',
     'The park rangers, covered in mud, discovered the lost hikers.',
     'Covered in mud, the lost hikers were discovered by the park rangers.',
     'D',
     'The phrase "covered in mud" must immediately precede the noun it modifies — the hikers, not the rangers. Option D places the modifier directly before "the lost hikers."',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence correctly uses parallel participial phrases?',
     'Exhausted from the long journey and having no money left, the travelers sought shelter.',
     'Exhausted from the long journey and with no money left, the travelers sought shelter.',
     'Having exhausted from the long journey and having no money left, the travelers sought shelter.',
     'Exhausted from the long journey and no money remaining, the travelers sought shelter.',
     'A',
     '"Exhausted from the long journey" and "having no money left" are both participial phrases modifying "the travelers" — they are parallel in structure and form.',
     'MULTIPLE_CHOICE', 'HARD');

    -- ════════════════════════════════════════════════════════
    -- UNIT 4 – Strategy (12 questions)
    -- ════════════════════════════════════════════════════════
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Strategy', 'Summaries/ACT/act_english_strategy.txt', 4)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer argues that regular exercise reduces the risk of chronic disease. Which sentence would most effectively support this claim?',
     'Many gyms have opened new locations in suburban areas.',
     'A 2022 meta-analysis of 50 studies found that 150 minutes of weekly aerobic exercise reduced the risk of type 2 diabetes by 35%.',
     'Exercise equipment has become more affordable in recent years.',
     'Many athletes train multiple times per day.',
     'B',
     'Only option B directly links regular exercise to a reduction in chronic disease risk with specific, quantifiable evidence — exactly what the claim requires.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A passage about jazz history argues New Orleans was the birthplace of the genre. The sentence "Louis Armstrong was born in New Orleans in 1901" appears mid-paragraph. Should it be kept or deleted?',
     'Keep it; it provides a specific example supporting the claim about New Orleans'' role in jazz history.',
     'Keep it; it introduces the discussion of New York''s jazz scene.',
     'Delete it; it contradicts the main argument about New Orleans.',
     'Delete it; it shifts focus from jazz history to biography.',
     'A',
     'Armstrong''s birth in New Orleans directly supports the paragraph''s claim about New Orleans as central to jazz origins. The sentence is relevant and provides concrete support.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A student is revising a scientific report for a general audience. Which version is most appropriate?',
     'The HbA1c assay quantifies glycosylated hemoglobin as a metric for longitudinal glycemic control.',
     'The blood test measures average blood sugar levels over the past three months.',
     'The assay quantifies hemoglobin to assess metabolic glucose regulation.',
     'Doctors measure your blood''s HbA1c to see if your sugar levels are, like, too high.',
     'B',
     'For a general audience, technical terms should be replaced with accessible language. Option B accurately conveys the meaning without jargon or informal expressions.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'An essay claims that public libraries promote economic opportunity. Which addition most directly supports this claim?',
     'Libraries often have comfortable reading chairs and free Wi-Fi.',
     'Research shows that adults who regularly use library resources earn 12% higher wages than those who do not.',
     'Many libraries now offer digital lending platforms.',
     'Libraries have been community gathering places for centuries.',
     'B',
     'Only option B provides direct evidence linking library use to economic outcomes (earnings), which directly supports the claim about economic opportunity.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'An essay about climate change begins: "In 2003, a heat wave swept through Europe, killing more than 70,000 people." The author most likely begins this way to:',
     'Provide a comprehensive overview of climate science.',
     'Define the term "climate change" for readers.',
     'Establish the real-world urgency and human impact of climate change.',
     'Introduce a counterargument to the essay''s main thesis.',
     'C',
     'Opening with a dramatic, specific historical event immediately illustrates the real consequences of climate change, creating urgency and engaging readers before introducing the scientific argument.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer concludes a paragraph about ocean plastic pollution with: "The choice is ours: act now, or watch the ocean we depend on disappear." The primary purpose of this sentence is to:',
     'Introduce a new piece of evidence about ocean health.',
     'Summarize the scientific findings discussed in the paragraph.',
     'Motivate the reader to feel a sense of personal responsibility.',
     'Provide a counterargument to the pollution problem.',
     'C',
     'The direct address ("the choice is ours") and urgent contrast create a call to action, appealing to the reader''s sense of responsibility rather than introducing evidence or summarizing facts.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer states: "Many historical inventions were created by accident." Which sentence best provides a specific supporting example?',
     'Accidents happen frequently in scientific laboratories.',
     'Scientists often make discoveries when conducting unrelated research.',
     'In 1928, Alexander Fleming discovered penicillin after noticing that mold had contaminated and killed bacteria in a petri dish he had left unattended.',
     'Invention often requires creativity and persistence over many years.',
     'C',
     'Only option C provides a specific, named historical example directly supporting the claim that inventions can be accidental.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A passage argues that standardized testing is an unreliable measure of student ability. Which statement, if true, would most strengthen this argument?',
     'Standardized tests are used in over 50 countries around the world.',
     'Students who receive test-prep coaching score significantly higher without demonstrating greater academic ability.',
     'Teachers spend significant time helping students prepare for standardized exams.',
     'Some students prefer essay-based assessments to multiple-choice exams.',
     'B',
     'If coaching raises scores without raising academic ability, the test measures test-taking skill — not actual ability — directly supporting the claim that standardized tests are unreliable.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A passage argues that raising the minimum wage reduces poverty. Which finding would most weaken this argument?',
     'Several states that raised the minimum wage also increased social services.',
     'Economists disagree about the effects of minimum wage increases.',
     'Studies show that minimum wage increases lead some employers to reduce working hours, leaving low-wage workers with similar or lower total income.',
     'The federal minimum wage has not been raised in over a decade.',
     'C',
     'If employers reduce hours in response to higher wages, workers'' total income may not increase — directly undermining the claim that a higher minimum wage reduces poverty.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A paragraph explains how honeybees navigate using the sun and landmarks. Which sentence best concludes the paragraph?',
     'Honeybees are one of the most studied insects in the world.',
     'Bees communicate through the waggle dance to share location information.',
     'This sophisticated navigation system allows bees to forage efficiently and return reliably to the hive, even over distances of several kilometers.',
     'Scientists have studied bees for many years using a variety of research methods.',
     'C',
     'The best concluding sentence synthesizes the paragraph''s content (navigation) and explains its significance (efficient foraging and reliable return) without introducing irrelevant new topics.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'An author wants to argue that a new teaching method improves student comprehension. Which evidence would be most convincing to an academic audience?',
     'Anecdotal reports from several teachers who tried the method.',
     'The method''s developer claims it is based on decades of research.',
     'A randomized controlled study with 500 students showing statistically significant improvements in comprehension scores.',
     'Testimonials from students who enjoyed the new method.',
     'C',
     'A randomized controlled study provides the strongest scientific evidence because it controls for variables and produces statistically measurable results — far more convincing than anecdotes or testimonials.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Throughout a passage, the author presents statistics about income inequality, quotes economists, and proposes three specific policy reforms. The author''s primary purpose is most likely to:',
     'Entertain readers with stories about economic hardship.',
     'Objectively describe different perspectives on income inequality without recommending action.',
     'Persuade readers that income inequality is a serious problem requiring specific policy solutions.',
     'Explain the historical origins of income inequality in the United States.',
     'C',
     'The combination of evidence (statistics), expert support (economists), and proposed reforms (policy recommendations) signals a persuasive argument. The author is making a case for action.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ════════════════════════════════════════════════════════
    -- UNIT 5 – Organization (13 questions)
    -- ════════════════════════════════════════════════════════
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Organization', 'Summaries/ACT/act_english_organization.txt', 5)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'Which transition best connects two contrasting ideas? "The new drug showed promising results in early trials. ___, it failed to meet safety standards in Phase 3."',
     'Furthermore', 'Therefore', 'However', 'Similarly',
     'C',
     '"However" signals a contrast or contradiction between the promising early results and the failure in Phase 3. "Furthermore" and "similarly" signal addition; "therefore" signals consequence.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which transition best connects sentences showing addition? "The park offers hiking trails and picnic areas. ___, it features a botanical garden open year-round."',
     'Nevertheless', 'In addition', 'On the other hand', 'As a result',
     'B',
     '"In addition" signals that the writer is adding another feature to the list already mentioned. "Nevertheless" signals contrast; "as a result" signals causation.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which transition best expresses a cause-effect relationship? "The company failed to adapt to new technology. ___, it lost significant market share within three years."',
     'In contrast', 'Meanwhile', 'Consequently', 'Similarly',
     'C',
     '"Consequently" signals that the market share loss is a direct result of the company''s failure to adapt. "In contrast" and "similarly" signal comparison; "meanwhile" signals simultaneous events.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer is adding "This process, known as photosynthesis, produces glucose and oxygen" to a paragraph about how plants make food. Where should it be placed?',
     'At the very beginning of the paragraph, before any other information is introduced.',
     'Immediately after the sentence explaining that plants absorb sunlight and carbon dioxide.',
     'At the end of the paragraph, as a concluding thought.',
     'In a separate paragraph about the products of plant metabolism.',
     'B',
     'The sentence defines and elaborates on the process introduced by absorbing sunlight and CO₂. Placing it immediately after that explanation maintains logical flow.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer has four paragraphs: (1) causes of deforestation, (2) global forest coverage history, (3) effects of deforestation on biodiversity, (4) proposed solutions. Which order is most logical?',
     '2, 1, 3, 4', '1, 3, 2, 4', '4, 2, 1, 3', '3, 1, 4, 2',
     'A',
     'The most logical structure is: historical context → causes → effects → solutions. This problem-solution framework builds naturally from background to analysis to action.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence best serves as the topic sentence for a paragraph about the economic benefits of renewable energy?',
     'Renewable energy sources include solar, wind, and hydroelectric power.',
     'Many countries are investing in green infrastructure projects.',
     'Transitioning to renewable energy creates jobs, reduces fuel costs, and stimulates technological innovation.',
     'The history of renewable energy dates back centuries to windmills and waterwheels.',
     'C',
     'The best topic sentence introduces the paragraph''s main argument clearly. Option C identifies three economic benefits the paragraph will explain, giving readers a clear roadmap.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence logically follows: "The Great Wall of China was not built all at once; different sections were constructed by various dynasties over many centuries."',
     'China is located in East Asia and has a population of over 1.4 billion.',
     'The Ming Dynasty is responsible for much of the wall that survives today.',
     'The wall is considered one of the greatest engineering feats in human history.',
     'Tourism in China generates billions of dollars in revenue annually.',
     'B',
     'The preceding sentence introduces the idea that different dynasties built different sections. The next sentence should logically specify which dynasty — option B does this directly.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which transition best introduces the concluding paragraph of an argumentative essay?',
     'First and foremost', 'On the other hand', 'In conclusion', 'For example',
     'C',
     '"In conclusion" signals the final paragraph where the writer synthesizes arguments and restates the thesis. "First" begins an argument; "on the other hand" signals contrast; "for example" introduces evidence.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Place these four sentences in the most logical order: (1) Without insulin, glucose cannot enter cells and accumulates in the bloodstream. (2) In Type 1 diabetes, the immune system destroys insulin-producing beta cells. (3) Patients must therefore take insulin injections to survive. (4) Insulin is a hormone that allows cells to absorb glucose for energy.',
     '4, 2, 1, 3', '2, 4, 1, 3', '1, 4, 2, 3', '4, 1, 2, 3',
     'A',
     'The logical order is: define insulin (4) → explain the disease mechanism (2) → explain the consequence (1) → explain the solution (3). Starting with the definition provides the background needed to understand what follows.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer is introducing an essay about the dangers of social media for teenagers. Which introductory sentence is most effective?',
     'Social media is used by billions of people around the world every day.',
     'This essay will discuss the dangers of social media for teenagers.',
     'In 2023, researchers found that teenagers who used social media for more than four hours daily were 2.6 times more likely to report symptoms of depression.',
     'Social media was invented in the early 2000s and has grown rapidly since then.',
     'C',
     'Opening with a striking, specific statistic immediately establishes the issue''s seriousness and engages the reader. Option A is too general, B is formulaic, and D provides irrelevant historical background.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A paragraph argues that arts education improves academic performance across subjects. Which closing sentence best reinforces this idea?',
     'Many schools have cut arts programs due to budget constraints.',
     'Art classes are popular with students of all ages.',
     'The evidence suggests that schools investing in arts education produce students who perform better not only in music and visual art, but also in reading and mathematics.',
     'Students who participate in band often enjoy practicing their instruments.',
     'C',
     'The best closing sentence synthesizes the paragraph''s argument (arts improves academic performance) by specifying the cross-disciplinary benefit — directly reinforcing the topic sentence.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which transition best shows a sequence of steps? "First, preheat the oven to 350°F. ___, mix the dry ingredients in a large bowl."',
     'However', 'Therefore', 'Next', 'In contrast',
     'C',
     '"Next" signals the following step in a sequential process. "However" implies contrast; "therefore" implies consequence; "in contrast" implies comparison.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence does NOT belong in a paragraph about how the printing press transformed European society?',
     'Gutenberg''s movable type press allowed books to be produced faster and more cheaply than ever before.',
     'The spread of printed materials contributed to the Protestant Reformation by allowing religious ideas to circulate widely.',
     'Manuscripts before the printing press were hand-copied by monks, a process that took months or years.',
     'Johannes Gutenberg was born around 1400 in Mainz, Germany, where he later apprenticed as a goldsmith.',
     'D',
     'The paragraph focuses on how the printing press transformed society. Gutenberg''s birthplace and goldsmith apprenticeship are biographical details that do not contribute to the argument and disrupt paragraph unity.',
     'MULTIPLE_CHOICE', 'HARD');

    -- ════════════════════════════════════════════════════════
    -- UNIT 6 – Style (12 questions)
    -- ════════════════════════════════════════════════════════
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (v_eng_id, 'Style', 'Summaries/ACT/act_english_style.txt', 6)
    RETURNING idunit INTO v_unit_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version eliminates the redundant phrase?',
     'The two twins celebrated their birthday together simultaneously.',
     'The twins celebrated their birthday together.',
     'Both of the two twins celebrated their mutual birthday simultaneously.',
     'The twins both celebrated their joint birthday at the same time together.',
     'B',
     '"Twins" implies two people and a shared birthday. Adding "two," "together," "simultaneously," or "joint" is redundant. Option B is the most concise.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version most concisely expresses the idea?',
     'Due to the fact that it was raining, the event was canceled.',
     'Owing to the circumstance of rainfall, the event was canceled.',
     'Because it was raining, the event was canceled.',
     'In light of the rainy conditions that were occurring, the event was canceled.',
     'C',
     '"Because" directly and concisely replaces the wordy phrases "due to the fact that" or "owing to the circumstance of." Effective writing prefers concise constructions.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A formal academic essay includes: "Scientists were kind of surprised by the results." Which revision best maintains a formal tone?',
     'Scientists were totally shocked by the results.',
     'The results genuinely blew scientists away.',
     'Scientists were surprised by the results.',
     'Scientists couldn''t believe what they found in the results.',
     'C',
     'In formal academic writing, informal expressions like "kind of," "totally," or "blew away" are inappropriate. Option C uses straightforward, neutral language consistent with a formal register.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which word most precisely completes the sentence? "The scientist''s theory was ___ by the new experimental evidence, which directly contradicted her core assumptions."',
     'helped', 'affected', 'undermined', 'changed',
     'C',
     '"Undermined" precisely conveys that the evidence weakened the theory. "Helped" is positive and opposite in meaning; "affected" and "changed" are too vague to capture the adversarial relationship.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version is most concise and uses active voice effectively?',
     'The new policy was implemented by the board of directors on Monday.',
     'On Monday, it was decided by the board of directors that the new policy would be implemented.',
     'The board of directors implemented the new policy on Monday.',
     'The new policy, having been implemented on Monday, was done so by the board.',
     'C',
     'Active voice ("The board implemented the policy") is typically more direct and concise than passive voice. Option C clearly identifies the subject performing the action.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence best replaces the cliché "think outside the box" in a formal essay?',
     'The team needed to think outside the box to solve the problem.',
     'The team needed to approach the problem with unconventional thinking and fresh perspectives.',
     'The team had to go ahead and think outside of the box, basically.',
     'The team should definitely try thinking outside the box when tackling this.',
     'B',
     'Clichés like "think outside the box" are overused and vague in formal writing. Option B replaces it with specific, fresh language ("unconventional thinking and fresh perspectives").',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A formal letter of recommendation includes: "Dr. Martin is an amazing person and you guys should totally hire her." Which revision best matches the formal register?',
     'Dr. Martin is super talented and your company would be lucky to hire her.',
     'Dr. Martin is a highly qualified professional whom I enthusiastically recommend for this position.',
     'Dr. Martin is great and I really think she should get the job.',
     'Dr. Martin would be an awesome addition to your team, for real.',
     'B',
     'Formal recommendations require professional language. "Highly qualified," "enthusiastically recommend" suit the context. Options A, C, and D use informal language inconsistent with the formal register.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which sentence uses figurative language most effectively in an essay about economic recovery?',
     'The economy was like a very sick patient who needed medicine.',
     'The economy recovered after the recession.',
     'Once paralyzed by debt and unemployment, the economy gradually regained its footing, moving from crisis toward stability.',
     'The economy is not literally a person, but it can be compared to one metaphorically.',
     'C',
     'Option C uses figurative language ("paralyzed," "regained its footing") naturally and effectively to convey the severity of the recession and the nature of recovery, without being awkward or overly literal.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A paragraph consists entirely of short, choppy sentences. Which revision best improves sentence variety?',
     'The storm hit. It was powerful. Trees fell. Power went out. Roads flooded.',
     'The powerful storm hit, causing trees to fall, knocking out power, and flooding roads throughout the region.',
     'The storm was powerful. It caused trees to fall. Power went out everywhere. Roads throughout the region became flooded.',
     'A powerful storm hit. Trees fell. And power went out. Roads flooded.',
     'B',
     'Option B combines the ideas into a single, varied sentence using participial phrases and parallel structure, creating better rhythm and flow than a series of choppy sentences.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version is most specific and informative?',
     'The policy had a big effect on a lot of people in many places.',
     'The new housing policy displaced thousands of low-income residents from urban neighborhoods in five major cities.',
     'The policy affected people quite a lot in different ways.',
     'A large number of individuals were impacted by the various provisions of the policy.',
     'B',
     'Effective writing uses specific details: "thousands," "low-income residents," "urban neighborhoods," "five major cities" give the reader concrete, meaningful information. Vague terms communicate very little.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'Which version most directly expresses the idea without a double negative?',
     'The meeting was not without its challenges.',
     'The meeting did not go smoothly and was not free of problems.',
     'The meeting was challenging.',
     'The meeting was not entirely challenge-free in all respects.',
     'C',
     'Double negatives and wordy constructions ("not without," "not entirely challenge-free") are indirect and harder to read. "The meeting was challenging" is the clearest, most direct statement.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_eng_id, v_eng_p1, v_unit_id,
     'A writer wants to describe a politician''s changes to a policy in a neutral, objective way. Which word choice is most appropriate?',
     'The politician gutted the environmental regulations.',
     'The politician altered the environmental regulations.',
     'The politician improved the environmental regulations.',
     'The politician destroyed the environmental regulations.',
     'B',
     '"Altered" is neutral and objective, conveying that changes were made without implying they were harmful ("gutted," "destroyed") or beneficial ("improved"). Objective writing requires neutral word choices when reporting.',
     'MULTIPLE_CHOICE', 'HARD');

END $$;
