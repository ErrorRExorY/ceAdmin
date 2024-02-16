RegisterCommand("cenoclip", function()
  if not next(Permissions) then
    TriggerServerEvent("ceadmin:getPermissions")

    Wait(500)

    if not next(Permissions) then
      return Debug("(Error) (command:adminmenu) srcPermissions is null, returning.")
    end

    if not Permissions.NoClip then
      return Notify("Du hast nicht die erforderlichen Berechtigungen!")
    end

    UIMessage("nui:adminperms", Permissions)
  end

  if not Permissions.NoClip then
    return Notify("Du hast nicht die erforderlichen Berechtigungen!")
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
      return Notify("Du hast nicht die erforderlichen Berechtigungen!")
    end

    UIMessage("nui:adminperms", Permissions)
  end

  if not Permissions.Menu then
    return Notify("Du hast nicht die erforderlichen Berechtigungen!")
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
    return Notify("Du hast nicht die erforderlichen Berechtigungen!.")
  end

  if not targetID then return Notify("Target id is null.") end

  if tonumber(targetID) == tonumber(GetPlayerServerId(PlayerId())) then
    return Notify("Du kannst dich nicht selber bannen!")
  end

  if not reason or #reason <= 1 then
    return Notify("Fehler: Grund ist zu kurz!")
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
    return Notify("Du hast nicht die erforderlichen Berechtigungen!.")
  end

  if not targetID then
    return Notify("Player ID wird benötigt.")
  end

  TriggerServerEvent("ceadmin:server:tp", {
    Option = "Goto",
    id = targetID
  })
end)

RegisterCommand("cebring", function(_source, args, rawCommand)
  local targetID = args[1]


  if not Permissions["Teleport"] then
    return Notify("Du hast nicht die erforderlichen Berechtigungen!.")
  end

  if not targetID then
    return Notify("Target ID wird benötigt.")
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
    return Notify("Du hast nicht die erforderlichen Berechtigungen!.")
  end

  if not targetID then
    return Notify("Target ID wird benötigt.")
  end

  if not reason then
    return Notify("Grund für den Kick benötigt.")
  end

  if tonumber(targetID) == tonumber(GetPlayerServerId(PlayerId())) then
    return Notify("Du kannst dich nicht selber kicken!")
  end


  TriggerServerEvent("ceadmin:server:kick", {
    target_id = targetID,
    reason = reason
  })
end)


-- Command Suggestions
TriggerEvent('chat:addSuggestions', {
  {
    name = '/cekick',
    help = '[Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },
      { name = "reason", help = "Grund für den Kick (Benötigt)" }
    }
  },
  {
    name = '/ceban',
    help = 'Dies bannt einen Spieler permanent. [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },
      { name = "reason", help = "Grund für den Ban (Benötigt)" }
    }
  },
  {
    name = '/cegoto',
    help = 'Teleportiere dich zum Spieler [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },
    }
  },
  {
    name = '/cebring',
    help = 'Hole den Spieler zu dir. [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },
    }
  },
  {
    name = '/setpbucket',
    help = 'Teleportiere einen Spieler in einen andere Bucket [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },
      { name = "bucket", help = "Bucket ID (Benötigt)" },
    }
  },
  {
    name = '/setpbucketrad',
    help = 'Teleportiere einen Spieler in einen andere Bucket [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },
      { name = "bucket", help = "Bucket ID (Benötigt)" },
      { name = "radius", help = "Radius Default 0" },
    }
  },
  {
    name = '/getpbucket',
    help = 'Hiermit bekommst du in welchem Bucket sich ein Spieler befindet [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },

    }
  },
  {
    name = '/setbucketpop',
    help = 'Hiermit setzt du die Bevökerung eines Buckets [Admin Only]',
    params = {
      { name = "bucket", help = "Bucket ID (Benötigt)" },
      { name = "mode", help = "true um Bevölkerung zu aktivieren false fürs deaktivieren (Benötigt)" },

    }
  },
  {
    name = '/setbucketlock',
    help = 'Hiermit setzt du einen Bucket in LockDownMode [Admin Only]',
    params = {
      { name = "bucket", help = "Bucket ID (Benötigt)" },
      { name = "mode", help = "strict, relaxed und inactive sind die Modes. Inactive ist normal, strict ist LockdownBucket" },

    }
  },
  {
    name = '/addhacker',
    help = 'Hiermit schiebst du einen Hacker in einen Lockdown-Bucket! [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },

    }
  },
  {
    name = '/removehacker',
    help = 'Hiermit holst du eine User aus dem HackerBucket [Admin Only]',
    params = {
      { name = "player", help = "Spieler ID (Benötigt)" },

    }
  },
})


RegisterCommand("cetestState", function()
  Debug(json.encode(LocalPlayer.state.playerData))
end)
