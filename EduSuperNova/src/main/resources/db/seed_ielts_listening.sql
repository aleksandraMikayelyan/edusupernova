DO $$
DECLARE
    v_course_id INTEGER;
    v_paper_id  INTEGER;
    u1 INTEGER; u2 INTEGER; u3 INTEGER; u4 INTEGER; u5 INTEGER; u6 INTEGER;
    g1 INTEGER; g2 INTEGER; g3 INTEGER; g4 INTEGER; g5 INTEGER; g6 INTEGER; g7 INTEGER; g8 INTEGER;
BEGIN
    SELECT idcourse INTO v_course_id FROM courses WHERE lower(description) = 'ielts listening section' LIMIT 1;

    -- Create IELTS Listening Paper
    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_course_id,
        'IELTS Listening',
        'You will hear a number of different recordings and you will have to answer questions on what you hear. There will be time for you to read the instructions and questions before you listen. You will hear each recording ONCE only.',
        'LISTENING',
        40,
        30,
        2
    ) ON CONFLICT DO NOTHING;

    SELECT idpaper INTO v_paper_id FROM papers WHERE idcourse = v_course_id AND lower(papername) = 'ielts listening' LIMIT 1;

    -- === LISTENING SKILL-BASED UNITS ===
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES 
        (v_course_id, 'Unit 1: Listening for Specific Details & Information', 'Summaries/ielts/listening/specific_details.txt', 1),
        (v_course_id, 'Unit 2: Understanding Main Ideas and Purpose', 'Summaries/ielts/listening/main_ideas.txt', 2),
        (v_course_id, 'Unit 3: Following Conversations & Discussions', 'Summaries/ielts/listening/conversations.txt', 3),
        (v_course_id, 'Unit 4: Academic Lectures & Note-taking', 'Summaries/ielts/listening/lectures.txt', 4),
        (v_course_id, 'Unit 5: Recognising Opinions, Attitudes & Inference', 'Summaries/ielts/listening/opinions_inference.txt', 5),
        (v_course_id, 'Unit 6: Advanced Listening Strategies & Accents', 'Summaries/ielts/listening/advanced_strategies.txt', 6)
    ON CONFLICT DO NOTHING;

    SELECT idunit INTO u1 FROM units WHERE title = 'Unit 1: Listening for Specific Details & Information' LIMIT 1;
    SELECT idunit INTO u2 FROM units WHERE title = 'Unit 2: Understanding Main Ideas and Purpose' LIMIT 1;
    SELECT idunit INTO u3 FROM units WHERE title = 'Unit 3: Following Conversations & Discussions' LIMIT 1;
    SELECT idunit INTO u4 FROM units WHERE title = 'Unit 4: Academic Lectures & Note-taking' LIMIT 1;
    SELECT idunit INTO u5 FROM units WHERE title = 'Unit 5: Recognising Opinions, Attitudes & Inference' LIMIT 1;
    SELECT idunit INTO u6 FROM units WHERE title = 'Unit 6: Advanced Listening Strategies & Accents' LIMIT 1;

    -- === 8 LISTENING SECTIONS WITH TRANSCRIPTS ===
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES
    (v_paper_id, 'Section 1: Coastal Flood Warning', 
    'Good afternoon. This is an automated emergency broadcast from the Brighton Coastal Protection Service, recorded at 2:00 PM on Thursday, the 14th of November. Due to a significant weather system moving in from the North Sea, combined with unusually high spring tides and sustained easterly winds reaching up to 50 miles per hour, we are issuing a severe flood warning for the seafront and surrounding low-lying areas this coming weekend.

While we have seen similar weather patterns in the past—most notably during the storms of 2014 and the minor surge in 2019—meteorological data suggests that the upcoming event could result in water levels exceeding those of the last decade. Consequently, local authorities and emergency teams will begin preparations immediately.

Specifically, heavy-duty flood barriers are scheduled to be installed along the main promenade starting at 6:00 PM this Friday. Please be aware that while the assembly begins then, the actual deployment across the road junctions won’t happen until Saturday morning. Because this process requires heavy machinery and large transport vehicles, the coastal road will be partially closed to traffic from Friday evening onwards. Diversions will be clearly marked, but we recommend using the inland bypass to avoid significant delays. We are advising all residents and business owners in the affected zones to take proactive measures. Most importantly, please ensure that all vehicles are moved away from the promenade and the lower ground-level car parks. These areas are at the highest risk of surge water. All vehicles must be cleared no later than 5:00 PM on Friday to allow our teams access. Any cars remaining after this time may be towed to the municipal impound lot at the owner’s expense.

Furthermore, if you live in a property directly facing the water, please do not leave valuable items—such as electronics, important documents, or sentimental belongings—in ground-floor rooms. Move them to an upper floor if possible. If your property does not have a second story, we suggest moving items onto high shelves or kitchen counters. We have seen in previous years that even a few inches of elevation can prevent thousands of pounds in damage.

For those requiring sandbags or further assistance with property protection, the local council depot on West Street will be open until midnight tonight. Please note that sandbags are limited to ten per household to ensure there is enough supply for everyone. You will need to bring proof of address, such as a utility bill, to collect them.

For continuous live updates throughout the weekend, please call our 24-hour hotline at 01273 555678. Our operators are trained to provide specific advice for different neighborhoods. Alternatively, you can monitor the situation on our official website at brightoncoast.gov.uk, where we will post hourly water level readings and road closure maps. We are also launching a new SMS alert system; you can sign up for this by texting 'FLOOD' to 88442.

We have also received inquiries regarding the local pier and the marina. Both will be closed to the public from Friday night until Monday morning. We ask that boat owners at the marina check their moorings today while the weather is still relatively calm, as access will be restricted once the winds pick up tomorrow afternoon.

We thank you for your cooperation and urge everyone to stay away from the sea wall during high tide for your own safety. The force of the waves can be deceptive and extremely dangerous. This message will repeat in sixty seconds.', 1),

    (v_paper_id, 'Section 2: AI in Healthcare Seminar', 
    'Dr. Michael Ross: Good morning, everyone. It’s a pleasure to see such a full house today. For those of you who don’t know me, I’m Dr. Michael Ross, and I’ve spent the last decade researching the intersection of technology and clinical practice. Today, I want to discuss a topic that is often met with both excitement and a fair bit of trepidation: Artificial Intelligence in modern healthcare.

Now, when we talk about AI, people often jump straight to science fiction—robots performing surgery without human intervention. But the reality is far more grounded, though no less impressive. Recent large-scale studies have demonstrated that AI algorithms can now identify specific malignancies in X-rays with a staggering 95% accuracy rate. To put that in perspective, that is on par with, and in some niche cases, superior to, the most experienced radiologists in the field. 

But it isn’t just about diagnostics. If we look at the pharmaceutical side of things, the traditional process for drug discovery is notoriously slow and incredibly expensive, often taking over a decade to bring a single molecule to market. However, by using machine learning to predict how different compounds will behave, we are now seeing this timeline compressed. AI is speeding up drug discovery dramatically, potentially saving millions of lives by getting treatments to patients years sooner than previously possible.

That said, we cannot ignore the "elephant in the room." As we integrate these systems, serious concerns persist regarding data privacy. Who owns the medical data used to train these models? Furthermore, there is the issue of algorithmic bias. If the data used to "teach" the AI isn’t diverse, the AI’s conclusions won''t be fair. We have to be vigilant.

I often get asked if doctors should be worried about their jobs. My answer is always a firm "no." In our view, AI should be viewed as a sophisticated tool—a "co-pilot," if you will. It should support doctors by handling data-heavy tasks, rather than replace the human touch, empathy, and complex reasoning that a physician provides.

Moving on, let’s look at the patient’s perspective. Many people worry that technology will lead to a "dehumanized" experience. However, by automating administrative tasks like paperwork, doctors actually have more quality time for face-to-face interaction. Furthermore, AI-driven personalized medicine allows us to tailor treatments to genetics. In hospitals using AI monitoring, we have seen a 20% reduction in adverse drug reactions compared to the old "one-size-fits-all" approach.

Regarding the cost-benefit analysis, the initial investment is undeniably substantial, costing millions for licenses and hardware. This makes administrators hesitant. However, through earlier disease detection and more efficient triaging, AI is projected to save the healthcare system 15 billion dollars over the next ten years. These savings can then be reinvested into frontline nursing and community care. 

Finally, the most significant impact may be in rural areas or the global south, where specialists are scarce. There, a nurse with a smartphone and AI tools can provide unprecedented levels of care. Thank you for your attention, let’s open the floor for some questions.', 2),

    (v_paper_id, 'Section 3: Industrial Revolution Student Discussion', 
    'Tutor: Welcome, both of you. Today we’re continuing our module on 18th-century history. I’d like to get your initial thoughts on the Industrial Revolution. It’s a polarizing topic, certainly. Liam, why don’t you start?

Liam (Student A): Well, looking at the primary sources from the 1830s, it’s hard to be positive. I believe the period caused widespread, terrible suffering. If you look at the textile mills in Northern England, the conditions were appalling. What strikes me most was the exploitation of children. Many were working twelve-hour shifts in dangerous conditions with very little food. It wasn’t just about hard work; it was the lack of any safety net or basic rights.

Tutor: A valid point, Liam. The social cost was indeed high. Sarah, do you share that purely pessimistic view?

Sarah: I understand where Liam is coming from, and the "dark satanic mills" are a well-documented reality. However, we have to look at the broader picture. In the long term, this period led to unprecedented economic growth and, eventually, much higher living standards for the working class. It was the birth of the middle class. Without the technological shifts in steam power and coal, we wouldn’t have the modern infrastructure we rely on today.

Liam: That’s true, Sarah, but I’d argue that the benefits didn’t trickle down for decades. For the first two generations, the average life expectancy in industrial cities like Manchester actually plummeted. People were moving from the countryside for "opportunity," but they ended up in overcrowded slums with no sanitation. So, while "economic growth" looks good on a graph, the lived reality for a family in 1820 was quite grim.

Sarah: I agree the transition was painful. But isn’t it also true that this suffering actually triggered the first major social reforms? It forced the government to step in. Before the Industrial Revolution, there was almost no labor legislation at all.

Tutor: That’s an excellent transition, Sarah. Let’s look at that. Liam, in your research, did you come across the Factory Act of 1833?

Liam: Yes, but even that was limited. It only banned children under the age of nine from working in silk mills—or rather, in most textile mills. And even then, it only limited older children to nine hours a day. It was a start, but it wasn’t exactly a revolution in workers’ rights.

Sarah: But Liam, it led to the appointment of factory inspectors! That was the first time the state actually went into private businesses to check on conditions. By 1844, we saw the introduction of the first health and safety laws, like requiring machinery to be fenced off to prevent accidents.

Tutor: Good. You’ve both highlighted the tension between economic progress and human cost. For our next seminar, I want you both to look specifically at the impact of the railway. Liam, focus on the displacement of rural communities, and Sarah, I’d like you to research the expansion of the postal service and communication. Let’s examine the social reforms that followed in more detail next time.', 3),

    (v_paper_id, 'Section 4: The Science of Sleep Lecture', 
    'Good morning. In today’s lecture, we’re going to delve into the fascinating and often misunderstood field of chronobiology, specifically focusing on the physiological and psychological architecture of human sleep. While we often view sleep as a state of total inactivity, it is, in fact, a period of intense neurological and biological labor that is essential for our survival.

To understand sleep, we must first look at its structure. Sleep is not a uniform state; rather, it is comprised of several distinct stages that the brain cycles through multiple times per night. These are broadly categorized into Non-REM and REM sleep. The initial stages of Non-REM are relatively light, but as we progress into Stage 3—often referred to as "Slow Wave Sleep" or deep sleep—the body undergoes a remarkable transformation. This stage is absolutely vital for physical restoration. During this time, the heart rate drops, breathing slows, and the body releases growth hormones. This is the window where tissue repair occurs and the immune system is bolstered. Without sufficient deep sleep, the body’s ability to recover from physical exertion or fight off infection is significantly compromised.

Following these stages, we enter REM, or Rapid Eye Movement sleep. This stage is distinct because brain activity spikes to levels nearly identical to when we are awake. REM is primarily associated with cognitive maintenance. It is during this phase that memory consolidation takes place—the process by which the brain turn short-term experiences into long-term memories. Furthermore, REM plays a crucial role in emotional regulation. It allows the brain to process difficult emotions and stressful events, acting as a form of nocturnal therapy. Interestingly, while the brain is hyperactive, the muscles in the limbs are temporarily paralyzed—a biological safeguard that prevents us from physically acting out our dreams.

Now, the question often arises: how much sleep is actually required? While individual needs can vary based on genetics, the consensus among sleep scientists is that the vast majority of adults require between seven and nine hours of consistent rest to function at an optimal level. Chronic sleep deprivation, even if it is only a deficit of one hour per night, has been linked to a litany of health issues, including increased cardiovascular risk and impaired executive function—the ability to make decisions and solve problems.

Finally, we must address the modern challenges to sleep hygiene, most notably the impact of technology. The human body operates on a circadian rhythm—a biological clock that is regulated by light. Specifically, our brains produce a hormone called melatonin in response to darkness, which signals to the body that it is time to wind down. However, the short-wavelength blue light emitted by smartphones, tablets, and laptop screens is particularly disruptive. This light suppresses melatonin production more aggressively than any other spectrum. Consequently, using these devices late in the evening effectively "tricks" the brain into thinking it is still daylight, making it significantly harder to transition into sleep. To mitigate this, experts recommend a "digital sunset"—avoiding screens at least sixty minutes before bedtime to allow the body’s natural chemistry to take over.

In our next session, we will explore the impact of caffeine and diet on these sleep cycles...', 4),

    (v_paper_id, 'Section 5: Benefits of Bilingualism', 
    'Good afternoon. In today’s session, we are going to explore a phenomenon that has shifted from being viewed as a potential cognitive burden to one of the most powerful tools for neurological development: bilingualism. For much of the 20th century, educators feared that teaching a child two languages simultaneously would lead to "linguistic confusion." However, modern neuroscience has debunked this, revealing that the bilingual brain is not only more efficient but structurally different.

Let’s start with the concept of "executive function." This is an umbrella term for the cognitive processes that allow us to plan, focus attention, and juggle multiple tasks successfully. Research consistently demonstrates that bilingual individuals possess a significantly more robust executive control system. Why is this? It’s because a bilingual person’s brain is constantly managing two active language systems. Even when speaking English, the Spanish or French side of the brain is "on," and the individual must actively suppress it. This constant "mental gymnastics" strengthens the prefrontal cortex, leading to superior multitasking abilities and a better capacity to filter out irrelevant information in noisy environments.

Moving on to the developmental stages, children raised in bilingual households often display what psychologists call "cognitive flexibility." In various studies, bilingual children were asked to sort objects by color and then suddenly switch to sorting them by shape. While monolingual children often struggled with the sudden change in rules, bilingual children adapted almost instantly. This heightened flexibility isn’t just about logic; it extends to creativity as well. Bilingual students frequently score higher on tasks requiring "divergent thinking"—the ability to come up with multiple solutions to a single problem.

Perhaps the most striking evidence of the bilingual advantage, however, is found in the field of gerontology—the study of aging. While learning a second language cannot "cure" or "prevent" the biological onset of Alzheimer’s or other forms of dementia, it appears to create a "cognitive reserve." A landmark study conducted in Toronto analyzed the medical records of hundreds of patients. The findings were startling: bilingual individuals tended to develop visible symptoms of dementia four to five years later than their monolingual counterparts. To be clear, their brains still showed the same physical signs of decay, but their executive control was so well-trained that they could function normally for much longer.

Furthermore, the benefits are not solely internal. There is a social and economic dimension to consider. In our increasingly globalized economy, the ability to bridge cultural gaps is invaluable. However, it’s important to note that these benefits are not reserved solely for those who learn a second language in infancy. While "native-like" fluency is harder to achieve in adulthood, the cognitive effort required for an adult to learn a new syntax and vocabulary provides a massive neurological workout, offering similar, albeit slightly different, protective benefits for the brain.

In our next lecture, we will examine the "Critical Period Hypothesis" and whether there truly is a cut-off age for language acquisition...', 5),

    (v_paper_id, 'Section 6: Coral Reef Conservation', 
    'Good morning. Today we examine the "rainforests of the sea"—coral reefs. Supporting 25% of marine life despite covering only 1% of the ocean floor, these ecosystems face an unprecedented decline. 

The primary threat is coral bleaching, caused by the breakdown of the symbiotic relationship with zooxanthellae algae. When temperatures rise by 1-2 degrees Celsius, corals expel these algae, which provide 90% of their nutrients. This leaves the coral white and vulnerable to starvation.

Furthermore, ocean acidification—the result of the ocean absorbing atmospheric CO2—is a "silent killer." Lower pH levels reduce carbonate ions, hindering calcification. This makes calcium carbonate skeletons brittle and slows growth, increasing susceptibility to storm damage.

Local solutions, such as Marine Protected Areas (MPAs), help by reducing overfishing and allowing grazers to control invasive seaweed. Some researchers are also trialing "assisted evolution" to breed heat-resistant strains. However, these are temporary measures. Long-term survival depends entirely on a global reduction in greenhouse gas emissions to stabilize temperatures. 

Next time, we will explore deep-sea hydrothermal vents and their unique inhabitants.', 6),

    (v_paper_id, 'Section 7: Renewable Energy Transition', 
   'Good morning. In today’s session, we are going to examine the global shift toward a carbon-neutral future, focusing specifically on the technological and economic drivers of the renewable energy transition. While the transition was once seen as a distant ideal, recent data suggests that the "green revolution" is accelerating at an unprecedented pace, with some nations serving as remarkable case studies for what is possible.

Take Denmark, for example. As of the mid-2020s, Denmark now generates over fifty percent of its total electricity from wind power alone. This achievement is not merely the result of favorable geography but is the product of decades of consistent policy and investment in offshore wind farms. By leveraging the consistent, high-velocity winds of the North Sea, Denmark has demonstrated that a modern industrial economy can function effectively while drastically reducing its reliance on fossil fuels.

Parallel to the success of wind energy is the extraordinary evolution of solar power. The economic landscape of the solar industry has been transformed over the last decade. The cost of photovoltaic solar panels has dropped dramatically—by nearly ninety percent in some markets. This is largely due to economies of scale in manufacturing and significant improvements in solar cell efficiency. Solar is no longer a niche, subsidized energy source; in many parts of the world, it is now the cheapest form of new electricity generation available, even outcompeting coal and natural gas on a purely financial basis.

However, despite these triumphs, we must address the "Achilles’ heel" of the renewable sector: the issue of intermittency. Unlike traditional power plants, which can provide a steady 'base load' of electricity, solar and wind are dependent on weather conditions. The sun does not always shine, and the wind does not always blow. This creates a significant challenge for grid stability. If the supply of energy fluctuates too wildly, it can lead to blackouts or require the expensive backup of gas-fired plants.

Consequently, the biggest challenge facing engineers today is not energy generation, but energy storage. We need a way to capture the excess energy produced during a sunny afternoon and release it during the evening peak. This is where new battery technology comes into play. While lithium-ion batteries—the same chemistry found in your smartphones—have dominated the market, they are often too expensive for long-term, large-scale grid storage. Fortunately, we are seeing rapid development in 'flow batteries' and 'solid-state' technologies, which promise higher capacities and longer lifespans.

Furthermore, we are exploring mechanical storage solutions, such as pumped hydro and compressed air, which use physical gravity or pressure to store energy. The race is now on to find a scalable, cost-effective storage solution that can bridge the gap between generation and consumption.

In our next lecture, we will look at the role of green hydrogen as a potential fuel for heavy industry and long-haul shipping...', 7),

    (v_paper_id, 'Section 8: Urban Farming Interview', 
    'Interviewer: Good morning. Dr. Rodriguez, what are the environmental benefits of urban farming? 

Expert: The main benefit is reducing "food miles." Currently, vegetables travel an average of 1,500 miles, causing high carbon emissions. Urban farms eliminate this and help mitigate the "urban heat island" effect.

Interviewer: And the social impact?

Expert: Community gardens strengthen social bonds across generations. More importantly, they improve mental wellbeing by reducing cortisol levels and anxiety. 

Interviewer: How did the pandemic change the perspective on this?

Expert: Before 2020, it was seen as a hobby. But supply chain disruptions proved that local production is vital for food security. In cities like London, allotment use rose by 30%. It is now seen as a pillar of urban resilience.

Interviewer: What are the main logistical challenges?

Expert: Space and soil contamination, such as heavy metals. To solve this, we use raised beds or hydroponics. While hydroponics are costlier to start, they can produce yields four times higher than traditional methods.

Interviewer: Next, we’ll discuss the costs of rooftop setups...', 8);

    -- Get group IDs
    SELECT id INTO g1 FROM question_groups WHERE title ILIKE '%Coastal Flood%' ORDER BY id DESC LIMIT 1;
    SELECT id INTO g2 FROM question_groups WHERE title ILIKE '%AI in Healthcare%' ORDER BY id DESC LIMIT 1;
    SELECT id INTO g3 FROM question_groups WHERE title ILIKE '%Industrial Revolution%' ORDER BY id DESC LIMIT 1;
    SELECT id INTO g4 FROM question_groups WHERE title ILIKE '%Science of Sleep%' ORDER BY id DESC LIMIT 1;
    SELECT id INTO g5 FROM question_groups WHERE title ILIKE '%Benefits of Bilingualism%' ORDER BY id DESC LIMIT 1;
    SELECT id INTO g6 FROM question_groups WHERE title ILIKE '%Coral Reef%' ORDER BY id DESC LIMIT 1;
    SELECT id INTO g7 FROM question_groups WHERE title ILIKE '%Renewable Energy%' ORDER BY id DESC LIMIT 1;
    SELECT id INTO g8 FROM question_groups WHERE title ILIKE '%Urban Farming%' ORDER BY id DESC LIMIT 1;

    -- ====================== 10 QUESTIONS PER SECTION ======================

    -- Unit 1 + Section 1 (Specific Details)
    -- Unit 1 + Section 1 (Specific Details) - Extended to 10 Questions
   INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u1, g1, 'When was the original emergency broadcast recorded?', 'Thursday morning', 'Thursday afternoon', 'Friday evening', 'Saturday morning', 'B', 'The text states: "recorded at 2:00 PM on Thursday."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u1, g1, 'The speaker compares the upcoming storm to which previous years?', '2010 and 2014', '2014 and 2019', '2019 and 2024', '2010 and 2019', 'B', 'The transcript mentions: "most notably during the storms of 2014 and the minor surge in 2019."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'When will the flood barriers be fully deployed across road junctions?', 'Friday at 5:00 PM', 'Friday at 6:00 PM', 'Saturday morning', 'Monday morning', 'C', 'Distractor alert: Assembly starts Friday, but "the actual deployment across the road junctions won’t happen until Saturday morning."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u1, g1, 'What is the recommended alternative for drivers avoiding the coastal road?', 'The municipal impound lot', 'The West Street depot', 'The inland bypass', 'The local marina', 'C', 'The text suggests: "we recommend using the inland bypass to avoid significant delays."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u1, g1, 'What might happen to cars left in the lower car parks after 5:00 PM Friday?', 'They will be moved to higher ground', 'They will be towed at the owner''s expense', 'They will be covered by the council', 'They will be locked in place', 'B', 'The warning states: "Any cars remaining after this time may be towed to the municipal impound lot at the owner’s expense."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'What should residents of single-story houses do with their valuables?', 'Take them to the council depot', 'Leave them in the kitchen', 'Place them on high shelves or counters', 'Lock them in a waterproof vehicle', 'C', 'The speaker suggests: "moving items onto high shelves or kitchen counters" if there is no second story.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'What is the maximum number of sandbags allowed per household?', 'Five', 'Ten', 'Twelve', 'Unlimited', 'B', 'The text specifies: "sandbags are limited to ten per household."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u1, g1, 'What must a resident provide to collect sandbags?', 'A valid passport', 'A utility bill', 'A coastal protection permit', 'A vehicle registration', 'B', 'The transcript says: "bring proof of address, such as a utility bill."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'How can residents sign up for the new SMS alert system?', 'By calling 01273 555678', 'By visiting the website', 'By texting ''FLOOD'' to 88442', 'By visiting the West Street depot', 'C', 'The instruction is: "sign up for this by texting ''FLOOD'' to 88442."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'When are boat owners advised to check their moorings?', 'Today', 'Tomorrow afternoon', 'Friday night', 'Monday morning', 'A', 'The text urges: "boat owners at the marina check their moorings today while the weather is still relatively calm."', 'MULTIPLE_CHOICE', 'HARD');

   INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u4, g2, 'How long has Dr. Michael Ross been researching the connection between technology and clinical practice?', 'Five years', 'Ten years', 'Over a decade', 'Two decades', 'B', 'The speaker explicitly states he has spent the "last decade" researching this.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g2, 'What is the accuracy rate of AI in identifying malignancies in X-rays?', '85%', '90%', '95%', '99%', 'C', 'The speaker mentions that AI algorithms can identify specific malignancies with a "95% accuracy rate."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g2, 'In what way is machine learning helping the pharmaceutical industry?', 'By increasing the cost of molecules', 'By replacing all laboratory researchers', 'By compressing the drug discovery timeline', 'By making drugs more expensive', 'C', 'The speaker explains that machine learning predicts compound behavior, allowing the "timeline [to be] compressed."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g2, 'What is described as the "elephant in the room" regarding AI integration?', 'Lack of medical training', 'Concerns regarding data privacy', 'The speed of the internet', 'The weight of hardware', 'B', 'The speaker uses this idiom to introduce "serious concerns persist regarding data privacy."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g2, 'How does the speaker define "algorithmic bias" in this context?', 'AI preferring certain brands', 'Unfair conclusions due to non-diverse data', 'The speed of the algorithm', 'A doctor''s dislike of technology', 'B', 'The speaker explains that if the data used to teach the AI isn''t diverse, the results "won''t be fair."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g2, 'What metaphor does Dr. Ross use for the role of AI?', 'A scientific pilot', 'A replacement worker', 'A sophisticated co-pilot', 'A digital surgeon', 'C', 'The speaker suggests AI should be viewed as a "co-pilot" that supports the physician.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g2, 'How can AI lead to more human interaction in medicine?', 'By requiring more technical staff', 'By automating paperwork and administration', 'By forcing patients to wait in groups', 'By allowing robots to talk to patients', 'B', 'Automating administrative tasks gives doctors "more quality time for face-to-face interaction."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g2, 'What reduction has been seen in adverse drug reactions using AI?', '10%', '15%', '20%', '50%', 'C', 'The text cites a "20% reduction in adverse drug reactions."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g2, 'What is the projected saving for the healthcare system over the next decade?', '15 million dollars', '1.5 billion dollars', '15 billion dollars', '150 billion dollars', 'C', 'The speaker projects a saving of "15 billion dollars" over the next ten years.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g2, 'Where does the speaker believe the "true revolution" of AI lies?', 'In wealthy urban hospitals', 'In pharmaceutical headquarters', 'In rural areas or the global south', 'In robotic surgery', 'C', 'He identifies these areas as the "true revolution" because AI helps where specialists are scarce.', 'MULTIPLE_CHOICE', 'EASY');

--Section 3:

-- Unit 3 + Section 3 (Industrial Revolution) - 10 Questions
INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u3, g3, 'What is Liam’s primary reason for his negative view of the Industrial Revolution?', 'Lack of technological progress', 'Exploitation of children in mills', 'High cost of living', 'Decrease in the middle class', 'B', 'Liam specifically highlights the 12-hour shifts and dangerous conditions for children in textile mills.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u3, g3, 'Sarah argues that the Industrial Revolution was beneficial because it...', 'Eliminated the need for coal', 'Led to immediate safety nets', 'Created the foundation for modern infrastructure', 'Encouraged rural living', 'C', 'Sarah mentions that without shifts in steam and coal, we wouldn''t have modern infrastructure.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g3, 'What happened to life expectancy in cities like Manchester initially?', 'It remained stable', 'It increased slightly', 'It plummeted due to poor sanitation', 'It improved for rural migrants', 'C', 'Liam notes that life expectancy plummeted in cities due to overcrowded slums and no sanitation.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g3, 'According to Sarah, what was a positive side effect of the period’s suffering?', 'It reduced slum populations', 'It triggered major social reforms', 'It made children more skilled', 'It discouraged private business', 'B', 'Sarah argues that visible suffering forced the government to introduce the first labor legislation.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u3, g3, 'What was one limitation of the Factory Act of 1833 mentioned by Liam?', 'It only applied to adult men', 'It banned work for everyone under 16', 'It only limited older children to nine hours', 'It was ignored by factory owners', 'C', 'Liam notes that the act was limited because it still allowed older children to work nine hours.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u3, g3, 'The 1833 Act was significant to Sarah because it introduced...', 'Free education', 'Factory inspectors', 'A minimum wage', 'A ban on steam power', 'B', 'Sarah emphasizes this was the first time the state appointed inspectors to check private businesses.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g3, 'What safety requirement was introduced by the year 1844?', 'Mandatory vaccinations', 'Fencing off machinery', 'Three meals a day', 'Banning night work', 'B', 'Sarah cites the requirement for "machinery to be fenced off" as a key health and safety law.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g3, 'What research task has the Tutor assigned specifically to Liam?', 'The growth of the postal service', 'Displacement of rural communities by railways', 'Interviewing modern workers', 'History of factory inspectors', 'B', 'The tutor tells Liam to "focus on the displacement of rural communities" caused by the railway.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g3, 'Sarah’s research for the next session will focus on...', 'Coal mining techniques', 'Middle class history', 'The postal service and communication', 'Agricultural reforms', 'C', 'The tutor explicitly asks Sarah to research the "expansion of the postal service and communication."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u3, g3, 'How does the Tutor summarize the students’ discussion?', 'A complete agreement', 'Inaccurate research', 'A balance between social cost and economic progress', 'A heated personal argument', 'C', 'The tutor concludes by noting the tension between "economic progress and human cost."', 'MULTIPLE_CHOICE', 'EASY');

-- Unit 4 + Section 4 (The Science of Sleep) - 10 Questions
INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u4, g4, 'How does the speaker define the field of chronobiology?', 'The study of dream patterns', 'The architecture of human sleep', 'The history of immune function', 'The chemistry of caffeine', 'B', 'The lecturer introduces the field by focusing on the "physiological and psychological architecture of human sleep."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g4, 'What is a key characteristic of Stage 3 Non-REM sleep?', 'High brain activity', 'Muscle paralysis', 'Release of growth hormones', 'Vivid dreaming', 'C', 'During Stage 3 (Slow Wave Sleep), the body releases growth hormones for tissue repair.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g4, 'What is the primary role of REM sleep in cognitive health?', 'Physical restoration', 'Memory consolidation', 'Lowering heart rate', 'Boosting the immune system', 'B', 'The speaker states that REM is where "memory consolidation takes place."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g4, 'Why are the limb muscles paralyzed during REM sleep?', 'To conserve energy', 'To repair muscle tissue', 'To prevent acting out dreams', 'To increase blood flow to the brain', 'C', 'Paralysis is described as a "biological safeguard that prevents us from physically acting out our dreams."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g4, 'How much sleep do most adults require for optimal functioning?', '5 to 7 hours', '7 to 9 hours', '8 to 10 hours', 'Exactly 8 hours', 'B', 'The consensus among scientists is that the vast majority of adults need "between seven and nine hours."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g4, 'What is "executive function" as defined in the lecture?', 'The heart''s rhythm during rest', 'The process of acting out dreams', 'Problem-solving and decision-making', 'The production of melatonin', 'C', 'The speaker defines it as "the ability to make decisions and solve problems."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g4, 'Which hormone signals to the body that it is time to sleep?', 'Adrenaline', 'Growth hormone', 'Melatonin', 'Caffeine', 'C', 'The brain produces melatonin in response to darkness to signal it is time to wind down.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g4, 'Why is blue light from screens particularly disruptive to sleep?', 'It increases heart rate', 'It causes muscle paralysis', 'It suppresses melatonin production', 'It speeds up REM cycles', 'C', 'Blue light "suppresses melatonin production more aggressively than any other spectrum."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g4, 'What does the term "digital sunset" refer to?', 'Watching the sun set on a screen', 'Using screens only in the morning', 'Avoiding screens 60 minutes before bed', 'Using night-mode settings', 'C', 'Experts recommend a "digital sunset—avoiding screens at least sixty minutes before bedtime."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g4, 'What will be discussed in the next session?', 'The history of the smartphone', 'Impact of caffeine and diet on sleep', 'Evolutionary reasons for dreaming', 'Advanced surgical techniques', 'B', 'The lecture concludes by saying the next session will explore "the impact of caffeine and diet on these sleep cycles."', 'MULTIPLE_CHOICE', 'EASY');

-- Unit 5 + Section 5 (Bilingualism) - 10 Questions
INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u4, g5, 'What was the primary concern of 20th-century educators regarding bilingual children?', 'Lower IQ scores', 'Linguistic confusion', 'Physical health issues', 'Loss of native culture', 'B', 'The speaker notes a historical fear that teaching two languages would lead to "linguistic confusion."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g5, 'How does the speaker define "executive function"?', 'Multilingual ability', 'Processes for planning and focus', 'Auditory cortex structure', 'Reading speed', 'B', 'It is defined as an umbrella term for planning, focusing attention, and juggling tasks.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g5, 'What "mental gymnastics" must a bilingual brain perform?', 'Constant translation', 'Suppressing the unused language', 'Subconscious learning', 'Mathematical switching', 'B', 'Bilinguals must actively suppress the side of the brain not currently in use.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g5, 'Which brain region is strengthened by bilingualism?', 'Visual cortex', 'Prefrontal cortex', 'Cerebellum', 'Brainstem', 'B', 'Constant language management strengthens the prefrontal cortex.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g5, 'How did bilingual children perform in sorting studies?', 'Slower but accurate', 'Adapted faster to rule changes', 'Could only sort by color', 'Refused new instructions', 'B', 'Bilingual children displayed "cognitive flexibility" by adapting almost instantly to new rules.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g5, 'What is "divergent thinking" as described in the lecture?', 'Sustained attention', 'Generating multiple solutions', 'Linguistic loss', 'Simultaneous thinking', 'B', 'It is the capacity to come up with multiple creative solutions to a single problem.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g5, 'What did the Toronto study find regarding dementia?', 'It prevents Alzheimer''s', 'Symptoms appeared 4-5 years later', 'Brains stayed physically younger', 'Monolinguals managed better', 'B', 'Bilinguals developed visible symptoms 4 to 5 years later than monolinguals.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g5, 'The term "cognitive reserve" refers to...', 'A backup vocabulary', 'A mental buffer against aging', 'The grammar-learning region', 'Energy conservation', 'B', 'It describes a resilience that allows the brain to function normally for longer despite physical decay.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g5, 'Can adults gain neurological benefits from a second language?', 'No, the brain is too rigid', 'Yes, through cognitive effort', 'Only if they move abroad', 'No, only social benefits', 'B', 'The cognitive effort required for an adult to learn syntax provides a "massive neurological workout."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g5, 'What will the next lecture examine?', 'Economic benefits', 'The Critical Period Hypothesis', 'History of Toronto medicine', 'Trilingual households', 'B', 'The concluding sentence states they will discuss the "Critical Period Hypothesis."', 'MULTIPLE_CHOICE', 'EASY');

-- Unit 6 + Section 6 (Coral Reef Conservation) - 10 Questions
INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u4, g6, 'What percentage of marine life is supported by coral reefs?', 'Less than 1%', 'Approximately 25%', 'Up to 90%', 'Nearly 50%', 'B', 'The lecture states that reefs support "approximately twenty-five percent of all marine life."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g6, 'What is the relationship between coral polyps and zooxanthellae?', 'Parasitic', 'Competitive', 'Symbiotic', 'Predatory', 'C', 'The speaker describes the connection as a "symbiotic relationship" where both organisms benefit.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g6, 'How much of a coral’s nutritional needs are provided by algae?', '10%', '25%', '50%', '90%', 'D', 'The algae provide corals with "up to ninety percent of their nutritional requirements."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g6, 'What temperature increase can trigger the coral bleaching process?', '0.5 degrees Celsius', '1 to 2 degrees Celsius', '5 degrees Celsius', '10 degrees Celsius', 'B', 'Bleaching can occur when temperatures rise "by as little as one or two degrees Celsius."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g6, 'Why does ocean acidification make corals more vulnerable to storm damage?', 'It makes their skeletons brittle', 'It increases the frequency of storms', 'It makes the water too salty', 'It prevents fish from grazing', 'A', 'Acidification hinders calcification, making skeletons "brittle and grow much slower."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g6, 'Which chemical process is hindered by the lowering of ocean pH?', 'Photosynthesis', 'Assisted evolution', 'Calcification', 'Greenhouse effect', 'C', 'Lower pH reduces carbonate ions, which are essential for "the process of constructing their rigid calcium carbonate skeletons."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g6, 'How do Marine Protected Areas (MPAs) specifically help the coral?', 'By cooling the water temperature', 'By reducing pressure from overfishing', 'By blocking greenhouse gases', 'By preventing all tourism', 'B', 'MPAs reduce pressure from overfishing and destructive tourism, allowing reefs to recover.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g6, 'What is the goal of "assisted evolution" in coral research?', 'To prevent algae from entering the coral', 'To move reefs to deeper water', 'To breed heat-resistant coral strains', 'To increase the acidity of the water', 'C', 'It involves "breeding heat-resistant coral strains in laboratories to be replanted."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g6, 'According to the lecturer, local conservation efforts are only...', 'A long-term solution', 'A waste of time', 'A "band-aid" solution', 'The primary goal', 'C', 'The speaker describes them as "merely ''band-aid'' solutions if the root cause is not addressed."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g6, 'What will be the focus of the next lecture session?', 'Rainforest ecosystems', 'Greenhouse gas statistics', 'Deep-sea hydrothermal vents', 'Coastal tourism management', 'C', 'The speaker concludes by stating they will "shift our focus to deep-sea hydrothermal vents."', 'MULTIPLE_CHOICE', 'EASY');

-- Unit 7 + Section 7 (Renewable Energy Transition) - 10 Questions
INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u4, g7, 'What percentage of Denmark''s electricity is now provided by wind power?', 'Over 10%', 'Exactly 25%', 'Over 50%', 'Nearly 90%', 'C', 'The speaker notes that Denmark generates "over fifty percent of its total electricity from wind power alone."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g7, 'According to the lecture, what has been a major factor in the dropping cost of solar panels?', 'Government tax increases', 'Economies of scale in manufacturing', 'The discovery of new oil reserves', 'A decrease in solar cell efficiency', 'B', 'The lecturer attributes the price drop to "economies of scale in manufacturing and significant improvements in solar cell efficiency."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g7, 'How much has the cost of solar panels decreased in some markets?', 'By 10%', 'By 50%', 'By nearly 90%', 'By 100%', 'C', 'The cost has dropped "by nearly ninety percent in some markets."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u4, g7, 'What does the speaker refer to as the "Achilles’ heel" of renewable energy?', 'The high cost of installation', 'The issue of intermittency', 'The lack of skilled engineers', 'The noise produced by wind farms', 'B', 'Intermittency—the fact that wind and sun are not constant—is identified as the primary weakness.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g7, 'Why is grid stability a concern for renewable energy sources?', 'They produce too much steady power', 'They are weather-dependent', 'They use too much water', 'They only work in Denmark', 'B', 'Because they are "weather-dependent," the supply fluctuates, which can threaten the stability of the power grid.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g7, 'What is the main limitation of lithium-ion batteries for grid-scale storage?', 'They are too small for smartphones', 'They are often too expensive', 'They cannot be recharged', 'They only work with solar power', 'B', 'The speaker states that lithium-ion chemistry is "often too expensive for long-term, large-scale grid storage."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g7, 'Which new battery technologies are mentioned as having rapid development?', 'Lead-acid and alkaline', 'Flow batteries and solid-state', 'Hydrogen and oxygen cells', 'Mechanical and hydro batteries', 'B', 'The lecture mentions "rapid development in ''flow batteries'' and ''solid-state'' technologies."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g7, 'What is an example of a mechanical storage solution?', 'Solar cells', 'Flow batteries', 'Pumped hydro', 'Lithium-ion', 'C', 'The speaker cites "pumped hydro and compressed air" as examples of mechanical storage.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u4, g7, 'What is currently the primary goal for engineers in the renewable sector?', 'Finding more locations for wind farms', 'Finding a scalable, cost-effective storage solution', 'Increasing the price of solar power', 'Reducing the efficiency of batteries', 'B', 'The race is on to find a storage solution that can "bridge the gap between generation and consumption."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u4, g7, 'What will the next lecture focus on?', 'The history of coal mining', 'Green hydrogen in heavy industry', 'The design of smartphones', 'How to install domestic solar panels', 'B', 'The speaker ends by saying they will look at "the role of green hydrogen as a potential fuel for heavy industry."', 'MULTIPLE_CHOICE', 'EASY');

-- Unit 8 + Section 8 (Urban Farming Interview) - 10 Questions
INSERT INTO quizes (idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES
(v_course_id, v_paper_id, u2, g8, 'What is the "average distance" a vegetable travels in the current global system?', '150 miles', '500 miles', '1,500 miles', '3,000 miles', 'C', 'The expert states that "the average vegetable travels over 1,500 miles."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u2, g8, 'How does urban farming help the city''s temperature?', 'By creating wind tunnels', 'By mitigating the heat island effect', 'By increasing humidity', 'By reflecting sunlight away', 'B', 'Dr. Rodriguez mentions that urban farms "mitigate the urban heat island effect."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u2, g8, 'According to the expert, community gardens are most effective at...', 'Generating profit', 'Strengthening social bonds', 'Replacing supermarkets', 'Reducing noise pollution', 'B', 'The gardens are described as "powerful tools for social cohesion" that "strengthen social bonds."', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u2, g8, 'What specific physiological change is linked to gardening?', 'Lower cortisol levels', 'Increased heart rate', 'Improved eyesight', 'Higher adrenaline', 'A', 'Engaging with the soil has been shown to "reduce cortisol levels."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u2, g8, 'How did city planners view urban gardens before the year 2020?', 'As essential infrastructure', 'As a "nice-to-have" hobby', 'As a health hazard', 'As a waste of water', 'B', 'Before 2020, planners viewed them as a "''nice-to-have'' hobby."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u2, g8, 'What was the increase in allotment use in cities like London during the pandemic?', '10%', '15%', '30%', '50%', 'C', 'The expert notes a "30% increase in the use of allotment spaces."','MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u2, g8, 'What is the primary concern regarding soil in vacant industrial lots?', 'It is too sandy', 'It contains heavy metals', 'It lacks any water', 'It is too expensive to buy', 'B', 'Dr. Rodriguez explains that "the soil in vacant lots contains heavy metals like lead."', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u2, g8, 'What alternative to traditional soil-based farming is suggested for contaminated areas?', 'Greenhouse glass', 'Vertical digging', 'Hydroponic systems', 'Importing rural soil', 'C', 'The expert suggests using "raised beds or hydroponic systems" where soil quality is poor.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u2, g8, 'How do the yields of hydroponic systems compare to traditional farming?', 'They are the same', 'They are slightly lower', 'They are twice as high', 'They are four times higher', 'D', 'The expert states that "the yields can be up to four times higher than traditional farming."', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u2, g8, 'What will be the topic of the next segment of the interview?', 'Rural farming history', 'Hydroponic chemical safety', 'Costs of rooftop farm setups', 'The impact of heavy metals on health', 'C', 'The interviewer ends by saying they will look at "the specific costs of setting up a rooftop farm."', 'MULTIPLE_CHOICE', 'EASY');
END $$;