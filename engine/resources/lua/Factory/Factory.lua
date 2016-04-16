local Factory = {};
local objectCreators = {}
local Creator = require("./Factory/Creator")

-- 1) Create a callback for button press 0 that will trigger a scene change
-- 	to a scene that benchmarks all of the different methods possibly
-- 	printing them to the screen or piping to a file.

-- 2) Larsson just finished move on to PCA

-- custom creators
local MOAIPropCreator = require("./Factory/MOAIPropCreator")(Factory);
local PropContainerCreator = require("./Factory/PropContainerCreator")(Factory);
local MOAILayerCreator = require("./Factory/MOAILayerCreator"):init(Factory);
local MOAILayerDDCreator = require("./Factory/MOAILayerDDCreator")(Factory);
local PropPrototypeCreator = require("./Factory/PropPrototypeCreator")(Factory);
local MOAIPropPrototypeCreator = require("./Factory/MOAIPropPrototypeCreator")(Factory);
local MOAIPropCubeCreator = require("./Factory/MOAIPropCubeCreator")(Factory);
local MOAITextBoxCreator = require("./Factory/MOAITextBoxCreator")(Factory);
local MOAIScriptCreator = require("./Factory/MOAIScriptCreator")(Factory);
local MOAIShaderCreator = require("./Factory/MOAIShaderCreator")(Factory);
local MOAISphereCreator = require("./Factory/MOAISphereCreator")(Factory);
local MOAITorusCreator = require("./Factory/MOAITorusCreator")(Factory);
local MOAIModelCreator = require("./Factory/MOAIModelCreator")(Factory);
local MOAIMeshCreator = require("./Factory/MOAIMeshCreator")(Factory);
local MOAIObjCreator = require("./Factory/MOAIObjCreator")(Factory);
local MOAIAABBCreator = require("MOAIAABBCreator")(Factory);
local MOAISphereCentroidCreator = require("MOAISphereCentroidCreator")(Factory);
local MOAISphereRitterCreator = require("MOAISphereRitterCreator")(Factory);
local MOAISphereLarssonCreator = require("MOAISphereLarssonCreator")(Factory);
local MOAISpherePCACreator = require("MOAISpherePCACreator")(Factory);
-- local MOAIEllipsoidPCACreator = require("MOAIEllipsoidPCACreator")(Factory);
local MOAIOBBPCACreator = require("MOAIOBBPCACreator")(Factory);
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
	Factory:register("AABB", MOAIAABBCreator:new());
	Factory:register("SphereCentroid", MOAISphereCentroidCreator:new());
	Factory:register("SphereRitter", MOAISphereRitterCreator:new());
	Factory:register("SphereLarsson", MOAISphereLarssonCreator:new());
	Factory:register("SpherePCA", MOAISpherePCACreator:new());
	-- Factory:register("EllipsoidPCA", MOAIEllipsoidPCACreator:new());
	Factory:register("OBBPCA", MOAIOBBPCACreator:new());
end

initialize();

return Factory;


