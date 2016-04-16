local MOAIShaderCreator = require("./Factory/Creator"):new();

-- MOAIShaderCreator
function MOAIShaderCreator:create(fileName) -- Change this to properties 
    if (fileName == "MESH_SHADER") then return MOAIShaderMgr.getShader(MOAIShaderMgr.MESH_SHADER) end
    return require("ResourceManager"):load("Shader", fileName);
end
--

return function(factory)
    return MOAIShaderCreator;
end