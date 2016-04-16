local Script = {
	name = "AccelerometerDebug.lua",
};

local t = 0;
local InputManager = require("InputManager");
function Script.update(object, dt)
  if InputManager.Android then
    object:setText(string.format('%.4f : %.4f : %.4f\n%.4f : %.4f : %.4f\n%.1f : %.1f : %.1f', InputManager.Android.accel.x, InputManager.Android.accel.y, InputManager.Android.accel.z, InputManager.Android.baseAccel.x, InputManager.Android.baseAccel.y, InputManager.Android.baseAccel.z, InputManager.Android.diffAccel.x, InputManager.Android.diffAccel.y, InputManager.Android.diffAccel.z));
    --object:setText(string.format('%.4f : %.4f\n%.4f : %.4f', InputManager.Android.window.x, InputManager.Android.window.y, InputManager.Android.world.x, InputManager.Android.world.y));
    --object:setText(string.format('%s %s %s', tostring(InputManager.Android.key[0][1]), tostring(InputManager.Android.key[0][2]), tostring(InputManager.Android.key[0][3])));
  end
end

return Script;