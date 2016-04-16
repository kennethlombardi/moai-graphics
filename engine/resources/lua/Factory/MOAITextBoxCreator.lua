local MOAITextBoxCreator = require("./Factory/Creator"):new();
local Factory = nil;

-- MOAITextBoxCreator
function MOAITextBoxCreator:create(properties)
    local MOAITextBoxPrototype = require("MOAITextBoxPrototype");
    local newObject = MOAITextBoxPrototype:allocate();

    newObject:setUnderlyingType(MOAITextBox.new());
    newObject:setName(properties.name);
    newObject:setType(properties.type);
    newObject:setScl(properties.scale.x, properties.scale.y, properties.scale.z);
    newObject:setLoc(properties.position.x, properties.position.y, properties.position.z);

    local font = require("ResourceManager"):load("Font", properties.fontName)
    newObject:setFont(font);
    newObject:setStyle(); -- hack

    newObject:setTextSize(properties.textSize);
    newObject:setRect(  properties.rectangle.x1,
                        properties.rectangle.y1,
                        properties.rectangle.x2,
                        properties.rectangle.y2 );

    if properties.justification == "left_justify" then
        newObject:getUnderlyingType():setAlignment(MOAITextBox.LEFT_JUSTIFY)
    elseif properties.justification == "center_justify" then
        newObject:getUnderlyingType():setAlignment(MOAITextBox.CENTER_JUSTIFY)
    else
        newObject:getUnderlyingType():setAlignment(MOAITextBox.RIGHT_JUSTIFY)
    end

    newObject:getUnderlyingType():setYFlip(true)
    newObject:setText(properties.string);

    for k,scriptName in pairs(properties.scripts) do
        newObject:registerScript(Factory:createFromFile("Script", scriptName));
    end

    return newObject;
end
--

return function(factory)
    Factory = factory;
    return MOAITextBoxCreator;
end
