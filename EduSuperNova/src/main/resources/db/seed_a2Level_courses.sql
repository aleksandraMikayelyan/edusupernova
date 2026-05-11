-- ============================================================
-- A2 Level — Courses, Papers & Units
-- idexam = 1 (A Levels)
-- Run once in Supabase SQL editor.
-- ============================================================

DO $$
DECLARE
    v_math_id  INTEGER;
    v_econ_id  INTEGER;
    v_eng_id   INTEGER;

    v_math_p1  INTEGER;
    v_math_p2  INTEGER;
    v_math_p3  INTEGER;
    v_econ_p1  INTEGER;
    v_econ_p2  INTEGER;
    v_eng_p1   INTEGER;
    v_eng_p2   INTEGER;
BEGIN

    -- ════════════════════════════════════════════════════════
    -- A2 MATHEMATICS (9709)
    -- ════════════════════════════════════════════════════════
    INSERT INTO courses (idexam, coursename, description, icon, totalquestions, section)
    VALUES (1, 'A2 Level Math',
            'Advanced Pure Mathematics, Statistics 2 and Further Mechanics for Cambridge A Level.',
            'calculator', 60, 'A2')
    RETURNING idcourse INTO v_math_id;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_math_id, 'Pure Mathematics 2 & 3',
            'Answer all questions. Show all working. Calculators permitted.',
            'MCQ', 20, 60, 1)
    RETURNING idpaper INTO v_math_p1;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_math_id, 'Statistics 2',
            'Answer all questions. Statistical tables are provided.',
            'MCQ', 20, 50, 2)
    RETURNING idpaper INTO v_math_p2;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_math_id, 'Further Mechanics',
            'Answer all questions. Formulae sheet provided.',
            'MCQ', 20, 50, 3)
    RETURNING idpaper INTO v_math_p3;

    INSERT INTO units (idcourse, title, summary_path, queue) VALUES
        (v_math_id, 'Algebra and Functions',                  'Summaries/ALevels/Math/A2LEVEL/unit1.txt', 1),
        (v_math_id, 'Advanced Trigonometry & Differential Equations', 'Summaries/ALevels/Math/A2LEVEL/unit2.txt', 2),
        (v_math_id, 'Advanced Differentiation & Integration', 'Summaries/ALevels/Math/A2LEVEL/unit3.txt', 3),
        (v_math_id, 'Vectors and Complex Numbers',            'Summaries/ALevels/Math/A2LEVEL/unit4.txt', 4),
        (v_math_id, 'Further Probability & Statistics',       'Summaries/ALevels/Math/A2LEVEL/unit5.txt', 5),
        (v_math_id, 'Further Mechanics',                      'Summaries/ALevels/Math/A2LEVEL/unit6.txt', 6);

    RAISE NOTICE 'A2 Math created — courseId = %', v_math_id;

    -- ════════════════════════════════════════════════════════
    -- A2 ECONOMICS (9708)
    -- ════════════════════════════════════════════════════════
    INSERT INTO courses (idexam, coursename, description, icon, totalquestions, section)
    VALUES (1, 'A2 Level Economics',
            'Advanced Micro & Macroeconomics, International Trade, and Development for Cambridge A Level.',
            'chart-bar', 60, 'A2')
    RETURNING idcourse INTO v_econ_id;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_econ_id, 'Paper 3 – Multiple Choice',
            '30 multiple-choice questions on A2 microeconomics and macroeconomics. 1 hour.',
            'MCQ', 20, 60, 1)
    RETURNING idpaper INTO v_econ_p1;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_econ_id, 'Paper 4 – Data Response & Essays',
            'Answer Section A (data response) and two Section B essay questions.',
            'ESSAY', 10, 120, 2)
    RETURNING idpaper INTO v_econ_p2;

    INSERT INTO units (idcourse, title, summary_path, queue) VALUES
        (v_econ_id, 'The Price System in Theory and Practice', 'Summaries/ALevels/Economy/A2LEVEL9708/unit1.txt', 1),
        (v_econ_id, 'Government Microeconomic Intervention',   'Summaries/ALevels/Economy/A2LEVEL9708/unit2.txt', 2),
        (v_econ_id, 'National Income and the Macroeconomy',   'Summaries/ALevels/Economy/A2LEVEL9708/unit3.txt', 3),
        (v_econ_id, 'Government Macroeconomic Policies',      'Summaries/ALevels/Economy/A2LEVEL9708/unit4.txt', 4),
        (v_econ_id, 'International Trade and Exchange Rates', 'Summaries/ALevels/Economy/A2LEVEL9708/unit5.txt', 5),
        (v_econ_id, 'Development Economics',                  'Summaries/ALevels/Economy/A2LEVEL9708/unit6.txt', 6);

    RAISE NOTICE 'A2 Economics created — courseId = %', v_econ_id;

    -- ════════════════════════════════════════════════════════
    -- A2 ENGLISH LANGUAGE (9093)
    -- ════════════════════════════════════════════════════════
    INSERT INTO courses (idexam, coursename, description, icon, totalquestions, section)
    VALUES (1, 'A2 Level English',
            'Advanced English Language — variation, change, identity, discourse and directed writing for Cambridge A Level.',
            'book-open', 30, 'A2')
    RETURNING idcourse INTO v_eng_id;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_eng_id, 'Paper 3 – Text Analysis',
            'Read both passages and answer all questions with detailed linguistic analysis.',
            'ESSAY', 10, 90, 1)
    RETURNING idpaper INTO v_eng_p1;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_eng_id, 'Paper 4 – Language Topics',
            'Answer one question from Section A (language topics) and Section B (directed writing).',
            'ESSAY', 10, 120, 2)
    RETURNING idpaper INTO v_eng_p2;

    INSERT INTO units (idcourse, title, summary_path, queue) VALUES
        (v_eng_id, 'Language Variation and Diversity', 'Summaries/ALevels/English/A2LEVEL9093/unit1.txt', 1),
        (v_eng_id, 'Language Change Over Time',        'Summaries/ALevels/English/A2LEVEL9093/unit2.txt', 2),
        (v_eng_id, 'Discourse and Pragmatics',         'Summaries/ALevels/English/A2LEVEL9093/unit3.txt', 3),
        (v_eng_id, 'Stylistics and Language Analysis', 'Summaries/ALevels/English/A2LEVEL9093/unit4.txt', 4),
        (v_eng_id, 'Language and Identity',            'Summaries/ALevels/English/A2LEVEL9093/unit5.txt', 5),
        (v_eng_id, 'Directed Writing and Commentary',  'Summaries/ALevels/English/A2LEVEL9093/unit6.txt', 6);

    RAISE NOTICE 'A2 English created — courseId = %', v_eng_id;

END $$;
