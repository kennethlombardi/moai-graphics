local SoundManager = {
	core = nil,
};

function SoundManager:play(fileName, isLooping)
	self.core:play(fileName, isLooping);
end

function SoundManager:registerCore(core)
	if self.core ~= nil then self.core:shutdown() end
	self.core = core;
	self.core:initialize();
end

function SoundManager:shutdown()
	self.core:shutdown();
	self.core = nil;
end

function SoundManager:stop(fileName)
	self.core:stop(fileName);
end

function SoundManager:update(dt)
	self.core:update(dt);
end

-- SoundManagerCore
local SoundManagerCore = {};

function SoundManagerCore:baseShutdown()
	print("SoundManagerCore:shutdown is UNIMPLEMENTED");
end

function SoundManagerCore:baseUpdate(dt)
end

function SoundManagerCore:initialize()
	print("SoundManagerCore:initialize is UNIMPLEMENTED");
end

function SoundManagerCore:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function SoundManagerCore:play(fileName)
	print("SoundManagerCore:play is UNIMPLEMENTED");
end

function SoundManagerCore:shutdown()
	self:baseShutdown();
end

function SoundManagerCore:update(dt)
	self:baseUpdate(dt);
end
--

-- MOAIUntzCore
local MOAIUntzCore = SoundManagerCore:new {
	playing = {},
};

function MOAIUntzCore:initialize()
	MOAIUntzSystem.initialize();
end	

function MOAIUntzCore:play(fileName, isLooping)
	local sound = require("ResourceManager"):load("Sound", fileName);	
	sound:setVolume(1);
	if isLooping then
		sound:setVolume(.8);
	end
	sound:setLooping(isLooping);
	sound:play();
	self.playing[fileName] = sound;
end

function MOAIUntzCore:stop(fileName)
	if self.playing[fileName] ~= nil then
		self.playing[fileName]:stop();
	end
end

function MOAIUntzCore:stopAll(fileName)
	for i,v in ipairs(self.playing) do
		self.playing[i]:stop();
		self.playing[i] = nil;
	end
end

function MOAIUntzCore:shutdown()
	self:stopAll();
end

function MOAIUntzCore:update(dt)
	self:baseUpdate(dt);
	for i,v in ipairs(self.playing) do
		if not self.playing[i]:isPlaying() then
			self.playing[i] = nil;
		end
	end
end
--

local function initialize()
	SoundManager:registerCore(MOAIUntzCore:new());
end

initialize();

return SoundManager;