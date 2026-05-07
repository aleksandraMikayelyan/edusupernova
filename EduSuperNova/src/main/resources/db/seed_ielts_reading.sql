DO $$
DECLARE
    v_course_id INTEGER;
    v_paper_id  INTEGER;
    u1 INTEGER; u2 INTEGER; u3 INTEGER; u4 INTEGER; u5 INTEGER; u6 INTEGER;
    g1 INTEGER; g2 INTEGER; g3 INTEGER; g4 INTEGER; g5 INTEGER; 
    g6 INTEGER; g7 INTEGER; g8 INTEGER; g9 INTEGER;
BEGIN
    -- Resolve Course & Paper
    SELECT idcourse INTO v_course_id FROM courses WHERE lower(description) = 'ielts reading section' LIMIT 1;

    INSERT INTO papers (idcourse, papername, instructions, format, totalquestions, timelimitminutes, orderindex)
    VALUES (
        v_course_id,
        'IELTS Reading',
        'Read the three passages below and answer the questions that follow. Each passage has a number of questions. Choose the correct answer A, B, C, or D for each question.',
        'MCQ',
        40,
        60,
        1
    );

    SELECT idpaper INTO v_paper_id FROM papers WHERE idcourse = v_course_id AND lower(papername) = 'ielts reading' LIMIT 1;

    IF v_course_id IS NULL OR v_paper_id IS NULL THEN
        RAISE EXCEPTION 'Course or Paper not found!';
    END IF;

    -- === 1. INSERT UNITS ===
    INSERT INTO units (idcourse, title, summary_path, queue)
    VALUES 
        (v_course_id, 'Unit 1: Reading for Main Ideas and Purpose', 'Summaries/ielts/reading/main_ideas.txt', 1),
        (v_course_id, 'Unit 2: Understanding Detailed Information', 'Summaries/ielts/reading/detailed_info.txt', 2),
        (v_course_id, 'Unit 3: Inference and Writer’s Opinion', 'Summaries/ielts/reading/inference_opinion.txt', 3),
        (v_course_id, 'Unit 4: Vocabulary in Context', 'Summaries/ielts/reading/vocabulary_context.txt', 4),
        (v_course_id, 'Unit 5: Scientific and Technical Passages', 'Summaries/ielts/reading/scientific_tech.txt', 5),
        (v_course_id, 'Unit 6: Social Science and Historical Passages', 'Summaries/ielts/reading/social_historical.txt', 6)
    ON CONFLICT DO NOTHING;


    SELECT idunit INTO u1 FROM units WHERE title = 'Unit 1: Environment & Climate Change' LIMIT 1;
    SELECT idunit INTO u2 FROM units WHERE title = 'Unit 2: Science & Technology' LIMIT 1;
    SELECT idunit INTO u3 FROM units WHERE title = 'Unit 3: History & Society' LIMIT 1;
    SELECT idunit INTO u4 FROM units WHERE title = 'Unit 4: Health & Psychology' LIMIT 1;
    SELECT idunit INTO u5 FROM units WHERE title = 'Unit 5: Education & Learning' LIMIT 1;
    SELECT idunit INTO u6 FROM units WHERE title = 'Unit 6: Biodiversity & Nature' LIMIT 1;

    -- === 2. INSERT QUESTION GROUPS (Passages) ===
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES
    (v_paper_id, 'Rising Seas and Coastal Communities', 
    'Climate change is causing sea levels to rise at an accelerating rate, posing one of the most serious environmental threats of the 21st century. Low-lying islands and densely populated coastal cities face increasing threats from flooding, coastal erosion, and storm surges. According to data from the Intergovernmental Panel on Climate Change (IPCC), global sea levels have risen by approximately 20 centimetres since 1900, with the rate of increase more than doubling in the last two decades. This rapid rise is primarily driven by the melting of glaciers and polar ice sheets, together with the thermal expansion of seawater as ocean temperatures continue to climb.

The consequences for human populations are already visible and are expected to intensify dramatically. In low-lying delta regions such as Bangladesh, entire communities have been forced to abandon their homes as saline intrusion destroys agricultural land and frequent flooding becomes the norm. Similarly, the Maldives, a nation composed of coral atolls whose highest point is only a few metres above sea level, faces an existential threat. The government has already begun planning for the possible relocation of its population, raising profound questions about national identity and cultural survival.

Scientists warn that without substantial and immediate reductions in greenhouse gas emissions, many coastal regions could become uninhabitable by 2100. Cities such as Miami, Jakarta, and Alexandria are particularly vulnerable, with projections suggesting that hundreds of millions of people worldwide may be displaced. This phenomenon, sometimes referred to as "climate migration", is likely to become one of the defining social and political issues of the century. The economic costs are equally staggering. Coastal infrastructure, including ports, roads, and residential areas, faces damage running into trillions of dollars.

In response, governments and engineers have proposed various adaptation strategies. These include the construction of massive sea walls and flood barriers, as seen in projects in the Netherlands and parts of Japan. Another popular approach is ecosystem-based adaptation, such as the large-scale restoration of mangrove forests, which act as natural buffers against waves and storms while also supporting biodiversity and fisheries. However, many experts argue that such measures may only delay the inevitable in the most vulnerable areas. They emphasise that adaptation alone is insufficient and must be combined with aggressive mitigation efforts to limit global warming.

The social dimension of sea-level rise is particularly complex. Vulnerable communities, often in developing countries, typically contribute the least to global emissions yet suffer the most severe impacts. This has led to increasing calls for "climate justice" and demands that wealthier nations provide financial and technical support to those most at risk. International agreements such as the Paris Accord acknowledge these disparities, yet progress on funding adaptation in poorer nations has been slower than hoped.

Furthermore, the psychological effects on affected populations should not be underestimated. The constant threat of losing one’s home creates anxiety and a sense of powerlessness, especially among younger generations who feel they are inheriting an uncertain future. Educational programmes and community resilience initiatives are being developed to help people adapt mentally as well as physically.

In conclusion, while technological solutions and natural barriers offer some protection, the long-term outlook depends heavily on humanity’s ability to curb carbon emissions. As sea levels continue to rise, the world may witness unprecedented population movements and geopolitical tensions over land and resources. Coastal communities around the globe are on the frontline of climate change, serving as a stark reminder of the urgent need for collective global action.', 1),
    
    (v_paper_id, 'Artificial Intelligence in Healthcare', 
'Artificial intelligence is transforming modern medicine at an unprecedented pace, offering new possibilities for diagnosis, treatment, and medical research. Machine learning algorithms can now analyse medical scans and detect various forms of cancer with higher accuracy than many human radiologists, sometimes identifying subtle patterns that even experienced doctors might miss. These systems are trained on thousands of images and continue to improve as they process more data.

One of the most significant impacts of AI is in the field of drug discovery. Traditionally, developing a new medicine takes over a decade and costs billions of dollars. However, AI is dramatically changing this process by predicting how different compounds will interact with the human body, thereby reducing development time from years to months. This acceleration not only lowers costs but also brings life-saving treatments to patients much faster. Several pharmaceutical companies have already reported success in using AI to identify promising drug candidates for diseases ranging from Alzheimer’s to rare genetic disorders.

Despite these remarkable advances, concerns remain about the widespread adoption of artificial intelligence in healthcare. Data privacy is a major issue, as medical records contain highly sensitive personal information. There are fears that patient data could be misused or inadequately protected when shared with technology companies. Additionally, serious ethical questions arise when machines are involved in life-critical decisions. Who should be held responsible if an AI system makes a wrong diagnosis or recommends an inappropriate treatment — the doctor, the hospital, or the software developer?

Another contentious issue is the potential impact on employment. Some healthcare professionals fear that AI could lead to significant job losses, particularly in areas such as radiology and routine diagnostic work. On the other hand, many experts argue that AI should be viewed as a supportive tool rather than a replacement. By handling repetitive and time-consuming administrative tasks, such as analysing routine scans or managing patient records, AI can free doctors to spend more time on direct patient care, complex decision-making, and building meaningful doctor-patient relationships.

The integration of AI into healthcare also raises important questions about bias and fairness. Because machine learning systems learn from existing data, they can unintentionally reproduce and even amplify existing biases in healthcare. For example, if most training data comes from Western populations, the system may perform less accurately for patients from different ethnic backgrounds. Researchers are now working to develop more diverse and representative datasets to address this problem.

Regulation presents another challenge. Governments and medical organisations are struggling to create appropriate frameworks to ensure that AI tools are safe, effective, and ethically sound before they are used in clinical settings. Striking the right balance between encouraging innovation and protecting patients is proving difficult.

Looking ahead, the future of AI in medicine appears promising but complex. While it has the potential to improve healthcare outcomes, reduce costs, and make quality medical services more accessible, its successful integration will depend on addressing technical, ethical, and social concerns. Most experts agree that the greatest benefits will come not from replacing human doctors, but from creating a collaborative model in which artificial intelligence and medical professionals work together to deliver better patient care.', 2),
    
    (v_paper_id, 'The Industrial Revolution and Urbanization', 
   'The Industrial Revolution fundamentally changed human society, marking a major turning point in history. Beginning in Britain in the late 18th century, it rapidly spread to other parts of Europe and North America. This period saw a dramatic shift from an agricultural economy to one dominated by industry and manufacturing.

The revolution was driven by a combination of technological innovations, such as the steam engine, spinning jenny, and power loom, which dramatically increased production capacity. Factories sprang up across the country, creating a strong demand for labour. This demand triggered a massive migration of people from rural areas to urban centres in search of work. As a result, cities grew at an unprecedented rate, a process known as urbanization. Towns such as Manchester and Birmingham expanded rapidly, becoming major industrial hubs.

While the Industrial Revolution brought significant economic growth and technological progress, its social consequences were profound and often negative. Working conditions in the new factories were frequently appalling. Workers, including large numbers of women and children, laboured for long hours in dangerous environments with little safety protection. Child labour became widespread, with young children working in coal mines and textile factories under harsh conditions. Overcrowded slums developed around industrial areas, leading to poor sanitation, widespread disease, and high mortality rates.

Despite these HARDships, the period also saw improvements in living standards for some sections of society. The rise of the middle class created new opportunities, and increased production made goods more affordable. Technological advances eventually led to better transport systems, including railways, which further accelerated economic development and connected distant regions.

Historians continue to debate the overall impact of the Industrial Revolution. Some argue that, in the long term, it laid the foundations for modern prosperity and raised living standards for the majority of people. Others emphasise the enormous human cost, particularly during the early decades, when exploitation was common and inequality increased dramatically. The debate often centres on whether the benefits eventually outweighed the suffering experienced by the working classes.

The social changes extended far beyond the workplace. Traditional family structures were disrupted as men, women, and children left home to work in factories. New social classes emerged, and ideas about labour rights, socialism, and political reform began to develop in response to the harsh realities of industrial life. Trade unions were formed, and pressure grew for improved working conditions and voting rights.

The Industrial Revolution also had significant environmental consequences. Air and water pollution became serious problems near industrial centres, and the demand for coal and other raw materials led to widespread landscape changes. These environmental impacts, once largely ignored, are now viewed with greater concern by modern historians.

Today, the Industrial Revolution serves as a powerful case study for understanding the complex relationship between technological progress, economic development, and social change. Its legacy continues to influence contemporary discussions about automation, urbanisation, and the balance between economic growth and human welfare.', 3),
    
    (v_paper_id, 'The Science of Sleep', 
    'Sleep is essential for both physical and mental health, yet it is often undervalued in modern society. Scientists have long studied the complex processes that occur during sleep and have discovered that it is far more than a period of rest. It is an active state during which the body and brain carry out vital restorative functions.

Sleep is typically divided into several stages. Deep sleep, also known as slow-wave sleep, is particularly important for physical recovery. During this phase, the body repairs damaged tissues, builds muscle, and strengthens the immune system. Growth hormones are released, helping with cell regeneration and overall physical maintenance. Studies have shown that people who regularly experience insufficient deep sleep are more susceptible to infections and take longer to recover from illness.

Another critical phase is REM (Rapid Eye Movement) sleep. This stage is strongly associated with brain activity and plays a crucial role in memory consolidation and emotional processing. During REM sleep, the brain organises and stores information gathered during the day, transfers short-term memories into long-term storage, and helps regulate emotions. Lack of adequate REM sleep has been linked to impaired learning, reduced concentration, and increased risk of mood disorders such as anxiety and depression.

Despite its importance, sleep deprivation has become widespread in contemporary society. Modern lifestyles, characterised by constant screen exposure from smartphones, tablets and computers, irregular working hours, and high stress levels, have significantly disrupted natural sleep patterns. The blue light emitted by electronic devices suppresses the production of melatonin, the hormone that regulates sleep, making it HARDer for many people to fall asleep and maintain quality rest.

Research consistently shows that adults need between seven and nine hours of quality sleep per night for optimal functioning. However, surveys indicate that a large proportion of the population regularly gets far less than this recommended amount. Chronic sleep deprivation has been associated with numerous serious health problems, including obesity, type 2 diabetes, cardiovascular disease, and weakened cognitive performance. In fact, prolonged lack of sleep can have effects on the body and mind that are comparable to alcohol intoxication.

The consequences extend beyond individual health. Sleep-deprived workers are more likely to make mistakes, have slower reaction times, and experience reduced productivity. In safety-critical professions such as healthcare, transportation, and manufacturing, fatigue-related errors can have life-threatening consequences. Governments and health organisations are increasingly recognising the scale of the problem and are promoting awareness campaigns about sleep hygiene.

Scientists are also exploring the relationship between sleep and mental health. Poor sleep quality is both a symptom and a contributing factor in many psychological conditions. Improving sleep has been shown to reduce symptoms of depression and anxiety, while good sleep habits can enhance overall emotional resilience.

Various strategies have been suggested to improve sleep quality. These include maintaining a regular sleep schedule, creating a dark and cool sleeping environment, limiting screen time before bed, and engaging in regular physical exercise. Some researchers are also investigating the effectiveness of cognitive behavioural therapy for insomnia (CBT-I), which has shown promising results as a non-pharmaceutical treatment.

In conclusion, sleep is a fundamental biological process that underpins almost every aspect of human health and performance. As society becomes increasingly fast-paced and technology-driven, understanding and prioritising quality sleep is more important than ever. The science of sleep continues to reveal how critical this nightly process is for our physical restoration, cognitive function, and emotional wellbeing.', 4),
    
    (v_paper_id, 'Multiple Intelligences in Education', 
    'Howard Gardner''s theory of multiple intelligences challenged the traditional view of intelligence as a single measurable quantity, fundamentally changing how educators and psychologists understand human cognitive abilities. Proposed in 1983, the theory suggests that intelligence is not a unitary concept but consists of several distinct modalities.

Gardner originally identified seven intelligences and later added an eighth. These are: linguistic intelligence (sensitivity to spoken and written language), logical-mathematical intelligence (ability to analyse problems logically and carry out mathematical operations), spatial intelligence (capacity to recognise and use patterns in space), musical intelligence (skill in performing, composing, and appreciating musical patterns), bodily-kinesthetic intelligence (ability to use one’s body to solve problems or create products), interpersonal intelligence (capacity to understand the intentions, motivations, and desires of other people), intrapersonal intelligence (self-awareness and understanding of one’s own emotions and motivations), and naturalistic intelligence (ability to recognise and categorise plants, animals, and other elements in the natural world).

This framework directly challenged the long-dominant IQ test approach, which primarily measured linguistic and logical-mathematical abilities. Gardner argued that traditional schooling systems tend to favour students strong in these two areas while disadvantaging those whose strengths lie in other intelligences. For example, a student with high bodily-kinesthetic intelligence might struggle in a conventional classroom but excel in sports, dance, or crafts.

The impact of Gardner''s theory on education has been significant. Many schools and teachers worldwide have adopted multiple intelligence approaches, designing lessons that incorporate a variety of activities to engage different types of learners. Instead of relying heavily on lectures and written tests, educators now use group projects, music, visual aids, physical movement, and nature-based learning to reach more students effectively.

Proponents of the theory claim it promotes greater inclusivity and helps identify and nurture diverse talents. It has encouraged the development of more personalised learning strategies and shifted emphasis from standardised testing toward a broader understanding of student potential. Some schools have introduced "intelligence-friendly" curricula that allow students to demonstrate understanding through their strongest intelligence channels.

However, the theory has also faced criticism. Some psychologists argue that the eight intelligences are not truly independent and that there is still strong evidence for a general intelligence factor (g-factor). Others question whether all the proposed intelligences meet the strict scientific criteria for intelligence. Despite these debates, the practical applications in education remain popular because they offer teachers flexible and creative ways to engage diverse learners.

The theory has particular relevance in today''s increasingly multicultural and multilingual classrooms. Recognising different intelligences helps teachers address cultural differences in learning styles and supports students with special educational needs. It has also influenced vocational training and adult education, where individuals can develop skills aligned with their natural strengths.

Gardner himself has emphasised that his theory is not about labelling students but about acknowledging cognitive diversity and creating richer educational experiences. He encourages educators to use multiple pathways to help students master important material rather than forcing all learners into the same narrow mould.

Today, multiple intelligences theory continues to inspire curriculum development, teacher training programmes, and educational policy discussions globally. While it may not have completely replaced traditional measures of academic achievement, it has undeniably broadened our understanding of what it means to be intelligent and how best to support learning in the 21st century.', 5),
    
    (v_paper_id, 'Coral Reef Ecosystems Under Threat', 
    'Coral reefs are among the most diverse and vibrant ecosystems on Earth, often referred to as the rainforests of the sea. They occupy less than one per cent of the ocean floor but support approximately 25 per cent of all marine species. These complex underwater structures provide habitat, food, and breeding grounds for thousands of fish, molluscs, crustaceans, and other marine organisms.

Despite their importance, coral reefs worldwide are facing unprecedented threats. Climate change is the most serious danger. Rising ocean temperatures, caused by global warming, lead to a phenomenon known as coral bleaching. When water becomes too warm, corals expel the colourful algae living in their tissues. Without these algae, corals turn white, lose their main source of energy, and eventually die if the stress continues. Major bleaching events have become more frequent and severe in recent decades, with the Great Barrier Reef in Australia experiencing multiple mass bleaching episodes.

Another significant threat is ocean acidification. As the oceans absorb increasing amounts of carbon dioxide from the atmosphere, seawater becomes more acidic. This reduces the availability of carbonate ions that corals need to build their calcium carbonate skeletons. Acidification essentially makes it HARDer for corals to grow and maintain the reef structure, weakening the entire ecosystem.

Human activities compound these environmental pressures. Coastal development, agricultural runoff, and industrial waste introduce pollutants into the ocean, causing algal blooms and reducing water quality. Sedimentation from deforestation and construction smothers corals, blocking sunlight essential for photosynthesis. Overfishing is another major problem. The removal of herbivorous fish allows algae to grow unchecked, competing with corals for space on the reef.

The economic and social value of coral reefs is enormous. They protect coastlines from storm surges and erosion, support commercial and subsistence fisheries, and generate billions of dollars annually through tourism. Many island nations and coastal communities depend heavily on healthy reefs for their livelihoods and food security. The loss of coral reefs would therefore have devastating consequences for both biodiversity and human populations.

Scientists are working on various conservation and restoration efforts. These include establishing marine protected areas, reducing local pollution, and implementing sustainable fishing practices. More experimental approaches involve coral gardening and selective breeding of heat-resistant coral strains. However, experts emphasise that without significant global action to reduce greenhouse gas emissions, local efforts alone may not be enough to save many reef systems.

The decline of coral reefs serves as a powerful indicator of the broader health of our oceans and the planet. As one of the most sensitive ecosystems to environmental change, they act as an early warning system for the impacts of climate change. The future of coral reefs will largely depend on how quickly humanity can reduce carbon emissions and manage local human pressures.

Despite the challenges, there is some cause for cautious optimism. Some reefs have shown remarkable resilience and recovery when given protection from local threats. International initiatives and growing public awareness are increasing efforts to preserve these vital ecosystems for future generations.', 6),
    
    (v_paper_id, 'Renewable Energy Transition', 
    'The shift from fossil fuels to renewable energy sources is one of the most important challenges of our time. As concerns about climate change, energy security, and environmental degradation intensify, many nations are accelerating their transition towards cleaner, sustainable forms of energy.

Renewable energy comes from naturally replenished sources such as sunlight, wind, water, and geothermal heat. Among these, solar and wind power have seen the most dramatic progress in recent decades. Technological improvements and large-scale production have caused costs to fall sharply. Solar photovoltaic panels and onshore wind turbines are now competitive with, or even cheaper than, traditional coal and gas in many parts of the world. This cost reduction has transformed renewables from expensive alternatives into mainstream energy sources.

Several countries have become global leaders in the renewable energy transition. Denmark, for example, generates more than 50% of its electricity from wind power and aims to become completely fossil-fuel free by 2050. Similarly, Costa Rica has achieved remarkable success, often generating nearly 99% of its electricity from renewable sources, primarily hydropower, wind, and geothermal energy. These countries demonstrate that a high percentage of renewable energy is technically and economically feasible.

The benefits of transitioning to renewables extend beyond environmental protection. The renewable energy sector creates substantial employment opportunities in manufacturing, installation, maintenance, and research. It also reduces dependence on imported fossil fuels, improving energy security for many nations. Furthermore, cleaner air resulting from reduced coal and oil combustion leads to significant improvements in public health, decreasing respiratory and cardiovascular diseases.

However, the transition is not without challenges. Renewable sources such as solar and wind are intermittent — they depend on weather conditions and time of day. This creates the need for advanced energy storage solutions, such as large-scale batteries, pumped hydro storage, and smart grid technologies. Critics also point to the environmental impact of producing renewable infrastructure, including the mining of rare earth minerals and the disposal of old solar panels and turbine blades.

Despite these obstacles, the momentum towards renewables continues to grow. International agreements such as the Paris Climate Accord have encouraged governments to set ambitious targets for reducing carbon emissions. Many large corporations are also committing to 100% renewable energy goals, driven by both environmental responsibility and long-term cost savings.

Looking ahead, experts believe that continued innovation in energy storage, hydrogen technology, and improved grid management will overcome current limitations. Emerging economies in Asia and Africa have the opportunity to leapfrog fossil fuel dependency and move directly towards renewable systems, potentially avoiding the pollution mistakes of earlier industrialised nations.

The renewable energy transition represents more than just a change in power sources — it signifies a fundamental shift in how societies think about energy, sustainability, and economic development. While the complete replacement of fossil fuels will take decades, the rapid progress in recent years provides cautious optimism that a cleaner energy future is achievable.', 7),
    
    (v_paper_id, 'The Benefits of Bilingualism', 
   'Learning two or more languages from an early age provides cognitive advantages that last into adulthood. In our increasingly globalised world, bilingualism and multilingualism have become more common and more valuable than ever before.

Bilingual individuals, who regularly use two languages, often demonstrate superior cognitive abilities compared to monolinguals. Research in neuroscience and psychology has shown that managing two language systems strengthens the brain''s executive function — the set of mental skills that include attention control, working memory, and cognitive flexibility. This constant mental juggling appears to enhance the brain''s ability to focus, ignore distractions, and switch between tasks efficiently.

One of the most remarkable findings is that bilingualism improves multitasking ability. Because bilinguals are accustomed to switching between languages, their brains become more adept at handling multiple demands simultaneously. Laboratory studies have repeatedly shown that bilingual participants outperform monolinguals in tasks requiring rapid task-switching and conflict resolution.

Perhaps the most significant long-term benefit is the delayed onset of dementia symptoms. Multiple studies across different countries have found that bilingual individuals typically develop symptoms of Alzheimer’s disease and other forms of dementia four to five years later than monolinguals, even when they have similar levels of brain deterioration. This protective effect is believed to result from the enhanced cognitive reserve built up through years of managing multiple languages.

The advantages begin early in life. Children raised in bilingual environments often show greater metalinguistic awareness — the ability to think about language itself. This deeper understanding helps them learn additional languages more easily later in life. Furthermore, bilingual children frequently demonstrate more creative thinking and problem-solving skills because they are used to viewing the world from different linguistic and cultural perspectives.

However, the benefits extend far beyond cognition. Bilingualism also provides social and cultural advantages. It opens doors to different communities, cultures, and ways of thinking. In professional contexts, being bilingual or multilingual is increasingly seen as a valuable asset in business, diplomacy, healthcare, and education. Many employers actively seek candidates who can communicate effectively across language barriers.

Despite these proven benefits, some parents still worry that exposing young children to multiple languages might cause confusion or delay language development. However, extensive research has disproved this concern. Children are remarkably capable of acquiring multiple languages simultaneously without negative effects on their overall linguistic development.

The mechanisms behind these cognitive advantages are still being studied. Some researchers believe that the bilingual brain is constantly active, even when using only one language, because it must suppress the other language. This constant inhibitory control acts like mental exercise, keeping the brain sharper and more resilient throughout life.

As globalisation continues, the number of bilingual and multilingual individuals is rising rapidly. Schools in many countries are introducing bilingual programmes, and parents are increasingly choosing to raise their children with more than one language. The evidence suggests that investing in bilingual education and encouraging early language learning could have profound benefits for individuals and society as a whole.

In conclusion, the cognitive, social, and professional advantages of bilingualism make it one of the most valuable skills a person can develop. Far from being a burden, learning multiple languages from an early age appears to enrich both the mind and the individual''s opportunities in life.', 8),
    
    (v_paper_id, 'Urban Farming and Food Security', 
   'Growing food in cities is becoming increasingly popular as a response to climate change, supply chain vulnerabilities, and growing concerns about food security. This movement, known as urban farming or urban agriculture, involves cultivating crops and raising small livestock within city environments using innovative methods and spaces.

Urban farming takes many forms. Rooftop gardens transform unused building rooftops into productive green spaces. Vertical farms use indoor multi-layered systems with controlled environments, LED lighting, and hydroponic or aeroponic techniques to grow vegetables and herbs with minimal water and no soil. Community gardens and allotments turn vacant lots, parks, and school grounds into shared growing spaces where local residents can grow their own food.

One of the main advantages of urban farming is the significant reduction in "food miles" — the distance food travels from producer to consumer. By growing food where people live, cities can cut transportation-related carbon emissions and reduce reliance on long, fragile global supply chains. This became particularly evident during the COVID-19 pandemic and recent geopolitical conflicts, when disruptions in supply chains caused food shortages and price spikes in many urban areas.

Urban agriculture also improves local resilience. Communities that produce at least part of their own food are better able to withstand external shocks such as extreme weather events, natural disasters, or economic instability. Additionally, fresh produce harvested and consumed locally retains more nutrients than food that has spent days in transit and storage.

Beyond environmental and economic benefits, urban farming provides important social advantages. Community gardens bring neighbours together, strengthen social bonds, and improve mental health through contact with nature. They also offer educational opportunities for children and adults to learn about sustainable food production, healthy eating, and environmental stewardship. In many low-income neighbourhoods, urban farms help address food deserts — areas with limited access to affordable fresh produce.

However, urban farming faces several challenges. Limited space, poor soil quality in some areas, and contamination from previous industrial use are common problems. High initial setup costs for vertical farms and rooftop gardens can be prohibitive, and access to water and sunlight must be carefully managed. Furthermore, some critics argue that urban agriculture can only ever supplement, not replace, traditional rural farming on a large scale.

Despite these obstacles, technological innovation is helping urban farming become more efficient and productive. Advances in hydroponics, aquaponics, automation, and artificial intelligence are allowing higher yields in smaller spaces. Some vertical farms can produce up to 100 times more food per square metre than traditional farming.

Governments and organisations in many countries are beginning to support urban agriculture through policies, subsidies, and urban planning regulations. Cities such as Singapore, Tokyo, New York, and Amsterdam have ambitious programmes to increase local food production and integrate agriculture into urban design.

As the global population continues to urbanise and climate change makes traditional agriculture more unpredictable, urban farming is likely to play an increasingly important role in feeding the world''s cities. While it may not solve all food security problems, it represents a valuable and sustainable component of a more resilient and environmentally conscious food system.', 9);

    -- Get the inserted group IDs (PostgreSQL returns them in order)
    SELECT idquestiongroup INTO g1 FROM question_groups WHERE title = 'Rising Seas and Coastal Communities' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g2 FROM question_groups WHERE title = 'Artificial Intelligence in Healthcare' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g3 FROM question_groups WHERE title = 'The Industrial Revolution and Urbanization' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g4 FROM question_groups WHERE title = 'The Science of Sleep' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g5 FROM question_groups WHERE title = 'Multiple Intelligences in Education' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g6 FROM question_groups WHERE title = 'Coral Reef Ecosystems Under Threat' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g7 FROM question_groups WHERE title = 'Renewable Energy Transition' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g8 FROM question_groups WHERE title = 'The Benefits of Bilingualism' ORDER BY idquestiongroup DESC LIMIT 1;
    SELECT idquestiongroup INTO g9 FROM question_groups WHERE title = 'Urban Farming and Food Security' ORDER BY idquestiongroup DESC LIMIT 1;
       
    -- (Repeat pattern for g3 to g9 — adjust if needed)
    
    
    -- (Repeat pattern for g3 to g9 — adjust if needed)

    -- === 3. INSERT 120 QUESTIONS ===
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u1, g1, 'What is the main idea of the passage?', 
 'The benefits of mangrove restoration', 'The impact of rising sea levels on coastal areas', 'The history of climate change science', 'Economic opportunities in island nations', 'B', 
 'The passage primarily discusses sea level rise and its consequences for coastal communities.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'By how much have global sea levels risen since 1900?', 
 '10 cm', '20 cm', '35 cm', '50 cm', 'B', 
 'The text states "approximately 20 cm since 1900".', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u1, g1, 'What does the passage say about the rate of sea level rise?', 
 'It has remained constant', 'It has doubled in the last two decades', 'It has slowed down recently', 'It stopped increasing after 2000', 'B', 
 'The rate has doubled in recent decades.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'Which countries are mentioned as already displacing communities?', 
 'Indonesia and Thailand', 'Bangladesh and the Maldives', 'Australia and Japan', 'Brazil and Peru', 'B', 
 'Bangladesh and the Maldives are explicitly named.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u1, g1, 'What prediction do scientists make for 2100?', 
 'Sea levels will begin to fall', 'Many coastal regions could become uninhabitable', 'All islands will be protected by technology', 'Emissions will naturally decrease', 'B', 
 'Without emission cuts, many areas may become uninhabitable.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'What adaptation strategies are mentioned?', 
 'Building higher skyscrapers and desalination plants', 'Sea walls and mangrove restoration', 'Relocating entire populations to mountains', 'Banning all coastal construction', 'B', 
 'The text lists sea walls and mangrove restoration.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'What is the writer’s view regarding adaptation measures?', 
 'They will completely solve the problem', 'They may only delay the problem in vulnerable areas', 'They are unnecessary', 'They are more important than emission reductions', 'B', 
 'Experts argue these measures may only delay the inevitable.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u1, g1, 'The word "displaced" in the passage is closest in meaning to:', 
 'Employed', 'Moved from their homes', 'Given financial aid', 'Educated about climate change', 'B', 
 'It refers to people being forced to leave their homes.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'What is required to prevent many regions from becoming uninhabitable?', 
 'Significant reductions in greenhouse gas emissions', 'More mangrove planting worldwide', 'Construction of taller sea walls', 'Increased international tourism', 'A', 
 'Scientists warn that emission reductions are essential.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'Which of the following is NOT mentioned as a threat?', 
 'Flooding', 'Erosion', 'Rising sea levels', 'Increased tourism', 'D', 
 'Tourism is not mentioned as a threat.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'The passage suggests that low-lying islands are particularly:', 
 'Economically advantaged', 'Vulnerable to climate change effects', 'Uninterested in adaptation', 'Experiencing population growth', 'B', 
 'They face increasing threats from flooding and erosion.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u1, g1, 'What is the overall tone of the passage?', 
 'Optimistic about technological solutions', 'Concerned about future impacts', 'Neutral and purely scientific', 'Critical of developing countries', 'B', 
 'The tone is serious and highlights risks.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u1, g1, 'According to the passage, mangrove restoration is:', 
 'A complete long-term solution', 'One of several adaptation strategies', 'No longer recommended by experts', 'Only useful for tourism', 'B', 
 'It is listed as an adaptation strategy.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u1, g1, 'The phrase "delay the inevitable" implies that adaptation measures:', 
 'Will fully protect all areas', 'May not be enough in the long term', 'Are better than emission reductions', 'Will speed up the process', 'B', 
 'They may only postpone the problem in vulnerable areas.', 'MULTIPLE_CHOICE', 'HARD');
-- Passage 2: Artificial Intelligence in Healthcare
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u3, g2, 'What is the main idea of the passage?', 
 'The complete replacement of doctors by artificial intelligence', 'How AI is transforming healthcare along with its challenges', 'The high cost of implementing AI in hospitals', 'Why patients distrust artificial intelligence', 'B', 
 'The passage discusses both the benefits and the concerns surrounding AI in medicine.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g2, 'According to the passage, what can machine learning algorithms do better than many radiologists?', 
 'Perform complex surgeries', 'Detect cancers in medical scans', 'Communicate with patients', 'Manage hospital staff', 'B', 
 'The text states that AI can detect cancers with higher accuracy than many radiologists.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u3, g2, 'How has AI changed the process of drug discovery?', 
 'Made it significantly more expensive', 'Reduced development time from years to months', 'Removed the need for any human involvement', 'Slowed down the entire process', 'B', 
 'AI dramatically reduces development time and costs.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u3, g2, 'Which of the following is mentioned as a major concern about AI in healthcare?', 
 'Lack of computing power', 'Data privacy and ethical implications', 'Too much direct contact with patients', 'Decreased hospital funding', 'B', 
 'The passage highlights data privacy and ethical issues.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g2, 'What do some healthcare professionals fear about AI?', 
 'It will make medical treatment slower', 'Significant job losses', 'It will increase their administrative workload', 'It will reduce patient numbers', 'B', 
 'Some fear AI could lead to job losses, especially in radiology.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u3, g2, 'According to the passage, how can AI benefit doctors?', 
 'By replacing them in all medical decisions', 'By freeing them from administrative tasks', 'By reducing their interaction with patients', 'By increasing their working hours', 'B', 
 'AI can handle routine tasks so doctors can focus on patient care.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g2, 'The word "accelerates" in the passage is closest in meaning to:', 
 'Slows down', 'Speeds up', 'Replaces', 'Complicates', 'B', 
 'It refers to making the drug discovery process much faster.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g2, 'What is the writer’s overall attitude towards AI in healthcare?', 
 'Strongly opposed to its use', 'Positive but aware of its challenges', 'Completely neutral', 'Highly sceptical of all technological progress', 'B', 
 'The passage presents benefits while seriously addressing concerns.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u3, g2, 'Which of the following is NOT mentioned as a concern regarding AI?', 
 'Data privacy', 'Ethical implications of life-critical decisions', 'Bias in training data', 'High cost of AI systems', 'D', 
 'The high cost of AI systems is not mentioned in the passage.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g2, 'The passage suggests that using AI for life-critical decisions raises issues related to:', 
 'Only financial costs', 'Responsibility and ethics', 'Patient waiting times', 'Hospital location', 'B', 
 'Serious ethical questions arise when machines make life-critical decisions.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g2, 'One positive view of AI mentioned in the passage is that it can help doctors:', 
 'Eliminate the need for hospitals', 'Focus more on patient care', 'Reduce medical research', 'Avoid all training', 'B', 
 'AI frees doctors from administrative tasks.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u3, g2, 'The passage implies that the best future role for AI in medicine is as:', 
 'A complete replacement for doctors', 'A supportive tool working alongside medical professionals', 'A temporary experimental technology', 'A tool only for administrative staff', 'B', 
 'Experts recommend a collaborative model between AI and doctors.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u3, g2, 'What problem can arise if AI systems are trained mostly on Western data?', 
 'They may not perform well for other ethnic groups', 'They become too slow', 'They only work in rich countries', 'They increase costs dramatically', 'A', 
 'AI can unintentionally reproduce biases if training data is not diverse.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u3, g2, 'According to the passage, what is one of the biggest current challenges for AI in healthcare?', 
 'Finding enough patients to test it', 'Creating appropriate regulation and frameworks', 'Making the systems more expensive', 'Convincing patients to use it', 'B', 
 'Governments are struggling to create suitable regulatory frameworks.', 'MULTIPLE_CHOICE', 'MEDIUM');
-- Passage 3: The Industrial Revolution and Urbanization
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u6, g3, 'What is the main idea of the passage?', 
 'The negative effects of child labour during the Industrial Revolution', 'The profound social and economic transformations caused by the Industrial Revolution', 'The technological inventions of the 19th century', 'Why Britain became the richest country in the world', 'B', 
 'The passage explores both the benefits and serious consequences of the Industrial Revolution.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'Where and when did the Industrial Revolution begin?', 
 'In France in the early 17th century', 'In Britain in the late 18th century', 'In the United States in the mid-19th century', 'In Germany after 1900', 'B', 
 'The text states it began in Britain in the late 18th century.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g3, 'What directly led to rapid urbanization?', 
 'Government policies encouraging city growth', 'Factories demanding large numbers of workers', 'Improvements in rural farming techniques', 'The development of the internet', 'B', 
 'Mass migration occurred because factories needed workers.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g3, 'Which of the following is mentioned as a positive outcome?', 
 'Elimination of child labour', 'Economic growth and technological progress', 'Improved working conditions from the beginning', 'Reduction in city populations', 'B', 
 'The passage mentions economic growth and technological progress as benefits.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'What social problems resulted from rapid urbanization?', 
 'Overcrowded slums, poor working conditions and child labour', 'High unemployment and economic decline', 'Better healthcare and education for all', 'Decreased pollution levels', 'A', 
 'These problems are explicitly described in the text.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g3, 'What do historians continue to debate about the Industrial Revolution?', 
 'The exact date it started', 'Whether its overall impact was positive or negative for the average person', 'The number of factories built in Manchester', 'The role of women in rural areas', 'B', 
 'Historians still debate the long-term benefits versus the human cost.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'The word "fundamentally" is closest in meaning to:', 
 'Slightly', 'Dramatically / at a basic level', 'Temporarily', 'Only financially', 'B', 
 'It means the change was deep and transformative.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'Which two cities are mentioned as becoming major industrial hubs?', 
 'London and Edinburgh', 'Manchester and Birmingham', 'Liverpool and Bristol', 'Oxford and Cambridge', 'B', 
 'Manchester and Birmingham expanded rapidly as industrial centres.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'The passage suggests that the Industrial Revolution:', 
 'Only created negative effects', 'Brought both major benefits and serious social problems', 'Had little impact on ordinary people', 'Was mainly beneficial for rural populations', 'B', 
 'It brought economic growth but also significant human suffering.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'Which group suffered particularly harsh conditions during the early Industrial Revolution?', 
 'Factory owners', 'Children (through widespread child labour)', 'Wealthy merchants', 'Skilled craftsmen', 'B', 
 'Child labour in factories and mines is highlighted.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'The writer’s tone in the passage is best described as:', 
 'Strongly critical of all industrialization', 'Completely positive about progress', 'Balanced – presenting both advantages and disadvantages', 'Humorous and light-hearted', 'C', 
 'The passage presents both sides of the Industrial Revolution.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u6, g3, 'According to the passage, what long-term positive development resulted from the Industrial Revolution?', 
 'The complete end of social inequality', 'The rise of the middle class and more affordable goods', 'The return of people to rural areas', 'The elimination of pollution', 'B', 
 'It led to the rise of the middle class and cheaper goods.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'Which of the following is NOT mentioned as a consequence of the Industrial Revolution?', 
 'Air and water pollution', 'Disruption of traditional family structures', 'Formation of trade unions', 'Significant decrease in global temperatures', 'D', 
 'Global temperature decrease is not mentioned.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g3, 'The passage implies that the legacy of the Industrial Revolution is still relevant today because:', 
 'It only affected Britain', 'It helps us understand current issues around technology, urbanization and social change', 'All problems from that era have been solved', 'It led to the end of capitalism', 'B', 
 'Its legacy continues to influence modern discussions about automation and urban growth.', 'MULTIPLE_CHOICE', 'HARD');

-- Passage 4: The Science of Sleep
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u5, g4, 'What is the main idea of the passage?', 
 'The negative effects of modern technology on work productivity', 'The importance of sleep for physical and mental health', 'Different types of dreams during REM sleep', 'How to reduce stress in fast-paced societies', 'B', 
 'The passage explains the science of sleep and why it is essential for human wellbeing.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g4, 'During which stage of sleep does the body repair tissues and strengthen the immune system?', 
 'REM sleep', 'Deep sleep (slow-wave sleep)', 'Light sleep', 'Awake resting state', 'B', 
 'Deep sleep is when physical restoration mainly occurs.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g4, 'What is one key function of REM sleep?', 
 'Releasing growth hormones', 'Memory consolidation and emotional processing', 'Repairing damaged muscles', 'Lowering body temperature', 'B', 
 'REM sleep plays a crucial role in memory and emotional regulation.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g4, 'According to the passage, how many hours of sleep do adults generally need?', 
 '4–6 hours', '7–9 hours', '9–11 hours', 'At least 10 hours', 'B', 
 'Research shows adults need 7–9 hours of quality sleep.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g4, 'Why does screen exposure before bed make it harder to sleep?', 
 'It increases body temperature', 'The blue light suppresses melatonin production', 'It makes the room too noisy', 'It raises stress levels dramatically', 'B', 
 'Blue light from devices interferes with melatonin.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g4, 'Which health problem is NOT mentioned as being linked to chronic sleep deprivation?', 
 'Obesity', 'Type 2 diabetes', 'Cardiovascular disease', 'Severe skin conditions', 'D', 
 'Skin conditions are not mentioned in the passage.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g4, 'The word "consolidation" in the passage is closest in meaning to:', 
 'Forgetting', 'Strengthening and storing', 'Removing', 'Ignoring', 'B', 
 'It refers to transferring and strengthening memories.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g4, 'What effect can prolonged sleep deprivation have that is compared to alcohol intoxication?', 
 'Improved reaction times', 'Impaired cognitive performance', 'Increased creativity', 'Better immune function', 'B', 
 'The effects can be comparable to alcohol intoxication.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u5, g4, 'In which sectors can fatigue-related errors be especially dangerous?', 
 'Education and retail', 'Healthcare, transportation and manufacturing', 'Agriculture and tourism', 'Entertainment and media', 'B', 
 'Safety-critical professions are specifically mentioned.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g4, 'What is CBT-I?', 
 'A type of sleeping pill', 'Cognitive Behavioural Therapy for Insomnia', 'A new sleep tracking device', 'A government sleep awareness law', 'B', 
 'It is mentioned as a non-pharmaceutical treatment.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g4, 'The passage suggests that poor sleep and mental health problems:', 
 'Have no relationship', 'Can influence each other in both directions', 'Only affect older people', 'Are caused solely by technology', 'B', 
 'Poor sleep is both a symptom and a contributing factor.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u5, g4, 'Which of the following is recommended to improve sleep quality?', 
 'Using smartphones until late at night', 'Maintaining a regular sleep schedule', 'Exercising right before bedtime', 'Sleeping in a warm, bright room', 'B', 
 'Regular sleep schedule and limiting screen time are suggested.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g4, 'What is the writer’s overall attitude towards the importance of sleep?', 
 'It is overrated in modern society', 'It is fundamental to nearly every aspect of health and performance', 'It is less important than diet and exercise', 'It mainly affects physical health only', 'B', 
 'The passage stresses that sleep underpins almost every aspect of wellbeing.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u5, g4, 'The passage implies that as society becomes more technology-driven:', 
 'Sleep will naturally improve', 'Prioritising good sleep becomes increasingly important', 'People need less sleep than before', 'Sleep research will become unnecessary', 'B', 
 'Understanding and prioritising sleep is more important than ever.', 'MULTIPLE_CHOICE', 'MEDIUM');
-- Passage 5: Multiple Intelligences in Education
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u6, g5, 'What is the main idea of the passage?', 
 'The disadvantages of traditional IQ tests', 'Howard Gardner''s theory of multiple intelligences and its impact on education', 'The importance of linguistic and mathematical skills', 'Why some students fail in traditional schools', 'B', 
 'The passage explains Gardner''s theory and how it has influenced teaching methods.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'When was Gardner''s theory of multiple intelligences first proposed?', 
 'In the 1960s', 'In 1983', 'In the early 2000s', 'In 1975', 'B', 
 'The theory was proposed in 1983.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g5, 'How many types of intelligence did Gardner propose?', 
 'Five', 'Seven', 'Eight', 'Ten', 'C', 
 'He originally identified seven and later added an eighth.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g5, 'Which intelligence involves understanding one’s own emotions and motivations?', 
 'Interpersonal intelligence', 'Intrapersonal intelligence', 'Naturalistic intelligence', 'Spatial intelligence', 'B', 
 'Intrapersonal intelligence is self-awareness of one’s emotions.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'What does the passage say about traditional schooling systems?', 
 'They give equal importance to all intelligences', 'They mainly favour linguistic and logical-mathematical abilities', 'They focus heavily on bodily-kinesthetic intelligence', 'They have fully adopted Gardner''s theory', 'B', 
 'Traditional systems tend to favour only two intelligences.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'According to the theory, a student with high bodily-kinesthetic intelligence would likely excel in:', 
 'Writing essays and reading', 'Sports, dance or crafts', 'Solving mathematical equations', 'Learning foreign languages', 'B', 
 'Bodily-kinesthetic intelligence involves using the body to solve problems.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g5, 'The word "modalities" in the passage is closest in meaning to:', 
 'Types or forms', 'Difficulties', 'Measurements', 'Limitations', 'A', 
 'It refers to different types of intelligence.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'One major benefit of applying multiple intelligences theory in schools is:', 
 'It makes standardised testing easier', 'It promotes greater inclusivity and personalised learning', 'It reduces the need for teachers', 'It focuses only on talented students', 'B', 
 'It helps reach more students through diverse activities.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'What criticism of Gardner''s theory is mentioned?', 
 'It is too difficult for teachers to apply', 'The intelligences may not be truly independent', 'It ignores linguistic skills completely', 'It is only useful for young children', 'B', 
 'Some argue the intelligences are not fully independent.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u6, g5, 'How has the theory influenced education worldwide?', 
 'It has been completely rejected', 'It has encouraged teachers to diversify their methods', 'It has reduced the importance of education', 'It has led to the elimination of all testing', 'B', 
 'Educators now use varied activities to engage different learners.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'The passage suggests that Gardner''s theory is particularly useful in:', 
 'Only elite private schools', 'Multicultural and multilingual classrooms', 'Schools that focus only on mathematics', 'Universities specialising in science', 'B', 
 'It helps address cultural differences in learning styles.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'What was Gardner''s main intention with his theory?', 
 'To label students according to their weaknesses', 'To acknowledge cognitive diversity and create richer learning experiences', 'To replace all traditional teaching methods', 'To prove that IQ tests are useless', 'B', 
 'He wanted to support different pathways to learning.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u6, g5, 'Which of the following is NOT one of the eight intelligences?', 
 'Naturalistic', 'Spiritual', 'Musical', 'Bodily-kinesthetic', 'B', 
 'Spiritual intelligence is not part of the eight.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g5, 'The overall tone of the passage towards multiple intelligences theory can be described as:', 
 'Highly critical', 'Completely dismissive', 'Positive but balanced', 'Entirely negative', 'C', 
 'The passage presents both the benefits and the criticisms.', 'MULTIPLE_CHOICE', 'HARD');

-- Passage 6: Coral Reef Ecosystems Under Threat
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u5, g6, 'What is the main idea of the passage?', 
 'The economic benefits of coral reef tourism', 'The serious threats facing coral reefs and their importance', 'How to build artificial coral reefs', 'The discovery of new marine species', 'B', 
 'The passage discusses both the value of coral reefs and the multiple threats they face.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'Why are coral reefs often called the rainforests of the sea?', 
 'They are the same colour as rainforests', 'They support an enormous diversity of marine life', 'They grow very tall structures', 'They produce large amounts of rain', 'B', 
 'They support 25% of marine species despite occupying less than 1% of the ocean floor.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g6, 'What is the main cause of coral bleaching?', 
 'Ocean acidification', 'Rising ocean temperatures', 'Overfishing', 'Sedimentation', 'B', 
 'Rising temperatures cause corals to expel their algae.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g6, 'How does ocean acidification affect corals?', 
 'It makes the water too warm', 'It reduces their ability to build calcium carbonate skeletons', 'It increases their growth rate', 'It improves water quality', 'B', 
 'Acidification lowers carbonate ions needed for skeleton building.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'Which human activity is mentioned as contributing to reef damage through sedimentation?', 
 'Overfishing', 'Coastal development and deforestation', 'Tourism only', 'Deep sea mining', 'B', 
 'Sedimentation from construction and deforestation smothers corals.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'What percentage of marine species do coral reefs support?', 
 'Less than 5%', 'Approximately 25%', 'Over 50%', 'About 10%', 'B', 
 'They support 25% of marine species.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g6, 'The word "unprecedented" in the passage means:', 
 'Minor or insignificant', 'Never seen before / on a new scale', 'Easily reversible', 'Widely welcomed', 'B', 
 'It refers to the scale of current threats.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'According to the passage, what economic benefit do coral reefs provide?', 
 'They reduce the need for international tourism', 'They protect coastlines from storms and support fisheries and tourism', 'They increase agricultural land', 'They lower global sea levels', 'B', 
 'They protect coastlines and generate income through tourism and fishing.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'What is one experimental approach to coral restoration mentioned?', 
 'Complete removal of all tourism', 'Selective breeding of heat-resistant coral strains', 'Banning all fishing permanently', 'Adding chemicals to the ocean', 'B', 
 'Scientists are breeding heat-resistant corals.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'The passage suggests that local conservation efforts alone:', 
 'Are completely sufficient to save all reefs', 'May not be enough without global reduction in greenhouse gases', 'Are unnecessary', 'Have already reversed all damage', 'B', 
 'Global action on emissions is also required.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u5, g6, 'Which of the following is NOT mentioned as a threat to coral reefs?', 
 'Rising ocean temperatures', 'Ocean acidification', 'Increased solar radiation', 'Pollution and overfishing', 'C', 
 'Increased solar radiation is not mentioned.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'Why are coral reefs considered an early warning system?', 
 'They grow very quickly', 'They are highly sensitive to environmental changes', 'They are located near cities', 'They produce oxygen for the planet', 'B', 
 'They act as an indicator of broader ocean and planetary health.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u5, g6, 'The passage mentions that some coral reefs have shown resilience when:', 
 'Tourism is completely banned', 'Protected from local threats such as pollution and overfishing', 'Water temperatures continue to rise', 'All human activity stops', 'B', 
 'Reefs can recover when given protection from local pressures.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g6, 'The writer’s tone in the passage is best described as:', 
 'Completely optimistic', 'Highly pessimistic with no hope', 'Concerned but balanced with some cautious optimism', 'Entirely neutral and factual', 'C', 
 'The passage highlights serious threats while mentioning conservation efforts and resilience.', 'MULTIPLE_CHOICE', 'HARD');

 -- Passage 7: Renewable Energy Transition
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u5, g7, 'What is the main idea of the passage?', 
 'The disadvantages of renewable energy', 'The global shift from fossil fuels to renewable energy sources', 'Why coal and gas are still the best energy options', 'The high cost of solar and wind power', 'B', 
 'The passage discusses the importance, benefits, and challenges of transitioning to renewable energy.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'What has made solar and wind power more competitive with fossil fuels?', 
 'Government subsidies only', 'A dramatic fall in costs', 'Decreased demand for electricity', 'Increase in oil prices', 'B', 
 'Technological improvements have caused costs to fall sharply.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g7, 'Which country generates a very high percentage of its electricity from wind power?', 
 'Costa Rica', 'Denmark', 'Germany', 'Japan', 'B', 
 'Denmark generates more than 50% of its electricity from wind.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g7, 'According to the passage, what is one major benefit of renewable energy?', 
 'It increases dependence on imported fuels', 'It creates employment opportunities', 'It raises electricity prices dramatically', 'It reduces public health problems', 'B', 
 'The renewable sector creates jobs in manufacturing, installation and maintenance.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'What problem is caused by the intermittent nature of solar and wind power?', 
 'They are too expensive to maintain', 'They depend on weather conditions', 'They produce too much pollution', 'They are difficult to install', 'B', 
 'Solar and wind energy production varies with weather and time of day.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'Which of the following is mentioned as a challenge of renewable energy infrastructure?', 
 'Complete lack of public support', 'Mining of rare earth minerals and disposal of old equipment', 'Increased greenhouse gas emissions', 'Reduced energy security', 'B', 
 'Production and disposal of panels and turbines create environmental concerns.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'The word "intermittent" in the passage means:', 
 'Constant and reliable', 'Not continuous / irregular', 'Extremely powerful', 'Very expensive', 'B', 
 'It refers to energy sources that are not always available.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'What has encouraged many governments to set renewable energy targets?', 
 'The Paris Climate Accord', 'Pressure from oil companies', 'Decreasing public interest', 'Rising fossil fuel prices only', 'A', 
 'International agreements like the Paris Accord have played a key role.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'According to the passage, what opportunity do emerging economies have?', 
 'To continue using only fossil fuels', 'To leapfrog fossil fuels and adopt renewables directly', 'To ignore climate change', 'To focus only on coal power', 'B', 
 'They can avoid the pollution mistakes of earlier industrialised nations.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'What positive health effect is linked to the transition to renewables?', 
 'Increased respiratory diseases', 'Cleaner air and reduced cardiovascular problems', 'Higher stress levels', 'More hospital admissions', 'B', 
 'Reduced pollution leads to better public health.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'The passage suggests that energy storage solutions are needed because:', 
 'Renewable energy is too cheap', 'Solar and wind power are not available all the time', 'Fossil fuels are running out', 'Governments oppose renewables', 'B', 
 'Storage is required due to the intermittent nature of renewables.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'What is the writer’s overall attitude towards the renewable energy transition?', 
 'Highly pessimistic', 'Cautiously optimistic', 'Completely neutral', 'Strongly opposed', 'B', 
 'The passage acknowledges challenges but shows optimism about future progress.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u5, g7, 'Which of the following is NOT mentioned as a benefit of renewable energy?', 
 'Job creation', 'Improved energy security', 'Reduced dependence on imported fuels', 'Complete elimination of all environmental problems', 'D', 
 'The passage does not claim renewables solve every environmental issue.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g7, 'The passage implies that the renewable energy transition:', 
 'Will be completed within the next five years', 'Represents a fundamental shift toward sustainable development', 'Is no longer necessary', 'Is only important for rich countries', 'B', 
 'It is described as a major shift in how societies think about energy and sustainability.', 'MULTIPLE_CHOICE', 'HARD');

 --passage 8
 INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u5, g8, 'What is the main idea of the passage?', 
 'The difficulties of learning multiple languages', 'The cognitive and social benefits of bilingualism', 'Why most people should only speak one language', 'The decline of multilingualism in modern society', 'B', 
 'The passage explores the various advantages of learning and using multiple languages from an early age.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'What does bilingualism strengthen according to the passage?', 
 'Physical strength', 'Executive function of the brain', 'Memory of historical facts', 'Appetite for food', 'B', 
 'Managing two languages strengthens executive function, attention control, and cognitive flexibility.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g8, 'Bilingual individuals often show better performance in:', 
 'Single-task activities only', 'Multitasking and task-switching', 'Avoiding all mental effort', 'Reading speed in one language', 'B', 
 'They are better at handling multiple demands simultaneously.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g8, 'By how many years can bilingualism delay the onset of dementia symptoms?', 
 'One to two years', 'Four to five years', 'Eight to ten years', 'No delay', 'B', 
 'Studies show a delay of four to five years.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g8, 'What is "metalinguistic awareness"?', 
 'The ability to speak many languages fluently', 'The ability to think about language itself', 'The skill of memorising vocabulary', 'The preference for one language', 'B', 
 'It is a deeper understanding of language structure and use.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'According to the passage, one social benefit of bilingualism is:', 
 'Increased isolation from other communities', 'Access to different cultures and communities', 'Reduced job opportunities', 'Lower creativity', 'B', 
 'It opens doors to different cultures and professional opportunities.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'The word "suppress" in the passage means:', 
 'To encourage', 'To hold back or inhibit', 'To forget completely', 'To celebrate', 'B', 
 'Bilinguals must suppress one language while using another.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'What concern do some parents still have about bilingual education?', 
 'That it might cause confusion or delay language development', 'That it is too expensive', 'That it reduces physical activity', 'That it is only useful for adults', 'A', 
 'Some parents worry it may confuse children, though research disproves this.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'The passage suggests that the bilingual brain is constantly active because:', 
 'It never rests', 'It must suppress one language while using another', 'It needs more sleep', 'It avoids difficult tasks', 'B', 
 'This constant control acts like mental exercise.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u5, g8, 'Which of the following is mentioned as a professional benefit of being bilingual?', 
 'Higher chances of being selected for many jobs', 'Reduced need for further education', 'Automatic salary increase', 'Fewer working hours', 'A', 
 'Employers actively seek bilingual candidates in many fields.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'The passage implies that bilingual children often:', 
 'Learn slower than monolingual children', 'Show more creative thinking and problem-solving skills', 'Have weaker memories', 'Avoid cultural differences', 'B', 
 'They view the world from different linguistic perspectives.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'What has contributed to the increase in bilingualism worldwide?', 
 'Globalisation', 'Reduction in international travel', 'Decrease in school education', 'Preference for one global language', 'A', 
 'Globalisation has made bilingualism more common and valuable.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u5, g8, 'Which of the following is NOT mentioned as a benefit of bilingualism?', 
 'Better executive function', 'Delayed dementia symptoms', 'Improved physical strength', 'Enhanced cultural understanding', 'C', 
 'Physical strength is not mentioned.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u5, g8, 'The writer’s overall attitude towards bilingualism is:', 
 'Negative and cautious', 'Positive and supportive', 'Completely neutral', 'Highly sceptical', 'B', 
 'The passage presents bilingualism as highly beneficial.', 'MULTIPLE_CHOICE', 'HARD');

 --passage 9
INSERT INTO quizes 
(idcourse, idpaper, idunit, idquestiongroup, questiontext, optiona, optionb, optionc, optiond, correctanswer, explanation, question_type, difficulty)
VALUES

(v_course_id, v_paper_id, u6, g9, 'What is the main idea of the passage?', 
 'The decline of traditional rural farming', 'The rise and benefits of growing food in urban areas', 'The negative effects of climate change on cities', 'Why vertical farms are too expensive', 'B', 
 'The passage discusses the growth of urban farming and its advantages for food security and sustainability.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'What is one common method of urban farming mentioned?', 
 'Expanding large rural plantations', 'Rooftop gardens and vertical farms', 'Importing all food from abroad', 'Using only traditional soil farming in cities', 'B', 
 'Rooftop gardens, vertical farms, and community plots are highlighted.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g9, 'What does "food miles" refer to?', 
 'The price of food in local markets', 'The distance food travels from producer to consumer', 'The number of miles farmers walk', 'A type of urban garden', 'B', 
 'Urban farming helps reduce the distance food travels.', 'MULTIPLE_CHOICE', 'EASY'),

(v_course_id, v_paper_id, u6, g9, 'Why did urban farming become more important during the COVID-19 pandemic?', 
 'People had more free time', 'Supply chain disruptions caused food shortages', 'Rural farms increased production', 'Cities became less populated', 'B', 
 'Disruptions in global supply chains highlighted vulnerabilities.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'One social benefit of community gardens is:', 
 'Increased isolation between neighbours', 'Stronger social bonds and improved mental health', 'Higher levels of pollution', 'Reduced educational opportunities', 'B', 
 'They bring people together and improve wellbeing.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'What problem do some urban areas face regarding soil?', 
 'Soil is too expensive', 'Poor soil quality and possible contamination', 'Too much fertile soil', 'Lack of interest in using soil', 'B', 
 'Previous industrial use can cause contamination.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'The word "resilience" in the passage means:', 
 'The ability to recover from difficulties', 'The ability to grow food faster', 'The desire to move to rural areas', 'The cost of production', 'A', 
 'It refers to a community’s ability to withstand shocks.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'According to the passage, vertical farms can produce:', 
 'Much less food than traditional farming', 'Up to 100 times more food per square metre than traditional farming', 'Only decorative plants', 'Food only for rich people', 'B', 
 'Technological advances allow much higher yields.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'Which cities are mentioned as having ambitious urban agriculture programmes?', 
 'London and Paris', 'Singapore, Tokyo, New York and Amsterdam', 'Beijing and Moscow', 'Cairo and Riyadh', 'B', 
 'These cities are actively supporting urban farming.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'What is a "food desert"?', 
 'An area with too much agriculture', 'An area with limited access to affordable fresh produce', 'A desert used for farming', 'A type of vertical farm', 'B', 
 'Urban farms help address areas lacking fresh food.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'The passage suggests that urban farming is likely to become more important because of:', 
 'Decreasing city populations', 'Increasing urbanisation and climate change', 'Reduced interest in healthy eating', 'Lower food prices globally', 'B', 
 'Urbanisation and unpredictable climate make local food production valuable.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'Which of the following is NOT mentioned as a challenge of urban farming?', 
 'Limited space', 'High setup costs', 'Lack of interest from governments', 'Contamination of soil', 'C', 
 'Governments are actually beginning to support it.', 'MULTIPLE_CHOICE', 'MEDIUM'),

(v_course_id, v_paper_id, u6, g9, 'The writer’s overall attitude towards urban farming is:', 
 'Highly critical', 'Cautiously positive', 'Completely negative', 'Indifferent', 'B', 
 'The passage highlights benefits while acknowledging challenges.', 'MULTIPLE_CHOICE', 'HARD'),

(v_course_id, v_paper_id, u6, g9, 'The passage implies that urban farming will:', 
 'Completely replace traditional rural agriculture', 'Play a valuable supporting role in future food systems', 'Only be useful for wealthy cities', 'Increase global food miles', 'B', 
 'It is presented as a useful component of a more resilient food system.', 'MULTIPLE_CHOICE', 'HARD');
 END $$;