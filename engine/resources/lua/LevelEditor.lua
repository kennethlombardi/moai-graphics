local Editor = {};
local Input = require "InputManager"
local Factory = require "Factory"


local newObjList = {};
local newObjListCount = 1;
local state = 1; --1 no object highlighted, control camera; 2 object created, control object; 
local shift = 1;
function Editor:Update(layer)	
	local newPosition;
	if Input:IsKeyTriggered(Input.Key["CTRL+S"]) then
		layer:serializeToFile("NewFile.lua");
	end
	if Input:IsKeyTriggered(Input.Key["c"]) then
		if shift > 1 then
			shift = shift - 1;
		end
	end
	if Input:IsKeyTriggered(Input.Key["v"]) then
		shift = shift + 1;
	end
	if Input:IsKeyPressed(Input.Key["1"]) then
		state = 1;
	end
	if Input:IsKeyPressed(Input.Key["2"]) then
		state = 2;
	end
	if state == 1 then			
		newPosition = layer:getLoc();		
		local dx = 10 * shift;
		if Input:IsKeyPressed(Input.Key["a"]) then
			newPosition.x = newPosition.x - dx;			
		end
		if Input:IsKeyPressed(Input.Key["d"]) then
			newPosition.x = newPosition.x + dx;
		end
		if Input:IsKeyPressed(Input.Key["s"]) then
			newPosition.y = newPosition.y - dx;			
		end
		if Input:IsKeyPressed(Input.Key["w"]) then
			newPosition.y = newPosition.y + dx;
		end
		if Input:IsKeyPressed(Input.Key["x"]) then
			newPosition.z = newPosition.z - dx;			
		end
		if Input:IsKeyPressed(Input.Key["z"]) then
			newPosition.z = newPosition.z + dx;
		end
		layer:setLoc(newPosition.x, newPosition.y, newPosition.z);	-- globally access the layer from init		
	else
		if Input:IsButtonTriggered(0) then			
			local properties = {};
			properties.type = "PropCube";
			properties.name = "NewProp";
			local position = layer:getLoc();
			position.z = position.z - 500;
			properties.position = position;
			
			newprop = Factory:create("PropCube", properties);
			layer:insertPropPersistent(newprop);
			newObjList[newObjListCount] = newprop;
			newObjListCount = newObjListCount + 1;
			layer:insertProp(newprop);
		end
		if newObjListCount > 1 then
			newPosition = newObjList[newObjListCount-1].position;
			local dx = 10 * shift;
			if Input:IsKeyPressed(Input.Key["a"]) then
				newPosition.x = newPosition.x - dx;			
			end
			if Input:IsKeyPressed(Input.Key["d"]) then
				newPosition.x = newPosition.x + dx;
			end
			if Input:IsKeyPressed(Input.Key["s"]) then
				newPosition.y = newPosition.y - dx;			
			end
			if Input:IsKeyPressed(Input.Key["w"]) then
				newPosition.y = newPosition.y + dx;
			end
			if Input:IsKeyPressed(Input.Key["x"]) then
				newPosition.z = newPosition.z - dx;			
			end
			if Input:IsKeyPressed(Input.Key["z"]) then
				newPosition.z = newPosition.z + dx;
			end
			newObjList[newObjListCount-1]:setLoc(newPosition.x, newPosition.y, newPosition.z);	-- globally access the layer from init				
			--if Input:IsKeyTriggered(Input.Key["backspace"]) then
--				newObjListCount = newObjListCount - 1;
--				layer:removeProp(newObjList[newObjListCount]);
--				newObjList[newObjListCount] = nil;
--			end
		end
	end	
end

return Editor;