---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by BLUGTHEK.
--- DateTime: 7/27/2022 11:16 PM
---
local ESX
local police = 0
local medic = 0
local isReady = false
local xPlayers = {}
local identifier
local Updateblip
local markList = {}
local CurrentResourceName = GetCurrentResourceName()

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    
    isReady = true

    ESX.RegisterServerCallback('blugx:fetchNumberOfPolice',function(_, cb)
        cb(police)
    end)
    
    ESX.RegisterServerCallback('blugx:fetchNumberOfAmbulance',function(_, cb)
        cb(medic)
    end)

    ESX.RegisterServerCallback(CurrentResourceName..':fetchUserRank', function(source, cb)
        local player = ESX.GetPlayerFromId(source)

        if player ~= nil then
            local playerGroup = player.getGroup()

            if playerGroup ~= nil then
                cb(playerGroup)
            else
                cb("user")
            end
        else
            cb("user")
        end
    end)

    ESX.RegisterServerCallback(CurrentResourceName..':fetchUserJob', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer ~= nil then
            local xPlayerJob = xPlayer.job.name
            if xPlayerJob ~= nil then
                cb(xPlayerJob)
            else
                cb("unemployed")
            end
        else
            cb("unemployed")
        end
    end)

    ESX.RegisterServerCallback(CurrentResourceName..':checkInitialized',function(_, cb)
        cb(isReady)
    end)

    -- ระเบิดกระจกรถ
    ESX.RegisterServerCallback(CurrentResourceName..':BrokeCarWindows',function(_, cb,veh)
        TriggerClientEvent(CurrentResourceName..':Client:SmashWindows',-1,veh)
    end)
end)

-- License and ect.

RegisterServerEvent('blugx:checkLicense')
AddEventHandler('blugx:checkLicense',function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem(Config["License"]).count > 0 then
        xPlayer.set('License',true)
    else
        xPlayer.set('License',false)
    end
    if xPlayer.getInventoryItem(Config["VIPJobLicense"]).count > 0 then
        xPlayer.set('VIPJobLicense',true)
    else
        xPlayer.set('VIPJobLicense',false)
    end
    if xPlayer.getInventoryItem(Config["ExtraDropLicense"]).count > 0 then
        local xItem = xPlayer.getInventoryItem(Config["ExtraDropLicense"])
        local dropRate = xItem.count * 2
        xPlayer.set('Droprate',dropRate)
    end
end)

RegisterServerEvent('blugx:GetLicense')
AddEventHandler('blugx:GetLicense',function(cb,target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xLicense = xPlayer.get(target)
    cb(xLicense)
end)

RegisterServerEvent('blugx:printVar')
AddEventHandler('blugx:printVar',function(args)
    print(args)
end)

-- จัดการเกี่ยวกับผู้เล่น 
AddEventHandler('esx:playerLoaded', function(_, xPlayer)
    if xPlayer ~= nil and xPlayer.job.name == 'police' then
        police = police + 1
    elseif xPlayer ~= nil and xPlayer.job.name == 'ambulance' then
        medic = medic + 1        
    end
end)

-- ผู้เล่นเปลี่ยนอาชีพ
AddEventHandler('esx:setJob', function(_, job, lastJob) -- งานก่อนหน้า
    if lastJob.name == "police" then
        police = police - 1
    elseif job.name == "police" then
        police = police + 1        
    elseif lastJob.name == "ambulance" then
        medic = medic - 1
    elseif job.name == "ambulance" then
        medic = medic + 1
    end
end)

-- ผู้เล่นออกจากเกม
AddEventHandler('playerDropped', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer ~= nil then
        if xPlayer.job.name == 'police' and police > 0 then
            police = police - 1
        elseif xPlayer.job.name == 'ambulance' and police > 0 then
            medic = medic - 1            
        end
    end
    TriggerClientEvent(CurrentResourceName..':removeUser', -1, source)
end)

function CheckJobs()
    police = 0
    medic = 0
    xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        identifier = GetPlayerIdentifiers(xPlayers[i])
        if xPlayer.job.name == 'police' then
            police = police + 1
        elseif xPlayer.job.name == 'ambulance' and police > 0 then
            medic = medic + 1
        end
    end
    
    -- ส่วนส่งข้อมูลไปให้ Client
    TriggerClientEvent('blugx:updatePolice', -1, police)
    TriggerClientEvent('blugx:numberOfMedic', -1, medic)
end

AddEventHandler('onResourceStart', function(resourceName)
    if (CurrentResourceName ~= resourceName) then
        return
    end
    Citizen.Wait(1000)
    CheckJobs()
    print('The resource ' .. resourceName .. ' has been started.')
    print('Custom script BY BLUGTHEK')
end)

Citizen.CreateThread(function()
    while not isReady do
        Citizen.Wait(5)
    end
    
    while true do
        CheckJobs()
        Citizen.Wait(5000)
    end
end)

-- mark player
RegisterCommand('markPlayer', function(source,args)
    local temp = args[1]
    markList[#markList+1] = temp
    for i=1, #markList do
        print(markList[i])
    end
end, true)

RegisterCommand('clearMark', function(source)
    markList = {}
    TriggerClientEvent(CurrentResourceName..':clearBlip', -1)    
end, true)

Citizen.CreateThread(function()
    local timer_ = 5
    while not isReady do
        Citizen.Wait(5)
    end
    Citizen.Wait(100)
    
    while true do
        if markList ~= nil then
            local data = {}
            for i=1, #xPlayers, 1 do
                if ESX.GetPlayerFromId(xPlayers[i]) ~= nil then
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                    local iDen = xPlayer.getIdentifier()
                    for j=1, #markList do
                        if markList[j] == iDen then
                            data[i] = {
                                playerId = xPlayers[i],
                                name = GetPlayerName(xPlayers[i]),
                                coords = GetEntityCoords(GetPlayerPed(xPlayers[i]))
                            }
                        end
                    end
                end
            end

            if true then
                TriggerClientEvent(CurrentResourceName..':showblip', -1, data)
            end
            timer_ = 15000
        else
            timer_ = 5
        end
        Citizen.Wait(timer_)
    end
end)

