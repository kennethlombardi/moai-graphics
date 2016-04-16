local Layer = {
    type = "Layer",
    name = "DefaultLayerName",
    visible = "false",  -- This should start at false to allow a push to the render pass
    underlyingType = "nil",
    propContainer = nil,
    position = {x = 0, y = 0, z = 0},
    rotation = {x = 0, y = 0, z = 0},
    scripts = {},
    currentIndex = 1,
    paused = false,
}

function Layer:baseFree()
    self.underlyingType = nil;
    self.propContainer:free();
    self.position = nil;
    self.scripts = nil;
    self.propContainer = nil;
end

function Layer:baseUpdate(dt)
    if self.paused then return end
    for k,v in pairs(self.scripts) do
        v.update(self, dt);
    end
    self.propContainer:update(dt);
end

function Layer:clearAllScripts()
    self.scripts = {};
end

function Layer:free() 
    self:baseFree();
end

function Layer:getName()
    return self.name;
end

function Layer:getUnderlyingType()
    return self.underlyingType;
end

function Layer:getPropForIndex(index)
    return propsByIndex[index];
end

function Layer:hide()
    self.visible = "false";
    print("Hiding layer");
end

function Layer:insertProp(prop)
    print("Layer:insertProp is UNIMPLEMENTED");
end

function Layer:new(object)
    object = object or {};
    setmetatable(object, self);
    self.__index = self;
    return object;
end

function Layer:pause(doPause)
    if doPause == nil then self.paused = true
    else self.paused = doPause end
end

function Layer:pick()
    print("Layer:pick is UNIMPLEMENTED");
end

function Layer:registerScript(script)
    table.insert(self.scripts, script);
end

function Layer:replaceAllScripts(with)
    self:clearAllScripts();
    self:registerScript(with);
end

function Layer:replaceScript(scriptName, with)
    for k,v in ipairs(self.scripts) do
        if v.name == scriptName then
            self.scripts[k] = with;
            return;
        end
    end
    print("Script", scriptName, "not found to be replaced with", with.name);
end

function Layer:serialize(properties)
   properties = properties or {};
   return self:serializeBase(properties);
end

function Layer:serializeBase(properties)
    properties = properties or {}
    properties["type"] = self.type;
    properties["name"] = self.name;
    properties["visible"] = self.visible;
    properties["propContainer"] = self["propContainer"]:serialize();
    properties["position"] = self.position;
    properties.scripts = {};
    for i,script in pairs(self.scripts) do
        table.insert(properties.scripts, script.name);
    end
    return properties;   
end

function Layer:serializeToFile(fileName)
    require "Pickle";
    properties = self:serialize();
    properties.name = fileName;
    p = pickle( properties );
    file = assert( io.open("../layers/"..fileName, "wt") );
    s = "deserialize (\"Layer\",\n";
    file:write(s);
    file:write(p);
    s = ")\n\n";
    file:write(s);
    file:close();
end

function Layer:setName(name)
    self.name = name;
end

function Layer:setLoc(x, y, z)
    self.position.x = x;
    self.position.y = y;
    self.position.z = z;
end

function Layer:setType(type)
    self.type = type;
end

function Layer:setUnderlyingType(newObjectReference)
    self["underlyingType"] = newObjectReference;
end

function Layer:update(dt)
    self:baseUpdate(dt);
end

return Layer;