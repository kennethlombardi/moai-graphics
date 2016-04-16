local SimulationManager = { core = nil };

-- SimulationCore
local SimulationCore = {};

function SimulationCore:new(object)
	object = object or {};
	setmetatable(object, self);
	self.__index = self;
	return object;
end

function SimulationCore:forceGarbageCollection()
	print("SimulationCore:forceGarbageCollection is UNIMPLEMENTED");
end

function SimulationCore:getPerformance()
	print ("SimulationCore:getPerformanceCount is UNIMPLEMENTED");
end

function SimulationCore:getStep()
	print("SimulationCore:getStep is UNIMPLEMENTED");
end

function SimulationCore:reportHistogram()
	print("SimulationCore:reportHistogram is UNIMPLEMENTED");
end

function SimulationCore:reportLeaks()
	print("SimulationCore:reportLeaks is UNIMPLEMENTED");
end

function SimulationCore:setHistogramEnabled(bool)
	print("SimulationCore:setHistogramEnabled is UNIMPLEMENTED");
end

function SimulationCore:setLeakTrackingEnabled(bool) 
	print("SimulationCore:setLeakTrackingEnabled is UNIMPLEMENTED");
end

function SimulationCore:setLuaAllocLogEnabled(bool)
	print("SimulationCore:setLuaAllocLogEnabled is UNIMPLEMENTED");
end

function SimulationCore:shutdown() 
	print("SimulationCore:shutdown is UNIMPLEMENTED");
end

function SimulationCore:update(dt)
	print("SimulationCore:update is UNIMPLEMENTED");
end
--

-- SimulationManager
function SimulationManager:getPerformance()
	return self.core:getPerformance();
end

function SimulationManager:getStep()
	return self.core:getStep();
end

function SimulationManager:forceGarbageCollection()
	self.core:forceGarbageCollection();
end

function SimulationManager:reportHistogram()
	self.core:reportHistogram();
end

function SimulationManager:reportLeaks()
	self.core:reportLeaks();
end

function SimulationManager:registerCore(core)
	self.core = core;
end

function SimulationManager:setHistogramEnabled(bool)
	self.core:setHistogramEnabled(bool);
end

function SimulationManager:setLeakTrackingEnabled(bool)
	self.core:setLeakTrackingEnabled(bool);
end

function SimulationManager:setLuaAllocLogEnabled(bool)
	self.core:setLuaAllocLogEnabled(bool);
end

function SimulationManager:shutdown()
	self.core:shutdown();
	self.core = nil;
end

function SimulationManager:update(dt)
	self.core:update(dt);
end

--

-- MOAISimulationCore
local MOAISimulationCore = SimulationCore:new();
function MOAISimulationCore:forceGarbageCollection()
	MOAISim.forceGarbageCollection();
end

function MOAISimulationCore:getPerformance()
	return MOAISim.getPerformance();
end

function MOAISimulationCore:getStep()
	return MOAISim.getStep();
end

function MOAISimulationCore:reportHistogram()
	MOAISim.reportHistogram();
end

function MOAISimulationCore:reportLeaks()
	MOAISim.reportLeaks();
end

function MOAISimulationCore:setHistogramEnabled(bool)
	MOAISim.setHistogramEnabled(bool);
end

function MOAISimulationCore:setLeakTrackingEnabled(bool) 
	MOAISim.setLeakTrackingEnabled(bool);
end

function MOAISimulationCore:setLuaAllocLogEnabled(bool)
	MOAISim.setLuaAllocLogEnabled(bool);
end

function MOAISimulationCore:shutdown()
end

function MOAISimulationCore:update(dt)
	collectgarbage();
end
--


local function init()
	SimulationManager:registerCore(MOAISimulationCore:new());
end

init();

return SimulationManager;