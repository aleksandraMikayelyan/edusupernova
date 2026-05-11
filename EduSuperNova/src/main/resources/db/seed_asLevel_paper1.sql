DO $$
DECLARE
    v_eng_id      INTEGER;
    v_unit_1      INTEGER; -- Writing
    v_unit_2      INTEGER; -- Reading
    v_paper_id    INTEGER;
    v_group_id    INTEGER;
    g2 INTEGER; 
    g3 INTEGER;
    g4 INTEGER;
    g5 INTEGER;
    g6 INTEGER;
    g7 INTEGER;
    g8 INTEGER;
    g9 INTEGER;
    g10 INTEGER;
    g11 INTEGER;
    g12 INTEGER;
    g13 INTEGER;
    g14 INTEGER;
    g15 INTEGER;
BEGIN

    -- 1. Resolve existing IDs from your DB
    SELECT idcourse INTO v_eng_id FROM courses WHERE lower(coursename) = 'as level english' LIMIT 1;
    SELECT idpaper INTO v_paper_id FROM papers WHERE idcourse = v_eng_id AND papername = 'Paper 1' LIMIT 1;
    
    -- Mapping units based on your specific Paper 1 structure
    --SELECT idunit INTO v_unit_1 FROM units WHERE idcourse = v_eng_id AND queue = 1 LIMIT 1;
    --SELECT idunit INTO v_unit_2 FROM units WHERE idcourse = v_eng_id AND queue = 2 LIMIT 1;

    -- 2. Insert the Source Passage (Question Group)
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 1', 
    'The old seaside town had once depended entirely on summer visitors. In faded photographs displayed in the local museum, the promenade appears crowded with families holding striped umbrellas while children leaned dangerously over the railings with melting ice creams in their hands. The photographs are filled with colour and movement, even though time has drained the actual images into pale shades of grey.

    Today, however, the town feels quieter. Many of the amusement arcades stand half-empty even during July, and several hotels have been converted into apartment blocks occupied mostly by retirees. Along the seafront, souvenir shops still sell postcards and buckets for the beach, but customers wander through them slowly, more out of habit than excitement.

    Yet there are signs of revival. In recent years, artists and café owners have begun moving into abandoned buildings near the harbour. Murals now cover walls that once carried advertisements for forgotten attractions. On weekends, small outdoor markets attract visitors from nearby cities who arrive searching for handmade food, vintage clothing and a version of coastal life that feels authentic rather than commercial.

    Local residents disagree sharply about these changes. Some welcome the investment and energy brought by newcomers. Others argue that the town is becoming less affordable and increasingly designed for tourists rather than the people who actually live there. A retired fisherman interviewed outside the harbour described the transformation bitterly:

    “They say they’re saving the town, but they’re turning it into somewhere I barely recognise.”

    Despite this tension, the town continues to reinvent itself. At sunset, cafés fill with customers, musicians perform along the promenade, and the sea reflects the orange light in a way that briefly makes the place feel timeless again.', 
    1) RETURNING id INTO v_group_id;

    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 1', 
    'When the Riverside Library first opened in 1924, local newspapers described it as “a palace of learning for ordinary people.” At the time, the building stood proudly at the centre of the town: a wide stone staircase led visitors towards tall oak doors, and enormous windows filled the reading rooms with natural light. For decades, students revised for exams there, elderly residents read newspapers beside the radiators during winter afternoons, and children attended storytelling sessions every Saturday morning.

    Now, however, the future of the library is uncertain.

    Last month, the town council announced plans to reduce funding significantly, arguing that fewer people use the building than in previous generations. According to official reports, most residents prefer digital services, online books and remote working spaces. The council has proposed replacing part of the library with a modern fitness centre and a café designed to “increase community engagement”.

    Not everyone supports the decision. A protest group formed within days of the announcement, attracting teachers, students and long-time residents. Outside the library entrance, campaign posters declare: “Communities need libraries more than ever.” Volunteers have organised public readings and donation events in an attempt to demonstrate the building’s continued importance.

    Critics of the protest movement argue that the library’s defenders are motivated mainly by nostalgia. They point out that some sections of the building remain almost empty for entire afternoons and that maintenance costs continue to rise each year. One councillor commented during a local radio interview:

    “We cannot preserve every old building simply because people feel emotionally attached to it.”

    Even so, many residents insist that the library represents something larger than books alone. They describe it as one of the few public spaces where people of different ages and backgrounds can exist together without pressure to spend money. A university student interviewed during the protest explained:

    “If this place disappears, the town loses part of its identity.”

    For now, the library remains open, although uncertainty hangs over it. Each evening, as the lights inside the reading rooms glow against the darkening streets, campaigners continue gathering outside with petitions in their hands.', 
        1) RETURNING id INTO g2;
    -- 3. Insert the Question Patterns
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, 
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    -- Pattern for Section A: Directed Writing
    (v_eng_id, v_paper_id, NULL, 
        'Imagine that you are a tourism officer attempting to encourage young professionals to visit the town for a long weekend.

    Write the text for a promotional online article.

    In your writing, create a positive view of the town and adapt the material in Text A for your audience and purpose.

    Write between 150 and 200 words.', 
    NULL, NULL, NULL, NULL, 
    'Model answer: candidates should identify rhetorical devices, sentence structure, and tone with textual evidence.', 
    'Criteria: Accuracy to source, appropriate register, and adherence to the word count.', 
    'ESSAY', 'MEDIUM', v_group_id, 1),

    -- Pattern for Section B: Text Analysis
    (v_eng_id, v_paper_id, NULL, 
    'Compare the form, structure and language of your text with the pasage provided', 
    NULL, NULL, NULL, NULL, 
    'Model answer: candidates should identify rhetorical devices, sentence structure, and tone with textual evidence.', 
    'Criteria: Evidence of language analysis (imagery, syntax, tone, register, structure, figurative language) and structural techniques.', 
    'ESSAY', 'MEDIUM', v_group_id, 2);

    -- 3. Insert the Question Patterns
    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond, 
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    -- Pattern for Section A: Directed Writing
    (v_eng_id, v_paper_id, NULL, 
    'Imagine that you are a member of the protest group campaigning to save the library.

    Write the text for a speech to be delivered at a public meeting.

    In your writing, create a persuasive argument supporting the library and adapt the material in Text A for your audience and purpose.

    Write between 150 and 200 words.', 
    NULL, NULL, NULL, NULL, 
    'Model answer: candidates should identify rhetorical devices, sentence structure, and tone with textual evidence.', 
    'Criteria: Accuracy to source, appropriate register, and adherence to the word count.', 
    'ESSAY', 'MEDIUM', g2, 1),

    -- Pattern for Section B: Text Analysis
    (v_eng_id, v_paper_id, NULL, 
    'Compare the form, structure and language of your text with the pasage provided', 
    NULL, NULL, NULL, NULL, 
    'Model answer: candidates should identify rhetorical devices, sentence structure, and tone with textual evidence.', 
    'Criteria: Evidence of language analysis (imagery, syntax, tone, register, structure, figurative language) and structural techniques.', 
    'ESSAY', 'MEDIUM', g2, 2);

    -- ============================================================
    -- PASSAGE 3: Urban Green Space Under Threat
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 3',
    'The park has existed for longer than anyone in the neighbourhood can reliably remember. Old maps show it occupying its triangular patch of land before the surrounding streets were even named. Plane trees planted along its perimeter have grown wide enough that two adults cannot reach their arms around the trunks, and on summer evenings their canopy closes off the sky above the central path in a way that feels almost deliberate, as though the trees had agreed among themselves to provide shelter.

    For decades, the park functioned as an informal meeting place. Office workers ate lunch on the benches; parents waited on the grass while children tested themselves on the climbing frames; teenagers gathered at the far corner near the fountain after school. The park was never grand or particularly well-maintained. The fountain stopped working sometime in the 1990s, and the benches carry decades of carved initials. But the very ordinariness of it seemed to be the point.

    Last year, the council announced that a private developer had submitted plans to build a retail and leisure complex on the site. The proposal includes a supermarket, a gym and underground parking. A small strip of replacement green space would be provided alongside the development — a narrow rectangle of grass approximately thirty metres long, positioned between the car park exit and a dual carriageway.

    The announcement provoked immediate reaction. Within forty-eight hours, a local campaign group had gathered nearly four thousand signatures opposing the plans. Children from the nearby primary school produced drawings of the trees and wrote letters addressed to the mayor. At a public consultation event held in the community centre, residents queued outside the building before the doors opened.

    Supporters of the development argue that the retail complex will generate jobs and investment in an area with high unemployment. The developer''s promotional materials describe the project as "transforming a neglected space into a vibrant community hub." The council has pointed out that maintenance costs for the park have increased by thirty percent over the past five years.

    Yet critics note that the replacement green space is barely visible on the development plans and that no equivalent proposal has been offered for the mature trees themselves, which would be felled. A local ecologist described the loss of the existing canopy as "irreversible within any meaningful human timescale."

    The planning committee is due to reach a decision in the spring.',
    1) RETURNING id INTO g3;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are a parent who regularly uses the park with your children and who opposes the development.

