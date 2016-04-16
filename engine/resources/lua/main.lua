-- window must exist before main thread can run
require("WindowManager"):openWindow("CS350");

-- create and run the game loop thread
mainThread = MOAIThread.new();
mainThread:run(require(require("ConfigurationManager"):get("mainThread")));