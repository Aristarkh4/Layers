local composer = require("composer")
local scene = composer.newScene()

local numberOfLevel = 'test'

local information = require("information.levels")
local size = information.returnInfo('size', numberOfLevel) -- number of strings and columns
local numberOfBT = information.returnInfo('numberOfBT', numberOfLevel) -- number of black tiles
local isTurnable = information.returnInfo('isTurnable', numberOfLevel)
local isSpinable = information.returnInfo('isSpinable', numberOfLevel)
local numberOfLayers = information.returnInfo('numberOfLayers', numberOfLevel)
local layers = information.returnInfo('layers', numberOfLevel)

local w = display.contentWidth
local h = display.contentHeight

local fieldSize = 0.8*w/math.sqrt(2)
local tileSize = fieldSize/size

local numberOfWrongPresses = 0

local currentTopLayer = 0 -- which of layers is current topLayer

local topTilesTable = {}
local bottomTilesTable = {}	
-- Creating table of shadows for the bottom layer
local bottomShadowTable = {}
local counter = 0
for i = 0, size-2 do
	bottomShadowTable[counter] = 9
	counter = counter + 1
	for j = 1, size-1 do
		bottomShadowTable[counter] = 15
		counter = counter + 1
	end
end
bottomShadowTable[counter] = 1
counter = counter + 1
for j = 1, size-1 do
	bottomShadowTable[counter] = 5
	counter = counter + 1
end
counter = nil
-------------------------------------------------
-- Function which changes shadows after correct touch 
local function changeShadows(a)
	local x = 0
	local y = 0
	local name = ''
	local border = size*size
	-- Tiles which are affected by this tile
	local sideTiles = {} -- left - 1, right - 2, up - 3, bottom - 4
	sideTiles[1] = a - size
	sideTiles[2] = a + 1
	sideTiles[3] = a - size + 1
	sideTiles[4] = a
	----------------------------------------
	-- Border tiles
	if (math.fmod(a+1, size) == 0) then
		sideTiles[2] = -1
		sideTiles[3]= -1
	end
	----------------------------------------
	-- Costs of the shadows
	local shadowCosts = {}
	for i = 1, 4 do
		shadowCosts[i] = math.pow(2, (i-1))
	end
	-----------------------

	for i = 1, 4 do
		if ((sideTiles[i] > -1)and(sideTiles[i] < border)) then
			bottomShadowTable[sideTiles[i]] = bottomShadowTable[sideTiles[i]] - shadowCosts[5-i]
			x = bottomTilesTable[sideTiles[i]].x
			y = bottomTilesTable[sideTiles[i]].y
			name = bottomTilesTable[sideTiles[i]].name
			bottomTilesTable[sideTiles[i]]:removeSelf()
			bottomTilesTable[sideTiles[i]] = nil
			bottomTilesTable[sideTiles[i]] = display.newImageRect(bottomLayer, 'images/'..layers[currentTopLayer + 1]['top'][sideTiles[i]+1]..bottomShadowTable[sideTiles[i]]..'.jpg', tileSize, tileSize)
			bottomTilesTable[sideTiles[i]].x = x
			bottomTilesTable[sideTiles[i]].y = y
			bottomTilesTable[sideTiles[i]].name = name
		end
	end
	return
end
-----------------------------------------------------
-- Function which spins the field after swipe--------
local function spin(d)
	if (isSpinable) then
		if (d == 'left') then
			topLayer.rotation = topLayer.rotation + 90
			bottomLayer.rotation = bottomLayer.rotation + 90
		else
			topLayer.rotation = topLayer.rotation - 90
			bottomLayer.rotation = bottomLayer.rotation - 90
		end
	end
	return
end
-----------------------------------------------------
-- Function which turns the field upside down--DO!!!!
local function turn(d)
	if (isTurnable) then
	end
	return
end
-----------------------------------------------------
local function topTileTouched(event)
	local tile = event.target
	if (event.phase == "began") then -- only after touch(so it happense only once)
		if (layers[currentTopLayer + 1]['top'][tile.name+1] == 'b') then
			audio.play(correctSound)
			-- Deleting tile
			layers[currentTopLayer]['top'][tile.name+1] = 't'
			tile.isVisible = false
			----------------
			changeShadows(tile.name+0)
			numberOfBT = numberOfBT - 1
			numberOfBTText.text = numberOfBT
		else
			audio.play(wrongSound)
			numberOfWrongPresses = numberOfWrongPresses + 1
			numberOfWrongPressesText.text = numberOfWrongPresses
		end
	end
