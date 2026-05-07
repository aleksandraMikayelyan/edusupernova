-- ============================================================
-- ACT Science – 100 Additional Questions (Passages + Groups)
--
-- Assumes seed_act.sql has already been run:
--   Course "ACT Science", paper "Science Test", and units
--   "Data Representation & Research Summaries" and
--   "Conflicting Viewpoints" already exist.
--
-- Creates 2 new practice papers (50 questions each) and
-- 20 passages stored in question_groups.
-- Run in: Supabase SQL editor → New query → paste → Run
-- ============================================================

DO $$
DECLARE
    v_sci_id    INTEGER;
    v_sci_p2    INTEGER;
    v_sci_p3    INTEGER;
    v_sci_unit1 INTEGER;
    v_sci_unit2 INTEGER;
    v_group_id  INTEGER;
BEGIN

    SELECT idcourse INTO v_sci_id
    FROM courses WHERE lower(coursename) = 'act science' LIMIT 1;
    IF v_sci_id IS NULL THEN RAISE EXCEPTION 'Course "ACT Science" not found.'; END IF;

    SELECT idunit INTO v_sci_unit1 FROM units
    WHERE lower(title) = 'data representation & research summaries'
      AND idcourse = v_sci_id LIMIT 1;

    SELECT idunit INTO v_sci_unit2 FROM units
    WHERE lower(title) = 'conflicting viewpoints'
      AND idcourse = v_sci_id LIMIT 1;

    IF v_sci_unit1 IS NULL THEN RAISE EXCEPTION 'Unit "Data Representation & Research Summaries" not found.'; END IF;
    IF v_sci_unit2 IS NULL THEN RAISE EXCEPTION 'Unit "Conflicting Viewpoints" not found.'; END IF;

    -- ── Practice Paper 2 ─────────────────────────────────────
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_sci_id,
        'Science Practice Test 2',
        'Each passage presents scientific information as data representations, research summaries, or conflicting viewpoints. Answer each question based solely on the information provided.',
        'MCQ', 50, 45, 2)
    RETURNING idpaper INTO v_sci_p2;

    -- ── Practice Paper 3 ─────────────────────────────────────
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (v_sci_id,
        'Science Practice Test 3',
        'Each passage presents scientific information as data representations, research summaries, or conflicting viewpoints. Answer each question based solely on the information provided.',
        'MCQ', 50, 45, 3)
    RETURNING idpaper INTO v_sci_p3;

    -- ════════════════════════════════════════════════════════
    -- PRACTICE TEST 2 — PASSAGES 1–10
    -- ════════════════════════════════════════════════════════

    -- ── Passage 1 [Data Representation]: Solubility of Salts ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Solubility of Four Salts at Varying Temperatures',
        'A student investigated the solubility of four ionic compounds in water. Solubility is expressed as grams of compound dissolved per 100 mL of water at saturation.

Table 1: Solubility (g / 100 mL H₂O)

Temperature (°C) | NaCl  | KNO₃  | NH₄Cl | KCl
0                | 35.7  | 13.3  | 29.4  | 27.6
20               | 36.0  | 31.6  | 37.2  | 34.0
40               | 36.6  | 63.9  | 45.8  | 40.0
60               | 37.3  | 106.0 | 55.2  | 45.5
80               | 38.0  | 169.0 | 65.6  | 51.1',
        1)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'At 40°C, which compound has the highest solubility?',
     'NaCl', 'KNO₃', 'NH₄Cl', 'KCl',
     'B',
     'At 40°C: NaCl = 36.6, KNO₃ = 63.9, NH₄Cl = 45.8, KCl = 40.0. KNO₃ is highest.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Which of the following best describes the effect of temperature on NaCl solubility across the range tested?',
     'NaCl solubility increases dramatically with temperature.',
     'NaCl solubility decreases as temperature increases.',
     'NaCl solubility increases only slightly, remaining relatively constant.',
     'NaCl solubility shows no measurable change.',
     'C',
     'NaCl increases from 35.7 to 38.0 g over 80°C — a very small change compared to KNO₃ (13.3 to 169.0). The increase is real but slight.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'According to Table 1, at 0°C, which compound is LEAST soluble?',
     'NaCl', 'KNO₃', 'NH₄Cl', 'KCl',
     'B',
     'At 0°C: NaCl = 35.7, KNO₃ = 13.3, NH₄Cl = 29.4, KCl = 27.6. KNO₃ is the least soluble.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'At 20°C, which two compounds have the most similar solubility values?',
     'NaCl and KNO₃', 'NaCl and NH₄Cl', 'KNO₃ and KCl', 'NH₄Cl and KCl',
     'B',
     'At 20°C: NaCl = 36.0, NH₄Cl = 37.2 — a difference of only 1.2 g. All other pairs differ by more.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on the trend in Table 1, which compound''s solubility would most likely exceed 200 g/100 mL at 100°C?',
     'NaCl', 'KNO₃', 'NH₄Cl', 'KCl',
     'B',
     'KNO₃ increases from 106.0 (60°C) to 169.0 (80°C) — an increase of 63 g per 20°C. Extrapolating to 100°C suggests approximately 230–250 g, well above 200 g. No other compound shows this rate of increase.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 2 [Data Representation]: Bacterial Growth ────
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'E. coli Population Growth Over Time',
        'A microbiologist measured the growth of Escherichia coli in a nutrient broth over 12 hours at 37°C. Samples were taken every 2 hours and the number of cells per milliliter (cells/mL) was counted.

Table 2: E. coli Population Growth

Time (h) | Cells/mL
0        | 1.0 × 10³
2        | 2.0 × 10³
4        | 8.0 × 10³
6        | 6.4 × 10⁴
8        | 5.1 × 10⁵
10       | 4.1 × 10⁶
12       | 3.3 × 10⁷

Figure 1 (described): The same data plotted on a logarithmic scale (log₁₀ cells/mL vs. time). Data points form a nearly straight line from hours 2 to 12, with a slight flattening between hours 0 and 2 (lag phase).',
        2)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'According to Table 2, during which 2-hour interval did the bacterial population increase by the greatest absolute number of cells?',
     '0 to 2 hours', '4 to 6 hours', '8 to 10 hours', '10 to 12 hours',
     'D',
     'The absolute increases: 0–2: ~1×10³; 4–6: ~5.6×10⁴; 8–10: ~3.6×10⁶; 10–12: ~2.9×10⁷. The 10–12 hour interval shows the largest absolute increase.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'A straight line on a log-scale graph (Figure 1) between hours 2 and 12 indicates that the bacterial population is growing:',
     'At a constant, fixed number of cells per hour',
     'Exponentially',
     'At a steadily decreasing rate',
     'Linearly',
     'B',
     'A straight line on a logarithmic scale is the signature of exponential growth — the population multiplies by a constant factor per unit time.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Table 2, approximately how many times larger was the bacterial population at hour 12 compared to hour 0?',
     '330 times', '3,300 times', '33,000 times', '330,000 times',
     'C',
     '3.3 × 10⁷ ÷ 1.0 × 10³ = 3.3 × 10⁴ = 33,000 times larger.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'The slight flattening of the curve (lag phase) between hours 0 and 2 most likely indicates that the bacteria were:',
     'Dying due to the temperature of the broth',
     'Adapting to their new environment before beginning active reproduction',
     'Consuming all available nutrients in the first 2 hours',
     'Dividing at their maximum possible rate immediately',
     'B',
     'The lag phase occurs when bacteria are newly introduced to a medium. Cells synthesize necessary enzymes and adjust to conditions before beginning rapid division.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'A student wants to estimate the population at hour 11. Based on Table 2, the most reasonable approach is to:',
     'Use the hour 10 value directly, since populations rarely change in 1 hour',
     'Average the hour 10 and hour 12 values',
     'Multiply the hour 12 value by 2',
     'Assume the population reached its maximum by hour 10',
     'B',
     'Interpolating between adjacent known data points (averaging 4.1 × 10⁶ and 3.3 × 10⁷) gives a reasonable estimate for the intermediate time point.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 3 [Data Representation]: CO₂ and Temperature ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Atmospheric CO₂ Concentration and Global Temperature Anomaly',
        'Scientists have compiled global climate records from instrumental data and ice core analyses spanning 1880 to 2023.

Figure 1 (described): Global mean surface temperature anomaly (°C relative to 1951–1980 average) from 1880 to 2023. Values fluctuated near −0.2°C from 1880 through approximately 1960, then rose steadily to approximately +0.6°C by 1990 and +1.2°C by 2023.

Figure 2 (described): Atmospheric CO₂ concentration (ppm) measured at Mauna Loa Observatory from 1958 to 2023. The line rises from ~315 ppm in 1958 to ~422 ppm in 2023, with a regular seasonal sawtooth pattern superimposed on the upward trend.

Table 3: Decadal Averages

