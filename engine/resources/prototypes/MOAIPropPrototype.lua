local PropPrototype = require "PropPrototype";

local MOAIPropPrototype = PropPrototype:allocate();

function MOAIPropPrototype:allocate()
	object = MOAIPropPrototype:new{
		position = {x = 0, y = 0, z = 0},
		size = {x = 1, y = 1, z = 1},
		scale = {x = 1, y = 1, z = 1},
		rotation = {x = 0, y = 0, z = 0},
		scripts = {},
		shaderName = "ken",
	}
	return object;
end

function MOAIPropPrototype:getScl()
	self.scale.x, self.scale.y, self.scale.z = self.underlyingType:getScl();
	return self.scale;
end

function MOAIPropPrototype:getShader()
	return self.underlyingType.hack.shader;
end

function MOAIPropPrototype:getRot()
	self.rotation.x, self.rotation.y, self.rotation.z = self.underlyingType:getRot();
	return self.rotation;
end

function MOAIPropPrototype:moveLoc(x, y, z, length, ease)
	ease = ease or MOAIEaseType.SMOOTH;
	self.underlyingType:moveLoc(x, y, z, length, ease);
end

function MOAIPropPrototype:serialize(properties)
	properties = properties or {};
	self:baseSerialize(properties);
	properties.scripts = {};
	properties.rotation.x, properties.rotation.y, properties.rotation.z = self.underlyingType:getRot();
	properties.position.x, properties.position.y, properties.position.z = self.underlyingType:getLoc();
	for k,script in pairs(self.scripts) do
		table.insert(properties.scripts, script.name)
	end
	return properties;
end

function MOAIPropPrototype:setName(name)
	self.name = name;
end

function MOAIPropPrototype:setLoc(x, y, z)
	self:baseSetLoc(x, y, z);
	self.underlyingType:setLoc(x, y, z);
end

function MOAIPropPrototype:setRot(x, y, z)
	self:baseSetRot(x, y, z);
	self.underlyingType:setRot(x, y, z);
end

function MOAIPropPrototype:setScl(x, y, z)
	self:baseSetScl(x, y, z);
	self.underlyingType:setScl(x, y, z);
end

function MOAIPropPrototype:setShader(shader, shaderName)
	self:baseSetShader(shader, 	shaderName);
	self.underlyingType:setShader(shader);
	self.underlyingType.hack = self.underlyingType.hack or {}
	self.underlyingType.hack.shader = shader;
end

function MOAIPropPrototype:update(dt)
	self:baseUpdate(dt);
end

return MOAIPropPrototype;