# coding: utf-8
# This file is included in the db/seeds.rb file

Factory.define :achiever, :class => StrengthTheme do |st|
  st.theme "Achiever"
  st.brief_description "People who are especially talented in the Achiever theme have a great deal of stamina and work hard. They take great satisfaction from being busy and productive."
  st.long_description "Your Achiever theme helps explain your drive. Achiever describes a constant need for achievement. You feel as if every day starts at zero. By the end of the day you must achieve something tangible in order to feel good about yourself. And by “every day” you mean every single day — workdays, weekends, vacations. No matter how much you may feel you deserve a day of rest, if the day passes without some form of achievement, no matter how small, you will feel dissatisfied. You have an internal fire burning inside you. It pushes you to do more, to achieve more. After each accomplishment is reached, the fire dwindles for a moment, but very soon it rekindles itself, forcing you toward the next accomplishment. Your relentless need for achievement might not be logical. It might not even be focused. But it will always be with you. As an Achiever you must learn to live with this whisper of discontent. It does have its benefits. It brings you the energy you need to work long hours without burning out. It is the jolt you can always count on to get you started on new tasks, new challenges. It is the power supply that causes you to set the pace and define the levels of productivity for your work group. It is the theme that keeps you moving."
end

Factory.define :activator, :class => StrengthTheme do |st|
  st.theme "Activator"
  st.brief_description "People who are especially talented in the Activator theme can make things happen by turning thoughts into action. They are often impatient."
  st.long_description "“When can we start?“ This is a recurring question in your life. You are impatient for action. You may concede that analysis has its uses or that debate and discussion can occasionally yield some valuable insights, but deep down you know that only action is real. Only action can make things happen. Only action leads to performance. Once a decision is made, you cannot not act. Others may worry that “there are still some things we don’t know,” but this doesn’t seem to slow you. If the decision has been made to go across town, you know that the fastest way to get there is to go stoplight to stoplight. You are not going to sit around waiting until all the lights have turned green. Besides, in your view, action and thinking are not opposites. In fact, guided by your Activator theme, you believe that action is the best device for learning. You make a decision, you take action, you look at the result, and you learn. This learning informs your next action and your next. How can you grow if you have nothing to react to? Well, you believe you can’t. You must put yourself out there. You must take the next step. It is the only way to keep your thinking fresh and informed. The bottom line is this: You know you will be judged not by what you say, not by what you think, but by what you get done. This does not frighten you. It pleases you."
end

Factory.define :adaptability, :class => StrengthTheme do |st|
  st.theme "Adaptability"
  st.brief_description "People who are especially talented in the Adaptability theme prefer to “go with the flow.” They tend to be “now” people who take things as they come and discover the future one day at a time."
  st.long_description "You live in the moment. You don’t see the future as a fixed destination. Instead, you see it as a place that you create out of the choices that you make right now. And so you discover your future one choice at a time. This doesn’t mean that you don’t have plans. You probably do. But this theme of Adaptability does enable you to respond willingly to the demands of the moment even if they pull you away from your plans. Unlike some, you don’t resent sudden requests or unforeseen detours. You expect them. They are inevitable. Indeed, on some level you actually look forward to them. You are, at heart, a very flexible person who can stay productive when the demands of work are pulling you in many different directions at once."
end

Factory.define :analytical, :class => StrengthTheme do |st|
  st.theme "Analytical"
  st.brief_description "People who are especially talented in the Analytical theme search for reasons and causes. They have the ability to think about all the factors that might affect a situation."
  st.long_description  "Your Analytical theme challenges other people: “Prove it. Show me why what you are claiming is true.” In the face of this kind of questioning some will find that their brilliant theories wither and die. For you, this is precisely the point. You do not necessarily want to destroy other people’s ideas, but you do insist that their theories be sound. You see yourself as objective and dispassionate. You like data because they are value free. They have no agenda. Armed with these data, you search for patterns and connections. You want to understand how certain patterns affect one another. How do they combine? What is their outcome? Does this outcome fit with the theory being offered or the situation being confronted? These are your questions. You peel the layers back until, gradually, the root cause or causes are revealed. Others see you as logical and rigorous. Over time they will come to you in order to expose someone’s “wishful thinking” or “clumsy thinking” to your refining mind. It is hoped that your analysis is never delivered too harshly. Otherwise, others may avoid you when that “wishful thinking” is their own."
end

