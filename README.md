# CS50x 2021 Final Project
# Interactive Fiction Game: "Who Turned off the Lights?"
## Video Demo:  [Who Turned off the Lights?](https://youtu.be/SWs1opgJhH4)
## Description:
**A ***Spooky*** Interactive Fiction (aka a choose-your-own-story) game written in Ink, adapted for the web via Javascript & HTML/CSS.**

## How to play?
**Simply download the "Finished Project" folder. Then open the HTML file in a Google Chrome browser and play the game by choosing different options presented to you in the story, either by clicking the options or the lightswitch button when hinted.**

## What is "Original Ink 'Export for Web' Files"?  
**Essentially these files are the initial game that was created i.e the game without my modifications. These are the original files created by Inkle immediately after exporting the Ink story for the web. You can play this version of the game following the same instructions under the "How to play" header (download the "Original Ink 'Export for Web' Files" and open "index.html" instead).** 

---

## More details  

### What have I made?  
An interactive fiction game adapted for the web, with a slight twist.
Players advance the plot not only by using dialogue options given to them, but also by clicking the lightswitch button on the webpage itself at certain decisions.

### Why Interactive Fiction?
Well, in all honesty these interest me. Despite having only ever played a small bit of the "Hitchhiker's Guide to the Galaxy" text-based game and watching a letsplay of "The House Abandon", I was inspired by the humour in the facetiousness of the former, and the surprising immersiveness of the latter.  
Likewise when I was researching other web-hosted interactive-fiction games, I got the impression that the game seemed to be confined to a small window of the webpage. So I wanted to play around with the idea of incorporating more of a webpage into the game itself, to subvert the player's expectations on how to operate both an interactive fiction game, and on how unified/"same-y" websites have become.

### Why this story?
Originally I wanted to make a story that would have incorporated more of the standardised buttons on websites nowadays (e.g "Hamburger Stack" menu icon would actually take you to the "Hamburger Stack" diner in the story etc.) however, this was mainly built on vague ideas of which webpage buttons could do what and I did not have a proper storyline down. 
So I reeled it back, made the story simpler, and landed on inspiration from the chain mail emails you used to get in the 90's/early 00's. 

---

## Technical details

