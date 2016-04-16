
local Mouse;
local Keyboard;
local layerManager = require "LayerManager"
local windowManager = require "WindowManager";
local Factory = require "Factory"
	layer1 = Factory:createFromFile("Layer", "pickleFile.lua");
MOAIGfxDevice.setClearDepth ( true );
local camera;

local function Initialize()

	local BoxManager = require "BoxMesh";
	local mesh = BoxManager.makeCube(128, '../textures/moai.png')
	local prop = MOAIProp.new()
    prop:setDeck(mesh)
    prop:setLoc(0, 0)
    --prop:moveRot(0, 2160, 0, 120)
	--prop:setPiv(100,0,0);
    prop:setShader ( MOAIShaderMgr.getShader ( MOAIShaderMgr.MESH_SHADER ))
    prop:setCullMode ( MOAIProp.CULL_BACK )
    layer1:insertProp ( prop )
	camera = MOAICamera.new()
	camera:setLoc(0,100, camera:getFocalLength(windowManager.screenWidth))
	layer1:setCamera(camera)
	print("Initialized");
	if MOAIInputMgr.device.pointer then			
		Mouse = require "MouseInput";
	end
	if MOAIInputMgr.device.keyboard then
		Keyboard = require "KeyboardInput";
	end
end



local done = false
local function gamesLoop()
	Initialize();

	while not done do
		Mouse.Update(layer1, camera);
		for i = 1, 255, 1 do
			if Keyboard.IsKeyTriggered(i) then
				print(i);
			end
		end
		coroutine.yield()
	end
end

return gamesLoop;
