RegisterNetEvent("UIMessage", function(action, data)
  UIMessage(action, data)
end)

RegisterNetEvent("ceadmin:cb:updatePermissions", function(perms)
  if not next(perms) then
    return Debug("(Error) [netEvent:ceadmin:cb:updatePermissions] Expected a table at first param, got: ",
      type(perms))
  end

  Permissions = perms
end)

RegisterNetEvent("ceadmin:spectate:start", function(targetServerId, targetCoords)
  if targetServerId == GetPlayerServerId(PlayerId()) then
    return Notify("Du kannst dir nicht selbst zuschauen!")
  end


  storedTargetPed = nil
  storedTargetPlayerId = nil
  storedTargetServerId = nil

  if storedTargetPed == nil then
    local spectatorPed = PlayerPedId()
    spectatorReturnCoords = GetEntityCoords(spectatorPed)
  end

  prepareSpectatorPed(true)



  local coordsUnderTarget = calculateSpectatorCoords(targetCoords)
  collisionTpCoordTransition(coordsUnderTarget)
  local serverId = tonumber(targetServerId)

  local targetResolveAttempts = 0
  local resolvedPlayerId = -1
  local resolvedPed = 0

  while (resolvedPlayerId <= 0 or resolvedPed <= 0) and targetResolveAttempts < 300 do
    targetResolveAttempts = targetResolveAttempts + 1
    resolvedPlayerId = GetPlayerFromServerId(serverId)
    resolvedPed = GetPlayerPed(resolvedPlayerId)
    Debug(("Attempting to resolve ped. %s, %s"):format(resolvedPlayerId, resolvedPed))
    Wait(50)
  end

  if (resolvedPlayerId <= 0 or resolvedPed <= 0) then
    Debug('Failed to resolve target PlayerId or Ped')
    collisionTpCoordTransition(spectatorReturnCoords)
    prepareSpectatorPed(false)
    DoScreenFadeIn(500)
    while IsScreenFadedOut() do Wait(5) end

    spectatorReturnCoords = nil
    return Notify(
      "Zuschauen fehlgeschlagen. Bitte drücke F8 und achte auf Fehlermeldungen.")
  end



  storedTargetPed = resolvedPed
  storedTargetPlayerId = resolvedPlayerId
  storedTargetServerId = targetServerId

  NetworkSetInSpectatorMode(true, resolvedPed)
  SetMinimapInSpectatorMode(true, resolvedPed)

  Debug(('Set spectate to true for resolvedPed (%s)'):format(resolvedPed))
  isSpectateEnabled = true
  -- toggleShowPlayerIDs(true, false)
  createSpectatorThreads()
  createInstitutionalThreads()
  DoScreenFadeIn(500)

  while IsScreenFadingOut() do Wait(5) end
end)
