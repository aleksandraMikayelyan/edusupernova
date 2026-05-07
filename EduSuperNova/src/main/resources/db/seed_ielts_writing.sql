DO $$
DECLARE
    v_course_id INTEGER;
    v_paper_id  INTEGER;
    u1 INTEGER; u2 INTEGER; u3 INTEGER; u4 INTEGER;
    g3  INTEGER; g4  INTEGER; g5  INTEGER; g6  INTEGER; g7  INTEGER;
    g8  INTEGER; g9  INTEGER; g10 INTEGER; g11 INTEGER; g12 INTEGER;
    g13 INTEGER; g14 INTEGER; g15 INTEGER; g16 INTEGER; g17 INTEGER;
    g18 INTEGER; g19 INTEGER; g20 INTEGER; g21 INTEGER; g22 INTEGER;
BEGIN
    -- 1. Resolve Course
    SELECT idcourse INTO v_course_id FROM courses WHERE lower(description) = 'ielts writing section' LIMIT 1;

    -- 2. Create Writing Paper
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_course_id,
        'IELTS Writing',
        'Task 1: 20 mins (150 words). Task 2: 40 mins (250 words).',
        'ESSAY',
        2,
        60,
        2
    );

    SELECT idpaper INTO v_paper_id FROM papers WHERE idcourse = v_course_id AND lower(papername) = 'ielts writing' LIMIT 1;

    -- 3. Insert Units
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES
        (v_course_id, 'Unit 1: Task 1 - Data & Scenarios',   'Summaries/ielts/writing/task1.txt',      1),
        (v_course_id, 'Unit 2: Task 1 - Letter Writing',     'Summaries/ielts/writing/letters.txt',    2),
        (v_course_id, 'Unit 3: Task 2 - Essay Structures',   'Summaries/ielts/writing/task2.txt',      3),
        (v_course_id, 'Unit 4: Task 2 - Global & Social',    'Summaries/ielts/writing/global.txt',     4)
    ON CONFLICT DO NOTHING;

    SELECT idunit INTO u1 FROM units WHERE title = 'Unit 1: Task 1 - Data & Scenarios'  LIMIT 1;
    SELECT idunit INTO u2 FROM units WHERE title = 'Unit 2: Task 1 - Letter Writing'    LIMIT 1;
    SELECT idunit INTO u3 FROM units WHERE title = 'Unit 3: Task 2 - Essay Structures'  LIMIT 1;
    SELECT idunit INTO u4 FROM units WHERE title = 'Unit 4: Task 2 - Global & Social'   LIMIT 1;

    -- 4. Insert Question Groups (context/scenario for each Task 1 prompt)
    INSERT INTO question_groups (idpaper, title, contexttext, contextimageurl, orderindex)
    VALUES
        -- Academic Task 1: Data Descriptions
        (v_paper_id, 'Academic Task 1: Bar Chart - Telephone Calls', '/images/ielts/ielts-writing-01.png', 
         'The bar chart below shows the number of minutes of telephone calls in the UK, divided into three categories, from 1995 to 2002.', 1),

        (v_paper_id, 'Academic Task 1: Pie Chart - Water Usage','/images/ielts/ielts-writing-02.jpg',
         'The pie charts below show the percentage of water used for different purposes in six areas of the world.', 2),

        (v_paper_id, 'Academic Task 1: Table - Wealth Distribution','/images/ielts/ielts-writing-03.jpg',
         'The table below shows the percentage of the population and the distribution of wealth by region in the year 2000.', 3),

        (v_paper_id, 'Academic Task 1: Process Diagram - Milk Production','/images/ielts/ielts-writing-04.jpg',
         'The diagram below shows how milk is produced and processed for sale in supermarkets.', 4),

        (v_paper_id, 'Academic Task 1: Map - Park Development','/images/ielts/ielts-writing-05.png',
         'The maps below show a small local park in 1920 and its current layout after redevelopment.', 5),

        (v_paper_id, 'Academic Task 1: Bar Chart - Electricity Statistics','/images/ielts/ielts-writing-06.jpg',
         'The bar chart below shows the top ten countries for the production and consumption of electricity in 2014.', 6),

        (v_paper_id, 'Academic Task 1: Table - City Water Costs','/images/ielts/ielts-writing-07.jpg',
         'The table below gives information about the average cost of water in five different Australian cities.', 7),

        (v_paper_id, 'Academic Task 1: Line Graph - Waste Production','/images/ielts/ielts-writing-08.png',
         'The line graph below shows the amount of waste produced by three different companies over a 15-year period.', 8),

        (v_paper_id, 'Academic Task 1: Process Diagram - Central Heating','/images/ielts/ielts-writing-09.png',
         'The diagram below shows how a solar-powered central heating system in a house works.', 9),

        (v_paper_id, 'Academic Task 1: Map - School Layout','/images/ielts/ielts-writing-10.png',
         'The maps below show the changes in the layout of a school campus between 1985 and 2015.', 10),

        (v_paper_id, 'Academic Task 1: Bar Chart - Household Waste Recycling','/images/ielts/ielts-writing-11.png',
         'The bar chart below shows the percentage of total household waste that was recycled in four different countries between 2010 and 2026.', 11),

        -- General Training Task 1: Letter Scenarios
        INSERT INTO question_groups (idpaper, title, contexttext,, orderindex)
        VALUES
        (v_paper_id, 'General Task 1: Job Application',
         'You have seen an advertisement for a part-time job in a local restaurant. Write a letter to the manager applying for the job.', 14),

        (v_paper_id, 'General Task 1: Complaint - Defective Product',
         'You recently bought a new piece of equipment for your home, but it does not work. Write a letter to the shop manager to complain.', 15),

        (v_paper_id, 'General Task 1: Insurance Policy Change',
         'Your car insurance policy is about to expire and you want to renew it, but you want to make some changes. Write a letter to the company.', 16),

        (v_paper_id, 'General Task 1: Thank You Letter',
         'You recently stayed at a friend''s house in another country. Write a letter to thank them for their hospitality.', 17),

        (v_paper_id, 'General Task 1: Help Request - House Sitting',
         'You are moving to a new city and you need someone to look after your house while you are away. Write a letter to a friend asking for help.', 18),

        (v_paper_id, 'General Task 1: Job Rejection',
         'You have been offered a job in another city, but you cannot accept it for personal reasons. Write a letter to the hiring manager.', 19),

        (v_paper_id, 'General Task 1: Volunteer Application',
         'You have seen a notice in your local library about a volunteer position. Write a letter to the organizer expressing your interest.', 20),

        (v_paper_id, 'General Task 1: Declining Invitation',
         'You have been invited to a party by a former colleague, but you are unable to attend. Write a letter to your colleague.', 21),

        (v_paper_id, 'General Task 1: Complaint - Service Quality',
         'You are unhappy with the quality of service at a local sports club. Write a letter to the club manager explaining the issues.', 22),

        (v_paper_id, 'General Task 1: Advice Request - Reunion',
         'You want to organize a reunion for your old school friends. Write a letter to your former teacher asking for advice on the event.', 23);

    -- 5. Fetch group IDs
    SELECT id INTO g3  FROM question_groups WHERE title = 'Academic Task 1: Bar Chart - Telephone Calls'      LIMIT 1;
    SELECT id INTO g4  FROM question_groups WHERE title = 'Academic Task 1: Pie Chart - Water Usage'          LIMIT 1;
    SELECT id INTO g5  FROM question_groups WHERE title = 'Academic Task 1: Table - Wealth Distribution'      LIMIT 1;
    SELECT id INTO g6  FROM question_groups WHERE title = 'Academic Task 1: Process Diagram - Milk Production' LIMIT 1;
    SELECT id INTO g7  FROM question_groups WHERE title = 'Academic Task 1: Map - Park Development'           LIMIT 1;
    SELECT id INTO g8  FROM question_groups WHERE title = 'Academic Task 1: Bar Chart - Electricity Statistics' LIMIT 1;
    SELECT id INTO g9  FROM question_groups WHERE title = 'Academic Task 1: Table - City Water Costs'         LIMIT 1;
    SELECT id INTO g10 FROM question_groups WHERE title = 'Academic Task 1: Line Graph - Waste Production'    LIMIT 1;
    SELECT id INTO g11 FROM question_groups WHERE title = 'Academic Task 1: Process Diagram - Central Heating' LIMIT 1;
    SELECT id INTO g12 FROM question_groups WHERE title = 'Academic Task 1: Map - School Layout'              LIMIT 1;
    SELECT id INTO g13 FROM question_groups WHERE title = 'Academic Task 1: Bar Chart - Household Waste Recycling' LIMIT 1;
    SELECT id INTO g14 FROM question_groups WHERE title = 'General Task 1: Job Application'                  LIMIT 1;
    SELECT id INTO g15 FROM question_groups WHERE title = 'General Task 1: Complaint - Defective Product'    LIMIT 1;
    SELECT id INTO g16 FROM question_groups WHERE title = 'General Task 1: Insurance Policy Change'          LIMIT 1;
    SELECT id INTO g17 FROM question_groups WHERE title = 'General Task 1: Thank You Letter'                 LIMIT 1;
    SELECT id INTO g18 FROM question_groups WHERE title = 'General Task 1: Help Request - House Sitting'     LIMIT 1;
    SELECT id INTO g19 FROM question_groups WHERE title = 'General Task 1: Job Rejection'                    LIMIT 1;
    SELECT id INTO g20 FROM question_groups WHERE title = 'General Task 1: Volunteer Application'            LIMIT 1;
    SELECT id INTO g21 FROM question_groups WHERE title = 'General Task 1: Declining Invitation'             LIMIT 1;
    SELECT id INTO g22 FROM question_groups WHERE title = 'General Task 1: Complaint - Service Quality'         LIMIT 1;
    SELECT id INTO g23 FROM question_groups WHERE title = 'General Task 1: Advice Request - Reunion'         LIMIT 1;

    -- 6. Insert Task 1: Academic Data Description questions (SHORT_ANSWER + Groq evaluated)
    INSERT INTO quizes
    (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_course_id, v_paper_id, u1, g3,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A well-organised summary identifying key trends: steady decline in local calls, rise in national and mobile calls, with mobile overtaking national by 2002.',
     'Note that national calls remained the highest throughout the period.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g4,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A response covering the dominant role of agriculture in most regions with clear comparisons between regions, noting exceptions such as Europe where industrial use is higher.',
     'Agriculture accounts for the vast majority of water use in Central Asia and South East Asia.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g5,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A response describing the disparity between population share and wealth share across regions, highlighting that North America holds 34% of wealth with only 6% of the population.',
     'North America owns 34% of wealth despite having only 6% of the population.',
     'SHORT_ANSWER', 'HARD'),

    (v_course_id, v_paper_id, u1, g6,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A clear sequential description of the milk production process from collection through refrigeration and pasteurisation to packaging and distribution.',
     'Ensure you mention the refrigeration and pasteurization stages.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g7,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A comparison of the two maps identifying key changes: removal of the rose garden, addition of a cafe, enlargement of the pond, and any new pathways or facilities.',
     'The rose garden was replaced by a cafe and the pond was enlarged.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g8,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A response identifying China and the US as top producers and consumers and describing the significant gap between them and third-ranked countries.',
     'Highlight that China and the US are the top producers and consumers; note the gap between them and the third-ranked country.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g9,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A response comparing water costs across the five cities, identifying the highest and lowest cost cities with specific figures and noting notable differences in usage charges.',
     'Identify the highest and lowest cost cities and compare the average usage charges across the five Australian cities.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g10,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A response contrasting Company A''s steady decline with Company B''s fluctuation and Company C''s sharp increase over the 15-year period.',
     'Contrast the steady decline in Company A''s waste with the sharp upward trend seen in Company C.',
     'SHORT_ANSWER', 'HARD'),

    (v_course_id, v_paper_id, u1, g11,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A step-by-step description of the solar heating process from collection by solar panels through heat exchange in the water storage tank to distribution throughout the house.',
     'Explain the process starting from solar energy collection to the heat exchange in the water storage tank.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g12,
     'You should spend about 20 minutes on this task. <br><br> Summarise the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A comparison of the campus in 1985 and 2015, noting the expansion of buildings, conversion of the library to a digital media centre, and changes to outdoor spaces.',
     'Describe the expansion of buildings and the conversion of the library into a digital media center over the 30-year period.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g3,
     'You should spend about 20 minutes on this task. <br><br> Identify the most significant trends in the telephone call data and provide a summary. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A focused summary highlighting the dramatic rise in mobile calls and the decline in local landline usage, with accurate comparison of figures.',
     'Compare the massive growth in mobile call minutes against the decline in local fixed-line usage.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u1, g4,
     'You should spend about 20 minutes on this task. <br><br> Compare and contrast the water usage patterns in different global regions. <br><br> Write at least 150 words.',
     NULL, NULL, NULL, NULL,
     'A comparative response clearly identifying agricultural dominance in Central Asia versus higher industrial use in Europe, with relevant supporting data.',
     'Highlight that agriculture dominates water use in Central Asia, whereas industry is the main user in Europe.',
     'SHORT_ANSWER', 'HARD');

     INSERT INTO quizes 
    (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES (
    v_course_id, 
    v_paper_id, 
    u1, 
    g13,
    'You should spend about 20 minutes on this task. <br><br> Summarize the information by selecting and reporting the main features, and make comparisons where relevant. <br><br> Write at least 150 words.',
    NULL, 
    NULL, 
    NULL, 
    NULL,
    'A high-scoring response should highlight the massive disparity in Central Asia, where Agriculture accounts for the vast majority of water use (88%), contrasting sharply with Europe, where Industry is the primary consumer at roughly 53%. It should also note that Domestic use is consistently the lowest sector across all regions.',
    'Ensure the student uses comparative structures like "by far the most," "conversely," and "accounted for." Remind them to include specific data points from the chart to support their descriptions.',
    'SHORT_ANSWER', 
    'HARD'
);

    -- 7. Insert Task 1: General Training Letter questions (SHORT_ANSWER + Groq evaluated)
    INSERT INTO quizes
    (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_course_id, v_paper_id, u2, g14,
     'Write a letter to the manager applying for the part-time job at the restaurant. In your letter, introduce yourself, explain why you are suitable, and ask about working hours.',
     NULL, NULL, NULL, NULL,
     'A semi-formal letter with a clear introduction, relevant personal skills or experience, and a polite request for information about the position.',
     'Semi-formal tone. Introduce yourself, state your relevant experience, and express enthusiasm for the role.',
     'SHORT_ANSWER', 'EASY'),

    (v_course_id, v_paper_id, u2, g15,
     'Write a letter to the shop manager complaining about the defective equipment. Describe the problem, explain how it has affected you, and say what action you want taken.',
     NULL, NULL, NULL, NULL,
     'A formal complaint letter specifying the product purchased, the defect encountered, the inconvenience caused, and a clear request for repair, replacement, or refund.',
     'Formal tone. Be specific about the fault and state clearly what resolution you expect.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u2, g16,
     'Write a letter to the insurance company about renewing your policy with changes. Explain what changes you want to make and ask for information about the new terms.',
     NULL, NULL, NULL, NULL,
     'A formal letter clearly identifying the policy, specifying the desired changes (e.g., coverage level, named drivers), and politely requesting confirmation of the new premium.',
     'Formal tone. Be precise about which changes you need and ask specific questions about the updated policy.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u2, g17,
     'Write a letter to thank your friend for their hospitality. Mention what you enjoyed most about the stay.',
     NULL, NULL, NULL, NULL,
     'An informal letter with a clear greeting, genuine expression of gratitude, specific personal details about enjoyable experiences, and a warm closing.',
     'Use an informal tone. Ensure you mention specific details of the visit to make it personal.',
     'SHORT_ANSWER', 'EASY'),

    (v_course_id, v_paper_id, u2, g18,
     'Write a letter to your friend asking for help with house sitting. Explain the dates and specific tasks needed.',
     NULL, NULL, NULL, NULL,
     'An informal letter clearly stating the dates of absence, specific house-sitting responsibilities (watering plants, checking mail, etc.), and a polite request for help.',
     'Informal tone. Be clear about the responsibilities like watering plants or checking mail.',
     'SHORT_ANSWER', 'EASY'),

    (v_course_id, v_paper_id, u2, g19,
     'Write a letter to the hiring manager explaining why you cannot accept the job offer.',
     NULL, NULL, NULL, NULL,
     'A formal letter politely declining the job offer, briefly explaining personal reasons without excessive detail, and expressing appreciation for the opportunity.',
     'Formal tone. Be polite and professional; you do not need to give exhaustive personal details.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u2, g20,
     'Write a letter to the organizer expressing your interest in the volunteer position.',
     NULL, NULL, NULL, NULL,
     'A semi-formal letter expressing genuine interest, highlighting relevant personal skills or experience, and requesting further information about the role.',
     'Semi-formal tone. Highlight how your specific skills can help the library or organization.',
     'SHORT_ANSWER', 'EASY'),

    (v_course_id, v_paper_id, u2, g21,
     'Write a letter to your former colleague declining their party invitation.',
     NULL, NULL, NULL, NULL,
     'A semi-formal letter expressing regret for being unable to attend, giving a brief reason, and wishing the colleague well for the event.',
     'Semi-formal tone. Express regret and offer well-wishes for the event.',
     'SHORT_ANSWER', 'EASY'),

    (v_course_id, v_paper_id, u2, g22,
     'Explain the issues you encountered at the sports club and what improvements you suggest.',
     NULL, NULL, NULL, NULL,
     'A formal complaint letter specifying issues with supporting details, requesting management action, and offering constructive suggestions for improvement.',
     'Formal tone. Be specific about dates/times and provide constructive suggestions for improvement.',
     'SHORT_ANSWER', 'MEDIUM'),

    (v_course_id, v_paper_id, u2, g23,
     'Write a letter to your former teacher asking for advice on organizing a school reunion.',
     NULL, NULL, NULL, NULL,
     'A formal or semi-formal letter clearly explaining the purpose of the reunion, asking for specific advice, and expressing appreciation for the teacher''s expected guidance.',
     'Formal/Semi-formal tone. Explain the purpose of the event and why their advice is valued.',
     'SHORT_ANSWER', 'MEDIUM');

    -- 8. Insert Task 2: Argumentative / Discussion Essay questions (ESSAY + Groq evaluated)
    INSERT INTO quizes
    (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_course_id, v_paper_id, u3, NULL,
     'Some people think that it is best to work for the same organization for one''s whole life. Others think that it is better to change jobs frequently. Discuss both views and give your opinion.',
     NULL, NULL, NULL, NULL,
     'A well-structured essay presenting arguments for job stability (security, expertise, loyalty) and job mobility (diverse skills, growth, higher earning), concluding with a clearly supported personal opinion.',
     'Contrast stability versus professional growth and diverse experience.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'In many cities, the use of video cameras in public places is being increased in order to reduce crime. Do the benefits of this outweigh the disadvantages?',
     NULL, NULL, NULL, NULL,
     'An essay evaluating surveillance benefits (crime deterrence, evidence gathering) against disadvantages (privacy erosion, government overreach), with a clear conclusion on whether benefits outweigh drawbacks.',
     'Evaluate if the reduction in crime justifies the loss of personal privacy.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'Fresh water has always been a limited resource in some parts of the world. Today, however, growing worldwide demand has made this a global problem. What are the causes of this and what measures can be taken?',
     NULL, NULL, NULL, NULL,
     'A problem-solution essay identifying causes (population growth, industrialisation, climate change) and proposing measures (desalination, conservation, policy regulation) with supporting detail.',
     'Focus on industrialization and population growth; suggest desalination or conservation.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'Some people believe that school children should be allowed to choose which subjects they study. Others believe that all children should study a fixed curriculum. Discuss both views and give your opinion.',
     NULL, NULL, NULL, NULL,
     'A balanced discussion of student autonomy (motivation, specialisation) versus fixed curriculum (foundational skills, equality), with a justified personal position.',
     'Balance the need for basic skills with the benefit of student motivation.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u3, NULL,
     'The best way to solve environmental problems is to increase the price of fuel. To what extent do you agree or disagree?',
     NULL, NULL, NULL, NULL,
     'An essay evaluating whether fuel price increases effectively change behaviour, considering economic impact on lower-income populations and alternative solutions such as green energy investment.',
     'Address whether high prices effectively change behavior or just punish the poor.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'Some people think that it is better to educate boys and girls in separate schools. Others, however, believe that mixed schools are better for children. Discuss both views and give your opinion.',
     NULL, NULL, NULL, NULL,
     'A balanced essay covering academic performance, social development, and preparation for adult life in both school types, concluding with a supported personal opinion.',
     'Discuss social development in mixed schools versus academic focus in single-sex schools.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u3, NULL,
     'In the future, translated books and movies will be more important than learning a foreign language. To what extent do you agree or disagree?',
     NULL, NULL, NULL, NULL,
     'An essay distinguishing the functional role of translation from the deeper cultural and communicative competence gained through language learning, with a clear and supported position.',
     'Address the difference between functional translation and the cultural depth of knowing a language.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'Large shopping malls are replacing small local shops. Do you think this is a positive or negative development?',
     NULL, NULL, NULL, NULL,
     'An essay evaluating the convenience and economic efficiency of malls against the cultural value, community identity, and entrepreneurship fostered by small local businesses.',
     'Compare the convenience/price of malls against the community value and uniqueness of small businesses.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u3, NULL,
     'Some people believe that the best way to reduce crime is to give longer prison sentences. Others think there are better ways to help reduce crime. Discuss both views.',
     NULL, NULL, NULL, NULL,
     'A discussion contrasting deterrence through harsher sentencing versus rehabilitation programmes and addressing root causes such as poverty and lack of education.',
     'Contrast the "deterrence" approach with "rehabilitation" and "root cause" (poverty/education) approaches.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'It is now possible to perform many everyday tasks, such as shopping and banking, online. Does the convenience of this outweigh the risks?',
     NULL, NULL, NULL, NULL,
     'An essay weighing efficiency and accessibility of online services against security risks (identity theft, fraud) and social isolation, with a clear conclusion.',
     'Evaluate efficiency versus security risks (identity theft) and social isolation.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u3, NULL,
     'Some believe that people should be allowed to work as long as they want, while others think there should be a mandatory retirement age. Discuss both views.',
     NULL, NULL, NULL, NULL,
     'A discussion of the value of experienced older workers and financial necessity versus the need to create job opportunities for younger generations and manage workforce productivity.',
     'Discuss the value of experience and financial need versus the need to open jobs for the youth.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'Advertising is now all around us. Some people think this is a negative development, while others disagree. To what extent do you agree or disagree?',
     NULL, NULL, NULL, NULL,
     'An essay exploring the manipulative aspects of advertising (consumerism, unrealistic standards) balanced against its informative role in a free-market economy.',
     'Discuss consumerism and manipulation versus the informative role of advertising in a free market.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u3, NULL,
     'The gap between the rich and the poor is widening in many countries. What problems does this cause? What are some solutions?',
     NULL, NULL, NULL, NULL,
     'A problem-solution essay identifying consequences (social unrest, unequal opportunity, reduced mobility) and proposing solutions such as progressive taxation, improved public education, or minimum wage policies.',
     'Identify issues like social unrest and unequal opportunity; suggest progressive taxation or education subsidies.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u3, NULL,
     'Is it better for children to grow up in the city or in the countryside? Give reasons for your answer.',
     NULL, NULL, NULL, NULL,
     'An essay comparing urban opportunities (education, culture, career) with rural benefits (safety, nature, community), with a clearly stated preference supported by reasoning.',
     'Contrast educational/cultural opportunities in cities with the health and safety benefits of the country.',
     'ESSAY', 'EASY'),

    (v_course_id, v_paper_id, u3, NULL,
     'Some people think that museums should be free for everyone. Others think that visitors should pay an entrance fee. Discuss both views.',
     NULL, NULL, NULL, NULL,
     'A discussion covering universal access to culture and education (free entry) against the financial sustainability argument (paid entry funds maintenance and acquisitions).',
     'Discuss the right to cultural education versus the practical need for funding and maintenance.',
     'ESSAY', 'MEDIUM');

    INSERT INTO quizes
    (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
    VALUES
    (v_course_id, v_paper_id, u4, NULL,
     'Successful sports stars and glamorous film stars are a role model for youngsters. Do you think it is a positive or negative development?',
     NULL, NULL, NULL, NULL,
     'A position essay examining positive effects (inspiration, work ethic) and negative effects (unrealistic lifestyle expectations, materialism) of celebrity role models on young people.',
     'Consider work ethic vs. unrealistic lifestyle expectations.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'Some people think that cultural traditions may be destroyed when they are used as money-making attractions aimed at tourists. Others believe it is the only way to save these traditions. Discuss both views.',
     NULL, NULL, NULL, NULL,
     'A discussion of commercialisation risks (dilution, inauthenticity) versus the financial benefit enabling preservation, with reference to specific examples where possible.',
     'Discuss the tension between authenticity and financial survival.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u4, NULL,
     'In the future, nobody will buy printed newspapers or books because they will be able to read everything they want online without paying. To what extent do you agree or disagree?',
     NULL, NULL, NULL, NULL,
     'An essay exploring the shift in media consumption, addressing digital access trends, the economics of publishing, and reasons why print may still survive in certain contexts.',
     'Address the shift in media consumption and the economic impact on publishing.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'Governments should spend more money on education than on recreation and sports. To what extent do you agree?',
     NULL, NULL, NULL, NULL,
     'An essay arguing the relative merits of education investment (economic productivity, social mobility) versus sports and recreation (public health, national pride), with a clearly defended stance.',
     'Argue whether long-term economic growth (education) outweighs immediate public health (sports).',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'International news is often focused on problems and emergencies. Should the news focus more on positive developments? To what extent do you agree?',
     NULL, NULL, NULL, NULL,
     'An essay discussing the watchdog and informational role of journalism versus the psychological harm of constant negativity, with a position on the appropriate balance.',
     'Discuss the "watchdog" role of news versus the psychological impact of constant negative information.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'The best way to improve health is to do more exercise. To what extent do you agree or disagree?',
     NULL, NULL, NULL, NULL,
     'An essay analysing the importance of exercise relative to other health factors such as diet, stress management, medical care, and environmental pollution.',
     'Analyze the role of exercise versus other factors like diet, pollution, and genetic factors.',
     'ESSAY', 'EASY'),

    (v_course_id, v_paper_id, u4, NULL,
     'Some people think that space exploration is a waste of money. Others believe it is necessary for the future of mankind. Discuss both views.',
     NULL, NULL, NULL, NULL,
     'A balanced discussion of the opportunity cost of space funding (earthly problems like poverty/climate) versus long-term benefits (survival, technology spinoffs), with a supported conclusion.',
     'Contrast immediate earthly needs (poverty/climate) with long-term survival and technological innovation.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u4, NULL,
     'In many countries, traditional foods are being replaced by international fast food. This has negative effects on both families and society. To what extent do you agree?',
     NULL, NULL, NULL, NULL,
     'An essay assessing health implications of fast food and the loss of cultural identity and family bonding associated with traditional food, arguing the degree to which negative effects dominate.',
     'Discuss the health implications and the loss of cultural identity and family bonding time.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'Is it the responsibility of individuals or the government to protect the environment? Give your opinion.',
     NULL, NULL, NULL, NULL,
     'A position essay arguing the necessity of top-down regulation and policy versus the power of individual consumer choices and lifestyle habits, with a clearly defended stance.',
     'Argue for the necessity of systemic regulation versus the power of consumer choice and personal habits.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'Technology has made it possible for many people to work from home. Do the advantages of this outweigh the disadvantages?',
     NULL, NULL, NULL, NULL,
     'An essay evaluating the benefits of remote work (flexibility, reduced commute, work-life balance) against disadvantages (social isolation, reduced collaboration, blurred work-life boundaries).',
     'Evaluate work-life balance and reduced commuting versus social isolation and lack of office collaboration.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'Some people believe that zoos are cruel and should be closed down. Others think zoos are helpful in protecting wild animals. Discuss both views.',
     NULL, NULL, NULL, NULL,
     'A discussion presenting animal welfare and captivity arguments against the role of zoos in conservation, research, and public education, with a balanced or clearly stated conclusion.',
     'Discuss animal rights and captivity versus conservation research and public education.',
     'ESSAY', 'MEDIUM'),

    (v_course_id, v_paper_id, u4, NULL,
     'Wealthy countries should provide more financial aid to poor countries. To what extent do you agree or disagree?',
     NULL, NULL, NULL, NULL,
     'An essay examining the moral and practical case for foreign aid (reducing inequality, global stability) against the risks of dependency, corruption, and misuse of funds.',
     'Analyze the moral obligation of rich nations versus the risks of creating dependency and corruption.',
     'ESSAY', 'HARD'),

    (v_course_id, v_paper_id, u4, NULL,
     'Nowadays, more and more people are using social media to keep in touch with others. Is this a positive or negative development?',
     NULL, NULL, NULL, NULL,
     'A position essay examining social media''s role in global connectivity and community-building versus its contribution to reduced face-to-face interaction, privacy concerns, and mental health issues.',
     'Discuss global connectivity versus the erosion of face-to-face social skills and privacy.',
     'ESSAY', 'EASY'),

    (v_course_id, v_paper_id, u4, NULL,
     'The excessive use of cars is causing serious problems in many cities. What are the causes and what measures can be taken?',
     NULL, NULL, NULL, NULL,
     'A causes-and-solutions essay identifying urban sprawl, poor public transport, and car culture as causes, and proposing congestion charges, investment in public transport, and cycling infrastructure as solutions.',
     'Identify causes like poor public transport and urban sprawl; suggest congestion charges or bike lanes.',
     'ESSAY', 'MEDIUM');

END $$;
