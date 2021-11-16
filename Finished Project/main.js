                        //------ VARIABLES ------\\

// Stores the text from the Ink story as a list (see Inky documentation).
var story = new inkjs.Story(storyContent);

// Empty strings to store the story state and body element classes.
var savePoint = "";
var currentClasses = "";

// Variables to select various elements on the HTML DOM
var storyContainer = document.querySelector('#story');
var Light = document.querySelector("#lightsOut");
var bg = document.querySelector("body");
var navbar = document.querySelector("nav");

// Loads saved game state (including body element classes, and state of the game-control buttons), if a saved game stored in browser memory.
var hasSave = loadSavePoint();
setupButtons(hasSave);

// Sets initial save state & classes states i.e before story starts.
savePoint = story.state.toJson();
currentClasses = bg.className;

//------ MAIN FUNCTION TO START AND CONTINUE THE STORY ------\\
function continueStory() {

    // Delay variable for showing story & choice text.
    var delay = 0.0;

    // Checks if there are more items in the story object.
    while(story.canContinue) {

      // Generates next paragraph (from the next item) in the story object.
      var paragraphText = story.Continue();

      // Creates a HTML <p> element, adds the next paragraph and the .paragraph class to the <p> element.
      var paragraphElement = document.createElement('p');
      paragraphElement.classList.add("paragraph");
      paragraphElement.innerHTML = paragraphText;
      // Appends the <p> element to the appropriate <div> tag in the HTML DOM (storyContainer).
      storyContainer.appendChild(paragraphElement);

      // Delays when the paragraph <p> element gets displayed.
      showAfter(delay, paragraphElement);
      delay += 500.0;

      // Selects all of the choices in the story object and creates HTML choices for each of them (where story.currentChoices produces an object similar-ish to a list of dictionaries).
      story.currentChoices.forEach(function(choice) {

        // Creates a HTML <p> element, adds the .choice class to that element.
        var choiceParagraphElement = document.createElement('p');
        choiceParagraphElement.classList.add("choice");
        // Adds the next choice text wrapped in an anchor element to the <p> element and appends the <p> element to the appropriate <div> tag in the HTML DOM (storyContainer).
        choiceParagraphElement.innerHTML = `<a href='#'>${choice.text}</a>`;
        storyContainer.appendChild(choiceParagraphElement);

        // Delays when the choice <p> element gets displayed.
        showAfter(delay, choiceParagraphElement);
        delay += 500.0;

        // Listener for when a choice is clicked
        var choiceAnchorEl = choiceParagraphElement.querySelectorAll("a")[0];
        choiceAnchorEl.addEventListener("click", function(event) {

            // Prevents <a> from being followed (scrolls to top of page if was followed)
            event.preventDefault();

            // Remove all existing text, choices and images prior to that choice
            removeAll("img");
            removeAll("p.choice");
            removeAll("p.paragraph");

            // Selects the index of the choice that was clicked on, which tells the story where to go next.
            story.ChooseChoiceIndex(choice.index);

            // Updates stored story state and body element classes state after a choice has been made.
            savePoint = story.state.toJson();
            currentClasses = bg.className;

            // Loop
            continueStory();
        });

      });


      // Changes the <body> appearance (to give the illusion of lights turning on/off) based off certain tags in the ink story.
      game_Toggle_Lights();
      // Updates the stored body element class to reflect the change from the above function.
      currentClasses = bg.className;

      // Converts the 0-index tag from an object to a string.
      var tag = String(story.currentTags[0]);
      // Adds a picture to the story if the tag contains "/". (The tag in ink for images is just the file path relative to this .js file.)
      if(tag.includes("/")){
        // Creates img element, and makes the stringified tag the source.
        var imgElement = document.createElement("img");
        imgElement.src = tag;

        // Simplifies the name of the tag, and creates alt & title text for the picture. Also adjusts size of the image.
        var img_name = (((tag.slice(7)).replaceAll("_", " ")).replace(".jpg","")).replace(".png","");
        imgElement.alt = "A picture of "+ img_name;
        imgElement.title = "A picture of "+ img_name;
        imgElement.style.width = "300px";

        // Appends the image to the story container div element.
        storyContainer.appendChild(imgElement);

        // Shows image after a delay.
        showAfter(delay, imgElement);
        delay += 300.0;
      }

      // When the current 0-index tag is "tunes" plays music if player chooses to, and stops at certain points.
      if(tag =="tunes"){
        // Creates audio element in HTML file & plays it when tunes variable in story is true (i.e when player chooses tunes).
        if(story.variablesState["tunes"] == 1){
          // Creates HTML audio element, sets specific attributes and appends it to the main story.
          var tunesElement = document.createElement("audio");
          tunesElement.id = "tunes";
          tunesElement.src = "Sound/Urban_Lifestyle.mp3";
          storyContainer.appendChild(tunesElement);

          // Plays the HTML audio element.
          tunesElement.volume = 0.2;
          tunesElement.play();
        }
        // Pauses the audio element & removes its source when the tunes variable in story is false.
        else if(story.variablesState["tunes"] == 0){
          // Selects HTML audio element, pauses the audio and removes the source.
          let tunes = document.getElementById("tunes");
          tunes.pause();
          tunes.src = "";
        }
      }

      // Starts "flickering lights" effect when the tag "#flicker" is at index 1 of current tags in the ink story.
      var off_delay = 0.0;
      var on_delay = 0.0;
      if(story.currentTags[1] == "flicker"){
        flicker(off_delay, on_delay);
      }
    }
  }

