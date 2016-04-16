local SceneManager = {
    activeScene = nil
}

function SceneManager:shutdown()
	MessageManager = nil;
	LayerManager = nil;
	Factory = nil;
    GameVariables = nil;
	self:removeAllScenes();
end

function SceneManager:update(dt)
	self.activeScene:update(dt);
end

function SceneManager:removeAllScenes()
end

function SceneManager:addSceneFromFile(filename)
    if(self.activeScene) then self.activeScene:exit(); end
    self.activeScene = dofile("../scenes/" .. filename);
    self.activeScene:enter();
end

return SceneManager