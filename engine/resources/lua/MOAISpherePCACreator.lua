local MOAISpherePCACreator = require("./Factory/Creator"):new();
local Factory = nil;
local Math = require("Math");
local SphereCreator = require("SphereCreator");
local Matrix = require("Matrix");


local function eigenSphere(s, vertices)
    local m = Matrix.identity({});
    local v = Matrix.identity({});

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

local function createPCASphere(vertices)
    local s = eigenSphere({}, vertices);
    return Math:growSphere(vertices, s)
end

local function createSpherePCAFromObj(obj) 
    local sphere = createPCASphere(obj.vertices);
    return SphereCreator:makeSphereMesh(sphere.c, sphere.r);
end

local function writePoint(point, file)
    file:write(point.x .. ", " .. point.y .. ", " .. point.z);
end

local function writePointSet(pointSet, file)
    file:write("Point Set: \n\n");
    for k,v in pairs(pointSet) do 
        writePoint(v, file); 
        file:write("\n");
    end
end

local function writeCentroid(pointSet, file)
    --Mean : (1.125, 1.375, 2.125)
    file:write("Mean : ")
    writePoint(Math:getCentroid(pointSet), file);
end

local function writeCovarianceMatrix(pointSet, file)
    --[[
        [Variance Method] : The covariance matrix is :
        16.1094 8.07813 6.98438
        8.07813 13.7344 11.7031
        6.98438 11.7031 11.8594
    --]]
    local m = Matrix.identity({});
    m = Math:covarianceMatrix(m, pointSet);
    Matrix.write(m, file, "[Variance Method] : The covariance matrix is :");
end

local function writeJacobi(pointSet, file)
    file:write("The result of Jacobi method :\n\n");

    local m = Matrix.identity({});
    local v = Matrix.identity({});
    m = Math:covarianceMatrix(m, pointSet);
    m, v = Math:jacobi(m, v);

    Matrix.write(m, file, "[Variance Method] : The matrix is :");
    file:write("\n");
    Matrix.write(v, file, "The Eigenvectors of Jacobi method :")
end

local function test()
    local points1 = {
        {x = -1, y = -1, z = 1},
        {x = -1, y = -1, z = 1},
        {x = -5, y = 4, z = 5},
        {x = 10, y = 10, z = 10},
        {x = 3, y = -2, z = 1},
        {x = 1, y = -1, z = -1},
        {x = 1, y = 1, z = 1},
        {x = 1, y = 1, z = -1}
    }


    -- Covariance
    local file = io.open("../Diff/covariance1diff.txt", "w");
    writePointSet(points1, file);
    file:write("\n")
    writeCentroid(points1, file);
    file:write("\n\n");
    writeCovarianceMatrix(points1, file);
    file:close();

    -- Jacobi
    local file = io.open("../Diff/jacobi1diff.txt", "w");
    writePointSet(points1, file);
    file:write("\n");
    writeJacobi(points1, file);
    file:close();
end

function MOAISpherePCACreator:create(properties)
    --test();
    local sphere = require("ResourceManager"):load("Prop", "sphereProp");
    local PCASpherePath = "../boundingVolumes/SpherePCA/"..properties.obj.fileName;

    sphere.mesh = require("ResourceManager"):getFromCache(PCASpherePath);
    if sphere.mesh == nil then
        sphere.mesh = createSpherePCAFromObj(properties.obj);
        require("ResourceManager"):addToCache(PCASpherePath, sphere.mesh);
    end

    -- if sphere has mesh attached then mesh will be used to create prop
    local newProp = Factory:create(sphere.type, sphere)
    sphere.mesh = nil; -- remove for garbage collector
    newProp.fileName = sphere.fileName;
    return newProp;
end

return function(factory)
    Factory = factory;
    return MOAISpherePCACreator;
end