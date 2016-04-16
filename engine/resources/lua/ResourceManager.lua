-- ResourceManager
local ResourceManager = {
	cache = {},
	handlers = {};
};

function ResourceManager:addToCache(key, value) 
	self.cache[key] = value;
end

function ResourceManager:getFromCache(key)
	return self.cache[key];
end

function ResourceManager:load(typeName, fileName) 
	return self.handlers[typeName]:load(fileName);
end

function ResourceManager:register(typeName, handler) 
	self.handlers[typeName] = handler;
end

function ResourceManager:shutdown()
	self.cache = nil;
end
--

-- Creator
local Creator = {};

function Creator:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end
-- 

-- Creators
local MOAITextureCreator = Creator:new(); 
local MOAIFileCreator = Creator:new();
local MOAIFontCreator = Creator:new();
local MOAIShaderCreator = Creator:new();
local MOAISoundCreator = Creator:new();
local MOAIObjCreator = Creator:new();
--

-- Handler
local Handler = Creator:new();
--

-- Handlers
local MOAIFileHandler = Handler:new();
local MOAIConfigurationHandler = Handler:new();
local MOAIScriptHandler = Handler:new();
local MOAIUserDataHandler = Handler:new();
local MOAIObjFileStreamHandler = Handler:new();
local MOAIPropHandler = Creator:new();
--

-- MOAIConfigurationHandler
function MOAIConfigurationHandler:load(fileName)
	local configuration = {};
	function deserialize(args)
		configuration = args;
	end
	local fullPath = "../configurations/"..fileName;
	if require("FileSystem"):checkFileExists(fullPath) then
		dofile(fullPath);
	end
	return configuration;
end
--

-- MOAIFileHandler
function MOAIFileHandler:load(fullPath) 
	local FileSystem = require("FileSystem");
	local file = "";
	if FileSystem:checkFileExists(fullPath) then
		file = FileSystem:load("File", fullPath);
	end
	ResourceManager:addToCache(fullPath, file);
end
--

-- MOAIPropHandler
function MOAIPropHandler:load(fileName)
	-- assuming props folder is in package.path
    return require(fileName);
end
--

-- MOAIUserDataHandler
function MOAIUserDataHandler:load(fileName)
	dofile("Pickle.lua");
	local configuration = {};
	function deserialize(args)
		configuration = args;
	end
	local fullPath = "../userData/"..fileName;
	if require("FileSystem"):checkFileExists(fullPath) then
		dofile(fullPath);
	end
	local cucumber = unpickle(configuration);
	for k,v in pairs(cucumber) do
		print(k,v)
	end
	return cucumber;
end
--

-- MOAIFontCreator
function MOAIFontCreator:createFromFile(fileName)
	local font = ResourceManager:getFromCache(fileName);
	if font == nil then
		properties = {
			name = "arial-rounded.ttf",
			--name = "horrendo.ttf",
			characterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!",
			points = 12,
			dpi = 144,
		}
		font = MOAIFont.new();
		font:loadFromTTF(properties.name, properties.characterSet, properties.points, properties.dpi);
		ResourceManager:addToCache(fileName, font);
	end
	return font;
end

function MOAIFontCreator:load(fileName)
	return self:createFromFile(fileName);
end
--

-- MOAIObjCreator
local function objStreamToVertexAndFaceLists(objStream)
    local function pushFace(faces, v1, v2, v3)
        local face = {v1 = v1, v2 = v2, v3 = v3}
        table.insert(faces, face);
    end

    local function pushVertex(vertices, x, y, z)
        local vertex = {x = x, y = y, z = z}
        table.insert(vertices, vertex)
    end
    
    local faces = {};
    local vertices = {};
    local comments = {};
    
    -- handlers
    local handlers = {};
    function handlers:register(key, handler)
        self[key] = handler;
    end
    
    function handlers:handle(key, payload)
        local method = self[key]; --:handle(payload);
        if (method) then method:handle(payload)
        end
    end

    -- commentHandler
    local commentHandler = {}
    function commentHandler:handle(comment)
        table.insert(comments, comment);
    end

    -- vertexHandler
    local vertexHandler = {}
    
    function vertexHandler:handle(vertexString)
        local vertex = {}
        for i in string.gmatch(vertexString, "%S+") do
            if (i ~= 'v') then table.insert(vertex, i); end
        end

        pushVertex(vertices, tonumber(vertex[1]), tonumber(vertex[2]), tonumber(vertex[3]));
    end

    -- faceHandler
    local faceHandler = {}
    function faceHandler:handle(faceString)
        local face = {}
        for i in string.gmatch(faceString, "%S+") do
            if (i ~= 'f') then table.insert(face, i); end
        end
        pushFace(faces, vertices[tonumber(face[1])], vertices[tonumber(face[2])], vertices[tonumber(face[3])]);
    end
    
    -- globalHandler
    local globalHandler = {}
    function globalHandler:handle(global)
    end
    
    handlers:register('v', vertexHandler);
    handlers:register('#', commentHandler);
    handlers:register('f', faceHandler);
    handlers:register('g', globalHandler);
    
    for line in objStream:lines() do
        handlers:handle(line:sub(1, 1), line)
    end
    
    return {faces = faces, vertices = vertices};
