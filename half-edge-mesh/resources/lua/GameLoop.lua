local done = false;

function gameLoop ()
	while not done do
		coroutine.yield()

	end
end

return gameLoop;