Decade | Temp Anomaly (°C) | CO₂ (ppm)
1880s  | −0.19             | 291
1920s  | −0.08             | 305
1960s  | +0.01             | 320
1990s  | +0.31             | 362
2010s  | +0.87             | 398',
        3)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'According to Table 3, between which two consecutive decades shown did the temperature anomaly increase by the greatest amount?',
     '1880s to 1920s', '1920s to 1960s', '1960s to 1990s', '1990s to 2010s',
     'D',
     'Changes: 1880s→1920s: 0.11°C; 1920s→1960s: 0.09°C; 1960s→1990s: 0.30°C; 1990s→2010s: 0.56°C. The largest increase is from 1990s to 2010s.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Table 3, what is the general relationship between CO₂ concentration and global temperature anomaly across the decades shown?',
     'As CO₂ increases, temperature anomaly decreases.',
     'As CO₂ increases, temperature anomaly also increases.',
     'CO₂ and temperature anomaly show no consistent relationship.',
     'Temperature anomaly increases while CO₂ remains stable.',
     'B',
     'In every decade shown, both CO₂ and temperature anomaly rise together — a consistent positive association.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'The seasonal sawtooth pattern visible in Figure 2 (CO₂ rising and falling each year within the overall trend) is most likely caused by:',
     'Volcanic eruptions releasing CO₂ in regular cycles',
     'Industrial activity concentrated in northern hemisphere winters',
     'The seasonal cycle of plant growth in spring/summer absorbing CO₂ and decomposition in fall/winter releasing it',
     'Ocean currents releasing CO₂ randomly throughout the year',
     'C',
     'Northern hemisphere vegetation absorbs large amounts of CO₂ during the growing season (spring–summer) and releases it during dormancy (fall–winter), producing the regular annual oscillation.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'A scientist claims that the rate of CO₂ increase has accelerated since the early 20th century. Which data from Table 3 best supports this?',
     'CO₂ values in all decades are above 280 ppm.',
     'The increase in CO₂ per decade has grown larger over time: from ~3–4 ppm/decade early on to ~18 ppm/decade recently.',
     'Temperature and CO₂ always move in the same direction.',
     'CO₂ in 2023 was higher than in 1880.',
     'B',
     '1880s→1920s: 14 ppm over 40 years (~3.5 ppm/decade); 1990s→2010s: 36 ppm over 20 years (~18 ppm/decade). The per-decade rate has clearly increased.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Figure 1, in approximately which decade did the global temperature anomaly first consistently remain above 0°C?',
     '1940s', '1960s', '1980s', '2000s',
     'C',
     'Figure 1 describes fluctuations near or below 0°C through about 1960, with a steady rise thereafter crossing above 0°C and staying there around the late 1970s–1980s.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 4 [Research Summaries]: Fertilizer & Plant Growth ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Effect of Fertilizer Type and Concentration on Tomato Plant Growth',
        'A biology class investigated how fertilizer type and concentration affect the growth of tomato seedlings over 6 weeks. All seedlings began at 5 cm height. Conditions not being tested (soil type, water volume, light, temperature) were held constant.

Experiment 1: 40 seedlings divided into 4 groups (n=10 each).
  Group 1: No fertilizer (control)         → avg. height: 18.2 cm
  Group 2: Nitrogen-only fertilizer (N)    → avg. height: 31.5 cm
  Group 3: Phosphorus-only fertilizer (P)  → avg. height: 22.1 cm
  Group 4: Potassium-only fertilizer (K)   → avg. height: 19.8 cm

Experiment 2: Same as Experiment 1, with an added Group 5 receiving complete NPK fertilizer (all three nutrients combined).
  Group 5: NPK fertilizer                  → avg. height: 41.3 cm

Experiment 3: 30 seedlings divided into 3 groups (n=10 each). All groups received NPK fertilizer at different concentrations.
  Low concentration (0.5 g/L)              → avg. height: 28.7 cm
  Medium concentration (1.0 g/L)           → avg. height: 41.3 cm
  High concentration (2.0 g/L)             → avg. height: 38.9 cm',
        4)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'In Experiment 1, what was the independent variable?',
     'Average plant height after 6 weeks',
     'The type of fertilizer applied to each group',
     'The volume of water given to each plant',
     'The number of weeks the experiment ran',
     'B',
     'The independent variable is the factor deliberately changed by the researcher. Here, the researchers varied the type of fertilizer while holding all other conditions constant.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Experiment 1, which single nutrient had the greatest positive effect on plant height compared to the control?',
     'Phosphorus (P)', 'Potassium (K)', 'Nitrogen (N)', 'No fertilizer showed a significant effect.',
     'C',
     'Nitrogen group: 31.5 cm vs. control: 18.2 cm — an increase of 13.3 cm. Phosphorus added 3.9 cm and potassium added 1.6 cm. Nitrogen had the greatest effect.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'What was the purpose of the control group (Group 1, no fertilizer) in Experiment 1?',
     'To show that plants cannot survive without fertilizer',
     'To provide a baseline for comparing the effect of each fertilizer type',
     'To test whether potassium alone is sufficient for plant growth',
     'To determine the maximum height tomato plants can reach naturally',
     'B',
     'A control group establishes baseline conditions so that any differences in the experimental groups can be attributed to the manipulated variable (fertilizer type).',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Comparing the NPK group (41.3 cm) in Experiment 2 to the nitrogen-only group (31.5 cm) in Experiment 1, which conclusion is best supported?',
     'Phosphorus and potassium inhibit growth when combined with nitrogen.',
     'The combination of all three nutrients produces greater growth than any single nutrient alone.',
     'NPK fertilizer is less effective than nitrogen-only fertilizer.',
     'Results of Experiments 1 and 2 are inconsistent with each other.',
     'B',
     'NPK (41.3 cm) exceeded the best single-nutrient group (N: 31.5 cm), indicating that the combination of nutrients produced greater growth than any nutrient alone.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'A student hypothesizes that increasing NPK fertilizer concentration always increases plant height. Which result from Experiment 3 is most inconsistent with this hypothesis?',
     'Low-concentration plants grew shorter than medium-concentration plants.',
     'Medium and high concentration plants both grew taller than the control from Experiment 1.',
     'High-concentration plants (38.9 cm) grew shorter than medium-concentration plants (41.3 cm).',
     'All three concentration groups exceeded the control.',
     'C',
     'The student''s hypothesis predicts growth always increases with concentration. But high concentration (2.0 g/L) produced less growth than medium (1.0 g/L), directly contradicting the "always increases" claim.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Passage 5 [Research Summaries]: Heat Transfer in Metals ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Heat Conduction in Metal Rods',
        'A student investigated how different metals conduct heat. Rods of identical dimensions (30 cm long, 1 cm diameter) made of copper (Cu), aluminum (Al), and steel (Fe) were tested. One end of each rod was placed in boiling water (100°C); the temperature at the opposite end was recorded every 30 seconds.

Experiment 1: Rods tested individually in open air.

Time (s) | Temp Cu (°C) | Temp Al (°C) | Temp Fe (°C)
0        | 25.0         | 25.0         | 25.0
30       | 34.5         | 31.2         | 26.3
60       | 48.9         | 43.6         | 27.8
120      | 73.5         | 65.2         | 31.4
180      | 87.2         | 78.4         | 34.9
300      | 96.4         | 90.8         | 40.2

Experiment 2: Same procedure, but rod length doubled to 60 cm. All temperatures at the far end were lower at each time point compared to Experiment 1.

Experiment 3: Rods wrapped in insulating foam. Temperatures at the far end were significantly lower for all metals at every time point compared to Experiments 1 and 2.',
        5)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Experiment 1, which metal rod conducted heat most rapidly?',
     'Copper', 'Aluminum', 'Steel', 'All metals conducted heat at the same rate.',
     'A',
     'At every time point, copper reached the highest temperature at the far end (e.g., 96.4°C at 300 s vs. Al: 90.8°C and Fe: 40.2°C), indicating it conducts heat most rapidly.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'In Experiment 1, what was the independent variable?',
     'The temperature measured at the far end of the rod',
     'The type of metal used for each rod',
     'The length of each rod',
     'The temperature of the boiling water',
     'B',
     'The researcher deliberately varied the type of metal while keeping rod dimensions, water temperature, and initial temperature constant.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Why were rod length and diameter kept constant across all metals in Experiments 1 and 2?',
     'To ensure any difference in heat transfer was due to the type of metal, not rod dimensions',
     'To demonstrate that longer rods conduct heat more quickly',
     'To make the rods easier to insulate in Experiment 3',
     'To eliminate the effect of boiling water temperature on results',
     'A',
     'Controlling rod dimensions isolates the effect of material type (thermal conductivity) as the only variable responsible for differences in heat transfer.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Comparing Experiments 1 and 2, what can be concluded about rod length and heat transfer rate?',
     'Longer rods transfer heat more efficiently.',
     'Heat transfer rate is unaffected by rod length.',
     'Longer rods result in lower temperatures at the far end at each time point.',
     'Length only affects steel''s heat transfer rate.',
     'C',
     'Experiment 2 (60 cm rods) produced lower far-end temperatures at each time point than Experiment 1 (30 cm rods), indicating that greater length reduces the rate of heat transfer to the far end.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'The results of Experiment 3 compared to Experiment 1 suggest that insulating foam:',
     'Increases the rate of heat transfer through the rod',
     'Has no measurable effect on heat transfer',
     'Reduces heat loss to the surrounding air, which paradoxically makes far-end temperatures higher',
     'Reduces the rate at which heat reaches the far end of the rod',
     'D',
     'Experiment 3 shows significantly lower far-end temperatures compared to Experiment 1, even though the rods are wrapped. The insulation slows heat transmission — consistent with insulating materials impeding conduction.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Passage 6 [Research Summaries]: Enzyme Activity vs. pH ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Effect of pH and Temperature on Digestive Enzyme Activity',
        'A biochemist measured the activity of three digestive enzymes—pepsin, amylase, and lipase—at varying pH values. Activity is expressed as a percentage of each enzyme''s maximum recorded activity.

