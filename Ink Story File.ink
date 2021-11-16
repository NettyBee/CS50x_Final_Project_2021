// This is the Ink file for the story itself.
// Ink is a scripting language based a bit off of C#, so some features of C# are here (e.g conditional blocks).

// Some key features of the Ink language:
// VAR = variables. Work much the same as variables in other languages.
// ~VAR_NAME = Call or change a variable in the story script.
// ===Knot=== = Knot. This is essentially like a chapter.
// =Stitch = Stitch. These are essentially like sub-chapters within Knots. 
// -> = Divert. This is used to divert the story to a set knot or stitch.
// * = A choice. This type of choice can only be chosen ONCE. 
// + = A choice. This type of choice can be chosen repeatedly.
// - = Gather. This is used to gather outcomes of multiple choices to the same point.
// ** / ++ / -- = NESTED choices & gathers.
// * Before [Choice1] After = Shows "Before Choice1" before the option has been clicked, and "After" after the option has been clicked.
// <> = Glue. Glues two sentences together.
// #tag = Tags. These essentially act as meta-data for the story and can be accessed by other programming languages. They are stored and fed to other programming languages as lists. Tag lists are only broken by non-meta data e.g. printed sentences, game conditional statements, updated variables etc. New paragraphs DO NOT break Ink tag lists. That's why I've used "<nobr>" in some instances (more detail in the first instance of <nobr>).
// {VAR_name} = This will print the value of the variable (VAR_name) to the story.
// {Logic: printed if true | printed if false } = Inline conditional logic. Allows different sentences to be printed based off the conditional. 
// {Sentence one|Sentence two|Sentence three} = When this sentence is revisited, the next sentence in the series is printed.
// {& Sentence one|Sentence two|Sentence three} = As above but "&" loops through the choices.
// {~ Sentence one|Sentence two|Sentence three} = Here "~" prints the sentence at random.
// There are also conditional blocks (in curly braces), as well. 

// There are also lists and more advanced features such as Tunnels and Flow, but I just wanted to keep this simple! 


                            //------VARIABLES------\\
// Location variables (user and game input)
VAR in_study = false
VAR in_hallway = false
VAR in_kitchen = false
VAR in_bedroom = false
VAR in_bathroom = false

// Outcome-deciding variables (user determined).
// In order of approximate appearance in the story.
VAR decision_one = ""
VAR food = ""
VAR food_left = 0
VAR sleep = false
VAR snooze = 0
VAR CURSE = false
VAR PROJECT = false
VAR CLEAN = false

// Loop variables (see ==eat_food, ===brush_teeth===, and ==flicker_start).
// In order of appearance in the story.
VAR food_counter = 0
VAR brush_count=0
VAR brush_motion_count = 0
VAR flickering_lights_count = 0

// Miscellaneous variables.
// Don't really affect the outcome of the story.
VAR time = "10:45pm"
VAR tunes = false
VAR blackpool_illuminations=false

                            //------STORY START------\\
// Divert to disclaimer knot & start the story.
->DISCLAIMER

===DISCLAIMER===

WARNING:
Sections of this story could trigger seizures for people with photosensitive epilepsy. Player discretion is advised. Proceed with caution. #in_study
 
    *[Continue?]
        ~in_study=true
        ->Intro
        // Above turns "study light" on, and diverts to Intro.

