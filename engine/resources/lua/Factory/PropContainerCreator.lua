local PropContainerCreator = require("./Factory/Creator"):new();

-- PropContainerCreator
function PropContainerCreator:create(properties)
    propContainerPrototype = require "PropContainerPrototype";
    return propContainerPrototype:allocate();
end
--

return function(factory)
    return PropContainerCreator;
end