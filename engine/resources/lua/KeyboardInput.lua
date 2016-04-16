
local Keyboard = {};
Keyboard.key = {};
for i = 0, 255, 1 do
	Keyboard.key[i] = {false,false,false};
end

--3 = prev state, 2 = curr state, 1 = changed

local function PushBack(key, pressed)	
	Keyboard.key[key][1] = true;	
	Keyboard.key[key][3] = Keyboard.key[key][2];
	Keyboard.key[key][2] = pressed;
end

local function SetKey(key, pressed)
	PushBack(key, pressed);
end


local function PressKey(key)
	SetKey(key, true);
end

local function RaiseKey(key)
	SetKey(key, false);
end


function Keyboard:isKeyPressed(key)	
	if self.key[key][2] == true and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Keyboard:isKeyReleased(key)
	if self.key[key][2] == false and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Keyboard:isKeyTriggered(key)	
	if self.key[key][2] == true and self.key[key][3] == false then
		return true;
	end
	return false;
end

function Keyboard:update(dt)
	for i =0, 255, 1 do
		if Keyboard.key[i][1] == false then
			PushBack(i, Keyboard.key[i][2]);
		end
		Keyboard.key[i][1] = false;
	end
end

local keyCallback = function ( key, down )
	if down then 
		PressKey(key);
		--print(key);
	else		
		RaiseKey(key);
	end
end
MOAIInputMgr.device.keyboard:setCallback ( keyCallback )

return Keyboard;