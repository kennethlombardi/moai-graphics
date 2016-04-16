local Script = {
    name = "GJKLayerUpdate.lua",
};

local Math = require("Math");

function calculateCSO(obj1, obj2)
    local cso = {}
    for k,v1 in pairs(obj1.vertices) do
        for k2,v2 in pairs(obj2.vertices) do 
            table.insert(cso, {x = v1.x - v2.x, y = v1.y - v2.y, z = v1.z - v2.z});
        end
    end
    return cso;
end

function modelToWorldObj(r, t, s, obj)
    local world = {}
    local Matrix44 = require("Matrix44");
    local rotation = Matrix44:rotation(r.x, r.y, r.z):setName("Rotation");
    local scale = Matrix44:scale(s.x, s.y, s.z):setName("Scale");
    local modelToWorld = rotation:cat(scale):setName("modelToWorld"); -- RS
    modelToWorld[0][3] = t.x; modelToWorld[1][3] = t.y; modelToWorld[2][3] = t.z;
    for k,v in pairs(obj.vertices) do
        table.insert(world, modelToWorld:mulVec3(v));
    end
    return {vertices = world};
end

function isColliding(prop1, prop2)
    local prop1ObjWorld = modelToWorldObj(prop1:getRot(), prop1:getLoc(), prop1:getScl(), prop1.bvObj)
    local prop2ObjWorld = modelToWorldObj(prop2:getRot(), prop2:getLoc(), prop2:getScl(), prop2.bvObj)
    local cso = calculateCSO(prop2ObjWorld, prop1ObjWorld);
    local prop1Position = prop1:getLoc();
    local prop2Position = prop2:getLoc();
    local v = {
        x = prop2Position.x - prop1Position.x,
        y = prop2Position.y - prop1Position.y,
        z = prop2Position.z - prop1Position.z
    }
    local prop1Extreme = Math:getExtremePointsAlongDirection(v, prop1ObjWorld.vertices);
    local prop2Extreme = Math:getExtremePointsAlongDirection(v, prop2ObjWorld.vertices);
    local prop1ClosestToProp2 = prop1Extreme.vmax;
    local prop2ClosestToProp1 = prop2Extreme.vmin;
    local vectorBetweenClosestPoints = Math:vertex3Sub(prop2ClosestToProp1, prop1ClosestToProp2);
    local asdf = Math:dot3(v, vectorBetweenClosestPoints);
    if asdf > 0 then return false end;
    return true, cso;
end

local t = 0;
local horseDirection = -1;
local rabbitDirection = 1;
local paused = false;
local state = "ANIMATING"
local collidedPreviousFrame = false;
local collidedThisFrame = false;
local function moveProps(props, dt)
    if not (state == "ANIMATING") then return end;
    t = t + dt;
    for k,v in pairs(props) do
        local position = v:getLoc();
        local directionalTime = t;
        if v.fileName == "horse_lowres_cleaned.obj" then
            directionalTime = t * horseDirection   
        elseif v.fileName == "bunny.obj" then
            directionalTime = t * rabbitDirection;
        end
        v:setLoc(
            math.sin(directionalTime), 
            math.sin(2 * directionalTime), 
            -3);
    end
end

local function spacePressed() 
    if state == "INITIAL_SIMPLEX" then state = "REFINEMENT"; return end
    if state == "REFINEMENT" then
        state = "ANIMATING";
    return end
end

require("MessageManager"):listen("KeyPressed_SPACE", spacePressed);
function Script.update(layer, dt)  
    dt = dt * 2;
    local allProps = layer:getAllProps();
    moveProps(allProps, dt)
    local prop1 = allProps[1];
    local prop2 = allProps[2];
    if state == "ANIMATING" then 
        local colliding, cso = isColliding(prop1, prop2);
        if colliding == true then 
            state = "INITIAL_SIMPLEX"
            local newColor = MOAIColor.new();
            newColor:setColor(1, 0, 0, 0);
            prop2:getShader():setAttrLink(2, newColor, MOAIColor.COLOR_TRAIT)
            prop1:getShader():setAttrLink(2, newColor, MOAIColor.COLOR_TRAIT)
        else
            local newColor = MOAIColor.new();
            newColor:setColor(0, 1, 0, 0);
            prop2:getShader():setAttrLink(2, newColor, MOAIColor.COLOR_TRAIT)
            prop1:getShader():setAttrLink(2, newColor, MOAIColor.COLOR_TRAIT)
        end
    end
end

return Script;