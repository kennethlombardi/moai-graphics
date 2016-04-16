local Factory = {};
local objectCreators = {}
local Creator = {}

function Creator:new(object)
	object = object or {}
	setmetatable(object, self)
	self.__index = self;
	return object;
end

-- custom creators
local MOAIPropCreator = Creator:new();
local PropContainerCreator = Creator:new();
local MOAILayerCreator = Creator:new();
local MOAILayerDDCreator = Creator:new();
local PropPrototypeCreator = Creator:new();
local MOAIPropPrototypeCreator = Creator:new();
local MOAIPropCubeCreator = Creator:new();
local MOAITextBoxCreator = Creator:new();
local MOAIScriptCreator = Creator:new();
local MOAIShaderCreator = Creator:new();
local MOAISphereCreator = Creator:new();
local MOAITorusCreator = Creator:new();
local MOAIModelCreator = Creator:new();
local MOAIMeshCreator = Creator:new();
local MOAIObjCreator = Creator:new();
--

-- MOAILayerDDCreator
function MOAILayerDDCreator:create(properties)
	local layerdd = Factory:create("Layer", properties);
	layerdd:setCamera(MOAICamera2D.new());

	return layerdd;
end
--

-- MOAILayerCreator
function MOAILayerCreator:create(properties)
	local layer = require "MOAILayerPrototype";
	local newLayer = layer:allocate();
	local newMoaiLayer = MOAILayer.new();
	local newMoaiPartition = MOAIPartition.new();
	newMoaiLayer:setPartition(newMoaiPartition);
	newLayer:setUnderlyingType(newMoaiLayer);
	local propContainer = Factory:create("PropContainer");

	--[[ 
		TODO: 	
			Remove Model hack. This is the only factory method so
			far that is going to return multiple objects
	--]]
	newLayer:setPropContainer(propContainer);
	for k,v in pairs(properties.propContainer) do 
		local newProp = Factory:create(v.type, v);
		if v.type == "Model" then
			for k,v in pairs(newProp) do
				newLayer:insertProp(v)
			end
		else
			newLayer:insertProp(newProp);
		end
	end
	
	-- viewport
    local windowManager = require "WindowManager";
    local screenWidth = windowManager.screenWidth;
    local screenHeight = windowManager.screenHeight;
    local newViewport = MOAIViewport.new();
    newViewport:setSize(screenWidth, screenHeight);
    newViewport:setScale(screenWidth, screenHeight);

    -- camera
    local newCamera = MOAICamera.new();
	newCamera:setFarPlane(25000);

    -- initialize the layer
    newLayer:setViewport(newViewport);
    newLayer:setCamera(newCamera);
    newLayer:setName(properties.name);
    newLayer:setType(properties.type);	
    newLayer:setVisible(properties.visible == "true");
	newLayer:setLoc(properties.position.x, properties.position.y, properties.position.z);

	-- scripts
	for k,scriptName in pairs(properties.scripts) do
		newLayer:registerScript(Factory:createFromFile("Script", scriptName))
	end

	return newLayer;
end

function MOAILayerCreator:createFromFile(fileName)
	dofile "Pickle.lua";
	local newObject;
	local objectIndex = 1;
	function deserialize(className, properties)
		local cucumber = unpickle(properties);
		newObject = Factory:create(cucumber.type, cucumber)
		objectIndex = objectIndex + 1;
	end
	local path = "../layers/"..fileName;
	dofile (path)
	if objectIndex > 2 then print("MORE THAN ONE LAYER IN LAYER FILE: "..path) end;
	return newObject;
end
--

-- MOAIMeshCreator
function MOAIMeshCreator:create(properties)
	local ShapesLibrary = require "ShapesLibrary";
	if properties.type == "PropCube" then
		return ShapesLibrary.makeCube(properties.textureName);
	elseif properties.type == "Sphere" then
		return ShapesLibrary.makeSphere(properties.textureName);
	elseif properties.type == "Torus" then
		return ShapesLibrary.makeTorus(properties.textureName);
	end
	return ShapesLibrary.makeCube(properties.textureName);
