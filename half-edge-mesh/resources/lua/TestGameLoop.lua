local done = false;

local function preInitialize()
	-- require managers to perform singleton initialization
	require("ConfigurationManager");
  	require("UserDataManager");
	require("MessageManager");
	require("SimulationManager");
	require("WindowManager");
	require("ResourceManager");
	require("LayerManager");
	--require("SceneManager");
	require("SoundManager");
	
 	print("PreInitialized");
end

local function initialize()
	require("SimulationManager"):setLeakTrackingEnabled(true);
	require("SimulationManager"):setHistogramEnabled(true);
	--require("SimulationManager"):setLuaAllocLogEnabled(true);

	-- simulation state
	MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
	MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0.5, 0.5, 0.5 )
	MOAIGfxDevice.setClearDepth(true);
	
	-- song
	--require("SoundManager"):play("mono16.wav", false);

    require("LayerManager"):createLayerFromFile("mainMenu.lua"); 

	require("MessageManager"):listen("QUIT", function() done = true; print("QUIT"); end);
  	print("Initialized");
  	require("MessageManager"):send("TEST");

    --createProp();
    --createText();
    --createSpeedLine();
end

local function preShutdown()
	--require("LayerManager"):getLayerByName("mainMenu.lua"):serializeToFile("mainMenuDiff.lua");
	--require("LayerManager"):serializeLayerToFile(require("LayerManager"):getLayerIndexByName("pickleFile1.lua"), "pickleFileDiff1.lua");
end

local function createProp()
    local properties = {}
    properties.scripts = {}
    properties.position = {x = 0, y = 0, z = 100}
    properties.shaderName = "shader";
    for j = 1, 1 do
        properties.type = "Sphere";
        properties.name = "Sphere";
        table.insert(properties.scripts,"obstacle.lua");
        properties.textureName = "rock.png";
        local newProp = require("Factory"):create("Sphere", properties);
        require("LayerManager"):getLayerByName("mainMenu.lua"):insertProp(newProp);
        newProp:destroy();
    end
end

local function createText()
    local properties = {};
    properties.scale = {x = 3000, y = 3000, z = 3000};
    properties.position = {x = math.random(-600, 600), y = math.random(-300, 300), z = 0};
    properties.scripts = {};
    properties.type = "TextBox";
    properties.name = "TextBox";    
    properties.string = "<c:00FF00>+2";
    properties.textSize = 48;
    properties.shaderName = "none";
    properties.rectangle = {x2 = 500, y2 = 0, x1 = 0, y1 = 100};
    local newProp = require("Factory"):create("TextBox", properties); 

    require("LayerManager"):getLayerByName("mainMenu.lua"):insertProp(newProp);
    --newProp:destroy();
end

local function createSpeedLine()
    properties = {};
    properties.scale = {x = 3, y = 3, z = 3};
    properties.position = {};
    local randx = math.random(600, 800);
    properties.position.z = -100;
    local angle = math.random(1, 360);
    properties.position.x = randx * math.cos(angle);
    properties.position.y = randx * math.sin(angle);
    properties.scripts = {};
    properties.rotation = {x = 0, y = 0, z = 0}
    properties.shaderName = "shader";

    properties.type = "PropCube";
    properties.name = "PropCube";
    table.insert(properties.scripts, "speedline.lua");
    properties.textureName = "whiteSquare.png";
    local newprop = require("Factory"):create("PropCube", properties); 
    require("LayerManager"):getLayerByName("mainMenu.lua"):insertProp(newprop);
    newprop:destroy();
end

local function shutdown()
	require("LayerManager"):shutdown();
	require("ResourceManager"):shutdown();
	require("WindowManager"):shutdown();
	require("SoundManager"):shutdown();
	--require("SceneManager"):shutdown();
	require("ShapesLibrary"):shutdown();
	require("ConfigurationManager"):shutdown();
	require("UserDataManager"):shutdown();

	--require("SimulationManager"):forceGarbageCollection();
	require("SimulationManager"):reportLeaks();
	--require("SimulationManager"):forceGarbageCollection();
	require("SimulationManager"):reportHistogram();

	require("SimulationManager"):shutdown();
end

local function update(dt)
	require("MessageManager"):update(dt);
	require("InputManager"):update(dt);
	require("LayerManager"):update(dt);
	--require("SceneManager"):update(dt);
	require("SoundManager"):update(dt);
	require("SimulationManager"):update(dt);

    if require("InputManager"):isKeyTriggered(require("InputManager").Key["esc"]) then
        require("MessageManager"):send("QUIT");
    end

    if require("InputManager"):isKeyTriggered(require("InputManager").Key["c"]) then
        require("LayerManager"):removeLayerByName("mainMenu.lua");
        require("LayerManager"):createLayerFromFile("mainMenu.lua"); 
        print('cleared')
    end

end

function gamesLoop ()
	preInitialize();
	initialize();

	while not done do
		update(require("SimulationManager"):getStep());
		coroutine.yield()
	end

	preShutdown();
	shutdown();
	os.exit();
end

return gamesLoop;