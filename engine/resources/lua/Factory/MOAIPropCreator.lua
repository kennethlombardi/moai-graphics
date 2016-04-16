local MOAIPropCreator = require("./Factory/Creator"):new();

-- MOAIPropCreator
function MOAIPropCreator:create(properties)
    -- gfx quad with texture
    local gfxQuad = MOAIGfxQuad2D.new ()
    local texture = require("ResourceManager"):load("Texture", properties.textureName);
    gfxQuad:setTexture(texture:getUnderlyingType());
    gfxQuad:setRect(
        -texture:getSize().x * properties.scale.x, 
        -texture:getSize().y * properties.scale.y, 
        texture:getSize().x * properties.scale.x, 
        texture:getSize().y * properties.scale.y);
    gfxQuad:setUVRect(0, 1, 1, 0)

    local propPrototype = Factory:create("MOAIPropPrototype", properties);
    propPrototype:getUnderlyingType():setDeck(gfxQuad);
    propPrototype:setSize(texture:getSize().x, texture:getSize().y, 1);
    return propPrototype;
end
--

return function(factory)
    return MOAIPropCreator;
end