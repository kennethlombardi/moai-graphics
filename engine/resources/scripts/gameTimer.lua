local Script = {
	name = "gameTimer.lua",
};

local lastTime = 0;
local triggeredOutOfTime = false;
local greenText = 0;
local redText = 0;
local flash = .3;
function Script.update(object, dt)  
	gameVariables = require("GameVariables");
	gameVariables:add("Timer", -dt);  
  currTime = gameVariables:get("Timer");
	if ( currTime < 0) then
    if triggeredOutOfTime == false then
      object:setText(string.format('Time: <c:FF0000>%d', currTime));  
      require("SoundManager"):stop("beep.wav");
      require("SoundManager"):play("buzzer.wav", false);
		  require("MessageManager"):send("RAN_OUT_OF_TIME");
      object:replaceAllScripts(require("Factory"):createFromFile("Script", ""));
    end
    return;
	end
  if lastTime < currTime then
    greenText = flash;
  elseif lastTime - 2 > currTime then
    redText = flash;
  elseif currTime < 5 and currTime > .2 and redText <= -currTime * .1 then
    redText = .1*currTime;
    require("SoundManager"):play("beep.wav", false);    
  end
    
  timetext = "Time: ";
  color = "<c:FFFFFF>";
  if greenText > 0 then
    color = "<c:00FF00>";
  elseif redText > 0 then
    color = "<c:FF0000>";
  end
  object:setText(string.format('%s%s%d', timetext, color, currTime));
  greenText = greenText - dt;
  redText = redText - dt;
  lastTime = currTime;
  -- local Input = require("InputManager")
  -- object:setText(string.format('x = %f y = %f z = %f', Input.Android.diffAccel.x, Input.Android.diffAccel.y, Input.Android.diffAccel.z));
end

return Script;