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
	local ifnovpn_clientname = data.name			        // Same as Player:Nick()
	local ifnovpn_steamid32 = data.networkid	            // Same as Player:SteamID()
	local ifnovpn_clientadressandport = data.address		// Same as Player:IPAddress()
	local ifnovpn_clientid = data.userid			        // Same as Player:UserID()
	local ifnovpn_isbot = data.bot			                // Same as Player:IsBot()
	local ifnovpn_uniqueid = data.index		                // Same as Player:EntIndex()
	local ifnovpn_clientadress = string.Explode(":", ifnovpn_clientadressandport)[1]

	http.Fetch( "https://ifnet.fr/api/ifnovpn2.php?ip=" .. ifnovpn_clientadress .. "&steamid=".. util.SteamIDTo64(ifnovpn_steamid32), function( body, len, headers, code )
			local reponseapi = string.Explode( "^^", body)
			if reponseapi[1] == "YES" then
				print("\n\n\n\n[IFNOVPN]: Adresse IP de " .. ifnovpn_clientname .. " autorisé.\n Pays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. util.SteamIDTo64(ifnovpn_steamid32))
			elseif reponseapi[1] == "NO" then
				print("\n\n\n\n[IFNOVPN]: Adresse IP de " .. ifnovpn_clientname .. " refusé.\n Pays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. util.SteamIDTo64(ifnovpn_steamid32))
				game.KickID( ifnovpn_clientid, "Adresse IP non autorisée.\n\n\nInformation technique:\n\nPays: ".. reponseapi[3] .." \nFAI: ".. reponseapi[5] .. " \nASN: ".. reponseapi[4] .. "\n\n\n[ℹ] Veuillez contacter un administrateur si vous pensez qu'il s'agit d'une erreur\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: IFNET#4955")
			else
				print("\n\n\n\n[IFNOVPN]: ERREUR LORS DE LA VERIFICATION DE L'IP.\n\n\n\n")
			    game.KickID( ifnovpn_clientid, "Erreur lors de la verification de l'ip. (Veuillez contacter l'administrateur > IFNET#4955)" )
	            print("\n")
	            print("URL: https://ifnet.fr/api/ifnovpn.php?ip=" .. ifnovpn_clientadress .. "&steamid=".. util.SteamIDTo64(ifnovpn_steamid32))
			end
		end, function( error )
	print( "\n\n\n\n[IFNOVPN]: ERREUR LORS DE LA REQUETE HTTP\n" )
	print("\n")
	print("Code d'erreur: ".. error)
	print("\n")
	print("URL: https://ifnet.fr/api/ifnovpn.php?ip=" .. ifnovpn_clientadress .. "&steamid=".. util.SteamIDTo64(ifnovpn_steamid32))
	
	game.KickID( ifnovpn_clientid, "Serveur de verification d'IP hors-ligne. (Veuillez contacter l'administrateur > IFNET#4955)" )
	end)
end)
