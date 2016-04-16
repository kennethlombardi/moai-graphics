local Scene = {}

local LayerManager = require("LayerManager");
local Factory = require("./Factory/Factory");
local Math = require("Math")
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables")
local MIN_FACES = UserDataManager:get("MIN_FACES");
local SHOW_SPLIT_FACES = UserDataManager:get("SHOW_SPLIT_FACES");
local SHOW_LINE_GRID = UserDataManager:get("SHOW_LINE_GRID")
local SHOW_OCTREE = UserDataManager:get("SHOW_OCTREE");
local SHOW_BSP_TREE = UserDataManager:get("SHOW_BSP_TREE")
local SHOW_DEBUG_LINES = UserDataManager:get("SHOW_DEBUG_LINES");
local SHOW_BUNNY = UserDataManager:get("SHOW_BUNNY");
local SHOW_LUCY = UserDataManager:get("SHOW_LUCY");
local SHOW_HAPPY = UserDataManager:get("SHOW_HAPPY");
local SHOW_TEMPLE = UserDataManager:get("SHOW_TEMPLE");
local SHOW_DRAGON = UserDataManager:get("SHOW_DRAGON");

GameVariables:set("MIN_FACES", MIN_FACES);
GameVariables:set("SHOW_LINE_GRID", SHOW_LINE_GRID);
GameVariables:set("SHOW_SPLIT_FACES", SHOW_SPLIT_FACES);
GameVariables:set("SHOW_OCTREE", SHOW_OCTREE)
GameVariables:set("SHOW_BSP_TREE", SHOW_BSP_TREE);
GameVariables:set("SHOW_DEBUG_LINES", SHOW_DEBUG_LINES);
GameVariables:set("SHOW_BUNNY", SHOW_BUNNY)
GameVariables:set("SHOW_LUCY", SHOW_LUCY)
GameVariables:set("SHOW_HAPPY", SHOW_HAPPY)
GameVariables:set("SHOW_TEMPLE", SHOW_TEMPLE)
GameVariables:set("SHOW_DRAGON", SHOW_DRAGON)

function Scene:update(dt)
end

local sceneObjs = {}

function Scene:free()
    MessageManager = nil;
    LayerManager = nil;
    Factory = nil;
    GameVariables = nil;
end

local function addLayer(v)
    local layerKey = LayerManager:createLayerFromFile(v);
    local layer = LayerManager:getLayerByName(layerKey);

    -- add a bounding volume for each prop
    local allProps = layer:getAllProps();
    for index, prop in pairs(allProps) do
        if prop.type == "Model" then
            print(prop.name);
            if SHOW_OCTREE == "TRUE" and prop.name == "horse" then
                local rot = prop:getRot();
                prop:setRot(rot.x, rot.y + 90, rot.z);
            end
            local obj = Factory:create("Obj", {fileName = prop.fileName});
            obj.fileName = prop.fileName;
            obj.rotation = prop:getRot();
            local asdf = prop:getLoc();
            obj.translation = {x = asdf.x, y = asdf.y, z = asdf.z};
            prop:setLoc(300, 300, 300);
            obj.scale = prop:getScl();
            table.insert(sceneObjs, obj);
        end
    end
end

