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
    -- vbo:setFormat(vertexFormat)
    vbo:reserve(3 * #faces);

    local function writeVertex(vbo, vertex, uv, color)
        vbo:writeFloat(vertex.x, vertex.y, vertex.z)
        vbo:writeFloat(uv.x, uv.y);
        vbo:writeColor32(color.r, color.g, color.b);
    end

    local color = {r = 0, g = 1, b = 0};
    for index, face in pairs(faces) do
        writeVertex(vbo, face.v1, {x = 0, y = 0}, color)
        writeVertex(vbo, face.v2, {x = 0, y = 0}, color)
        writeVertex(vbo, face.v3, {x = 0, y = 0}, color)
    end

    -- vbo:bless()

    local mesh = MOAIMesh.new();
    mesh:setVertexBuffer(vbo, vertexFormat);
    mesh:setPrimType(MOAIMesh.GL_TRIANGLES);

    return mesh;
end

-- MOAIModelCreator
function MOAIModelCreator:create(properties)
    if not properties.mesh then
        local obj = Factory:create("Obj", properties);
        properties.mesh = objToMesh(obj)
    end
    properties.mesh:setTexture(require("ResourceManager"):load("Texture", properties.textureName):getUnderlyingType());
    local propPrototype = Factory:create("MOAIPropPrototype", properties);
    local shader = Factory:create("Shader", properties.shaderName);
    propPrototype:setShader(shader, properties.shaderName);
    propPrototype:getUnderlyingType():setDeck(properties.mesh);
    propPrototype:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);
    --propPrototype:getUnderlyingType():setCullMode(MOAIProp2D.CULL_baCK)

    return propPrototype;
end
--

return function(factory)
    Factory = factory;
    return MOAIModelCreator;
end
