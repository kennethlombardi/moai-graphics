local ShapesLibrary = {};

function pushPoint(points, x, y, z)
  local point = {};
  point.x = x;
  point.y = y;
  point.z = z;
  
  table.insert(points, point);
end

function writeTri (vbo, p1, p2, p3, uv1, uv2, uv3)
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

function writeFace ( vbo, p1, p2, p3, p4, uv1, uv2, uv3, uv4 )

  writeTri ( vbo, p1, p2, p4, uv1, uv2, uv4 )
  writeTri ( vbo, p2, p3, p4, uv2, uv3, uv4 )
end

function makeCubeMesh()
  local p = {};
  local defaultScale = .5;
  pushPoint(p, -defaultScale, defaultScale, defaultScale); --p1
  pushPoint(p, -defaultScale, -defaultScale, defaultScale); --p2
  pushPoint(p, defaultScale, -defaultScale, defaultScale); --p3
  pushPoint(p, defaultScale, defaultScale, defaultScale); --p4
  pushPoint(p, -defaultScale, defaultScale, -defaultScale); --p5
  pushPoint(p, -defaultScale, -defaultScale, -defaultScale); --p6
  pushPoint(p, defaultScale, -defaultScale, -defaultScale); --p7
  pushPoint(p, defaultScale, defaultScale, -defaultScale); --p8
  
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
  vbo:setFormat(vertexFormat);
  vbo:reserveVerts(36);
  
  writeFace ( vbo, p [ 1 ], p [ 2 ], p [ 3 ], p [ 4 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 4 ], p [ 3 ], p [ 7 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 8 ], p [ 7 ], p [ 6 ], p [ 5 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 5 ], p [ 6 ], p [ 2 ], p [ 1 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 5 ], p [ 1 ], p [ 4 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 2 ], p [ 6 ], p [ 7 ], p [ 3 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])

	vbo:bless ()
  
  return vbo;
end

ShapesLibrary.cubeMesh = makeCubeMesh();

function ShapesLibrary.makeCube(texture)
  local ResourceManager = require("ResourceManager");
  local mesh = MOAIMesh.new();
  mesh:setTexture(ResourceManager:load("Texture", texture):getUnderlyingType());
  mesh:setVertexBuffer(ShapesLibrary.cubeMesh);
  mesh:setPrimType(MOAIMesh.GL_TRIANGLES);
  
  return mesh;
end

function makeSphereMesh()
  local radius = .5;
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
      
      pushPoint(p, radius * sina1 * cosb1, 
                   radius * sinb1, 
                   radius * cosa1 * cosb1);
                   
      pushPoint(p, radius * sina1 * cosb2, 
                   radius * sinb2, 
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
  vbo:setFormat(vertexFormat);
  vbo:reserveVerts(stacks*slices*8);
  
  for i = 0, stacks-1, 1 do
	local k = 0;
    for j = 0, slices-1, 1 do
      k = (j*2) + (i * 2*(slices+1));	  
	  writeFace(vbo, p[k+1], p[k+2], p[k+4], p[k+3], uv[k+1], uv[k+2], uv[k+4], uv[k+3]);	  
    end    	
  end
  vbo:bless();
  
  return vbo;
end

ShapesLibrary.sphereMesh = makeSphereMesh();

function ShapesLibrary.makeSphere(texture)
  local ResourceManager = require("ResourceManager");
  local mesh = MOAIMesh.new();
  mesh:setTexture(ResourceManager:load("Texture", texture):getUnderlyingType());
  mesh:setVertexBuffer(ShapesLibrary.sphereMesh);
  mesh:setPrimType(MOAIMesh.GL_TRIANGLES);
  
  return mesh;
end

function makeTorusMesh()
  local radius = .5;
  local innerRadius = radius * .7;
  local thickness = radius - innerRadius;	
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
      
      pushPoint(p, radius * sina1 + thickness * sina1 * cosb1, 
                   radius * sinb1, 
                   radius * cosa1 + thickness * cosa1 * cosb1);
                   
      pushPoint(p, radius * sina1 + thickness * sina1 * cosb2, 
                   radius * sinb2, 
                   radius * cosa1 + thickness * cosa1 * cosb2);
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
  vbo:setFormat(vertexFormat);
  vbo:reserveVerts(stacks*slices*8);
  
  for i = 0, stacks-1, 1 do
	local k = 0;
    for j = 0, slices-1, 1 do
      k = (j*2) + (i * 2*(slices+1));	  
	  writeFace(vbo, p[k+1], p[k+2], p[k+4], p[k+3], uv[k+1], uv[k+2], uv[k+4], uv[k+3]);	  
    end    	
  end
  vbo:bless();
  
  return vbo;
end

ShapesLibrary.torusMesh = makeTorusMesh();

function ShapesLibrary.makeTorus(texture)
  local ResourceManager = require("ResourceManager");
  local mesh = MOAIMesh.new();
  mesh:setTexture(ResourceManager:load("Texture", texture):getUnderlyingType());
  mesh:setVertexBuffer(ShapesLibrary.torusMesh);
  mesh:setPrimType(MOAIMesh.GL_TRIANGLES);
  
  return mesh;
end

function ShapesLibrary:shutdown()
	ShapesLibrary.torusMesh = nil;
	ShapesLibrary.sphereMesh= nil;
	ShapesLibrary.cubeMesh = nil;
end

return ShapesLibrary;