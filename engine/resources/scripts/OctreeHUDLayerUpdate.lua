local Script = {
    name = "OctreeHUDLayerUpdate.lua",
};

local GameVariables = require("GameVariables");

function Script.update(layer, dt)
    local allProps = layer:getAllProps();
    for k,v in pairs(allProps) do
        local name = v:getName();
        if name == "SHOW_ALGORITHM" then
            local algorithm = "";
            if GameVariables:get("SHOW_OCTREE") == "TRUE" then algorithm = "OCTREE"
            elseif GameVariables:get("SHOW_BSP_TREE") == "TRUE" then algorithm = "BSP-TREE"
            end
            v:setText(string.format('Algorithm: %s', algorithm));
        elseif name == "SHOW_LEAF_POLYGON_LIMIT" then
            v:setText(string.format('Leaf Polygon Limit: %i', GameVariables:get("MIN_FACES")))
        end
    end
end

return Script;