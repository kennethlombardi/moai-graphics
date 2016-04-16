local MOAIMeshCreator = require("./Factory/Creator"):new();

-- MOAIMeshCreator
function MOAIMeshCreator:create(properties)
    local ShapesLibrary = require "ShapesLibrary";
    if properties.type == "PropCube" then
        return ShapesLibrary.makeCube(properties.textureName);
    elseif properties.type == "Sphere" then
        return ShapesLibrary.makeSphere(properties.textureName);
    elseif properties.type == "Torus" then
        return ShapesLibrary.makeTorus(properties.textureName);
    end
    return ShapesLibrary.makeCube(properties.textureName);
end
--

return function(factory)
    return MOAIMeshCreator;
end