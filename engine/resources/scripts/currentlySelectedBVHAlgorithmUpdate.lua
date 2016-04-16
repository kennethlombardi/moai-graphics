local Script = {
    name = "currentlySelectedBVHAlgorithmUpdate.lua",
};

function Script.update(object, dt)  
    object:setText(string.format('BVH Algorithm: %s', require("GameVariables"):get("BVHAlgorithm") or "NONE"));  
end

return Script;