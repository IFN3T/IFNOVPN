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

local ifnovpn_version = "B.1.21"
local ifnovpn_api_url = "https://ifnet.fr/api/ifnovpnpost.php"

CreateConVar( "ifnovpn_enable", 1, {FCVAR_PROTECTED,FCVAR_NEVER_AS_STRING}, "Gère l'état de la protection IFNOVPN.\n0 = Desactivée / 1 = Activée", 0, 1)

gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "IFNOVPN_CHECK", function( data )

	if GetConVar("ifnovpn_enable"):GetInt() == 0 then
		print("\n\n\n\n[IFNOVPN]: ℹ La protection est desactivé ℹ\nvous pouvez la réactivé avec \"ifnovpn_enable 1\" dans la console !\n\n")
		return
	end

	local ifnovpn_clientadress = string.Explode(":", data.address)[1]

	if data.bot == 1 then return end	
			http.Post(ifnovpn_api_url, { ip = ifnovpn_clientadress, steamid = util.SteamIDTo64(data.networkid) }, 
				function(responseText, contentLength, responseHeaders, statusCode)
					local reponseapi = string.Explode( "^^", responseText)
						if statusCode == 200 then
							if reponseapi[1] == "YES" then
								print("\n[IFNOVPN]: ✔️ Adresse IP de " .. data.name .. " autorisé. ✔️\nPays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. util.SteamIDTo64(data.networkid))
							elseif reponseapi[1] == "NO" then
								print("\n[IFNOVPN]: ❌ Adresse IP de " .. data.name .. " refusé. ❌\n Pays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. util.SteamIDTo64(data.networkid))
								game.KickID( data.userid, "\n\n                    ❌ Adresse IP non autorisée. ❌\n\n\nInformations Techniques:\n\nPays: ".. reponseapi[3] .." \nFAI: ".. reponseapi[5] .. " \nASN: ".. reponseapi[4] .. "\n\n\n[ℹ] Veuillez contacter un administrateur si vous pensez qu'il s'agit d'une erreur\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: ifnet\n\n\n\n                                                      -IFNOVPN: " .. ifnovpn_version .. "")
							else
								print("\n[IFNOVPN]: ⚠️ ERREUR LORS DE LA RÉCUPERATION DE LA DEMANDE. ⚠️\n\n\n\n")
                                print("Rapport d'erreur:\n"..util.Base64Encode("HTTPCODE: "..statusCode.."\n BODY:"..reponseapi))
								game.KickID( data.userid, "Erreur lors de récupération de la demande de vérification.\n\n Veuillez me contacter avec le rapport d'erreur afficher dans la console.\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: ifnet" )
							end
							elseif statusCode == 404 then
								print("\n[IFNOVPN] ⚠️ ERREUR API INTROUVABLE ⚠️")
								game.KickID( data.userid, "\n\n  ❌❌❌ Configuration du IFNOVPN Invalide ❌❌❌\n\n\nInformations Techniques:\n\nURL de l'API: \n" .. ifnovpn_api_url .. "\n\nNom du serveur: \n".. GetConVar("hostname"):GetString() .. "\n\nIP serveur: \n" .. game.GetIPAddress() .. "\n\n\n[ℹ] Veuillez contacter le support si vous pensez qu'il s'agit d'une erreur\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: ifnet\n\n\n\n                                                      -IFNOVPN: " .. ifnovpn_version .. "")
							elseif statusCode == 403 then
								print("\n[IFNOVPN] ❌ ACCESS API REFUSÉ ❌")
                                game.KickID( data.userid, "\n\n  ❌❌❌ L'utilisation du IFNOVPN n'est pas autorisé ❌❌❌\n\n\nInformations Techniques:\n\nNom du serveur: \n".. GetConVar("hostname"):GetString() .. "\n\nIP serveur: \n" .. game.GetIPAddress() .. "\n\n\n[ℹ] Veuillez contacter le support si vous pensez qu'il s'agit d'une erreur\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: ifnet\n\n\n\n                                                      -IFNOVPN: " .. ifnovpn_version .. "")
                            				elseif statusCode == 500 then
                                print("\n[IFNOVPN] ⚠️ ERREUR SERVEUR API ⚠️")
                                print("Rapport d'erreur:\n"..util.Base64Encode("HTTPCODE: "..statusCode.."\nBODY:\n"..responseText))
								game.KickID( data.userid, "Erreur du serveur API.\n\n Veuillez me contacter avec le rapport d'erreur afficher dans la console.\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: ifnet" )
                            else
								print("\n[IFNOVPN] ⚠️ ERREUR API INCONNU ⚠️")
								game.KickID( data.userid, "Erreur IFNOVPN Inconnue.\n\n Veuillez me contacter:\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: ifnet" )
						end
				end,
				function(failed)
					print("\n[IFNOVPN] ⚠️ ERREUR LIB HTTP ⚠️")
					print(failed)
				end)
end)
