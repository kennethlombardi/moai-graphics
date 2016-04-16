local MOAISphereRitterCreator = require("./Factory/Creator"):new();
local Factory = nil;
local Math = require("Math");
local SphereCreator = require("SphereCreator");

local function createRitterSphereFromObj(obj) 
    local s = {r = 0, c = {x = 0, y = 0, z = 0}}
    Math:ritterSphere(s, obj.vertices);
    print("Ritter sphere: ", s.r)
    return SphereCreator:makeSphereMesh(s.c, s.r);
end

function MOAISphereRitterCreator:create(properties)
    local sphere = require("ResourceManager"):load("Prop", "sphereProp");
    local ritterSpherePath = "../boundingVolumes/SphereRitter/"..properties.obj.fileName;

    sphere.mesh = require("ResourceManager"):getFromCache(ritterSpherePath);
    if sphere.mesh == nil then
        sphere.mesh = createRitterSphereFromObj(properties.obj);
        require("ResourceManager"):addToCache(ritterSpherePath, sphere.mesh);
    end

    -- if sphere has mesh attached then mesh will be used to create prop
    local newProp = Factory:create(sphere.type, sphere)
    sphere.mesh = nil; -- remove for garbage collector
    newProp.fileName = sphere.fileName;
    return newProp;
end

return function(factory)
    Factory = factory;
    return MOAISphereRitterCreator;
end