Write the text for a formal letter to the chair of the planning committee.

In your writing, present a persuasive case against the development and adapt the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt a formal letter register, use first-person voice, deploy logical argument supported by evidence from the text, and appeal to community values and environmental concern.',
    'Criteria: Appropriate formal register, clear structure, persuasive techniques, accurate adaptation of source material, adherence to word count.',
    'ESSAY', 'MEDIUM', g3, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to present the park and the threat it faces.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should discuss descriptive detail, temporal framing, contrast between past and present, use of direct speech, objectivity versus implied sympathy, sentence variation and paragraph organisation.',
    'Criteria: Close analysis of language choices, structural techniques, tone and register with well-selected textual evidence.',
    'ESSAY', 'MEDIUM', g3, 2);

    -- ============================================================
    -- PASSAGE 4: Decline of a Fishing Community
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 4',
    'At four o''clock in the morning the harbour is already alive. Engines run quietly in the dark, and the smell of diesel and salt water reaches the street above the quay. Three boats have already left; two more are being loaded with equipment by men who know by long habit exactly where each item should go. There is almost no conversation. The work requires none.

    The village of Carrow Point has fished these waters for generations. In the community hall, a framed photograph taken in 1953 shows thirty-seven boats in the harbour at high tide. Today there are nine, and only five of those go out regularly. The rest are moored in various states of disrepair, their paintwork cracking and their hulls gradually accumulating weed below the waterline.

    The decline has several causes. European fishing quotas introduced in the 1990s dramatically reduced the quantity of fish that could be legally landed. Fuel prices rose steeply throughout the following decade. Larger commercial trawlers operating out of distant ports undercut the prices that local fishermen could achieve at market. One by one, the fleet contracted.

    Dennis Pellow has fished from Carrow Point for forty-one years. He learned the trade from his father, who learned it from his father before him. When asked whether any of his three children intend to follow him into the work, he pauses before answering.

    "My youngest considered it for a while. Then the quota figures came in for last year. That finished the conversation."

    The village has attempted to adapt. A small smokehouse opened on the quayside, selling cured fish and attracting visitors. Several fishermen have taken up offering guided sea-trips during summer months. The primary school holds an annual heritage day at which children learn rope-knot techniques and hear stories from retired fishermen.

    These are not solutions. They are, at best, gestures of preservation — ways of maintaining the memory of a way of life that is already, in all practical senses, ending. By the time the last boat leaves Carrow Point for the final time, there will be very little left to preserve except the photographs.',
    1) RETURNING id INTO g4;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are a travel writer who has visited Carrow Point and wishes to portray the community sympathetically to a general readership.

