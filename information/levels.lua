local publicClass = {}

local size = {}
local numberOfBT = {}
local isTurnable = {}
local isSpinable = {}
local numberOfLayers = {}
local layers = {}

-- LEVELS -------------------------------
-- Level Test -----------------------
	size['test'] = 8
	numberOfBT['test'] = 49
	isTurnable['test'] = false
	isSpinable['test'] = true
	numberOfLayers['test'] = 2
	-- Layers layout
	layers['test'] = {}

	layers['test'][0] = {}
	layers['test'][0]['top'] = {}
	for i = 1, size['test']*size['test'] do
		layers['test'][0]['top'][i] = 'w'
	end

	layers['test'][1] = {}
	layers['test'][1]['top'] = {'b', 'b', 'b', 'b', 'b', 'b', 'b', 'w',
								'b', 'b', 'b', 'b', 'b', 'b', 'b', 'w',
								'b', 'b', 'b', 'b', 'b', 'b', 'b', 'w',
								'b', 'b', 'b', 'b', 'b', 'b', 'b', 'w',
								'b', 'b', 'b', 'b', 'b', 'b', 'b', 'w',
								'b', 'b', 'b', 'b', 'b', 'b', 'b', 'w',
								'b', 'b', 'b', 'b', 'b', 'b', 'b', 'w',
						        'w', 'w', 'w', 'w', 'w', 'w', 'w', 'w'}
-------------------------------------
-- Level 1 --------------------------
	size[1] = 1
	numberOfBT[1] = 1
	isTurnable[1] = false
	isSpinable[1] = false
	numberOfLayers[1] = 2
	-- Layers layout
	layers[1] = {}

	layers[1][0] = {}
	layers[1][0]['top'] = {} 
	for i = 1, size[1]*size[1] do
		layers[1][0]['top'][i] = 'w'
	end
	
	layers[1][1] = {}
	layers[1][1]['top'] = {'b'}
----------------
-------------------------------------
-- Level 2 --------------------------
	size[2] = 2
	numberOfBT[2] = 2
	isTurnable[2] = false
	isSpinable[2] = false
	numberOfLayers[2] = 2
	-- Layers layout
	layers[2] = {}

	layers[2][0] = {}
	layers[2][0]['top'] = {}
	for i = 1, size[2]*size[2] do
		layers[2][0]['top'][i] = 'w'
	end

	layers[2][1] = {}
	layers[2][1]['top'] = {'b', 'b',
						   'w', 'w'}
----------------
-------------------------------------
-- Level 3 --------------------------
	size[3] = 2
	numberOfBT[3] = 1
	isTurnable[3] = false
	isSpinable[3] = false
	numberOfLayers[3] = 2
	-- Layers layout
	layers[3] = {}

	layers[3][0] = {}
	layers[3][0]['top'] = {}
	for i = 1, size[3]*size[3] do
		layers[3][0]['top'][i] = 'w'
	end

	layers[3][1] = {}
	layers[3][1]['top'] = {'w', 'b',
						   'w', 'w'}
----------------
-------------------------------------
-----------------------------------------

-- Function which returns information
function publicClass.returnInfo(whatInfo, numberOfLevel)
	if (whatInfo == 'size') then
		return size[numberOfLevel]
	elseif (whatInfo == 'isTurnable') then
		return isTurnable[numberOfLevel]
	elseif (whatInfo == 'isSpinable') then
		return isSpinable[numberOfLevel]
	elseif (whatInfo == 'numberOfBT') then
		return numberOfBT[numberOfLevel]
	elseif (whatInfo == 'numberOfLayers') then
		return numberOfLayers[numberOfLevel]
	elseif (whatInfo == 'layers') then
		return layers[numberOfLevel]
	end
end
-------------------------------------
return publicClass