local function createLineStripMeshFromBox(p1, p2, p3, p4, p5, p6, p7, p8)
    local vertexFormat = MOAIVertexFormat.new();
    vertexFormat:declareCoord(1, MOAIVertexFormat.GL_FLOAT, 3);
    vertexFormat:declareUV(2, MOAIVertexFormat.GL_FLOAT, 2);
    vertexFormat:declareColor(3, MOAIVertexFormat.GL_UNSIGNED_BYTE);
    local vbo = MOAIVertexBuffer.new();
    -- vbo:setFormat(vertexFormat);
    vbo:reserve(24);

    function writePoint(v, uvx, uvy, color)
        vbo:writeFloat(v.x, v.y, v.z);
        vbo:writeFloat(uvx, uvy);
        vbo:writeColor32(color.r, color.g, color.b);
    end

    local front = {r = 1, g = 0, b = 0} -- red
    local back = {r = 0, g = 1, b = 0} -- green
    local left = {r = 0, g = 0, b = 1} -- blue
    local right = {r = 1, g = 1, b = 1} -- white

    -- front
    writePoint(p1, 0, 0, front)
    writePoint(p2, 0, 0, front)
    writePoint(p2, 0, 0, front)
    writePoint(p3, 0, 0, front)
    writePoint(p3, 0, 0, front)
    writePoint(p4, 0, 0, front)
    writePoint(p4, 0, 0, front)
    writePoint(p1, 0, 0, front)

    -- back
    writePoint(p5, 0, 0, back)
    writePoint(p6, 0, 0, back)
    writePoint(p6, 0, 0, back)
    writePoint(p7, 0, 0, back)
    writePoint(p7, 0, 0, back)
    writePoint(p8, 0, 0, back)
    writePoint(p8, 0, 0, back)
    writePoint(p5, 0, 0, back)

    -- left
    writePoint(p1, 0, 0, left)
    writePoint(p5, 0, 0, left)
    writePoint(p2, 0, 0, left)
    writePoint(p6, 0, 0, left)

    -- right
    writePoint(p3, 0, 0, right)
    writePoint(p7, 0, 0, right)
    writePoint(p4, 0, 0, right)
    writePoint(p8, 0, 0, right)

    -- vbo:bless()

    local mesh = MOAIMesh.new();
    mesh:setVertexBuffer(vbo, vertexFormat);
    mesh:setPrimType(MOAIMesh.GL_LINES);

    local cube = require("ResourceManager"):load("Prop", "cubeProp");
    cube.mesh = mesh
    cube.shaderName = "MESH_SHADER"

    -- if cube has mesh attached then mesh will be used to create prop
    local newProp = Factory:create(cube.type, cube)
    cube.mesh = nil; -- remove for garbage collector
    newProp.bvObj = cube.obj;
    return newProp
end

function partitionX(p1, p2, p3, p4, p5, p6, p7, p8)
    local vecp1p4 = Math:vertex3Sub(p4, p1); -- v1
    local vecp2p3 = Math:vertex3Sub(p3, p2); -- v2
    local vecp6p7 = Math:vertex3Sub(p7, p6); -- v3
    local vecp5p8 = Math:vertex3Sub(p8, p5); -- v4
    local p9 = {x = p1.x + vecp1p4.x * .5, y = p1.y + vecp1p4.y * .5, z = p1.z + vecp1p4.z * .5}
    local p10 = {x = p2.x + vecp2p3.x * .5, y = p2.y + vecp2p3.y * .5, z = p2.z + vecp2p3.z * .5}
    local p11 = {x = p6.x + vecp6p7.x * .5, y = p6.y + vecp6p7.y * .5, z = p6.z + vecp6p7.z * .5}
    local p12 = {x = p5.x + vecp5p8.x * .5, y = p5.y + vecp5p8.y * .5, z = p5.z + vecp5p8.z * .5}
    return {p1, p2, p10, p9, p5, p6, p11, p12}, {p9, p10, p3, p4, p12, p11, p7, p8}, {p9, p10, p11, p12}
end