Write the text for a magazine article about Carrow Point and its fishing heritage.

In your writing, create an engaging and reflective portrait of the community and adapt the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt an engaging, descriptive register appropriate to travel writing, balance factual content with atmospheric detail, and use the source material selectively to create emotional resonance.',
    'Criteria: Appropriate travel-writing register, vivid language, coherent structure, faithful adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g4, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to convey the decline of the fishing community at Carrow Point.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should explore sensory opening, statistical detail, direct speech and its placement, the contrast between activity and decay, the final paragraph''s shift to a summary judgement, and the writer''s tone of restrained elegy.',
    'Criteria: Detailed language analysis, awareness of structure and tone, well-integrated textual evidence.',
    'ESSAY', 'MEDIUM', g4, 2);

    -- ============================================================
    -- PASSAGE 5: A Theatre''s Final Night
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 5',
    'The Criterion Theatre opened in 1911 and has not been significantly altered since. The seats are upholstered in a deep red fabric that has been replaced twice but always restored to the original colour. The stage is slightly raked, the proscenium arch carries plasterwork cherubs that were considered fashionable once and have since become eccentric, and the lighting rig above the stalls was installed in 1974 and has worked without serious fault for half a century.

    On Saturday evening, the Criterion hosted its final performance.

    The production was a revival of a play first staged in the building in 1963. Many in the audience had seen that original run. Several had seen the play here more than once over the intervening decades. One man seated near the front of the circle told the person beside him that he had been brought to the Criterion for the first time as a child of seven and had attended a performance in this building every year since. He was now sixty-three.

    During the interval, people moved slowly through the foyer, holding drinks and looking around with an attention they might not have brought on any previous visit — reading the framed programme covers on the walls, running their hands along the moulding of the bar counter, taking photographs of details they had passed unnoticed for years. A group of ushers who had worked at the theatre for decades stood together near the staircase, talking quietly.

    In the second half, there was a moment midway through the final act — a long pause in the dialogue, written into the script — when the silence in the auditorium became unusually complete. Afterwards, several people remarked on it independently without knowing that others had noticed the same thing.

    When the cast took their final bow, the applause continued for several minutes. Then the house lights came up, and people began to leave — slowly, by most accounts, and without much talking.',
    1) RETURNING id INTO g5;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are a theatre critic who attended the final performance and wish to honour both the production and the theatre''s history.

