local Scene = {}

local MessageManager = require("MessageManager");
local LayerManager = require("LayerManager");
local Factory = require("Factory");
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables");
GameVariables:set("HighScore", UserDataManager:get("highScore"));

function Scene:update(dt)
    if require("InputManager"):isKeyTriggered(require("InputManager").Key["esc"]) then
        MessageManager:send("QUIT");
    end
end

function Scene:free()
    MessageManager = nil;
    LayerManager = nil;
    Factory = nil;
    GameVariables = nil; 
end

function Scene:enter()

end

function Scene:exit()
    
end

function Scene.onAddTimer(pos)
	properties = {};
	properties.scale = {x = 3000, y = 3000, z = 3000};
	properties.position = {};
	properties.position.x = pos.x;
	properties.position.y = pos.y;
	properties.position.z = pos.z;
	properties.scripts = {"timeToLive.lua"};
	properties.type = "TextBox";
	properties.name = "TextBox";    
	properties.string = "<c:00FF00>+2";
	properties.textSize = 48;
	properties.shaderName = "none";
	properties.rectangle = {x2 = 500, y2 = 0, x1 = 0, y1 = 100};
	local newprop = require("Factory"):create("TextBox", properties); 

	LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
end

function Scene.onCheckPoint(pos)
	local properties = {};
	properties.scale = {x = 3000, y = 3000, z = 3000};
	properties.position = {};
	properties.position.x = pos.x;
	properties.position.y = pos.y;
	properties.position.z = pos.z-3000;
	properties.scripts = {"timeToLive.lua"};
	properties.type = "TextBox";
	properties.name = "TextBox";    
	--checkpoint = "<c:FF0000>C<c:FF00DD>H<c:CC00FF>E<c:5500FF>C<c:00A0FF>K<c:00FFFF>P<c:00FF00>O<c:A0FF00>I<c:FFFF00>N<c:FFA000>T";  
	local checkpoint = "CHECKPOINT";
	local distance = string.format('<c:FFFFFF>%d km traveled!', -pos.z);
	properties.string = string.format('%s\n%s',checkpoint, distance);
	properties.textSize = 56;
	properties.shaderName = "none";
	properties.justification = "center_justify";
	properties.rectangle = {x2 = 500, y2 = 0, x1 = -500, y1 = -300};
	local newprop = require("Factory"):create("TextBox", properties); 

	LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
end

function Scene.onClickedCreditsButton(payload)
    local pauseLayer = LayerManager:getLayerByName("pause.lua");
    if pauseLayer ~= nil then
        pauseLayer:setVisible(false);
        pauseLayer:pause();
    end
    LayerManager:createLayerFromFile("credits.lua");
end

function Scene.onClickedCreditsBackButton(payload)
    print("Clicked credits layer back button")
end

function Scene.onClickedPauseButton(payload)
    LayerManager:pauseAllLayers(true);
    LayerManager:createLayerFromFile("pause.lua");
end

function Scene.onClickedPlayButton(payload)
	print("Clicked play button");	
	require("SoundManager"):play("woosh.wav", false);
	LayerManager:getLayerByName("mainMenu.lua"):replaceAllScripts(Factory:createFromFile("Script", "titleLayerTransitionOut.lua"));
	LayerManager:getLayerByName("starfield.lua"):replaceAllScripts(Factory:createFromFile("Script", "starfieldLayerTransitionOut.lua"));
end

function Scene.onClickedQuitButton(payload)
    print("Clicked quit button");
    MessageManager:send("QUIT");
end

function Scene.onClickedResumeButton(payload)
    print("Clicked resume button");
    LayerManager:pauseAllLayers(false);
end

function Scene.onClickedRetryButton(payload)
	print("Clicked retry button");	
end

function Scene.onGameInitialized(payload)
    LayerManager:removeAllLayers();
    LayerManager:createLayerFromFile("skyBox.lua");
	LayerManager:createLayerFromFile("starfield.lua");
	LayerManager:createLayerFromFile("mainMenu.lua");
end

