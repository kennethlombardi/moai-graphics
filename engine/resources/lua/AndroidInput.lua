local Android = {};
Android.key = {};
Android.window = {x = 0, y = 0;};			--place of last tap in window space
Android.world = {x = 0; y = 0;};			--place of last tap in world space
Android.accel = {x = 0; y = 0; z = 0;};		--current state of gyro
Android.baseAccel = {x = 0; y = 0; z = 0;};	--base state of gyro (used for calibration)
Android.diffAccel = {x = 0; y = 0; z = 0;}; -- diff between accel - base
Android.key[0] = {false, false, false};
Android.key[1] = {false, false, false};
Android.key[2] = {false, false, false};

local function PushBack(key, pressed)
	Android.key[key][1] = true;
	Android.key[key][3] = Android.key[key][2];
	Android.key[key][2] = pressed;	
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

function Android:isKeyPressed(key)	
	if self.key[key][2] == true and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Android:isKeyReleased(key)	
	if self.key[key][2] == false and self.key[key][3] == true then
		return true;
	end
	return false;
end

function Android:isKeyTriggered(key)
	if self.key[key][2] == true and self.key[key][3] == false then
		return true;
	end
	return false;
end

function Android:update(dt)
	for i = 0, 2, 1 do
		if Android.key[i][1] == false then
			PushBack(i, Android.key[i][2]);
		end
		Android.key[i][1] = false;	
	end	
	--need to throw in calibration here
	--if tap is in top-left corner
	--calibrate, simple enough, no?
--	if Android:isKeyTriggered(1) then
--		Android:reCal();
--	end	
	Android.diffAccel.x = Android.accel.x - Android.baseAccel.x;
	Android.diffAccel.y = Android.accel.y - Android.baseAccel.y;
	Android.diffAccel.z = Android.accel.z - Android.baseAccel.z;
  local epsilon = .0001;
  if math.abs(Android.diffAccel.x) <= epsilon then
    Android.diffAccel.x = 0;
  end
  if math.abs(Android.diffAccel.y) <= epsilon then
    Android.diffAccel.y = 0;    
  end
  if math.abs(Android.diffAccel.z) <= epsilon then
    Android.diffAccel.z = 0;
  end
end

function Android:reCal() --recalibrate
	Android.baseAccel.x = Android.accel.x;
	Android.baseAccel.y = Android.accel.y;
	Android.baseAccel.z = Android.accel.z;
end

function Android:getWorldTap(layer)
	self.world.x, self.world.y = (layer:wndToWorld(self.window.x, self.window.y));
end

MOAIInputMgr.device.touch:setCallback (					
	function ( eventType, idx, x, y, tapCount )						
		if eventType == MOAITouchSensor.TOUCH_DOWN or eventType == MOAITouchSensor.TOUCH_MOVE then			
			--wx,wy = (layer:wndToWorld(x,y))
			Android.window.x = x;
			Android.window.y = y;	
			if x < 100 and y < 100 then
				PressKey(1);
			elseif x > 1000 and y > 550 then
				PressKey(2);
			else
				PressKey(0);		
			end
		else			
      RaiseKey(2);
			RaiseKey(1);			
			RaiseKey(0);			
		end
	end
)

 MOAIInputMgr.device.level:setCallback(  --gyro
	function(x, y, z)
	  Android.accel.x = y;
	  Android.accel.y = -x;
	  Android.accel.z = z;
	end
)

return Android;