Write the text of a review for a national arts publication.

In your writing, evoke the atmosphere of the evening and reflect on what the theatre''s closure means, adapting the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt a review register combining evaluative language with reflective, elegiac tone; reference theatrical detail from the passage; and address a culturally engaged readership with appropriate vocabulary.',
    'Criteria: Appropriate review register and voice, reflective tone, language precision, adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g5, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to capture the significance of the theatre''s final evening.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should examine factual and historical framing, the contrast between routine detail and emotional weight, the use of the interval scene and collective behaviour, the scripted silence as pivotal moment, and the restrained, understated closing sentence.',
    'Criteria: Perceptive analysis, close attention to language choices, structural awareness, integrated evidence.',
    'ESSAY', 'MEDIUM', g5, 2);

    -- ============================================================
    -- PASSAGE 6: A Teacher Who Changed a School
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 6',
    'When Marcus Webb arrived at Northgate Secondary School in September 2009, the school had been in special measures for two years. Inspection reports described "widespread disengagement," "low staff morale" and "a learning environment that fails to meet the needs of its pupils." Twenty-three percent of students achieved five GCSEs at grade C or above. The corridor walls, according to one inspector''s report, were "bare and institutional."

    Fifteen years later, the walls of those same corridors are covered from floor to ceiling with student artwork, poetry, technical diagrams and photographs of school trips to places as distant as Iceland and Mozambique. Last year, seventy-nine percent of students achieved five GCSEs at grade four or above.

    Webb, now fifty-one, is head teacher. He would prefer to discuss the work of his staff than to speak about himself, and deflects personal credit with a persistence that becomes, eventually, its own form of communication. He is, his colleagues suggest, much the same in private as he appears in public: calm, genuinely curious about other people, and possessed of an almost total inability to walk past a student in a corridor without stopping to ask them a question.

    His first act upon arriving at the school was not to introduce a new teaching framework or to address staff performance. Instead, he repainted the entrance hall over a single weekend, with the help of three teachers who came in voluntarily. He then displayed student work in every available space.

    "I wanted students to walk in on Monday morning and see themselves," he explains. "Not posters someone bought. Their work. Proof that this school thought their ideas mattered."

    The change was not immediate, and Webb is careful to say so. The transformation of a school culture, he argues, cannot be reduced to a single intervention or a single person. What he offered, he suggests, was consistency — the same priorities, the same responses, the same expectations, maintained year after year until the institution began to hold their shape on its own.',
    1) RETURNING id INTO g6;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are Marcus Webb, delivering a speech to newly qualified teachers at a national education conference.

Write the text of his speech.

