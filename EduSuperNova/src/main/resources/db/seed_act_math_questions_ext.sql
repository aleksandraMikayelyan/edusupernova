-- ============================================================
-- ACT Math – 60 Additional Questions (20 per paper)
-- Extends Math Practice Tests 2, 3, 4 from 40 → 60 questions
-- matching the real ACT Math exam format (60 q / 60 min).
--
-- Run AFTER seed_act_math_questions.sql.
-- SELECTs existing papers and units — does NOT re-insert them.
-- Also updates totalquestions from 40 → 60 on the 3 papers.
-- ============================================================

DO $$
DECLARE
    v_math_id    INTEGER;
    v_math_unit1 INTEGER;
    v_math_unit2 INTEGER;
    v_math_unit3 INTEGER;
    v_math_p2    INTEGER;
    v_math_p3    INTEGER;
    v_math_p4    INTEGER;
BEGIN

    -- ── Resolve existing IDs ───────────────────────────────────
    SELECT idcourse INTO v_math_id FROM courses WHERE lower(coursename) = 'act math' LIMIT 1;
    IF v_math_id IS NULL THEN RAISE EXCEPTION 'Course "ACT Math" not found.'; END IF;

    SELECT idunit INTO v_math_unit1 FROM units WHERE idcourse = v_math_id AND queue = 1 LIMIT 1;
    SELECT idunit INTO v_math_unit2 FROM units WHERE idcourse = v_math_id AND queue = 2 LIMIT 1;
    SELECT idunit INTO v_math_unit3 FROM units WHERE idcourse = v_math_id AND queue = 3 LIMIT 1;

    SELECT idpaper INTO v_math_p2 FROM papers
    WHERE idcourse = v_math_id AND lower(papername) = 'math practice test 2' LIMIT 1;
    SELECT idpaper INTO v_math_p3 FROM papers
    WHERE idcourse = v_math_id AND lower(papername) = 'math practice test 3' LIMIT 1;
    SELECT idpaper INTO v_math_p4 FROM papers
    WHERE idcourse = v_math_id AND lower(papername) = 'math practice test 4' LIMIT 1;

    IF v_math_p2 IS NULL THEN RAISE EXCEPTION 'Math Practice Test 2 not found. Run seed_act_math_questions.sql first.'; END IF;
    IF v_math_p3 IS NULL THEN RAISE EXCEPTION 'Math Practice Test 3 not found.'; END IF;
    IF v_math_p4 IS NULL THEN RAISE EXCEPTION 'Math Practice Test 4 not found.'; END IF;

    -- ── Update paper totals to reflect real ACT exam (60 q) ───
    UPDATE papers SET totalquestions = 60 WHERE idpaper IN (v_math_p2, v_math_p3, v_math_p4);

    -- ════════════════════════════════════════════════════════════
    -- PAPER 2 EXTENSIONS  (questions 41–60)
    -- ════════════════════════════════════════════════════════════

    -- ── Unit 1: Pre-Algebra & Elementary Algebra (7 q) ─────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p2, v_math_unit1, 'What is the value of √0.0049?', '0.007', '0.07', '0.7', '7', '0.0007', 'B', '√0.0049 = √(49/10000) = 7/100 = 0.07.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'A city''s population increases from 50,000 to 65,000. What is the percent increase?', '15%', '23%', '25%', '30%', '35%', 'D', '(65000 − 50000)/50000 × 100 = 15000/50000 × 100 = 30%.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'Which inequality is equivalent to −3x + 5 ≥ 14?', 'x ≥ −3', 'x ≤ −3', 'x ≥ 3', 'x ≤ 3', 'x ≥ −9', 'B', '−3x ≥ 9. Dividing by −3 and flipping: x ≤ −3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'What is the value of (2/3)² × (3/4)²?', '1/4', '3/8', '1/2', '4/9', '1/6', 'A', '(4/9)(9/16) = 36/144 = 1/4.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'How many integers from 1 to 30 inclusive are divisible by 3 or 5?', '12', '13', '14', '15', '16', 'C', 'Divisible by 3: 10 numbers. By 5: 6 numbers. By both (15, 30): 2. Total = 10 + 6 − 2 = 14.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p2, v_math_unit1, 'If 2^(m+1) = 32, what is the value of m?', '3', '4', '5', '6', '7', 'B', '32 = 2⁵, so 2^(m+1) = 2⁵ → m + 1 = 5 → m = 4.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit1, 'An employee earns $15.50/hr for the first 40 hours and 1.5× that rate for overtime. How much does she earn in a week with 45 hours worked?', '$697.50', '$706.25', '$736.25', '$748.75', '$820.25', 'C', '40 × $15.50 = $620. Overtime: 5 × ($15.50 × 1.5) = 5 × $23.25 = $116.25. Total = $736.25.', 'MULTIPLE_CHOICE', 'HARD');

    -- ── Unit 2: Intermediate Algebra & Coordinate Geometry (7 q)
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p2, v_math_unit2, 'What is the solution to the system: 2x + y = 7 and x − y = 2?', '(1, 5)', '(2, 3)', '(3, 1)', '(4, −1)', '(5, −3)', 'C', 'From the second equation: x = y + 2. Substituting: 2(y+2) + y = 7 → 3y = 3 → y = 1, x = 3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'If f(x) = 3x − 2 and g(x) = x², what is f(g(2))?', '4', '8', '10', '12', '16', 'C', 'g(2) = 4. f(4) = 3(4) − 2 = 10.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the equation of the line parallel to y = −2x + 5 that passes through (1, 0)?', 'y = −2x + 2', 'y = −2x + 5', 'y = 2x − 2', 'y = −2x − 2', 'y = 2x + 2', 'A', 'Parallel lines share slope −2. Using point (1, 0): y − 0 = −2(x − 1) → y = −2x + 2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the solution to 3^(2x) = 81?', '1', '2', '3', '4', '9', 'B', '3^(2x) = 3⁴ → 2x = 4 → x = 2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit2, 'The graph of y = x² − 4x + 3 has x-intercepts at:', 'x = 1 and x = 3', 'x = −1 and x = −3', 'x = 1 and x = −3', 'x = −1 and x = 3', 'x = 0 and x = 4', 'A', '(x − 1)(x − 3) = 0 → x = 1 and x = 3.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the distance from the point (4, 7) to the horizontal line y = 3?', '3', '4', '5', '7', '11', 'B', 'Distance from (4, 7) to y = 3 is |7 − 3| = 4.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit2, 'What is the area of the circle described by x² + y² = 16?', '4π', '8π', '16π', '32π', '64π', 'C', 'r² = 16 → r = 4. Area = πr² = 16π.', 'MULTIPLE_CHOICE', 'EASY');

    -- ── Unit 3: Plane Geometry & Trigonometry (6 q) ────────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p2, v_math_unit3, 'Two angles of a triangle measure 55° and 75°. What is the third angle?', '40°', '45°', '50°', '55°', '60°', 'C', '180° − 55° − 75° = 50°.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p2, v_math_unit3, 'A square has a diagonal of length 8√2. What is the area of the square?', '32', '64', '128', '32√2', '64√2', 'B', 'Diagonal = s√2 = 8√2 → s = 8. Area = 8² = 64.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'What is the arc length in a circle of radius 12 subtended by a central angle of 60°?', '2π', '4π', '6π', '12π', '24π', 'B', 'Arc = (60/360)(2π)(12) = (1/6)(24π) = 4π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'In a right triangle, one acute angle is 60° and the adjacent leg is 5. What is the length of the opposite leg?', '5/√3', '5√3', '10', '5/2', '10√3', 'B', 'tan(60°) = opp/5. tan(60°) = √3 → opp = 5√3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'What is the perimeter of a right triangle with legs 9 and 40?', '49', '90', '98', '81', '41', 'B', 'Hypotenuse = √(81 + 1600) = √1681 = 41. Perimeter = 9 + 40 + 41 = 90.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p2, v_math_unit3, 'For any angle θ, what is the value of sin²(θ) + cos²(θ)?', '0', '1/2', '1', '2', 'It depends on θ', 'C', 'This is the Pythagorean identity: sin²(θ) + cos²(θ) = 1 for all angles θ.', 'MULTIPLE_CHOICE', 'EASY');

    -- ════════════════════════════════════════════════════════════
    -- PAPER 3 EXTENSIONS  (questions 41–60)
    -- ════════════════════════════════════════════════════════════

    -- ── Unit 1: Pre-Algebra & Elementary Algebra (7 q) ─────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p3, v_math_unit1, 'Simplify: (5x²y)(3xy³)', '8x³y⁴', '15x²y⁴', '15x³y⁴', '15x³y³', '8x²y⁴', 'C', '5 × 3 = 15; x² × x = x³; y × y³ = y⁴. Result: 15x³y⁴.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'What is the value of (1/2 + 1/3) ÷ (1/4)?', '5/24', '5/6', '5/3', '10/3', '5/2', 'D', '1/2 + 1/3 = 5/6. Then (5/6) ÷ (1/4) = (5/6) × 4 = 20/6 = 10/3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'A car worth $20,000 depreciates 15% of its current value each year. What is it worth after 2 years?', '$14,000', '$14,450', '$14,900', '$16,000', '$17,000', 'B', 'After year 1: 20000 × 0.85 = $17,000. After year 2: 17000 × 0.85 = $14,450.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p3, v_math_unit1, 'Which of the following is the complete factorization of x² − 16?', '(x − 4)²', '(x + 4)(x − 4)', '(x − 8)(x + 2)', 'x(x − 16)', '(x − 4)(x + 2)', 'B', 'x² − 16 is a difference of squares: (x + 4)(x − 4).', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit1, 'If the average of 3x, x + 4, and 2x − 1 is 11, what is x?', '2', '3', '4', '5', '6', 'D', '(3x + x+4 + 2x−1)/3 = 11 → (6x+3)/3 = 11 → 6x+3 = 33 → x = 5.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit1, 'If 5 − |2x − 3| = 1, what are the possible values of x?', 'x = −0.5 and x = 3.5', 'x = 1 and x = 2', 'x = −4 and x = 4', 'x = −1 and x = 4', 'x = 0 and x = 3', 'A', '|2x − 3| = 4. Then 2x − 3 = 4 → x = 3.5, or 2x − 3 = −4 → x = −0.5.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p3, v_math_unit1, 'What is the total surface area of a rectangular prism with length 5, width 3, and height 4?', '60', '74', '80', '94', '120', 'D', 'SA = 2(lw + lh + wh) = 2(15 + 20 + 12) = 2(47) = 94.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 2: Intermediate Algebra & Coordinate Geometry (7 q)
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p3, v_math_unit2, 'What is the inverse function of f(x) = 2x + 6?', 'f⁻¹(x) = (x + 6)/2', 'f⁻¹(x) = (x − 6)/2', 'f⁻¹(x) = 2x − 6', 'f⁻¹(x) = x/2 + 6', 'f⁻¹(x) = 6 − 2x', 'B', 'Set y = 2x + 6. Swap: x = 2y + 6 → y = (x − 6)/2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the center of the circle (x + 3)² + (y − 5)² = 49?', '(3, −5)', '(−3, 5)', '(3, 5)', '(−3, −5)', '(0, 0)', 'B', 'Standard form (x − h)² + (y − k)² = r². Here h = −3, k = 5. Center = (−3, 5).', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'For what values of x is f(x) = √(x − 4) defined?', 'x < 4', 'x = 4', 'x ≥ 4', 'x > 4', 'all real x', 'C', 'The radicand must be ≥ 0: x − 4 ≥ 0 → x ≥ 4.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the value of log₄(64)?', '2', '3', '4', '6', '16', 'B', '4^x = 64 = 4³ → x = 3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'The lines y = 2x − 1 and y = 2x + 5 are:', 'perpendicular', 'the same line', 'intersecting at exactly one point', 'parallel', 'undefined', 'D', 'Both lines have slope 2 with different y-intercepts, so they are parallel.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit2, 'If f(x) = x² − 1 and g(x) = 2x, what is (f ∘ g)(3)?', '25', '35', '16', '17', '5', 'B', 'g(3) = 6. f(6) = 36 − 1 = 35.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit2, 'What is the axis of symmetry of y = −3x² + 12x − 7?', 'x = −2', 'x = 2', 'x = 4', 'x = −4', 'x = 3', 'B', 'x = −b/(2a) = −12/(2 × −3) = −12/−6 = 2.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 3: Plane Geometry & Trigonometry (6 q) ────────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p3, v_math_unit3, 'What is the volume of a rectangular prism with length 8, width 5, and height 3?', '40', '79', '120', '158', '240', 'C', 'V = l × w × h = 8 × 5 × 3 = 120.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p3, v_math_unit3, 'In a right triangle, one leg is 5 and the hypotenuse is 13. What is the cosine of the angle opposite the leg of length 5?', '5/13', '12/13', '5/12', '13/5', '12/5', 'B', 'Other leg = √(169 − 25) = 12. cos(angle opposite 5) = adj/hyp = 12/13.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'A circle has circumference 12π. What is its area?', '6π', '12π', '36π', '72π', '144π', 'C', 'C = 2πr = 12π → r = 6. Area = π(6²) = 36π.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'Two similar triangles have sides 3, 4, 5 and the longest side of the larger is 20. What is the perimeter of the larger triangle?', '24', '36', '40', '48', '60', 'D', 'Scale factor = 20/5 = 4. Small perimeter = 12. Large perimeter = 12 × 4 = 48.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p3, v_math_unit3, 'An isosceles triangle has two equal sides of 10 and a base of 12. What is its height?', '6', '7', '8', '9', '10', 'C', 'Half-base = 6. Height = √(10² − 6²) = √(100 − 36) = √64 = 8.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p3, v_math_unit3, 'For 0° < x < 90°, if sin(x) = cos(x), what is x?', '30°', '45°', '60°', '75°', '90°', 'B', 'sin(x) = cos(x) means tan(x) = 1, which occurs at x = 45°.', 'MULTIPLE_CHOICE', 'EASY');

    -- ════════════════════════════════════════════════════════════
    -- PAPER 4 EXTENSIONS  (questions 41–60)
    -- ════════════════════════════════════════════════════════════

    -- ── Unit 1: Pre-Algebra & Elementary Algebra (7 q) ─────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p4, v_math_unit1, 'A train travels at 60 mph for 2.5 hours. How far does it travel?', '120 miles', '130 miles', '140 miles', '150 miles', '160 miles', 'D', '60 × 2.5 = 150 miles.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'What is the next term in the arithmetic sequence: 5, 8, 11, 14, ...?', '16', '17', '18', '19', '20', 'B', 'Common difference = 3. Next term = 14 + 3 = 17.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'If x² = 81, what is the sum of all possible values of x?', '−81', '−18', '0', '18', '81', 'C', 'x = 9 or x = −9. Sum = 9 + (−9) = 0.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit1, 'What is the value of 4^(−2)?', '−16', '−8', '1/16', '1/8', '1/4', 'C', '4^(−2) = 1/4² = 1/16.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'A company''s revenue fell from $120,000 to $90,000. What is the percent decrease?', '15%', '20%', '25%', '30%', '33%', 'C', 'Decrease = $30,000. Percent = 30000/120000 × 100 = 25%.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit1, 'Which of the following is NOT a real number?', '√4', '√(−4)', '√0', '√(1/4)', '√16', 'B', '√(−4) = 2i, which is imaginary, not a real number.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit1, 'The expression 3x² − 2x + k equals 0 when x = 1. What is k?', '−5', '−3', '−1', '1', '5', 'C', '3(1)² − 2(1) + k = 0 → 3 − 2 + k = 0 → k = −1.', 'MULTIPLE_CHOICE', 'MEDIUM');

    -- ── Unit 2: Intermediate Algebra & Coordinate Geometry (7 q)
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p4, v_math_unit2, 'If log₅(x) = 2, what is x?', '10', '25', '32', '50', '100', 'B', '5² = 25.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'The point (3, k) lies on y = 4x − 5. What is k?', '3', '5', '7', '9', '11', 'C', 'y = 4(3) − 5 = 12 − 5 = 7.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit2, 'What are the real solutions to 2x² + 3x = 0?', 'x = 0 only', 'x = −3/2 only', 'x = 0 and x = −3/2', 'x = 0 and x = 3/2', 'x = 3/2 only', 'C', 'x(2x + 3) = 0 → x = 0 or x = −3/2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit2, 'A line passes through (0, −4) and (5, 0). What is its equation?', 'y = (4/5)x − 4', 'y = (5/4)x − 4', 'y = −(4/5)x − 4', 'y = (4/5)x + 5', 'y = 4x − 4', 'A', 'Slope = (0 − (−4))/(5 − 0) = 4/5. y-intercept = −4. y = (4/5)x − 4.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit2, 'What is the sum of the solutions to x² − 7x + 10 = 0?', '−7', '5', '7', '10', '−10', 'C', 'Sum of roots = −b/a = −(−7)/1 = 7.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit2, 'For x ≠ 3, which expression is equivalent to (x² − 9)/(x − 3)?', 'x − 3', 'x + 3', 'x² + 3', 'x', 'x² − 3', 'B', '(x − 3)(x + 3)/(x − 3) = x + 3 for x ≠ 3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit2, 'The circle x² + y² = 25 is centered at the origin with radius 5. Which point lies ON the circle?', '(3, 4)', '(2, 4)', '(4, 4)', '(0, 4)', '(5, 5)', 'A', '3² + 4² = 9 + 16 = 25 = 5². Point (3, 4) satisfies the equation.', 'MULTIPLE_CHOICE', 'EASY');

    -- ── Unit 3: Plane Geometry & Trigonometry (6 q) ────────────
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, optione, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_math_id, v_math_p4, v_math_unit3, 'What is the area of a parallelogram with base 14 and height 9?', '63', '126', '252', '46', '23', 'B', 'Area = base × height = 14 × 9 = 126.', 'MULTIPLE_CHOICE', 'EASY'),
    (v_math_id, v_math_p4, v_math_unit3, 'Each exterior angle of a regular pentagon measures:', '36°', '54°', '60°', '72°', '108°', 'D', 'Sum of exterior angles = 360°. 360°/5 = 72°.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'What is the height of an equilateral triangle with side length 10?', '5', '5√2', '5√3', '10√3', '10', 'C', 'Height = (√3/2) × s = (√3/2) × 10 = 5√3.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'If cos(30°) = √3/2, what is cos(150°)?', '√3/2', '−√3/2', '1/2', '−1/2', '−1', 'B', 'cos(150°) = cos(180° − 30°) = −cos(30°) = −√3/2.', 'MULTIPLE_CHOICE', 'MEDIUM'),
    (v_math_id, v_math_p4, v_math_unit3, 'A rectangle has length (2x + 3) and width (x − 1). What is its area in terms of x?', '3x + 2', '6x + 4', '2x² + x − 3', '2x² − x + 3', '2x² + 5x − 3', 'C', '(2x + 3)(x − 1) = 2x² − 2x + 3x − 3 = 2x² + x − 3.', 'MULTIPLE_CHOICE', 'HARD'),
    (v_math_id, v_math_p4, v_math_unit3, 'In right triangle RST with right angle at S and angle R = 40°, which ratio equals cos(R)?', 'RS/RT', 'ST/RT', 'ST/RS', 'RS/ST', 'RT/RS', 'A', 'cos(R) = adjacent/hypotenuse = RS/RT. (RT is the hypotenuse opposite the right angle at S.)', 'MULTIPLE_CHOICE', 'MEDIUM');

END $$;