Factory.define :arranger, :class => StrengthTheme do |st|
  st.theme "Arranger"
  st.brief_description "People who are especially talented in the Arranger theme can organize, but they also have a flexibility that complements this ability. They like to figure out how all of the pieces and resources can be arranged for maximum productivity."
  st.long_description  "You are a conductor. When faced with a complex situation involving many factors, you enjoy managing all of the variables, aligning and realigning them until you are sure you have arranged them in the most productive configuration possible. In your mind there is nothing special about what you are doing. You are simply trying to figure out the best way to get things done. But others, lacking this theme, will be in awe of your ability. “How can you keep so many things in your head at once?” they will ask. “How can you stay so flexible, so willing to shelve well-laid plans in favor of some brand-new configuration that has just occurred to you?” But you cannot imagine behaving in any other way. You are a shining example of effective flexibility, whether you are changing travel schedules at the last minute because a better fare has popped up or mulling over just the right combination of people and resources to accomplish a new project. From the mundane to the complex, you are always looking for the perfect configuration. Of course, you are at your best in dynamic situations. Confronted with the unexpected, some complain that plans devised with such care cannot be changed, while others take refuge in the existing rules or procedures. You don’t do either. Instead, you jump into the confusion, devising new options, hunting for new paths of least resistance, and figuring out new partnerships — because, after all, there might just be a better way."
end

Factory.define :belief, :class => StrengthTheme do |st|
  st.theme "Belief"
  st.brief_description "People who are especially talented in the Belief theme have certain core values that are unchanging. Out of these values emerges a defined purpose for their life."
  st.long_description  "If you possess a strong Belief theme, you have certain core values that are enduring. These values vary from one person to another, but ordinarily your Belief theme causes you to be family-oriented, altruistic, even spiritual, and to value responsibility and high ethics — both in yourself and others. These core values affect your behavior in many ways. They give your life meaning and satisfaction; in your view, success is more than money and prestige. They provide you with direction, guiding you through the temptations and distractions of life toward a consistent set of priorities. This consistency is the foundation for all your relationships. Your friends call you dependable. “I know where you stand,” they say. Your Belief makes you easy to trust. It also demands that you find work that meshes with your values. Your work must be meaningful; it must matter to you. And guided by your Belief theme it will matter only if it gives you a chance to live out your values."
end

Factory.define :command, :class => StrengthTheme do |st|
  st.theme "Command"
  st.brief_description "People who are especially talented in the Command theme have presence. They can take control of a situation and make decisions."
  st.long_description  "Command leads you to take charge. Unlike some people, you feel no discomfort with imposing your views on others. On the contrary, once your opinion is formed, you need to share it with others. Once your goal is set, you feel restless until you have aligned others with you. You are not frightened by confrontation; rather, you know that confrontation is the first step toward resolution. Whereas others may avoid facing up to life’s unpleasantness, you feel compelled to present the facts or the truth, no matter how unpleasant it may be. You need things to be clear between people and challenge them to be clear-eyed and honest. You push them to take risks. You may even intimidate them. And while some may resent this, labeling you opinionated, they often willingly hand you the reins. People are drawn toward those who take a stance and ask them to move in a certain direction. Therefore, people will be drawn to you. You have presence. You have Command."
end

Factory.define :communication, :class => StrengthTheme do |st|
  st.theme "Communication"
  st.brief_description "People who are especially talented in the Communication theme generally find it easy to put their thoughts into words. They are good conversationalists and presenters."
  st.long_description  "You like to explain, to describe, to host, to speak in public, and to write. This is your Communication theme at work. Ideas are a dry beginning. Events are static. You feel a need to bring them to life, to energize them, to make them exciting and vivid. And so you turn events into stories and practice telling them. You take the dry idea and enliven it with images and examples and metaphors. You believe that most people have a very short attention span. They are bombarded by information, but very little of it survives. You want your information — whether an idea, an event, a product’s features and benefits, a discovery, or a lesson — to survive. You want to divert their attention toward you and then capture it, lock it in. This is what drives your hunt for the perfect phrase. This is what draws you toward dramatic words and powerful word combinations. This is why people like to listen to you. Your word pictures pique their interest, sharpen their world, and inspire them to act."
end

Factory.define :competition, :class => StrengthTheme do |st|
  st.theme "Competition"
  st.brief_description "People who are especially talented in the Competition theme measure their progress against the performance of others. They strive to win first place and revel in contests."
  st.long_description  "Competition is rooted in comparison. When you look at the world, you are instinctively aware of other people’s performance. Their performance is the ultimate yardstick. No matter how hard you tried, no matter how worthy your intentions, if you reached your goal but did not outperform your peers, the achievement feels hollow. Like all competitors, you need other people. You need to compare. If you can compare, you can compete, and if you can compete, you can win. And when you win, there is no feeling quite like it. You like measurement because it facilitates comparisons. You like other competitors because they invigorate you. You like contests because they must produce a winner. You particularly like contests where you know you have the inside track to be the winner. Although you are gracious to your fellow competitors and even stoic in defeat, you don’t compete for the fun of competing. You compete to win. Over time you will come to avoid contests where winning seems unlikely. "
