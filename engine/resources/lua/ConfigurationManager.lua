local ConfigurationManager = { configuration = {} }
local FileSystem = require "FileSystem";
local ResourceManager = require "ResourceManager";

function ConfigurationManager:get(key)
	return self.configuration[key];
end

function ConfigurationManager:set(key, value)
	self.configuration[key] = value;
end

function ConfigurationManager:shutdown()
end

function init()
	local globalSettings = ResourceManager:load("Configuration", "config_global.lua");
	for k,v in pairs(globalSettings) do
		ConfigurationManager:set(k, v);
	end

	-- User overrides global
	local userSettings = ResourceManager:load("Configuration", "config_user.lua");
	for k,v in pairs(userSettings) do 
		ConfigurationManager:set(k, v);
	end
end

init();

return ConfigurationManager