function partitionY(p1, p2, p3, p4, p5, p6, p7, p8)
    local vecp1p2 = Math:vertex3Sub(p2, p1); -- v1
    local vecp4p3 = Math:vertex3Sub(p3, p4); -- v2
    local vecp8p7 = Math:vertex3Sub(p7, p8); -- v3
    local vecp5p6 = Math:vertex3Sub(p6, p5); -- v4
    local p9 = {x = p1.x + vecp1p2.x * .5, y = p1.y + vecp1p2.y * .5, z = p1.z + vecp1p2.z * .5}
    local p10 = {x = p4.x + vecp4p3.x * .5, y = p4.y + vecp4p3.y * .5, z = p4.z + vecp4p3.z * .5}
    local p11 = {x = p8.x + vecp8p7.x * .5, y = p8.y + vecp8p7.y * .5, z = p8.z + vecp8p7.z * .5}
    local p12 = {x = p5.x + vecp5p6.x * .5, y = p5.y + vecp5p6.y * .5, z = p5.z + vecp5p6.z * .5}
    return {p9, p2, p3, p10, p12, p6, p7, p11}, {p1, p9, p10, p4, p5, p12, p11, p8}, {p9, p10, p11, p12}
end

-- possibly -Z depending on how you look at it
-- either way the vertices are correct in location
function partitionZ(p1, p2, p3, p4, p5, p6, p7, p8)
    local vecp1p5 = Math:vertex3Sub(p5, p1); -- v1
    local vecp2p6 = Math:vertex3Sub(p6, p2); -- v2
    local vecp3p7 = Math:vertex3Sub(p7, p3); -- v3
    local vecp4p8 = Math:vertex3Sub(p8, p4); -- v4
    local p9 = {x = p1.x + vecp1p5.x * .5, y = p1.y + vecp1p5.y * .5, z = p1.z + vecp1p5.z * .5}
    local p10 = {x = p2.x + vecp2p6.x * .5, y = p2.y + vecp2p6.y * .5, z = p2.z + vecp2p6.z * .5}
    local p11 = {x = p3.x + vecp3p7.x * .5, y = p3.y + vecp3p7.y * .5, z = p3.z + vecp3p7.z * .5}
    local p12 = {x = p4.x + vecp4p8.x * .5, y = p4.y + vecp4p8.y * .5, z = p4.z + vecp4p8.z * .5}
    return {p1, p2, p3, p4, p9, p10, p11, p12}, {p9, p10, p11, p12, p5, p6, p7, p8}, {p9, p12, p11, p10}
end

local BSPNode = {}
BSPNode.__index = BSPNode;

function BSPNode.new(spec)
    local self = setmetatable({}, BSPNode)
    self.type = "BSPNode"
    self.left = spec.left;
    self.right = spec.right;
    self.faces = spec.faces;
    return self;
end

local function getNextSplitAxis(splitAxis)
    if splitAxis == "X" then return "Y"; end
    if splitAxis == "Y" then return "Z"; end
    if splitAxis == "Z" then return "X"; end
end

local function separateFaces(N, faces, pointOnPlane)
    local front = {}
    local back = {}
    for k,face in pairs(faces) do
        local inFrontCount = 0;
        if Math:dot3(N, Math:vertex3Sub(face.v1, pointOnPlane)) > 0 then inFrontCount = inFrontCount + 1 end
        if Math:dot3(N, Math:vertex3Sub(face.v2, pointOnPlane)) > 0 then inFrontCount = inFrontCount + 1 end
        if Math:dot3(N, Math:vertex3Sub(face.v3, pointOnPlane)) > 0 then inFrontCount = inFrontCount + 1 end
        if inFrontCount > 2 then
            table.insert(front, face);
        else
            table.insert(back, face);
        end
    end
    return front, back
end

function getFacesForPlanePoints(points)
    return {
        {v1 = points[1], v2 = points[2], v3 = points[3]},
        {v1 = points[1], v2 = points[3], v3 = points[4]}
    }
end

