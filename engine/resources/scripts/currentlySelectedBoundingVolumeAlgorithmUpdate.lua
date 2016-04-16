local Script = {
    name = "currentlySelectedBoundingVolumeAlgorithmUpdate.lua",
};

function Script.update(object, dt)  
    object:setText(string.format('Algorithm: %s', require("GameVariables"):get("BVAlgorithm")));  
end

return Script;