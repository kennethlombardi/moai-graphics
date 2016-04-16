local MOAISphereCreator = require("./Factory/Creator"):new();
local Factory = nil;

-- MOAISphereCreator
function MOAISphereCreator:create(properties)
    return Factory:create("Model", properties);
end
--

return function(factory)
    Factory = factory;
    return MOAISphereCreator;
end