### Languages used? Why?
**Ink**  
(See [here](https://github.com/inkle) & [here](https://github.com/inkle/ink).)
Ink is a scripting language based around C# specifically designed for writing interactive fiction.  
I decided to use Ink because:
* It is easier and quicker to script a game in Ink, rather than Python, as Ink already takes care of certain features (such as user-choice-tracking).
* The text editor (Inky), allows "Export to Web", and "Export to .js" options. Both of which allow the Ink script to be interpreted and interacted with via Javascript for displaying on a web page.
* The "Export to Web" option also provides the following default files:
  * Javascript files including: "name_of_story.js"(converts the Ink script to a javascript variable called "StoryContent"); "ink.js" (redefines Ink rules/objects for javascript); "main.js"(handles interaction between story/ink.js, and the main HTML DOM).
  * Basic HTML & CSS 'default' format files.(Editing the HTML, CSS & main.js files is strongly encouraged by the creators of Ink/Inky/Inkle.)
* The Ink game script can also be manipulated by Javascript (and vice versa) via tags and/or variables set up in the Ink script.    
  * Ink Tag Example: 
		
		#tag_name
		Middle of story is happening.
		
	
  * Ink Global Variable Example:
				
		VAR lights = false

		->story
		==story==	
		Story is happening.
		~lights = true
		
  
**Javascript**  
An object-oriented programming language used for manipulating the HTML DOM of .html files (and other functions).  
This was used to manipulate the HTML DOM in general, and to act as a "bridge" between the game script (as given by the "name_of_story.js" file) and the HTML DOM.

**HTML**  
A markup language for designing the layout of the webpage(s) - used just for that!

**CSS(+Bootstrap)**  
Used to design the look/aesthetic of the webpage(s), with Bootstrap being a standardised CSS.

### Languages not used and why.
**Python & SQL & Flask/AJAX.**  
I originally wanted to include player log-ins & passwords into the game so that a user could reload their own specific game, rather than having to start all over again.  However as the project went on, I did not have time to implement this before my own deadline (see below for details on deadlines).  
However, I was able to include Save/Load/Restart buttons (based off those included in the "main.js" file). These save/reload/restart the state of the game (as the variable accessed in "name_of_story.js") into/from/in the browser window respectively.  
For implementing user accounts, the same information that is passed into the browser memory would be saved into/reloaded from/removed from an SQL database, via Python.

### Text editors/IDEs used? 
**Inky (IDE)**  
**Used for: Ink**  
Inky hosts scripting in Ink. It allows you to test the flow of the game concurrently with script editing!

**Microsoft Visual Code (text editor/IDE)**  
**Used for: Javascript/HTML/CSS**  
While I wanted to move away from using CS50's IDE, I wasn't fully confident with working in a text editor without more beginner-friendly features.  
Initially I looked at the Sublime text editor, but then quickly found out that I already had Microsoft Visual Code and that it acts more as an IDE by having additional features such as debugging etc., whereas Sublime does not.

**CS50 IDE (AWS based IDE)**  
**Used for: Javascript/HTML/CSS**  
Mainly used for accessibility reasons i.e if I was on a different PC that did not have Microsoft Visual Code installed.

---

## Goals & Timelines

### Initial Goals
**Initially I had four main goals, or standards, of completion for this project:**
* **"Bronze"**  
     Make a simple web text-based adventure game. Player only advances the story by choosing options given to them. 

* **"Silver"**  
    "Bronze" Standard PLUS...  
    Add functionality that advances the story via a lightswitch button on the website itself.

* **"Gold"**  
    "Bronze" and "Silver" Standard PLUS...  
    Allow different players to be able to play on the same browser. i.e allow account registration/log-in/log-out before starting or continuing the story. Each players progress would be saved in their account. 

* **"Platinum"**  
    "Bronze" and "Silver" and "Gold" Standard PLUS...  
    Make the register/log-in options seamless with the plot. 

---

### Original Timeline: 
* **Stage A.**
  * **13/09/2021 (<1 day):** Generate ideas for project and decide on one.
* **Stage B.**
  * **~16/09/2021 or ~17/09/2021 (1 day):** Plan out HOW to do the project. i.e Project structure & break down in to chunks. Which languages & IDE's/text editors to use. Other areas to research.
* **Stage C.** 
  * **18/09/2021 (<1 day):** Plan a more detailed timeline.
* **Stage D.**
  * **22/09/2021-(25 or 27)/09/2021 (3-5 days). Start project:** Log in README draft. Set up initial directories and files: Project directory, README file, Export initial Ink file for web & make a copy (to work on), HTML template & CSS.
* **Stage E.**
  * **25-27/09/2021 - 03/10/2021 (1 week). Quarter-done:** Basic story decided on & completed, written in Ink and saved. Basic HTML & CSS decided on and completed.
* **Stage F.**
  * **03/10/2021 - 10/10/2021 (1 week). Half-done:** Add Javascript button to the HTML template that interacts with the story!
* **Stage G.**
  * **10/10/2021 - 17/10/2021 (1 week). Three quarters-done:** IF POSSIBLE: Try and make user log-ins. And then make this seamless with the story! IF NOT: Add more interaction with the story. 
* **Stage H.**
  * **(24 OR 31)/10/2021 (1-2 weeks). Testing:** Self & on Audiences. Error checking & Style checking. Further testing. 
* **Stage I.**
  * **07/11/2021 (1 week):** Neaten up README, record demo video & submit!

---

### Actual Timeline: 
* **Stages A.-C.**  
**~05-10/09/2021 (~5 days):** Project ideas were considered, decided on and planned while answering the ethics questions for Lab 10!

* **Stage D.**  **~15-16/09/2021 (~2 days) Project Start:** Directories and files set up. 

* **Stage E.**  **16/09/2021-03/10/2021 (~17 days) 1/4-DONE:**
  * 16-17/09/2021: Figured out a story and a rough flowchart. Also began thinking of HTML layout and design.
  * 18/09/2021: Made a physical flowchart of story-beats (see "Images/Interactive_Story_Flowchart.jpg"). Also planned which should be "Knots" or "stitches", where "diverts" should go!
  * 18-23/09/2021: Wrote stripped-back story in Ink i.e wrote the main knots/stitches/diverts/weaves/"if/else" blocks in ink. Started modifying the HTML & CSS template generated automatically by Inky (when "Export to Web").
  * 24/09 - 03/10/2021: Filled in the blanks in the story in the Ink script. Basic Ink script finished (additional modifications may come later). Finished modifying the HTML & CSS template to a basic standard i.e a starting point.

* **Stages F. & G.**  **(This bit took longer than I would have liked as I was back at work full-time after a holiday!)**  
**03-24/10/2021 (21 days) ~2/3-DONE:**
  * 03/10/2021 : Sorted out the CSS classes to use for the "light" effects in different "rooms".
  * 03-06/10/2021: Attempted to understand how to use run the Ink storyfile using Javascript. For this I referred to the "Running Your Ink" documentation AND THEN had a breakthrough when I found [Dan Cox's blog]("https://videlais.com/ink-tutorials/"). Honestly saved my life because I knew that there must have been a way to advance a story via a non-choice button click (and change variables of the Ink storyfile in one fell swoop), but it just would not click fully until I found this blog!
  * 06-14/10/2021: Figured out how to implement all of the light effects I wanted via communication between Javascript and "tags" in Ink. Completed a rough markup of Ink with "tags", to then test later. 
  * 14-18/10/2021: Implemented the lighting effects in the Ink script and was testing as I went along.
  * 19/10/2021: I decided the finer details of some of the light effects (i.e flicker effects). I also marked up the Ink script to hide choices after they were made.
  * 20/10/2021: Modified main.js likeso: Added comments; Add the fade-in/remove text effects; Added in effect to remove choice once made by lightswitch.
  * 20/10/2021: Modified HTML: Added the byline.
  * 20/10/2021: Modified Ink script to separate ink tag lists. 
  * 21-22/10/2021: Removed extraneous Ink tags from, and added comments to the Ink file.
  * 23-24/10/2021: Removed extraneous CSS selectors, and added comments. Also made a References HTML file. 
  * 24-26/10/2021: Figured out how to use the save/load/restart functionality from the original export for web file, and modified it for my own game. 
  * 26/10/2021: Decided against implementing individual user accounts as was way over the previous deadline! 

* **Stage H.**
  * 26-27/10/2021 (2 days): I added in other bits such as appearing/disappearing images, and neatened up the javascript code here & there. 
  * 31/10/2021 (<1 day): Testing! Self tested the game with different variables to ensure that the game worked with as many permutations as possible.  This didn't take too long as I was testing as I went along in previous stages.

* **Stage I.**
  * 31/10/2021 (<1 day): Neatened up the README.md document, organised the files and added the music to the game!
  * 01/11/2021 (<1day): Made the short video showcasing my finished project, uploaded and submitted the project to CS50x!