===  Intro  ===
    
    {time}.
    You've confined yourself to your study all day, working long hours on a project that could have been completed a day or two ago.
    It's late.
    You're tired.

    A stale coffee cup metropolis grew around you as you worked, built upon a foundation of papers. As night fell, your desk lamp acted as street lights for the metropolis. 

    Thankfully your project is so close to finished. Maybe an hour or 45minutes of work left should do the trick. 

    But the 12am deadline still looms. #in_study
    //First outcome-deciding decision. Updates decision_one variable to reflect this choice. 
        * Coffee time[?]!
            ~ decision_one = "Coffee"
        * Pizza time[?]!
            ~ decision_one = "Pizza"
        * Nap time[?]!
            ~ decision_one = "Sleep"
            
    - ->first_lightswitch // Gather point diverts all choices to the next "stitch".
    
    = first_lightswitch    
        You get up from your desk chair and move towards the hallway of your flat. You hadn't realised just how dark the flat had become though. 
        There's a lightswitch around here somewhere... 
        // User can progress the story either by choosing the sole choice OR by turning the "lights" on.
        #in_hallway #lights_ON_please
        * [I can get around fine]
        
        //Prints if user turns on hall light.
        {in_hallway==true: That's better!}
        
        //Next diverts based off of the first decision. 
        { 
            - decision_one == "Coffee":
                ->coffee_transition
            - decision_one == "Pizza":
                ->Pizza
            - decision_one == "Sleep":
                -> sleep_transition
        }
    
    = turn_off_hall_light
        // Glue used with conditionals change the sentence that is printed based off of variables.
        You walk back through the hallway towards your study
        {food: {Intro.Coffee: <>{food=="Coffee and biscuits": coffee and biscuits}<>{food=="Coffee": coffee}} {Intro.Pizza: <> {food} pizza} <> in hand and ready to work!}
        
        {Intro.Sleep: <>{snooze<1: refreshed from your nap and ready to work!| panicked! Why did you snooze so much?!}}
        
        // Story can be progressed either by turning hall light OFF or ON (based on the hall light's current state), OR by choosing the sole choice (i.e leaving the light as it is).
        {
            -in_hallway==true: 
                #in_hallway # lights_OFF_please
            -else:
                 #in_hallway # lights_ON_please
        }
        * [Leave hall light{in_hallway==true: on| off}?]
            {in_hallway==true:It's nice to see where you're going!|Gotta save that energy!}
            #in_hallway //Indicates current location.
        
            **[Back to study] 
                 #in_hallway #next_room //Indicates movement between rooms.
                 
                -> get_back_to_work
    
    = coffee_transition
    //Mainly broke up this section into multiple stitches to make the transitions between hallway and kitchen easier. 
    #in_hallway
        //Printed if hall light is not "on".
        {
            - in_hallway == false:
                
                You walk the few steps to the kitchen 
                OW!
                You've stubbed your toe - that hurt!
                You feel around for the kitchen doorway #in_hallway
        }
        *[To the kitchen!]#in_hallway
        ->Coffee
    
    =Coffee
        It's pitch black. 
        //Bit of a non-choice. User can flick the lightswitch to progress the story, but if they don't then the light is turned on automatically.
        #in_kitchen #lights_ON_please
       
            * [Leave kitchen light off]
        - 
        // The below conditional turns the kitchen light on automatically. 
        {
            - in_kitchen == false:
                Well, while making coffee in the middle of the night without any lights on would be a skill to master, tonight is not the night to begin learning that! 
                ~ in_kitchen = true
        }
        That's better. Now you can see what you're doing!
        You fill the kettle with water and set it boiling. You open the cupboard and reach in for the ground coffee. You find the cafetiere and plunger on the drying rack next to the sink.
        One.
        Two.
        Three scoopfuls of coffee grounds into the cafetiere.

        The kettle wobbles from the boiling water within, and after a few moments of wobbling the switch clicks off. You pour the water over the coffee grounds in the cafetiere, find a teaspoon next to the sink, and give the coffee a quick stir.
        
        Now, for one of the most important questions you could ever be confronted with...
        Do you want a biscuit? #in_kitchen
        //Next choice changes the food and food_left variables.
            * [Yes.] Of course!
                ~ food = "Coffee and biscuits"
                Most excellent! You open the crockery cupboard, grab a teaplate and make your way to the biscuit barrel. You lift the lid off the biscuit barrel and inside is a beautiful sight!
                Inside the barrel is an assortment of biscuits; chocolate digestives; custard creams; and chocolate bourbons! - Oh my!
                You pick one of each and put it on the teaplate.
                You have 4 biscuits.

            * [No.] No food. No time. Only coffee. Need to power through.
                ~ food = "Coffee"
                And besides, why risk diluting the effects of caffeine with biscuits? There probably aren't any in the biscuit barrel anyway!
                
        - ~food_left = 3 
        {food} in hand, you shuffle back to your study, careful not to spill any.
        
        The kitchen light is still on though...
        // Story can progress if lights turned off.
            #in_kitchen #lights_OFF_please
            * [Leave kitchen light on?]
                        
        - // Conditional responses based off kitchen light & food variables. And Time is updated.
        {in_kitchen==false: Off!}
        {in_kitchen==true && food=="Coffee": Well, at least that's on. You never know, maybe there are biscuits in the barrel!}
        {in_kitchen==true && food=="Coffee and biscuits": Well, at least that's on - there are always more biscuits to go back for!}
        ~time="11:00pm" 
        
        
        #in_kitchen // Indicates current location. 
        //Single choice progresses the story with the divert.
        *[To the hallway] 
            #in_kitchen #next_room //Indicates movement between locations.
            ->turn_off_hall_light 

    = Pizza
        
        Alrighty then! You think that you left the menu somewhere here in the hall.
        //Automatically turns on the hall light if user left it off. 
        {
            - in_hallway==false: 
                But you can't even see an inch in front of your face it's so dark!
                You turn the hall light on.
                ~ in_hallway = true
                That's better! You can see now.
        }
        There's the menu next to the landline telephone!
        //Next choice updates "food" & "food_left" variables.
        You pick up the menu, and your eyes go straight to your usual go-to's:#in_hallway
            * Margarita[]!
                ~food="Margarita"
                Simple, delicious, cheap - what more can you ask for?
            * Pepperoni[]!
                ~food="Pepperoni"
                Salty, greasy, naughty - just what you need to power through and celebrate finishing the project!
            * Veggie Supreme[]!
                ~food="Veggie"
                Red onions, green peppers, mushrooms, black olives - oh my! Being vegetarian has never been so good!
            - ~food_left=3
            
        You decide to go with a large 'za - it's been a trying time! You dial the number and only need to wait a couple of minu-
        "Hello there! You've reached Pizza Palace, the home of pizza royalty, can I take your order?" 
        "Oh hi, yes, I'd like to order the {food} pizza please?" 
        "Of course! The {food} pizza is quite popular at the moment! What size would you like?" 
        "A large one please!"
        "No problem. And what's your address?"
        "Ah good thank you. My address is Flat 6, 66 Spooky Drive, Spookania, Spooktown." 
        "Excellent, your pizza should be there with you in fifteen minutes! Would you like to pay over the phone or in person" 
        "Fifteen minutes is perfect please! Please could I pay over the phone?"
        You sort out payment over the phone, say goodbye to the Pizza Palace, feeling like the perfect Pizza Palace patron! You place the menu back to where it was next to the landline, begin to walk over to the study again to work while you wait for piz-
        
        DING-DONG 
        That's the doorbell!
        ~time="11:00pm" //Time variable updated. 
        Is it the pizza? That seemed too quick!
        You look at the time: {time}
        There's a knock at the front door. 
        Oh! Well! You walk over to the front door, and open it. It's your piping hot {food} pizza (and the pizza delivery guy)! You thank the delivery driver and bring the pizza in. 
        The smell wafts through your flat and makes itself at home. 
        Your stomach rumbles.
        
        ->turn_off_hall_light



    =sleep_transition
        You decide to catch some z's. It may allow you to wake up more refreshed ready to tackle the rest of the project!
        //Changes paragraphs based off hall light state. 
        {
            - in_hallway == false:
                You walk the few steps to your bedr- 
                OW!
                You've stubbed your toe - that hurt!
            - in_hallway == true:
                You walk towards your bedroom, you can't see a thing but you already feel cosiness from the bedroom.
        }#in_hallway
        // Sole choice progresses story.
        *[To the bedroom] 
        ->Sleep
            
    = Sleep        
        In the bedroom it is silent and pitch black.
        // Story can progress either through sole choice or by switching ON the lights.
            #in_bedroom #lights_ON_please

            * [Leave bedroom light off?]
                {
                    - in_bedroom==true:
                        That's better. Now you can see where you're going. And there won't be too much of a risk of oversleeping.
                    - in_bedroom==false && in_hallway == false:
                        You fumble around, arms outstretched, feeling for the bed. 
                        Your hands feel something soft, sheetlike, aaah that's your bed!
                    - in_bedroom==false && in_hallway == true:
                        You can just about see the outline of your bed from the hall light.
                }
                
        - You lift up the covers and climb into bed. Nestled in - you're all cosy. You set an alarm for 30minutes. That'll take you to 11:15pm - that should be fine.
        // Updates time variable.
        ~time="11:15pm"
        
        // Updates "time" and "snooze" variables based off how many "naps" the user chooses to have.
        The alarm wakes you up. It's {time}, just as you planned. #in_bedroom
            * Another 30min snooze won't hurt...
                ~ snooze = 1
                ~ time = "11:45pm"
                The alarm wakes you up again. It's {time}.#in_bedroom
                    ** Hmmm... another snooze... 
                        ~ snooze = 2
                        ~ time = "00:15am"
                        ->Endings // Diverts to unofficial ending one. 
                    ** Hmm... There was something you needed to get up for... [] Oh holy mackerel! You remembered that the deadline is in 15minutes! You really need to get up.
                        ->turn_off_bedroom_light // Diverts to rest of story

            * [Well, that was nice but you need to get up now!]
                ->turn_off_bedroom_light  
                // Diverts to rest of story
    
    =turn_off_bedroom_light
        // Story progresses by user turning lights ON or OFF (depending upon current state of lights), OR by the single choice (i.e leaving lights as is). 
        {
            -in_bedroom==true: 
                #in_bedroom # lights_OFF_please
            -else:
                 #in_bedroom # lights_ON_please
        }
        * [Leave bedroom light{in_bedroom==true: on| off}?]
            #in_bedroom
            **[Go to hallway] 
                #in_bedroom #next_room //Indicates movement between locations. 
                ->turn_off_hall_light
        

=== get_back_to_work ===
    You step back into your study. You readjust the cushions and hoodie that were left on your office chair, shuffle a few papers and move a few mugs around on the desk to make a space just for you.
    //Conditional block that changes the paragraphs based on if the user picked food (and the type of food) or not. All choices divert to the next stitch (tunage_query).
    { 
        -food:
            You wonder where to put your<>{food=="Coffee and biscuits": coffee and biscuits}<>{food=="Coffee": coffee}<>{Intro.Pizza: {food} pizza}.#in_study
                * Desk
                    You've make an extra space for the goods! You pray you don't accidentally knock any<>{Intro.Coffee: coffee}<>{Intro.Pizza: grease} on to the keyboard!
                        ->tunage_query    
                * Windowsill
                    You place the goods on the windowsill. You catch a glimpse of the outdoors. 
                    Streetlamps turn everything orange and make strange shapes of ordinary things. 
                    It is very quiet. 
                    You look away quickly in an attempt not to get too creeped out by just how quiet it is outside...
                        ->tunage_query
        -else:
            ->tunage_query
    }
    

    
    == tunage_query
    
    You sit back down in your office, ready and raring to go!
    {Intro.Coffee: Now, it is time for yet another one of the most important decisions of your life...}
    {Intro.Pizza or Intro.Sleep: Now it is time for quite possibly one of the most important decisions of your life...}
    
    // Inconsequential decision. Both choices lead to either eat_food or friend_email stitches depending on the first decision.
    Tunes?#in_study
        
        { Intro.Coffee or Intro.Pizza or snooze<1:
            * [Yes]Absolutely 100%
            #tunes
                ~ tunes = true
                
                Smashing! What's a project deadline without a soundtrack that makes you feel like the main character?
            {  
                -food:
                    ->eat_food
            }
            
            ->friend_email
        }

        * [{snooze==1:No. No time!|No}]
            Okay, time for focus!
        {  
            -food:
                ->eat_food
         }        
        
    ->friend_email


    == eat_food
        //This ENTIRE stitch is a loop for "eating" the food that the user picked.
        // With each loop, the "food_counter", "food_left" and "time" variables are updated.
        // Different sentences are also printed with each iteration of the loop. 
        {You work away for a couple of minutes.| You continue to work on your project. It appears to be going well!| Time ticks on some more. It is now a race between you and the clock.}
        {&<> Your stomach rumbles.|<> It's going well - so well that you almost forgot about your food!}
        
        {
            - food_counter< 3:
                
                {
                    -food_counter==0:
                        ~time="11:15pm"
                    -food_counter==1:
                        ~time="11:30pm"
                    -food_counter==2:
                        ~time="11:45pm"
                }

                {time}. {<>Is it food time?|<>Another snack? |<>One last snack to take you up to the finish-line?}#in_study
                    + Yes 
                        ~food_left = food_left-1
                        {{Intro.Coffee:That was, excuse me, a DAMN fine cup of coffee!| Aaah! That hit the spot!} | Just as good as before! |  Delicious! And the finish line is in sight!}
                        ~ food_counter = food_counter + 1
                         //Loops back to the start of the stitch
                        ->eat_food
    
                    + No
                        ~ food_counter = food_counter + 1
                        //Loops back to the start of the stitch
                        ->eat_food
        }
        
        // Breaks out of the loop and to the next stitch ("friend_email"). Paragraphs also change dependent upon value of "food_left". 
        {
            - food_counter==3:
                    { 
                        - food_left>0:
                            {Intro.Pizza:The pizza is cold. {food_left==3:All 9}{food_left==2:Some 6}{food_left==1:Only 3} slices remain. The cheese is no longer gooey and melty and delicious. All this is good for now is breakfast pizza.}
                            
                            {Intro.Coffee: {food == "Coffee and biscuits": {food_left>1: {food_left==3:All 4 biscuits}{food_left==2: Three biscuits} remain on the teaplate.}{food_left==1: A single biscuit remains.}}}
                                
                            {Intro.Coffee: {food=="Coffee" or food=="Coffee and biscuits": {food_left == 3: <>The coffee pot is now full of tepid coffee.}{food_left==2: <>The coffee pot is missing one mug of coffee.} {food_left==1: <>One mug full of coffee remains in the pot. You really hope that you can get to sleep!}}}
                        
                            {
                                - food_left==3:
                                    You mustn't have been hungry!
                                - food_left==2:
                                    You must have really gotten in to the project!
                                - food_left==1:    
                                    Your stomach is satisfied.
                            }
                            ->friend_email
                            
                                
                        - else:
                            {Intro.Pizza: Damn that was good 'za! Your stomach is satisfied, if a little on the full side!}
                            
                            {Intro.Coffee: Holy mackerel! That was a lot of caffeine! You have the jitters and you think that you can even smell sounds.{food == "Coffee and biscuits": No biscuits remain.}}
                            ->friend_email
                    }

        }


=== friend_email ===
    ~time="11:50pm"
    {time} you've been in the zone. The finish line is in so close you can smell it! {tunes==true: Your tunes made you feel like a superhero working up to the eleventh hour!}

    A ping startles you from out of nowhere.
    An email.
    You look at the subject header and sender. It's from your friend, they're working on the same thing - they've probably left it a bit too late too! 
    You quickly glance over it - they're telling you to hang on in there! They've sent you a picture of their cat Mr.Fuzzykins fast asleep, curled in a ball next to their radiator.

    You wish you had a pet - the only thing close is a folder full of meme cat pictures.
    
    //Another inconsequential decision. Each choice ultimately goes to the next Knot ("chain_mail").    
    Send one back? #in_study
        {
            -snooze>0: 

                * [Absolutely not! No time!]
                    ->chain_mail
            - else:
                * Absolutely!
                    Which one? #in_study
                        ** Grumpycat[?]!
                            # Images/grumpy_cat.jpg
                            Lovely! Perfectly sums up how tired you are!
                            Right! That's sent off now.
                            <br>
                            Now time to send this project off!
                            ->chain_mail   
                        ** Princess Monstertruck[?]!
                            # Images/princess_monster_truck.jpg
                            Aww! What a snaggletoothed cutie!
                            Right! That's sent off now.
                            <br>
                            Now time to send this project off!
                            ->chain_mail
                        ** Catbug[?]!
                            # Images/catbug.png
                            This may be pushing the boundaries for cat picture, but...
                            ...just look at that face! 
                            You'll allow it.
                            Right! That's sent off now.
                            <br>
                            Now time to send this project off!
                            ->chain_mail   

                * No! No time!
                    Only ten minutes left! No time! Maybe in the morning!
                    Now time to send this project off! ->chain_mail
        }

=== chain_mail ===
    //This Knot contains ONE of the BIG STORY DEFINING DECISIONS.
    ~time="11:55pm"
    Ping!
    What's this? Another email? 
    {time}. 
    Your friend can't have responded that quickly!
    You glance over at the subject and sender.
    ~tunes=false 
    Both fields are empty. #in_study
        * [Read email.]*Click* Read 
            There'll be time enough to read this, send the project off and then respond.#tunes
            
            //Diverts to outcome if reading the chain mail first
            ->read_email_first
        * [Send project.]
            Too right. I would be better to see the back of this before responding to any other emails thankyouverymuch!
        
            //Diverts to outcome if the project gets sent off first.
            ->send_project_first

=== read_email_first ===
    // Variables "time" and "CURSE" are updated.
    ~time="11:58pm"
    ~CURSE = true
    
    The email reads.
    "THIS EMAIL HAS BEEN CURSED ONCE OPENED YOU MUST SEND IT."
    Oh good grief! 
    "...You are now cursed. You must send this on or you will be killed. Tonight at 2am by Bloody Mary."
    
    It's one of those chain emails from the 90's/00's{Intro.Pizza: (conveniently forgetting the fact that you have a landline telephone in the hall)}!
    
    "...This is no joke. So don’t think you can quickly get out of it and delete it now because Bloody Mary will come to you if you do not send this on."

    You haven't seen one of these in a good long while! Complete with spelling mistakes!
    
    "...It won’t be funny then, will it? Don’t think this is a fake and it’s all put on to scare you because your wrong, so very wrong."
    Who the hell is still sending these?! 
    
    "...We strongly advise you to send this email on. It is seriously NO JOKE."
    Who the heck is "WE"?
    
    "...15-25 OR MORE PEOPLE – You are safe from Bloody Mary"
    Your friends would get a good kick out of this!#in_study
    // These choices make up ANOTHER BIG STORY DEFINING DECISION.
    * Follow email instructions
        This'll be a laugh!
        ->follow_instructions
    * Ignore and send off project
        You have other priorities right now thankyouverymuch!
        ->ignore_and_send_project
    
    
    = follow_instructions
        // "time" and "CURSE" variables are updated. 
        ~time="12:00am"
        ~CURSE = false
        It's been a while since you've sent one of these. You take a strange sort of glee in selecting 15 people to forward the "curse" on to! But who would be okay with being sent this? Who would get irrationally angry? Maybe you could send the email on to those people anyway! 
        This feels even better than a RickRoll! 
        {time}. Oh no! The time has gotten away from you! This is the project deadline!
            ~time="12:01am"
            #in_study
            //This choice DOES NOT change the outcome massively. This only gives the illusion of choice! Both choices divert to the next knot ("clean_up_query")
            * Send the project anyway - you never know!
                {time}. Huh. Well, you'll just have to hope.                    
            * Give up.
                {time} Eh, nevermind. You're sure that there's bound to be some leeway! You'd much rather go to bed by now.
         - ->clean_up_query


    = ignore_and_send_project
        // "time" and "PROJECT" variables are updated. "CURSE" remains the same.
        ~time="12:00am"
        ~CURSE = true
        ~PROJECT = true
        {time} Phew! You're glad to see the back of that project!
        ~time="12:01am"
        Stupid email nearly derailed you! Although...
        #in_study
        //Again, this choice DOES NOT change the outcome massively. This only gives the illusion of choice! Both choices divert to the next knot ("clean_up_query")
            * Attempt to follow instructions
                It might be funny to see your friends reactions to this ancient chain email! And even though you don't like to admit it, you can be persuaded to be superstitious...
                15 people selected. Chain email forwarded. And the time is...
                {time}
                Huh. Well. All you can do now is hope that superstition isn't true.
            * Ignore the email.
                It's {time}. It's bedtime for pity's sake! You hope you don't get any nightmares tonight though.
        - ->clean_up_query


=== send_project_first ===
    // "time" and ""PROJECT" variables are updated. 
    ~time="11:58pm"
    ~PROJECT=true
    You send your project off and breathe a sigh of relief - thank goodness that's done! 
    Stupid email coming at the wrong time! Even if it is your friend it was still an inopportune moment - and they should know that! 
    You're tired and want nothing more than to go to bed satisfied... Although the empty subject header and sender fields are intriguing...#in_study
        // These choices make up ANOTHER BIG STORY DEFINING DECISION.
        * Investigate. []You're surprised that your curiosity has gotten the better of you!
            ->investigate_chain_email
        * Hit the hay. []You decide to leave it until the morning. 
            ->hit_the_hay
            
    = investigate_chain_email
        //"time" and "CURSE" variables are updated. "PROJECT" remains the same. 
        ~time = "12:00am"
        ~CURSE = true
        ~PROJECT = true
        You click open the email in question. You are met with a massive wall of text: #tunes

        "THIS EMAIL HAS BEEN CURSED ONCE OPENED YOU MUST SEND IT. 
            You are now cursed. You must send this on or you will be killed. Tonight at 2am by Bloody Mary....This is no joke. So don’t think you can quickly get out of it and delete it now because Bloody Mary will come to you if you do not send this on. ...It won’t be funny then, will it? Don’t think this is a fake and it’s all put on to scare you because your wrong, so very wrong. ...We strongly advise you to send this email on. It is seriously NO JOKE. ...15-25 OR MORE PEOPLE – You are safe from Bloody Mary"

        ~time="12:01am"
        Man alive what a waste of an email! 
        Who the heck is still sending these?! 
        Although...#in_study
        //Again, this choice DOES NOT change the outcome massively. This only gives the illusion of choice! Both choices divert to the next knot ("clean_up_query")
            * Follow instructions
                Screw it! Full of relief from having sent off your project, you decide to share this with your friends - it'll be a laugh! When was the last time you received one of these - let alone your friends?!
                You even decide to send it to those friends who would get annoyed by this sort of thing!
                
            * Ignore the email and go to bed.
                As much as a blast from the past this was, you decide that it can stay there!
            - {time} A voice in the back of your head whispers that it secretly hopes that chain emails don't mean anything...
            ->clean_up_query
            
    = hit_the_hay
        #in_study
        // "time" variable is updated. "PROJECT" and "CURSE" variables remain the same.
        // Diverts to next knot anyway ("clean_up_query").
        ~time = "12:00am"
        ~PROJECT = true
        Enough of this nonsense! You've had enough of being confined to your study! You just want to hit the hay - pronto! 
        {time}. This is way past your bedtime!#tunes
        
        ->clean_up_query


=== clean_up_query ===
    You slowly pick yourself up from your desk chair, steadying yourself on the desk and the walls around you. 
    Oop! Your legs nearly gave way beneath you from fatigue!
    //Sentences change depending on if certain stitches have been encountered and the value of certain variables.
    You look around at the mug metropolis you've created. {food: Stale {Intro.Coffee: coffee} {Intro.Pizza: {food} pizza} smell fills the air {food=="Coffee and biscuits": biscuit crumbs litter the desk.}{Intro.Pizza: small grease pools have sank into the cardboard pizza box.}}
        #in_study
        // Yet another BIG OUTCOME-DEFINIING DECISION
        * Clean up? 
            ~CLEAN = true
            You hook each empty mug onto one finger of your free hands.
            {food: Somehow you manage to pick up {Intro.Coffee:<>the cafetiere {food=="Coffee and biscuits": <>and teaplate}} {Intro.Pizza:<>the pizza box} as well.}
            <> It's a skill you've picked up from doing this probably too many times.#in_study
            
            // These nested "decisions" inside of "*Clean up?" move the story along. User only gets one choice. Splitting up the decision in this way is also an easier way to do the movement-between-locations illusion (compared to splitting this up in to several Knots).
            **You shuffle towards the hallway...#in_study #next_room
            --
            // Moves between the study and the hallway (and turns on the hall light automatically).
            {
                    - in_hallway==false:
                        ~in_hallway=true
                        turning on the light automatically...                     
              }#in_hallway
 
            **and mosey on over to the kitchen...
                #in_hallway #next_room
            --
            // Moves between the hallway and the kitchen (and turns on the kitchen light automatically).
            {
                -in_kitchen==false:
                    ~in_kitchen=true
                    turning on the kitchen light...
              } 
            
            ...still wary not to drop anything accidentally. #in_kitchen
            
            // More conditional sentences. 
            In the kitchen you put the mugs {Intro.Coffee:<>and cafetiere {food=="Coffee and biscuits":<>and teaplate}}{Intro.Pizza:<>and pizza box }down on the counter {Intro.Pizza:<>, you put the pizza box in the {food_left>0:<>fridge|<>recycling}}, put warm water and washing up liquid in the wash basin. It soon fills up with warm soapy suds.
            
                {PROJECT==true: You're just so relieved to see the back of that project!|As you wash the pots you start to worry about that project - what if there isn't an extension? What if there is no leeway?}
                //{read_email_first or send_project_first.investigate_chain_email: {CURSE==true: What a silly chain email and all! Why has it always gotta be "send it to x number of people"?|Thank goodness you were able find x number of people to send the chain mail off to!}}
                //{send_project_first.hit_the_hay: You're just so tired and the water is so nice and warm on your hands that you almost fall asleep where you stand.}
            
            The mugs{Intro.Coffee: and pots and plates}, are all squeaky clean. You are dying to go to bed. You shuffle towards the hallway.
            
            // Come out of kitchen. User can move the story along by either switching the lights off or by choosing "No".
            Turn off kitchen lights?
                #in_kitchen #lights_OFF_please
                ** [No]
                
                {
                    - in_kitchen==true:
                        A couple extra pennies to keep the lights on won't matter in the grand scheme of things!
                }#in_kitchen

        // This is the NON-CLEAN UP option. 
        * Leave it until the morning #in_study
            
            Eh, a few little mugs {food=="Coffee": <>and a cafetiere}{food=="Coffee and biscuits": <>a cafetiere and a teaplate}{Intro.Pizza: <>and a pizza box} can wait until the morning.
        
        -   
        {
            - CLEAN ==true: 
                #in_kitchen
            - else:
                #in_study
        }//The above conditional changes the location tags dependent upon which option the user chose (i.e Clean up or non-clean up?).
        
        *[Go to hallway] #in_kitchen #next_room //So... this is a little bit dodgy, as we've gathered the clean-up and non-clean-up options, only to then move between rooms as if both options were already in the kitchen. Why does this work? //This works because it toggles the in_kitchen CSS class OFF, and because the in_study CSS class is the default.

            // Now the user is in the hallway, they get to choose if they want the lights on/off.             
            {
                -in_hallway==true: 
                    #in_hallway # lights_OFF_please
                -else:
                     #in_hallway # lights_ON_please
            }#in_hallway
        
            ** [Leave hall light{in_hallway==true: on| off}?]#in_hallway

            -- You can't wait to climb back into your cosy bed{Intro.Coffee or Intro.Pizza:.}{Intro.Sleep: - it's been calling you since you napped earlier!}
        - *[Go to bedroom] #in_hallway //This is actually a fakeout choice. The user is taken to the bathroom instead. But the next_room transition is taken care of in "penultimate_scene".
            You begin to shuffle towards the bedroom
        ->penultimate_scene


=== penultimate_scene ===
    You're so sleepy and so ready for bed. Standing in the hallway you shuffle towards the bedroom before realising that you almost forgot!#in_hallway
        //Fakeout choice; both go to the "brush_teeth" knot.
        * [Brush your teeth!]
        * Leave it until the morning.[]That's disgusting.
            Dental hygiene is very important! You must brush your teeth!
        
        -#in_hallway 
        *[Go to bathroom] 
            
            You shuffle into the bathroom. Brushing teethypegs shouldn't take too long.

        There are no windows in the bathroom.#in_hallway #next_room //Indicates move to the next location.
        
        It's so dark you can't even see a centimeter in front of your face - let alone an inch!
        {CURSE==true: The story from the chain mail lingers in the back of your head.}
        //User can turn lights ON to progress the story. ALthough this is another fakeout choice as pressing "Leave off" will turn on the lights automatically anyway. The "Leave off" choice here is also a gather point for the "Go to bathroom" choice as well.
        #in_bathroom #lights_ON_please
        - * [Leave off] 
        - {   
            - in_bathroom==false:
                Well, while it may be important to practice seeing in the dark for a powercut, you are too tired so now is not the time.
                ~in_bathroom=true
        }#in_bathroom
        That's better. You see yourself in the mirror, lit up by the bathroom's stark fluorescent lighting {in_hallway==true:and the warmer hall lighting behind|, alone in the darkness of the hallway behind you}. You look bedraggled and tired. The bathroom light picks out all of your pores, spots, and lines underneath your eyes with clinical precision. Good grief. You really do need sleep. 
            
        You pick up your toothbrush from its holder on the sink, wash it, apply toothpaste, and start brushing. 
    
    ->brush_teeth
        

=== brush_teeth ===
// This knot, and the stitch within, form one massive loop. Well, more like two loops; one nested in the other. 
// Counters "brush_count" (for choosing which "teeth" to brush), and "brush_motion_count" (for choosing how to brush those "teeth"), control the outcome of each iteration. i.e sentences printed AND if the loop is broken out of. 

// Decision for choosing which "teeth" to brush. "brush_count" is updated, and then diverts to "brushing_motions". 
#in_bathroom
    *[Top sides](Top sides)
    *[Top middle] (Top middle)
    *[Bottom sides] (Bottom sides)
    *[Bottom middle] (Bottom middle)
    - ~brush_count+=1 
    ->brushing_motions
    
    =brushing_motions 

        // Decision for choosing how to brush those "teeth". "brush_motion_count" is updated and then outcomes are decided based upon the values of "brush_count", "brush_motion_count" and other variables too. 
        #in_bathroom
        + [Side to side.] (Side to side) 
        + [Up and down.] (Up & down)
        + [Little circles.] (Little circles)
        + [Next!]
            
            //The next bits are BEFORE the gather point, so this only happens when "Next!" is chosen. 
            // Refreshes the "brush_motion_count" counter between each loop of "brushing_motions" knot. 
            ~brush_motion_count=0
            // Diverts to different knots depending on the value of different variables. i.e if brush_count is less than 4, the loop is restarted. Otherwise the loop is broken out of to different diverts depending on if CURSE is true or false. 
            {brush_count<4:->brush_teeth|{CURSE==true: ->spooky_drama |->finish_brushing_teeth}}

        - // GATHER POINT
            // Updates brush_motion_count
            ~brush_motion_count+=1 

        // Conditional sentences based off different variables. 
        { 
            - PROJECT==true:
                {You're so relieved that that project got sent off on time!| Fancy that mysterious email arriving just five minutes beforehand - it's always the way!|Anyway, that project is gone now, so you can sleep soundly.|You start to hum a little tune.|}
            -else:
                {brush_count<3: {brush_motion_count<2:Stupid project. }{&| |Making you stay up this late.|Surely you'll get the benefit of the doubt?|(oh no oh no oh no...)| You're gonna get in trouble.}}
        }
        
        {brush_motion_count==5: You must have done this side more than once by now!}
        {brush_motion_count==4: Your mind starts to wander as you repeat this little ritual.}
        
        // More conditional sentences and outcomes based off the "CURSE" and "in_hallway" variables.    
        {
            - CURSE==true:
                {   // If both "CURSE" & "in_hallway" are true, then this will trigger certain "lightswitch" effects based off the value of the counters ("brush_count" & "brush_motion_count").
                    -in_hallway==true:
                        
                        {
                            -brush_count<3:
                                    {
                                        -brush_motion_count==1:
                                                #in_bathroom #flicker #-0.6                  // Bathroom light flickers with a delay (see MAIN.JS for more information.)
                                                {
                                                    -brush_count==1 && brush_motion_count==1:
                                                        Did the lights just flicker?
                                                }
                                        - brush_motion_count==2:
                                                {
                                                    - brush_count>1:
                                                        #in_bathroom #flicker #0
                                                        {~You continue to brush your teeth|You brush your teeth a little bit quicker.|Flicker...Flicker...}
                                                        #in_bathroom #flicker #0.25
                                                }
                                        - brush_motion_count==3:
                                            {
                                                -brush_count%2==0:
                                                    #in_bathroom #flicker #-0.5
                                                    {~You think about trying  the lightswitch|Maybe there's a loose connection somewhere...|Ignore the lights.}
                                                    #in_bathroom #flicker #0.25
                                                -else:
                                                    {
                                                        - brush_count==1:
                                                            The lights settle down.
                                                    }
                                            }
                                }
                        
                            - brush_count==3 or (brush_count==4 && brush_motion_count <3)://Bathroom light flickers more vigorously at this point.
                                    
                                    #in_bathroom #flicker #-0.6
                                    {&What is happening?|...|What the..?|}
                                    #in_bathroom #flicker #-0.4
                                    {&Ohno|dread|Ohnoohnoohno|d r e a d|meeeeeep|DREAD}
                                    #in_bathroom #flicker #-0.2
                                    {&brushbrushbrush|Well, whatever happens, you'll have clean teeth!|brushbrushbrush|DAMN THIS DENTAL HYGIENE}
                                    #in_bathroom #flicker #0.0                                

                            - brush_count==4://slow & ominous
                                    #in_bathroom #flicker #1                        
                        }

                    // If the "CURSE" is true and "in_hallway" is false, no flickering light effects happen, just different sentences.     
                    -in_hallway==false:
                        {&You look at the darkened hallway past yourself in the mirror.| |The front door is lit up orange by the streetlamps outside.|The furniture makes strange shapes in the orange glow| |In the hallway you recognise the... |...side table with the telephone on it... |...the stack of takeaway menus on the side table... | ... | Is that a figure standing next to your door?| It's still there. |You pause for a moment. You're deathly still.| It doesn't move.| |Oh wait, nevermind it's the coat-rack!|For a moment the hallway looks darker...|Is that a figure standing outside your front door?|You brush your teeth quicker.->spooky_drama}
                }
            
            // More conditional sentences dependent on if the "CURSE" variable is false, and what state the hall light is in. 
            - CURSE == false:
                {
                    - in_hallway==true: 
                        {&The sight of yourself in the mirror makes yourself jump!|The bathroom light makes you look a bit ill!|You're glad that the hall light is on}
                    - in_hallway==false:    
                    {&The sight of yourself in the mirror makes yourself jump!|The bathroom light makes you look a bit ill!|You look very stark in the bathroom mirror with no other lights on!}
                }
        }

        // Conditional statement determining if the loop should only go back to the stitch "brushing_motions", or if the loop should begin from the knot "brush_teeth" again. 
        {
            - brush_motion_count<3:
                ->brushing_motions
            - brush_motion_count==6 && brush_count<4:
                ~brush_motion_count=0
                ->brush_teeth
            - brush_motion_count>=3:
                ->brushing_motions
        }


    = spooky_drama
        ~in_bathroom=false
        ~in_hallway=false
        // Hall and bathroom lights turn off automatically.
        The lights abruptly-
        turn off.#in_bathroom
            * It's probably nothing.[] You think.
                The bulb's probably gone - you reason.
                To make a point you turn the bathroom light back on. 
                // Bathroom light automatically turns back on when diverts to next knot. 
                ~in_bathroom = true
                And finish brushing your teeth, leisurely.
                ->finish_brushing_teeth
                                        
            // With this choice come some more flicker effects even going between rooms. 
            * Nope! Nope. Nope. Nope. Nope.
            #in_bathroom
                
                You practically throw the toothbrush back into the holder.
                #in_bathroom #flicker #0
                Quick swig of water to wash your mouth out.
                
                // Stitch separated by nested decisions to allow the moving-between-locations effect.
                **[Run out of the bathroom.]
                    
                    ~in_bathroom = false // Automatically turns off bathroom light regardless of its previous state.
                -- #in_bathroom #next_room
                
                ~in_hallway=false // Automatically turns off hall light regardless of its previous state. 
                #in_hallway
                It must just be loose wiring, surely?
                #in_hallway #flicker #0 // Another flicker effect - but with the hall light instead.
                **[You practically leap into the bedroom.] #in_hallway
                -- #in_hallway #next_room // Move between locations.
                #in_bedroom
                Oh no!
                #in_bedroom #flicker #-0.2 // Bedroom light flicker effect. 
                
                <nobr> // Tag lists in Ink are NOT separated by new lines. So by putting <nobr> here, I've separated the tag list, tricked the HTML into not printing anything, and prevented a line break in the HTML too. 
                
                // Story progresses if user turns lights on/off, or chooses to leave lights off/on. 
                {
                    -in_bedroom==true: 
                        #in_bedroom # lights_OFF_please
                    -else:
                         #in_bedroom # lights_ON_please
                }
                
                **[Leave lights {in_bedroom==true:on|off}?] #in_bedroom
                --{in_bedroom==true:You absolutely don't want to be left in the dark!|Maybe you'll be safer under the cover of darkness?}
                

                You avoid the potential monster under your bed by jumping in! 
                Once in you draw the covers up past your head.
                ...
                Aaah.
                You survey the scene for a bit. Nothing appears out of place.
                ...
                Everything is still.
                ...
                Safe.
                ...
                
                // Story progresses if user turns lights on/off, or chooses to leave lights off/on. 
                {
                    -in_bedroom==true: 
                        #in_bedroom # lights_OFF_please
                    -else:
                         #in_bedroom # lights_ON_please
                }
                **[Leave lights {in_bedroom==true:on|off}?] #in_bedroom
                --{in_bedroom==true:Absolutely not! |You feel brave enough to have the lights off, you roll over and go to sleep.}                
                ->Endings


    = finish_brushing_teeth
        You take your toothbrush out of your mouth.
        You wash your toothbrush under the running water.
        You put the toothbrush back in its holder on the sink. 
        You take a swigful of water to rinse your mouth with.
        You spit out the water into the sink.
        You dry your hands and face.

        // Requires user to turn lights OFF or leave the light on to progress the story.
        #in_bathroom #lights_OFF_please
        *[Leave bathroom light {in_bathroom==true:on?|off?}] Suit yourself. 
            #in_bathroom
        -*[Leave the bathroom.] #in_bathroom
        -#in_bathroom #next_room //Indicates transition between locations.
        #in_hallway
        
        // Requires user to turn lights ON/OFF or leaving lights to progress the story. 
        Hall light?
            {
                -in_hallway==true: 
                    #in_hallway #lights_OFF_please
                -else:
                     #in_hallway #lights_ON_please
            }

        *[Leave hall light {in_hallway==true: on|off}] 
            #in_hallway        

            {brush_teeth.spooky_drama:{in_hallway==false:That'll stop that light from flickering thankyouverymuch|The shapes in the hallway reveal themselves. It's just your side table and coat rack! Nothing to be scared of!}}

        -*[Go to bedroom] #in_hallway
        -#in_hallway #next_room // Indicates transition between locations. 
        #in_bedroom
        
        {in_bedroom==true: There's your bed! Looking all cosy{Intro.Sleep: -just as cosy as when you went for a nap earlier!|-it's been expecting you}!|You can't see a damn thing in here!}
            //Requires user to turn lights ON/OFF or leave lights to progress the story. 
            {
                -in_bedroom==true: 
                    #in_bedroom #lights_OFF_please
                -else:
                     #in_bedroom #lights_ON_please
            }

            *[Leave bedroom light {in_bedroom==true:on|off}] #in_bedroom

        // Conditional sentences.
        -{in_bedroom==true:You sleepily shuffle yourself over to the bed.|You cautiously walk on over to where you think your bed is. You put your arms outstretched just in case. Your hands touch something soft like cotton. It's a rounded edge. It must be the corner of your bed!} {brush_teeth.spooky_drama: For a moment you hesitate as your mind wonders if there could be something lurking underneath your bed. You decide to ignore it.} You climb up onto the bed.
            
        On the bed now you wiggle yourself to underneath the covers. You make yourself cosy.

        // More conditional sentences based off if user encountered "brush_teeth.spooky_drama" stitch.
        {
            - brush_teeth.spooky_drama:
                You survey the scene for a bit. Nothing appears out of place.
                ...
                Everything is still.
                ...
                Safe.
                ...
        }
        
        //Requires user to turn lights ON/OFF or leave lights to progress the story. 
        {
            -in_bedroom==true: 
                #in_bedroom #lights_OFF_please
            -else:
                 #in_bedroom #lights_ON_please
        }

        * [Leave bedroom light {in_bedroom==true:on|off}?] #in_bedroom
            
            // More conditional sentences.
            {in_bedroom==false:{brush_teeth.spooky_drama:You feel brave enough now to turn the lights off.|Night night!}|{brush_teeth.spooky_drama:You don't feel quite brave enough to sleep with the light off just yet.|}<> You drift off with the bedroom light on.}
            {brush_teeth.spooky_drama:<> You roll over and go to sleep.}
            -> Endings


=== Endings ===
    // Conditional statement to determine ending.
    {
        - snooze==2:
            ->snooze_ending
        - PROJECT == false && CURSE == false:
            ->final_ending_one
    
        -((PROJECT == true) or (PROJECT == false) )&& CURSE == true:
            -> final_ending_two
    
        - PROJECT == true && CURSE == false:
            -> final_ending_three
    }
    
=== snooze_ending ===
        // Basically just prose here. Nothing too exciting. 

        #in_bedroom #flicker #2 // Bedroom light flicker effect.
        You snooze away the hours. The clock ticks. Thoughts of your project drift away out of your mind.
        Stale coffee mugs in the study grow even staler!
        Ten minutes to the project deadline your laptop pings once!
        You roll-over blissfully unaware. 
        #in_bedroom #flicker #4 // Another bedroom light flicker effect.
        Five minutes to the project deadline your laptop pings again!
        CRACK! The window in the study has opened. Papers on the desk flutter around the room. 
        You feel a breeze but you're too deep in sleep to care. A slight chill fills the room. The covers get pulled up over your shoulders.
        
        Hours pass.
        
        08:30am. Your alarm wakes you up. It's cold. 
        You realise that you oversnoozed! The project is not done! Oh no! DREAD. 
        You leap out of bed to see if you can send it off anyway. You rush to the study. The window is open. Papers litter the floor, the chair and the desk. Mugs have been knocked over. Some mugs are on the floor. 
        
        You wake up your laptop from its sleep and begin to catch up with your work.
        There are two emails waiting for you. #in_bedroom
        ->END // End statement. Signals the end of the story to Ink.
        
        
=== final_ending_one ===
        
        //The FIRST end! PROJECT==false & CURSE==false
        //i.e Project not sent off & Curse either not looked at OR instructions followed!
        
        // Conditional sentences based off which stitches encountered & other variable states.         
        The clock ticks. You drift off in to a deep sleep.
        <>{Intro.Sleep && snooze >=0: This is perhaps one of the deepest sleeps you have had for a long time!|}
        Every now and again
        <>{Intro.Coffee: the coffee makes you fitfully wake up and think about| you dream about}
        <> silly things. Things like
 
        <>{CLEAN==true: if you cleaned up the study or not? Was washing the mugs real or a dream?| stale coffee mugs in the study growing staler and becoming overgrown with plants sprouting from the coffee stains!}
        <>{Intro.Pizza: Most importantly, was there any pizza leftover? You think you may have some left over...}
        
        <>And who the heck would be sending chain emails in this day and age?!
        
        You drift off again. 
        
        // Only choice progresses the story. 
        #in_bedroom
        08:30am. Your alarm starts blaring.
        *Wake up #in_bedroom
        -
        // Turns on bedroom light automatically
        ~in_bedroom=true
        DREAD. 
        Why? 
        DREAD.
        You receive a message on your phone from your friend asking you if you managed to send the project off...
        DREAD. 
        Oh no!
        DREAD.
        
        
        You leap out of bed to see if you can send it off anyway. 
        #in_bedroom
        // Again another sole choice just to progress the story.
        *[Go to study.] You rush to the study. #in_bedroom #next_room //Indicates transition between locations. 
            #in_study
            
        // More conditional sentences.    
        -{CLEAN==false:The stale mug metropolis is still there.|Thankfully the study is clean.}
        The laptop is asleep. You wake the laptop up and it sleepily breathes into life. #in_study
            
            // Conditional divert.
            {food=="Pizza":->final_ending_one_food_choice}
        
        // Another conditional sentence. 
        You {CLEAN==false:make a space on the desk for yourself, and |get comfortable, and} start working on the project - you never know, maybe they'll accept a late submission?
        #in_study
        ->END // End statement. Signals the end of the story to Ink.


    =final_ending_one_food_choice
        #in_study
        // Simple choices. Both lead to an Ending. 
        Check for pizza while you wait for your laptop?
            *Yes []Good choice!#in_study
                
                // Conditional sentences                
                You walk on over to the kitchen.
                {food_left>0: You look in the fridge and... |You see the pizza box in the recycling - this is a bad omen to be sure!}
                {food_left>0:There lies a beautiful sight of a pizza box!|You look in the fridge anyway and...}
                {food_left>0:Pizza for breakfast it is - HUZZAH!|Empty.}
                {food_left==0: :(}#in_kitchen //Only this tag is needed to indicate movement between rooms as #in_study is the default, so #in_kitchen toggles the in_kitchen CSS class on & masks the in_study class.
                
                // Nested sole choice to progress the story on to the next room. 
                **[Back to study] #in_kitchen #next_room
                    #in_study
                    
                    //Transitioned on to the next room and conditional sentences. 
                    You mosey on back to the study, {food_left>0:pizza in hand, } {CLEAN==false:{food_left>0:make a space on the desk for yourself and the pizza,|make a space on the desk for yourself,}|{food_left>0:plop the pizza on the desk|get comfortable,}} and start working on the project - you never know, maybe they'll accept a late submission?
                                ->END // End statement. Signals the end of the story to Ink.                    
                                
            * No
                // With this choice, you essentially just get prose. Nothing too exciting really. 
                #in_study
                You're not in the mood for pizza, - there's no time!
                **[Start working] #in_study
                    
                    
                    Desperate to try and change your fate, you plonk yourself down into your office chair, nervously waiting for the laptop to finally boot up.
                    Once it finally does you frantically start opening programs and files, only causing it to slow down even more. 
                    Eventually the laptop calms down again, and you are able to start working on the project - you never know, maybe they'll accept a late submission?
                    ->END // End statement. Signals the end of the story to Ink.


=== final_ending_two ===
    //The SECOND end! PROJECT==true or false & CURSE==true
    //i.e Project either sent off or not & Curse looked at and instructions not followed!

    #in_bedroom
    You are woken up by a strange noise! #in_bedroom
        * Look at time? 
            2am. It is the witching hour.
        * Try and go back to sleep

    - You roll over to nestle into your bed some more. To try and drift off to sleep once more. But then...
    //Changes one variable for a later conversation in this knot. 
    { 
        - (in_kitchen==true or in_bathroom==true or in_hallway==true or in_bedroom==true): 
            ~blackpool_illuminations=true
    }
    ->flicker_intro

    =flicker_intro
        // Automatically turns all of the lights off.
        ~in_kitchen=false
        ~in_bathroom=false
        ~in_hallway=false
        ~in_bedroom=false
        
        // More flicker effects, separated by <nobr> HTML tags.     
        #in_bedroom #flicker #-0.6 
        <nobr>
        #in_bedroom #flicker #-0.4 
        <nobr>

        // Divert to a knot that contains a loop
        ->flicker_start
            
    
    =flicker_start
        // Similar to "brush_teeth" this entire stitch as well as "flickering_lights" is a loop! All to produce some light flickering effects.
        // The outcomes of this loop is determined by the "flickering_lights_count" variable. 
        
        // Flicker effect
        #in_bedroom #flicker #0.2
        <nobr>
        
        // Choice between turning light ON/OFF or eaving the light as it is. 
        {
            - in_bedroom == true:
                #in_bedroom #lights_OFF_please
            -else:
                #in_bedroom #lights_ON_please
        }
        +[Leave light?] #in_bedroom
        
        // Changes sentence printed based on value of "flickering_lights_count".
        -  {flickering_lights_count>0 && flickering_lights_count<3:{What the?|Have you tried the lightswitch?}}
        
        // Diverts to "flickering_lights" stitch. 
        ->flickering_lights
        
    =flickering_lights

        { 
            // Flickering lights pattern if the counter is less than 3. 
            - flickering_lights_count<3:
                {
                    // Flickering lights pattern if the counter is an even number less than 3.
                    -flickering_lights_count%2 ==0: 
                            {
                                -in_bedroom==false:
                                    #in_bedroom #flicker #-0.7
                                    <nobr>
                                    #in_hallway #flicker #-0.4
                                
                                -else:
                                    #in_hallway #flicker #-0.7
                                    <nobr>
                                    #in_bedroom #flicker #-0.4
                            }
                        // Counter updated, and diverted to the beginning of the loop ("flicker_start").
                        ~flickering_lights_count+=1
                        ->flicker_start
                        
                    // Flickering lights pattern if the counter is an odd number less than 3.
                    -else:
                            #in_hallway #flicker #-0.75
                                <nobr>
                            #in_bedroom #flicker #-0.5
                                <nobr>
                            #in_hallway #flicker #-0.25                             
                                <nobr>
                            #in_bedroom #flicker #0

                        // Counter updated, and diverted to the beginning of the loop ("flicker_start").
                        ~flickering_lights_count+=1
                        ->flicker_start
                }
            
            // Outcome if the counter is equal to 3.  
            - flickering_lights_count ==3:
                // All lights are automatically turned off.
                ~in_bathroom=false
                ~in_hallway=false
                ~in_bedroom=false
                
                // Flicker pattern.
                #in_study #flicker #-0.4
                This cannot be happening...
                #in_hallway #flicker #-0.2 
                DREAD
                #in_bathroom #flicker #0.0
                No no no no no no nonononononononono!
                #in_hallway #flicker #0.2 
                <nobr>
                #in_bedroom #flicker #0.4
                <nobr>

                // Divert OUT of loop to "final_choice".
                ->final_choice
        }
        

    =final_choice    
        #in_bedroom
        
        After all that.
        
        Nothing. 

        It seems eerily quiet now. 
        You're uncertain, but... is that something moving? #in_bedroom
            * Take a look 
                You open your eyes. 
                Your room seems... Normal. Nothing out of the ordinary.
                But then you glance over to your wardrobe and see an object there that wasn't there before...
            * NOPE!
        
        - You close your eyes tighter! You roll over in bed! #in_bedroom
        
        // More prose with some conditional sentences.
        You hear a shuffle.
        Shuffle.
        Shuffle.
        Then a 
                - THUD! 
        Shuffle. Shuffle. Shuffle.
        You hear slow, haggard breathing coming closer, ever closer...
        Shuffle. 
                - GASP!
            shuffle
                    -GASP!
                        shuffle
        You hear the haggard breathing now right next to your ear.
        {blackpool_illuminations==true: "Bloody hell. It were like Blackpool Illuminations in here!" Says a cold, raspy voice.}
        You stay incredibly still.
        "Flipping curse! I can't see anything in here!" says the cold raspy voice
        ~in_bedroom=true
        Oh no. There's DEFINITELY someone in the room with you. Strange for a burglar to be this chatty... And what do they mean by curse?
        {CLEAN == true: "So many chuffing visits to do tonight! So many messy rooms! Well, at least this one is tidy!"|"Eugh! It's absolutely filthy in here! Just like the last lot I saw! Never in my day!"}
        You remember the chain email.
        Oh no... 
        What to do what to do what to do...
            // Conditional block leads to other stitches with further decisions based off decisions made earlier in the story. 
            {   
                - Intro.Pizza or Intro.Coffee:
                    ->offer_food_or_hide
                
                -snooze>0:
                    ->doze_off
            }
        

        =offer_food_or_hide
        // Conditional sentences. 
        You remember you {Intro.Pizza:ordered some pizza!}{Intro.Coffee: made some coffee. {food=="Coffee":Maybe you do have biscuits left in the barrel after all?|You know there are some biscuits left!}} Bit of a long shot though... maybe it would be better to try and disguise yourself as a pillow? 
        #in_bedroom
        // Choice between "Offer food" or "Hide under bed".
            * [Offer food] It's worth a shot!
                You wriggle out of the covers slightly. 
                You open your eyes.
                There she is. Adorned in a heavy black lace dress, hair matted in with the lace, blood matted in with the hair. It's difficult to see her face, but you find an eye.
                With a raised eyebrow Bloody Mary eyes you up and down.
                "Yes hello, yes? You may as well sit up love"
                Terrified, you do just that.
                
                // Nested inconsequential decision - i.e both choice have the same outcome.
                "Now, do you know why I'm here?"#in_bedroom
                    ** Nod head
                        "Ah good good. That'll save me some explanation. 
                    ** Shake head
                        "Alright. Very well then. I'm here because of that chain email that you must have opened and not followed the instructions on. Ring a bell?
                    --Personally I don't know why I have to haunt folks just because they didn't follow some instructions. Seems rather pointless to me in the grand scheme of things."

                <> Well, here goes nothing.
                "It sounds like you've come a long way... Would you like something to eat?"
                "..."
                "..."
                "You know what? Nobody's ever asked me that before! Usually they're just shaking in their bedsheets by now! Yes that would be lovely!"#in_bedroom
                
                // These next few nested decisions only serve to progress the story and to show the transition between rooms.
                **[Lead the way] #in_bedroom
                
                //Turns the hall light on automatically.    
                -- ~in_hallway=true
                You climb out of bed and walk to the kitchen with Bloody Mary in tow. She turns on lights for you.#in_bedroom #next_room // Transition to next location. 
                    #in_hallway
                **[Go to kitchen] #in_hallway
                
                -- ~in_kitchen=true
                "Thank you!" you say #in_hallway #next_room //Transition to next location.                     
                #in_kitchen
                "You're welcome luvvy"
                (This seems to be going surprisingly well!)

                In the kitchen.
                //Conditional sentence.
                {CLEAN==true:Thankfully it is nice and tidy. Bloody Mary appears to nod and smile. |Bloody Mary tuts at the mess in the you left. }

                {
                    // Diverts to good ending if Intro.Pizza is encountered and there is food_left, or if Intro.Coffee is encountered.
                    -(Intro.Pizza and food_left>0) or Intro.Coffee: 
                        ->Offer_food_good_end

                    // A bad ending.
                    - (Intro.Pizza and food_left==0):
                        // Conditional sentences based off "CLEAN" variable. 
                        {
                            - CLEAN==true: 
                                Then you see it. The pizza box sticking out of the recycling. 
                                A bad omen.
                            -else: 
                                Out of nowhere Bloody Mary pipes up: 
                                "You know, it's funny. I didn't think that there would be any pizza left when you offered as I came in through your study and noticed an empty Pizza box. Smelled awful and all."
                                Oh no. DREAD. 
                                Maybe you ate all of the pizza? 
                                DREAD.
                        }                
                        
                        // Bad ending. Multiple flicker effects. 
                        
                        ~in_kitchen = true
                        #in_kitchen
                        You turn around. Bloody Mary does not look happy.
                        #in_kitchen #flicker #2
                        "Offering food when you don't have any? Now, THAT is mighty inhospitable of you." Strands of hair start to move upwards. 
                        #in_kitchen #flicker #2.5
                        There is a chill. 
                        "An ancient woman such as myself needs sustenance" More strands of hair stand up on end, revealing her face piece by piece. 
                        #in_kitchen #flicker #3
                        "And for you to offer food without having any? Unforgivable"
                        #in_kitchen #flicker #3.5
                        Her face is fully visible now. It is full of scorn. The room turns ice cold. 
                        

                        
                        #in_kitchen #flicker #4
                        You make a note not to offer food without having any.
                        #in_kitchen #flicker #5.5
                        
                        // Kitchen light turns off ominously. And end of story.
                        ~in_kitchen=false
                        #in_kitchen
                        ->END // End statement. Signals the end of the story to Ink.
                }
                
                
            * [Hide under bed] NOPE!
                // Hide under bed choice. Mainly a lot of prose really. 
                
                Nope. Nope! Nope! Nope! Nope! Nope!
                You're not dealing with this. You know you can disguise yourself as a pillow - and you can make yourself a damn good one at that!
                But you have to roll over. #in_bedroom
                    
                    //Nested decisions that come to the same gather points. 

                    **[Quickly?]This is high-risk high-reward.
                    #in_bedroom
                        You decide to go for broke and roll over as quickly as possible - there's a chance that you'll do it so fast that Bloody Mary just won't notice... Right? 
                        You hear her haggard breathing.
                        Okay. Here goes.
                        3...
                        2..
                        1.
                        GO!
                        You roll over so quickly that you almost jump up from the bed. But in a single manoeuver not only did you roll over, but you also managed to pull the covers over your head and land in the foetal position underneath the covers. 
                        Just as you land you think you hear Bloody Mary quickly turn around.
                        You did make a lot of noise though.
                        STEP-SHUFFLE
                        You realise you need to lower the volume of your breathing.
                        STEP-SHUFFLE
                        You try and take shallow breaths.
                        STEP-SHUFFLE
                        You're finally used to taking shallow breaths now.
                        
                    **[Subtly?] Okay. Your funeral.
                    #in_bedroom
                        Inch by inch, millimetre by millimetre, you roll over, pulling up the covers over your head as you go. 
                        Keep going.
                        You hear her breathing.
                        STEP-SHUFFLE
                        Keep going. 
                        It's haggard.
                        STEP-SHUFFLE.
                        You're nearly there. 
                        STEP-SHUFFLE.
                        You bend into the foetal position.
                    -- SHE IS NEXT TO YOU. #in_bedroom
                    Everything is deathly still.
                    You hear her breathing right next to your ear.
                    You wish you could fall asleep but you don't dare.
                    Bloody Mary is standing over you, staring.
                    You don't dare fall asleep.
                    
                    The clock ticks on until morning. #in_bedroom
                    #in_bedroom #flicker #4 //Flicker effect
                ->END // End statement. Signals the end of the story to Ink.

        =Offer_food_good_end
            //Good ending to the "Offer_food" option.
            
            // Conditional sentences. 
            {Intro.Pizza:You haven't seen the pizza box yet. Is this a good omen? You walk over to the fridge. You open the fridge.}
            {Intro.Coffee:You walk over to the biscuit barrel. You open the biscuit barrel.}
    
            Aaand...
            Relief! Sweet relief!
            {Intro.Pizza: There in the fridge is the pizza box! Leftover {food} pizza slices still inside! You take the box out of the fridge.}
    
    
            {Intro.Coffee: 
                Thankfully the biscuit barrel is laden with biscuits - 'tis truly a beautiful sight!
                You fill the kettle up with water and set it boiling. 
                You then get the cafetiere{CLEAN==true: from the draining board and the| from the counter and give it a quick clean (Bloody Mary pulls a disgusted face but you continue anyway). You get the} coffee grounds and two plates out of the cupboard. You scoop one. Two. Three scoopfuls of coffee grounds into the cafetiere. 
                The water finishes boiling. You pour the water into the cafetiere and give it a stir.                                
                You let Bloody Mary help herself to biscuits. She takes {~one|two|three} biscuits. One {~chocolate digestive|custard cream|chocolate bourbon}, one {~chocolate digestive|custard cream|chocolate bourbon} and a {~chocolate digestive|custard cream|chocolate bourbon}. 
                You help yourself to three biscuits: one of each.
            }
            Bloody Mary and you shuffle#in_kitchen
            // Choice that progresses the story.
            *[Lead back to hallway]
              
            - 
            #in_kitchen #next_room // Indicates movement between locations.
            ...back through the hallway
            #in_hallway            
           
            *[Back to bedroom]
                
            -
            #in_hallway #next_room // Indicates movement between locations.
            
            // More conditional sentences, and then the end of the story!
            
            ...and back into the bedroom again, {Intro.Coffee:coffee {food=="Coffee and biscuits":and biscuits}}{Intro.Pizza: leftover pizza} in hand. 
                
            You offer Bloody Mary a seat on the armchair. 
            "That's very kind of you! Thank you very much!" She says and eases herself down.
            You take a seat on the bed.
            Silence.
            
            {Intro.Coffee:She takes a sip of the coffee. |{Intro.Pizza:She inspects a slice of the leftover pizza, sniffs it, nibbles it and once satisfied that it is safe, takes a bite. }}
            <>Not wanting to risk angering her, you copy her actions.
            Silence.
            Things feel a bit awkward.
            {   
                - Intro.Coffee:
                    "So, you must have some interesting stories to tell?"
                    You feel the coffee kicking in and realise something...
                    Isn't that coffee particularly strong? This could be interesting...
                    
                    "Oh, you wouldn't know the start of it love!" says Bloody Mary.
                    
                    You look up and see that the coffee has had a profound effect on Bloody Mary. She is sitting up like a bolt. Her hair is standing on end - the entire length of it! Her eyes are wide. She's smiling maniacally.
                    You're in for it now. She starts reeling off her life story, and all the tangential stories in between, at lightning fast pace.
                    Something tells you this is going to be a loooong night. 
                    
    
                - Intro.Pizza:
                    Wasn't your friend up really late working on the same project?
                    You decide to ask Bloody Mary if she's ever played videogames before - hey the food worked so why not this?
                    She says she has dabbled in a few.
                    Well then, that's more than enough! You ring up your friend -thankfully they're still wide awake- and invite them over.
                    
                    As you wait for your friend, you and Bloody Mary boot up a couple of games of Mario-Kart and tuck into the leftover pizza slices.
                    
                    Your friend arrives! They've brought more pizza - piping hot!
                    You all spend the night playing videogames and eating fresh hot 'za until the morning.
            }
            #in_bedroom
            ->END // End statement. Signals the end of the story to Ink.


        =doze_off
            // Outcome if Intro.Sleep stitch was encountered. 
            Eugh. 
            Ach. Bleurgh. 
            It's probably a dream.
            You remember something from a documentary about sleep paralysis.
            Apparently you can stop an episode of sleep paralysis by moving around a bit. 
            Although... You've never gotten sleep paralysis before. #in_bedroom
            // One of two choices leading to a separate ending each. Nothing too exciting here, just prose.
            * [Wriggle your toes.]
                The presence you felt in the room before begins to grow faint.
                wriggle-wriggle-wriggle
                It appears to dissipate. 
                wriggle-wriggle-wriggle
                It's undetectable from the darkness of the room.
                wriggle-wriggle-wriggle
                It is gone.
                You fall asleep. 
                #in_bedroom
                ->END // End statement. Signals the end of the story to Ink.
            * [Go back to sleep.]Sure. It's unlikely you'll get it in the future. 
                You drift back off to sleep. The presence is still there but you ignore it.
                A few moments later, you feel a heavy weight on your chest.
                You open your eyes. 
                A shadowy figure looms over you. It looks like they are wearing a heavy dress adorned in lace. Their long black hair is matted with blood, and tangled up in the lace.
                Under the mess of hair you can just about make out an eye. It is emotionless. 
                You can't move under the weight of their stare.
                You're unsure if this is a dream or not.
                The clock ticks on until morning.
                #in_bedroom
                ->END // End statement. Signals the end of the story to Ink.

===final_ending_three===
        //The THIRD end! PROJECT==true & CURSE==false
        //i.e Project sent off & Curse either not looked at OR looked at and instructions followed!

        // Nothing too interesting in this ending going on. Just conditional sentences really. 
        
        #in_bedroom
        The clock ticks. You drift off in to a deep sleep.
        <>{Intro.Sleep && snooze >=0: This is perhaps one of the deepest sleeps you have had for a long time!|}
        <> Every now and again
        <>{Intro.Coffee: the coffee makes you fitfully wake up and think about| you dream about silly things. Things like}
        <>{CLEAN==true: if you cleaned up the study or not? You remember washing mugs... But was that a dream?| stale coffee mugs in the study growing staler and becoming overgrown with plants sprouting from the coffee stains!}
        <>{Intro.Pizza: Most importantly, was there any pizza leftover? You think you may have some left over...}
        <> Sometimes you {Intro.Coffee:wake up and |half-asleep }think about your project with dread. And then with relief remember it's all signed, sealed and delivered. Imagine if you read that email that arrived 5minutes before the deadline!
        
        You drift off again. 
        
        08:30am. You wake up before your alarm - happy & refreshed!
        You mosey on over to your study to see what that email was all about... #in_bedroom
        ->END // End statement. Signals the end of the story to Ink. 
    
