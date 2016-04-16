local MessageManager = {
	listeners = {},
	messageQueue = {},
	messageTypes = {},
}

function MessageManager:listen(messageType, callback)
	self.listeners[messageType] = self.listeners[messageType] or {};
	table.insert(self.listeners[messageType], callback);
end

function MessageManager:register(messageType)
	self.messageTypes[messageType] = messageType;
end

function MessageManager:send(messageType, payload)
	if self.messageTypes[messageType] == nil then
		print("Message type", messageType, "does not exist");
		return;
	end
	self.messageQueue[messageType] = self.messageQueue[messageType] or {};
	table.insert(self.messageQueue[messageType], payload);
end

function MessageManager:shutdown()
	self.listeners = nil;
	self.messageQueue = nil;
	self.messageTypes = nil;
end

function MessageManager:update(dt)
	for messageType, payload in pairs(self.messageQueue) do
		for _, callback in pairs(self.listeners[messageType] or {}) do
			if #payload > 0 then
				for k,v in pairs(payload) do
					callback(v)
				end
			else
				callback(payload)
			end
		end
	end
	self.messageQueue = {};
end

MessageManager:register("ADD_TIMER");
MessageManager:register("CHECKPOINT");
MessageManager:register("CLICKED_CREDITS_BUTTON");
MessageManager:register("CLICKED_CREDITS_BACK_BUTTON");
MessageManager:register("CLICKED_PAUSE_BUTTON");
MessageManager:register("CLICKED_PLAY_BUTTON");
MessageManager:register("CLICKED_QUIT_BUTTON");
MessageManager:register("CLICKED_RETRY_BUTTON");
MessageManager:register("CLICKED_RESUME_BUTTON");
MessageManager:register("GAME_INITIALIZED");
MessageManager:register("LAYER_FINISHED_TRANSITION");
MessageManager:register("QUIT");
MessageManager:register("RAN_OUT_OF_TIME");
MessageManager:register("SPLASH_SCREEN");
MessageManager:register("START_GAME");
MessageManager:register("SUB_TIMER");
MessageManager:register("TEST");

return MessageManager