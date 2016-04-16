local MOAITextBoxPrototype = require("TextBoxPrototype"):new();

function MOAITextBoxPrototype:allocate()
	object = MOAITextBoxPrototype:new{
		position = {x = 0, y = 0, z = 0},
		scale = {x = 1, y = 1, z = 1},
		underlyingType = nil,
		string = "MOAITextBoxPrototype Text",
		textSize = 12,
		rectangle = {x1 = -50, y1 = -50, x2 = 50, y2 = 50},
		scripts = {},
	}

	return object;
end

function MOAITextBoxPrototype:setFont(font)
	self:baseSetFont(font);
	self.underlyingType:setFont(font);
end

function MOAITextBoxPrototype:setLoc(x, y, z)
	self:baseSetLoc(x, y, z);
	self.underlyingType:setLoc(x, y , z);
end

function MOAITextBoxPrototype:setText(string)
	self:baseSetText(string);
	self.underlyingType:setString(string);
end

function MOAITextBoxPrototype:setTextSize(size)
	self:baseSetTextSize(size);
	self.underlyingType:setTextSize(size);
end

function MOAITextBoxPrototype:setRect(x1, y1, x2, y2)
	self:baseSetRect(x1, y1, x2, y2);
	self.underlyingType:setRect(x1, y1, x2, y2);
end
return MOAITextBoxPrototype;