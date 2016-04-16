local Script = {
	name = "titleLayerTransitionOut.lua",
};

function Script.update(layer, dt)
	local props = layer:getAllProps();
	for k,v in pairs(props) do
		local position = v:getLoc();
		v:setLoc(position.x + 1000 * dt, position.y, position.z);
	end
	
	local playButton = layer:getPropByName("playButton");
	if playButton and playButton:getType() == "Prop" then
		local fudge = 500;
		if playButton:getLoc().x > require("WindowManager").screenWidth / 2 + playButton:getSize().x / 2 + fudge then
			require("MessageManager"):send("LAYER_FINISHED_TRANSITION", layer:getName());
		end
	end
end

return Script;