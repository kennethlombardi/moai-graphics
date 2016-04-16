local Scene = {}

local LayerManager = require("LayerManager");
local Factory = require("./Factory/Factory");
local Math = require("Math")
local UserDataManager = require("UserDataManager");
local GameVariables = require("GameVariables");
print("scene setup: ", UserDataManager:get("BVAlgorithm"), UserDataManager:get("BVHAlgorithm"))
GameVariables:set("BVHAlgorithm", UserDataManager:get("BVHAlgorithm"));
GameVariables:set("BVAlgorithm", UserDataManager:get("BVAlgorithm"));

local BVMethods = {
    "AABB",
    "SphereCentroid"
}

local BVHMethods = {
    "TopDown",
    "BottomUp"
};

-- get the current BVH method and check if it is valid
local currentBVHMethod = GameVariables:get("BVHAlgorithm");
-- if BVHMethods[currentBVHMethod] == nil then
--     currentBVHMethod = BVHMethods[#BVHMethods];
--     GameVariables:set("BVHAlgorithm", currentBVHMethod)
-- end

-- -- get the current bounding method and check if it is valid
local currentBVMethod = GameVariables:get("BVAlgorithm");
-- if BVMethods[currentBVMethod] == nil then
--     print("Changing from", currentBVMethod, " to: ", BVMethods[#BVMethods])
--     currentBVMethod = BVMethods[#BVMethods];
--     GameVariables:set("BVAlgorithm", currentBVMethod)
-- end

function Scene:update(dt)

end

local sceneObjs = {}
function Scene:registerObj(obj)
    table.insert(sceneObjs, obj);
end

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
    local sceneObjs = {}
    for index, prop in pairs(allProps) do 
        if prop.type == "Model" then
            local obj = Factory:create("Obj", {fileName = prop.fileName});
            obj.fileName = prop.fileName;
            obj.rotation = prop:getRot();
            obj.translation = prop:getLoc();
            obj.scale = prop:getScl();
            table.insert(sceneObjs, obj);
        end
    end

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

    -- for each one of the scene objs transform into world space
    for k,obj in pairs(sceneObjs) do 
        print(k, obj)
        Scene:registerObj(modelToWorldObj(obj.rotation, obj.translation, obj.scale, obj));
    end
end

local function addLayers() 
    local layers = {}
    table.insert(layers, "bunnyLayer.lua");
    table.insert(layers, "horseLayer.lua");
    table.insert(layers, "cs350HUDLayer.lua");
    table.insert(layers, "BVHHUDLayer.lua");
    table.insert(layers, "BVHLayer.lua");
    -- table.insert(layers, "bunniesLayer.lua")
    table.insert(layers, "dragonLayer.lua")
    -- for all layers
        -- for each prop in layer
            -- add an aabb to layer for prop
    for k, v in pairs(layers) do 
        addLayer(v);
    end


    local function PartitionObjects(objects)
        --[[
            1) Choose partitioning axis
            2) Choose a split point
                Median of the centroid coordinates (object median)
                    Project centroid coordinates on to partitioning axis
                    Sort centroid coordinates along partitioning axis
                    Choose median centroid from centroid coordinate set
        ]]

        -- choose partitioning axis
        local partitioningAxis = {x = 1, y = 0, z = 0};

        -- choose a split point
        -- get the median of the centroid coordinates of objects
        local centroids = {};
        for k,object in pairs(objects) do 
            object.centroid = object.centroid or Math:getCentroid(object.vertices);
            object.centroid.object = object; -- causing a memory leak
            table.insert(centroids, object.centroid);
        end

        -- sort the centroids along partitioning axis
        table.sort(centroids, function(a, b) 
            return a.x < b.x;
        end
        )

        -- finally get the median centroid
        local median = math.floor(#centroids / 2);

        -- collect the left half of the tree
        local leftHalf = {}
        for i = 1, median do 
            table.insert(leftHalf, centroids[i].object);
        end

        local rightHalf = {}
        for i = median + 1, #centroids do 
            table.insert(rightHalf, centroids[i].object)
        end

        return leftHalf, rightHalf;
    end

    local function ComputeBoundingVolume(objects)
        print("Computing bv")
        local fileName = "Bounding Volume Hierarchy";
        if #objects == 1 then fileName = objects[1].fileName end
        return Factory:create(currentBVMethod, {objs = objects, fileName = fileName})
    end

    -- build the hierarchy for the bounding volumes
    local LEAF = 0;
    local NODE = 1;
    function TopDownBVTree(objects) 
        local MIN_OBJECTS_PER_LEAF = 1;
        local pNode = {};
        pNode.BV = ComputeBoundingVolume(objects);
        if #objects <= MIN_OBJECTS_PER_LEAF then
            pNode.type = LEAF;
            pNode.numObjects = #objects;
            pNode.object = objects[1];
        else
            pNode.type = NODE;
            local leftHalfOfObjects, rightHalfOfObjects = PartitionObjects(objects);
            pNode.left = TopDownBVTree(leftHalfOfObjects);
            pNode.right = TopDownBVTree(rightHalfOfObjects);
        end
        return pNode
    end

    local function closestCentroids(centroids)
        local c1 = centroids[1];
        local c2 = centroids[2];
        local closest = {c1 = c1, c2 = c2};
        local d = Math:vertex3Sub(c1, c2);
        local dist2 = Math:dot3(d, d);
        for i = 3, #centroids do 
            c1 = c2;
            c2 = centroids[i];
            -- compute squared distance between point and sphere center
            d = Math:vertex3Sub(c1, c2);
            dist2_potential = Math:dot3(d, d);
            if dist2_potential > dist2 then
                closest.c1 = c1;
                closest.c2 = c2;
                dist2 = dist2_potential;
            end
        end
        return closest.c1.nodeId, closest.c2.nodeId;
    end

    local function _calculateNodeCentroid(node, centroids)
        if node == nil then return end;
        local leftCentroid = _calculateNodeCentroid(node.left, centroids);
        local rightCentroid = _calculateNodeCentroid(node.right, centroids);
        table.insert(centroids, leftCentroid);
        table.insert(centroids, rightCentroid);
    end

    local function calculateNodeCentroid(node)
        local centroids = {}
        _calculateNodeCentroid(node, centroids)
        return Math:getCentroid(centroids);
    end

    local function FindNodesToMerge(nodes, numObjects)
        print("Find nodes to merge:")
        print("nodes", nodes);
        print("numObjects", numObjects);
        local centroids = {}
        for i = 1, numObjects do 
            nodes[i].centroid = nodes[i].centroid or calculateNodeCentroid(node);
            nodes[i].centroid.nodeId = i;
            table.insert(centroids, nodes[i].centroid)
        end
        return closestCentroids(centroids);
    end

    -- build the hierarchy bottom up
    function BottomUpBVTree(objects)
        local nodes = {};
        for k,v in pairs(objects) do 
            local node = {};
            node.type = LEAF;
            node.object = v;
            node.BV = ComputeBoundingVolume({node.object})
            table.insert(nodes, node);
        end

        local numObjects = #objects;
        while numObjects > 1 do
            local i, j = FindNodesToMerge(nodes, numObjects);
            local pair = {};
            pair.type = NODE;
            pair.left = nodes[i];
            pair.right = nodes[j];
            pair.BV = ComputeBoundingVolume({pair.left.object, pair.right.object})


            -- remove the 2 nodes from the active set
            local min = i; local max = j;
            if i > j then min = j; max = i; end
            nodes[min] = pair;
            nodes[max] = nodes[numObjects];
            numObjects = numObjects - 1;


        end
        return nodes[1];
    end

    local colors = {
        {r = 1, g = 0, b = 0, a = 0},
        {r = .75, g = .25, b = 0, a = 0},
        {r = .50, g = .50, b = 0, a = 0},
        {r = .25, g = .75, b = 0, a = 0},
        {r = 0, g = 1, b = 0, a = 0}
    }
    local function getColor(level)
        level = level + 1;
        local newColor = MOAIColor.new();
        newColor:setColor(colors[level].r, colors[level].g, colors[level].b, colors[level].a);
        return newColor;
    end

    local layer = LayerManager:getLayerByName("BVHLayer.lua");
    local function printLeaf(node, context)
        local levelColor = getColor(context.level);
        node.BV:getShader():setAttrLink(2, levelColor, MOAIColor.COLOR_TRAIT )
        layer:insertProp(node.BV);
    end
    
    -- layer:insertProp(Factory:create(currentBVMethod, {objs = objs, fileName = "Bounding Volume Hierarchy"}))
    local function printTree(node, context)
        context.level = context.level + 1;
        if node.type == LEAF then 
            printLeaf(node, context);
        elseif node.type == NODE then
            local levelColor = getColor(context.level);
            node.BV:getShader():setAttrLink(2, levelColor, MOAIColor.COLOR_TRAIT )
            layer:insertProp(node.BV);
            printTree(node.left, context);
            printTree(node.right, context);
        end
        context.level = context.level - 1;
    end

    local tree = nil;
    if currentBVHMethod == "BottomUp" then tree = BottomUpBVTree(sceneObjs) end
    if currentBVHMethod == "TopDown" then tree = TopDownBVTree(sceneObjs) end
    printTree(tree, {level = -1})
end

local function removeLayers()
    LayerManager:removeAllLayers(); 
end

local numberKeys = {"1", "2", "3", "4", "5", "6", "7", "8", "9"}

function Scene.reset()
    sceneObjs = {};
    removeLayers();
    addLayers();
end

function Scene.numberKeyPressed(key)
    key = tonumber(key);
    if key == 9 then
        addLayer("dragonLayer.lua")
    else
        if key <= 0 then 
            key = 1 
        end
        if key > #BVMethods then 
            key = #BVMethods 
        end
        currentBVMethod = BVMethods[key];
        Scene.reset()
        print("Switching to: ", currentBVMethod);
        GameVariables:set("BVAlgorithm", currentBVMethod);
        UserDataManager:set("BVAlgorithm", currentBVMethod);
    end
end

function Scene.changeBVHMethod(method)
    currentBVHMethod = method;
    GameVariables:set("BVHAlgorithm", currentBVHMethod);
    UserDataManager:set("BVHAlgorithm", currentBVHMethod);
    print("Switching to: ", currentBVHMethod);
    Scene.reset();
end

function Scene.toggleWireFrame()
    wireframeMode = not wireframeMode;
    if wireframeMode == true then
        MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
        --MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0.5, 0.5, 0.5 )
    else
        MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 0, 0, 0, 0 )
    end
    Scene.reset();
end

function Scene.tKeyPressed(key)
    Scene.changeBVHMethod("TopDown");
    Scene.toggleWireFrame();
end

function Scene.bKeyPressed(key)
    Scene.changeBVHMethod("BottomUp");
end

function Scene:enter()
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0.5, 0.5, 0.5 )
    addLayers();
    for k, v in pairs(numberKeys) do 
        require("MessageManager"):listen("KeyPressed_"..v, Scene.numberKeyPressed);
    end

    require("MessageManager"):listen("KeyPressed_t", Scene.tKeyPressed);
    require("MessageManager"):listen("KeyPressed_b", Scene.bKeyPressed);
    -- require("MessageManager"):listen("KeyPressed_e", Scene.eKeyPressed);
end

function Scene:exit()
    removeLayers();
end

return Scene