function autopartition(p1, p2, p3, p4, p5, p6, p7, p8, splitAxis, faces)
    local l = {};
    local r = {};
    local dividingPlaneVertices = {}
    if splitAxis == "X" then
        l, r, dividingPlaneVertices = partitionX(p1, p2, p3, p4, p5, p6, p7, p8)
    elseif splitAxis == "Y" then
        l, r, dividingPlaneVertices = partitionY(p1, p2, p3, p4, p5, p6, p7, p8)
    elseif splitAxis == "Z" then
        l, r, dividingPlaneVertices = partitionZ(p1, p2, p3, p4, p5, p6, p7, p8)
    else
        print("Didn't autopartition on unknown axis")
    end
    local v1 = Math:vertex3Sub(dividingPlaneVertices[2], dividingPlaneVertices[1]);
    local v2 = Math:vertex3Sub(dividingPlaneVertices[4], dividingPlaneVertices[1]);
    local N = Math:vertex3Cross(v1, v2)
    local front, back = separateFaces(N, faces, dividingPlaneVertices[1])
    local dividingPlaneFaces = getFacesForPlanePoints(dividingPlaneVertices)
    return l, r, back, front, dividingPlaneFaces
end

local function addLayers()
    local layers = {}
    if SHOW_BUNNY == "TRUE" then
        table.insert(layers, "bunnyLayer.lua");
    end

    if SHOW_LUCY == "TRUE" then
        table.insert(layers, "lucyLayer.lua");
    end

    if SHOW_HAPPY == "TRUE" then
        table.insert(layers, "happyLayer.lua");
    end

    if SHOW_TEMPLE == "TRUE" then
        table.insert(layers, "templeLayer.lua")
    end

    if SHOW_DRAGON == "TRUE" then
        table.insert(layers, "dragonLayer.lua");
    end

    table.insert(layers, "octreeLayer.lua")
    -- table.insert(layers, "horseLayer.lua");
    --
    table.insert(layers, "OctreeHUDLayer.lua")
    -- table.insert(layers, "happyLayer.lua");

    -- for all layers
        -- for each prop in layer
            -- add an aabb to layer for prop
    for k, v in pairs(layers) do
        addLayer(v);
    end

    --local tree = buildBSPTree(sceneObjs[1].faces);
    function modelToWorldObj(r, t, s, obj)
        local Matrix44 = require("Matrix44");
        local rotation = Matrix44:rotation(r.x, r.y, r.z):setName("Rotation");
        local scale = Matrix44:scale(s.x, s.y, s.z):setName("Scale");
        local modelToWorld = rotation:cat(scale):setName("modelToWorld"); -- RS
        modelToWorld[0][3] = t.x; modelToWorld[1][3] = t.y; modelToWorld[2][3] = t.z;
        for k,v in pairs(obj.vertices) do
            obj.vertices[k] = modelToWorld:mulVec3(v);
        end
        return obj;
    end

    for k,v in pairs(sceneObjs) do
        modelToWorldObj(v.rotation, v.translation, v.scale, v);
    end

    local layer = LayerManager:getLayerByName("octreeLayer.lua");
    local aabb = Factory:create("AABB", {objs = sceneObjs, fileName = "asdf"})
    local newColor = MOAIColor.new();
    newColor:setColor(1, 0, 0, 0);
    aabb:getShader():setAttrLink(2, newColor, MOAIColor.COLOR_TRAIT)
    --layer:insertProp(aabb)

    local name = 0
    local function uniqueName()
        name = name + 1;
        return ""..name;
    end

    local extremal = aabb.bvObj.extremePoints;
    local p1 = {x = extremal.x.vmin.x, y = extremal.y.vmax.y, z = extremal.z.vmax.z}; --p1
    local p2 = {x = extremal.x.vmin.x, y = extremal.y.vmin.y, z = extremal.z.vmax.z}; --p2
    local p3 = {x = extremal.x.vmax.x, y = extremal.y.vmin.y, z = extremal.z.vmax.z}; --p3
    local p4 = {x = extremal.x.vmax.x, y = extremal.y.vmax.y, z = extremal.z.vmax.z}; --p4
    local p5 = {x = extremal.x.vmin.x, y = extremal.y.vmax.y, z = extremal.z.vmin.z}; --p5
    local p6 = {x = extremal.x.vmin.x, y = extremal.y.vmin.y, z = extremal.z.vmin.z}; --p6
    local p7 = {x = extremal.x.vmax.x, y = extremal.y.vmin.y, z = extremal.z.vmin.z}; --p7
    local p8 = {x = extremal.x.vmax.x, y = extremal.y.vmax.y, z = extremal.z.vmin.z}; --p8

    -- collect faces
    function modelToWorldFaces(r, t, s, faces)
        local Matrix44 = require("Matrix44");
        local rotation = Matrix44:rotation(r.x, r.y, r.z):setName("Rotation");
        local scale = Matrix44:scale(s.x, s.y, s.z):setName("Scale");
        local modelToWorld = rotation:cat(scale):setName("modelToWorld"); -- RS
        modelToWorld[0][3] = t.x; modelToWorld[1][3] = t.y; modelToWorld[2][3] = t.z;
        for k,face in pairs(faces) do
            faces[k].v1 = modelToWorld:mulVec3(face.v1);
            faces[k].v2 = modelToWorld:mulVec3(face.v2);
            faces[k].v3 = modelToWorld:mulVec3(face.v3);
        end
        return faces;
    end

    local faces = {}
    for k,v in pairs(sceneObjs) do
        modelToWorldFaces(v.rotation, v.translation, v.scale, v.faces);
        for a,b in pairs(v.faces) do
            table.insert(faces, b)
        end
    end

    local function createVertexFormat()
        local vertexFormat = MOAIVertexFormat.new()
        vertexFormat:declareCoord(1, MOAIVertexFormat.GL_FLOAT, 3)
        vertexFormat:declareUV(2, MOAIVertexFormat.GL_FLOAT, 2)
        vertexFormat:declareColor(3, MOAIVertexFormat.GL_UNSIGNED_BYTE)
        return vertexFormat;
    end

    local function objToMesh(obj, color)
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

    function createPropFromFaces(faces, color)
        local properties = {
            type = "Model",
            fileName = "bunny.obj",
            name = "earth",
            position = {x = 0, y = 0, z = 0};
            scale = {x = 1, y = 1, z = 1},
            scripts = {"bunnyUpdate.lua"},
            shaderName = "MESH_SHADER",
            textureName = "earthWrap.png",
            rotation = {x = 0, y = 0, z = 0},
        }
        local mesh = objToMesh({faces = faces}, color);
        properties.mesh = mesh;
        return Factory:create("Model", properties);
    end

    math.randomseed(1232)
    local function getRandomColor()
        return {r = math.random(), g = math.random(), b = math.random()};
    end

    local function getColor(depth)
        local color = getRandomColor();
        while (color.r == 0) and (color.g == 0) and (color.b == 0) do
            color = getRandomColor()
        end
        return color
    end

    local function tabString(count)
        local string = ""
        for i = 1, count do
            string = string.."\t"
        end
        return string
    end

    local names = {}
    function consumeNode(node, depth)
        if node.type == "LEAF" then
            local color = node.color;
            if names[node.name] ~= nil then assert(false) end
            names[node.name] = node.name;
            local p = node.bv
            if node.faces ~= nil then layer:insertProp(createPropFromFaces(node.faces, color)); end
            if SHOW_SPLIT_FACES == "TRUE" then
                layer:insertProp(createPropFromFaces(node.dpf, color));
            end
        elseif node.type == "NODE" then
            local color = getColor(depth);
            local p = node.bv
            if SHOW_LINE_GRID == "TRUE" then
                if p ~= nil then layer:insertProp(createLineStripMeshFromBox(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8])); end
            end

            if SHOW_SPLIT_FACES == "TRUE" then
                layer:insertProp(createPropFromFaces(node.dpf, color));
            end
            node.left.color = color;
            node.right.color = color;
            consumeNode(node.left, depth + 1);
            consumeNode(node.right, depth + 1);
        end
    end

    local MAX_DEPTH = 200;
    function _buildBSPTree(p, depth, axis, faces, dpf)
        if #faces <= MIN_FACES  or (depth >= MAX_DEPTH) then
            return {type = "LEAF", faces = faces, bv = p, dpf = dpf, name = uniqueName()}
        end
        local node = {type = "NODE", dpf = dpf, bv = p, name = uniqueName()}
        local l, r, back, front, dividingPlaneFaces = autopartition(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], axis, faces);
        node.left = _buildBSPTree(l, depth + 1, getNextSplitAxis(axis), back, dividingPlaneFaces);
        node.right = _buildBSPTree(r, depth + 1, getNextSplitAxis(axis), front, dividingPlaneFaces);
        return node;
    end

    function buildBSPTree(p, depth, axis, faces)
        local l, r, back, front, dividingPlaneFaces = autopartition(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], axis, faces);
        local root = {type = "NODE", dpf = dividingPlaneFaces, bv = p, name = uniqueName()}
        root.left = _buildBSPTree(l, depth + 1, getNextSplitAxis(axis), back, dividingPlaneFaces);
        root.right = _buildBSPTree(r, depth + 1, getNextSplitAxis(axis), front, dividingPlaneFaces);
        return root
    end

    function buildOctree(p, depth, faces, dpf)
        if #faces < MIN_FACES then return {type = "LEAF", faces = faces, p = p, dpf = dpf} end
        local oct = {type = "NODE", children = {}}

        -- split on X
        local l1, r1, back1, front1, dpf1 = autopartition(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], "X", faces)

        -- split left and right of X on Y
        local l2, r2, back2, front2, dpf2 = autopartition(l1[1], l1[2], l1[3], l1[4], l1[5], l1[6], l1[7], l1[8], "Y", back1)
        local l3, r3, back3, front3, dpf3 = autopartition(r1[1], r1[2], r1[3], r1[4], r1[5], r1[6], r1[7], r1[8], "Y", front1)

        -- split left and right of X and Y on Z
        local l4, r4, back4, front4, dpf4 = autopartition(l2[1], l2[2], l2[3], l2[4], l2[5], l2[6], l2[7], l2[8], "Z", back2)
        local l5, r5, back5, front5, dpf5 = autopartition(r2[1], r2[2], r2[3], r2[4], r2[5], r2[6], r2[7], r2[8], "Z", front2)
        local l6, r6, back6, front6, dpf6 = autopartition(l3[1], l3[2], l3[3], l3[4], l3[5], l3[6], l3[7], l3[8], "Z", back3)
        local l7, r7, back7, front7, dpf7 = autopartition(r2[1], r2[2], r2[3], r2[4], r2[5], r2[6], r2[7], r2[8], "Z", front3)

        table.insert(oct.children, buildOctree(l4, depth + 1, back4, dpf))
        table.insert(oct.children, buildOctree(r4, depth + 1, front4, dpf))
        table.insert(oct.children, buildOctree(l5, depth + 1, back5, dpf))
        table.insert(oct.children, buildOctree(r5, depth + 1, front5, dpf))
        table.insert(oct.children, buildOctree(l6, depth + 1, back6, dpf))
        table.insert(oct.children, buildOctree(r6, depth + 1, front6, dpf))
        table.insert(oct.children, buildOctree(l7, depth + 1, back7, dpf))
        table.insert(oct.children, buildOctree(r7, depth + 1, front7, dpf))
        return oct;
    end

    function consumeTree(tree)
        consumeNode(tree, 0)
    end

    function consumeOct(oct, color)
        if oct.type == "LEAF" then
            layer:insertProp(createPropFromFaces(oct.faces, color));
            if SHOW_LINE_GRID == "TRUE" then
                local p = oct.p;
                layer:insertProp(createLineStripMeshFromBox(p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]));
            elseif SHOW_LINE_GRID == "FALSE" then
            end
        elseif oct.type == "NODE" then
            consumeOct(oct.children[1], getColor());
            consumeOct(oct.children[2], getColor());
            consumeOct(oct.children[3], getColor());
            consumeOct(oct.children[4], getColor());
            consumeOct(oct.children[5], getColor());
            consumeOct(oct.children[6], getColor());
            consumeOct(oct.children[7], getColor());
            consumeOct(oct.children[8], getColor());
        end
    end

    function consumeOctree(tree)
        consumeOct(tree, {r = 1, g = 0, b = 0});
    end

    local tree = {}
    if SHOW_BSP_TREE == "TRUE" then
        tree = buildBSPTree({p1, p2, p3, p4, p5, p6, p7, p8}, 0, "X", faces)
        consumeTree(tree);
    elseif SHOW_OCTREE == "TRUE" then
        tree = buildOctree({p1, p2, p3, p4, p5, p6, p7, p8}, 0, faces)
        consumeOctree(tree);
    end