end

Factory.define :connectedness, :class => StrengthTheme do |st|
  st.theme "Connectedness"
  st.brief_description "People who are especially talented in the Connectedness theme have faith in the links between all things. They believe there are few coincidences and that almost every event has a reason."
  st.long_description  "Things happen for a reason. You are sure of it. You are sure of it because in your soul you know that we are all connected. Yes, we are individuals, responsible for our own judgments and in possession of our own free will, but nonetheless we are part of something larger. Some may call it the collective unconscious. Others may label it spirit or life force. But whatever your word of choice, you gain confidence from knowing that we are not isolated from one another or from the earth and the life on it. This feeling of Connectedness implies certain responsibilities. If we are all part of a larger picture, then we must not harm others because we will be harming ourselves. We must not exploit because we will be exploiting ourselves. Your awareness of these responsibilities creates your value system. You are considerate, caring, and accepting. Certain of the unity of humankind, you are a bridge builder for people of different cultures. Sensitive to the invisible hand, you can give others comfort that there is a purpose beyond our humdrum lives. The exact articles of your faith will depend on your upbringing and your culture, but your faith is strong. It sustains you and your close friends in the face of life’s mysteries."
end

Factory.define :consistency, :class => StrengthTheme do |st|
  st.theme "Consistency"
  st.brief_description "People who are especially talented in the Consistency theme are keenly aware of the need to treat people the same. They try to treat everyone in the world with consistency by setting up clear rules and adhering to them."
  st.long_description  "Balance is important to you. You are keenly aware of the need to treat people the same, no matter what their station in life, so you do not want to see the scales tipped too far in any one person’s favor. In your view this leads to selfishness and individualism. It leads to a world where some people gain an unfair advantage because of their connections or their background or their greasing of the wheels. This is truly offensive to you. You see yourself as a guardian against it. In direct contrast to this world of special favors, you believe that people function best in a consistent environment where the rules are clear and are applied to everyone equally. This is an environment where people know what is expected. It is predictable and evenhanded. It is fair. Here each person has an even chance to show his or her worth."
end

Factory.define :context, :class => StrengthTheme do |st|
  st.theme "Context"
  st.brief_description "People who are especially talented in the Context theme enjoy thinking about the past. They understand the present by researching its history."
  st.long_description  <<LONG_DESCRIPTION
You look back. You look back because that is where the answers lie. You look back to understand the present.
From your vantage point the present is unstable, a confusing clamor of competing voices. It is only by cast-
ing your mind back to an earlier time, a time when the plans were being drawn up, that the present regains
its stability. The earlier time was a simpler time. It was a time of blueprints. As you look back, you begin to
see these blueprints emerge. You realize what the initial intentions were. These blueprints or intentions have
since become so embellished that they are almost unrecognizable, but now this Context theme reveals them
again. This understanding brings you confidence. No longer disoriented, you make better decisions because
you sense the underlying structure. You become a better partner because you understand how your colleagues
came to be who they are. And counterintuitively you become wiser about the future because you saw its
seeds being sown in the past. Faced with new people and new situations, it will take you a little time to orient
yourself, but you must give yourself this time. You must discipline yourself to ask the questions and allow the
blueprints to emerge because no matter what the situation, if you haven’t seen the blueprints, you will have
less confidence in your decisions.
LONG_DESCRIPTION

end

Factory.define :deliberative, :class => StrengthTheme do |st|
  st.theme "Deliberative"
  st.brief_description "People who are especially talented in the Deliberative theme are best described by the serious care they take in making decisions or choices. They anticipate the obstacles."
  st.long_description  <<LONG_DESCRIPTION
You are careful. You are vigilant. You are a private person. You know that the world is an unpredictable place.
Everything may seem in order, but beneath the surface you sense the many risks. Rather than denying these
risks, you draw each one out into the open. Then each risk can be identified, assessed, and ultimately reduced.
Thus, you are a fairly serious person who approaches life with a certain reserve. For example, you like to plan
ahead so as to anticipate what might go wrong. You select your friends cautiously and keep your own counsel
when the conversation turns to personal matters. You are careful not to give too much praise and recognition,
lest it be misconstrued. If some people don’t like you because you are not as effusive as others, then so be it.
For you, life is not a popularity contest. Life is something of a minefield. Others can run through it recklessly
if they so choose, but you take a different approach. You identify the dangers, weigh their relative impact, and
then place your feet deliberately. You walk with care.
LONG_DESCRIPTION
end

Factory.define :developer, :class => StrengthTheme do |st|
  st.theme "Developer"
  st.brief_description "People who are especially talented in the Developer theme recognize and cultivate the potential in others. They spot the signs of each small improvement and derive satisfaction from these improvements."
  st.long_description  <<LONG_DESCRIPTION
