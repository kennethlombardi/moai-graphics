require "BoxMesh"

-- screen stuff initializing
if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 720 end
assert (not (screenWidth == nil))
viewport = MOAIViewport.new()
viewport:setSize(screenWidth,screenHeight)
viewport:setScale(screenWidth,screenHeight)

layer = MOAILayer.new()
layer:setViewport(viewport)

MOAIRenderMgr.pushRenderPass(layer)

camera = MOAICamera.new()
camera:setLoc(0,0, camera:getFocalLength(screenWidth))
layer:setCamera(camera)

skyBox = MOAIGfxQuad2D.new()
skyBox:setTexture ("room.png")
skyBox:setRect(-screenWidth/2, -screenHeight/2, screenWidth/2, screenHeight/2)

skyBoxProp= MOAIProp2D.new ()
skyBoxProp:setDeck ( skyBox )
skyBoxProp:setParent ( dynbody )
layer:insertProp ( skyBoxProp )

--font junk
local font = MOAIFont.new()
font:loadFromTTF ( "arial-rounded.ttf", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!", 12, 163 )



fpscounter = MOAITextBox.new()
fpscounter:setFont(font)
fpscounter:setTextSize(24)
fpscounter:setRect(-50, -50, 50, 50)
fpscounter:setLoc(-550, 300)
fpscounter:setAlignment(MOAITextBox.LEFT_JUSTIFY)
fpscounter:setYFlip(true)
layer:insertProp(fpscounter)

ballcounter = MOAITextBox.new()
ballcounter:setFont(font)
ballcounter:setTextSize(24)
ballcounter:setRect(-50, -50, 50, 50)
ballcounter:setLoc(550, 300)
ballcounter:setAlignment(MOAITextBox.LEFT_JUSTIFY)
ballcounter:setYFlip(true)
layer:insertProp(ballcounter)

world = MOAIBox2DWorld.new()
world:setGravity(0,-10)
world:setUnitsToMeters(1/100)
world:setDebugDrawEnabled(true)
world:setDebugDrawFlags(MOAIBox2DWorld.DebugDrawShapes)
world:start()
layer:setBox2DWorld(world)

ballc = 0
--circle

function MakeCircle(x, y)
	dynbody = world:addBody (MOAIBox2DBody.DYNAMIC)
	fixture = dynbody:addCircle(0, 0, 10)
	dynbody:setTransform(x,y)
	fixture:setFriction(0)
	fixture:setRestitution(.01)
  fixture.userData = "water"
  --fixture:setFilter(0x01)
--  fixture:setCollisionHandler(onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x03)
	dynbody:resetMassData()
	ballc = ballc + 1
  
  --texture = MOAIGfxQuad2D.new ()
  --texture:setTexture ( "water.png" )
  --texture:setRect ( -20, -20, 20, 20 )
  texture = MOAITileDeck2D.new()
  texture:setTexture ("waters.png")
  texture:setSize (2, 2)
  texture:setRect(-40, -40, 40, 40)
  
  sprite = MOAIProp2D.new ()
  sprite:setDeck ( texture )
  sprite:setParent ( dynbody )
  layer:insertProp ( sprite )
  
  curve = MOAIAnimCurve.new()
  curve:reserveKeys ( 4 )
  curve:setKey ( 1, 0.00, 1, MOAIEaseType.FLAT )
  curve:setKey ( 2, 0.25, 2, MOAIEaseType.FLAT )
  curve:setKey ( 3, 0.50, 3, MOAIEaseType.FLAT )
  curve:setKey ( 4, 0.75, 4, MOAIEaseType.FLAT )
  --curve:setKey ( 5, 1.00, 1, MOAIEaseType.FLAT )
 
  anim = MOAIAnim.new ()
  anim:reserveLinks ( 1 )
  anim:setLink ( 1, curve, sprite, MOAIProp2D.ATTR_INDEX )
  anim:setMode ( MOAITimer.LOOP )
  anim:start ()
--dynbody:applyAngularImpulse(2)
	return body
end


--edges
screen = {
	--bottom
	-640, -360,
	 640, -360,
	--right
	 640, -360,
	 640,  360,
	--top
	 640,  360,
	-640,  360,
	--left
	-640,  360,
	-640, -360,
	
	--goal
	-550, -200,
	-550, -360,
	-400, -360,
	-400, -200,	
	}
staticbody = world:addBody(MOAIBox2DBody.STATIC)
fixture2 = staticbody:addEdges(screen)

lidTop = {
  -550, -200,
  -400, -200,
}

--oneWayBody = world:addBody(MOAIBox2DBody.STATIC)
--fixture3 = staticbody:addEdges(lidTop)
--fixture3.userdata = "lid"
--fixture3:setFilter(0x03)
--fixture3:setCollisionHandler(onCollide, MOAIBox2DArbiter.BEGIN + MOAIBox2DArbiter.END, 0x01)
--image junk


slideNum = 1

slides = {
	"EngineProofWho1.png",
	"EngineProofWho2.png",
	"EngineProofWho3.png",
	"EngineProofWho4.png",
	"EngineProofWho5.png",
  "EngineProofWho6.png",
	"EngineProofWho7.png",
	"EngineProofWho8.png",
	"EngineProofWho9.png",
	"EngineProofWho10.png",
	"EngineProofWho11.png",
  "EngineProofWho12.png",
  "EngineProofWho13.png",
	"EngineProofWho14.png",
	"EngineProofWho15.png",
	"EngineProofWho16.png",
	"EngineProofWho17.png",
	"EngineProofWho18.png"}
	
image = MOAIGfxQuad2D.new()
image:setTexture("EngineProofWho1.png")
image:setRect(-640,-360,640,360)

function ChangeSlide()
	image:setTexture(slides[slideNum])
end

prop = MOAIProp2D.new()
prop:setDeck(image)
layer:insertProp(prop)

slideOver = false
gameOver = false
lastX = 0
lastY = -10

function angle ( x2, y2 )

	return math.atan2 ( y2, x2) * ( 180 / math.pi )
end

function RotateArrow(ang)	
	prop:setRot(ang)
end

function normalize(x, y)
	mag = math.sqrt(x*x+y*y)
	return x/mag, y/mag
end


local textbox = MOAITextBox.new()
textbox:setFont(font)
textbox:setTextSize(24)
textbox:setRect(-200, -200, 200, 200)
textbox:setLoc(0,100)
textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY)
textbox:setYFlip(true)
layer:insertProp(textbox)