Experiment 1: Each enzyme tested at seven pH values at 37°C with identical substrate concentrations.

pH | Pepsin (%) | Amylase (%) | Lipase (%)
2  | 95         | 5           | 10
4  | 65         | 12          | 25
6  | 20         | 58          | 65
7  | 8          | 82          | 80
8  | 5          | 95          | 78
9  | 2          | 65          | 88
10 | 1          | 35          | 42

Note: Pepsin is secreted in the stomach (pH ~2); amylase functions in the mouth and small intestine (pH 6–8); lipase functions in the small intestine (pH 7–9).

Experiment 2: All three enzymes were tested at pH 8 across temperatures from 10°C to 70°C. Each enzyme showed maximum activity near 37°C; activity dropped sharply above 50°C, approaching zero by 60–70°C.',
        6)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Experiment 1, which enzyme has its highest activity at pH 2?',
     'Amylase', 'Lipase', 'Pepsin', 'All three enzymes show equal activity at pH 2.',
     'C',
     'At pH 2: Pepsin = 95%, Amylase = 5%, Lipase = 10%. Pepsin is clearly most active at pH 2, consistent with its function in the acidic stomach.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'According to Experiment 1, at pH 8, which enzyme is most active?',
     'Pepsin', 'Amylase', 'Lipase', 'All three are equally active at pH 8.',
     'B',
     'At pH 8: Pepsin = 5%, Amylase = 95%, Lipase = 78%. Amylase has the highest activity at pH 8.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'In Experiment 1, what was the independent variable?',
     'Enzyme activity (% of maximum)',
     'Substrate concentration',
     'Temperature',
     'pH of the solution',
     'D',
     'The researcher varied the pH across trials while holding temperature and substrate concentration constant. pH is therefore the independent variable.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on the note about enzyme locations in the body, which enzyme would be most useful for digesting fats in the small intestine at pH 8?',
     'Pepsin, because it has high activity at low pH',
     'Amylase, because it has 95% activity at pH 8',
     'Lipase, because it functions in the small intestine and retains high activity at pH 8',
     'Pepsin and amylase equally, since both are active at pH 8',
     'C',
     'Lipase functions specifically in the small intestine (pH 7–9) and digests fats (lipids). At pH 8 it shows 78% activity. Pepsin digests proteins in the stomach, not fats. Amylase digests carbohydrates.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'The finding from Experiment 2 that all three enzymes lose nearly all activity above 50°C is most likely because:',
     'High temperatures increase substrate availability, overwhelming the enzymes',
     'Enzymes are used up (consumed) as reaction products accumulate',
     'High temperatures cause the enzymes to denature, altering their three-dimensional shape and active site',
     'Temperatures above 50°C increase pH, reducing enzyme activity indirectly',
     'C',
     'Enzymes are proteins whose function depends on their specific 3-D shape. Excessive heat disrupts hydrogen bonds and other interactions maintaining that shape (denaturation), destroying the active site.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 7 [Research Summaries]: Pendulum Period ──────
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Factors Affecting the Period of a Simple Pendulum',
        'A physics student investigated what factors affect the period (T) of a simple pendulum — the time for one complete back-and-forth swing.

Experiment 1: Length (L) varied; bob mass = 100 g; amplitude = 10°.

L (cm) | T (s)
25     | 1.00
50     | 1.42
100    | 2.00
200    | 2.83
400    | 4.00

Experiment 2: Bob mass varied (50 g, 100 g, 200 g, 500 g); L = 100 cm; amplitude = 10°.
Result: T = 2.00 s for all four masses.

Experiment 3: Amplitude varied (5°, 10°, 20°, 30°, 45°); L = 100 cm; mass = 100 g.
Results: T ≈ 2.00 s for amplitudes 5°–30°; T ≈ 2.07 s at 45°.',
        7)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Experiment 1, what is the effect of increasing pendulum length on the period?',
     'Period decreases as length increases.',
     'Period remains constant regardless of length.',
     'Period increases as length increases.',
     'Period first increases then decreases.',
     'C',
     'From the table: as L increases from 25 to 400 cm, T increases from 1.00 to 4.00 s — a consistent increase.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'In Experiment 1, what was the dependent variable?',
     'The length of the pendulum',
     'The mass of the pendulum bob',
     'The amplitude of the swing',
     'The period of the pendulum',
     'D',
     'The dependent variable is the one measured as an outcome. The researcher measured the period (T) while varying the length.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Experiment 2, which conclusion about bob mass is best supported?',
     'Heavier bobs swing faster, producing shorter periods.',
     'Bob mass has no significant effect on the period of a pendulum.',
     'The period increases proportionally with bob mass.',
     'Only bobs heavier than 200 g affect the period.',
     'B',
     'T = 2.00 s for all four masses (50 g, 100 g, 200 g, 500 g). Mass has no measurable effect on period.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Looking at Experiment 1 data: when the pendulum length is quadrupled from 25 cm to 100 cm, the period changes from 1.00 s to 2.00 s. This pattern suggests the period is proportional to:',
     'The length', 'The square root of the length', 'The square of the length', 'The cube root of the length',
     'B',
     'Quadrupling length (25→100) doubles the period (1.00→2.00 s). This is consistent with T ∝ √L, since √4 = 2.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Based on Experiment 3, for which range of amplitudes does the period remain essentially constant?',
     '5° to 45°', '5° to 30°', '10° to 45°', 'Only at exactly 10°',
     'B',
     'T ≈ 2.00 s for amplitudes 5°–30°, with only a slight deviation (2.07 s) at 45°. Below 30° the period is effectively independent of amplitude.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 8 [Research Summaries]: Viscosity and Temperature ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Effect of Temperature on the Viscosity of Four Liquids',
        'A chemist measured the viscosity (resistance to flow, in centipoise, cP) of four liquids at five temperatures using a calibrated viscometer. Each measurement was repeated three times; standard deviation was < 2% of the mean for all trials.

Table: Viscosity (cP) at Different Temperatures

Temperature (°C) | Water  | Ethanol | Vegetable Oil | Glycerol
0                | 1.79   | 1.77    | 65.0          | 12,100
20               | 1.00   | 1.19    | 43.0          | 1,412
40               | 0.65   | 0.91    | 28.0          | 233
60               | 0.47   | 0.72    | 19.0          | 53
80               | 0.35   | 0.58    | 13.0          | 17',
        8)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit1,
     'At 20°C, which liquid has the highest viscosity?',
     'Water', 'Ethanol', 'Vegetable Oil', 'Glycerol',
     'D',
     'At 20°C: Water = 1.00, Ethanol = 1.19, Vegetable Oil = 43.0, Glycerol = 1,412 cP. Glycerol is by far the most viscous.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'Which of the following best describes the effect of increasing temperature on the viscosity of all four liquids tested?',
     'Viscosity increases as temperature increases.',
     'Viscosity decreases as temperature increases.',
     'Viscosity is unaffected by temperature changes.',
     'Viscosity first increases then decreases with temperature.',
     'B',
     'For all four liquids, viscosity values decrease at every step from 0°C to 80°C — a consistent inverse relationship.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'At 80°C, which two liquids have the most similar viscosity values?',
     'Water and ethanol', 'Ethanol and vegetable oil', 'Glycerol and vegetable oil', 'Water and glycerol',
     'C',
     'At 80°C: Water = 0.35, Ethanol = 0.58, Vegetable Oil = 13.0, Glycerol = 17 cP. Glycerol (17) and vegetable oil (13) are closest to each other.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'A student claims water''s viscosity decreases by approximately 44% from 0°C to 20°C. Based on the table, is this claim supported?',
     'No — the decrease is less than 10%.',
     'Yes — the viscosity drops from 1.79 to 1.00 cP, a decrease of about 44%.',
     'No — the decrease is greater than 80%.',
     'Yes — water''s viscosity is exactly halved from 0°C to 20°C.',
     'B',
     '(1.79 − 1.00) / 1.79 × 100 ≈ 44%. The claim is well supported by the data.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit1,
     'The fact that each measurement was repeated three times with a standard deviation less than 2% of the mean indicates that:',
     'The viscometer was measuring a different liquid each time.',
     'Temperature control was not maintained during the experiment.',
     'The viscosity measurements are highly consistent and reproducible.',
     'The results cannot be compared across different liquids.',
     'C',
     'Low standard deviation across repeated trials is a measure of precision (reproducibility). It indicates the measurement method is reliable and the results are consistent.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- ── Passage 9 [Conflicting Viewpoints]: Coal Formation ───
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Origin of High-Latitude Coal Deposits: Two Hypotheses',
        'Coal deposits are found today in Antarctica and the Arctic. Two scientists disagree about how coal formed in these polar regions.