You see the potential in others. Very often, in fact, potential is all you see. In your view no individual is fully
formed. On the contrary, each individual is a work in progress, alive with possibilities. And you are drawn
toward people for this very reason. When you interact with others, your goal is to help them experience success.
You look for ways to challenge them. You devise interesting experiences that can stretch them and help them
grow. And all the while you are on the lookout for the signs of growth — a new behavior learned or modified,
a slight improvement in a skill, a glimpse of excellence or of “flow” where previously there were only halting
steps. For you these small increments — invisible to some — are clear signs of potential being realized. These
signs of growth in others are your fuel. They bring you strength and satisfaction. Over time many will seek you
out for help and encouragement because on some level they know that your helpfulness is both genuine and
fulfilling to you.
LONG_DESCRIPTION
end

Factory.define :discipline, :class => StrengthTheme do |st|
  st.theme "Discipline"
  st.brief_description "People who are especially talented in the Discipline theme enjoy routine and structure. Their world is best described by the order they create."
  st.long_description  <<LONG_DESCRIPTION
Your world needs to be predictable. It needs to be ordered and planned. So you instinctively impose structure
on your world. You set up routines. You focus on timelines and deadlines. You break long-term projects into
a series of specific short-term plans, and you work through each plan diligently. You are not necessarily neat
and clean, but you do need precision. Faced with the inherent messiness of life, you want to feel in control.
The routines, the timelines, the structure, all of these help create this feeling of control. Lacking this theme of
Discipline, others may sometimes resent your need for order, but there need not be conflict. You must
understand that not everyone feels your urge for predictability; they have other ways of getting things done. 
Likewise, you can help them understand and even appreciate your need for structure. Your dislike of surprises,
your impatience with errors, your routines, and your detail orientation don’t need to be misinterpreted as
controlling behaviors that box people in. Rather, these behaviors can be understood as your instinctive method
for maintaining your progress and your productivity in the face of life’s many distractions.  
LONG_DESCRIPTION
end

Factory.define :empathy, :class => StrengthTheme do |st|
  st.theme "Empathy"
  st.brief_description "People who are especially talented in the Empathy theme can sense the feelings of other people by imagining themselves in others’ lives or others’ situations."
  st.long_description  <<LONG_DESCRIPTION
You can sense the emotions of those around you. You can feel what they are feeling as though their feelings
are your own. Intuitively, you are able to see the world through their eyes and share their perspective. You do
not necessarily agree with each person’s perspective. You do not necessarily feel pity for each person’s predicament —
this would be sympathy, not Empathy. You do not necessarily condone the choices each person
makes, but you do understand. This instinctive ability to understand is powerful. You hear the unvoiced questions.
You anticipate the need. Where others grapple for words, you seem to find the right words and the right
tone. You help people find the right phrases to express their feelings — to themselves as well as to others. You
help them give voice to their emotional life. For all these reasons other people are drawn to you.
LONG_DESCRIPTION
end

Factory.define :focus, :class => StrengthTheme do |st|
  st.theme "Focus"
  st.brief_description "People who are especially talented in the Focus theme can take a direction, follow through, and make the corrections necessary to stay on track. They prioritize, then act."
  st.long_description  <<LONG_DESCRIPTION
“Where am I headed?” you ask yourself. You ask this question every day. Guided by this theme of Focus, you
need a clear destination. Lacking one, your life and your work can quickly become frustrating. And so each
year, each month, and even each week you set goals. These goals then serve as your compass, helping you
determine priorities and make the necessary corrections to get back on course. Your Focus is powerful because
it forces you to filter; you instinctively evaluate whether or not a particular action will help you move toward
your goal. Those that don’t are ignored. In the end, then, your Focus forces you to be efficient. Naturally, the
flip side of this is that it causes you to become impatient with delays, obstacles, and even tangents, no
matter how intriguing they appear to be. This makes you an extremely valuable team member. When others start
to wander down other avenues, you bring them back to the main road. Your Focus reminds everyone that if
something is not helping you move toward your destination, then it is not important. And if it is not
important, then it is not worth your time. You keep everyone on point.
LONG_DESCRIPTION
end

Factory.define :futuristic, :class => StrengthTheme do |st|
  st.theme "Futuristic"
  st.brief_description "People who are especially talented in the Futuristic theme are inspired by the future and what could be. They inspire others with their visions of the future."
  st.long_description  <<LONG_DESCRIPTION
