local PropPrototypeCreator = require("./Factory/Creator"):new();

-- PropPrototypeCreator
function PropPrototypeCreator:create(properties)
    local propPrototype = require "PropPrototype";
    local newObject = propPrototype:new();
    newObject:setName(properties.name);
    newObject:setType(properties.type);
    return newObject;
end
--

return function(factory)
    return PropPrototypeCreator;
end