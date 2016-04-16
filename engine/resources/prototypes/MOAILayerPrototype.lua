local Layer = require "Layer";

MOAILayerPrototype = Layer:new();

local windowManager = require "WindowManager";

function MOAILayerPrototype:addToPartition(prop)
	local partition = self.underlyingType:getPartition();
	partition:insertProp(prop:getUnderlyingType());
end

function MOAILayerPrototype:allocate()
    local object = MOAILayerPrototype:new {
        propContainer = {},
        position = {x = 0, y = 0, z = 0},
        rotation = {x = 0, y = 0, z = 0},
        underlyingType = nil,
        camera = nil,
        scripts = {},
        currentIndex = 1,
    }
    return object;
end

function MOAILayerPrototype:clear()
	self:getUnderlyingType():clear();
end

function MOAILayerPrototype:free()
	self:clear();
	MOAIRenderMgr.removeRenderPass(self:getUnderlyingType());
	self:baseFree();
	self.camera = nil;
end

function MOAILayerPrototype:getAllProps()
	return self.propContainer:getAllProps();
end

function MOAILayerPrototype:getLoc()
	return self.position;
end

function MOAILayerPrototype:getPropByName(name)
	return self.propContainer:getPropByName(name);
end

function MOAILayerPrototype:getRot()
	return self.rotation;
end

function MOAILayerPrototype:setOnDestroyCallback(prop)
	local this = self;
	local callback = function() 
		this:removeProp(prop); 
		prop.destroy = nil;
		this = nil; 
		prop = nil;

	end
	prop.destroy = callback;
	return callback;
end

function MOAILayerPrototype:insertProp(prop)
	if prop == nil then return end
	self:setOnDestroyCallback(prop);
	self:addToPartition(prop);
	self.propContainer:insertProp(prop);
end

function MOAILayerPrototype:pickForRay(windowX, windowY, props)
	props = props or {};
	local function toTable ( ... )
    	return arg;
	end
	local originX, originY, originZ, directionX, directionY, directionZ = self.underlyingType:wndToWorld(windowX, windowY, 0);
	local pickListRaw = toTable(self.underlyingType:getPartition():propListForRay(originX, originY, originZ, directionX, directionY, directionZ));
	self.propContainer:getPropsForRawList(pickListRaw, props);
	return props;
end

function MOAILayerPrototype:pickForPoint(windowX, windowY, props)
	props = props or {};
	local function toTable ( ... )
    	return arg;
	end
	local originX, originY, originZ, directionX, directionY, directionZ = self.underlyingType:wndToWorld(windowX, windowY, 0);
	local pickListRaw = toTable(self.underlyingType:getPartition():propListForPoint(originX, originY, originZ, directionX, directionY, directionZ));
	self.propContainer:getPropsForRawList(pickListRaw, props);
	return props;
end


function MOAILayerPrototype:removeProp(prop)
	local partition = self.underlyingType:getPartition();
	partition:removeProp(prop:getUnderlyingType());
	self.propContainer:removeProp(prop);
end

function MOAILayerPrototype:setCamera(camera)
	if self["underlyingType"] == nil then 
		print("Trying to insert camera into MOAILayerPrototype without underlying type"); 
		return; 
	end;
	self.camera = camera;
	self.underlyingType:setCamera(camera);
end

function MOAILayerPrototype:setLoc(newX, newY, newZ)
	self.position = {x = newX, y = newY, z = newZ}
	if self.camera ~= nil then
		self.camera:setLoc(newX, newY, newZ);
	else
	end
end

function MOAILayerPrototype:setRot(newX, newY, newZ)
	self.rotation = {x = newX, y = newY, z = newZ}
	if self.camera ~= nil then
		self.camera:setRot(newX, newY, newZ);
	else
	end
end

function MOAILayerPrototype:serialize(properties)
	properties = properties or {}
	self:serializeBase(properties);	--Serialize the parent data
	return properties;
end

function Layer:setPropContainer(propContainer)
    self.propContainer = propContainer;
    --for i,prop in pairs(propContainer.props) do
        --self:insertProp(prop);
    --end
end

function MOAILayerPrototype:setViewport(viewport)
	if self["underlyingType"] == nil then
		print("Trying to insert viewport into MOAILayerPrototype without underlying type"); 
		return;
	end;
	self["underlyingType"]:setViewport(viewport);
end

function MOAILayerPrototype:setVisible(visible)
	if visible == true then
		if self.visible == "false" then
			MOAIRenderMgr.pushRenderPass(self:getUnderlyingType());
			self.visible = "true";
		end
	else
		if self.visible == "true" then
			MOAIRenderMgr.removeRenderPass(self:getUnderlyingType());
			self.visible = "false";
		end
	end
end

function MOAILayerPrototype:update(dt)
	self:baseUpdate(dt);
end

return MOAILayerPrototype;