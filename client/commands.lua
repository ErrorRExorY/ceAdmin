RegisterCommand("cenoclip", function()
  if not next(Permissions) then
    TriggerServerEvent("ceadmin:getPermissions")

    Wait(500)

    if not next(Permissions) then
      return Debug("(Error) (command:adminmenu) srcPermissions is null, returning.")
    end

    if not Permissions.NoClip then
      return Notify("What the fluff dude, you don't have perms :o")
    end

    UIMessage("nui:adminperms", Permissions)
  end

  if not Permissions.NoClip then
    return Notify("What the fluff dude, you don't have perms :o")
  end

  ToggleNoClip()
end)

RegisterCommand('ceadminmenu', function()
  UIMessage("nui:adminperms", Permissions)
  if not next(Permissions) then
    -- Using ox_lib
    -- local srcPermissions = lib.callback.await('ceadmin:getPermissions', false)


    Notify("[First Load] Checking player permissions...")
    TriggerServerEvent("ceadmin:getPermissions")

    Wait(500)

    if not next(Permissions) then
      return Debug("(Error) (command:adminmenu) srcPermissions is null, returning.")
    end

    if not Permissions.Menu then
      return Notify("What the fluff dude, you don't have perms :o")
    end

    UIMessage("nui:adminperms", Permissions)
  end

  if not Permissions.Menu then
    return Notify("What the fluff dude, you don't have perms :o")
  end

  -- ox_lib Soltion
  -- local PlayerList = lib.callback.await('ceadmin:plist', false)
  -- local PlayerCache = lib.callback.await("ceadmin:clist", false)

  -- if #PlayerList then
  --   UIMessage("nui:plist", PlayerList)
  -- end

  -- if #PlayerCache then
  --   UIMessage("nui:clist", PlayerCache)
  -- end

  -- Standalone Solution for updating the player list and cache list.
  TriggerServerEvent("ceadmin:plist")
  TriggerServerEvent("ceadmin:clist")
  TriggerServerEvent("ceadmin:blist")

  if Permissions.Menu then
    toggleNuiFrame(true)
  end
end, false)

RegisterCommand("ceban", function(source, args, rawCommand)
  -- Store the first value from the first index of the args table.
  local targetID = tonumber(args[1])

  -- Since we have already stored the first index (targetID) we can just remove it.
  table.remove(args, 1)

  -- The rest of the arguments are the reason for the ban.
  local reason = table.concat(args, " ")

  if not Permissions.Ban then
    return Notify("Insufficient permissions.")
  end

  if not targetID then return Notify("Target id is null.") end

  if tonumber(targetID) == tonumber(GetPlayerServerId(PlayerId())) then
    return Notify("What the fluff dude, you can't ban yourself!")
  end

  if not reason or #reason <= 1 then
    return Notify("Error: Reason is too short!")
  end

  local data = {
    target_id = targetID,
    reason = reason,
    length = "Permanent"
  }

  TriggerServerEvent("ceadmin:server:ban", data)
end, false)

RegisterCommand("cegoto", function(_source, args, rawCommand)
  local targetID = args[1]


  if not Permissions["Teleport"] then
    return Notify("Insufficient permissions.")
  end

  if not targetID then
    return Notify("Player ID is required.")
  end

  TriggerServerEvent("ceadmin:server:tp", {
    Option = "Goto",
    id = targetID
  })
end)

RegisterCommand("cebring", function(_source, args, rawCommand)
  local targetID = args[1]


  if not Permissions["Teleport"] then
    return Notify("Insufficient permissions.")
  end

  if not targetID then
    return Notify("Target ID is required.")
  end

  TriggerServerEvent("ceadmin:server:tp", {
    Option = "Bring",
    id = targetID
  })
end)

RegisterCommand("cekick", function(source, args, rawCommand)
  local targetID = args[1]

  table.remove(args, 1)

  local reason = table.concat(args, " ")

  if not Permissions["Kick"] then
    return Notify("Insufficient permissions.")
  end

  if not targetID then
    return Notify("Target ID is required.")
  end

  if not reason then
    return Notify("Reason for the kick required.")
  end

  if tonumber(targetID) == tonumber(GetPlayerServerId(PlayerId())) then
    return Notify("What the fluff dude, you can't kick yourself!")
  end


  TriggerServerEvent("ceadmin:server:kick", {
    target_id = targetID,
    reason = reason
  })
end)


-- Command Suggestions
TriggerEvent('chat:addSuggestions', {
  {
    name = '/kick',
    help = '[Admin Only]',
    params = {
      { name = "player", help = "Player ID (Required)" },
      { name = "reason", help = "Input a reason for the kick (Required)" }
    }
  },
  {
    name = '/ban',
    help = 'This will permanently ban the selected player. [Admin Only]',
    params = {
      { name = "player", help = "Player ID (Required)" },
      { name = "reason", help = "Input a reason for the ban (Required)" }
    }
  },
  {
    name = '/goto',
    help = 'Teleport to the selected player. [Admin Only]',
    params = {
      { name = "player", help = "Player ID (Required)" },
    }
  },
  {
    name = '/bring',
    help = 'Bring the selected player to you. [Admin Only]',
    params = {
      { name = "player", help = "Player ID (Required)" },
    }
  }
})


RegisterCommand("cetestState", function()
  Debug(json.encode(LocalPlayer.state.playerData))
end)
