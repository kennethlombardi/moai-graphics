local Input = {};
Input.Mouse = nil;
Input.Keyboard = nil;
Input.Android = nil;

Key = {};
Key["backspace"] = 8;
--Key["tab"] = 9;
--Key["enter"] = 13;
Key["shift"] = 16;
--Key["ctrl"] = 17;
--Key["alt"] = 18;
Key["CTRL+S"] = 19;--Key["pause"] = 19;
--Key["caps lock"] = 20
Key["esc"] = 27;
Key["SPACE"] = 32;
--Key["page up"] = 33;
--Key["page down"] = 34;
--Key["end"] = 35;
--Key["home"] = 36;
--Key["left arrow"] = 37;
--Key["up arrow"] = 38;
--Key["right arrow"] = 39;
--Key["down arrow"] = 40;
--Key["insert"] = 45;
--Key["delete"] = 46;
--Key["0"] = 48;
Key["1"] = 49;
Key["2"] = 50;
--Key["3"] = 51;
--Key["4"] = 52;
--Key["5"] = 53;
--Key["6"] = 54;
--Key["7"] = 55;
--Key["8"] = 56;
--Key["9"] = 57;
Key["a"] = 97;--65;
--Key["b"] = 66;
Key["c"] = 99;--67;
Key["d"] = 100;--68;
Key["e"] = 101;--69;
--Key["f"] = 70;
--Key["g"] = 71;
--Key["h"] = 72;
--Key["i"] = 73;
--Key["j"] = 74;
--Key["k"] = 75;
--Key["l"] = 76;
--Key["m"] = 77;
--Key["n"] = 78;
--Key["o"] = 79;
--Key["p"] = 80;
--Key["q"] = 81;
Key["r"] = 114;--82;
Key["s"] = 115;--83;
--Key["t"] = 84;
--Key["u"] = 85;
Key["v"] = 118 --86;
Key["w"] = 119;--87;
Key["x"] = 120;--88;
--Key["y"] = 89;
Key["z"] = 122;--90;
--Key["lwindows"] = 91; -- Left Windows Key
--Key["rwindows"] = 92; -- Right Windows Key
--Key["appkey"] = 93; -- Application key - located between the right Windows and Ctrl keys on most keyboards
 --Numpad numbers start
--Key["1n"] = 97;
--Key["2n"] = 98;
--Key["3n"] = 99;
--Key["4n"] = 100;
--Key["5n"] = 101;
--Key["6n"] = 102;
--Key["7n"] = 103;
--Key["8n"] = 104;
--Key["9n"] = 105;
--Key["*n"] = 106;
--Key["+n"] = 107;
--Key["-n"] = 109;
--Key[".n"] = 110;
--Key["/n"] = 111;
 --Numpad numbers end
--Key["f1"] = 112;
--Key["f2"] = 113;
--Key["f3"] = 114;
--Key["f4"] = 115;
--Key["f5"] = 116;
--Key["f6"] = 117;
--Key["f7"] = 118;
--Key["f8"] = 119;
--Key["f9"] = 120;
--Key["f10"] = 121;
--Key["f11"] = 122;
--Key["f12"] = 123;
--Key["numlock"] = 144;
--Key["scrolllock"] = 145;
--Key[";"] = 186;
--Key["="] = 187;
--Key[","] = 188;
--Key["-"] = 189;
--Key["."] = 190;
--Key["/"] = 191;
--Key["`"] = 192;
--Key["["] = 219;
--Key["\\"] = 220;
--Key["]" ] = 221;
--Key["'"] = 221;

Input.Key = Key;

if MOAIInputMgr.device.pointer then			
	Input.Mouse = require "MouseInput";
end
if MOAIInputMgr.device.keyboard then
	Input.Keyboard = require "KeyboardInput";
end

if MOAIInputMgr.device.touch then
	Input.Android = require "AndroidInput";		
end
-- MOUSE ANDROID COMBINE
function Input:isPressed()
  return Input:isButtonPressed(0) or Input:isScreenPressed(0);
end

function Input:isPausedTriggered()
	pos = Input:getWindowPos();
	return Input:isScreenTriggered(2) or (Input:isButtonTriggered(0) and pos.x > 1180 and pos.y > 620);
end

function Input:isReleased()
  return Input:isButtonReleased(0) or Input:isScreenReleased(0);
end

function Input:isTriggered()
  return Input:isButtonTriggered(0) or Input:isScreenTriggered(0);
end

function Input:getWindowPos()
  if Input.Android then
    return Input.Android.window;
  elseif Input.Mouse then
    return Input.Mouse.window;  
  end
end

function NormalizeVec(v)  
  local mag = v.x * v.x + v.y * v.y;
  mag = math.sqrt(mag);
  local newv = {x = 0, y = 0};
  if mag > .005 then  
    newv.x = v.x / mag;
    newv.y = v.y / mag;
  end
  return newv;
end

function Input:getMove()
  if Input.Android then
    return Input.Android.diffAccel;
  elseif Input.Mouse then
    return Input.Mouse.world;
  end
end

function Input:update(dt)
	if Input.Keyboard then
		Input.Keyboard:update(dt);
	end
	if Input.Mouse then
		Input.Mouse:update(dt);
	end
	if Input.Android then
		Input.Android:update(dt);		
	end
end

function Input:reCal()
	if Input.Android then
		Input.Android:reCal();
	end
end

function Input:isKeyPressed(k)
	if Input.Keyboard then
		return Input.Keyboard:isKeyPressed(k);
	end
	return false;
end

function Input:isButtonPressed(b)
	if Input.Mouse then
		return Input.Mouse:isKeyPressed(b);
	end
	return false;
end

function Input:isScreenPressed(s)
	if Input.Android then
		return Input.Android:isKeyPressed(s);
	end
end

function Input:isKeyTriggered(k)
	if Input.Keyboard then
		return Input.Keyboard:isKeyTriggered(k);
	end
	return false;
end

function Input:isButtonTriggered(b)
	if Input.Mouse then
		return Input.Mouse:isKeyTriggered(b);
	end
	return false;
end

function Input:isScreenTriggered(s)
	if Input.Android then
		return Input.Android:isKeyTriggered(s);
	end
	return false;
end

function Input:isKeyReleased(k)
	if Input.Keyboard then
		return Input.Keyboard:isKeyReleased(k);
	end
	return false;
end

function Input:isButtonReleased(b)
	if Input.Mouse then
		return Input.Mouse:isKeyReleased(b);
	end
	return false;
end

function Input:isScreenReleased(s)
	if Input.Android then
		return Input.Android:isKeyReleased(s);
	end
	return false;
end

function Input:isKeyDown(k)
	if Input.Keyboard then
		return Input.Keyboard:isKeyPressed(k) or Input.Keyboard:isKeyTriggered(k);
	end
end

function Input:isButtonDown(b)
	if Input.Mouse then
		return Input.Mouse:isKeyPressed(b) or Input.Mouse:isKeyTriggered(b);
	end
end

function Input:isScreenDown(s)
	if Input.Android then
		return Input.Android:isKeyPressed(s) or Input.Android:isKeyTriggered(s);
	end
end

return Input;
