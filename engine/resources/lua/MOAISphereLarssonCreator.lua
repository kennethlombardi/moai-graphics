local MOAISphereRitterCreator = require("./Factory/Creator"):new();
local Factory = nil;
local Math = require("Math");
local SphereCreator = require("SphereCreator");

--[[
    sphere S of a point set P with n points
    described by a center point c and a radius r
    S = {c, r}
    
    To calculate the bounding sphere
        1) Select suitable subset E of P with k extremal points
            such that 4 < k < n
        2) The minimum sphere S' enclosing the point set E is computed
            using an exact solver such as Gartner's algorithm

        3) A final iteration over all P 
            makes sure that the sphere is grown if necessary to include all points
            Each time a point outside the current sphere is encountered
                a new larger sphere enclosing the current sphere and point is computed

        Assume n > k from the beginning
            Otherwise no need to reduce the number of points passed to exact solver

        Points in E include the actual points of support of optimal sphere
            So the algorithm is guaranteed to compute the minimum sphere

    To calculate extremal points E
        1) Create a pre-determined normal set N with s = k/2 normals
        2) For each normal select 2 extremal points 
            based on projecting all the input points p_i in P on the normal

    s and k can vary such as:
        s = {3, 7, 13, 49} (s = k/2)
        k = {6, 14, 26, 98} (number of extremal points selected)

    Varying s and k creates specialized implementations hereafter called:
        EPOS-6, EPOS-14, EPOS-26, and EPOS-98
        Where the tightness of fit and computational speed is easily controlled
--]]

local function findExtremalPoints(P, N)
    local extremal = {};
    for k,direction in pairs(N) do
        local extreme = Math:getExtremePointsAlongDirection(direction, P)
        -- push the 2 extreme points from query
        table.insert(extremal, extreme.vmin);
        table.insert(extremal, extreme.vmax);
    end
    return extremal;
end

local function EPOS6(vertices)
    -- 4 < k < n 
    -- n = number of vertices
    -- k = 6 (EPOS-6)
    -- s = 3 (k / 2) = number of normals
    local normals001_3 = {
        {x = 1, y = 0, z = 0}, {x = 0, y = 1, z = 0}, {x = 0, y = 0, z = 0}
    }

    local normals111_4 = {
        {x = 1, y = 1, z = 1}, {x = 1, y = 1, z = -1},
        {x = 1, y = -1, z = 1}, {x = 1, y = -1, z = -1}
    }

    local normals012_12 = {
        {x = 0, y = 1, z = 2}, {x = 0, y = 2, z = 1}, {x = 1, y = 0, z = 2}, 
        {x = 2, y = 0, z = 1}, {x = 1, y = 2, z = 0}, {x = 2, y = 1, z = 0}, 
        {x = 0, y = 1, z = -2}, {x = 0, y = 2, z = -1}, {x = 1, y = 0, z = -2}, 
        {x = 2, y = 0, z = -1}, {x = 1, y = -2, z = 0}, {x = 2, y = -1, z = 0},
    }

    local N = normals001_3; -- s = k/2 normals
    local P = vertices;
    local n = #vertices;
    local k = 6;
    local s = 3; -- s = #N = k/2 normals
    if n > k then
        local E = findExtremalPoints(P, N);
        local SPrime = Math:minimumSphere(E);
        local S = Math:growSphere(P, SPrime);
        print ("S: ", S.c.x, S.c.y, S.c.z, S.r)
        return S;
    else
        return Math:minimumSphere(P);
    end
end

local function createSphereLarssonFromObj(obj) 
    local sphere = EPOS6(obj.vertices);
    print("Larsson sphere: ", sphere.r);
    return SphereCreator:makeSphereMesh(sphere.c, sphere.r);
end

function MOAISphereRitterCreator:create(properties)
    local sphere = require("ResourceManager"):load("Prop", "sphereProp");
    local larssonSpherePath = "../boundingVolumes/SphereLarsson/"..properties.obj.fileName;

    sphere.mesh = require("ResourceManager"):getFromCache(larssonSpherePath);
    if sphere.mesh == nil then
        sphere.mesh = createSphereLarssonFromObj(properties.obj);
        require("ResourceManager"):addToCache(larssonSpherePath, sphere.mesh);
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