Scientist 1 (Plate Tectonics Hypothesis): Polar coal deposits formed from tropical forests that thrived when those landmasses were situated near the equator, hundreds of millions of years ago. According to plate tectonics, continents drift slowly over geological time. Antarctica was once part of the supercontinent Gondwana, positioned in temperate or tropical latitudes. Dense forests grew, died, and accumulated as peat, which heat and pressure transformed into coal over millions of years. Evidence includes fossilized tropical plant species — such as Glossopteris — found in Antarctic coal. Glossopteris is known from warm-climate fossil assemblages worldwide and is considered a marker of tropical or subtropical Gondwana flora.

Scientist 2 (Polar Forest Hypothesis): High-latitude coal deposits do not require those landmasses to have been in tropical positions. Some coal-forming plants are adapted to cool, high-latitude environments with extreme seasonal variation in sunlight. During the Carboniferous period, global temperatures were significantly warmer than today, potentially allowing "polar forests" — dense, seasonally adapted woodlands — to form coal at high latitudes. Modern genetic studies of living Glossopteris relatives suggest adaptation to low-light, seasonal environments rather than consistent tropical sunlight. The presence of Glossopteris therefore supports a cool-adapted polar flora, not necessarily tropical origin.',
        9)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit2,
     'According to Scientist 1, what is the primary reason coal deposits exist in Antarctica today?',
     'Antarctica was once covered by warm ocean currents that enabled forest growth.',
     'Antarctica was once located at tropical latitudes and hosted dense forests.',
     'Coal-forming plants are adapted to grow in polar environments.',
     'Global temperatures were higher than today during the Carboniferous period.',
     'B',
     'Scientist 1 argues that plate tectonics moved Antarctica from tropical latitudes — where forests formed the coal — to its current polar position.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Both Scientist 1 and Scientist 2 would most likely agree that:',
     'Antarctic coal deposits formed exclusively from tropical plants.',
     'Plate tectonics is responsible for the current position of Antarctica.',
     'Plant material accumulated in Antarctica at some point in geological history and was transformed into coal.',
     'Glossopteris could only survive in tropical climates.',
     'C',
     'Both scientists accept that coal exists in Antarctica and was formed from plants — they disagree only on what kind of plants grew there and under what climate conditions.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Which piece of evidence would most strongly support Scientist 1''s hypothesis?',
     'Genetic evidence showing Glossopteris relatives are adapted to low-light polar conditions',
     'Paleomagnetic rock records confirming Antarctica was located at tropical latitudes when the coal-forming forests grew',
     'Studies showing that modern polar forests produce coal at comparable rates to tropical forests',
     'Evidence that global temperatures during the Carboniferous were only slightly warmer than today',
     'B',
     'Scientist 1''s hypothesis rests on Antarctica having been in tropical latitudes. Paleomagnetic evidence (the record of ancient magnetic pole positions locked in rocks) directly confirms or denies a continent''s past latitude.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Scientist 2 uses the Glossopteris fossil evidence differently from Scientist 1. According to Scientist 2, Glossopteris fossils suggest:',
     'Glossopteris required warm, consistent tropical sunlight and confirms tropical origin.',
     'Glossopteris is unrelated to any living plant species.',
     'Glossopteris was adapted to the seasonal, low-light conditions typical of polar regions.',
     'Glossopteris fossils are not found in Antarctic coal deposits.',
     'C',
     'Scientist 2 argues modern genetic studies of Glossopteris relatives indicate adaptation to low-light, seasonal environments — reinterpreting the same fossil evidence to support a polar-forest origin.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Which finding would most weaken Scientist 2''s hypothesis?',
     'Evidence that plate tectonics was active during the Carboniferous period',
     'Genetic evidence showing that all Glossopteris relatives require warm temperatures and abundant, consistent sunlight to complete their life cycle',
     'Discovery of additional coal deposits at high latitudes in the Arctic',
     'Fossil evidence showing that some Carboniferous forests existed at temperate latitudes',
     'B',
     'Scientist 2''s hypothesis depends on Glossopteris (and similar plants) being capable of thriving in low-light, seasonal polar conditions. If genetic evidence showed they require warm, consistent sunlight, the "polar forest" hypothesis collapses.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Passage 10 [Conflicting Viewpoints]: Dinosaur Thermoregulation ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p2,
        'Dinosaur Thermoregulation: Endothermy vs. Mesothermy',
        'Scientists disagree about whether non-avian dinosaurs were endothermic (warm-blooded) like modern birds and mammals, or mesothermic (intermediate between warm- and cold-blooded).

Scientist 1 (Endothermy): Dinosaurs generated and regulated internal body heat. Evidence: (1) Bone microstructure in many species shows rapid, sustained growth rings consistent with high metabolic rates, similar to modern birds — not the seasonal slow-growth patterns of living reptiles. (2) Predator-to-prey biomass ratios in fossil assemblages resemble those of warm-blooded ecosystems. (3) Dinosaur fossils found at polar latitudes indicate survival in cold environments where ectotherms would struggle. (4) Feathers discovered on many theropod species provide insulation, a hallmark of animals that generate and retain body heat.

