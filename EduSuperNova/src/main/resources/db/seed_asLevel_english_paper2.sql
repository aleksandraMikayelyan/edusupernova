-- ============================================================
-- AS Level English Language (9093) — Paper 2: Writing
-- Cambridge 9093 Paper 2 is a pure WRITING paper. No reading
-- passages. Students produce two pieces of writing in specified
-- forms, for specific audiences and purposes.
-- Run once in the Supabase SQL editor.
-- ============================================================

DO $$
DECLARE
    v_eng_id   INTEGER;
    v_paper_id INTEGER;
BEGIN

    SELECT idcourse INTO v_eng_id
    FROM courses WHERE lower(coursename) = 'as level english' LIMIT 1;

    IF v_eng_id IS NULL THEN
        RAISE EXCEPTION 'Course "AS Level English" not found. Create it first.';
    END IF;

    SELECT idpaper INTO v_paper_id
    FROM papers WHERE idcourse = v_eng_id AND lower(papername) LIKE '%paper 2%' LIMIT 1;

    IF v_paper_id IS NULL THEN
        SELECT idpaper INTO v_paper_id
        FROM papers WHERE idcourse = v_eng_id LIMIT 1;
    END IF;

    -- ══════════════════════════════════════════════════════════
    -- PAPER 2: WRITING
    -- All questions are ESSAY type. Students write one piece per
    -- question in the specified form and register.
    -- Word count: 250–350 words unless otherwise stated.
    -- ══════════════════════════════════════════════════════════

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty)
    VALUES

    -- ── ARTICLES ──────────────────────────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'Write an article for a school or college magazine in which you argue that students today face greater pressures than any previous generation.

Your article should be lively and engaging, and should use a variety of persuasive techniques. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Convincing, sustained and controlled writing. Register is entirely appropriate for a magazine article (engaging, direct, persuasive). A wide range of vocabulary and sentence structures used for effect. Effective use of rhetorical techniques (e.g. rhetorical questions, repetition, statistics, anecdote). Band 2 (16–20): Generally appropriate register with clear attempt at persuasion. Some variety in expression. Band 3 (10–15): Some awareness of audience and purpose but register inconsistent. Limited range of techniques. Band 4 (0–9): Register largely inappropriate or purpose unclear.',
     'ESSAY', 'MEDIUM'),

    (v_eng_id, v_paper_id, NULL,
     'A national newspaper has invited readers to contribute to a debate about whether young people spend too much time on screens. Write your article arguing either FOR or AGAINST the motion.

Your article should be clearly structured and use language appropriate for a general adult readership. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): A compelling, well-structured argument sustained throughout. Appropriate formal-but-accessible register for a newspaper readership. Effective use of discourse markers to guide the reader. Counter-arguments acknowledged and addressed. Band 2 (16–20): Argument is mostly clear; register is appropriate. Some counterargument or acknowledgement of complexity. Band 3 (10–15): Argument attempted but not always coherent; register fluctuates. Band 4 (0–9): Little evidence of argument structure or appropriate register.',
     'ESSAY', 'MEDIUM'),

    (v_eng_id, v_paper_id, NULL,
     'Write an article for a travel magazine describing a place you know well and explaining why visitors should experience it.

Your writing should create a vivid sense of place and be aimed at adult readers who enjoy discovering new destinations. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Rich, evocative descriptive writing that creates a strong sense of place. Appropriate tone for a travel magazine — enthusiastic, informative and personal. Effective use of sensory language, figurative language, and varied syntax. Band 2 (16–20): Clear description with some vivid detail. Tone mostly appropriate. Band 3 (10–15): Some descriptive content but limited development of place or atmosphere. Band 4 (0–9): Very limited descriptive detail or inappropriate register.',
     'ESSAY', 'MEDIUM'),

    -- ── SPEECHES ──────────────────────────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'You have been asked to deliver a speech at your school''s end-of-year assembly arguing that academic qualifications are not the only measure of success.

