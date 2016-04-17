package.path = package.path .. ';resources/lua/?.lua'
package.path = package.path .. ';resources/prototypes/?.lua'
package.path = package.path .. ';resources/props/?.lua'

-- window must exist before main thread can run
require("WindowManager"):openWindow("CS350");

-- create and run the game loop thread
mainThread = MOAIThread.new();
mainThread:run(require(require("ConfigurationManager"):get("mainThread")));

MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0.5, 0.5, 0.5 )
