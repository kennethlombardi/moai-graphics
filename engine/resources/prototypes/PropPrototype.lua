local PropPrototype = {
	underlyingType = nil,
	name = "PropPrototypeName",
	type = "PropPrototypeType",
	scale = {x = 1, y = 1, z = 1},
	position = {x = 0, y = 0, z = 0},
	size = {x = 1, y = 1, z = 1},
	shaderName = "ken",
	textureName = "moai.png",
	rotation = {x = 0, y = 0, z = 0},
	scripts = {},
}

function PropPrototype:allocate()
	local object = PropPrototype:new {
		underlyingType = nil,
		name = "PropPrototypeName",
		type = "PropPrototypeType",
		scale = {x = 1, y = 1, z = 1},
		position = {x = 0, y = 0, z = 0},
		size = {x = 1, y = 1, z = 1},
		shaderName = "ken",
		textureName = "moai.png",
		rotation = {x = 0, y = 0, z = 0},
		scripts = {},
	}
	return object;
end

function PropPrototype:baseUpdate(dt)
	for k,script in pairs(self.scripts) do
		script.update(self, dt);
	end
end

function PropPrototype:baseFree()
	self.underlyingType = nil;
	self.name = nil;
	self.type = nil;
	self.scale = nil
	self.position = nil;
	self.size = nil;
	self.shaderName = nil;
	self.textureName = nil;
	self.rotation = nil;
	self.scripts = nil;
end

function PropPrototype:baseSerialize(properties)
	properties = properties or {};
	properties.name = self.name;
	properties.position = self.position;
	properties.type = self.type;
	properties.scale = self.scale;
	properties.shaderName = self.shaderName;
	properties.textureName = self.textureName
	properties.rotation = self.rotation;
	return properties;
end

function PropPrototype:baseSetLoc(x, y, z)
	self.position.x = x;
	self.position.y = y;
	self.position.z = z;
end

function PropPrototype:baseSetRot(x, y, z)
	self.rotation.x = x;
	self.rotation.y = y;
	self.rotation.z = z;
end

function PropPrototype:clearAllScripts()
	self.scripts = {};
end

function PropPrototype:baseSetScl(x, y, z)
	self.scale.x = x;
	self.scale.y = y;
	self.scale.z = z;
end

function PropPrototype:baseSetShader(shader, shaderName)
	self.shaderName = shaderName;
end

function PropPrototype:free()
	self:baseFree();
end

function PropPrototype:getLoc()
	return self.position;
end

function PropPrototype:getName()
	return self.name;
end

function PropPrototype:getRot()
	return self.rotation;
end

function PropPrototype:getScl()
	return self.scale;
end

function PropPrototype:getSize()
	return self.size;
end

function PropPrototype:getType()
	return self.type;
end

function PropPrototype:getUnderlyingType()
	return self.underlyingType;
end

function PropPrototype:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function PropPrototype:registerScript(script)
	table.insert(self.scripts, script);
end

function PropPrototype:replaceAllScripts(with)
    self:clearAllScripts();
    self:registerScript(with);
end

function PropPrototype:setLoc(x, y, z)
	self:baseSetLoc(x, y, z);
end

function PropPrototype:setName(name)
	self.name = name;
end

function PropPrototype:serialize(properties)
	return self:baseSerialize(properties);
end

function PropPrototype:setScl(x, y, z)
	self:baseSetScl(x, y, z);
end

function PropPrototype:setShader(shader, shaderName)
	self:baseSetShader(shader, shaderName);
end

function PropPrototype:setSize(x, y, z)
	self.size.x = x;
	self.size.y = y;
	self.size.z = z;
end

function PropPrototype:setType(type)
	self.type = type;
end

function PropPrototype:setTextureName(textureName)
	self.textureName = textureName;
end

function PropPrototype:setUnderlyingType(newObjectReference)
	self.underlyingType = newObjectReference;
end

function PropPrototype:update(dt)
	self:baseUpdate(dt);
end

return PropPrototype;