“Wouldn’t it be great if . . .” You are the kind of person who loves to peer over the horizon. The future
fascinates you. As if it were projected on the wall, you see in detail what the future might hold, and this detailed
picture keeps pulling you forward, into tomorrow. While the exact content of the picture will depend on your
other strengths and interests — a better product, a better team, a better life, or a better world — it will always
be inspirational to you. You are a dreamer who sees visions of what could be and who cherishes those visions.
When the present proves too frustrating and the people around you too pragmatic, you conjure up your
visions of the future and they energize you. They can energize others, too. In fact, very often people look to you
to describe your visions of the future. They want a picture that can raise their sights and thereby their spirits.
You can paint it for them. Practice. Choose your words carefully. Make the picture as vivid as possible. People
will want to latch on to the hope you bring.
LONG_DESCRIPTION
end

Factory.define :harmony, :class => StrengthTheme do |st|
  st.theme "Harmony"
  st.brief_description "People who are especially talented in the Harmony theme look for consensus. They don’t enjoy conflict; rather, they seek areas of agreement."
  st.long_description  <<LONG_DESCRIPTION
You look for areas of agreement. In your view there is little to be gained from conflict and friction, so you seek
to hold them to a minimum. When you know that the people around you hold differing views, you try to find
the common ground. You try to steer them away from confrontation and toward harmony. In fact, harmony is
one of your guiding values. You can’t quite believe how much time is wasted by people trying to impose their
views on others. Wouldn’t we all be more productive if we kept our opinions in check and instead looked for
consensus and support? You believe we would, and you live by that belief. When others are sounding off about
their goals, their claims, and their fervently held opinions, you hold your peace. When others strike out in a
direction, you will willingly, in the service of harmony, modify your own objectives to merge with theirs (as
long as their basic values do not clash with yours). When others start to argue about their pet theory or
concept, you steer clear of the debate, preferring to talk about practical, down-to-earth matters on which you can
all agree. In your view we are all in the same boat, and we need this boat to get where we are going. It is a good
boat. There is no need to rock it just to show that you can.
LONG_DESCRIPTION
end

Factory.define :ideation, :class => StrengthTheme do |st|
  st.theme "Ideation"
  st.brief_description "People who are especially talented in the Ideation theme are fascinated by ideas. They are able to find connections between seemingly disparate phenomena."
  st.long_description  <<LONG_DESCRIPTION
You are fascinated by ideas. What is an idea? An idea is a concept, the best explanation of the most events.
You are delighted when you discover beneath the complex surface an elegantly simple concept to explain why
things are the way they are. An idea is a connection. Yours is the kind of mind that is always looking for
connections, and so you are intrigued when seemingly disparate phenomena can be linked by an obscure
connection. An idea is a new perspective on familiar challenges. You revel in taking the world we all know and
turning it around so we can view it from a strange but strangely enlightening angle. You love all these ideas
because they are profound, because they are novel, because they are clarifying, because they are contrary,
because they are bizarre. For all these reasons you derive a jolt of energy whenever a new idea occurs to you.
Others may label you creative or original or conceptual or even smart. Perhaps you are all of these. Who can
be sure? What you are sure of is that ideas are thrilling. And on most days this is enough.
LONG_DESCRIPTION
end

Factory.define :includer, :class => StrengthTheme do |st|
  st.theme "Includer"
  st.brief_description "People who are especially talented in the Includer theme are accepting of others. They show awareness of those who feel left out, and make an effort to include them."
  st.long_description  <<LONG_DESCRIPTION
“Stretch the circle wider.” This is the philosophy around which you orient your life. You want to include people
and make them feel part of the group. In direct contrast to those who are drawn only to exclusive groups, you
actively avoid those groups that exclude others. You want to expand the group so that as many people as
possible can benefit from its support. You hate the sight of someone on the outside looking in. You want to draw
them in so that they can feel the warmth of the group. You are an instinctively accepting person. Regardless
of race or sex or nationality or personality or faith, you cast few judgments. Judgments can hurt a person’s
feelings. Why do that if you don’t have to? Your accepting nature does not necessarily rest on a belief that each
of us is different and that one should respect these differences. Rather, it rests on your conviction that
fundamentally we are all the same. We are all equally important. Thus, no one should be ignored. Each of us should
be included. It is the least we all deserve.
LONG_DESCRIPTION
end

Factory.define :individualization, :class => StrengthTheme do |st|
  st.theme "Individualization"
  st.brief_description "People who are especially talented in the Individualization theme are intrigued with the unique qualities of each person. They have a gift for figuring out how people who are different can work together productively."
  st.long_description  <<LONG_DESCRIPTION
