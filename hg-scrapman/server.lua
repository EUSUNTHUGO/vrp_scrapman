local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","hg-scrapman")

local job = "Scrapman"

RegisterServerEvent('scrapman:giveitem') 
AddEventHandler('scrapman:giveitem', function()
	local _source = source
    local user_id = vRP.getUserId({_source})
    if vRP.getInventoryItemAmount({user_id, "fiervechii"}) < 10 then
        if vRP.getUserGroupByType({user_id,"job"}) == job then
            TriggerClientEvent('scrapjob:freezeentirty', source)
            TriggerClientEvent('srawtesxt', source)
            TriggerClientEvent('scrapjob:craftanimacja22', source)
            TriggerClientEvent('scrapjob:drawtext', source)
            Citizen.Wait(5000)
            local random = math.random(10,35)
            vRP.giveInventoryItem({user_id,"fiervechi", random, true})
            TriggerClientEvent('scrapjob:craftite', _source)
            vRPclient.mnotify(_source,{"Ai colectat "..random.." resturi din masina!"})
        else
            TriggerClientEvent('scrapjob:stopcraftanimacja2', source)
            vRPclient.mnotify(source,{"Nu detii jobul de colector fier vechi."})
        end 
    else
        vRPclient.mnotify(source,{"Nu poti cara mai mult de 10 cutii de fier vechi."})
    end
end)

RegisterServerEvent('scrapman:sell') 
AddEventHandler('scrapman:sell', function()
	local _source = source
    local user_id = vRP.getUserId({_source})
    local iteme = vRP.getInventoryItemAmount({user_id, "fiervechi"})
    if vRP.getUserGroupByType({user_id,"job"}) == job then
        if iteme >= 1 then
            local pret = 1
            vRP.tryGetInventoryItem({user_id, "fiervechi", iteme, false}) 
            TriggerClientEvent('vanzare:animatiee2', source)
            Citizen.Wait(3000)
            vRP.giveMoney({user_id, iteme*pret})
            TriggerClientEvent('odlacz:propa', _source)
            vRPclient.mnotify(_source,{"Ai vandut: "..iteme.." cutii de fier vechi si ai primit: "..iteme*pret.." $."})
        else
            vRPclient.mnotify(_source,{"Nu ai fier vechi!"})
        end
    else
        vRPclient.mnotify(_source,{"Nu ai jobul de colector fier vechi."})
    end 
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        if vRP.getUserGroupByType({user_id,"job"}) == job then
            TriggerClientEvent('hugo:addblips', source)
        end
    end
  end)

AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
	local player = vRP.getUserSource({user_id})
	if gtype == "job" then 
		if group == job then
            TriggerClientEvent('hugo:addblips', player)
        end
	end
end)

AddEventHandler("vRP:playerLeaveGroup", function(user_id, group, gtype)
    local player = vRP.getUserSource({user_id})
	if gtype == "job" then 
		if group == job then
            TriggerClientEvent('hugo:deleteblips', player)
        end
	end
end)
  
