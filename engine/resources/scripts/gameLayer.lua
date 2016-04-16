local Script = {
	name = "gameLayer.lua",
};

local spawnTimer = 0;
local LayerManager = require("LayerManager");
function Script.update(layer, dt)
    spawnTimer = spawnTimer + dt;
    if spawnTimer > 1 then    
        spawnTimer = 0;
        local newprop = require("Generator"):spawnObject(0,0);  
        LayerManager:getLayerByName("gameLayer.lua"):insertPropPersistent(newprop);
        LayerManager:getLayerByName("gameLayer.lua"):insertProp(newprop);
    end
end

return Script;