Your Individualization theme leads you to be intrigued by the unique qualities of each person. You are
impatient with generalizations or “types” because you don’t want to obscure what is special and distinct about each
person. Instead, you focus on the differences between individuals. You instinctively observe each person’s
style, each person’s motivation, how each thinks, and how each builds relationships. You hear the one-of-a-
kind stories in each person’s life. This theme explains why you pick your friends just the right birthday gift,
why you know that one person prefers praise in public and another detests it, and why you tailor your
teaching style to accommodate one person’s need to be shown and another’s desire to “figure it out as I go.” Because
you are such a keen observer of other people’s strengths, you can draw out the best in each person. This
Individualization theme also helps you build productive teams. While some search around for the perfect team
“structure” or “process,” you know instinctively that the secret to great teams is casting by individual strengths
so that everyone can do a lot of what they do well.  
LONG_DESCRIPTION
end

Factory.define :input, :class => StrengthTheme do |st|
  st.theme "Input"
  st.brief_description "People who are especially talented in the Input theme have a craving to know more. Often they like to collect and archive all kinds of information."
  st.long_description  <<LONG_DESCRIPTION
You are inquisitive. You collect things. You might collect information — words, facts, books, and quotations —
or you might collect tangible objects such as butterflies, baseball cards, porcelain dolls, or sepia photographs.
Whatever you collect, you collect it because it interests you. And yours is the kind of mind that finds so many
things interesting. The world is exciting precisely because of its infinite variety and complexity. If you read a
great deal, it is not necessarily to refine your theories but, rather, to add more information to your archives.
If you like to travel, it is because each new location offers novel artifacts and facts. These can be acquired and
then stored away. Why are they worth storing? At the time of storing it is often hard to say exactly when or
why you might need them, but who knows when they might become useful? With all those possible uses in
mind, you really don’t feel comfortable throwing anything away. So you keep acquiring and compiling and
filing stuff away. It’s interesting. It keeps your mind fresh. And perhaps one day some of it will prove valuable.
LONG_DESCRIPTION
end

Factory.define :intellection, :class => StrengthTheme do |st|
  st.theme "Intellection"
  st.brief_description "People who are especially talented in the Intellection theme are characterized by their intellectual activity. They are introspective and appreciate intellectual discussions."
  st.long_description  <<LONG_DESCRIPTION
You like to think. You like mental activity. You like exercising the “muscles” of your brain, stretching them
in multiple directions. This need for mental activity may be focused; for example, you may be trying to solve
a problem or develop an idea or understand another person’s feelings. The exact focus will depend on your
other strengths. On the other hand, this mental activity may very well lack focus. The theme of Intellection
does not dictate what you are thinking about; it simply describes that you like to think. You are the kind of
person who enjoys your time alone because it is your time for musing and reflection. You are introspective. In
a sense you are your own best companion, as you pose yourself questions and try out answers on yourself to
see how they sound. This introspection may lead you to a slight sense of discontent as you compare what you
are actually doing with all the thoughts and ideas that your mind conceives. Or this introspection may tend
toward more pragmatic matters such as the events of the day or a conversation that you plan to have later.
Wherever it leads you, this mental hum is one of the constants of your life.   
LONG_DESCRIPTION
end

Factory.define :learner, :class => StrengthTheme do |st|
  st.theme "Learner"
  st.brief_description "People who are especially talented in the Learner theme have a great desire to learn and want to continuously improve. In particular, the process of learning, rather than the outcome, excites them."
  st.long_description  <<LONG_DESCRIPTION
You love to learn. The subject matter that interests you most will be determined by your other themes and
experiences, but whatever the subject, you will always be drawn to the process of learning. The process, more
than the content or the result, is especially exciting for you. You are energized by the steady and deliberate
journey from ignorance to competence. The thrill of the first few facts, the early efforts to recite or practice
what you have learned, the growing confidence of a skill mastered — this is the process that entices you. Your
excitement leads you to engage in adult learning experiences — yoga or piano lessons or graduate classes. It
enables you to thrive in dynamic work environments where you are asked to take on short project assignments
and are expected to learn a lot about the new subject matter in a short period of time and then move on to the
next one. This Learner theme does not necessarily mean that you seek to become the subject matter expert, or
that you are striving for the respect that accompanies a professional or academic credential. The outcome of
the learning is less significant than the “getting there.”   
LONG_DESCRIPTION
end

Factory.define :maximizer, :class => StrengthTheme do |st|
  st.theme "Maximizer"
  st.brief_description "People who are especially talented in the Maximizer theme focus on strengths as a way to stimulate personal and group excellence. They seek to transform something strong into something superb."
  st.long_description  <<LONG_DESCRIPTION
