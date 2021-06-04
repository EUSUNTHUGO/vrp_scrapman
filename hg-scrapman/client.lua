vRP = Proxy.getInterface("vRP")
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

local PlayerData                = {}
local menuIsShowed 				 = false
local hasAlreadyEnteredMarker 	 = false
local hasAlreadyEnteredMarkerr 	 = false
local lastZone 					 = nil
local isInJoblistingMarker 		 = false
local isInJoblistingMarkerr 		 = false
local bet = 0
local wtrakcie = false
local bagModel = "prop_apple_box_01"
local bagspawned = nil
local maitem = false
local tekst = 0

local locatii = {
	{-491.460, -1746.190, 18.70},
	{-491.870, -1756.750, 19.20},
	{220.870, 6501.150, 31.20}
}

Citizen.CreateThread(function()
	local htime = 1000
	local intratwhile = false
	local coords2
	while true do
		if wtrakcie == false and maitem == false then
			local coords = GetEntityCoords(PlayerPedId())
			if intratwhile == false then
				for k,v in pairs(locatii) do
					local coordonate = vector3(v[1], v[2], v[3])
					if #(coords - coordonate) < 10.0 then
						intratwhile = true
						htime = 5
						coords2 = coordonate
					end
				end
			elseif intratwhile == true then
				htime = 5
				while intratwhile == true do
					Wait(5)
					coords = GetEntityCoords(PlayerPedId())
					if #(coords - coords2) < 10.0  then
						scrapman_drawtext("Apasa tasta ~y~E ~w~ pentru a lua fier vechi-ul!",0.5,0.94,0.7,255,255,255,255)
						if IsControlJustReleased(0, Keys['E']) then
								intratwhile = false
								coords2 = nil
								zbieranie()
						end
					else
						intratwhile = false
					end
				end
				intratwhile = false
			end
		end
		Citizen.Wait(htime)
		htime = 1000
	end
end)

function HelpText(text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 0, -1)
end

function zbieranie()
TriggerServerEvent('scrapman:giveitem')
wtrakcie = true
end

RegisterNetEvent('scrapjob:freezeentirty')
AddEventHandler('scrapjob:freezeentirty', function()
	playerPed = PlayerPedId()	
	ClearPedTasks(PlayerPedId())
	FreezeEntityPosition(playerPed, true)
end)
RegisterNetEvent('scrapjob:craftite')
AddEventHandler('scrapjob:craftite', function()
	playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(PlayerPedId())
	maitem = true
	Citizen.Wait(1000)
	wtrakcie = false
	TriggerEvent('podlacz:propa2')
end)


RegisterNetEvent('scrapjob:craftanimacja22')
AddEventHandler('scrapjob:craftanimacja22', function()
	TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
	Citizen.Wait(2000)
end)



function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(10)
	end
end
Citizen.CreateThread(function()
  
    RequestModel(GetHashKey("s_m_m_dockwork_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_dockwork_01")) do
      Wait(155)
    end

      local ped =  CreatePed(4, GetHashKey("s_m_m_dockwork_01"), -425.16, -1722.05, 18.20, 349.404, false, true)
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
end)
function scrapman_drawtext(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

Citizen.CreateThread(function()
	local htime = 1000
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		local shop = vector3(-423.260, -1720.750, 19.370)
		if #(coords-shop) <= 3.0 then
			htime = 5
			scrapman_drawtext("Apasa tasta ~y~E ~w~ pentru a vinde fier vechiul!",4,0.7,0.5,0.94,0.7,255,255,255,255)
			if IsControlJustReleased(0, Keys['E']) then
				skup()
		  	end
		end
		Citizen.Wait(htime)
		htime = 1000
	end
end)
RegisterNetEvent('podlacz:propa2')
AddEventHandler('podlacz:propa2', function()
	local ad = "anim@heists@box_carry@"
	loadAnimDict( ad )
	TaskPlayAnim( PlayerPedId(), ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )

	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	local szn = math.random(1,3)
	if szn == 1 then
		bagModel = 'prop_car_door_01'
		bagspawned = CreateObject(GetHashKey(bagModel), x, y, z+0.2,  true,  true, true)
		AttachEntityToEntity(bagspawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.00, 0.355, -75.0, 470.0, 0.0, true, true, false, true, 1, true)
		Citizen.Wait(10000)

	elseif szn == 2 then
		bagModel = 'prop_car_seat'
		bagspawned = CreateObject(GetHashKey(bagModel), x, y, z+0.2,  true,  true, true)
		AttachEntityToEntity(bagspawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.00, 0.355, -045.0, 480.0, 0.0, true, true, false, true, 1, true)
		Citizen.Wait(10000)

	else	
		bagModel = 'prop_rub_bike_02'
		bagspawned = CreateObject(GetHashKey(bagModel), x, y, z,  true,  true, true)
		AttachEntityToEntity(bagspawned, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.125, -0.50, 0.355, -045.0, 410.0, 0.0, true, true, false, true, 1, true)
		Citizen.Wait(10000)

	end

end)
RegisterNetEvent('vanzare:animatiee2')
AddEventHandler('vanzare:animatiee2', function()
	local playerPed = PlayerPedId()
	local lib, anim = 'gestures@m@standing@casual', 'gesture_easy_now'
	FreezeEntityPosition(playerPed, true)
	TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
end)
function skup()
	TriggerServerEvent('scrapman:sell')
	Citizen.Wait(3500)
	Citizen.Wait(13000)
	FreezeEntityPosition(PlayerPedId(), false)
	wtrakcie = false
end
	
RegisterNetEvent('odlacz:propa')
AddEventHandler('odlacz:propa', function()
	DetachEntity(bagspawned, 1, 1)
	DeleteObject(bagspawned)
	maitem = false
	ClearPedSecondaryTask(PlayerPedId())
	FreezeEntityPosition(PlayerPedId(), false)
end)

local blips = {
	{title="Punct Colectare 1", colour=5, id=468, x = -491.240, y = -1753.890, z = 19.00},
	{title="Vanzare Fier Vechi", colour=5, id=479, x = -422.020, y = -1720.250, z = 43.370}
}      

RegisterNetEvent('hugo:deleteblips')
AddEventHandler('hugo:deleteblips', function()
	for _, info in pairs(blips) do
		RemoveBlip(info.blip)
	end
end)

RegisterNetEvent('hugo:addblips')
AddEventHandler('hugo:addblips', function()
	for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 1.0)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	  end
end)

local UI = { 
	x =  0.000 ,	-- Base Screen Coords 	+ 	 x
	y = -0.001 ,	-- Base Screen Coords 	+ 	-y
}
RegisterNetEvent('scrapjob:drawtext')
AddEventHandler('scrapjob:drawtext', function()
	while wtrakcie == true do
		Citizen.Wait(1)
		drawTxt(UI.x + 0.9605, UI.y + 0.962, 1.0,0.98,0.4, "~y~[~w~".. tekst .. "%~y~]", 255, 255, 255, 255)
	end
end)
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('scrapjob:scoateoba')
AddEventHandler('scrapjob:scoateoba', function()
	wtrakcie = false
end)

RegisterNetEvent('srawtesxt')
AddEventHandler('srawtesxt', function()
	Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1
Citizen.Wait(37)
tekst = tekst + 1

Citizen.Wait(1500)
tekst = 0
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

