RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  cb({})
end)

RegisterNuiCallback("ceadmin:client:unban", function(banID)
  if not banID then
    return Debug("(Error) [nuiCallback:ceadmin:client:unban] first param is nil/null, returning.")
  end

  TriggerServerEvent("ceadmin:server:unban", banID)
end)

RegisterNUICallback("ceadmin:client:offlineban", function(data, cb)
  if not next(data) then
    return Debug("(Error) [nuiCallback:ceadmin:client:offlineban] first param is nil/null, returning.")
  end

  TriggerServerEvent("ceadmin:server:offlineban", data)
  cb({})
end)

RegisterNuiCallback("ceadmin:client:spectate", function(playerData, cb)
  if not next(playerData) then
    return Debug("(Error)  [nuiCallback:ceadmin:client:spectate] first param is nil/null, returning.")
  end

  local sourceId = GetPlayerServerId(PlayerId())

  if tostring(sourceId) == tostring(playerData.id) then
    return Notify("What the fluff dude, you cannot spectate yourself.")
  end

  TriggerServerEvent("ceadmin:server:spectate", playerData)
  cb({})
end)

RegisterNuiCallback("ceadmin:client:jail", function(playerData, cb)
  if not next(playerData) then
    return Debug("(Error)  [nuiCallback:ceadmin:client:jail] first param is nil/null, returning.")
  end

  local sourceId = GetPlayerServerId(PlayerId())

  if tostring(sourceId) == tostring(playerData.id) then
    return Notify("What the fluff dude, you cannot jail yourself.")
  end

  TriggerServerEvent("ceadmin:server:jail", playerData)
  cb({})
end)

RegisterNuiCallback("ceadmin:client:tp", function(data, cb)
  if not next(data) then
    return Debug("(Error) [ceadmin:client:tp] data param is null.")
  end

  if not Permissions.Teleport then return end

  TriggerServerEvent("ceadmin:server:tp", data)

  cb({})
end)

RegisterNuiCallback("ceadmin:client:options", function(data, cb)
  if not next(data) then
    return Debug("(Error) [ceadmin:client:options] data param is null.")
  end

  local ped = PlayerPedId()

  -- print(json.encode(data))

  if data.health then
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    return
  end

  if data.armor then
    SetPedArmour(ped, 100)
    return
  end

  if data.playerNames then
    State.playerNames = not State.playerNames
    createGamerTagThread()
    return
  end

  if data.noclip then
    if not Permissions.NoClip then
      return Notify("What the fluff dude, you don't have perms :o")
    end

    ToggleNoClip()
    return
  end

  TriggerServerEvent("ceadmin:server:options", data)
  cb({})
end)


RegisterNuiCallback("ceadmin:client:rev", function(data)
  if not next(data) then
    return Debug("(Error) [ceadmin:nui_cb:rev] data param is null.")
  end

  TriggerServerEvent("ceadmin:server:rev", data)
end)

RegisterNuiCallback("ceadmin:client:frz", function(data)
  if not next(data) then
    return Debug("(Error) [ceadmin:nui_cb:frz] data param is null.")
  end
  TriggerServerEvent("ceadmin:server:frz", data)
end)

RegisterNuiCallback("ceadmin:nui_cb:ban", function(data, cb)
  if not next(data) then
    return Debug("(Error) [ceadmin:nui_cb:ban] data param is null.")
  end

  if tonumber(data.target_id) == GetPlayerServerId(PlayerId()) then
    return Notify("What the fluff dude, you can't ban yourself :o")
  end

  TriggerServerEvent("ceadmin:server:ban", data)
  cb({})
end)


RegisterNuiCallback("ceadmin:nui_cb:kick", function(data, cb)
  if not next(data) then
    return Debug("(Error) [ceadmin:nui_cb:kick] data param is null.")
  end

  if tonumber(data.target_id) == GetPlayerServerId(PlayerId()) then
    return Notify("What the fluff dude, you can't kick yourself :o")
  end

  Debug("[ceadmin:nui_cb:kick] Data Param:", json.encode(data))
  TriggerServerEvent("ceadmin:server:kick", data)
  cb({})
end)

RegisterNuiCallback("ceadmin:nui_cb:unban:global", function(data)
  if not next(data) then
    return Debug("(Error) [ceadmin:nui_cb:unbanPage] data param is null.")
  end

  TriggerServerEvent("ceadmin:server:unban", data)
end)

RegisterNuiCallback("ceadmin:nui_cb:jail", function(data, cb)
  if not next(data) then
    return Debug("(Error) [ceadmin:nui_cb:jail] data param is null.")
  end

  if tonumber(data.target_id) == GetPlayerServerId(PlayerId()) then
    return Notify("What the fluff dude, you can't ban yourself :o")
  end

  TriggerServerEvent("ceadmin:server:jail", data)
  cb({})
end)
