// THIS SCRIPT USED IN "References.html" ONLY
// Variables to select various elements on the HTML DOM
var Light = document.querySelector("#lightsOut");
var bg = document.querySelector("body");

                        //------ LIGHTSWITCH EFFECT SIMPLIFIED LISTENER FUNCTION ------\\
//------ Main lightswitch eventListener function (user-controlled) ------\\
Light.addEventListener("click", function(event) {
  // Turns "lights" OFF and changes the id, alt and title attribute
  if (Light.id=="lightsOut"){
    bg.className="any_light_off";
    Light.id = "lightsOn";
    Light.getElementsByTagName("img").alt = "Lights On";
    Light.getElementsByTagName("img").title = "Lights On";
  }

  // Turns "lights" ON and changes the id, alt and title attribute
  else if (Light.id=="lightsOn"){
    bg.className = "in_study";
    Light.id = "lightsOut";
    Light.getElementsByTagName("img").alt = "Lights Off";
    Light.getElementsByTagName("img").title = "Lights Off";
  }
});