local UserDataManager = { userData = {} }
local FileSystem = require "FileSystem";
local ResourceManager = require "ResourceManager";

function UserDataManager:get(key)
    return self.userData[key];
end

function UserDataManager:set(key, value)
    self.userData[key] = value;
end

function UserDataManager:flush()
    local file = io.open("../userData/userData.lua", "wt");
	if file then
		s = "deserialize (";
		file:write(s);
		s = pickle(self.userData);
		file:write(s);
		s = ")\n\n";
		file:write(s);
		file:close();
	else
		print("No file found");
		--local stream = MOAIFileStream.new();
		--stream:open('UserData', MOAIFileStream.READ_WRITE_NEW);		
		--stream:writeFormat('u32', self.get("highScore"));
		--stream:close();
	end	
	
end


function UserDataManager:shutdown()
    UserDataManager:flush();
end

function init()
    local userData = ResourceManager:load("UserData", "userData.lua");
	if not userData then
		print("no Data!");
	end
    for k,v in pairs(userData) do 
        UserDataManager:set(k, v);
    end
end

init();

return UserDataManager