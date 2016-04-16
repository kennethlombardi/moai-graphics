local TextBox = require("PropPrototype"):new {
	font = nil,
	string = "MyText",
	textSize = 12,
	rectangle = {x1 = -50, y1 = -50, x2 = 50, y2 = 50},
	scripts = {},
};

function TextBox:baseSerialize_(properties)
	properties = properties or {};
	self:baseSerialize(properties);
	properties.string = self.string;
	properties.textSize = self.textSize;
	properties.rectangle = self.rectangle;
	properties.scripts = {};
	for k,v in pairs(self.scripts) do
		table.insert(properties.scripts, v.name);
	end
	return properties;
end

function TextBox:baseSetFont(font)
	self.font = font;
end

function TextBox:baseSetRect(x1, y1, x2, y2)
	self.rectangle.x1 = x1;
	self.rectangle.y1 = y1;
	self.rectangle.x2 = x2;
	self.rectangle.y2 = y2;
end

function TextBox:baseSetText(string)
	self.string = string;
end

function TextBox:baseSetTextSize(size)
	self.textSize = size;
end

function TextBox:free()
	self:baseFree();
	self.font = nil;
end

function TextBox:registerScript(script)
	table.insert(self.scripts, script);
end

function TextBox:serialize(properties)
	return self:baseSerialize_(properties);
end

function TextBox:setFont(font)
	self:baseSetFont(font);
end

--[[
x1	( number ) The X coordinate of the rect's upper-left point.
y1	( number ) The Y coordinate of the rect's upper-left point.
x2	( number ) The X coordinate of the rect's lower-right point.
y2	( number ) The Y coordinate of the rect's lower-right point. --]]
function TextBox:setRect(x1, y1, x2, y2)
	self:baseSetRect(x1, y1, x2, y2);
end

function TextBox:setAlignment(alignment)
end

function TextBox:setYFlip(bool)
end

function TextBox:setText(string)
	self:baseSetText(string);
end

function TextBox:setTextSize(size)
	self:baseSetTextSize(size);
end

function TextBox:update(dt)
	for k,script in pairs(self.scripts) do
		script.update(self, dt);
	end
end

return TextBox;