// Starts the story!
continueStory();


                        //------ Helper functions for displaying and removing elements (both taken from the original ink main.js file) ------\\                  

// Shows given HTMl elements after a delay
function showAfter(delay, el) {
  el.classList.add("hide");
  setTimeout(function() { el.classList.remove("hide") }, delay);
}

// Removes all instances of a given HTML selector
function removeAll(selector){
    var allElements = storyContainer.querySelectorAll(selector);
    for(var i = 0; i<allElements.length; i++) {
        var el = allElements[i];
        el.parentNode.removeChild(el);
    }
}

                        //------ LIGHTSWITCH EFFECT HELPER FUNCTIONS AND LISTENER FUNCTIONS ------\\
//------ Helper functions to change the "lights" based off current tags in the ink story (game-input)------\\

// Toggles the "lights" based off of the current tags in the ink story.
function game_Toggle_Lights(){
  // Stores values for the current location and the name of the next tag.
  var location = story.currentTags[0];
  var nextTag = story.currentTags[1];

  // Toggles lights ON for the current location if the corresponding light is ON in the ink story (via the global variable of the same name as the location)
  if(location && story.variablesState[location] == 1){

    // Changes the appearance & functionality of the light icon and the appearance of the <body> element.
    Light.id = "lightsOut";
    Light.getElementsByTagName("img")[0].alt = "Lights Off";
    Light.getElementsByTagName("img")[0].title = "Lights Off";
    bg.className = location;
    // Toggles the appearance of the navbar menu icon dependent upon the current location.
    if(location == "in_kitchen" || location == "in_bathroom"){
      navbar.classList.toggle("navbar-dark", false);
      navbar.classList.toggle("navbar-light", true);
    }
    else{
      navbar.classList.toggle("navbar-dark", true);
      navbar.classList.toggle("navbar-light", false);
    }

    // Toggles the current location light off while moving between rooms (based upon value of the next tag).
    // Solves the issue of one lights on class masking another while moving between rooms.
    if(nextTag == "next_room"){
      bg.classList.toggle(location, false);
    }
  }
  // Toggles lights OFF for the current location if the light is OFF in the ink story (via the global variable of the same name as the location)
  else if(location && story.variablesState[location] == 0){
    // Changes the appearance & functionality of the light icon and the appearance of the <body> element and navbar.
    Light.id = "lightsOn";
    Light.getElementsByTagName("img")[0].alt = "Lights On";
    Light.getElementsByTagName("img")[0].title = "Lights On";

    navbar.classList.toggle("navbar-dark", true);
    navbar.classList.toggle("navbar-light", false);
    bg.className = "any_light_off";

    // Prevents the "any_light_off" class from masking other classes while moving between locations.
    if(nextTag == "next_room"){
      bg.classList.toggle("any_light_off", false);
    }
  }
}