Write the text of your speech. Your language should be appropriate for an audience of students and teachers. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Confident, assured speech that addresses the audience directly. Features of spoken delivery evident in the writing (e.g. direct address, rhetorical questions, repetition for emphasis, pauses signalled through punctuation or phrasing). Argument is clear and well-developed. Register is appropriate for a school assembly. Band 2 (16–20): Clear speech with some features of spoken language. Argument present. Band 3 (10–15): Awareness of speech form but features are limited. Argument underdeveloped. Band 4 (0–9): Little evidence of speech register or structured argument.',
     'ESSAY', 'MEDIUM'),

    (v_eng_id, v_paper_id, NULL,
     'A local community group is debating whether a historic building in your town should be demolished to make way for a new shopping centre. You have been asked to speak in favour of preserving the building.

Write the text of your speech. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Persuasive, well-crafted speech with clear position. Appropriate register for a public community meeting — respectful, authoritative, but accessible. Use of rhetorical devices (tricolon, anaphora, rhetorical questions) to build argument. Evidence or examples used effectively. Band 2 (16–20): Clear argument in appropriate register. Some rhetorical techniques. Band 3 (10–15): Position stated but insufficiently supported; limited register awareness. Band 4 (0–9): Argument unclear or register inappropriate.',
     'ESSAY', 'MEDIUM'),

    -- ── LETTERS ───────────────────────────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'You have read a newspaper article claiming that teenagers today are less resilient than previous generations. You disagree strongly.

Write a formal letter to the newspaper editor responding to this claim and offering a different perspective. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Fully appropriate formal letter format (greeting, clear paragraphing, formal close). Confident, measured tone that challenges the claim without becoming aggressive. Well-developed counter-argument with evidence or examples. Band 2 (16–20): Correct format with appropriate formality. Counter-argument present but less fully developed. Band 3 (10–15): Some attempt at formal letter but register inconsistent. Limited engagement with the original claim. Band 4 (0–9): Format incorrect or register very informal.',
     'ESSAY', 'MEDIUM'),

    (v_eng_id, v_paper_id, NULL,
     'You are applying for a place on a competitive summer programme for young people interested in journalism. The organisers have asked applicants to write a letter explaining their passion for writing and their relevant experience.

Write the letter. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Professional, persuasive application letter. Appropriate formal register that remains personal and engaging. Clear structure: introduction stating purpose, body developing relevant experiences and motivation, conclusion reinforcing commitment. Specific and convincing content. Band 2 (16–20): Clear, mostly formal letter. Some relevant content. Band 3 (10–15): Letter format attempted; content is vague or generic. Band 4 (0–9): Inappropriate register or very limited content.',
     'ESSAY', 'MEDIUM'),

    -- ── REPORTS ───────────────────────────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'Your school has asked the student council to investigate students'' wellbeing during examination periods and recommend improvements.

Write the report for the school leadership team, outlining your findings and making two clear recommendations. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Fully appropriate formal report register — objective, structured, impersonal tone. Clear organisation with headings (e.g. Introduction, Findings, Recommendations). Two specific, practical and clearly justified recommendations. Controlled, professional language throughout. Band 2 (16–20): Appropriate structure and mostly formal register. Two recommendations present. Band 3 (10–15): Some attempt at report format but structure unclear or register inconsistent. Band 4 (0–9): No report structure or very inappropriate tone.',
     'ESSAY', 'HARD'),

    (v_eng_id, v_paper_id, NULL,
     'A local authority has commissioned a report on the impact of closing the town''s public library on the local community.

Write the report for the local authority, assessing the likely impact and recommending whether the library should be kept open. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Balanced, evidence-based report with appropriate formal register. Clear assessment of impacts (social, educational, cultural) and a well-reasoned recommendation. Use of formal report conventions (headings, measured tone, third person). Band 2 (16–20): Clear report with some balance and a recommendation. Band 3 (10–15): Some formal register attempted; limited range of impacts discussed. Band 4 (0–9): Informal or discursive rather than report-style.',
     'ESSAY', 'HARD'),

    -- ── REVIEWS ───────────────────────────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'Write a review of a film, book or television series for a website aimed at young adults. Your review should evaluate both the strengths and weaknesses of the work and conclude with a clear recommendation.

Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Engaging, well-informed review with a clear evaluative voice. Appropriate register for an online youth-oriented platform — informal but articulate. Balanced assessment of strengths and weaknesses supported by specific examples. Clear recommendation at the close. Band 2 (16–20): Clear evaluation with some specific content. Register mostly appropriate. Band 3 (10–15): Some evaluation present but largely descriptive summary. Band 4 (0–9): Very little evaluation; register inappropriate.',
     'ESSAY', 'MEDIUM'),

    -- ── BLOG POSTS ────────────────────────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'Write a blog post for a personal blog in which you reflect on a challenge you have faced and what you learned from it.

