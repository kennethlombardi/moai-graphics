package.path = package.path .. ';resources/lua/?.lua'
package.path = package.path .. ';resources/prototypes/?.lua'
package.path = package.path .. ';resources/props/?.lua'

holyGlobalBatman = "1234567"

-- window must exist before main thread can run
require("WindowManager"):openWindow("CS350");

-- create and run the game loop thread
mainThread = MOAIThread.new();
-- local configurationManager = require("ConfigurationManager")
-- local mainThread = configurationManager:get("mainThread")
mainThread:run(require("ManagerGameLoop"))
-- mainThread:run(require(require("ConfigurationManager"):get("mainThread")));
