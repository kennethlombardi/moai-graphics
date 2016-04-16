local MOAIAABBCreator = require("./Factory/Creator"):new();
local Factory = nil;
local Math = require("Math");

local function pushPoint(points, x, y, z)
    local point = {};
    point.x = x;
    point.y = y;
    point.z = z;

    table.insert(points, point);
end

local function writeTri (vbo, p1, p2, p3, uv1, uv2, uv3)
    vbo:writeFloat(p1.x, p1.y, p1.z);
    vbo:writeFloat(uv1.x, uv1.y);
    vbo:writeColor32(1,1,1);

    vbo:writeFloat(p2.x, p2.y, p2.z);
    vbo:writeFloat(uv2.x, uv2.y);
    vbo:writeColor32(1,1,1);

    vbo:writeFloat(p3.x, p3.y, p3.z);
    vbo:writeFloat(uv3.x, uv3.y);
    vbo:writeColor32(1,1,1);
end

local function writeFace ( vbo, p1, p2, p3, p4, uv1, uv2, uv3, uv4 )
    writeTri ( vbo, p1, p2, p4, uv1, uv2, uv4 )
    writeTri ( vbo, p2, p3, p4, uv2, uv3, uv4 )
end

local function makeCubeMesh(properties, extremal)
    local p = {};
    -- pushPoint(p, -properties.x, properties.y, properties.z); --p1
    -- pushPoint(p, -properties.x, -properties.y, properties.z); --p2
    -- pushPoint(p, properties.x, -properties.y, properties.z); --p3
    -- pushPoint(p, properties.x, properties.y, properties.z); --p4
    -- pushPoint(p, -properties.x, properties.y, -properties.z); --p5
    -- pushPoint(p, -properties.x, -properties.y, -properties.z); --p6
    -- pushPoint(p, properties.x, -properties.y, -properties.z); --p7
    -- pushPoint(p, properties.x, properties.y, -properties.z); --p8

    pushPoint(p, extremal.x.vmin.x, extremal.y.vmax.y, extremal.z.vmax.z); --p1
    pushPoint(p, extremal.x.vmin.x, extremal.y.vmin.y, extremal.z.vmax.z); --p2
    pushPoint(p, extremal.x.vmax.x, extremal.y.vmin.y, extremal.z.vmax.z); --p3
    pushPoint(p, extremal.x.vmax.x, extremal.y.vmax.y, extremal.z.vmax.z); --p4
    pushPoint(p, extremal.x.vmin.x, extremal.y.vmax.y, extremal.z.vmin.z); --p5
    pushPoint(p, extremal.x.vmin.x, extremal.y.vmin.y, extremal.z.vmin.z); --p6
    pushPoint(p, extremal.x.vmax.x, extremal.y.vmin.y, extremal.z.vmin.z); --p7
    pushPoint(p, extremal.x.vmax.x, extremal.y.vmax.y, extremal.z.vmin.z); --p8

    local uv = {};
    pushPoint(uv, 0, 0, 0);
    pushPoint(uv, 0, 1, 0);
    pushPoint(uv, 1, 1, 0);
    pushPoint(uv, 1, 0, 0);

    local vertexFormat = MOAIVertexFormat.new();
    vertexFormat:declareCoord(1, MOAIVertexFormat.GL_FLOAT, 3);
    vertexFormat:declareUV(2, MOAIVertexFormat.GL_FLOAT, 2);
    vertexFormat:declareColor(3, MOAIVertexFormat.GL_UNSIGNED_BYTE);

    local vbo = MOAIVertexBuffer.new();
    -- vbo:setFormat(vertexFormat);
    vbo:reserve(36);

    writeFace ( vbo, p [ 1 ], p [ 2 ], p [ 3 ], p [ 4 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 4 ], p [ 3 ], p [ 7 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 8 ], p [ 7 ], p [ 6 ], p [ 5 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 5 ], p [ 6 ], p [ 2 ], p [ 1 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 5 ], p [ 1 ], p [ 4 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 2 ], p [ 6 ], p [ 7 ], p [ 3 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])

    -- vbo:bless ()

    local mesh = MOAIMesh.new();
    mesh:setVertexBuffer(vbo, vertexFormat);
    mesh:setPrimType(MOAIMesh.GL_TRIANGLES);
    return mesh, {vertices = p};
end

function Dot(position, direction)
    return position.x * direction.x + position.y * direction.y + position.z * direction.z;
end

local function createAABBFromObj(obj, fileName)
    local extremePoints = {
        x = Math:getExtremePointsAlongDirection({x = 1, y = 0 , z = 0}, obj.vertices),
        y = Math:getExtremePointsAlongDirection({x = 0, y = 1 , z = 0}, obj.vertices),
        z = Math:getExtremePointsAlongDirection({x = 0, y = 0 , z = 1}, obj.vertices),
    }
    local mesh, obj = makeCubeMesh({x = .5, y = .5, z = .5}, extremePoints);
    obj.extremePoints = extremePoints;
    return mesh, obj
end

local function createAABBFromOBJs(objs, fileName)
    local vertices = {}
    for k,obj in pairs(objs) do
        local x = Math:getExtremePointsAlongDirection({x = 1, y = 0 , z = 0}, obj.vertices);
        local y = Math:getExtremePointsAlongDirection({x = 0, y = 1 , z = 0}, obj.vertices);
        local z = Math:getExtremePointsAlongDirection({x = 0, y = 0 , z = 1}, obj.vertices);
        table.insert(vertices, x.vmin);
        table.insert(vertices, x.vmax);
        table.insert(vertices, y.vmin);
        table.insert(vertices, y.vmax);
        table.insert(vertices, z.vmin);
        table.insert(vertices, z.vmax);
    end
    return createAABBFromObj({vertices = vertices})
end

function MOAIAABBCreator:create(properties)
    local cube = require("ResourceManager"):load("Prop", "cubeProp");
    local fileName = properties.obj and properties.obj.fileName or properties.fileName;

    if not properties.objs then
        properties.objs = {properties.obj};
    end
    cube.mesh, cube.obj = createAABBFromOBJs(properties.objs, fileName);

    -- if cube has mesh attached then mesh will be used to create prop
    local newProp = Factory:create(cube.type, cube)
    cube.mesh = nil; -- remove for garbage collector
    newProp.fileName = properties.fileName;
    newProp.bvObj = cube.obj;

    return newProp
end

return function(factory)
    Factory = factory;
    return MOAIAABBCreator;
end
