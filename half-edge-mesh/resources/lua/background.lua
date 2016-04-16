local function initBackground(layer, screenWidth, screenHeight)
  local skyBox = MOAIGfxQuad2D.new()
  skyBox:setTexture ("../textures/room.png")
  skyBox:setRect(-screenWidth/2, -screenHeight/2, screenWidth/2, screenHeight/2)

  skyBoxProp= MOAIProp2D.new ()
  skyBoxProp:setDeck ( skyBox )
  skyBoxProp:setParent ( dynbody )
  layer:insertProp ( skyBoxProp )
end

return initBackground;