Excellence, not average, is your measure. Taking something from below average to slightly above average
takes a great deal of effort and in your opinion is not very rewarding. Transforming something strong into
something superb takes just as much effort but is much more thrilling. Strengths, whether yours or someone
else’s, fascinate you. Like a diver after pearls, you search them out, watching for the telltale signs of a strength.
A glimpse of untutored excellence, rapid learning, a skill mastered without recourse to steps — all these are
clues that a strength may be in play. And having found a strength, you feel compelled to nurture it, refine it,
and stretch it toward excellence. You polish the pearl until it shines. This natural sorting of strengths means
that others see you as discriminating. You choose to spend time with people who appreciate your particular
strengths. Likewise, you are attracted to others who seem to have found and cultivated their own strengths.
You tend to avoid those who want to fix you and make you well rounded. You don’t want to spend your life
bemoaning what you lack. Rather, you want to capitalize on the gifts with which you are blessed. It’s more fun.
It’s more productive. And, counterintuitively, it is more demanding.  
LONG_DESCRIPTION
end

Factory.define :positivity, :class => StrengthTheme do |st|
  st.theme "Positivity"
  st.brief_description "People who are especially talented in the Positivity theme have an enthusiasm that is contagious. They are upbeat and can get others excited about what they are going to do."
  st.long_description  <<LONG_DESCRIPTION
You are generous with praise, quick to smile, and always on the lookout for the positive in the situation. Some
call you lighthearted. Others just wish that their glass were as full as yours seems to be. But either way, people
want to be around you. Their world looks better around you because your enthusiasm is contagious. Lacking
your energy and optimism, some find their world drab with repetition or, worse, heavy with pressure. You
seem to find a way to lighten their spirit. You inject drama into every project. You celebrate every
achievement. You find ways to make everything more exciting and more vital. Some cynics may reject your energy,
but you are rarely dragged down. Your Positivity won’t allow it. Somehow you can’t quite escape your
conviction that it is good to be alive, that work can be fun, and that no matter what the setbacks, one must never lose
one’s sense of humor.   
LONG_DESCRIPTION
end

Factory.define :relator, :class => StrengthTheme do |st|
  st.theme "Relator"
  st.brief_description "People who are especially talented in the Relator theme enjoy close relationships with others. They find deep satisfaction in working hard with friends to achieve a goal."
  st.long_description  <<LONG_DESCRIPTION
Relator describes your attitude toward your relationships. In simple terms, the Relator theme pulls you
toward people you already know. You do not necessarily shy away from meeting new people — in fact, you may
have other themes that cause you to enjoy the thrill of turning strangers into friends — but you do derive a
great deal of pleasure and strength from being around your close friends. You are comfortable with intimacy.
Once the initial connection has been made, you deliberately encourage a deepening of the relationship. You
want to understand their feelings, their goals, their fears, and their dreams; and you want them to understand
yours. You know that this kind of closeness implies a certain amount of risk — you might be taken advantage
of — but you are willing to accept that risk. For you a relationship has value only if it is genuine. And the only
way to know that is to entrust yourself to the other person. The more you share with each other, the more you
risk together. The more you risk together, the more each of you proves your caring is genuine. These are your
steps toward real friendship, and you take them willingly.
LONG_DESCRIPTION
end

Factory.define :responsibility, :class => StrengthTheme do |st|
  st.theme "Responsibility"
  st.brief_description "People who are especially talented in the Responsibility theme take psychological ownership of what they say they will do. They are committed to stable values such as honesty and loyalty."
  st.long_description  <<LONG_DESCRIPTION
Your Responsibility theme forces you to take psychological ownership for anything you commit to, and
whether large or small, you feel emotionally bound to follow it through to completion. Your good name depends on
it. If for some reason you cannot deliver, you automatically start to look for ways to make it up to the other
person. Apologies are not enough. Excuses and rationalizations are totally unacceptable. You will not quite
be able to live with yourself until you have made restitution. This conscientiousness, this near obsession for
doing things right, and your impeccable ethics, combine to create your reputation: utterly dependable. When
assigning new responsibilities, people will look to you first because they know it will get done. When people
come to you for help — and they soon will — you must be selective. Your willingness to volunteer may
sometimes lead you to take on more than you should.
LONG_DESCRIPTION
end

Factory.define :restorative, :class => StrengthTheme do |st|
  st.theme "Restorative"
  st.brief_description "People who are especially talented in the Restorative theme are adept at dealing with problems. They are good at
figuring out what is wrong and resolving it."
  st.long_description  <<LONG_DESCRIPTION
You love to solve problems. Whereas some are dismayed when they encounter yet another breakdown, you
can be energized by it. You enjoy the challenge of analyzing the symptoms, identifying what is wrong, and
finding the solution. You may prefer practical problems or conceptual ones or personal ones. You may seek
out specific kinds of problems that you have met many times before and that you are confident you can fix. Or
you may feel the greatest push when faced with complex and unfamiliar problems. Your exact preferences are
determined by your other themes and experiences. But what is certain is that you enjoy bringing things back
to life. It is a wonderful feeling to identify the undermining factor(s), eradicate them, and restore something to
its true glory. Intuitively, you know that without your intervention, this thing — this machine, this technique,
this person, this company — might have ceased to function. You fixed it, resuscitated it, rekindled its vitality.
Phrasing it the way you might, you saved it.  
LONG_DESCRIPTION
end