function gameLoop()		
		
		while not slideshowOver do
			coroutine.yield()
				
			if MOAIInputMgr.device.pointer then			
				if MOAIInputMgr.device.mouseLeft:down() then
					wx,wy = layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc())
					if wx < 0 then
						if slideNum > 1 then
							slideNum = slideNum - 1
						end
					else
						if slideNum < table.getn(slides) then
							slideNum = slideNum + 1
						else
							slideshowOver = true
						end
					end
					ChangeSlide()
				end
				
			else --touch and gyro
				MOAIInputMgr.device.touch:setCallback (					
					function ( eventType, idx, x, y, tapCount )						
						if eventType == MOAITouchSensor.TOUCH_DOWN then
							wx,wy = (layer:wndToWorld(x,y))
							if wx < 0 then
								if slideNum > 1 then
									slideNum = slideNum - 1
								end
							else
								if slideNum < table.getn(slides) then
									slideNum = slideNum + 1
								else
									slideshowOver = true
								end
							end
							ChangeSlide()
						end
					end
				)			
			end
		end
		layer:removeProp(prop)
		
    local mesh = makeCube(128, 'goal.png')
    
    prop = MOAIProp.new()
    prop:setDeck(mesh)
    prop:setLoc(-450, -280)
    prop:moveRot(0, 2160, 0, 120)
    prop:setShader ( MOAIShaderMgr.getShader ( MOAIShaderMgr.MESH_SHADER ))
    prop:setCullMode ( MOAIProp.CULL_BACK )
    layer:insertProp ( prop )
    
		while not gameOver do
			coroutine.yield()
      if (ballc < 100) then      
        MakeCircle(0, 0)
      end
      
      if MOAIInputMgr.device.pointer then	
        if MOAIInputMgr.device.mouseLeft:down() then
					--MakeCircle(layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc()))
					lastX, lastY = layer:wndToWorld( MOAIInputMgr.device.pointer:getLoc())				
        end
      else	
        MOAIInputMgr.device.level:setCallback(  --gyro
            function(x, y, z)
              lastX = x
              lastY = y
            end
        )
          
        MOAIInputMgr.device.touch:setCallback (				--touch	
          function ( eventType, idx, x, y, tapCount )						
            if MOAIInputMgr.device.touch.isDown() then --eventType == MOAITouchSensor.TOUCH_DOWN then
              --MakeCircle(layer:wndToWorld(x,y))
              lastX, lastY = layer:wndToWorld(x,y)
            end
          end
        )
      end
			
			lastX, lastY = normalize(lastX, lastY)
			gravScale = 100						
      
      if not MOAIInputMgr.device.pointer then	
        world:setGravity (lastY * gravScale, -lastX*gravScale)				
        textbox:setString("Gravity\n" .. "X " .. lastY*10 .. "\nY " .. lastX*10 )
      else
        world:setGravity(lastX * gravScale, lastY*gravScale)
        textbox:setString("Gravity\n" .. "X " .. lastX*10 .. "\nY " .. lastY*10 )
      end
			--dynbody:setAwake(true)
			
			--RotateArrow(currAngle)
						
			
			fpscounter:setString("FPS: " .. MOAISim.getPerformance())
			ballcounter:setString("NumBalls: " .. ballc)			
		end				
	end