Scientist 2 (Mesothermy): Dinosaurs occupied an intermediate metabolic state — neither fully endothermic nor fully ectothermic. Large body mass alone could provide "gigantothermy": the thermal inertia of a massive body maintains stable temperature without the high metabolic cost of full endothermy. Growth rate evidence is ambiguous; some modern reptiles also show rapid growth under favourable conditions. The predator-to-prey ratios observed fall within ranges consistent with mesothermic metabolism. Smaller dinosaurs may have varied in their thermal regulation, while larger species relied on mass for stability.',
        10)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Scientist 1 cites polar dinosaur fossils as evidence for endothermy primarily because:',
     'Cold-blooded animals cannot survive in environments with cold winters.',
     'Polar regions are the only places where dinosaur fossils are well-preserved.',
     'Warm-blooded animals always migrate toward polar regions.',
     'Fossil evidence from polar regions is more reliable than from tropical regions.',
     'A',
     'Ectotherms (cold-blooded animals) depend on external heat sources and typically cannot remain active or survive extended cold. Dinosaur presence at polar latitudes therefore implies internal heat generation.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Both scientists would most likely agree that:',
     'All dinosaurs had metabolic rates identical to modern birds.',
     'Dinosaur body temperatures were constant year-round.',
     'Large body mass may have contributed to thermal stability in some dinosaurs.',
     'The question of dinosaur thermoregulation has been fully resolved.',
     'C',
     'Scientist 2 explicitly argues that large mass provides gigantothermy. Scientist 1 does not dispute that mass helps — the disagreement is whether full endothermy was also present. Both can agree mass was a factor.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Scientist 1 mentions predator-to-prey biomass ratios as evidence for endothermy. Scientist 2 would most likely respond that:',
     'Predators in the fossil record were never endothermic.',
     'Those ratios do not exist and cannot be measured from fossils.',
     'The observed predator-to-prey ratios fall within ranges also consistent with mesothermic metabolism.',
     'Predator-to-prey ratios are only meaningful in modern ecosystems.',
     'C',
     'The passage explicitly states Scientist 2''s position: "The predator-to-prey ratios observed fall within ranges consistent with mesothermic metabolism" — directly addressing and reinterpreting this evidence.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'Which of the following findings would most strengthen Scientist 2''s hypothesis over Scientist 1''s?',
     'Discovery of feathers on additional small theropod species',
     'Evidence that small dinosaurs survived in Arctic environments alongside large dinosaurs',
     'Measurements showing large dinosaurs had metabolic rates significantly lower than modern birds of similar body mass',
     'Growth rate analysis showing some small dinosaurs grew as fast as modern birds',
     'C',
     'If large dinosaurs had very low metabolic rates compared to birds, full endothermy would be less supported. Mesothermy — combining mass-based stability with modest metabolic output — would then better fit the data.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id),

    (v_sci_id, v_sci_p2, v_sci_unit2,
     'A new study finds that small feathered dinosaurs (< 5 kg) had growth rates twice as fast as any known living reptile but only half the rate of modern birds of equivalent size. This evidence most directly supports:',
     'Scientist 1''s view that all dinosaurs were fully endothermic like modern birds.',
     'The hypothesis that all dinosaurs were fully ectothermic.',
     'Scientist 2''s view that dinosaurs occupied an intermediate metabolic state between reptiles and birds.',
     'Neither scientist, since growth rate is unrelated to thermal regulation.',
     'C',
     'Growth rates intermediate between reptiles (slower) and birds (faster) are exactly the pattern predicted by mesothermy — an intermediate metabolic state — directly supporting Scientist 2.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ════════════════════════════════════════════════════════
    -- PRACTICE TEST 3 — PASSAGES 11–20
    -- ════════════════════════════════════════════════════════

    -- ── Passage 11 [Data Representation]: Radioactive Decay ──
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Radioactive Decay and Half-Lives',
        'Radioactive isotopes decay at characteristic rates expressed as half-lives (t½) — the time required for half of a sample to decay to a daughter product.

Figure 1 (described): A graph showing the percentage of original sample remaining (y-axis, 0–100%) versus time in half-lives (x-axis, 0–5). All isotopes follow the same curve: 100% at 0 half-lives, 50% at 1, 25% at 2, 12.5% at 3, 6.25% at 4, 3.125% at 5.

Table 1: Half-Lives of Selected Isotopes

Isotope       | Half-life
Carbon-14     | 5,730 years
Uranium-238   | 4.47 billion years
Iodine-131    | 8.0 days
Potassium-40  | 1.25 billion years',
        1)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Figure 1, after 3 half-lives, what percentage of the original radioactive sample remains?',
     '25%', '12.5%', '6.25%', '3.125%',
     'B',
     'Each half-life reduces the sample by half: 100% → 50% → 25% → 12.5%. After 3 half-lives, 12.5% remains.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A medical technician receives a sample of Iodine-131. After how many days will approximately 25% of the original amount remain?',
     '8 days', '16 days', '24 days', '32 days',
     'B',
     '25% remaining = 2 half-lives. Iodine-131 half-life = 8 days. 2 × 8 = 16 days.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A geologist wants to date a rock estimated to be about 2 billion years old. Based on Table 1, which isotope would be LEAST suitable because its half-life is too short?',
     'Carbon-14', 'Uranium-238', 'Potassium-40', 'Both Uranium-238 and Potassium-40',
     'A',
     'Carbon-14 has a half-life of 5,730 years. After 2 billion years, essentially no C-14 would remain — far too many half-lives would have elapsed for any measurable amount to be detectable.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'In Figure 1, all four isotopes follow the same decay curve when time is expressed in half-lives. What does this indicate?',
     'All four isotopes have identical half-lives.',
     'The fraction of sample remaining after a given number of half-lives is the same regardless of which isotope is used.',
     'Radioactive decay is a linear process.',
     'Isotopes with shorter half-lives always retain a higher percentage of the original sample.',
     'B',
     'Expressing time in units of half-lives normalises the decay curve. The mathematics of exponential decay means every isotope loses the same fraction per half-life, giving an identical curve shape.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A Carbon-14 sample contains 1,000 atoms at time zero. After 17,190 years (3 half-lives), approximately how many Carbon-14 atoms remain?',
     '500', '250', '125', '63',
     'C',
     '1,000 × (1/2)³ = 1,000 / 8 = 125 atoms.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 12 [Data Representation]: Seismic Waves ─────
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Seismic Wave Travel Times and Earth''s Interior',
        'Seismologists use seismic body waves to study Earth''s internal structure. P-waves (compressional) travel through solids and liquids; S-waves (shear) travel only through solids.

Table 2: Travel Times from Earthquake Epicenter

Distance (°) | P-wave time (min) | S-wave time (min)
0            | 0.0               | 0.0
20           | 4.4               | 7.9
40           | 7.5               | 13.7
60           | 10.0              | 18.3
80           | 12.1              | 22.1
100          | 14.2              | —
120          | 16.1              | —
140          | 17.8              | —

Note: S-waves are absent (—) beyond approximately 105° from the epicenter, creating an "S-wave shadow zone." A P-wave shadow zone also exists between approximately 105° and 145°, though weak P-wave arrivals via diffraction are still detected.',
        2)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Table 2, at 60° from the epicenter, how much longer does an S-wave take to arrive compared to a P-wave?',
     '4.4 minutes', '8.3 minutes', '10.0 minutes', '18.3 minutes',
     'B',
     'S-wave time at 60° = 18.3 min; P-wave time = 10.0 min. Difference = 18.3 − 10.0 = 8.3 minutes.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A seismograph records a P-wave arriving 7.5 minutes after an earthquake. Based on Table 2, the station is approximately how far from the epicenter?',
     '20°', '40°', '60°', '80°',
     'B',
     'Table 2 shows P-wave travel time = 7.5 min at 40°.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'The S-wave shadow zone (no S-waves detected beyond ~105°) is best explained by which property of Earth''s outer core?',
     'The outer core is solid and reflects S-waves.',
     'The outer core is liquid, and S-waves cannot propagate through liquids.',
     'The outer core absorbs all seismic energy completely.',
     'The outer core causes S-waves to travel faster than P-waves.',
     'B',
     'S-waves are shear waves that require a rigid medium. They cannot travel through liquids. The S-wave shadow zone is primary evidence that Earth''s outer core is in a liquid (molten) state.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Table 2, what is the general relationship between angular distance from the epicenter and P-wave travel time?',
     'P-wave travel time decreases as distance increases.',
     'P-wave travel time is constant regardless of distance.',
     'P-wave travel time increases as distance increases.',
     'P-wave travel time increases then decreases.',
     'C',
     'P-wave travel times increase steadily from 0 min at 0° to 17.8 min at 140°, a consistent positive relationship.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A scientist hypothesizes that Earth''s inner core is solid. Which observation would provide the most direct seismic evidence for this hypothesis?',
     'Detection of P-waves passing through the center of the Earth at all distances',
     'Detection of S-waves traversing the inner core at velocities consistent with a solid medium',
     'A longer P-wave shadow zone than currently observed',
     'Complete absence of any waves at distances beyond 120°',
     'B',
     'S-waves can only travel through solid material. Detecting S-waves that have passed through the inner core would be direct evidence of its solid state — this is in fact the basis for our current understanding.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Passage 13 [Research Summaries]: Reaction Rate ───────
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Effect of Temperature and Concentration on a Chemical Reaction Rate',
        'A student investigated the rate of reaction between sodium thiosulfate solution (Na₂S₂O₃) and hydrochloric acid (HCl). The reaction produces a yellow sulfur precipitate that makes the solution cloudy. A cross drawn on paper beneath the beaker became invisible once sufficient precipitate formed; the time to invisibility was recorded as a measure of reaction rate (rate = 1/time).

Experiment 1: Na₂S₂O₃ = 0.1 M, HCl = 2 M (constant). Temperature varied.

Temp (°C) | Time to invisibility (s) | Rate (s⁻¹)
10        | 214                      | 0.00467
20        | 111                      | 0.00901
30        | 58                       | 0.01724
40        | 31                       | 0.03226
50        | 17                       | 0.05882

Experiment 2: Temperature = 30°C, HCl = 2 M (constant). Na₂S₂O₃ concentration varied.

