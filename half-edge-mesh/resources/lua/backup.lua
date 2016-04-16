local function deserializeLayer(self)

    local function unpickleThis()
        local up;
        function deserialize(arg1, pickle)
            print(arg1);
            up = unpickleMe( pickle );
            print(up.name);
            for k,prop in pairs(up.props) do
                print(prop.name);
            end
        end
        dofile("../layers/pickleFile.lua");
        return up;
    end 

    function unpickleMe(s)
        local tables = s;

        for tnum = 1, table.getn(tables) do
            local t = tables[tnum]
            local tcopy = {}; for i, v in pairs(t) do tcopy[i] = v end
            for i, v in pairs(tcopy) do
              local ni, nv
              if type(i) == "table" then ni = tables[i[1]] else ni = i end
              if type(v) == "table" then nv = tables[v[1]] else nv = v end
              t[i] = nil
              t[ni] = nv
            end
        end
        return tables[1]
    end
    layerFromFile = unpickleThis();
    createHackLayer(self);

    local function addPropToLayer(layer)
        local file = assert ( io.open ( 'shader.vsh', mode ))
        vsh = file:read ( '*all' )
        file:close ()

        local file = assert ( io.open ( 'shader.fsh', mode ))
        fsh = file:read ( '*all' )
        file:close ()

        local gfxQuad = MOAIGfxQuad2D.new ()
        gfxQuad:setTexture ( "../textures/moai.png" )
        gfxQuad:setRect ( -64, -64, 64, 64 )
        gfxQuad:setUVRect ( 0, 1, 1, 0 )

        -- create metaball to hook shader to
        local metaball = MOAIMetaBall.new();
        metaball:setDeck(gfxQuad);
        metaball:moveRot(0, 0, 360, 5, MOAIEaseType.LINEAR);
        layer.layer:insertProp(metaball);

        local color = MOAIColor.new ()
        color:setColor ( 0, 0, 1, 0 )
        color:seekColor(1, 1, 1, 1, 5, MOAIEaseType.LINEAR);
        --color:moveColor(1, 1, 1, 0, 1 );

        local shader = MOAIShader.new ()
        shader:reserveUniforms ( 1 )
        shader:declareUniform ( 1, 'maskColor', MOAIShader.UNIFORM_COLOR )

        shader:setAttrLink ( 1, color, MOAIColor.COLOR_TRAIT )

        shader:setVertexAttribute ( 1, 'position' )
        shader:setVertexAttribute ( 2, 'uv' )
        shader:setVertexAttribute ( 3, 'color' )
        shader:load ( vsh, fsh )

        gfxQuad:setShader ( shader )

        return metaball;
    end

    -- add props to hack layer
    for _,prop in pairs(layerFromFile.props) do
        newProp = addPropToLayer(self);
        newProp:setLoc(math.random(-200, 200), math.random(-200, 200), 0)
    end
end





local function createHackLayer(self)
    -- layer viewport
    local windowManager = require "WindowManager";
    local screenWidth = windowManager.screenWidth;
    local screenHeight = windowManager.screenHeight;
    local newViewport = MOAIViewport.new();
    newViewport:setSize(screenWidth, screenHeight);
    newViewport:setScale(screenWidth, screenHeight);

    -- layer camera
    local newCamera = MOAICamera.new();
    newCamera:setLoc(0, 0, newCamera:getFocalLength(screenWidth));

    local layer = MOAILayer.new();
    layer:setViewport(newViewport);
    layer:setCamera(newCamera);

    self["layer"] = layer;
    self["camera"] = newCamera;
    self["viewport"] = newViewport;
end


local function initHack()
    local layerManager = require "LayerManager"
    local windowManager = require "WindowManager";

    local foregroundLayerIndex = layerManager:createLayer();
    local foregroundLayer = layerManager:getLayerAtIndex(foregroundLayerIndex);
    MOAISim.pushRenderPass(foregroundLayer.layer);

    foregroundLayer:setPosition(-200, 0);
    --backgroundLayer:setPosition(200, 200);
    
    local function shaderTest()
        if 1 then return end;
        local file = assert ( io.open ( 'shader.vsh', mode ))
        vsh = file:read ( '*all' )
        file:close ()

        local file = assert ( io.open ( 'shader.fsh', mode ))
        fsh = file:read ( '*all' )
        file:close ()

        local gfxQuad = MOAIGfxQuad2D.new ()
        gfxQuad:setTexture ( "../textures/moai.png" )
        gfxQuad:setRect ( -64, -64, 64, 64 )
        gfxQuad:setUVRect ( 0, 1, 1, 0 )

        -- create metaball to hook shader to
        local metaball = MOAIMetaBall.new();
        metaball:setDeck(gfxQuad);
        metaball:moveRot(0, 0, 360, 5, MOAIEaseType.LINEAR);
        foregroundLayer.layer:insertProp(metaball);

        local color = MOAIColor.new ()
        color:setColor ( 0, 0, 1, 0 )
        color:seekColor(1, 1, 1, 1, 5, MOAIEaseType.LINEAR);
        --color:moveColor(1, 1, 1, 0, 1 );

        local shader = MOAIShader.new ()
        shader:reserveUniforms ( 1 )
        shader:declareUniform ( 1, 'maskColor', MOAIShader.UNIFORM_COLOR )

        shader:setAttrLink ( 1, color, MOAIColor.COLOR_TRAIT )

        shader:setVertexAttribute ( 1, 'position' )
        shader:setVertexAttribute ( 2, 'uv' )
        shader:setVertexAttribute ( 3, 'color' )
        shader:load ( vsh, fsh )

        gfxQuad:setShader ( shader )
    end

    shaderTest();

    Factory = require "Factory";
end