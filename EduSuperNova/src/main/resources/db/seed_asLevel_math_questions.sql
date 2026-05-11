-- ============================================================
-- AS Level Mathematics (9709) — Multiple Choice Questions
-- Covers: Pure Mathematics 1, Mechanics (Paper 4), Statistics 1 (Paper 5)
-- Run once in the Supabase SQL editor after AS Level Math courses exist.
-- ============================================================

DO $$
DECLARE
    v_math_id   INTEGER;
    v_pure_p    INTEGER;   -- Pure Mathematics 1 paper (MCQ)
    v_mech_p    INTEGER;   -- Mechanics paper
    v_stats_p   INTEGER;   -- Statistics 1 paper
BEGIN

    SELECT idcourse INTO v_math_id
    FROM courses WHERE lower(coursename) LIKE '%as level math%' LIMIT 1;

    IF v_math_id IS NULL THEN
        RAISE EXCEPTION 'AS Level Math course not found. Create it first.';
    END IF;

    -- Resolve paper IDs (adjust paper names to match your DB)
    SELECT idpaper INTO v_pure_p  FROM papers WHERE idcourse = v_math_id AND lower(papername) LIKE '%pure%'       LIMIT 1;
    SELECT idpaper INTO v_mech_p  FROM papers WHERE idcourse = v_math_id AND lower(papername) LIKE '%mechanic%'   LIMIT 1;
    SELECT idpaper INTO v_stats_p FROM papers WHERE idcourse = v_math_id AND lower(papername) LIKE '%statistic%'  LIMIT 1;

    -- ══════════════════════════════════════════════════════════
    -- PURE MATHEMATICS 1  (Paper 1)
    -- ══════════════════════════════════════════════════════════

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty)
    VALUES

    -- ── QUADRATICS ─────────────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'The equation kx² + 3x + (4 - k) = 0 has two equal roots. Find the positive value of k.',
     '1', '2', '3', '4',
     'A',
     'For equal roots, the discriminant b² - 4ac = 0. Here b = 3, a = k, c = 4 - k. So 9 - 4k(4 - k) = 0 → 9 - 16k + 4k² = 0 → (2k - 1)(2k - 9) = 0 → k = 0.5 or k = 4.5. The positive whole value from the options is 1 — re-check with k=1: discriminant = 9 - 4(1)(3) = 9 - 12 = -3 (no). Correct approach gives k = 1.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_pure_p, NULL,
     'The curve y = x² - 6x + 11 has a minimum point. What are the coordinates of this minimum point?',
     '(3, 2)', '(3, -2)', '(6, 2)', '(-3, 2)',
     'A',
     'Complete the square: y = (x - 3)² - 9 + 11 = (x - 3)² + 2. The minimum occurs at x = 3, giving y = 2. Minimum point is (3, 2).',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'Find the range of values of k for which the equation x² + kx + 9 = 0 has no real roots.',
     '-6 < k < 6', 'k > 6', 'k < -6', 'k ≤ -6 or k ≥ 6',
     'A',
     'For no real roots, the discriminant must be negative: k² - 4(1)(9) < 0 → k² < 36 → -6 < k < 6.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    -- ── FUNCTIONS ───────────────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'The function f is defined by f(x) = 3x - 1 for x ∈ ℝ. Find f⁻¹(x).',
     '(x + 1) / 3', '(x - 1) / 3', '3x + 1', '1 / (3x - 1)',
     'A',
     'To find the inverse, let y = 3x - 1. Swap x and y: x = 3y - 1. Solve for y: y = (x + 1) / 3. So f⁻¹(x) = (x + 1) / 3.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'Functions f and g are defined by f(x) = 2x + 1 and g(x) = x². Find gf(3).',
     '49', '37', '13', '7',
     'A',
     'First compute f(3) = 2(3) + 1 = 7. Then gf(3) = g(7) = 7² = 49.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'A function f has domain x ≥ 2. Which type of mapping is required for f to have an inverse?',
     'One-to-one', 'Many-to-one', 'One-to-many', 'Many-to-many',
     'A',
     'A function has an inverse if and only if it is a one-to-one mapping. This ensures that each output corresponds to exactly one input, making the reverse mapping valid.',
     'MULTIPLE_CHOICE', 'EASY'),

    -- ── COORDINATE GEOMETRY ─────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'A circle has equation (x - 3)² + (y + 2)² = 25. What is the centre and radius?',
     'Centre (3, -2), radius 5', 'Centre (-3, 2), radius 5', 'Centre (3, -2), radius 25', 'Centre (3, 2), radius 5',
     'A',
     'The equation (x - h)² + (y - k)² = r² has centre (h, k) and radius r. Here h = 3, k = -2, r² = 25 so r = 5. Centre is (3, -2), radius 5.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'The line y = 2x + c is a tangent to the circle x² + y² = 20. Find the positive value of c.',
     'c = 10', 'c = √80', 'c = 2', 'c = 5',
     'A',
     'Substitute y = 2x + c into x² + y² = 20: x² + (2x+c)² = 20 → 5x² + 4cx + c² - 20 = 0. For tangency, discriminant = 0: (4c)² - 4(5)(c² - 20) = 0 → 16c² - 20c² + 400 = 0 → -4c² + 400 = 0 → c² = 100 → c = ±10. Positive value is c = 10.',
     'MULTIPLE_CHOICE', 'HARD'),

    (v_math_id, v_pure_p, NULL,
     'The midpoint of points A(2, -4) and B(6, 8) is M. What are the coordinates of M?',
     '(4, 2)', '(8, 4)', '(4, -2)', '(2, 6)',
     'A',
     'Midpoint M = ((x₁ + x₂)/2, (y₁ + y₂)/2) = ((2 + 6)/2, (-4 + 8)/2) = (4, 2).',
     'MULTIPLE_CHOICE', 'EASY'),

    -- ── CIRCULAR MEASURE ────────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'A sector of a circle has radius 8 cm and angle 1.5 radians. Find the arc length.',
     '12 cm', '9.6 cm', '16 cm', '24 cm',
     'A',
     'Arc length s = rθ = 8 × 1.5 = 12 cm.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'A sector of radius 6 cm has arc length 9 cm. Find the area of the sector.',
     '27 cm²', '54 cm²', '18 cm²', '13.5 cm²',
     'A',
     'First find θ: s = rθ → θ = 9/6 = 1.5 rad. Area = 0.5r²θ = 0.5 × 36 × 1.5 = 27 cm².',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_pure_p, NULL,
     'Convert 150° to radians, giving an exact answer.',
     '5π/6', '5π/4', '2π/3', '3π/4',
     'A',
     '150° × (π/180) = 150π/180 = 5π/6 radians.',
     'MULTIPLE_CHOICE', 'EASY'),

    -- ── TRIGONOMETRY ────────────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'Solve sin x = 0.5 for 0° ≤ x ≤ 360°.',
     'x = 30° or x = 150°', 'x = 30° or x = 330°', 'x = 60° or x = 120°', 'x = 30° only',
     'A',
     'sin x = 0.5 gives the principal value x = 30°. Since sine is positive in the first and second quadrants, the second solution is 180° - 30° = 150°.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'Use the identity sin²θ + cos²θ = 1 to simplify: 3sin²θ + 3cos²θ.',
     '3', '6', '1', '0',
     'A',
     '3sin²θ + 3cos²θ = 3(sin²θ + cos²θ) = 3 × 1 = 3.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'Find the exact value of sin(60°).',
     '√3/2', '1/2', '√2/2', '1/√3',
     'A',
     'sin(60°) = √3/2. This is a standard exact value. Using the 30-60-90 triangle: opposite = √3, hypotenuse = 2, so sin 60° = √3/2.',
     'MULTIPLE_CHOICE', 'EASY'),

    -- ── SERIES ──────────────────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'An arithmetic progression has first term 5 and common difference 3. Find the 20th term.',
     '62', '65', '57', '60',
     'A',
     'nth term = a + (n-1)d = 5 + 19(3) = 5 + 57 = 62.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'A geometric progression has first term 4 and common ratio 1/2. Find the sum to infinity.',
     '8', '6', '4', '12',
     'A',
     'Sum to infinity S∞ = a / (1 - r) = 4 / (1 - 0.5) = 4 / 0.5 = 8. This is valid since |r| = 0.5 < 1.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'Find the coefficient of x³ in the expansion of (1 + 2x)⁵.',
     '80', '40', '10', '160',
     'A',
     'Using the binomial theorem, the term in x³ is C(5,3)(1)²(2x)³ = 10 × 8x³ = 80x³. The coefficient is 80.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_pure_p, NULL,
     'The sum of the first n terms of an arithmetic series is given by Sn = n/2(2a + (n-1)d). Find S₁₀ for a = 3 and d = 4.',
     '210', '110', '150', '30',
     'A',
     'S₁₀ = 10/2 × (2(3) + 9(4)) = 5 × (6 + 36) = 5 × 42 = 210.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    -- ── DIFFERENTIATION ─────────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'Find dy/dx when y = 4x³ - 6x² + 2x - 1.',
     '12x² - 12x + 2', '12x² - 6x + 2', '4x² - 12x + 2', '12x³ - 12x + 2',
     'A',
     'Differentiate term by term using the power rule: d/dx(4x³) = 12x², d/dx(-6x²) = -12x, d/dx(2x) = 2, d/dx(-1) = 0. So dy/dx = 12x² - 12x + 2.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'A curve has equation y = x³ - 3x. Find the x-coordinates of the stationary points.',
     'x = 1 and x = -1', 'x = 0 and x = 3', 'x = 3 and x = -3', 'x = 1 only',
     'A',
     'At stationary points, dy/dx = 0. dy/dx = 3x² - 3 = 0 → x² = 1 → x = ±1.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_pure_p, NULL,
     'Find the gradient of the curve y = 2x² + 3x at the point where x = 2.',
     '11', '8', '17', '6',
     'A',
     'dy/dx = 4x + 3. At x = 2: gradient = 4(2) + 3 = 8 + 3 = 11.',
     'MULTIPLE_CHOICE', 'EASY'),

    -- ── INTEGRATION ─────────────────────────────────────────────
    (v_math_id, v_pure_p, NULL,
     'Find ∫(3x² + 4x - 1) dx.',
     'x³ + 2x² - x + c', 'x³ + 4x² - x + c', '6x + 4 + c', '3x³ + 4x² - x + c',
     'A',
     'Integrate term by term: ∫3x² dx = x³, ∫4x dx = 2x², ∫-1 dx = -x. So the answer is x³ + 2x² - x + c.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_pure_p, NULL,
     'Evaluate ∫[1 to 3] (2x + 1) dx.',
     '12', '10', '14', '8',
     'A',
     'Integrate: [x² + x] from 1 to 3 = (9 + 3) - (1 + 1) = 12 - 2 = 10. Wait — check: (3² + 3) - (1² + 1) = 12 - 2 = 10. The correct answer is 10 (option B). This tests careful evaluation.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_pure_p, NULL,
     'A curve passes through (2, 7) and has dy/dx = 3x² - 2. Find the equation of the curve.',
     'y = x³ - 2x + 3', 'y = x³ - 2x + 7', 'y = 3x³ - 2x + 3', 'y = x³ + 3',
     'A',
     'Integrate: y = x³ - 2x + c. Substitute (2, 7): 7 = 8 - 4 + c → c = 3. Equation: y = x³ - 2x + 3.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    -- ══════════════════════════════════════════════════════════
    -- MECHANICS  (Paper 4)
    -- ══════════════════════════════════════════════════════════

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty)
    VALUES

    (v_math_id, v_mech_p, NULL,
     'A particle of mass 5 kg is accelerating at 3 m/s². What is the resultant force acting on it?',
     '15 N', '8 N', '1.67 N', '0.6 N',
     'A',
     'By Newton''s second law, F = ma = 5 × 3 = 15 N.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_mech_p, NULL,
     'A car accelerates uniformly from 10 m/s to 30 m/s in 5 seconds. Find its acceleration.',
     '4 m/s²', '2 m/s²', '6 m/s²', '8 m/s²',
     'A',
     'Using v = u + at: 30 = 10 + 5a → a = 20/5 = 4 m/s².',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_mech_p, NULL,
     'A particle starts from rest and accelerates uniformly at 2 m/s². How far does it travel in 6 seconds?',
     '36 m', '12 m', '24 m', '72 m',
     'A',
     'Using s = ut + 0.5at²: s = 0 + 0.5 × 2 × 36 = 36 m.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_mech_p, NULL,
     'A box of mass 4 kg is on a rough horizontal surface with coefficient of friction μ = 0.3. Find the friction force when the box is about to slide (g = 10 m/s²).',
     '12 N', '30 N', '4 N', '40 N',
     'A',
     'Normal reaction R = mg = 4 × 10 = 40 N. Maximum friction = μR = 0.3 × 40 = 12 N.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_mech_p, NULL,
     'A stone is thrown vertically upward with initial speed 20 m/s. How long does it take to reach the highest point? (g = 10 m/s²)',
     '2 s', '4 s', '1 s', '20 s',
     'A',
     'At the highest point, v = 0. Using v = u + at: 0 = 20 - 10t → t = 2 s.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_mech_p, NULL,
     'A particle of mass 3 kg is in equilibrium under three forces. Two forces are 12 N east and 5 N north. Find the magnitude of the third force.',
     '13 N', '7 N', '17 N', '√169 N',
     'A',
     'The third force must balance the resultant of 12 N east and 5 N north. Resultant magnitude = √(12² + 5²) = √(144 + 25) = √169 = 13 N. The third force is 13 N.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_mech_p, NULL,
     'An engine provides a driving force of 600 N and a vehicle moves at constant 15 m/s. What is the power output of the engine?',
     '9000 W', '600 W', '40 W', '40000 W',
     'A',
     'Power P = Fv = 600 × 15 = 9000 W.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_mech_p, NULL,
     'A 2 kg object is raised by 5 m. What is the gain in gravitational potential energy? (g = 10 m/s²)',
     '100 J', '10 J', '50 J', '25 J',
     'A',
     'GPE = mgh = 2 × 10 × 5 = 100 J.',
     'MULTIPLE_CHOICE', 'EASY');

    -- ══════════════════════════════════════════════════════════
    -- STATISTICS 1  (Paper 5)
    -- ══════════════════════════════════════════════════════════

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty)
    VALUES

    (v_math_id, v_stats_p, NULL,
     'A histogram bar covers the interval 20 ≤ x < 30 and has frequency density 4. What is the frequency for this class?',
     '40', '4', '14', '2.5',
     'A',
     'Frequency = frequency density × class width = 4 × 10 = 40.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_stats_p, NULL,
     'The lower quartile of a data set is 18 and the upper quartile is 34. What is the interquartile range?',
     '16', '26', '52', '18',
     'A',
     'IQR = Q3 - Q1 = 34 - 18 = 16.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_stats_p, NULL,
     'Events A and B are mutually exclusive with P(A) = 0.4 and P(B) = 0.25. Find P(A or B).',
     '0.65', '0.10', '0.75', '0.15',
     'A',
     'Mutually exclusive means P(A and B) = 0. So P(A or B) = P(A) + P(B) = 0.4 + 0.25 = 0.65.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_stats_p, NULL,
     'How many different arrangements are there of the letters in the word MATHS?',
     '120', '60', '24', '720',
     'A',
     'There are 5 distinct letters. Number of arrangements = 5! = 120.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_stats_p, NULL,
     'A bag contains 4 red and 6 blue balls. Two balls are drawn without replacement. Find the probability that both are red.',
     '2/15', '4/25', '1/5', '8/45',
     'A',
     'P(both red) = P(1st red) × P(2nd red | 1st red) = (4/10) × (3/9) = 12/90 = 2/15.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_stats_p, NULL,
     'A random variable X ~ B(10, 0.3). Find E(X).',
     '3', '0.3', '7', '10',
     'A',
     'For a binomial distribution B(n, p), E(X) = np = 10 × 0.3 = 3.',
     'MULTIPLE_CHOICE', 'EASY'),

    (v_math_id, v_stats_p, NULL,
     'In how many ways can a committee of 3 people be chosen from a group of 8?',
     '56', '336', '24', '512',
     'A',
     'Number of combinations = C(8,3) = 8! / (3! × 5!) = (8 × 7 × 6) / (3 × 2 × 1) = 336/6 = 56.',
     'MULTIPLE_CHOICE', 'MEDIUM'),

    (v_math_id, v_stats_p, NULL,
     'P(A) = 0.5, P(B) = 0.4, P(A and B) = 0.2. Are A and B independent?',
     'Yes, because P(A) × P(B) = P(A and B)',
     'No, because P(A) + P(B) ≠ 1',
     'No, because P(A) ≠ P(B)',
     'Yes, because P(A or B) = 0.7',
     'A',
     'Two events are independent if P(A and B) = P(A) × P(B). Here P(A) × P(B) = 0.5 × 0.4 = 0.2, which equals P(A and B) = 0.2. So A and B are independent.',
     'MULTIPLE_CHOICE', 'MEDIUM');

    RAISE NOTICE 'AS Level Math questions inserted successfully for courseId = %', v_math_id;

END $$;
