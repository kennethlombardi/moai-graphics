local SphereCreator = {}

function writeTri(vbo, p1, p2, p3, uv1, uv2, uv3, offset)
  vbo:writeFloat(p1.x + offset.x, p1.y + offset.y, p1.z + offset.z);
  vbo:writeFloat(uv1.x, uv1.y);
  vbo:writeColor32(1,1,1);

  vbo:writeFloat(p2.x + offset.x, p2.y + offset.y, p2.z + offset.z);
  vbo:writeFloat(uv2.x, uv2.y);
  vbo:writeColor32(1,1,1);

  vbo:writeFloat(p3.x + offset.x, p3.y + offset.y, p3.z + offset.z);
  vbo:writeFloat(uv3.x, uv3.y);
  vbo:writeColor32(1,1,1);
end

function writeFace(vbo, p1, p2, p3, p4, uv1, uv2, uv3, uv4, offset)
  writeTri(vbo, p1, p2, p4, uv1, uv2, uv4, offset)
  writeTri(vbo, p2, p3, p4, uv2, uv3, uv4, offset)
end

function pushPoint(points, x, y, z)
  local point = {};
  point.x = x;
  point.y = y;
  point.z = z;

  table.insert(points, point);
end

function SphereCreator:makeSphereMesh(c, r)
    local radius = r;
    local center = c;
    local p = {};
    local uv = {};
    local stacks = 30;
    local slices = 30;
    local PI = 3.14159265359;
    local HALFPI = PI/2;
    local count = 0;
    for i = 0,  stacks, 1 do
        local y1 = i / stacks;
        local y2 = (i + 1) / stacks;

        local b1 = HALFPI - (y1 * PI);
        local b2 = HALFPI - (y2 * PI);

        local cosb1 = math.cos(b1);
        local sinb1 = math.sin(b1);
        local cosb2 = math.cos(b2);
        local sinb2 = math.sin(b2);

        for j = 0, slices, 1 do
            local x1 = j / slices;
            local a1 = x1 * 2*PI;

            local cosa1 = math.cos(a1);
            local sina1 = math.sin(a1);

            pushPoint(p,
                        radius * sina1 * cosb1,
                        radius * sinb1        ,
                        radius * cosa1 * cosb1);

            pushPoint(p,
                        radius * sina1 * cosb2,
                        radius * sinb2        ,
                        radius * cosa1 * cosb2);
            pushPoint(uv, x1, y1, 0);
            pushPoint(uv, x1, y2, 0);
            count = count + 2;
        end
    end

    local vertexFormat = MOAIVertexFormat.new ()
    vertexFormat:declareCoord ( 1, MOAIVertexFormat.GL_FLOAT, 3 )
    vertexFormat:declareUV ( 2, MOAIVertexFormat.GL_FLOAT, 2 )
    vertexFormat:declareColor ( 3, MOAIVertexFormat.GL_UNSIGNED_BYTE )

    local vbo = MOAIVertexBuffer.new();
    -- vbo:setFormat(vertexFormat);
    vbo:reserve(stacks*slices*8);

    for i = 0, stacks-1, 1 do
    local k = 0;
        for j = 0, slices-1, 1 do
          k = (j*2) + (i * 2*(slices+1));
          writeFace(vbo, p[k+1], p[k+2], p[k+4], p[k+3], uv[k+1], uv[k+2], uv[k+4], uv[k+3], center);
        end
    end
    -- vbo:bless();
    local mesh = MOAIMesh.new();
    mesh:setVertexBuffer(vbo, vertexFormat);
    mesh:setPrimType(MOAIMesh.GL_TRIANGLES);
    return mesh;
end

return SphereCreator;
