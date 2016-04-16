local MOAIScriptCreator = require("./Factory/Creator"):new();
local Factory = nil;

-- MOAIScriptCreator
function MOAIScriptCreator:create(properties)
    return Factory:createFromFile("Script", properties.fileName);
end

function MOAIScriptCreator:createFromFile(fileName)
    return require("ResourceManager"):load("Script", fileName);
end

return function(factory) 
    Factory = factory;
    return MOAIScriptCreator;
end