In your writing, inspire and advise your audience about what it means to lead meaningful change in a school, adapting the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt first-person speech register with direct address, inspirational but grounded tone, draw on Webb''s philosophy as presented in the passage, and structure the speech effectively with a clear opening and close.',
    'Criteria: Appropriate speech register and rhetorical features, consistent persona, persuasive and inspiring tone, adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g6, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to present Marcus Webb and the school''s transformation.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should examine the contrast between the 2009 inspection language and the present, the use of statistics, direct speech and its placement, the description of Webb''s character through others'' observations, and the writer''s balanced, slightly admiring but measured tone.',
    'Criteria: Close reading of language and structure, awareness of the writer''s craft, analytical vocabulary, well-selected evidence.',
    'ESSAY', 'MEDIUM', g6, 2);

    -- ============================================================
    -- PASSAGE 7: Rewilding Project Controversy
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 7',
    'Five years ago, the Harwick Estate covered four thousand acres of intensively farmed land in the upland region of northern England. Sheep grazed the hillsides in numbers that kept the vegetation close-cropped and uniform; drainage channels ran in straight lines across the valley floors; and the rivers, constrained between reinforced banks, moved quickly through the landscape without pause.

    Today, the sheep are gone. The drainage channels have been blocked and the valley floors are reverting to marshy ground from which clumps of willow and alder are already emerging. The rivers have been allowed to meander freely, and in doing so have slowed, widened in places and created shallow areas that the estate''s ecologists describe as ideal habitat for a range of species not recorded on the land for decades. Last spring, otters were photographed on the estate for the first time in recorded history.

    The project has attracted considerable attention, and not all of it welcome. Farmers in the surrounding valleys argue that the rewilded land is allowing water to spread in ways that increase flood risk to their properties. One neighbouring farmer, whose low-lying fields flooded twice during the previous winter, is currently pursuing a formal complaint against the estate.

    Proponents of rewilding counter that the restored wetlands and meandering rivers actually reduce flood peaks downstream, by holding water in the landscape rather than channelling it rapidly away. The scientific evidence, they argue, supports this position clearly. The neighbouring farmer, they suggest, is experiencing the legacy of historical drainage decisions, not the consequences of rewilding.

    The debate has acquired a wider dimension. Critics of the rewilding movement argue that replacing productive agricultural land with wilderness amounts to an abandonment of the responsibility to feed people. Supporters respond that the land in question was never highly productive and that the ecological services provided by a functioning wetland — carbon storage, flood regulation, biodiversity — represent a different and equally valid form of value.

    The estate plans to introduce a small number of beavers later this year. The response from neighbouring landowners has been, in the project coordinator''s understated description, "mixed."',
    1) RETURNING id INTO g7;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are the coordinator of the rewilding project, writing for the estate''s public website.

Write a web article aimed at an interested general audience, presenting the project positively and explaining its purpose and achievements.

In your writing, adapt the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt an accessible, enthusiastic register appropriate for public engagement; highlight positive outcomes such as the otter sighting; acknowledge but downplay controversy; use second-person address or inviting language to draw the reader in.',
    'Criteria: Appropriate web-article register, positive but credible tone, engagement with audience, adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g7, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to explore the rewilding project and the debate surrounding it.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should examine the contrast between the two landscape descriptions, the use of technical and scientific language, the balanced presentation of opposing voices, verb choices suggesting natural agency, and the dry humour of the final line.',
    'Criteria: Perceptive language analysis, structural awareness, balanced critical response, integrated textual evidence.',
    'ESSAY', 'MEDIUM', g7, 2);

    -- ============================================================
    -- PASSAGE 8: A Dying Dialect
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 8',
    'In the village of Eckston, tucked into a narrow valley in the northern moorlands, a handful of elderly residents still speak a dialect so distinct that linguists from two universities have spent the past decade recording it. The dialect contains words not found in any neighbouring community — terms for specific weather conditions, for the different qualities of moorland peat, for the subtle gradations of relationship between neighbours that standard English collapses into a single inadequate word.

    Joan Metcalfe, eighty-two, is one of perhaps fifteen fluent speakers remaining. She learned the dialect as a child and speaks it still when she encounters one of the others. She is precise and unsentimental when asked what she thinks will happen to it.

    "It''ll go when we go. You can''t really stop that. You can record it — they''ve been here with their microphones — but a recording isn''t a language. A language is people talking."

    The university team has done exactly what Joan describes: built an extensive digital archive of recordings, transcriptions and grammatical analyses. The archive is available online and has attracted interest from academic linguists internationally. School children in the valley have participated in workshops where they learn dialect words and practice short phrases.

    The workshops are popular. Whether they represent preservation or commemoration is a question the project''s lead researcher chooses not to answer directly.

    Language loss, she explains, is not a simple tragedy. Languages and dialects disappear because communities change — because young people move to cities, because employment patterns shift, because identities evolve. Attempting to freeze a dialect in place might, she suggests, be a form of condescension: treating a living community as a heritage exhibit.

    And yet. In Eckston, there is a word — rendered approximately as ''threave'' in the research papers — that describes the particular quality of light on the moor in late afternoon in autumn. There is no equivalent word in standard English. When Joan Metcalfe dies, the capacity to name that light precisely will very probably die with her.',
    1) RETURNING id INTO g8;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are a journalist writing for a culture and heritage magazine, aiming to make readers feel the significance of what is being lost.

