Texture = {}

function Texture:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object
end

function Texture:allocate()
	object = Texture:new {
		size = {x = 1, y = 1},
		underlyingType = nil,
		name = "unnamedTexture",
	}
	return object
end

function Texture:free()
	self.underlyingType = nil;
end

function Texture:getName()
	return self.name;
end

function Texture:getSize()
	return self.size;
end

function Texture:getUnderlyingType()
	return self.underlyingType;
end

function Texture:setName(name)
	self.name = name;
end

function Texture:setSize(x, y)
	self.size.x = x;
	self.size.y = y;
end

function Texture:setUnderlyingType(underlyingType)
	self.underlyingType = underlyingType;
end




return Texture;