// "Flickering lights" effect.
function flicker(off_delay, on_delay){
  // Determines which "lights" should flicker and how long for
  var location = story.currentTags[0];
  var duration = story.currentTags[2];

  // Changes delay for when the "lights" turn off or on, based on the current variable state of the "lights" in the ink story (i.e true=on or false=off)
  if(story.variablesState[location] == true){
    off_delay = 2000.0;
    on_delay = 2500.0;
  }
  else if(story.variablesState[location] == false){
    off_delay = 2500.0;
    on_delay = 2000.0;
  }

  // Changes the length of the lights on/off delay time based off the duration specified in the tags
  off_delay += (off_delay*parseFloat(duration));
  on_delay += (on_delay*parseFloat(duration));


  // TWO defined setTimeout functions that flicker the lights on/off (order depending on the value of on_delay/off_delay).
  // BOTH setTimeout functions change:
  // - HTML background & navbar button theme;
  // - the id/alt/title of the lightswitch button (and therefore its appearance and functionality as well);
  // - and the value of the corresponding light variable in the ink story itself!
  
  // setTimeout Flickers lights OFF.
  setTimeout(function(){
    bg.className = "any_light_off";
    navbar.classList.toggle("navbar-dark", true);
    navbar.classList.toggle("navbar-light", false);

    Light.id = "lightsOn";
    Light.getElementsByTagName("img")[0].alt = "Lights On";
    Light.getElementsByTagName("img")[0].title = "Lights On";

    story.variablesState[location] = false;
  }, off_delay);

  // setTimeout Flickers lights ON.
  setTimeout(function(){
    bg.className = location;

    if(location == "in_kitchen" || location == "in_bathroom"){
      navbar.classList.toggle("navbar-dark", false);
      navbar.classList.toggle("navbar-light", true);
    }
    else{
      navbar.classList.toggle("navbar-dark", true);
      navbar.classList.toggle("navbar-light", false);
    }

    Light.id = "lightsOut";
    Light.getElementsByTagName("img")[0].alt = "Lights Off";
    Light.getElementsByTagName("img")[0].title = "Lights Off";

    story.variablesState[location] = true;
  }, on_delay);


}


//------ Helper functions for Lightswitch function (user input)------\\

// To give the illusion of lights being turned OFF
function user_Toggle_Lights_OFF(){
  // Stores the current location as given by the current story tags
  var location = story.currentTags[0];

  // Changes the appearance of the <body> element, the navbar, and also changes the corresponding variable in the ink story
  bg.className = "any_light_off";
  navbar.classList.toggle("navbar-dark", true);
  navbar.classList.toggle("navbar-light", false);

  story.variablesState[location] = false;
}

// To give the illusion of lights being turned ON
function user_Toggle_Lights_ON(){
  // Stores the current location as given by the current story tags
  var location = story.currentTags[0];

  // Changes the appearance of the <body> element, the navbar, and also changes the corresponding variable in the ink story
  bg.className = location;
  story.variablesState[location] = true;

  // Changes appearance of the navbar dependent upon the location.
  if(location == "in_kitchen" || location == "in_bathroom"){
    navbar.classList.toggle("navbar-dark", false);
    navbar.classList.toggle("navbar-light", true);
  }
  else{
    navbar.classList.toggle("navbar-dark", true);
    navbar.classList.toggle("navbar-light", false);
  }
}