end

function Scene:enter()
    addLayers();
end

function Scene:exit()
    removeLayers();
end

local function removeLayers()
    LayerManager:removeAllLayers();
end

function Scene.reset()
    sceneObjs = {}
    removeLayers();
    addLayers();
    MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1)

    if SHOW_DEBUG_LINES == "TRUE" then
        MOAIDebugLines.showStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, true)
    elseif SHOW_DEBUG_LINES == "FALSE" then
        MOAIDebugLines.showStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, false)
    end
end

function Scene.rKeyPressed()
    MIN_FACES = MIN_FACES + MIN_FACES * .10
    GameVariables:set("MIN_FACES", MIN_FACES);
    UserDataManager:set("MIN_FACES", MIN_FACES);
    print("Increasing the face count limit to: ", GameVariables:get("MIN_FACES"))
    Scene.reset();
end

function Scene.vKeyPressed()
    MIN_FACES = MIN_FACES - MIN_FACES * .10;
    GameVariables:set("MIN_FACES", MIN_FACES);
    UserDataManager:set("MIN_FACES", MIN_FACES);
    print("Reducing the face count limit to: ", GameVariables:get("MIN_FACES"))
    Scene.reset();
end

function Scene.gKeyPressed()
    if SHOW_LINE_GRID == "TRUE" then
        SHOW_LINE_GRID = "FALSE";
    elseif SHOW_LINE_GRID == "FALSE" then
        SHOW_LINE_GRID = "TRUE"
    end
    GameVariables:set("SHOW_LINE_GRID", SHOW_LINE_GRID);
    UserDataManager:set("SHOW_LINE_GRID", SHOW_LINE_GRID);
    Scene.reset();