Your post should be honest, personal and engaging. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Thoughtful, authentic-feeling post with a strong personal voice. Appropriate informal-but-reflective register for a personal blog. Narrative structure used effectively to build to the key insight. Varied sentence lengths and vocabulary create rhythm and engagement. Band 2 (16–20): Clear reflection with appropriate voice. Some narrative development. Band 3 (10–15): Reflective attempt but limited development or weak register. Band 4 (0–9): Very little reflection or entirely inappropriate register.',
     'ESSAY', 'MEDIUM'),

    (v_eng_id, v_paper_id, NULL,
     'A popular lifestyle blog has invited guest posts on the topic "What does success mean to you?" Write your guest post for this blog.

Your writing should be engaging and personal, addressed to a general adult readership. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Engaging, original response with a clear and sustained personal viewpoint. Appropriate register for a lifestyle blog — warm, direct, accessible. Effective use of anecdote, reflection, or examples to develop the idea of success. Band 2 (16–20): Clear personal viewpoint with some development. Mostly appropriate register. Band 3 (10–15): Some personal content but ideas not well developed. Band 4 (0–9): Generic or inappropriate register.',
     'ESSAY', 'MEDIUM'),

    -- ── LEAFLETS ──────────────────────────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'A charity is launching a campaign to encourage young people to volunteer in their local community. Write the text of a leaflet aimed at 16–18 year olds, persuading them to get involved.

Your leaflet should be persuasive, concise and visually clear in its organisation. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Persuasive, energetic writing that speaks directly to the target age group. Register is accessible and motivating — enthusiastic without being condescending. Text is organised clearly with headings, bullet points or short sections as appropriate for a leaflet. Use of second person, imperative verbs, and upbeat language. Band 2 (16–20): Clear persuasive content. Some leaflet conventions used. Register mostly appropriate. Band 3 (10–15): Some persuasive attempt; limited use of format or register. Band 4 (0–9): Very little audience awareness or form awareness.',
     'ESSAY', 'MEDIUM'),

    -- ── DESCRIPTIVE/NARRATIVE WRITING ────────────────────────────────────────
    (v_eng_id, v_paper_id, NULL,
     'Write the opening of a short story in which a character discovers something unexpected in an ordinary place.

Your writing should create atmosphere, establish character, and engage the reader from the start. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Controlled, imaginative narrative opening with strong sense of atmosphere. Effective techniques: varied sentence length for pacing, precise vocabulary choices, sensory detail, narrative tension. Character is established through action and detail rather than direct description. The unexpected discovery is set up with skill — tension builds naturally. Band 2 (16–20): Clear narrative with some atmosphere and character development. Band 3 (10–15): Some narrative present but atmosphere and characterisation underdeveloped. Band 4 (0–9): Very limited narrative skill or very brief.',
     'ESSAY', 'HARD'),

    (v_eng_id, v_paper_id, NULL,
     'Write a piece of descriptive writing about a busy public space — such as a market, railway station or sports stadium — at a moment of intense activity.

Your writing should be vivid and sensory, immersing the reader in the scene. Write 250–350 words.',
     NULL, NULL, NULL, NULL,
     NULL,
     'Band 1 (21–25): Rich, controlled descriptive writing. Strong use of sensory detail across multiple senses. Figurative language (metaphor, simile, personification) used purposefully and without cliché. Varied syntax creates rhythm and movement. The reader feels immersed in the scene. Band 2 (16–20): Clear descriptive content with some sensory detail. Some figurative language. Band 3 (10–15): Some description but limited development; figurative language limited or clichéd. Band 4 (0–9): Very little descriptive detail or very short.',
     'ESSAY', 'MEDIUM');

    RAISE NOTICE 'AS Level English Paper 2 writing tasks inserted — courseId = %, paperId = %', v_eng_id, v_paper_id;

END $$;
