local MOAIOBBPCACreator = require("./Factory/Creator"):new();
local Factory = nil;
local Math = require("Math");
local SphereCreator = require("SphereCreator");
local Matrix = require("Matrix");

function createOBB(vertices)
    local m = Matrix.identity({});
    local v = Matrix.identity({});
    local s = {r = 0, c = {x = 0, y = 0, z = 0}}

    Math:covarianceMatrix(m, vertices);
    m, v = Math:jacobi(m, v);


    local e = {x = 0, y = 0, z = 0};
    local maxc = 0;
    local maxe = math.abs(m[0][0]);
    local maxf = math.abs(m[1][1]);

    if maxf > maxe then 
        maxc = 1; 
        maxe = maxf;
    end

    maxf = math.abs(m[2][2]);
    if maxf > maxe then
        maxc = 2; 
        maxe = maxf;
    end

    e.x = v[0][maxc];
    e.y = v[1][maxc];
    e.z = v[2][maxc];

    -- find the most extreme points along direction e
    local extremal = Math:getExtremePointsAlongDirection(e, vertices);
    local minpt = extremal.vmin;
    local maxpt = extremal.vmax;

    local difference = Math:vertex3Sub(maxpt, minpt);
    local dist = math.sqrt(Math:dot3(difference, difference));
    s.r = dist * 0.5;

    local p = minpt;
    local q = maxpt;
    local difference = Math:vertex3Sub(q, p);
    local halfWayPoint = Math:vertex3Sum(p, Math:vertex3Mul(difference, .5));
    s.c = halfWayPoint;

    return s
end

function createOBBFromObj(obj)
    local sphere = createOBB(obj.vertices);
    return SphereCreator:makeSphereMesh(sphere.c, 0);
end

function MOAIOBBPCACreator:create(properties)
    local obb = require("ResourceManager"):load("Prop", "cubeProp");
    local obbPCAPath = "../boundingVolumes/SpherePCA/"..properties.obj.fileName;

    obb.mesh = require("ResourceManager"):getFromCache(obbPCAPath);
    if obb.mesh == nil then
        obb.mesh = createOBBFromObj(properties.obj);
        require("ResourceManager"):addToCache(obbPCAPath, obb.mesh);
    end

    -- if obb has mesh attached then mesh will be used to create prop
    local newProp = Factory:create(obb.type, obb)
    obb.mesh = nil; -- remove for garbage collector
    newProp.fileName = obb.fileName;
    return newProp;
end

return function(factory)
    Factory = factory;
    return MOAIOBBPCACreator;
end