end
--

-- MOAIModelCreator
function MOAIModelCreator:create(properties)
	local meshes = Factory:create("Obj", properties);
	local props = {};
	for k,mesh in pairs(meshes) do
		local propPrototype = Factory:create("MOAIPropPrototype", properties);
		local shader = Factory:create("Shader", properties.shaderName);
		propPrototype:setShader(shader, properties.shaderName);
		propPrototype:getUnderlyingType():setDeck(mesh);
		propPrototype:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);
		propPrototype:getUnderlyingType():setCullMode(MOAIProp2D.CULL_BACK)
		table.insert(props, propPrototype);
	end

	return props;
end
--

function test(obj) 
	function makeBoxVbo ( xMin, yMin, zMin, xMax, yMax, zMax )
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
		vbo:setFormat ( vertexFormat )
		vbo:reserveVerts ( 36 )
		
		writeFace ( vbo, p [ 1 ], p [ 2 ], p [ 3 ], p [ 4 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
		writeFace ( vbo, p [ 4 ], p [ 3 ], p [ 7 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
		writeFace ( vbo, p [ 8 ], p [ 7 ], p [ 6 ], p [ 5 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
		writeFace ( vbo, p [ 5 ], p [ 6 ], p [ 2 ], p [ 1 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
		writeFace ( vbo, p [ 5 ], p [ 1 ], p [ 4 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
		writeFace ( vbo, p [ 2 ], p [ 6 ], p [ 7 ], p [ 3 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])

		vbo:bless ()
		
		return vbo
	end

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

	function makeSphereVbo()
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

	function makeMesh(vbo, texture)
	  local ResourceManager = require("ResourceManager");
	  local mesh = MOAIMesh.new();
	  mesh:setTexture(ResourceManager:load("Texture", texture):getUnderlyingType());
	  mesh:setVertexBuffer(vbo);
	  mesh:setPrimType(MOAIMesh.GL_TRIANGLE_STRIP);
	  
	  return mesh;
	end
	
	function makeCubeVbo ( size )
		size = size * 0.5
		return makeBoxVbo ( -size, -size, -size, size, size, size )
	end
	
	return makeMesh(makeSphereVbo(1), "earthWrap.png");
end

function objStreamToVertexAndFaceLists(objStream)
	local faceIndex = 1;
	local function pushFace(faces, v1, v2, v3)
		local face = {v1 = v1, v2 = v2, v3 = v3}
		face.debugInfo = {index = faceIndex};
		faceIndex = faceIndex + 1;
		table.insert(faces, face);
	end

	local vertexIndex = 1;
	local function pushVertex(vertices, x, y, z)
		local vertex = {x = x, y = y, z = z}
		vertex.debugInfo = {name = "["..tostring(vertexIndex).."]"}
		vertexIndex = vertexIndex + 1;
		table.insert(vertices, vertex)
	end
	
	local faces = {};
	local vertices = {};
	local comments = {};
	
	-- handlers
	local handlers = {};
	function handlers:register(key, handler)
		self[key] = handler;
	end
	
	function handlers:handle(key, payload)
		local method = self[key]; --:handle(payload);
		if (method) then method:handle(payload)
		end
	end

	-- commentHandler
	local commentHandler = {}
	function commentHandler:handle(comment)
		table.insert(comments, comment);
	end

	-- vertexHandler
	local vertexHandler = {}
	
	function vertexHandler:handle(vertexString)
		local vertex = {}
		for i in string.gmatch(vertexString, "%S+") do
			if (i ~= 'v') then table.insert(vertex, i); end
		end

		pushVertex(vertices, tonumber(vertex[1]), tonumber(vertex[2]), tonumber(vertex[3]));
	end

	-- faceHandler
	local faceHandler = {}
	function faceHandler:handle(faceString)
		local face = {}
		for i in string.gmatch(faceString, "%S+") do
			if (i ~= 'f') then table.insert(face, i); end
		end
		pushFace(faces, vertices[tonumber(face[1])], vertices[tonumber(face[2])], vertices[tonumber(face[3])]);
	end
	
	-- globalHandler
	local globalHandler = {}
	function globalHandler:handle(global)
	end
	
	handlers:register('v', vertexHandler);
	handlers:register('#', commentHandler);
	handlers:register('f', faceHandler);
	handlers:register('g', globalHandler);
	
	for line in objStream:lines() do
		handlers:handle(line:sub(1, 1), line)
	end
	
	return faces, vertices;
end


local function writeDebugInformation(faces, vertices)
	--for vertexIndex, vertex in pairs(vertices) do
--			vertex.debugInfo = {name = "["..tostring(vertexIndex - 1).."]"}
--			print(vertex.debugInfo.name);
--		end

	for faceIndex, face in pairs(faces) do
		for edgeIndex, edge in pairs(face.halfEdges) do
			edge.debugInfo = {name = "[E"..face.debugInfo.index..":"..tostring(edgeIndex).."]"}
			print(edge.debugInfo.name)
		end
	end
end

local function writeFaceDebugInformation(outfile, faces)
	outfile:write("+=============================".."\n");
	outfile:write("FACES: COUNT="..#faces.."\n");
	outfile:write("------------------------------".."\n\n");
	
	local edgeCount = 0;
	for faceIndex, face in pairs(faces) do
		local e = face.edge;
		outfile:write("Face["..face.debugInfo.index.."] ");
		outfile:write("{");
		outfile:write(e.next.next.head.debugInfo.name);
		outfile:write(e.head.debugInfo.name);
		outfile:write(e.next.head.debugInfo.name);
		outfile:write(" }\n");
		edgeCount = edgeCount + 3;
	end
	
	outfile:write("==============================".."\n")
	outfile:write("EDGES: COUNT="..edgeCount.."\n\n");
	
	for faceIndex, face in pairs(faces) do
		for edgeIndex, edge in pairs(face.halfEdges) do
			outfile:write(edge.debugInfo.name.."\n")
			outfile:write(" VB:"..edge.next.next.head.debugInfo.name.."\n")
			outfile:write(" VF:"..edge.head.debugInfo.name.."\n");
			outfile:write(" PAF:"..edge.next.next.debugInfo.name.."\n");
			outfile:write(" NAF:"..edge.next.debugInfo.name.."\n");
			outfile:write(" T:"..edge.twin.debugInfo.name.."\n");
			outfile:write("\n");
		end
	end
end

--[[
	For each face edge e where an edge = {v1, v2}
		for each e
			create a new half edge he
				he.head = v2
				he.face = currentFace
			push he to face.halfEdges
			if v1 not visited
				set v1.outgoing = he
			memo v1 to v2 as having he
			if reverse (v2 to v1) is in memo. This means we have a twin.
				he.twin = reverse half edge from memo
				reverse half edge from memo.twin = he
		Hook up each half edge in face to form a circular reference to each other
			face.halfEdges[1].next = face.halfEdges[2]
			face.halfEdges[2].next = face.halfEdges[3]
			face.halfEdges[3].next = face.halfEdges[1]
			
		
--]]
function halfEdgeFromFacesAndVertexList(faces, vertices)

	local function createHalfEdge(head, face)
		return {head = head, face = face}
	end

	local function handleFaceEdge(face, v1, v2)
		local he = createHalfEdge(v2, face);
		table.insert(face.halfEdges, he);
		he.face = face;
		face.edge = face.edge or he;
		
		v1.visited = true;
		v1.outgoing = v1.outgoing or he;
		
		v1[v2] = he;
		if v2[v1] ~= nil then
			he.twin = v2[v1];
			v2[v1].twin = he;
		end
		
	end

	for index, face in pairs(faces) do
		face.halfEdges = face.halfEdges or {}
		
		handleFaceEdge(face, face.v1, face.v2);
		handleFaceEdge(face, face.v2, face.v3);
		handleFaceEdge(face, face.v3, face.v1);
		
		face.halfEdges[1].next = face.halfEdges[2]
		face.halfEdges[2].next = face.halfEdges[3]
		face.halfEdges[3].next = face.halfEdges[1]
	end

	-- local path = "../models/";
	-- local outfile = io.open(path.."cubetestout.txt", "wt");
	-- writeDebugInformation(faces, vertices);
	-- writeFaceDebugInformation(outfile, faces);

end

local function createVertexFormat()
	local vertexFormat = MOAIVertexFormat.new()
	vertexFormat:declareCoord(1, MOAIVertexFormat.GL_FLOAT, 3)
	vertexFormat:declareUV(2, MOAIVertexFormat.GL_FLOAT, 2)
	vertexFormat:declareColor(3, MOAIVertexFormat.GL_UNSIGNED_BYTE)
	return vertexFormat;
end

math.randomseed(150)

local function getNextRandomColor()
	local r = 0
	local g = math.random()
	local b = math.random();
	return {r = r, g = g, b = b}
end
	
local function faceBordersHole(face)
	local bordersHole = false
	for edgeIndex, edge in pairs(face.halfEdges) do
		if edge.twin == nil then bordersHole = true; break;
		end
	end
	return bordersHole
end

local function colorFaceIfBordersHole(face, ifColor, ifNotColor)
	local bordersHole = faceBordersHole(face);
	if bordersHole then
		face.v1.bordersHole = true;
		face.v2.bordersHole = true;
		face.v3.bordersHole = true;
	end
end

local function colorEdgeIfBordersHole(edge, ifColor, ifNotColor)
end

function cubeFromPaper(objStream)
	local faces, vertices = objStreamToVertexAndFaceLists(objStream);
	halfEdgeFromFacesAndVertexList(faces, vertices);	
	
	local vertexFormat = createVertexFormat();
	local vbo = MOAIVertexBuffer.new();
	vbo:setFormat(vertexFormat);
	vbo:reserveVerts(19)

	local function writeVertex(vbo, vertex, uv, color)
		vbo:writeFloat(vertex.x, vertex.y, vertex.z)
		vbo:writeFloat(uv.x, uv.y);
		vbo:writeColor32(color.r, color.g, color.b);
	end

	local vertexIndexList = {1,2,3,7,8,6,2,1,3,7,4,8,2,6,1,5,7,6};
	for k,v in pairs(vertexIndexList) do
		writeVertex(vbo, vertices[v], {0, 0, 0}, {1, 0, 0});
	end

	vbo:bless(); 

	local mesh = MOAIMesh.new();
	mesh:setVertexBuffer(vbo);
	mesh:setPrimType(MOAIMesh.GL_TRIANGLE_STRIP);

	local meshes = {mesh}
	print("Mesh count: " .. #meshes)
	
	return meshes;
end

function calculateVertexNormalsUsingOneRingInformation(faces, vertices)
	function cross(a, b)
		local result = {x = 0, y = 0, z = 0};
		result.x = a.y * b.z - a.z * b.y
		result.y = a.z * b.x - a.x * b.z
		result.z = a.x * b.y - a.y * b.x
		return result;
	end
	
	function sub(a, b)
		local result = {};
		result.x = a.x - b.x;
		result.y = a.y - b.y;
		result.z = a.z - b.z;
		return result
	end
	
	function processOneRing(center, neighborhood)
		local h = center.outgoing;
		if h == nil then
			return;
		end
		local hstop = h;
		
		local v = h.head;
		table.insert(neighborhood, v);
		h = h.twin
		
		while h ~= hstop do
			if h == nil then break; end;
			local v = h.head;
			table.insert(neighborhood, v);
			h = h.twin
		end
			
	end
		
	function averageNormalFromNeighborhood(center, neighborhood)
		if #neighborhood < 1 then return {x = 0, y = 0, z = 0} end
			
		local vector1 = sub(center, neighborhood[1]);
		local normals = {};
		
		for i = 2, #neighborhood do
			local vector2 = sub(center, neighborhood[i]);
			table.insert(normals, cross(vector2, vector1));
			vector1 = vector2;
		end
		
		local average = {x = 0, y = 0, z = 0};
		for i, normal in pairs(normals) do
			average.x = average.x + normal.x;
			average.y = average.y + normal.y;
			average.z = average.z + normal.z;
		end
		average.x = average.x / #normals;
		average.y = average.y / #normals;
		average.z = average.z / #normals;
		return average;
	end
	
	for i, center in pairs(vertices) do	
		local neighborhood = {};
		processOneRing(center, neighborhood);
		center.normal = averageNormalFromNeighborhood(center, neighborhood)
	end
	
end

function objStreamToMeshes(objStream)
	local faces, vertices = objStreamToVertexAndFaceLists(objStream);
	halfEdgeFromFacesAndVertexList(faces, vertices);	
	--calculateVertexNormalsUsingOneRingInformation(faces, vertices);
	
	for i, face in pairs(faces) do
		colorFaceIfBordersHole(face, {r = 1, g = 0, b = 0}, {r = 0, g = 1, b = 0});
	end
	
	local visitedFaces = {}
	local currentFaceIndex = 1;
	local function getNextFace()
		local face = faces[currentFaceIndex];
		if not face.visited then 
			currentFaceIndex = currentFaceIndex + 1;
			return face 
		end
		while face.visited do
			currentFaceIndex = currentFaceIndex + 1;
			face = faces[currentFaceIndex];
			if face == nil then
				return nil;
			end
			
			if not face.visited then
				currentFaceIndex = currentFaceIndex + 1;
				return face;
			end
		end
		return nil
	end

	local faceVisitCount = 0;
	local function allFacesVisited()
		return faceVisitCount >= #faces
	end
	
	local function markFaceVisited(face)
		if not face.visited then
			face.visited = true;
			faceVisitCount = faceVisitCount + 1;
		end
	end

	local vertexFormat = createVertexFormat();
	local meshes = {}
	
	while not allFacesVisited() do
		local triangleStrip = {};
	
		local n = 1;
		local currentFace = getNextFace();
		if currentFace == nil then
			break; -- all faces visited
		end

		local current = currentFace.v1;	
		local e = current.outgoing;
		local ePrime = e.next;
		table.insert(triangleStrip, current);
		table.insert(triangleStrip, e.head);
		table.insert(triangleStrip, ePrime.head)
		markFaceVisited(ePrime.face)
		
		while not allFacesVisited() do
			n = n + 1;
			
			ePrime = ePrime.twin;
			if ePrime == nil then 
				break; 
			end;

			table.insert(triangleStrip, ePrime.next.head);
			
			if n % 2 == 0 then
				ePrime = ePrime.next.next;
			else
				ePrime = ePrime.next;
			end
			
			markFaceVisited(ePrime.face);
		end

		local function writeVertex(vbo, vertex, uv, color)
			vbo:writeFloat(vertex.x, vertex.y, vertex.z)
			vbo:writeFloat(uv.x, uv.y);
			vbo:writeColor32(color.r, color.g, color.b);
		end

		local vbo = MOAIVertexBuffer.new();
		vbo:setFormat(vertexFormat);
		vbo:reserveVerts(#triangleStrip);

		local borderColor = {r = 1, g = 0, b = 0};
		local notBorderColor = getNextRandomColor();
		for i, vertex in pairs(triangleStrip) do
			if vertex.bordersHole then
				color = borderColor;
			else
				color = notBorderColor;
			end
			writeVertex(vbo, vertex, {0, 0, 0}, color);
		end

		vbo:bless();

		local mesh = MOAIMesh.new();
		mesh:setVertexBuffer(vbo);
		mesh:setPrimType(MOAIMesh.GL_TRIANGLE_STRIP);
		table.insert(meshes, mesh);
		print("Mesh count: ", #meshes);
	end

	print("Mesh count: " .. #meshes)
	return meshes;
end

local function objStreamToMesh(objStream) 
	local faces, vertices = objStreamToVertexAndFaceLists(objStream);
	halfEdgeFromFacesAndVertexList(faces, vertices);
	local vertexFormat = createVertexFormat();
	local vbo = MOAIVertexBuffer.new()
	vbo:setFormat(vertexFormat)
	vbo:reserveVerts(3 * #faces);
	
	local function writeVertex(vbo, vertex, uv, color)
		vbo:writeFloat(vertex.x, vertex.y, vertex.z)
		vbo:writeFloat(uv.x, uv.y);
		vbo:writeColor32(color.r, color.g, color.b);
	end
	
	for index, face in pairs(faces) do
		colorFaceIfBordersHole(face, {r = 1, g = 0, b = 0}, {r = 0, g = 1, b = 0});
		local e = face.halfEdges[1];
		writeVertex(vbo, e.head, {x = 0, y = 0}, face.color)
		writeVertex(vbo, e.next.head, {x = 0, y = 0}, face.color)
		writeVertex(vbo, e.next.next.head, {x = 0, y = 0}, face.color)
	end
	
	vbo:bless()
	
	local mesh = MOAIMesh.new();
	mesh:setVertexBuffer(vbo);
	mesh:setPrimType(MOAIMesh.GL_TRIANGLES);
	
	return mesh;
end

-- MOAIObjCreator
function MOAIObjCreator:create(properties)
	local triangleStrip = true;
	local objStream = require("ResourceManager"):load("ObjFileStream", properties.fileName); 
	local meshes;
	if triangleStrip then 
		meshes = objStreamToMeshes(objStream);
	else
		meshes = {}
		table.insert(meshes, objStreamToMesh(objStream))
	end
	objStream:close();
	for i,mesh in pairs(meshes) do
		mesh:setTexture(require("ResourceManager"):load("Texture", properties.textureName):getUnderlyingType());
	end
	
	return meshes;
end
-- MOAIObjCreator

-- MOAIPropCreator
function MOAIPropCreator:create(properties)
	-- gfx quad with texture
	local gfxQuad = MOAIGfxQuad2D.new ()
	local texture = require("ResourceManager"):load("Texture", properties.textureName);
	gfxQuad:setTexture(texture:getUnderlyingType());
	gfxQuad:setRect(
		-texture:getSize().x * properties.scale.x, 
		-texture:getSize().y * properties.scale.y, 
		texture:getSize().x * properties.scale.x, 
		texture:getSize().y * properties.scale.y );
	gfxQuad:setUVRect(0, 1, 1, 0)

	local propPrototype = Factory:create("MOAIPropPrototype", properties);
	propPrototype:getUnderlyingType():setDeck(gfxQuad);
	propPrototype:setSize(texture:getSize().x, texture:getSize().y, 1);
	return propPrototype;
end
--

-- MOAIPropCubeCreator
function MOAIPropCubeCreator:create(properties)
	return Factory:create("Model", properties);
end
--

-- MOAIPropPrototypeCreator
function MOAIPropPrototypeCreator:create(properties)
	local propPrototype = require "MOAIPropPrototype";
	local newObject = propPrototype:allocate();

	newObject:setUnderlyingType(MOAIProp.new());
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	properties.scale = properties.scale or newObject.scale;
	properties.size = properties.size or newObject.size;
	properties.rotation = properties.rotation or newObject.rotation;
	newObject:setSize(properties.size.x, properties.size.y, properties.size.z);
	newObject:setScl(properties.scale.x, properties.scale.y, properties.scale.z);
	newObject:setLoc(properties.position.x, properties.position.y, properties.position.z);
	newObject:setRot(properties.rotation.x, properties.rotation.y, properties.rotation.z);

	newObject:setTextureName(properties.textureName);
	newObject:getUnderlyingType():setDepthTest(MOAIProp.DEPTH_TEST_LESS_EQUAL);

	-- register scripts
	for k,scriptName in pairs(properties.scripts or {}) do
		newObject:registerScript(Factory:createFromFile("Script", scriptName));
	end

	-- shader
	local shader = Factory:create("Shader", properties.shaderName);
	newObject:setShader(shader, properties.shaderName);

	return newObject;
end
--

-- MOAIPropTorusCreator
function MOAITorusCreator:create(properties)
	return Factory:create("Model", properties);
end
--

-- MOAIScriptCreator
function MOAIScriptCreator:create(properties)
	return Factory:createFromFile("Script", properties.fileName);
end

function MOAIScriptCreator:createFromFile(fileName)
	return require("ResourceManager"):load("Script", fileName);
end
--

-- MOAIShaderCreator
function MOAIShaderCreator:create(fileName) -- Change this to properties 
	if (fileName == "MESH_SHADER") then return MOAIShaderMgr.getShader(MOAIShaderMgr.MESH_SHADER) end
	return require("ResourceManager"):load("Shader", fileName);
end
--

-- MOAISphereCreator
function MOAISphereCreator:create(properties)
	return Factory:create("Model", properties);
end
--

-- MOAITextBoxCreator
function MOAITextBoxCreator:create(properties)
	local MOAITextBoxPrototype = require("MOAITextBoxPrototype");
	local newObject = MOAITextBoxPrototype:allocate();
	
	newObject:setUnderlyingType(MOAITextBox.new());
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	newObject:setScl(properties.scale.x, properties.scale.y, properties.scale.z);
	newObject:setLoc(properties.position.x, properties.position.y, properties.position.z);
	newObject:setFont(require("ResourceManager"):load("Font", properties.fileName));

	newObject:setTextSize(properties.textSize);
	newObject:setRect( 	properties.rectangle.x1, 
						properties.rectangle.y1, 
						properties.rectangle.x2, 
						properties.rectangle.y2 );
	
	if properties.justification == "left_justify" then
		newObject:getUnderlyingType():setAlignment(MOAITextBox.LEFT_JUSTIFY)
	elseif properties.justification == "center_justify" then
		newObject:getUnderlyingType():setAlignment(MOAITextBox.CENTER_JUSTIFY)
	else 
		newObject:getUnderlyingType():setAlignment(MOAITextBox.RIGHT_JUSTIFY)
	end

	newObject:getUnderlyingType():setYFlip(true)
	newObject:setText(properties.string);

	for k,scriptName in pairs(properties.scripts) do
		newObject:registerScript(Factory:createFromFile("Script", scriptName));
	end

	return newObject;
end
--

-- PropContainerCreator
function PropContainerCreator:create(properties)
	propContainerPrototype = require "PropContainerPrototype";
	return propContainerPrototype:allocate();
end
--

-- PropPrototypeCreator
function PropPrototypeCreator:create(properties)
	local propPrototype = require "PropPrototype";
	local newObject = propPrototype:new();
	newObject:setName(properties.name);
	newObject:setType(properties.type);
	return newObject;
end
--

-- Factory methods
function Factory:createFromFile(objectType, fileName)
	return objectCreators[objectType]:createFromFile(fileName);
end

function Factory:create(objectType, properties)
	return objectCreators[objectType]:create(properties);
end

function Factory:register(objectType, creator)
	objectCreators[objectType] = creator;
end
--

local function initialize()
	Factory:register("PropPrototype", PropPrototypeCreator:new());
	Factory:register("MOAIPropPrototype", MOAIPropPrototypeCreator:new());
	Factory:register("Prop", MOAIPropCreator:new());
	Factory:register("PropContainer", PropContainerCreator:new());
	Factory:register("Layer", MOAILayerCreator:new());
	Factory:register("LayerDD", MOAILayerDDCreator:new());
	Factory:register("PropCube", MOAIPropCubeCreator:new());
	Factory:register("TextBox", MOAITextBoxCreator:new());
	Factory:register("Script", MOAIScriptCreator:new());
	Factory:register("Shader", MOAIShaderCreator:new());
	Factory:register("Sphere", MOAISphereCreator:new());
	Factory:register("Torus", MOAITorusCreator:new());
	Factory:register("Model", MOAIModelCreator:new());
	Factory:register("Mesh", MOAIMeshCreator:new());
	Factory:register("Obj", MOAIObjCreator:new());
end

initialize();

return Factory;