Na₂S₂O₃ (M) | Time to invisibility (s)
0.05         | 116
0.10         | 58
0.15         | 39
0.20         | 29',
        3)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 1, what is the relationship between temperature and the rate of the Na₂S₂O₃–HCl reaction?',
     'Reaction rate decreases as temperature increases.',
     'Reaction rate is unaffected by temperature.',
     'Reaction rate increases as temperature increases.',
     'Reaction rate first increases then decreases with temperature.',
     'C',
     'As temperature rises from 10°C to 50°C, the time to invisibility decreases from 214 s to 17 s, meaning the reaction rate (1/time) increases consistently.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'In Experiment 1, which variables were held constant (controlled)?',
     'Temperature and time to invisibility',
     'Na₂S₂O₃ concentration, HCl concentration, and solution volumes',
     'Temperature only',
     'Na₂S₂O₃ concentration and temperature',
     'B',
     'In Experiment 1 only temperature was varied; Na₂S₂O₃ concentration (0.1 M), HCl concentration (2 M), and volumes were all kept constant.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 1, approximately how much faster does the reaction proceed at 50°C compared to 10°C?',
     'About 2 times faster', 'About 6 times faster', 'About 12 times faster', 'About 25 times faster',
     'C',
     'Rate at 50°C = 0.05882 s⁻¹; rate at 10°C = 0.00467 s⁻¹. Ratio ≈ 12.6, approximately 12 times faster.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 2, what is the effect of increasing Na₂S₂O₃ concentration on the reaction rate?',
     'Increasing concentration decreases the reaction rate.',
     'Increasing concentration has no effect on reaction rate.',
     'Increasing concentration increases the reaction rate (decreases time to invisibility).',
     'Increasing concentration first increases then decreases the reaction rate.',
     'C',
     'As Na₂S₂O₃ concentration increases from 0.05 M to 0.20 M, time to invisibility decreases from 116 s to 29 s — a faster reaction rate.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A student conducts a third experiment identical to Experiment 1 but doubles the HCl concentration to 4 M (all other conditions unchanged). Based on the results of Experiments 1 and 2, which outcome is most likely?',
     'The reaction rate would decrease at all temperatures.',
     'The reaction rate at each temperature would be higher than in Experiment 1.',
     'Temperature would no longer affect the reaction rate.',
     'The reaction rate would be identical to Experiment 1.',
     'B',
     'Experiment 2 shows that increasing reactant concentration increases reaction rate. Doubling HCl concentration should therefore increase rate at every temperature tested in Experiment 1.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

    -- ── Passage 14 [Research Summaries]: Photosynthesis Rate ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Photosynthesis Rate as a Function of Light Intensity and CO₂ Concentration',
        'Students investigated photosynthesis in the aquatic plant Elodea by counting oxygen bubbles produced per minute as a proxy for photosynthesis rate. A sodium bicarbonate solution supplied dissolved CO₂.

Experiment 1: Light intensity varied (lamp distance adjusted); CO₂ concentration constant at 0.04%.

Light Intensity (lux) | Bubbles/min
500                   | 8
1,000                 | 15
2,000                 | 28
4,000                 | 43
8,000                 | 55
16,000                | 60
32,000                | 61

Experiment 2: Same setup; light intensity varied; three CO₂ concentrations tested (0.04%, 0.10%, 0.40%).
At low light (500–2,000 lux): bubble rates were similar across all three CO₂ concentrations.
At high light (8,000–32,000 lux): higher CO₂ concentrations allowed significantly higher bubble rates than 0.04% CO₂.',
        4)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 1, what happens to the rate of photosynthesis as light intensity increases from 500 to 32,000 lux?',
     'It increases without limit.',
     'It increases rapidly at first, then levels off at higher intensities.',
     'It remains constant across all intensities.',
     'It increases then sharply decreases above 8,000 lux.',
     'B',
     'Bubbles per minute: 8 → 15 → 28 → 43 → 55 → 60 → 61. The rate of increase slows markedly above 8,000 lux and nearly plateaus, indicating a saturation effect.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'What was the independent variable in Experiment 1?',
     'CO₂ concentration', 'Bubble production rate', 'Light intensity', 'Type of aquatic plant',
     'C',
     'The student deliberately varied light intensity while holding CO₂ concentration and other conditions constant.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'The plateau in oxygen production above ~16,000 lux in Experiment 1 suggests that at high light intensities:',
     'The plant stops photosynthesizing entirely.',
     'Light is no longer the limiting factor; another variable is now limiting the rate.',
     'The lamp produces too much heat, destroying photosynthetic enzymes.',
     'The sodium bicarbonate solution becomes acidic at high intensities.',
     'B',
     'When increasing the independent variable (light) no longer increases the rate, another factor has become limiting. Experiment 2 confirms CO₂ is that factor at high light levels.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 2, why did the plateau occur at lower bubble rates with 0.04% CO₂ than with 0.40% CO₂ at high light intensities?',
     'Higher CO₂ concentrations reduce light requirements for photosynthesis.',
     'At high light, CO₂ availability becomes the limiting factor; more CO₂ allows a higher maximum rate.',
     'Lower CO₂ concentrations increase oxygen toxicity in the plant.',
     'The 0.04% CO₂ solution absorbed more light, reducing effective intensity.',
     'B',
     'Experiment 2 directly shows that raising CO₂ from 0.04% to 0.40% at high light increases bubble rates — confirming CO₂ is limiting at high light when supply is low.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on both experiments, which combination of conditions would maximise photosynthesis rate in Elodea?',
     'Low light intensity and low CO₂ concentration',
     'High light intensity and low CO₂ concentration',
     'Low light intensity and high CO₂ concentration',
     'High light intensity and high CO₂ concentration',
     'D',
     'Experiment 1 shows increasing light raises rate; Experiment 2 shows that at high light, higher CO₂ is needed to sustain high rates. Both must be elevated together to achieve maximum photosynthesis.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- ── Passage 15 [Research Summaries]: Projectile Motion ───
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Horizontal Projectile Motion: Range and Variables',
        'A physics class launched steel balls horizontally off a table and measured the horizontal range (x, in meters) using carbon paper on the floor.

Experiment 1: Table height = 0.80 m. Launch velocity (v₀) varied.

v₀ (m/s) | Range x (m)
1.0      | 0.40
2.0      | 0.80
3.0      | 1.21
4.0      | 1.61
5.0      | 2.00

Experiment 2: Same procedure from a table height of 1.25 m. Ranges at each v₀ were approximately 25% greater than in Experiment 1.

Experiment 3: Heavier ball (double the mass) launched from the same 0.80 m height at the same velocities. Ranges were identical to Experiment 1.',
        5)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 1, what is the relationship between launch velocity and horizontal range?',
     'Horizontal range is independent of launch velocity.',
     'Horizontal range decreases as launch velocity increases.',
     'Horizontal range increases proportionally with launch velocity.',
     'Horizontal range increases with the square of launch velocity.',
     'C',
     'Doubling v₀ from 1.0 to 2.0 m/s doubles range from 0.40 to 0.80 m; tripling v₀ to 3.0 m/s triples range to ~1.21 m. This is a proportional (linear) relationship.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Comparing Experiments 1 and 2, what can be concluded about the effect of launch height on horizontal range?',
     'Greater launch height results in a shorter horizontal range.',
     'Launch height has no effect on horizontal range.',
     'Greater launch height results in a greater horizontal range for the same launch velocity.',
     'Greater launch height increases vertical speed but decreases horizontal range.',
     'C',
     'Experiment 2 (height 1.25 m) consistently produced ranges ~25% greater than Experiment 1 (height 0.80 m) at every tested velocity.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'In Experiment 1, the vertical drop (0.80 m) is the same for all launch velocities. This is best explained by:',
     'The horizontal velocity affects how quickly the ball falls.',
     'Gravity acts downward independently of any horizontal motion.',
     'Higher launch speeds increase the air resistance acting downward.',
     'The floor absorbs the ball''s vertical energy at all velocities equally.',
     'B',
     'In ideal projectile motion, horizontal and vertical motions are independent. The time to fall depends only on height and gravitational acceleration, not horizontal speed.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'The result of Experiment 3 (heavier ball, same range as Experiment 1) suggests:',
     'Heavier projectiles fall more slowly than lighter ones.',
     'Mass significantly affects horizontal range in projectile motion.',
     'Mass does not affect the trajectory of a horizontally launched projectile (ignoring air resistance).',
     'The heavier ball had a greater initial velocity in Experiment 3.',
     'C',
     'Equal ranges for different masses confirm that gravitational acceleration is independent of mass (Galileo''s principle), and horizontal range therefore depends on velocity and height, not mass.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 1, a student predicts the horizontal range at v₀ = 6.0 m/s. The most reasonable prediction is:',
     '2.21 m', '2.40 m', '2.80 m', '3.60 m',
     'B',
     'The proportional relationship gives range ≈ 0.40 × v₀. At 6.0 m/s: 0.40 × 6.0 = 2.40 m.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 16 [Research Summaries]: Dissolved Oxygen ────
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Dissolved Oxygen, Water Temperature, and Fish Species Richness',
        'Ecologists studied dissolved oxygen (DO, mg/L) levels and fish communities at five sites along a river. Sites 3–5 are downstream of a sewage treatment plant discharge point.

Experiment 1: DO and fish species richness measured at each site.

Site          | DO (mg/L) | Fish species richness
1 (upstream)  | 11.2      | 22
2             | 9.4       | 18
3             | 6.1       | 11
4             | 4.3       | 6
5 (downstream)| 2.8       | 2

Note: DO below 5 mg/L is classified as hypoxic (dangerously low for most fish species).

Experiment 2: River water from Site 4 was placed in aquaria at three temperatures. DO was measured after equilibration.

