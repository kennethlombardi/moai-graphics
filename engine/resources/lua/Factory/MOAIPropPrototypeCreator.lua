local MOAIPropPrototypeCreator = require("./Factory/Creator"):new();
local Factory = nil;

-- MOAIPropPrototypeCreator
function MOAIPropPrototypeCreator:create(properties)
    local propPrototype = require "MOAIPropPrototype";
    local newObject = propPrototype:allocate();

    newObject:setUnderlyingType(MOAIProp.new());
    newObject:setName(properties.name);
    newObject:setType(properties.type);
    properties.scale = properties.scale or newObject.scale;
    properties.size = properties.size or newObject.size;
    properties.rotation = properties.rotation or newObject.rotation;
    newObject:setSize(properties.size.x, properties.size.y, properties.size.z);
    newObject:setScl(properties.scale.x, properties.scale.y, properties.scale.z);
    newObject:setLoc(properties.position.x, properties.position.y, properties.position.z);
    newObject:setRot(properties.rotation.x, properties.rotation.y, properties.rotation.z);

    newObject:setTextureName(properties.textureName);
    newObject:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);

    -- register scripts
    for k,scriptName in pairs(properties.scripts or {}) do
        newObject:registerScript(Factory:createFromFile("Script", scriptName));
    end

    -- shader
    local shader = Factory:create("Shader", properties.shaderName);
    newObject:setShader(shader, properties.shaderName);

    return newObject;
end
--

return function(factory) 
    Factory = factory;
    return MOAIPropPrototypeCreator;
end