Factory.define :self_assurance, :class => StrengthTheme do |st|
  st.theme "Self-Assurance"
  st.brief_description "People who are especially talented in the Self-Assurance theme feel confident in their ability to manage their own lives. They possess an inner compass that gives them confidence that their decisions are right."
  st.long_description  <<LONG_DESCRIPTION
Self-Assurance is similar to self-confidence. In the deepest part of you, you have faith in your strengths. You
know that you are able — able to take risks, able to meet new challenges, able to stake claims, and, most
important, able to deliver. But Self-Assurance is more than just self-confidence. Blessed with the theme of Self-
Assurance, you have confidence not only in your abilities but in your judgment. When you look at the world,
you know that your perspective is unique and distinct. And because no one sees exactly what you see, you
know that no one can make your decisions for you. No one can tell you what to think. They can guide. They
can suggest. But you alone have the authority to form conclusions, make decisions, and act. This authority,
this final accountability for the living of your life, does not intimidate you. On the contrary, it feels natural to
you. No matter what the situation, you seem to know what the right decision is. This theme lends you an aura
of certainty. Unlike many, you are not easily swayed by someone else’s arguments, no matter how persuasive
they may be. This Self-Assurance may be quiet or loud, depending on your other themes, but it is solid. It is
strong. Like the keel of a ship, it withstands many different pressures and keeps you on your course.
LONG_DESCRIPTION
end

Factory.define :significance, :class => StrengthTheme do |st|
  st.theme "Significance"
  st.brief_description "People who are especially talented in the Significance theme want to be very important in the eyes of others. They are independent and want to be recognized."
  st.long_description  <<LONG_DESCRIPTION
You want to be very significant in the eyes of other people. In the truest sense of the word you want to be
recognized. You want to be heard. You want to stand out. You want to be known. In particular, you want to be
known and appreciated for the unique strengths you bring. You feel a need to be admired as credible,
professional, and successful. Likewise, you want to associate with others who are credible, professional, and
successful. And if they aren’t, you will push them to achieve until they are. Or you will move on. An independent
spirit, you want your work to be a way of life rather than a job, and in that work you want to be given free rein,
the leeway to do things your way. Your yearnings feel intense to you, and you honor those yearnings. And so
your life is filled with goals, achievements, or qualifications that you crave. Whatever your focus — and each
person is distinct — your Significance theme will keep pulling you upward, away from the mediocre toward
the exceptional. It is the theme that keeps you reaching.
LONG_DESCRIPTION
end

Factory.define :strategic, :class => StrengthTheme do |st|
  st.theme "Strategic"
  st.brief_description "People who are especially talented in the Strategic theme create alternative ways to proceed. Faced with any given scenario, they can quickly spot the relevant patterns and issues."
  st.long_description  <<LONG_DESCRIPTION
The Strategic theme enables you to sort through the clutter and find the best route. It is not a skill that can be
taught. It is a distinct way of thinking, a special perspective on the world at large. This perspective allows you
to see patterns where others simply see complexity. Mindful of these patterns, you play out alternative
scenarios, always asking, “What if this happened? Okay, well what if this happened?” This recurring question helps
you see around the next corner. There you can evaluate accurately the potential obstacles. Guided by where
you see each path leading, you start to make selections. You discard the paths that lead nowhere. You discard
the paths that lead straight into resistance. You discard the paths that lead into a fog of confusion. You cull
and make selections until you arrive at the chosen path — your strategy. Armed with your strategy, you strike
forward. This is your Strategic theme at work: “What if?” Select. Strike.
LONG_DESCRIPTION
end

Factory.define :woo, :class => StrengthTheme do |st|
  st.theme "Woo"
  st.brief_description "People who are especially talented in the Woo theme love the challenge of meeting new people and winning them over. They derive satisfaction from breaking the ice and making a connection with another person."
  st.long_description  <<LONG_DESCRIPTION
Woo stands for winning others over. You enjoy the challenge of meeting new people and getting them to like
you. Strangers are rarely intimidating to you. On the contrary, strangers can be energizing. You are drawn to
them. You want to learn their names, ask them questions, and find some area of common interest so that you
can strike up a conversation and build rapport. Some people shy away from starting up conversations because
they worry about running out of things to say. You don’t. Not only are you rarely at a loss for words; you
actually enjoy initiating with strangers because you derive satisfaction from breaking the ice and making a
connection. Once that connection is made, you are quite happy to wrap it up and move on. There are new people
to meet, new rooms to work, new crowds to mingle in. In your world there are no strangers, only friends you
haven’t met yet — lots of them.
LONG_DESCRIPTION
end