function Scene.onLayerFinishedTransition(layerName)
    LayerManager:removeLayerByName(layerName);
    print(layerName, "removed itself");
	if layerName == "splashScreen.lua" then
		LayerManager:removeAllLayers();
		MessageManager:send("GAME_INITIALIZED");
	elseif layerName == "mainMenu.lua" then
        LayerManager:removeAllLayers();
        MessageManager:send("START_GAME");    
    elseif layerName == "outOfTime.lua" then 	
        LayerManager:removeAllLayers();
        LayerManager:createLayerFromFile("results.lua");
        local currentScore = require("GameVariables"):get("Score");
        local highScore = UserDataManager:get("highScore");
        if currentScore > highScore then			
            UserDataManager:set("highScore", currentScore);
			UserDataManager:flush();
        end
    elseif layerName == "results.lua" then
        LayerManager:removeAllLayers();
        MessageManager:send("START_GAME");    
    elseif layerName == "pause.lua" then
        LayerManager:pauseAllLayers(false);
    elseif layerName == "credits.lua" then
        local pauseLayer = LayerManager:getLayerByName("pause.lua");
        if pauseLayer ~= nil then
            pauseLayer:setVisible(true);
            pauseLayer:pause(false);
            print("Unpaused pause layer")
        end
    end
end

function Scene:onRanOutOfTime(payload)
	local layers = LayerManager:getAllLayers();
	for k,v in pairs(layers) do
		if v:getName() == "gameLayer.lua" then
			v:replaceAllScripts(Factory:createFromFile("Script", "gameLayerTransitionOut.lua"));
		elseif v:getName() == "gameHud.lua" then
			v:replaceAllScripts(Factory:createFromFile("Script", "gameHudTransitionOut.lua"));
		end
	end
	print("creating outoftimelayer")
	LayerManager:createLayerFromFile("outOfTime.lua");
end

function Scene.onSubTimer(pos)
	properties = {};
	properties.scale = {x = 3000, y = 3000, z = 3000};
	properties.position = {};
	properties.position.x = pos.x;
	properties.position.y = pos.y;
	properties.position.z = pos.z;
	properties.scripts = {"timeToLive.lua"};
	properties.type = "TextBox";
	properties.name = "TextBox";    
	properties.string = "<c:FF0000>-5";
	properties.textSize = 48;
	properties.shaderName = "none";
	properties.rectangle = {x2 = 500, y2 = 0, x1 = 0, y1 = 100};
	local newprop = require("Factory"):create("TextBox", properties); 
    
	LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
end

function Scene.onStartGame()
    -- song
	--stop song 
	--stop woosh
	require("SoundManager"):stop("woosh.wav");
	require("SoundManager"):stop("bgm.wav");
    require("SoundManager"):play("bgm.wav", true);

    -- some variables
    require("GameVariables"):reset();
	require("InputManager"):reCal();  
    LayerManager:createLayerFromFile("skyBox.lua");
    LayerManager:createLayerFromFile("gameLayer.lua");  
    LayerManager:createLayerFromFile("gameHud.lua");
end

function Scene.onSplashStart()      
    LayerManager:createLayerFromFile("skyBox.lua");
	LayerManager:createLayerFromFile("splashScreen.lua");
end

function Scene.test(payload)
end

MessageManager:listen("SPLASH_SCREEN", Scene.onSplashStart);
MessageManager:listen("GAME_INITIALIZED", Scene.onGameInitialized);
MessageManager:listen("START_GAME", Scene.onStartGame);
MessageManager:listen("CLICKED_CREDITS_BUTTON", Scene.onClickedCreditsButton);
MessageManager:listen("CLICKED_CREDITS_BACK_BUTTON", Scene.onClickedCreditsBackButton);
MessageManager:listen("CLICKED_PLAY_BUTTON", Scene.onClickedPlayButton);
MessageManager:listen("CLICKED_PAUSE_BUTTON", Scene.onClickedPauseButton);
MessageManager:listen("CLICKED_QUIT_BUTTON", Scene.onClickedQuitButton);
MessageManager:listen("CLICKED_RETRY_BUTTON", Scene.onClickedRetryButton);
MessageManager:listen("LAYER_FINISHED_TRANSITION", Scene.onLayerFinishedTransition);
MessageManager:listen("RAN_OUT_OF_TIME", Scene.onRanOutOfTime);
MessageManager:listen("ADD_TIMER", Scene.onAddTimer);
MessageManager:listen("SUB_TIMER", Scene.onSubTimer);
MessageManager:listen("CHECKPOINT", Scene.onCheckPoint);
MessageManager:listen("TEST", Scene.test);

return Scene