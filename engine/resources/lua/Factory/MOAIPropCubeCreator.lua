local MOAIPropCubeCreator = require("./Factory/Creator"):new();
local Factory = factory;

-- MOAIPropCubeCreator
function MOAIPropCubeCreator:create(properties)
    return Factory:create("Model", properties);
end
--

return function(factory)
    Factory = factory;
    return MOAIPropCubeCreator;
end