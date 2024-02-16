RegisterCommand("ceunban", function(source, args, _rawCommand)
  -- Only the console can execute this command for now, admins use the unban logic in the NUI.
  if tonumber(source) ~= 0 then
    return print("This command can only be executed by the console!")
  end

  local banID = args[1]

  if not banID then
    return print("Ban ID cannot be null!")
  end

  local banList = LoadBanList()
  local found = false
  -- local targetName
  -- local targetHwids
  -- local targetIdentifiers

  for k, banData in pairs(banList) do
    if tostring(banData.uuid) == tostring(banID) then
      found = true
      -- targetName = banData.playerName
      -- targetHwids = banData.tokens
      -- targetIdentifiers = banData.identifiers
      table.remove(banList, k)
    end
  end

  SaveBanList(banList)

  if found then
    print("Player was found and unbanned!")
  else
    print("(Error) Player with that Ban ID not found!")
  end
end)

-- sc_routing.lua
ESX = exports['es_extended']:getSharedObject()

function havePermission(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	local playerGroup = xPlayer.getGroup()
	local isAdmin = false
	for k,v in pairs(Config.AuthorizedRanks) do
		if v == playerGroup then
			isAdmin = true
			break
		end
	end
	
	if IsPlayerAceAllowed(src, "giveownedcar.command") then isAdmin = true end
	
	return isAdmin
end

RegisterCommand('addhacker', function(source, args)
    if havePermission(source) then
        local targetId = tonumber(args[1])
        if targetId then
            local routingBucket = 9999 -- Ein spezieller Routing-Bucket für Hacker
            SetPlayerRoutingBucket(targetId, routingBucket)
            SetRoutingBucketEntityLockdownMode(routingBucket, 'strict') -- Setzen Sie den Lockdown-Modus auf streng
            ESX.ShowNotification('Spieler: ' .. GetPlayerName(targetId) .. ' wurde in den Lockdown-Routing-Bucket verschoben.')
        else
            ESX.ShowNotification('Bitte geben Sie eine gültige Spieler-ID ein!')
        end
    else
        ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('removehacker', function(source, args)
    if havePermission(source) then
        local targetId = args[1]
        if targetId then
            local routingBucket = 0 -- Der Standard-Routing-Bucket
            SetPlayerRoutingBucket(targetId, routingBucket)
            SetRoutingBucketEntityLockdownMode(9999, 'inactive') -- Setzen Sie den Lockdown-Modus auf inaktiv
            ESX.ShowNotification('Spieler: ' .. GetPlayerName(targetId) .. ' wurde in den Standard-Routing-Bucket zurückversetzt.')
        else
            ESX.ShowNotification('Bitte geben Sie eine gültige Spieler-ID ein!')
        end
    else
        ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('gpbucket', function(source, args)
    if havePermission(source) then
        local targetId = args[1] or source
        local playerName = GetPlayerName(targetId)
        local routingBucket = GetPlayerRoutingBucket(targetId)
        ESX.ShowNotification('Spieler: ' .. GetPlayerName(targetId) .. ' ist in Routing Bucket ' .. routingBucket .. '.')
    else
        ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('spbucket', function(source, args)
    if havePermission(source) then
        local targetId = args[1] or source
        local playerName = GetPlayerName(targetId)
        local routingBucket = tonumber(args[2])
        SetPlayerRoutingBucket(targetId, routingBucket)
        
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(targetId), false)
        if vehicle ~= 0 then
            SetEntityRoutingBucket(vehicle, routingBucket)
        end

        ESX.ShowNotification('Spieler: ' .. GetPlayerName(targetId) .. ' wurde in Routing Bucket ' .. routingBucket .. ' verschoben.')
    else
        ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('spbucketrad', function(source, args)
    if havePermission(source) then
        local targetId = args[1] or source
        local playerName = GetPlayerName(targetId)
        local routingBucket = tonumber(args[2])
        local radius = tonumber(args[3]) -- Der Radius, in dem andere Spieler mitgenommen werden sollen

        -- Verschieben Sie den Ziel-Spieler in den neuen Routing-Bucket
        SetPlayerRoutingBucket(targetId, routingBucket)

        -- Holen Sie sich die Position des Ziel-Spielers
        local targetPos = GetEntityCoords(GetPlayerPed(targetId))

        -- Durchlaufen Sie alle Spieler auf dem Server
        for _, playerId in ipairs(GetActivePlayers()) do
            -- Überspringen Sie den Ziel-Spieler
            if playerId ~= targetId then
                local playerPos = GetEntityCoords(GetPlayerPed(playerId))
                -- Wenn der Spieler innerhalb des Radius ist, verschieben Sie ihn in den neuen Routing-Bucket
                if GetDistanceBetweenCoords(targetPos, playerPos, true) <= radius then
                    SetPlayerRoutingBucket(playerId, routingBucket)
                end
            end
        end

        ESX.ShowNotification('Spieler: ' .. GetPlayerName(targetId) .. ' und alle Spieler im Radius von ' .. radius .. ' Einheiten wurden in Routing Bucket ' .. routingBucket .. ' verschoben.')
    else
        ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('gebucket', function(source, args)
    if havePermission(source) then
        local entity = tonumber(args[1])
        local routingBucket = GetEntityRoutingBucket(entity)
        ESX.ShowNotification('Die Routing-Bucket-ID der Entity beträgt ' .. routingBucket .. '.')
    else
      ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('sebucket', function(source, args)
    if havePermission(source) then
        local routingBucket = tonumber(args[1])
        local enabled = (args[2] == 'true')
        setRoutingBucketPopulationEnabled(routingBucket, enabled)
        
        ESX.ShowNotification('Bevölkerung ' .. (enabled and 'Aktiviert' or 'Deaktiviert') .. ' für Routing Bucket ' .. routingBucket .. '.')
    else
      ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('bucketpop', function(source, args)
    if havePermission(source) then
        local routingBucket = tonumber(args[1])
        local population = tonumber(args[2])
        setRoutingBucketPopulation(routingBucket, population)
        ESX.ShowNotification('Bevölkerung für Routing Bucket ' .. routingBucket .. ' auf ' .. population .. ' gesetzt.')
    else
        ESX.ShowNotification('Keine Berechtigungen!')
    end
end)

RegisterCommand('bucketlock', function(source, args, rawCommand)
    if havePermission(source) then
        local routingBucket = tonumber(args[1])
        local mode = args[2]
        setRoutingBucketLockdownMode(routingBucket, mode)
        ESX.ShowNotification('Lockdown-Modus für Routing Bucket ' .. routingBucket .. ' ist jetzt ' .. mode .. '.')
    else
        ESX.ShowNotification('Keine Berechtigungen!')
    end

end)

