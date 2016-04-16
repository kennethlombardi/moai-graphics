local MOAISphereCentroidCreator = require("./Factory/Creator"):new();
local Factory = nil;
local Math = require("Math");
local SphereCreator = require("SphereCreator");

local function getFurthestPointDistanceFromCenter(obj, from)
    local maxDistance = -Math.Constants.FLOAT_MAX;
    for index, vertex in pairs(obj.vertices) do
        local xDistance = from.x - vertex.x;
        local yDistance = from.y - vertex.y;
        local zDistance = from.z - vertex.z;
        local distance = xDistance * xDistance + yDistance * yDistance + zDistance * zDistance;
        if distance > maxDistance then
            maxDistance = distance;
        end
    end
    maxDistance = math.sqrt(maxDistance);
    return maxDistance;
end

local function createCentroidSphereFromObjs(objs)
    local c = Math:getCentroidOfMultipleObjs(objs);

    -- for each obj get a max r
    local r = 0;
    for k,obj in pairs(objs) do 
        local potential = getFurthestPointDistanceFromCenter(obj, c);
        if potential > r then r = potential end 
    end
    return SphereCreator:makeSphereMesh(c, r);
end

function MOAISphereCentroidCreator:create(properties)
    local cube = require("ResourceManager"):load("Prop", "sphereProp");

    if properties.objs == nil then 
        local objs = {properties.obj};
        properties.objs = objs;
    end
    cube.mesh = createCentroidSphereFromObjs(properties.objs);

    -- if cube has mesh attached then mesh will be used to create prop
    local newProp = Factory:create(cube.type, cube)
    cube.mesh = nil; -- remove for garbage collector
    newProp.fileName = cube.fileName;
    return newProp;
end

return function(factory)
    Factory = factory;
    return MOAISphereCentroidCreator;
end