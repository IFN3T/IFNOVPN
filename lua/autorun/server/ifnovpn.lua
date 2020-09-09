MsgC(Color(0, 255, 0), [[


			  _____ ______ _   _  ______      _______  _   _ 
			 |_   _|  ____| \ | |/ __ \ \    / /  __ \| \ | |
			   | | | |__  |  \| | |  | \ \  / /| |__) |  \| |
			   | | |  __| | . ` | |  | |\ \/ / |  ___/| . ` |
			  _| |_| |    | |\  | |__| | \  /  | |    | |\  |
			 |_____|_|    |_| \_|\____/   \/   |_|    |_| \_|

				 _                     _          _ 
				| |                   | |        | |
				| |     ___   __ _  __| | ___  __| |
				| |    / _ \ / _` |/ _` |/ _ \/ _` |
				| |___| (_) | (_| | (_| |  __/ (_| |
				|______\___/ \__,_|\__,_|\___|\__,_|


]])

gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "CHECK_ANTI_VPN_IFNET", function( data )
	local ifnovpn_clientname = data.name			        			// Same as Player:Nick()
	local ifnovpn_steamid = util.SteamIDTo64(data.networkid)			// Same as Player:SteamID()
	local ifnovpn_isbot = data.bot										// Same as Player:IsBot()
	local ifnovpn_clientadress = string.Explode(":", data.address)[1]	// Same as Player:IPAddress()
	local ifnovpn_clientid = data.userid								// Same as Player:UserID()

	http.Post("https://ifnet.fr/api/ifnovpnpost.php", { ip = ifnovpn_clientadress, steamid = ifnovpn_steamid }, 
	function(responseText, contentLength, responseHeaders, statusCode)
		local reponseapi = string.Explode( "^^", responseText)
		if statusCode == 200 then
			if reponseapi[1] == "YES" then
				print("\n\n\n\n[IFNOVPN]: Adresse IP de " .. ifnovpn_clientname .. " autorisé. ✔️\n Pays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. ifnovpn_steamid)
			elseif reponseapi[1] == "NO" then
				print("\n\n\n\n[IFNOVPN]: Adresse IP de " .. ifnovpn_clientname .. " refusé. ❌\n Pays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. ifnovpn_steamid)
				game.KickID( ifnovpn_clientid, "Adresse IP non autorisée.\n\n\nInformation technique:\n\nPays: ".. reponseapi[3] .." \nFAI: ".. reponseapi[5] .. " \nASN: ".. reponseapi[4] .. "\n\n\n[ℹ] Veuillez contacter un administrateur si vous pensez qu'il s'agit d'une erreur\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: IFNET#4955")
			else
				print("\n\n\n\n[IFNOVPN]: ⚠️ ERREUR LORS DE LA VERIFICATION DE L'IP. ⚠️\n\n\n\n")
				game.KickID( ifnovpn_clientid, "Erreur lors de la verification de l'ip. \n(Veuillez contacter l'administrateur > IFNET#4955)" )
			end
		elseif statusCode == 404 then
			print("[IFNOVPN] ⚠️ ERREUR API INTROUVABLE ⚠️")
			game.KickID( ifnovpn_clientid, "L'api IFNOVPN n'est pas correctement configuré.\n\n Veuillez contacter > IFNET#4955" )
		elseif statusCode == 403 then
			print("[IFNOVPN] ⚠️ ACCESS API REFUSÉ ⚠️")
			game.KickID( ifnovpn_clientid, "L'utilisation du IFNOVPN n'est pas autorisé.\n\n Veuillez contacter > IFNET#4955" )
		else
			print("[IFNOVPN] ⚠️ ERREUR API INCONNU ⚠️")
			game.KickID( ifnovpn_clientid, "Erreur IFNOVPN Inconnue.\n\n Veuillez contacter > IFNET#4955" )
		end
	end,
	function(failed)
		print(failed)
	end)
end)
