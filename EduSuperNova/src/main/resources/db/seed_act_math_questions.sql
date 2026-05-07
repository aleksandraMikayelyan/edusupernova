-- ============================================================
-- ACT Math – 120 Questions (3 Practice Papers)
-- 40 questions per paper, 5 answer choices (A–E), no passages
-- Unit distribution per paper:
--   14 × Pre-Algebra & Elementary Algebra        (queue=1)
--   14 × Intermediate Algebra & Coordinate Geo   (queue=2)
--   12 × Plane Geometry & Trigonometry            (queue=3)
--
-- Assumes seed_act.sql already ran:
--   Course "ACT Math" and its 3 units already exist.
--   Paper 1 "Math Test" (15 q) already exists.
--
-- Creates: Math Practice Test 2, 3, 4 (40 q each, 60 min)
-- ============================================================

DO $$
DECLARE
    v_math_id    INTEGER;
    v_math_unit1 INTEGER;   -- Pre-Algebra & Elementary Algebra
    v_math_unit2 INTEGER;   -- Intermediate Algebra & Coordinate Geometry
    v_math_unit3 INTEGER;   -- Plane Geometry & Trigonometry
    v_math_p2    INTEGER;
    v_math_p3    INTEGER;
    v_math_p4    INTEGER;
BEGIN

    -- ── Resolve existing course & units ───────────────────────
    SELECT idcourse INTO v_math_id FROM courses WHERE lower(coursename) = 'act math' LIMIT 1;
    IF v_math_id IS NULL THEN RAISE EXCEPTION 'Course "ACT Math" not found.'; END IF;

    SELECT idunit INTO v_math_unit1 FROM units WHERE idcourse = v_math_id AND queue = 1 LIMIT 1;
    SELECT idunit INTO v_math_unit2 FROM units WHERE idcourse = v_math_id AND queue = 2 LIMIT 1;
    SELECT idunit INTO v_math_unit3 FROM units WHERE idcourse = v_math_id AND queue = 3 LIMIT 1;

    IF v_math_unit1 IS NULL THEN RAISE EXCEPTION 'Unit 1 (Pre-Algebra & Elementary Algebra) not found.'; END IF;
    IF v_math_unit2 IS NULL THEN RAISE EXCEPTION 'Unit 2 (Intermediate Algebra & Coord Geo) not found.'; END IF;
    IF v_math_unit3 IS NULL THEN RAISE EXCEPTION 'Unit 3 (Plane Geometry & Trigonometry) not found.'; END IF;

    -- ── Papers ─────────────────────────────────────────────────
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_math_id, 'Math Practice Test 2',
        'Solve each problem and choose the best answer. Five choices are given for each problem. Calculators are permitted.',
        'MCQ', 40, 60, 2)
    RETURNING idpaper INTO v_math_p2;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_math_id, 'Math Practice Test 3',
        'Solve each problem and choose the best answer. Five choices are given for each problem. Calculators are permitted.',
        'MCQ', 40, 60, 3)
    RETURNING idpaper INTO v_math_p3;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_math_id, 'Math Practice Test 4',
        'Solve each problem and choose the best answer. Five choices are given for each problem. Calculators are permitted.',
        'MCQ', 40, 60, 4)
    RETURNING idpaper INTO v_math_p4;

    -- ════════════════════════════════════════════════════════════
    -- PAPER 2 – MATH PRACTICE TEST 2
    -- ════════════════════════════════════════════════════════════

    -- ── Unit 1: Pre-Algebra & Elementary Algebra (14 q) ────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p2, v_math_unit1, 'What is the value of 3² + 4²?', '7', '14', '25', '49', '5', 'C', '3² + 4² = 9 + 16 = 25.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'A shirt costs $45 and is on sale for 20% off. What is the sale price?', '$9', '$25', '$35', '$36', '$40', 'D', '45 × 0.80 = $36.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'What is the LCM of 12 and 18?', '6', '12', '18', '36', '216', 'D', 'LCM(12, 18) = 36.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'If a:b = 3:5 and b = 20, what is a?', '8', '10', '12', '15', '60', 'C', 'a/20 = 3/5 → a = (3 × 20)/5 = 12.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'The average of five numbers is 14. The average of four of them is 12. What is the fifth number?', '18', '20', '22', '24', '26', 'C', 'Total = 5 × 14 = 70. Sum of four = 4 × 12 = 48. Fifth = 70 − 48 = 22.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'Which of the following is a perfect square?', '48', '50', '60', '64', '75', 'D', '64 = 8². The others are not perfect squares.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'If |3x − 6| = 9, what are the solutions?', 'x = 5 only', 'x = −1 only', 'x = −1 and x = 5', 'x = 1 and x = −5', 'x = 3 and x = −3', 'C', '3x − 6 = 9 → x = 5; and 3x − 6 = −9 → x = −1.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'A store marks up items 40% above cost. If an item costs $50, what is the selling price?', '$55', '$60', '$65', '$70', '$75', 'D', '50 × 1.40 = $70.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'What is the prime factorization of 84?', '2 × 42', '2² × 21', '2² × 3 × 7', '2 × 3 × 14', '4 × 21', 'C', '84 = 4 × 21 = 2² × 3 × 7.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'Which value of y satisfies 5y − 3 > 12?', '2', '2.5', '3', '3.5', '4', 'E', '5y > 15 → y > 3. Only y = 4 satisfies this inequality.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'What is 3/8 expressed as a decimal?', '0.300', '0.325', '0.375', '0.400', '0.425', 'C', '3 ÷ 8 = 0.375.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'A jar contains 6 red, 4 blue, and 2 green marbles. What is the probability of choosing a blue marble at random?', '1/6', '1/4', '1/3', '2/5', '5/12', 'C', 'P(blue) = 4/12 = 1/3.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit1, 'Which expression is equivalent to (2x + 3)(x − 4)?', '2x² − 5x − 12', '2x² + 5x − 12', '2x² − 8x + 12', '2x² − 8x − 12', '2x² − 5x + 12', 'A', '(2x)(x) + (2x)(−4) + 3(x) + 3(−4) = 2x² − 8x + 3x − 12 = 2x² − 5x − 12.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'If 2x + 5 = 17, what is x?', '3', '5', '6', '7', '11', 'C', '2x = 12 → x = 6.', 'MULTIPLE_CHOICE', 'EASY');

    -- ── Unit 2: Intermediate Algebra & Coordinate Geometry (14 q)
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p2, v_math_unit2, 'What is the distance between (−3, 2) and (5, −4)?', '8', '√68', '10', '√72', '√76', 'C', 'd = √((5−(−3))² + (−4−2)²) = √(64 + 36) = √100 = 10.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the slope of the line 3x − 4y = 12?', '−4/3', '−3/4', '3/4', '4/3', '3', 'C', '4y = 3x − 12 → y = (3/4)x − 3. Slope = 3/4.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'If f(x) = x² − 2x + 3, what is f(−2)?', '3', '7', '11', '15', '−5', 'C', 'f(−2) = (−2)² − 2(−2) + 3 = 4 + 4 + 3 = 11.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit2, 'What are the solutions to x² − 5x + 6 = 0?', 'x = 1, x = 6', 'x = −2, x = −3', 'x = 2, x = 3', 'x = −1, x = −6', 'x = 1, x = −6', 'C', '(x − 2)(x − 3) = 0 → x = 2 or x = 3.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit2, 'The equation of the circle with center (2, −3) and radius 5 is:', '(x − 2)² + (y + 3)² = 25', '(x + 2)² + (y − 3)² = 25', '(x − 2)² + (y − 3)² = 5', '(x + 2)² + (y + 3)² = 25', '(x − 2)² + (y + 3)² = 5', 'A', 'Standard form: (x − h)² + (y − k)² = r². Here h = 2, k = −3, r = 5.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'If log₂(x) = 5, what is x?', '10', '16', '25', '32', '64', 'D', '2⁵ = 32.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the vertex of the parabola y = 2(x − 3)² + 4?', '(−3, 4)', '(3, 4)', '(3, −4)', '(−3, −4)', '(2, 4)', 'B', 'Vertex form y = a(x − h)² + k gives vertex (h, k) = (3, 4).', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the x-intercept of the line passing through (0, 6) with slope −2?', 'x = −3', 'x = 2', 'x = 3', 'x = 4', 'x = 6', 'C', 'y = −2x + 6. Set y = 0: 2x = 6 → x = 3.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit2, 'The arithmetic sequence 3, 7, 11, … has what value as its 20th term?', '75', '77', '79', '81', '83', 'C', 'aₙ = 3 + (n − 1) × 4. a₂₀ = 3 + 19 × 4 = 3 + 76 = 79.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'If 4^(x+1) = 16, what is x?', '0', '1', '2', '3', '4', 'B', '4^(x+1) = 4² → x + 1 = 2 → x = 1.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the midpoint of the segment with endpoints (−4, 7) and (6, −3)?', '(0, 2)', '(1, 2)', '(2, 1)', '(1, 4)', '(5, 2)', 'B', 'Midpoint = ((−4 + 6)/2, (7 + (−3))/2) = (1, 2).', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit2, 'Which of the following represents the solution set for |2x − 4| < 6?', '−1 < x < 5', 'x < −1 or x > 5', '−3 < x < 7', 'x < −3 or x > 7', '−5 < x < 1', 'A', '−6 < 2x − 4 < 6 → −2 < 2x < 10 → −1 < x < 5.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'If the geometric sequence starts 2, 6, 18, …, what is the 6th term?', '162', '324', '486', '648', '972', 'C', 'Common ratio = 3. a₆ = 2 × 3⁵ = 2 × 243 = 486.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the slope of a line perpendicular to y = (2/3)x − 5?', '2/3', '−2/3', '3/2', '−3/2', '−5/3', 'D', 'Perpendicular slopes are negative reciprocals. Reciprocal of 2/3 is 3/2; negate → −3/2.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 3: Plane Geometry & Trigonometry (12 q) ───────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p2, v_math_unit3, 'In a right triangle, the two legs are 8 and 15. What is the length of the hypotenuse?', '17', '19', '21', '23', '√289', 'A', '√(8² + 15²) = √(64 + 225) = √289 = 17.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit3, 'A rectangle has length 12 and width 5. What is the length of its diagonal?', '13', '15', '17', '7', '√119', 'A', '√(12² + 5²) = √(144 + 25) = √169 = 13.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit3, 'What is the area of a triangle with base 10 and height 6?', '16', '24', '30', '36', '60', 'C', 'A = (1/2)(10)(6) = 30.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit3, 'The angles of a triangle are in the ratio 1:2:3. What is the measure of the largest angle?', '30°', '60°', '90°', '120°', '150°', 'C', 'k + 2k + 3k = 180° → k = 30°. Largest = 3 × 30° = 90°.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit3, 'A circle has area 49π. What is its circumference?', '7π', '14π', '21π', '28π', '49π', 'B', 'r² = 49 → r = 7. C = 2πr = 14π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'What is the volume of a cylinder with radius 4 and height 9?', '36π', '72π', '112π', '144π', '288π', 'D', 'V = πr²h = π(16)(9) = 144π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'In a 45-45-90 triangle, if the hypotenuse is 10, what is the length of each leg?', '5', '5√2', '10/√3', '5√3', '10√2', 'B', 'Each leg = hypotenuse/√2 = 10/√2 = 5√2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'If sin(θ) = 3/5 and θ is in the first quadrant, what is cos(θ)?', '3/4', '4/5', '4/3', '5/3', '5/4', 'B', 'Adjacent = √(5² − 3²) = 4. cos(θ) = 4/5.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'What is the area of a regular hexagon with side length 6?', '36√3', '54√3', '72√3', '108√3', '216', 'B', 'A = (3√3/2)s² = (3√3/2)(36) = 54√3.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p2, v_math_unit3, 'The exterior angle of a regular polygon is 40°. How many sides does it have?', '7', '8', '9', '10', '12', 'C', '360° / 40° = 9 sides.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'In right triangle with legs 7 and 24, what is sin of the angle opposite the side of length 7?', '7/24', '24/25', '7/25', '24/7', '25/7', 'C', 'Hypotenuse = √(49 + 576) = √625 = 25. sin = opposite/hypotenuse = 7/25.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'What is the surface area of a cube with edge length 4?', '24', '48', '64', '96', '192', 'D', 'SA = 6s² = 6(16) = 96.', 'MULTIPLE_CHOICE', 'EASY');

    -- ════════════════════════════════════════════════════════════
    -- PAPER 3 – MATH PRACTICE TEST 3
    -- ════════════════════════════════════════════════════════════

    -- ── Unit 1: Pre-Algebra & Elementary Algebra (14 q) ────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p3, v_math_unit1, 'What is the value of √144 + √25?', '13', '15', '17', '19', '21', 'C', '√144 = 12, √25 = 5. Sum = 17.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'If 3(x + 4) = 27, what is x?', '3', '5', '7', '9', '12', 'B', '3x + 12 = 27 → 3x = 15 → x = 5.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'Which of the following is equivalent to (−3)³?', '9', '−9', '27', '−27', '−6', 'D', '(−3)(−3)(−3) = −27.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'A car travels 264 miles in 4 hours. At the same rate, how far will it travel in 7 hours?', '396', '432', '462', '528', '594', 'C', 'Rate = 264/4 = 66 mph. Distance = 66 × 7 = 462 miles.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'What is 15% of 80% of 200?', '12', '18', '20', '24', '32', 'D', '80% of 200 = 160. 15% of 160 = 24.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'The ratio of boys to girls in a class is 3:4 and there are 35 students. How many boys are there?', '12', '15', '18', '20', '21', 'B', '3/(3+4) × 35 = 3/7 × 35 = 15.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'What is the mode of the data set: 4, 7, 4, 9, 2, 4, 7, 1?', '1', '2', '4', '7', '9', 'C', '4 appears three times — more than any other value.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'What is the solution to −2(3x − 1) = 5x − 9?', 'x = −1', 'x = 1', 'x = 2', 'x = 3', 'x = −2', 'B', '−6x + 2 = 5x − 9 → 11 = 11x → x = 1.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'A sweater originally priced at $60 is discounted 25%, then the discounted price is raised by 10%. What is the final price?', '$42.50', '$44.50', '$49.50', '$50.00', '$52.50', 'C', '60 × 0.75 = $45. $45 × 1.10 = $49.50.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'For what value of x is the expression (x + 2)/(x − 5) undefined?', 'x = −2', 'x = 2', 'x = 5', 'x = −5', 'x = 0', 'C', 'An expression is undefined when its denominator equals zero. x − 5 = 0 → x = 5.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'The sum of three consecutive even integers is 78. What is the largest integer?', '24', '26', '28', '30', '32', 'C', 'n + (n+2) + (n+4) = 78 → 3n + 6 = 78 → n = 24. Largest = 28.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'What is the greatest common factor of 42 and 70?', '7', '14', '21', '35', '42', 'B', 'GCF(42, 70): 42 = 2 × 3 × 7; 70 = 2 × 5 × 7. GCF = 2 × 7 = 14.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'If 3^x = 81, what is x?', '3', '4', '5', '6', '9', 'B', '3⁴ = 81, so x = 4.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'What is the value of k if the equation 2kx + 4 = 8 has solution x = 2?', '0', '1', '2', '3', '4', 'B', '2k(2) + 4 = 8 → 4k = 4 → k = 1.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 2: Intermediate Algebra & Coordinate Geometry (14 q)
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p3, v_math_unit2, 'What is the equation of the line passing through (2, 5) with slope 3?', 'y = 3x − 1', 'y = 3x + 1', 'y = 3x + 5', 'y = 3x − 5', 'y = 2x + 5', 'A', 'y − 5 = 3(x − 2) → y = 3x − 6 + 5 = 3x − 1.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'If f(x) = 2x² + 3x − 5, what is f(0)?', '−5', '0', '3', '5', '−3', 'A', 'f(0) = 0 + 0 − 5 = −5.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the discriminant of x² − 6x + 10 = 0?', '−4', '0', '4', '16', '36', 'A', 'b² − 4ac = (−6)² − 4(1)(10) = 36 − 40 = −4. No real solutions.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'The line y = 4 − 2x intersects the y-axis at:', 'y = −2', 'y = 2', 'y = 4', 'y = −4', 'y = 0', 'C', 'Set x = 0: y = 4 − 0 = 4.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'If g(x) = (x + 3)/(x − 1), what is g(5)?', '1', '2', '3', '4', '8', 'B', 'g(5) = (5 + 3)/(5 − 1) = 8/4 = 2.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the solution set for x² − 9 = 0?', 'x = 3 only', 'x = −3 only', 'x = ±3', 'x = ±√3', 'x = ±9', 'C', 'x² = 9 → x = ±3.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'If two lines are perpendicular and one has slope 5, what is the slope of the other?', '5', '−5', '1/5', '−1/5', '1/25', 'D', 'Perpendicular slope is the negative reciprocal: −1/5.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'The point (3, −5) is reflected over the x-axis. What are the new coordinates?', '(−3, −5)', '(3, 5)', '(−3, 5)', '(5, −3)', '(−5, 3)', 'B', 'Reflection over x-axis maps (x, y) → (x, −y): (3, −5) → (3, 5).', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the sum of the roots of 3x² − 12x + 7 = 0?', '−4', '4', '7/3', '12', '−7/3', 'B', 'Sum of roots = −b/a = −(−12)/3 = 4.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the range of the function f(x) = x² + 3?', 'y ≥ 0', 'y ≥ 3', 'y > 3', 'all real numbers', 'y ≤ 3', 'B', 'The minimum value of x² is 0, so the minimum of f(x) = 0 + 3 = 3. Range: y ≥ 3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the equation of the circle centered at the origin passing through (3, 4)?', 'x² + y² = 5', 'x² + y² = 7', 'x² + y² = 25', '(x−3)² + (y−4)² = 25', 'x² + y² = 49', 'C', 'r = √(3² + 4²) = √25 = 5. Equation: x² + y² = 25.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'For the function f(x) = |x − 2| + 1, what is the minimum value of f(x)?', '−1', '0', '1', '2', '3', 'C', 'The minimum of |x − 2| is 0 (at x = 2), so the minimum of f(x) = 0 + 1 = 1.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the product of the roots of 2x² + 5x − 3 = 0?', '−3/2', '3/2', '−5/2', '5/2', '6', 'A', 'Product of roots = c/a = −3/2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the x-coordinate of the vertex of y = x² − 6x + 11?', '−3', '3', '6', '−6', '11', 'B', 'x-vertex = −b/(2a) = −(−6)/(2×1) = 6/2 = 3.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 3: Plane Geometry & Trigonometry (12 q) ───────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p3, v_math_unit3, 'Two sides of a right triangle are 7 and 24. What is the hypotenuse?', '17', '23', '25', '27', '31', 'C', '√(7² + 24²) = √(49 + 576) = √625 = 25.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit3, 'A rectangle has perimeter 40 and length 12. What is its area?', '60', '72', '84', '96', '120', 'D', 'Width = (40 − 2×12)/2 = 8. Area = 12 × 8 = 96.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'What is the sum of the interior angles of a hexagon?', '540°', '600°', '720°', '900°', '1080°', 'C', '(n − 2) × 180° = (6 − 2) × 180° = 720°.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'In a 30-60-90 triangle, the shortest side is 5. What is the hypotenuse?', '5', '5√2', '5√3', '10', '10√3', 'D', 'In a 30-60-90 triangle, sides are x, x√3, and 2x. Hypotenuse = 2 × 5 = 10.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'A sector of a circle has a central angle of 90° and radius 8. What is the area of the sector?', '4π', '8π', '16π', '32π', '64π', 'C', 'Area = (90/360)π(8²) = (1/4)(64π) = 16π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'If cos(θ) = 5/13 and θ is in the first quadrant, what is tan(θ)?', '5/12', '12/13', '12/5', '13/5', '13/12', 'C', 'Opposite = √(13² − 5²) = √144 = 12. tan(θ) = opp/adj = 12/5.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'Two parallel lines are cut by a transversal. One angle is 65°. What is its co-interior (same-side interior) angle?', '25°', '65°', '115°', '125°', '145°', 'C', 'Co-interior angles are supplementary: 180° − 65° = 115°.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'A cone has radius 3 and height 4. What is its volume?', '4π', '12π', '16π', '36π', '48π', 'B', 'V = (1/3)πr²h = (1/3)π(9)(4) = 12π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'What is the length of the arc with central angle 120° in a circle with radius 9?', '3π', '6π', '9π', '12π', '18π', 'B', 'Arc length = (120/360)(2π)(9) = (1/3)(18π) = 6π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'In triangle ABC, angle A = 45° and angle B = 75°. What is angle C?', '45°', '55°', '60°', '65°', '75°', 'C', '180° − 45° − 75° = 60°.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit3, 'What is the value of sin(30°) × cos(60°)?', '1/4', '1/2', '1', '√2/2', '√3/2', 'A', 'sin(30°) = 1/2, cos(60°) = 1/2. Product = (1/2)(1/2) = 1/4.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'A right triangle has hypotenuse 13 and one leg 5. What is the area of the triangle?', '30', '36', '40', '60', '65', 'A', 'Other leg = √(13² − 5²) = 12. Area = (1/2)(5)(12) = 30.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ════════════════════════════════════════════════════════════
    -- PAPER 4 – MATH PRACTICE TEST 4
    -- ════════════════════════════════════════════════════════════

    -- ── Unit 1: Pre-Algebra & Elementary Algebra (14 q) ────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p4, v_math_unit1, 'What is the value of 2³ × 3²?', '36', '48', '54', '72', '96', 'D', '2³ = 8, 3² = 9. 8 × 9 = 72.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'The median of the data set {15, 22, 8, 31, 19, 14, 27} is:', '14', '15', '19', '22', '31', 'C', 'Sorted: 8, 14, 15, 19, 22, 27, 31. The middle value (4th of 7) is 19.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'If x/4 − 3 = 5, what is x?', '8', '16', '24', '32', '48', 'D', 'x/4 = 8 → x = 32.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'A recipe uses 2.5 cups of flour for 12 cookies. How many cups are needed for 30 cookies?', '5.25', '6', '6.25', '7', '7.5', 'C', '2.5/12 × 30 = 2.5 × 2.5 = 6.25 cups.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit1, 'What is (−4)² − (−4)?', '12', '16', '20', '−20', '−12', 'C', '(−4)² = 16. 16 − (−4) = 16 + 4 = 20.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'What is 12.5% of 400?', '25', '40', '50', '60', '80', 'C', '0.125 × 400 = 50.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'If a/b = 4/7 and b = 21, what is a?', '8', '9', '10', '12', '15', 'D', 'a = (4/7)(21) = 12.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'What is the value of 5! (5 factorial)?', '25', '60', '100', '120', '125', 'D', '5! = 5 × 4 × 3 × 2 × 1 = 120.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'A bag has 3 red, 5 blue, and 2 white balls. What is the probability of NOT selecting a blue ball?', '1/2', '1/3', '2/5', '3/5', '7/10', 'A', 'P(not blue) = (3 + 2)/10 = 5/10 = 1/2.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'Which value of x satisfies both 4x − 7 < 5 AND x + 2 > 0?', '−3', '0', '2', '3', '4', 'C', '4x < 12 → x < 3. And x > −2. So −2 < x < 3. Only x = 2 fits.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit1, 'If p = 3 and q = −2, what is p² − q³?', '9', '1', '−1', '17', '−17', 'D', 'p² = 9, q³ = −8. 9 − (−8) = 9 + 8 = 17.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit1, 'What is the area of a square with perimeter 28?', '28', '49', '56', '64', '196', 'B', 'Side = 28/4 = 7. Area = 7² = 49.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'Which of the following is equivalent to 2(x + 3)²?', '2x² + 6', '2x² + 12x + 18', '2x² + 6x + 9', '4x² + 12x + 18', '2x² + 12x + 9', 'B', '(x+3)² = x² + 6x + 9. Multiply by 2: 2x² + 12x + 18.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit1, 'What is the sum of the first 10 positive even integers (2 + 4 + 6 + … + 20)?', '90', '100', '110', '120', '130', 'C', 'Sum = 2 + 4 + 6 + 8 + 10 + 12 + 14 + 16 + 18 + 20 = 110.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 2: Intermediate Algebra & Coordinate Geometry (14 q)
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p4, v_math_unit2, 'What is the value of i² + i³ + i⁴, where i = √(−1)?', 'i', '−i', '0', '1', '−1 + i', 'B', 'i² = −1, i³ = −i, i⁴ = 1. Sum = −1 + (−i) + 1 = −i.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the length of the segment from (1, 2) to (7, 10)?', '8', '10', '12', '√84', '6√2', 'B', 'd = √((7−1)² + (10−2)²) = √(36 + 64) = √100 = 10.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the equation of the line through the origin with slope −4?', 'y = −4', 'x = −4', 'y = −4x', 'y = 4x', 'y = x − 4', 'C', 'y = mx + b. m = −4, b = 0 (passes through origin). y = −4x.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the maximum value of f(x) = −x² + 4x − 3?', '1', '2', '3', '4', '−3', 'A', 'Vertex at x = −b/(2a) = −4/(−2) = 2. f(2) = −4 + 8 − 3 = 1.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit2, 'What are the x-intercepts of y = x² − x − 12?', 'x = 3, x = −4', 'x = −3, x = 4', 'x = 3, x = 4', 'x = −3, x = −4', 'x = 6, x = −2', 'B', '(x − 4)(x + 3) = 0 → x = 4 or x = −3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit2, 'If log₁₀(x) = 3, what is x?', '30', '300', '1000', '3000', '10000', 'C', '10³ = 1000.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the distance from the point (3, −4) to the origin?', '1', '3.5', '5', '7', '25', 'C', '√(3² + (−4)²) = √(9 + 16) = √25 = 5.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the area of the triangle with vertices at (0,0), (6,0), and (0,4)?', '10', '12', '18', '20', '24', 'B', 'A = (1/2) × base × height = (1/2)(6)(4) = 12.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the y-intercept of 5x − 2y = 10?', 'y = −5', 'y = 2', 'y = 5', 'y = −2', 'y = 10', 'A', 'Set x = 0: −2y = 10 → y = −5.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'The sum of the first n terms of a sequence is S(n) = n(n+1). What is the 5th term?', '7', '9', '10', '11', '12', 'C', 'a₅ = S(5) − S(4) = 5(6) − 4(5) = 30 − 20 = 10.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit2, 'Which equation represents a parabola opening downward?', 'y = x² + 3', 'y = −2x² + x − 1', 'x = y² − 4', 'y = (x−1)² + 2', 'y = 3x² − 6', 'B', 'A parabola y = ax² opens downward when a < 0. Only y = −2x² + x − 1 has a negative leading coefficient.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'In the matrix [[3, 2], [1, d]], if the determinant is 10, what is d?', '2', '3', '4', '5', '6', 'C', 'det = 3d − (2)(1) = 3d − 2 = 10 → 3d = 12 → d = 4.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the next term in the sequence 1, 3, 7, 15, 31, …?', '47', '51', '55', '63', '65', 'D', 'Each term = previous × 2 + 1. Next = 31 × 2 + 1 = 63.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit2, 'For what value of x does 2^x = 1/8?', '−4', '−3', '−2', '3', '4', 'B', '1/8 = 2^(−3), so x = −3.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 3: Plane Geometry & Trigonometry (12 q) ───────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p4, v_math_unit3, 'What is the area of a trapezoid with parallel sides of 8 and 14 and height 5?', '45', '55', '65', '70', '110', 'B', 'A = (1/2)(b₁ + b₂)(h) = (1/2)(8 + 14)(5) = (1/2)(22)(5) = 55.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'A sphere has radius 6. What is its volume?', '36π', '72π', '144π', '288π', '432π', 'D', 'V = (4/3)πr³ = (4/3)π(216) = 288π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'Two supplementary angles are in the ratio 1:4. What is the measure of the larger angle?', '36°', '72°', '108°', '144°', '162°', 'D', 'x + 4x = 180° → x = 36°. Larger angle = 4 × 36° = 144°.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'In right triangle ABC with right angle at C, BC = 5 and AB = 13. What is sin(∠A)?', '5/12', '5/13', '12/13', '13/5', '12/5', 'B', 'AB is the hypotenuse (= 13). BC is opposite ∠A (= 5). sin(A) = opp/hyp = 5/13.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'What is cos(45°) × tan(45°)?', '√2/2', '1', '√2', '1/2', '2', 'A', 'cos(45°) = √2/2, tan(45°) = 1. Product = √2/2 × 1 = √2/2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'A square is inscribed in a circle of radius 5. What is the area of the square?', '25', '50', '75', '100', '25π', 'B', 'Diameter = 10 = diagonal of square. Side = 10/√2 = 5√2. Area = (5√2)² = 50.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit3, 'What is the perimeter of an equilateral triangle with area 9√3?', '9', '18', '27', '36', '54', 'B', '(√3/4)s² = 9√3 → s² = 36 → s = 6. Perimeter = 3 × 6 = 18.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit3, 'The angle of elevation from a point 60 m from a building to its top is 30°. How tall is the building?', '20 m', '20√3 m', '30 m', '30√3 m', '60√3 m', 'B', 'tan(30°) = h/60 → h = 60 × (1/√3) = 60√3/3 = 20√3 m.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit3, 'A rhombus has diagonals of length 10 and 24. What is the length of each side?', '12', '13', '14', '15', '26', 'B', 'Half-diagonals form a right triangle: legs 5 and 12. Side = √(25 + 144) = √169 = 13.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'What is the measure of each interior angle of a regular octagon?', '120°', '135°', '140°', '144°', '150°', 'B', '(n − 2) × 180°/n = (8 − 2) × 180°/8 = 6 × 22.5° = 135°.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'A cylinder has radius 3 and height 10. What is its lateral surface area?', '30π', '60π', '90π', '120π', '180π', 'B', 'Lateral SA = 2πrh = 2π(3)(10) = 60π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'The hypotenuse of a 30-60-90 triangle is 2√3. What is the length of the shortest side?', '√3', '1', '√3/2', '2', '3', 'A', 'In a 30-60-90 triangle, hypotenuse = 2x. 2x = 2√3 → x = √3. Shortest side = x = √3.', 'MULTIPLE_CHOICE', 'HARD');

END $$;