Write the opening section of a feature article about the Eckston dialect.

In your writing, engage your readers emotionally and intellectually, adapting the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should use evocative, literary language to draw readers in; deploy the specific example of ''threave'' for emotional effect; balance academic information with accessible prose; and adopt the feature journalism register.',
    'Criteria: Engaging opening, appropriate feature register, emotional and intellectual appeal, adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g8, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to convey the significance of the dialect and the complexity of preserving it.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should examine the specificity of dialect description, Joan Metcalfe''s direct speech and its authority, the researcher''s balanced perspective, the deliberate structural pause of "And yet," and the final paragraph''s use of a concrete example to crystallise the abstract argument.',
    'Criteria: Close analysis of language and structure, awareness of tone shifts, perceptive reading, well-chosen evidence.',
    'ESSAY', 'MEDIUM', g8, 2);

    -- ============================================================
    -- PASSAGE 9: Young People Leaving Rural Communities
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 9',
    'The village of Dunsthorpe once supported a post office, two pubs, a butcher''s shop, a primary school and a small branch of a regional bank. The post office closed in 2008, the bank in 2012, one pub in 2015 and the second in 2019. The primary school has twenty-one pupils — down from over ninety in 1990 — and governors have been formally notified that closure is under review.

    The cause, if one factor can be named above others, is the steady departure of young people. Between 2001 and 2021, the proportion of Dunsthorpe''s population aged between eighteen and thirty-five fell from twenty-two percent to nine percent. The village''s median age is now fifty-eight.

    Those who leave speak of opportunity. There is no reliable broadband connection in much of the village; the nearest train station is eleven miles away; and the agricultural and service-sector work available locally pays wages that make renting, let alone buying, in the village extremely difficult for anyone starting out. Ellie Grainger, twenty-four, left Dunsthorpe for the city eighteen months ago and does not plan to return.

    "I didn''t want to leave. I grew up here; my parents are here. But there''s no path for me here. The only people my age who stayed are the ones who inherited a farm or whose parents own a business."

    Those who remain — many of them retired — describe feelings that exist somewhere between sadness and resignation. They maintain the village''s social infrastructure through effort of will: the reading group, the monthly market, the annual fair. But they acknowledge that these activities are sustained by a generation that will not be replaced.

    A parish councillor who has lived in Dunsthorpe for sixty years was asked recently what the village would look like in thirty years. He thought for a long moment before answering.

    "It''ll be houses," he said. "Just houses."',
    1) RETURNING id INTO g9;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are Ellie Grainger, writing a personal blog post about your experience of leaving Dunsthorpe, intended for other young people from rural areas who face a similar decision.

Write the text of the blog post.