end

function MOAIObjCreator:load(filename)
	local path = "../models/"..filename;
	local obj = nil; --ResourceManager:getFromCache(path);
	if obj == nil then
		local objFileStream = ResourceManager:load("ObjFileStream", path);
		local obj = objStreamToVertexAndFaceLists(objFileStream);
		objFileStream:close();
		ResourceManager:addToCache(path, obj);
	end
	return ResourceManager:getFromCache(path);
end
--

-- MOAIObjFileStreamHandler
function MOAIObjFileStreamHandler:load(filename)
	local path = "../models/"..filename;
	local file = io.open(path, "rt");
	return file;
end
--

-- MOAITextureCreator
function MOAITextureCreator:load(fileName) 
	local path = "../textures/"..fileName;
	local texture = ResourceManager:getFromCache(path);
	if texture == nil then
		texture = require("MOAITexture"):allocate();
		local moaiTexture = MOAITexture.new();
		local moaiImage = MOAIImage.new();
		moaiImage:load(path);
		moaiTexture:load(moaiImage);
		texture:setName(fileName);
		texture:setUnderlyingType(moaiTexture);
		
		
		local sizex, sizey = moaiTexture:getSize();
		texture:setSize(sizex, sizey)
		ResourceManager:addToCache(path, texture);
	end
	--TODO: If texture loading fails from file, create new MOAIImage with some garbage
	--		to ensure that at least something is registered correctly.

	return texture;
end
--

-- MOAIScriptHandler
function MOAIScriptHandler:load(fileName)	
	local fullPath = "../scripts/"..fileName;
	local script = ResourceManager:getFromCache(fullPath);
	if script ~= nil then return script end;

	-- If the script didn't exist in the cache
	if require("FileSystem"):checkFileExists(fullPath) then
		script = dofile(fullPath);
		ResourceManager:addToCache(fullPath, script);	
	else
		-- script is a do nothing anonymous function
		script = {update = function() end, name = "AnonymousScript"};
		print("Script", fileName, "was replaced with an anonymous do nothing");
	end
	return script;
end
--

-- MOAIShaderCreator
function MOAIShaderCreator:load(fileName)
	local fullPath = "../shaders/"..fileName;
	local vsh = require("FileSystem"):load("File", fullPath..".vsh", "rb");
	local fsh = require("FileSystem"):load("File", fullPath..".fsh", "rb");
	local shader = MOAIShader.new();
    -- color = MOAIColor.new ()
    -- color:setColor ( 1, 1, 0, 0 )
	shader:reserveUniforms(2);
	shader:declareUniform(1, 'transform', MOAIShader.UNIFORM_WORLD_VIEW_PROJ);
    shader:declareUniform(2, 'maskColor', MOAIShader.UNIFORM_COLOR);
    --shader:setAttrLink ( 2, color, MOAIColor.COLOR_TRAIT )
	shader:setVertexAttribute(1, 'position');
	shader:setVertexAttribute(2, 'uv');
	shader:setVertexAttribute(3, 'color');	
	shader:load(vsh, fsh);
	return shader;
end
--

function MOAISoundCreator:load(fileName)
	local fullPath = "../sounds/"..fileName;
	local sound = MOAIUntzSound.new();
	sound:load(fullPath);
	return sound;
end

local function init()
	ResourceManager:register("Texture", MOAITextureCreator:new());
	ResourceManager:register("Configuration", MOAIConfigurationHandler:new());
	ResourceManager:register("UserData", MOAIUserDataHandler:new());
	ResourceManager:register("Font", MOAIFontCreator:new());
	ResourceManager:register("Script", MOAIScriptHandler:new());
	ResourceManager:register("Shader", MOAIShaderCreator:new());
	ResourceManager:register("File", MOAIFileHandler:new());
	ResourceManager:register("Sound", MOAISoundCreator:new());
	ResourceManager:register("Obj", MOAIObjCreator:new());
	ResourceManager:register("ObjFileStream", MOAIObjFileStreamHandler:new());
    ResourceManager:register("Prop", MOAIPropHandler:new());
end

init();

return ResourceManager;