Temperature (°C) | DO (mg/L)
15               | 9.8
25               | 8.1
35               | 6.3',
        6)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 1, what is the general relationship between dissolved oxygen level and fish species richness?',
     'Higher DO is associated with fewer fish species.',
     'Higher DO is associated with greater fish species richness.',
     'DO has no consistent relationship with fish species richness.',
     'Fish species richness peaks at 6.1 mg/L DO.',
     'B',
     'As DO decreases from Site 1 (11.2 mg/L, 22 species) to Site 5 (2.8 mg/L, 2 species), species richness decreases consistently — a positive association.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'According to the note, which sites should be classified as hypoxic?',
     'Sites 1 and 2', 'Sites 3 and 4', 'Sites 4 and 5', 'Only Site 5',
     'C',
     'Sites 4 (4.3 mg/L) and 5 (2.8 mg/L) are both below the 5 mg/L hypoxic threshold. Site 3 (6.1 mg/L) is above it.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 1, the most likely cause of decreasing DO levels from Sites 1 to 5 is:',
     'Increasing river elevation downstream',
     'Discharge from the sewage treatment plant introducing organic matter that depletes oxygen through decomposition',
     'Fish at downstream sites consuming all available dissolved oxygen',
     'Sunlight causing oxygen to evaporate from the surface at downstream sites',
     'B',
     'Sites 3–5 are downstream of the sewage discharge point and show the sharpest DO decline. Organic matter from sewage is broken down by bacteria that consume oxygen (biochemical oxygen demand), depleting DO.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Experiment 2, what is the effect of increasing water temperature on dissolved oxygen?',
     'Dissolved oxygen increases as temperature increases.',
     'Dissolved oxygen is unaffected by temperature.',
     'Dissolved oxygen decreases as temperature increases.',
     'Dissolved oxygen first increases then decreases with temperature.',
     'C',
     'As temperature rises from 15°C to 35°C, DO falls from 9.8 to 6.3 mg/L — a consistent decrease. Warmer water holds less dissolved gas.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A conservation biologist wants to restore fish diversity at Site 4. Based on both experiments, which intervention would most directly address the root cause of low species richness?',
     'Stocking the river with farmed fish at Site 4',
     'Reducing water temperature at Site 4 to 15°C',
     'Reducing organic pollutant discharge from the sewage treatment plant to raise DO levels',
     'Removing all current fish species from Site 4 to allow recolonisation',
     'C',
     'The data show DO is the key variable correlated with species richness (Exp. 1), and sewage discharge is the likely cause of low DO downstream. Improving treatment to reduce organic discharge directly addresses the root cause.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 17 [Data Representation]: Stellar Classification ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Stellar Spectral Classification and the Hertzsprung–Russell Diagram',
        'Astronomers classify stars by spectral type, which correlates closely with surface temperature.

Table 3: Morgan–Keenan Spectral Classification

Spectral Type | Surface Temp (K) | Color       | Example Star
O             | 30,000–60,000    | Blue        | Alnitak
B             | 10,000–30,000    | Blue-white  | Rigel
A             | 7,500–10,000     | White       | Sirius A
F             | 6,000–7,500      | Yellow-white| Procyon
G             | 5,200–6,000      | Yellow      | The Sun
K             | 3,700–5,200      | Orange      | Arcturus
M             | 2,400–3,700      | Red         | Betelgeuse

Figure 2 (Hertzsprung–Russell diagram, described): Luminosity (solar units, log scale 10⁻⁴ to 10⁶) on the y-axis; spectral type O→M on the x-axis. The Main Sequence runs diagonally from upper-left (hot, luminous O stars) to lower-right (cool, dim M stars). Giant and supergiant branches appear above the Main Sequence at cool temperatures. White dwarfs appear in the lower left (hot but dim).',
        7)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'According to Table 3, which spectral type contains stars with surface temperatures between 6,000 K and 7,500 K?',
     'G type', 'F type', 'A type', 'K type',
     'B',
     'Table 3: F-type stars have surface temperatures 6,000–7,500 K.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Table 3, what is the general relationship between spectral type (moving from O to M) and surface temperature?',
     'Surface temperature increases from O to M.',
     'Surface temperature decreases from O to M.',
     'Surface temperature is unrelated to spectral type.',
     'Surface temperature first increases then decreases from O to M.',
     'B',
     'O-type stars range from 30,000–60,000 K; M-type from 2,400–3,700 K. Temperature decreases consistently along the spectral sequence from O to M.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Table 3, what color would the Sun (G-type, ~5,500 K) appear?',
     'Blue-white', 'Orange', 'Red', 'Yellow',
     'D',
     'Table 3 classifies G-type stars as yellow in color.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on the H–R diagram description, a star with extremely high luminosity (10⁵ solar luminosities) but a cool, red surface temperature (M-type) would most likely be located:',
     'On the Main Sequence among other M-type stars',
     'In the white dwarf region',
     'In the giant or supergiant branch above the Main Sequence',
     'Below the Main Sequence',
     'C',
     'Main Sequence M-type stars are cool AND dim (lower right). A cool but extremely luminous star must be very large — a giant or supergiant — located above the Main Sequence on the H–R diagram.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'A newly discovered star has spectral type A (surface temperature ~8,500 K) and luminosity of 25 solar luminosities. Based on the H–R diagram, this star is most likely:',
     'A white dwarf', 'A red supergiant', 'A main-sequence star', 'A K-type giant',
     'C',
     'A-type stars at moderate luminosities (tens of solar units) are consistent with Main Sequence placement. White dwarfs are hot but very dim; supergiants are far more luminous; K-type giants are cool.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 18 [Research Summaries]: Liquid Density ─────
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Density of Four Liquids at Different Temperatures',
        'A student measured the density (g/mL) of four liquids at temperatures from 0°C to 100°C using a calibrated pipette and analytical balance (10.00 mL sample weighed at each temperature).

Table 4: Density (g/mL) at Different Temperatures

Temperature (°C) | Water  | Ethanol | Vegetable Oil | Glycerol
0                | 0.9998 | 0.8063  | 0.920         | 1.273
20               | 0.9982 | 0.7893  | 0.910         | 1.261
40               | 0.9922 | 0.7721  | 0.900         | 1.249
60               | 0.9832 | 0.7548  | 0.890         | 1.234
80               | 0.9718 | 0.7374  | 0.880         | 1.220
100              | 0.9584 | 0.7199  | 0.869         | 1.205

Experiment 2: Equal volumes of all four liquids were mixed in a graduated cylinder at 20°C and allowed to separate. The observed layer order from bottom to top: glycerol, water, vegetable oil, ethanol.',
        8)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Table 4, which liquid is the most dense at 20°C?',
     'Water', 'Ethanol', 'Vegetable Oil', 'Glycerol',
     'D',
     'At 20°C: Water = 0.9982, Ethanol = 0.7893, Vegetable Oil = 0.910, Glycerol = 1.261 g/mL. Glycerol has the highest density.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Based on Table 4, what is the effect of increasing temperature on the density of all four liquids?',
     'Density increases as temperature increases.',
     'Density decreases as temperature increases.',
     'Density remains constant with temperature.',
     'Density first increases then decreases.',
     'B',
     'All four liquids show decreasing density values at every step from 0°C to 100°C — liquids expand (volume increases) when heated, reducing density.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'The layer order observed in Experiment 2 (bottom to top: glycerol, water, vegetable oil, ethanol) is consistent with which property?',
     'The liquids arrange in order of decreasing viscosity.',
     'The liquids arrange in order of increasing density from top to bottom.',
     'The liquids arrange in order of decreasing density from bottom to top.',
     'The liquids arrange in order of their boiling points.',
     'C',
     'Denser liquids sink and less dense liquids float. At 20°C: Glycerol (1.261) > Water (0.9982) > Vegetable Oil (0.910) > Ethanol (0.7893) — decreasing from bottom to top.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'Would the layer order from Experiment 2 be expected to change if the same experiment were repeated at 40°C?',
     'Yes, because all liquids expand equally, reversing some layers.',
     'No, because the relative order of densities is preserved at 40°C.',
     'Yes, because water becomes denser than glycerol at 40°C.',
     'Yes, because ethanol evaporates before 40°C, eliminating one layer.',
     'B',
     'At 40°C: Glycerol = 1.249, Water = 0.9922, Vegetable Oil = 0.900, Ethanol = 0.7721 g/mL. The rank order is unchanged — glycerol remains densest, ethanol least dense.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit1,
     'The precision of the density measurements is best demonstrated by which aspect of the experimental design?',
     'The use of a calibrated pipette and analytical balance, which allow measurements to four decimal places',
     'The fact that the temperature was raised in equal 20°C increments',
     'The use of four different liquids in the same experiment',
     'The mixing of all liquids in Experiment 2',
     'A',
     'Precision (reproducibility and exactness) in measurement is achieved through calibrated instruments. Four significant figures in density values indicate a high-precision measurement setup.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id);

    -- ── Passage 19 [Conflicting Viewpoints]: Origin of the Moon ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Competing Hypotheses for the Origin of Earth''s Moon',
        'Three hypotheses have been proposed to explain the origin of Earth''s Moon.

