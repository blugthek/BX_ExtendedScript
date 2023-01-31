local ESX = nil
local gender = -1

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(0)
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	while tempDataStorage.CurrentJob == nil do
		ESX.PlayerData = ESX.GetPlayerData()
		tempDataStorage.CurrentJob = ESX.PlayerData.job.name
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('blug_ext:CheckJob')
AddEventHandler('blug_ext:CheckJob',function(jobChecker,targetPlayer)
	local playerName = GetPlayerName(PlayerId())
	tempDataStorage.jobChecker = jobChecker
	tempDataStorage.targetPlayer = targetPlayer
	print(playerName)
	print(targetPlayer)
	--[[print('Job Checker '..tempDataStorage.jobChecker)
	print('current Job '..tempDataStorage.CurrentJob)
	print('current Job ESX '..ESX.PlayerData.job.name)]]
end)

AddEventHandler('skinchanger:loadSkin', function(c)	
	gender = (c.sex == 0 and "male" or "female")		
	--[[print(c)
	print(c.sex)
	print(c['sex'])]]
end)

local isPressed = function(input, key)
	return IsControlPressed(input, key) or IsDisabledControlPressed(input, key)
end

local getStreetName = function()
	local pos = GetEntityCoords(PlayerPedId())
	local streetName, _ = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
	streetName = GetStreetNameFromHashKey(streetName)
	return streetName
end

RegisterNetEvent('blug_ext:alertNet')
AddEventHandler('blug_ext:alertNet', function(event_type)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	TriggerServerEvent("blug_ext:defaultAlert", event_type, gender, getStreetName(), pos)
end)

RegisterNetEvent("blug_ext:getalertNet")
AddEventHandler("blug_ext:getalertNet", function(event_type)
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	TriggerServerEvent("blug_ext:defaultAlert", event_type, gender, getStreetName(), pos,ped)
end)

Citizen.CreateThread(function()
	local timer_ = 50
	local playerName = GetPlayerName(PlayerId())

	while tempDataStorage.jobChecker == nil do	
		Wait(0)
	end
	
	while true do
		Citizen.Wait(timer_)

		if tempDataStorage.jobChecker == ESX.PlayerData.job.name then
			local num

			if isPressed(1, 157) then
				num = 1
			elseif isPressed(1, 158) then
				num = 2
			elseif isPressed(1, 160) then
				num = 3
			elseif isPressed(1, 164) then
				num = 4
			elseif isPressed(1, 165) then
				num = 5
			elseif isPressed(1, 159) then
				num = 6
			elseif isPressed(1, 161) then
				num = 7
			elseif isPressed(1, 162) then
				num = 8
			elseif isPressed(1, 163) then
				num = 9
			end

			if isPressed(1, Config["base_key"]) and num and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
				local dataArgs = {
					job = 'police',
					color = Config["Color"].police,
					text = 'แจ้งเตือนจากกรมตำรวจ',
					timeout = Config["duration"]
				}
				TriggerServerEvent("blug_ext:getLocation", num,dataArgs)
				Citizen.Wait(1000)
			end

			if isPressed(1, Config["base_key"]) and num and ESX.PlayerData.job and ESX.PlayerData.job.name == 'army' then
				local dataArgs = {
					job = 'army',
					color = Config["Color"].police,
					text = 'แจ้งเตือนจากกรมทหาร',
					timeout = Config["duration"]
				}
				TriggerServerEvent("blug_ext:getLocation", num,dataArgs)
				Citizen.Wait(1000)
			end

			if isPressed(1, Config["base_key"]) and num and ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
				local dataArgs = {
					job = 'ambulance',
					color = Config["Color"].ambulance,
					text = 'แจ้งเตือนจาก กระทรวงสาธารณสุข',
					timeout = Config["duration"]
				}
				TriggerServerEvent("blug_ext:getLocation", num,dataArgs)
				TriggerServerEvent("blug_ext:SendNotificationTarget",tempDataStorage.targetPlayer,{
					title = 'มีคนรับเคสคุณแล้ว', 
					description = '<btn>' .. playerName .. '</btn> รับเคสของคุณแล้ว' 
				})
				Citizen.Wait(1000)
			end
		end		
	end
end)

RegisterNetEvent("blug_ext:sendLocation")
AddEventHandler("blug_ext:sendLocation", function(pos,dataArgs)
	TriggerEvent("blug_ext:SendNotification",{
		description = 'ตั้ง GPS ไปยังจุดเกิดเหตุแล้ว',
		type = 'success',
		timeout = 2000
	})
	TriggerServerEvent('blug_ext:accept',dataArgs)
	SetNewWaypoint(pos.x, pos.y);
end)

RegisterNetEvent('blug_ext:alertArea')
AddEventHandler('blug_ext:alertArea', function(pos)
	Citizen.CreateThread(function()
	if Config.playsound then
		SendNUIMessage({
			type = 'playsound',
		})
	end
		local v = AddBlipForRadius(pos.x, pos.y, pos.z, Config['red_radius'])

		SetBlipHighDetail(v, true)
		SetBlipColour(v, 1)
		SetBlipAlpha(v, 200)
		SetBlipAsShortRange(v, true)

		local a = 200
		local t = (a / Config["duration"]) * 100
		local r = (a / Config["duration"])
		while a > 0 do
			a = a - r
			if a <= 0 then
				RemoveBlip(v)
			else
				SetBlipAlpha(v, math.floor(a))
			end
			Citizen.Wait(t)
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if Config["alert_section"]["carjacking"] and IsPedJacking(ped) then
			Citizen.Wait(3000)
			local car = GetVehiclePedIsIn(ped)
			local seat = GetPedInVehicleSeat(car,-1)
			if seat == ped then
				local pos = GetEntityCoords(ped)
				TriggerServerEvent("blug_ext:defaultAlert", "carjacking", gender, getStreetName(), pos)
			end
			Citizen.Wait(Config["duration"] * 1000)
		elseif Config["alert_section"]["melee"] and IsPedInMeleeCombat(ped) then
			Citizen.Wait(3000)
			local pos = GetEntityCoords(ped)
			TriggerServerEvent("blug_ext:defaultAlert", "melee", gender, getStreetName(), pos)
			Citizen.Wait(Config["duration"] * 1000)
		elseif Config["alert_section"]["gunshot"] and IsPedShooting(ped) and not IsPedCurrentWeaponSilenced(ped) then
			Citizen.Wait(3000)
			local pos = GetEntityCoords(ped)
			TriggerServerEvent("blug_ext:defaultAlert", "gunshot", gender, getStreetName(), pos)
			Citizen.Wait(Config["duration"] * 1000)
		end
	end
end)