end

function Scene.fKeyPressed()
    if SHOW_SPLIT_FACES == "TRUE" then
        SHOW_SPLIT_FACES = "FALSE";
    elseif SHOW_SPLIT_FACES == "FALSE" then
        SHOW_SPLIT_FACES = "TRUE"
    end
    GameVariables:set("SHOW_SPLIT_FACES", SHOW_SPLIT_FACES);
    UserDataManager:set("SHOW_SPLIT_FACES", SHOW_SPLIT_FACES);
    Scene.reset();
end

function Scene.oKeyPressed()
    SHOW_OCTREE = "TRUE";
    SHOW_BSP_TREE = "FALSE";
    GameVariables:set("SHOW_OCTREE", SHOW_OCTREE);
    GameVariables:set("SHOW_BSP_TREE", SHOW_BSP_TREE);
    UserDataManager:set("SHOW_OCTREE", SHOW_OCTREE);
    UserDataManager:set("SHOW_BSP_TREE", SHOW_BSP_TREE);
    Scene.reset()
end

function Scene.bKeyPressed()
    SHOW_OCTREE = "FALSE";
    SHOW_BSP_TREE = "TRUE";
    GameVariables:set("SHOW_OCTREE", SHOW_OCTREE);
    GameVariables:set("SHOW_BSP_TREE", SHOW_BSP_TREE);
    UserDataManager:set("SHOW_OCTREE", SHOW_OCTREE);
    UserDataManager:set("SHOW_BSP_TREE", SHOW_BSP_TREE);
    Scene.reset()