end	
-----------------------------------------------------
local function swipeAction(event)
	if (event.phase == "ended") then
		local dx = event.x - event.xStart -- x movement
		local dy = event.y - event.yStart -- y movement
		local adx = math.abs(dx)
		local ady = math.abs(dy)
		
		if ((adx > 10)or(ady > 10)) then
			if (adx > ady) then -- left or right
				if (dx > 0) then
					spin('right')
				else
					spin('left')
				end
			else                -- up or down
				if (dy > 0) then
					turn('down')
				else
					turn('up')
				end
			end
		end
	end
	return
end
-----------------------------------------------------


-- Scene functions

-- create()
function scene:create( event )

    local sceneGroup = self.view
	--Loading sounds
	correctSound= audio.loadSound("sounds/correct.wav")
	wrongSound = audio.loadSound("sounds/wrong.wav")
	audio.setVolume(0.5)
    ----------------
	-- Code here runs when the scene is first created but has not yet appeared on screen
	

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
		local backgroung = display.newImage('images/Background_w.jpg', w*0.5, h*0.5)
		-- Information about progress
		numberOfBTText = display.newText(numberOfBT, w*0.9, h*0.04, 'Helvetica', 25)
		numberOfWrongPressesText = display.newText(numberOfWrongPresses, w*0.904, h*0.1, 'Helvetica', 25)
		numberOfWrongPressesText:setFillColor(0.8, 0.3, 0.3)
		-----------------------------
		
		bottomLayer = display.newGroup() -- the layer on which you are playing
		bottomLayer.x = w*0.5 --DECIDE BETTER
		bottomLayer.y = h*0.5 ---------------
		bottomLayer.rotation = 315
		
		topLayer = display.newGroup() -- the layer with black tiles
		topLayer.x = w*0.5 ------------------DECIDE BETTER
		topLayer.y = h*0.5 - tileSize*0.75  -----------------
		topLayer.rotation = 315
		
		-- Swipe touchscreen-------------------------------------
		local swipescreen = display.newRect(w*0.5, h*0.5, 2*w, 2*h)
		swipescreen.name = "swipescreen"
		swipescreen.alpha = 0
		swipescreen.isHitTestable = true
		swipescreen:addEventListener("touch", swipeAction)
		---------------------------------------------------------
		
		local counter = 0
		-- layers drawing----------------------------------------
		for i = 0, size-1 do
			for j = 0, size-1 do
				-- top layer formation ---------------------------------
				topTilesTable[counter] = display.newImageRect(topLayer, 'images/w0.jpg', tileSize, tileSize)
				topTilesTable[counter].x = tileSize*(j+0.5) - fieldSize*0.5
				topTilesTable[counter].y = tileSize*(i+0.5) - fieldSize*0.5
				topTilesTable[counter].name = ''..counter
				topTilesTable[counter]:addEventListener('touch', topTileTouched)
				-- Removing transparent tiles
				if (layers[currentTopLayer]['top'][counter+1]) == 't' then
					topTilesTable[counter].isVisible = false
				end
				-----------------------------
				---------------------------------------------------------
				--bottom layer formation --
				bottomTilesTable[counter] = display.newImageRect(bottomLayer, 'images/'..layers[currentTopLayer + 1]['top'][counter+1]..bottomShadowTable[counter]..'.jpg', tileSize, tileSize)
				bottomTilesTable[counter].x = tileSize*(j+0.5) - fieldSize*0.5
				bottomTilesTable[counter].y = tileSize*(i+0.5) - fieldSize*0.5
				bottomTilesTable[counter].name = ''..counter
				--
				counter = counter + 1
			end
		end
		----------------------------------------------------------
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
		
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
	
	audio.dispose(correctSound)
	audio.dispose(wrongSound)
	
	local counter = 0
    for i = 0, size-1 do
		for j = 0, size-1 do
			topTilesTable[counter]:removeEventListener('touch', topTileTouched)
			counter = counter+1
		end
	end
	
	swipescreen:removeEventListener('touch', swipeAction)
end


-- -----------------------------------------------------------------------------
-- Scene function listeners
-- -----------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------

return scene