In your writing, reflect honestly on the experience and its emotional complexity, adapting the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt an informal, personal blog register with direct address to peers; convey ambivalence and emotional honesty; use conversational syntax; draw on specific details from the passage while adding personal voice.',
    'Criteria: Convincing blog persona, appropriate informal register, emotional authenticity, adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g9, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to present the decline of Dunsthorpe and its impact on the community.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should explore the list of lost services as an opening structural device, the precision of statistical data contrasted with personal testimony, the bleak humour of the councillor''s final words, and the writer''s controlled, understated tone.',
    'Criteria: Perceptive structural analysis, close reading of language choices, awareness of tone, integrated evidence.',
    'ESSAY', 'MEDIUM', g9, 2);

    -- ============================================================
    -- PASSAGE 10: A Street Food Market and Urban Identity
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 10',
    'On Saturday mornings, Venn Street transforms. For six days a week it is an ordinary city road: traffic moves steadily along it, a letting agency occupies the ground floor of one building, a phone repair shop the ground floor of another. But by eight o''clock on Saturday the road has been closed to vehicles, stalls are arranged in two facing rows along its length, and the street acquires a completely different character.

    The market has operated here for eleven years. It began with seven stalls. There are now over forty. The offer has evolved considerably — there are fewer conventional fruit and vegetable sellers than in the early years and more prepared food from a wider range of culinary traditions. Ethiopian injera, Jamaican saltfish fritters, Korean fried chicken, hand-rolled pasta and locally produced cheese now occupy the same hundred metres of pavement. The resulting combination of smells is, on a still morning, genuinely extraordinary.

    The market attracts visitors from across the city and occasionally beyond it. On a busy Saturday the footfall can exceed three thousand people. Sociologists who have studied street markets in urban environments describe them as spaces of managed informality — places where social mixing occurs because the structure of the space encourages encounter without demanding it.

    Not everyone finds the transformation of Venn Street uncomplicated. Several long-term residents of the surrounding streets describe the Saturday crowds as disruptive. Parking becomes impossible; noise levels rise significantly; and the particular quality of the morning — leisurely, unhurried, local — is altered by the volume of people arriving by car and bicycle from other parts of the city.

    The market''s manager, Rosa Iliffe, acknowledges the tension with genuine openness. She argues, however, that the market''s success has materially benefited the surrounding area, pointing to reduced vacancy rates in local shops and increased investment in the street''s infrastructure.

    "The street is for everyone," she says. "That''s either a problem or an asset, depending on how you look at it."',
    1) RETURNING id INTO g10;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are Rosa Iliffe, writing a newsletter article for local residents to celebrate the market''s anniversary and address concerns about its impact on the neighbourhood.

Write the text of the newsletter article.

In your writing, strike a balance between enthusiasm for the market and sensitivity to residents'' concerns, adapting the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt a community newsletter register — warm, inclusive, addressing the audience as neighbours; acknowledge tensions honestly; use positive evidence from the passage; and structure the piece to move from celebration to reassurance.',
    'Criteria: Appropriate newsletter register, balanced and diplomatic tone, clear structure, adaptation of source material, adherence to word count.',
    'ESSAY', 'MEDIUM', g10, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to portray the market and its place in the life of the street.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should examine the contrast between the street''s weekday and Saturday identity, the accumulation of culinary detail and its sensory effect, the academic framing of the sociologist''s description, the presentation of competing perspectives, and Rosa Iliffe''s closing quotation as a tonal summary.',
    'Criteria: Close language analysis, structural awareness, recognition of multiple perspectives in the text, well-integrated evidence.',
    'ESSAY', 'MEDIUM', g10, 2);

    -- ============================================================
    -- PASSAGE 11: Restoring a Derelict Cinema
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 11',
    'The Palladium Cinema opened in 1937 and closed in 1989. In the intervening fifty-two years it had shown newsreels, wartime propaganda films, Hollywood epics, children''s Saturday matinees and, in its final decade, a declining programme that could not compete with the multiplex that had opened on the retail park at the edge of town. The closure was announced on a Friday; by the following Monday the projection booth had been stripped and the screen removed.

    For thirty years the building sat empty. The art deco facade, with its distinctive fan of terracotta tiles above the entrance, was listed by the local authority as a heritage asset, which ensured that the structure could not be demolished but provided no funds to maintain it. Each winter the building deteriorated a little further. Pigeons colonised the upper levels; roof sections collapsed inward; and the foyer, visible through grime-covered glass doors, accumulated the particular stillness of a place that has been left to its own company for too long.

    Three years ago, a community trust raised enough money through grants and public fundraising to begin restoration work. The project has been more complicated than anticipated. Behind the listed facade, the interior required almost complete reconstruction. Original features that appeared intact proved, on closer examination, to have been compromised by decades of water damage.

    The Palladium is expected to reopen next spring. Its programme will include independent films, live music events, community screenings and a weekly children''s session that echoes, consciously, the Saturday matinees of sixty years ago.

    Among those who contributed to the fundraising campaign is a man who saw his first film at the Palladium in 1961. He was three years old, taken by his grandmother, and has no memory of the film itself. What he remembers is the ceiling — an ornate plasterwork vault, painted midnight blue with small gold stars — which he mistook, briefly and entirely, for the actual sky.',
    1) RETURNING id INTO g11;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are the chair of the community trust, writing a fundraising appeal to the general public to help complete the final phase of the restoration.

