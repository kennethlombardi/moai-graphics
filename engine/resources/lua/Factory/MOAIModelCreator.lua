local MOAIModelCreator = require("./Factory/Creator"):new();
local Factory = nil;

local function createVertexFormat()
    local vertexFormat = MOAIVertexFormat.new()
    vertexFormat:declareCoord(1, MOAIVertexFormat.GL_FLOAT, 3)
    vertexFormat:declareUV(2, MOAIVertexFormat.GL_FLOAT, 2)
    vertexFormat:declareColor(3, MOAIVertexFormat.GL_UNSIGNED_BYTE)
    return vertexFormat;
end

local function objToMesh(obj)
    local faces = obj.faces;
    local vertexFormat = createVertexFormat();
    local vbo = MOAIVertexBuffer.new()
    vbo:reserve(3 * #faces * vertexFormat:getVertexSize());

    local vertexCount = 0;
    local function writeVertex(vbo, vertex, uv, color)
        vbo:writeFloat(vertex.x, vertex.y, vertex.z)
        vbo:writeFloat(uv.x, uv.y);
        vbo:writeColor32(color.r, color.g, color.b);
        vertexCount = vertexCount + 1;
    end

    local color = {r = 0, g = 1, b = 0};
    for index, face in pairs(faces) do
        writeVertex(vbo, face.v1, {x = 0, y = 0}, color)
        writeVertex(vbo, face.v2, {x = 0, y = 0}, color)
        writeVertex(vbo, face.v3, {x = 0, y = 0}, color)
    end

    local mesh = MOAIMesh.new();
    mesh:setVertexBuffer(vbo, vertexFormat);
    mesh:setPrimType(MOAIMesh.GL_TRIANGLES);
    mesh:setTotalElements ( vbo:countElements ( vertexFormat ))
    mesh:setBounds ( vbo:computeBounds ( vertexFormat ))
    return mesh;
    -- return makeCube(128);
end

function makeBoxMesh ( xMin, yMin, zMin, xMax, yMax, zMax, texture )

    local function pushPoint ( points, x, y, z )

        local point = {}
        point.x = x
        point.y = y
        point.z = z

        table.insert ( points, point )
    end

    local function writeTri ( vbo, p1, p2, p3, uv1, uv2, uv3 )

        vbo:writeFloat ( p1.x, p1.y, p1.z )
        vbo:writeFloat ( uv1.x, uv1.y )
        vbo:writeColor32 ( 1, 1, 1 )

        vbo:writeFloat ( p2.x, p2.y, p2.z )
        vbo:writeFloat ( uv2.x, uv2.y )
        vbo:writeColor32 ( 1, 1, 1 )

        vbo:writeFloat ( p3.x, p3.y, p3.z )
        vbo:writeFloat ( uv3.x, uv3.y  )
        vbo:writeColor32 ( 1, 1, 1 )
    end

    local function writeFace ( vbo, p1, p2, p3, p4, uv1, uv2, uv3, uv4 )

        writeTri ( vbo, p1, p2, p4, uv1, uv2, uv4 )
        writeTri ( vbo, p2, p3, p4, uv2, uv3, uv4 )
    end

    local p = {}

    pushPoint ( p, xMin, yMax, zMax ) -- p1
    pushPoint ( p, xMin, yMin, zMax ) -- p2
    pushPoint ( p, xMax, yMin, zMax ) -- p3
    pushPoint ( p, xMax, yMax, zMax ) -- p4

    pushPoint ( p, xMin, yMax, zMin ) -- p5
    pushPoint ( p, xMin, yMin, zMin  ) -- p6
    pushPoint ( p, xMax, yMin, zMin  ) -- p7
    pushPoint ( p, xMax, yMax, zMin  ) -- p8

    local uv = {}

    pushPoint ( uv, 0, 0, 0 )
    pushPoint ( uv, 0, 1, 0 )
    pushPoint ( uv, 1, 1, 0 )
    pushPoint ( uv, 1, 0, 0 )

    local vertexFormat = MOAIVertexFormat.new ()
    vertexFormat:declareCoord ( 1, MOAIVertexFormat.GL_FLOAT, 3 )
    vertexFormat:declareUV ( 2, MOAIVertexFormat.GL_FLOAT, 2 )
    vertexFormat:declareColor ( 3, MOAIVertexFormat.GL_UNSIGNED_BYTE )

    local vbo = MOAIVertexBuffer.new ()
    vbo:reserve ( 36 * vertexFormat:getVertexSize ())
    print("VERTEX RESERVE", vertexFormat:getVertexSize(), vertexFormat:getVertexSize() * 36);
    writeFace ( vbo, p [ 1 ], p [ 2 ], p [ 3 ], p [ 4 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 4 ], p [ 3 ], p [ 7 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 8 ], p [ 7 ], p [ 6 ], p [ 5 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 5 ], p [ 6 ], p [ 2 ], p [ 1 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 5 ], p [ 1 ], p [ 4 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
    writeFace ( vbo, p [ 2 ], p [ 6 ], p [ 7 ], p [ 3 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])

    local mesh = MOAIMesh.new ()
    -- mesh:setTexture ( texture )

    mesh:setVertexBuffer ( vbo, vertexFormat )
    mesh:setTotalElements ( vbo:countElements ( vertexFormat ))
    mesh:setBounds ( vbo:computeBounds ( vertexFormat ))

    mesh:setPrimType ( MOAIMesh.GL_TRIANGLES )
    -- mesh:setShader ( MOAIShaderMgr.getShader ( MOAIShaderMgr.MESH_SHADER ))

    return mesh
end

function makeCube ( size, texture )
    size = size * 0.5
    return makeBoxMesh ( -size, -size, -size, size, size, size, texture )
end

-- MOAIModelCreator
function MOAIModelCreator:create(properties)
    if not properties.mesh then
        local obj = Factory:create("Obj", properties);
        properties.mesh = objToMesh(obj)
        -- properties.mesh = makeCube ( 128, 'moai.png' )
    end
    properties.mesh:setTexture(require("ResourceManager"):load("Texture", properties.textureName):getUnderlyingType());
    local propPrototype = Factory:create("MOAIPropPrototype", properties);
    local shader = Factory:create("Shader", properties.shaderName);
    propPrototype:setShader(shader, properties.shaderName);
    propPrototype:getUnderlyingType():setDeck(properties.mesh);
    propPrototype:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);
    -- propPrototype:getUnderlyingType():setCullMode(MOAIProp2D.CULL_BACK)

    return propPrototype;
end
--

return function(factory)
    Factory = factory;
    return MOAIModelCreator;
end
