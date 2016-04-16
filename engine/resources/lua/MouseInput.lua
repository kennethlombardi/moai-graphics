local Mouse = {};
Mouse.window = {x = 0, y = 0};
Mouse.world = {x = 0, y = 0};
Mouse.velX = 0;
Mouse.velY = 0;
Mouse.key = {};
Mouse.key[0] = {false,false,false}
Mouse.key[1] = {false, false, false}

local function PushBack(key, pressed)
	Mouse.key[key][1] = true;
	Mouse.key[key][3] = Mouse.key[key][2];
	Mouse.key[key][2] = pressed;	
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

function Mouse:isKeyPressed(key)	
	if self.key[key][2] == true and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Mouse:isKeyReleased(key)	
	if self.key[key][2] == false and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Mouse:isKeyTriggered(key)
	if self.key[key][2] == true and self.key[key][3] == false then
		return true;
	end
	return false;
end

function Mouse:update(dt)
	for i = 0, 1, 1 do
		if Mouse.key[i][1] == false then
			PushBack(i, Mouse.key[i][2]);
		end
		Mouse.key[i][1] = false;	
	end	
  Mouse:setWorldPos();
end


MOAIInputMgr.device.pointer:setCallback(
	function()		
		local lastX = Mouse.window.x;
		local lastY = Mouse.window.y;	
		Mouse.window.x, Mouse.window.y = MOAIInputMgr.device.pointer:getLoc();
		Mouse.velX = Mouse.window.x - lastX;
		Mouse.velY = Mouse.window.y - lastY;
	end
)	

MOAIInputMgr.device.mouseLeft:setCallback(
	function(isMouseDown)		
		if(isMouseDown) then
			PressKey(0);		
		else
			RaiseKey(0);
		end
	end
)
MOAIInputMgr.device.mouseRight:setCallback(

	function(isMouseDown)		
		if(isMouseDown) then
			PressKey(1);
		else
			RaiseKey(1);
		end		
		
	end
)

function Mouse:setWorldPos()  
  Mouse.world.x = Mouse.window.x - require("WindowManager").screenWidth/2;  
  Mouse.world.y = (Mouse.window.y * (-1)) + require("WindowManager").screenHeight/2;
  local epsilon = 30;
  if math.abs(Mouse.world.x) < epsilon then
    Mouse.world.x = 0;
  end
  if math.abs(Mouse.world.y) < epsilon then
    Mouse.world.y = 0;
  end
  Mouse.world.x = Mouse.world.x / 640;
  Mouse.world.y = Mouse.world.y / 360;
end


return Mouse;
