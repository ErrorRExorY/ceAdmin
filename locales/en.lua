local Translations = {
  ban_info =
  "❌ Du bist gebannt :O.\n\nGebannt von: %{staffMember}\nGrund: %{banReason}\n Bandatum: %{banDate} \n Ablaufdatum: %{expirationDate} (%{expirationTime}) \n Ban ID: %{banId} \n\nWenn du denkst, dass dies ein Fehler war, wende dich an den Support.",
  kick_message =
  "❌ Du wurdest vom Server gekickt. \n \n Gekickt von: %{staff_member_name} (id - %{staff_member_id}) \n Grund: %{kick_reason} \n \n Wenn du denkst, dass dies ein Fehler war, wende dich an den Support.",
  drop_player_ban_message =
  "❌ Was zum geier Bro? \n Du wurdest gerade gebannt. \n \n Gebannt von: %{staff_member_name} (id - %{staff_member_id}) \n Grund: %{ban_reason} \n Ban Length: %{ban_length} \n Ban ID: %{ban_id}\n Joine nochmal für mehr Informationen \n \n Wenn du denkst, dass dies ein Fehler war, wende dich an den Support.",
  cheating_kick_message =
  "Du wurdest fürs Cheating gekickt. \n \n Wenn du denkst, dass dies ein Fehler war, wende dich an den Support."
}


Lang = Lang or Locale:new({
  phrases = Translations,
  warnOnMissing = true
})