end

function Scene.hKeyPressed()
    if SHOW_DEBUG_LINES == "FALSE" then
        SHOW_DEBUG_LINES = "TRUE"
    elseif SHOW_DEBUG_LINES == "TRUE" then
        SHOW_DEBUG_LINES = "FALSE"
    end
    GameVariables:set("SHOW_DEBUG_LINES", SHOW_DEBUG_LINES)
    UserDataManager:set("SHOW_DEBUG_LINES", SHOW_DEBUG_LINES);
    Scene.reset();
end

function Scene.iKeyPressed()
    if SHOW_BUNNY == "TRUE" then
        SHOW_BUNNY = "FALSE"
    elseif SHOW_BUNNY == "FALSE" then
        SHOW_BUNNY = "TRUE"
    end
    GameVariables:set("SHOW_BUNNY", SHOW_BUNNY);
    UserDataManager:set("SHOW_BUNNY", SHOW_BUNNY)
    Scene.reset()
end

function Scene.yKeyPressed()
    if SHOW_TEMPLE == "TRUE" then
        SHOW_TEMPLE = "FALSE"
    elseif SHOW_TEMPLE == "FALSE" then
        SHOW_TEMPLE = "TRUE"
    end
    GameVariables:set("SHOW_TEMPLE", SHOW_TEMPLE);
    UserDataManager:set("SHOW_TEMPLE", SHOW_TEMPLE)
    Scene.reset()
