local LayerManager = {
	layersByName = {},
	allLayersPaused = false,
}

local Factory = require "Factory";

function LayerManager:createLayerFromFile(layerFileName)
	-- not supporting duplicate named layers right now
	if self.layersByName[layerFileName] ~= nil then
		self.layersByName[layerFileName]:free();
		self.layersByName[layerFileName] = nil;
	end
	self.layersByName[layerFileName] = Factory:createFromFile("Layer", layerFileName);
	return layerFileName;
end

function LayerManager:getAllLayerIndices()
	local allLayerIndices = {};
	for k,v in pairs(self.layersByName) do
		table.insert(allLayerIndices, k);
	end
	return allLayerIndices;
end

function LayerManager:getAllLayers()
	local allLayers = {};
	for k,v in pairs(self.layersByName) do
		table.insert(allLayers, v)
	end 
	return allLayers;
end

function LayerManager:getLayerByIndex(layerIndex)
	return self.layersByName[layerIndex];
end

function LayerManager:getLayerIndexByName(layerName)
	return self.layersByName[layerName];
end

function LayerManager:pauseAllLayers(doPause)
	for k,v in pairs(self.layersByName) do
		v:pause(doPause);
	end
end

function LayerManager:removeAllLayers()
	local layerIndices = self:getAllLayerIndices();
	for i,index in ipairs(layerIndices) do
		self:removeLayerByIndex(index)
	end
end

function LayerManager:removeLayerByName(layerName)
	print("Removing layer by name of", layerName)
	self.layersByName[layerName]:free();
	self.layersByName[layerName] = nil;
end

function LayerManager:getLayerByName(layerName)
	return self.layersByName[layerName];
end

function LayerManager:removeLayerByIndex(layerIndex)
	self:removeLayerByName(layerIndex);
end

function LayerManager:serializeLayerToFile(layerIndex, fileName)
	self.layersByName[layerIndex]:serializeToFile(fileName);
end

function LayerManager:shutdown()
	self:removeAllLayers();
	Factory = nil;
	self.layersByName = nil;
end

function LayerManager:update(dt)
	for k,v in pairs(self.layersByName) do
		v:update(dt);
	end
end

return LayerManager;