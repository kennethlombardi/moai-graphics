local function preInitialize()
    -- require managers to perform singleton initialization
    require("ConfigurationManager");
    require("UserDataManager");
    require("MessageManager");
    require("SimulationManager");
    require("WindowManager");
    require("ResourceManager");
    require("LayerManager");
    require("SceneManager");
    require("SoundManager");
    require("InputManager");
	require("GameVariables");
    print("PreInitialized");
end

local done = false;
local function onQuit(payload)
    done = true;
end

local function initialize()
    require("SimulationManager"):setLeakTrackingEnabled(true);
    require("SimulationManager"):setHistogramEnabled(true);
    -- require("SceneManager"):addSceneFromFile('assignment5-OctreeScene.lua');
    -- require("SceneManager"):addSceneFromFile('assignment2-BoundingVolumesScene.lua');
    require("SceneManager"):addSceneFromFile('cs350TestScene.lua');

    -- simulation state
    -- MOAIGfxDevice.setClearDepth(true);

    require("MessageManager"):listen("QUIT", onQuit);
	require("MessageManager"):send("GAME_INITIALIZED")

    print("Initialized");
end

local function preShutdown()
    --require("LayerManager"):getLayerByName("pickleFile0.lua"):serializeToFile("pickleFileDiff0.lua");
    --require("LayerManager"):serializeLayerToFile(require("LayerManager"):getLayerIndexByName("pickleFile1.lua"), "pickleFileDiff1.lua");
end

local function shutdown()
    require("LayerManager"):shutdown();
    require("ResourceManager"):shutdown();
    require("WindowManager"):shutdown();
    require("SoundManager"):shutdown();
    require("SceneManager"):shutdown();
    require("ShapesLibrary"):shutdown();
    require("GameVariables"):shutdown();
    require("ConfigurationManager"):shutdown();
    require("UserDataManager"):shutdown();

    require("SimulationManager"):forceGarbageCollection();
    require("SimulationManager"):reportLeaks();
    require("SimulationManager"):forceGarbageCollection();
    require("SimulationManager"):reportHistogram();

    require("SimulationManager"):shutdown();
end

local function update(dt)
    require("MessageManager"):update(dt);
    require("InputManager"):update(dt);
    require("LayerManager"):update(dt);
    require("SceneManager"):update(dt);
    require("SoundManager"):update(dt);
    require("SimulationManager"):update(dt);
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
