-- ============================================================
-- AS Level English Language (9093) — Units seed
--
-- Inserts the 6 study units for the "AS Level English" course.
-- Summary files must already exist at:
--   src/main/resources/Summaries/ALevels/English/ASLEVEL9093/
--
-- Run once in the Supabase SQL editor.
-- The course must already exist in the Courses table.
-- ============================================================

DO $$
DECLARE
    v_course_id INTEGER;
BEGIN

    -- Resolve the course ID
    SELECT idcourse INTO v_course_id
    FROM courses
    WHERE lower(coursename) = 'as level english'
    LIMIT 1;

    IF v_course_id IS NULL THEN
        RAISE EXCEPTION 'Course "AS Level English" not found. Create it first.';
    END IF;

    -- Guard against duplicate inserts
    IF EXISTS (SELECT 1 FROM units WHERE idcourse = v_course_id LIMIT 1) THEN
        RAISE NOTICE 'Units already exist for AS Level English — skipping insert.';
        RETURN;
    END IF;

    -- ── Unit 1: Tone and Register ─────────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (
        v_course_id,
        'Tone and Register',
        'Summaries/ALevels/English/ASLEVEL9093/unit1.txt',
        1
    );

    -- ── Unit 2: Phonology and Sound ───────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (
        v_course_id,
        'Phonology and Sound',
        'Summaries/ALevels/English/ASLEVEL9093/unit2.txt',
        2
    );

    -- ── Unit 3: Figurative Language ───────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (
        v_course_id,
        'Figurative Language',
        'Summaries/ALevels/English/ASLEVEL9093/unit3.txt',
        3
    );

    -- ── Unit 4: Audience and Purpose ──────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (
        v_course_id,
        'Audience and Purpose',
        'Summaries/ALevels/English/ASLEVEL9093/unit4.txt',
        4
    );

    -- ── Unit 5: Language and Power ────────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (
        v_course_id,
        'Language and Power',
        'Summaries/ALevels/English/ASLEVEL9093/unit5.txt',
        5
    );

    -- ── Unit 6: Language Acquisition ──────────────────────────
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES (
        v_course_id,
        'Language Acquisition',
        'Summaries/ALevels/English/ASLEVEL9093/unit6.txt',
        6
    );

    RAISE NOTICE 'Inserted 6 units for AS Level English (courseId = %).',  v_course_id;

END $$;