end

function Scene.uKeyPressed()
    if SHOW_HAPPY == "TRUE" then
        SHOW_HAPPY = "FALSE"
    elseif SHOW_HAPPY == "FALSE" then
        SHOW_HAPPY = "TRUE"
    end
    GameVariables:set("SHOW_HAPPY", SHOW_HAPPY);
    UserDataManager:set("SHOW_HAPPY", SHOW_HAPPY)
    Scene.reset()
end

function Scene.lKeyPressed()
    if SHOW_LUCY == "TRUE" then
        SHOW_LUCY = "FALSE"
    elseif SHOW_LUCY == "FALSE" then
        SHOW_LUCY = "TRUE"
    end
    GameVariables:set("SHOW_LUCY", SHOW_LUCY);
    UserDataManager:set("SHOW_LUCY", SHOW_LUCY)
    Scene.reset()
end

function Scene.pKeyPressed()
    if SHOW_DRAGON == "TRUE" then
        SHOW_DRAGON = "FALSE"
    elseif SHOW_DRAGON == "FALSE" then
        SHOW_DRAGON = "TRUE"
    end
    GameVariables:set("SHOW_DRAGON", SHOW_DRAGON);
    UserDataManager:set("SHOW_DRAGON", SHOW_DRAGON)
    Scene.reset()
end

require("MessageManager"):listen("KeyPressed_r", Scene.rKeyPressed);
require("MessageManager"):listen("KeyPressed_v", Scene.vKeyPressed);
require("MessageManager"):listen("KeyPressed_g", Scene.gKeyPressed);
require("MessageManager"):listen("KeyPressed_f", Scene.fKeyPressed);
require("MessageManager"):listen("KeyPressed_b", Scene.bKeyPressed);
require("MessageManager"):listen("KeyPressed_o", Scene.oKeyPressed);
require("MessageManager"):listen("KeyPressed_h", Scene.hKeyPressed);
require("MessageManager"):listen("KeyPressed_i", Scene.iKeyPressed);
require("MessageManager"):listen("KeyPressed_u", Scene.uKeyPressed);
require("MessageManager"):listen("KeyPressed_y", Scene.yKeyPressed);
require("MessageManager"):listen("KeyPressed_l", Scene.lKeyPressed);
require("MessageManager"):listen("KeyPressed_p", Scene.pKeyPressed);


return Scene
