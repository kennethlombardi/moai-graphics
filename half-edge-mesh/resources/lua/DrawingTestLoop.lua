objects = {}



local function draw()
  for k, v in pairs(objects) do
    v:instanceHello();
  end
	
end

local function update()
  draw();
end

local function init()
  objects[1] = MOAIFoo.new();
  local prop = MOAIProp2D.new();
  local gfxQuad = MOAIGfxQuad2D.new ()
  gfxQuad:setTexture ( "../textures/moai.png" )
  gfxQuad:setRect ( -64, -64, 64, 64 )
  gfxQuad:setUVRect ( 0, 1, 1, 0 )
  
  prop:setDeck( gfxQuad );
  
  layer:insertProp( prop );
end

local done = false;
function testGameLoop ()
	init();
	while not done do
		update();
    coroutine.yield()
	end
end

return testGameLoop;