Hypothesis 1 – Giant Impact: Approximately 4.5 billion years ago, a Mars-sized body called Theia struck the early Earth at an oblique angle. The collision ejected vast quantities of material — primarily from Earth''s mantle and Theia''s outer layers — into Earth orbit. This debris coalesced to form the Moon. Supporting evidence: (1) The Moon''s bulk composition closely resembles Earth''s mantle. (2) The Moon has an unusually small iron core relative to its total mass, consistent with ejection of material after Earth''s iron had already sunk to form its core. (3) Computer simulations of an oblique impact produce a debris disk of the correct mass and angular momentum. (4) The angular momentum of the Earth–Moon system is consistent with a giant impact origin.

Hypothesis 2 – Gravitational Capture: The Moon formed elsewhere in the solar system and was captured by Earth''s gravity when it passed close to Earth. This might explain differences in surface features between Earth and the Moon. However, capturing a large body without subsequently losing it requires extremely precise orbital conditions, which critics consider highly improbable.

Hypothesis 3 – Co-formation: Earth and the Moon formed simultaneously from the same cloud of solar nebula material as a binary planet system. This naturally explains why the Moon''s orbit lies close to Earth''s equatorial plane. However, it struggles to explain why the Moon has a much smaller iron core relative to its total mass than Earth does.',
        9)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit2,
     'According to Hypothesis 1, what is the primary source of material that formed the Moon?',
     'Material captured from the asteroid belt',
     'Material ejected from Earth''s mantle and the impacting body Theia during the giant impact',
     'Material that co-formed with Earth in the solar nebula',
     'Material from the outer atmosphere of the early Sun',
     'B',
     'Hypothesis 1 states the collision "ejected vast quantities of material — primarily from Earth''s mantle and Theia''s outer layers — into Earth orbit" which then formed the Moon.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'Which hypothesis BEST explains why the Moon has a smaller iron core relative to its total mass compared to Earth?',
     'Hypothesis 1: ejected material came from Earth''s mantle after the iron core had already formed, so the Moon is iron-depleted',
     'Hypothesis 2: the Moon formed in a region of the solar system naturally low in iron',
     'Hypothesis 3: both Earth and Moon formed from the same material, so their iron content should be similar',
     'Hypotheses 1 and 3 both fully and equally explain this observation',
     'A',
     'Hypothesis 1 specifically accounts for the Moon''s iron depletion: material was ejected from the mantle (not the iron-rich core) after Earth''s differentiation, so the resulting Moon is iron-poor. Hypothesis 3 explicitly struggles with this observation.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'A critic of Hypothesis 2 would most likely cite which evidence as problematic?',
     'The Moon''s composition is very similar to Earth''s mantle, inconsistent with formation elsewhere in the solar system',
     'Gravitational capture is physically impossible under any circumstances',
     'Earth''s orbit is in the wrong location for any capture event to occur',
     'The Moon would have been destroyed by tidal forces during the capture process',
     'A',
     'If the Moon formed elsewhere, its composition would not be expected to so closely match Earth''s mantle. This similarity is most naturally explained by a common origin (Hypothesis 1 or 3), not capture.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'Hypotheses 1 and 3 differ in their explanation of the Moon''s small iron core. Which piece of evidence most clearly distinguishes between them?',
     'The Moon''s orbit lies close to Earth''s equatorial plane',
     'Computer simulations of early solar system dynamics',
     'The Moon''s small iron core relative to Earth''s',
     'The similar bulk composition of the Moon and Earth''s mantle',
     'C',
     'Hypothesis 1 explains the small iron core (ejection post-differentiation); Hypothesis 3 explicitly "struggles to explain" it. This observation therefore differentiates the two hypotheses most clearly.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'Both Hypothesis 1 and Hypothesis 3 would most likely agree that:',
     'The Moon formed from material entirely unrelated to Earth.',
     'Gravitational capture is the most likely mechanism for the Moon''s formation.',
     'The Moon and Earth share some common compositional heritage from related source material.',
     'The Moon formed more than 5 billion years ago.',
     'C',
     'Hypothesis 1 (ejected Earth/Theia mantle material) and Hypothesis 3 (co-formation from the same nebular cloud) both imply a shared compositional link between Earth and Moon. Hypothesis 2 (capture) is the one that does not.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id);

    -- ── Passage 20 [Conflicting Viewpoints]: Glacial Retreat ─
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_sci_p3,
        'Primary Driver of Accelerated Alpine Glacial Retreat Since 1850',
        'Alpine glaciers worldwide have retreated significantly since approximately 1850. Two scientists disagree about the primary cause.

Scientist 1 (Anthropogenic Climate Change): The accelerated retreat of alpine glaciers since 1850 is primarily driven by human-caused greenhouse gas emissions. Atmospheric CO₂ has risen from ~280 ppm before industrialisation to over 420 ppm today — a level not seen in at least 800,000 years, based on ice core records. Rising CO₂ traps additional heat, raising global mean temperatures. Statistical analyses of over 400 glaciers worldwide show retreat rates correlating closely with global temperature increases, and the rate of retreat has accelerated in concert with accelerating CO₂ emissions in the 20th century. Natural variability in solar output and volcanic eruptions cannot account for the magnitude or pattern of observed warming.

Scientist 2 (Natural Variability): While human-caused emissions may contribute some warming, the primary driver of glacial retreat since 1850 is the natural end of the Little Ice Age — a period of cooler global temperatures lasting from roughly 1300 to 1850 CE. Historical records, tree rings, and sediment cores clearly document this cooling period. Glaciers grew substantially during the Little Ice Age and have been naturally retreating as the climate rebounds toward pre–Little Ice Age norms. Long-term cycles in solar output and Milankovitch orbital parameters drive multi-century climate oscillations that do not require anthropogenic forcing to explain. Regional variability in glacial behavior (some glaciers advancing while others retreat) is more consistent with natural variability than with a globally uniform anthropogenic signal.',
        10)
    RETURNING id INTO v_group_id;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty, idquestiongroup)
    VALUES
    (v_sci_id, v_sci_p3, v_sci_unit2,
     'According to Scientist 1, what is the primary driver of accelerated glacial retreat since 1850?',
     'The natural end of the Little Ice Age',
     'Changes in Earth''s orbital parameters',
     'Human-caused greenhouse gas emissions raising global temperatures',
     'Reduced solar output since 1850',
     'C',
     'Scientist 1 explicitly states: "The accelerated retreat of alpine glaciers since 1850 is primarily driven by human-caused greenhouse gas emissions."',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'According to Scientist 2, the onset of accelerated glacial retreat around 1850 coincides specifically with:',
     'The beginning of large-scale industrial CO₂ emissions',
     'The natural end of the Little Ice Age',
     'A sharp increase in volcanic eruptions worldwide',
     'A sudden change in Earth''s orbital tilt',
     'B',
     'Scientist 2 argues that the Little Ice Age ended around 1850, and glaciers have been retreating naturally since then as temperatures rebound to pre–Little Ice Age levels.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'Both scientists would most likely agree on which of the following?',
     'Anthropogenic CO₂ emissions have no measurable effect on climate.',
     'The Little Ice Age did not occur.',
     'Alpine glaciers have been retreating since approximately 1850.',
     'Solar output is the dominant driver of current climate change.',
     'C',
     'Both scientists discuss glacial retreat as an observed, real phenomenon since 1850; they disagree only on whether the primary cause is anthropogenic or natural.',
     'MULTIPLE_CHOICE', 'EASY', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'Scientist 1 states that natural factors "cannot account for the magnitude or pattern of observed warming." How would Scientist 2 most likely respond?',
     'By agreeing that natural factors are insufficient and conceding the anthropogenic argument',
     'By citing evidence that Milankovitch cycles and solar variability have historically driven climate changes of comparable magnitude',
     'By arguing that no warming has occurred since 1850',
     'By claiming volcanic eruptions always cause net cooling, never warming',
     'B',
     'Scientist 2 explicitly argues that solar and Milankovitch cycles "drive multi-century climate oscillations that do not require anthropogenic forcing" — directly countering Scientist 1''s claim about the insufficiency of natural factors.',
     'MULTIPLE_CHOICE', 'MEDIUM', v_group_id),

    (v_sci_id, v_sci_p3, v_sci_unit2,
     'A new study finds that the rate of alpine glacial retreat in the 20th century is 10 times faster than at any other point in the preceding 10,000 years. This finding most directly challenges which scientist''s hypothesis?',
     'Scientist 1 only', 'Scientist 2 only', 'Both scientists equally', 'Neither scientist',
     'B',
     'Scientist 2 attributes retreat to natural rebound from the Little Ice Age. A retreat rate 10× faster than anything in 10,000 years is far beyond what "natural rebound" would predict, directly undermining the natural variability hypothesis.',
     'MULTIPLE_CHOICE', 'HARD', v_group_id);

END $$;
