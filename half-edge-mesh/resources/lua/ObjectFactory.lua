local factory = {}

local currentHandle = 1;
objects = {};

local function createNewObject( objectType )
	if objectType == "MOAIFoo" then
		return MOAIFoo:new();
	end
	print ("Created a nil object. Unknown type %s.", objectType );
	return nil;
end

local function addObject ( object )
	print( "added object: " .. object );
end

local function getUniqueHandle()
	newHandle = currentHandle;
	currentHandle = currentHandle + 1;
	return newHandle;
end

local function decorate( object, objectType )
	if objectType == "MOAIFoo" then
		function decoration (b)
			object.randomFunction = b["randomFunction"];
		end
		dofile( "objectDecorationMOAIFoo.lua" );
	end
end

local function createObject ( objectType )
	newHandle = getUniqueHandle();
	print( string.format( "created object with handle: %i", newHandle ) );
	objects[newHandle] = createNewObject( objectType );
	decorate( objects[newHandle], objectType );
	return newHandle;
end

local function getObject( handle )
	return objects[handle];
end

factory.createObject = createObject;
factory.getObject = getObject;


return factory