Write the text of the fundraising appeal, to be distributed as a leaflet.

In your writing, inspire readers to contribute by connecting them to the cinema''s history and its future potential, adapting the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should use an emotive, direct register with calls to action; appeal to shared memory and civic pride; use specific detail from the passage for authenticity; and structure the leaflet logically from past to present to future.',
    'Criteria: Persuasive fundraising register, emotional appeal, logical structure, adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g11, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to convey the history of the Palladium Cinema and the significance of its restoration.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should examine the compressed historical narrative of the opening paragraph, the personification of the empty building, the understated humour of the listing providing protection but no money, the shift to hope in the restoration section, and the final anecdote as an emotional anchor for the whole piece.',
    'Criteria: Detailed structural analysis, close reading of language effects, recognition of tone shifts, well-selected evidence.',
    'ESSAY', 'MEDIUM', g11, 2);

    -- ============================================================
    -- PASSAGE 12: An Athlete''s Return from Injury
    -- ============================================================
    INSERT INTO question_groups (idpaper, title, contexttext, orderindex)
    VALUES (v_paper_id, 'Passage 12',
    'The first time Priya Nair ran competitively after her injury, she finished seventh. She had expected this. What she had not expected was how seventh would feel — not diminished, as she had feared, but strangely clear. She crossed the line, stopped her watch and stood for a moment with her hands on her knees, breathing, which was all she had been able to do for months.

    The injury had occurred during a training session in October of the previous year. A stress fracture in her left tibia, sustained over years of high mileage, announced itself without ceremony during an ordinary Wednesday run. She was not sprinting. She was not doing anything unusual. The bone simply reached a point at which it could no longer carry the load, and that was that. She hopped to the roadside, sat on a low wall and called her coach.

    The months that followed were the longest of her career. She had been running since the age of eleven and had never previously experienced an enforced break of more than two weeks. The injury removed not only competition but the daily structure that running had provided for twenty years. She found herself waking at the times she would normally have left for training and lying in the unfamiliar stillness of a morning with nowhere to go.

    Rehabilitation was careful and slow. Her physiotherapist, she says, was "pathologically patient" — a quality she did not initially appreciate. The return to running began with ten-minute walks, progressed to twenty, and eventually allowed brief jog intervals so cautious that she felt, as she puts it, "like a child learning to walk in the body of an adult."

    The race in which she finished seventh was, she insists, the start of something rather than a return to something. The two are different. She is running on different terms now — more aware of the body''s limits, more grateful for its capacities, and less interested in what finishing seventh might mean to anyone watching.',
    1) RETURNING id INTO g12;

    INSERT INTO quizes (idcourse, idpaper, idunit, questiontext, optiona, optionb, optionc, optiond,
                        correctanswer, explanation, question_type, difficulty, idquestiongroup, grouporderindex)
    VALUES
    (v_eng_id, v_paper_id, NULL,
    'Imagine that you are Priya Nair, writing a personal essay for a sports magazine aimed at athletes who are currently recovering from injury.

Write the text of the personal essay.

In your writing, reflect honestly on the experience of injury and recovery, and offer perspective to your audience, adapting the material in the passage for your audience and purpose.

Write between 150 and 200 words.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should adopt a first-person personal essay register with an honest, reflective and quietly encouraging tone; use specific detail from the passage to maintain authenticity; address the reader in a way that acknowledges shared experience; and shape the piece around a clear emotional arc.',
    'Criteria: Convincing first-person voice, appropriate personal essay register, reflective tone, adaptation of source, adherence to word count.',
    'ESSAY', 'MEDIUM', g12, 1),

    (v_eng_id, v_paper_id, NULL,
    'Analyse how the writer uses language and structure to explore Priya Nair''s experience of injury and recovery.',
    NULL, NULL, NULL, NULL,
    'Model answer: candidates should examine the in medias res opening and its emotional subversion, the precise and unemotional account of the injury itself, the description of disrupted daily routine, the direct speech used for character and tone, and the final paragraph''s distinction between ''a return'' and ''a start'' as a structural and thematic resolution.',
    'Criteria: Perceptive analysis of structure and language, awareness of the writer''s craft, analytical vocabulary, well-integrated textual evidence.',
    'ESSAY', 'MEDIUM', g12, 2);

END $$;