//------ Main lightswitch eventListener function (user-controlled) ------\\
// Main lightswitch function. Changes the appearance of the page, variables in the story, and even progresses the story based off user input.
Light.addEventListener("click", function(event) {

  // Turns "lights" OFF
  if (Light.id == "lightsOut"){
    user_Toggle_Lights_OFF();

    // Changes the id, alt and title attributes
    Light.id = "lightsOn";
    Light.getElementsByTagName("img")[0].alt = "Lights On";
    Light.getElementsByTagName("img")[0].title = "Lights On";

    // Progresses the story if the current tag calls for it.
    if(story.currentTags[1] == "lights_OFF_please"){
      story.ChooseChoiceIndex(0);
      removeAll("p.choice");
      removeAll("p.paragraph");
      currentClasses = bg.className;
      continueStory();
    }
  }

  // Turns "lights" ON
  else if (Light.id == "lightsOn"){
    user_Toggle_Lights_ON();

    // Changes the id, alt and title attributes
    Light.id = "lightsOut";
    Light.getElementsByTagName("img")[0].alt = "Lights Off";
    Light.getElementsByTagName("img")[0].title = "Lights Off";

    // Progresses the story if the current tag calls for it.
    if (story.currentTags[1] == "lights_ON_please"){
      story.ChooseChoiceIndex(0);
      removeAll("p.choice");
      removeAll("p.paragraph");
      currentClasses = bg.className;
      continueStory();
    }
  }
});



                                                //------ GAME CONTROL HELPER FUNCTIONS AND LISTENER FUNCTIONS ------\\
                        //------(All taken from the original ink main.js file and adapted to include state of body element classes)------\\
// Restarts the game.
function restart() {

  // Resets the story state, updates the stored story state in the string variable and in the browser local storage as well.
  story.ResetState();
  savePoint = story.state.toJson();
  window.localStorage.setItem('save-state', savePoint);

  // Empties the string variable where classes is stored, updates the body elements class and the body element class state stored in the local browser storage.
  currentClasses = "";
  bg.className = currentClasses;
  window.localStorage.setItem('class-state', currentClasses);

  // Continues story loop
  continueStory();
}

// Loads save & class state stored in browser memory (if exists in browser memory).
function loadSavePoint() {
  // Safe way of loading.
  try {
      // Looks in browser memory for stored save state of story or class state of body element.
      let savedState = window.localStorage.getItem('save-state');
      let loadClasses = window.localStorage.getItem('class-state');
      // Updates story state and body element class with those saved in the browser local storage.
      if (savedState) {
          story.state.LoadJson(savedState);
          currentClasses = loadClasses;
          bg.className = loadClasses;
          return true;
      }
  }
  // Exception if error (i.e unable to load save)
  catch (e) {
      console.debug("Couldn't load save state");
  }
  return false;
}

// Sets up the restart/save/load buttons upon opening the game.
function setupButtons(hasSave){
  // Restarts the story upon clicking the restart button. - Listener function.
  let rewindEl = document.getElementById("rewind");
  if (rewindEl) rewindEl.addEventListener("click", function(event) {
      // Removes all paragraphs generated by the story.
      removeAll("p");
      removeAll("img");
      // Restarts the story. See function definition lines ~244 onwards.
      restart();
  });

  // Saves the current story state (including body element class) upon clicking save button. - Listener function.
  let saveEl = document.getElementById("save");
  if (saveEl) saveEl.addEventListener("click", function(event) {
      // Safe way of attempting a save.
      try {
          // Saves the story state and body element class state at that time, and disables the load button.
          window.localStorage.setItem('save-state', savePoint);
          window.localStorage.setItem('class-state', currentClasses);
          document.getElementById("reload").removeAttribute("disabled");
      }
      // Exception if error (i.e unable to save)
      catch (e) {
          console.warn("Couldn't save state");
      }

  });

  // Loads the saved story state and body class stored in the local browser storage. - Listener function.
  let reloadEl = document.getElementById("reload");
  // Disables the load button if there is no saved story state in the browser memory.
  if (!hasSave) {
      reloadEl.setAttribute("disabled", "disabled");
  }
  reloadEl.addEventListener("click", function(event) {
      // Returns if load button is disabled.
      if (reloadEl.getAttribute("disabled"))
          return;

      // Removes all paragraphs and images generated by the story.
      removeAll("p");
      removeAll("img");

      // Safe way of loading.
      try {
          // Retrieves saved story state and body element class from the browser local storage.
          let savedState = window.localStorage.getItem('save-state');
          let loadClasses = window.localStorage.getItem('class-state');

          // Updates story state and body element class with those saved in the browser local storage.
          if (savedState){
            story.state.LoadJson(savedState);
            currentClasses = loadClasses;
            bg.className = loadClasses;
          }
      }
      // Exception if error (i.e unable to load)
      catch (e) {
          console.debug("Couldn't load save state");
      }

      // Loop the story!
      continueStory();
  });
}