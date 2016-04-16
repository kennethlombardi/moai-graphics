local MOAITorusCreator = require("./Factory/Creator"):new();
local Factory = nil

-- MOAIPropTorusCreator
function MOAITorusCreator:create(properties)
    return Factory:create("Model", properties);
end
--

return function(factory)
    Factory = factory;
    return MOAITorusCreator;
end