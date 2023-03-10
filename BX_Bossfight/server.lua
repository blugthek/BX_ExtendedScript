---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Blugthek.
--- DateTime: 9/3/2022 5:51 PM
---
local CurrentResourceName = GetCurrentResourceName()
local isReady = false
local ESX = nil
local playerDmgDatabase = {}
local playerLootDatabase = {}
local bossPed

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    isReady = true

    ESX.RegisterServerCallback(CurrentResourceName..':checkInitialized',function(_, cb)
        cb(isReady)
    end)

    ESX.RegisterServerCallback(CurrentResourceName..':getPlayerDatabase',function(_, cb)
        cb(playerDmgDatabase)
    end)

    ESX.RegisterServerCallback(CurrentResourceName..':createServerBoss',function(source, callback,bPed)
        local checker = false
        local data = {}
        playerDmgDatabase = {}
        playerDmgDatabase[source] = {}
        playerDmgDatabase[source]['mainCharacter'] = true
        playerDmgDatabase[source]['hasExit'] = false
        data.mainChar = true
        bossPed = bPed
        data.bPed = bossPed
        TriggerEvent(CurrentResourceName..':server:UpdatePlayer')
        callback(data)
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Citizen.Wait(1000)
    print()
    print('The resource ' .. resourceName .. ' has been started.')
    print('Custom script BY BLUGTHEK')
    print()
end)

AddEventHandler('esx:playerLoaded', function(source)
    while isReady == false do
        Citizen.Wait(0)
    end
    TriggerClientEvent(CurrentResourceName..':initialise',source)
    TriggerClientEvent(CurrentResourceName..':UpdatePlayerDatabase',source,playerDmgDatabase)
end)

AddEventHandler(CurrentResourceName..':server:UpdatePlayer',function()
    TriggerClientEvent(CurrentResourceName..':UpdatePlayerDatabase',-1,playerDmgDatabase)
end)

RegisterServerEvent(CurrentResourceName .. ':server:RefreshPlayer')
AddEventHandler(CurrentResourceName .. ':server:RefreshPlayer', function()
    playerDmgDatabase = {}
    TriggerClientEvent(CurrentResourceName..':UpdatePlayerDatabase',-1,playerDmgDatabase)
end)

RegisterServerEvent(CurrentResourceName .. ':server:AddPlayer')
AddEventHandler(CurrentResourceName .. ':server:AddPlayer', function()
    local source_ = source
    playerDmgDatabase[source_] = {}
    playerDmgDatabase[source_]['hasExit'] = false
    TriggerClientEvent(CurrentResourceName..':UpdatePlayerDatabase',-1,playerDmgDatabase)
end)

RegisterServerEvent(CurrentResourceName .. ':server:PlayerExit')
AddEventHandler(CurrentResourceName .. ':server:PlayerExit', function()
    local source_ = source
    playerDmgDatabase[source_] = {}
    playerDmgDatabase[source_]['hasExit'] = true
    TriggerClientEvent(CurrentResourceName..':UpdatePlayerDatabase',-1,playerDmgDatabase)
end)

RegisterServerEvent(CurrentResourceName .. ':server:addPowerUpBossLocation')
AddEventHandler(CurrentResourceName .. ':server:addPowerUpBossLocation', function(coord)
    local coord_ = coord
    playerLootDatabase[#playerLootDatabase + 1] = coord_
    TriggerClientEvent(CurrentResourceName..':updateLootBossCoord',-1,playerLootDatabase)
end)