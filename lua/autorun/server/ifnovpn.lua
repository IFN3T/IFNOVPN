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

local ifnovpn_version = "B.1.19"
local ifnovpn_api_url = "https://ifnet.fr/api/ifnovpnpost.php"

local hostip = GetConVar("hostip")
local hostport = GetConVar("hostport")
local hostname = GetConVar("hostname")
local sv_allowcslua = GetConVar("sv_allowcslua")

function ifnovpn_getip()
    local ip = hostip:GetInt()
    local a = bit.band(bit.rshift (ip, 24), 0xFF)
    local b = bit.band(bit.rshift (ip, 16), 0xFF)
    local c = bit.band(bit.rshift (ip,  8), 0xFF)
    local d = bit.band(bit.rshift (ip,  0), 0xFF)
    return string.format ("%d.%d.%d.%d", a, b, c, d)
end

gameevent.Listen( "player_connect" )
hook.Add( "player_connect", "CHECK_ANTI_VPN_IFNET", function( data )
	local ifnovpn_clientname = data.name			        			// Same as Player:Nick()
	local ifnovpn_steamid = util.SteamIDTo64(data.networkid)			// Same as Player:SteamID()
	local ifnovpn_isbot = data.bot										// Same as Player:IsBot()
	local ifnovpn_clientadress = string.Explode(":", data.address)[1]	// Same as Player:IPAddress()
	local ifnovpn_clientid = data.userid								// Same as Player:UserID()

	http.Post(ifnovpn_api_url, { ip = ifnovpn_clientadress, steamid = ifnovpn_steamid }, 
	function(responseText, contentLength, responseHeaders, statusCode)
		local reponseapi = string.Explode( "^^", responseText)
		if statusCode == 200 then
			if reponseapi[1] == "YES" then
				print("\n\n\n\n[IFNOVPN]: ✔️ Adresse IP de " .. ifnovpn_clientname .. " autorisé. ✔️\n Pays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. ifnovpn_steamid)
			elseif reponseapi[1] == "NO" then
				print("\n\n\n\n[IFNOVPN]: ❌ Adresse IP de " .. ifnovpn_clientname .. " refusé. ❌\n Pays: " .. reponseapi[3] .. "\nFAI: " .. reponseapi[5] .. "\nASN: " .. reponseapi[4] .. "\nIP: " .. ifnovpn_clientadress .. "\nSteamID: " .. ifnovpn_steamid)
				game.KickID( ifnovpn_clientid, "\n\n                    ❌ Adresse IP non autorisée. ❌\n\n\nInformations Techniques:\n\nPays: ".. reponseapi[3] .." \nFAI: ".. reponseapi[5] .. " \nASN: ".. reponseapi[4] .. "\n\n\n[ℹ] Veuillez contacter un administrateur si vous pensez qu'il s'agit d'une erreur\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: IFNET#4955\n\n\n\n                                                      -IFNOVPN: " .. ifnovpn_version .. "")
			else
				print("\n\n\n\n[IFNOVPN]: ⚠️ ERREUR LORS DE LA VERIFICATION DE L'IP. ⚠️\n\n\n\n")
				game.KickID( ifnovpn_clientid, "Erreur lors de la verification de l'ip. \n(Veuillez contacter l'administrateur > IFNET#4955)" )
			end
		elseif statusCode == 404 then
			print("[IFNOVPN] ⚠️ ERREUR API INTROUVABLE ⚠️")
			game.KickID( ifnovpn_clientid, "\n\n  ❌❌❌ Configuration du IFNOVPN Invalide ❌❌❌\n\n\nInformations Techniques:\n\nURL de l'API: \n" .. ifnovpn_api_url .. "\n\nNom du serveur: \n".. GetConVar("hostname"):GetString() .. "\n\nIP serveur: \n" .. game.GetIPAddress() .. "\n\n\n[ℹ] Veuillez contacter le support si vous pensez qu'il s'agit d'une erreur\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: IFNET#4955\n\n\n\n                                                      -IFNOVPN: " .. ifnovpn_version .. "")
		elseif statusCode == 403 then
			print("[IFNOVPN] ⚠️ ACCESS API REFUSÉ ⚠️")
			game.KickID( ifnovpn_clientid, "\n\n  ❌❌❌ L'utilisation du IFNOVPN n'est pas autorisé ❌❌❌\n\n\nInformations Techniques:\n\nNom du serveur: \n".. GetConVar("hostname"):GetString() .. "\n\nIP serveur: \n" .. game.GetIPAddress() .. "\n\n\n[ℹ] Veuillez contacter le support si vous pensez qu'il s'agit d'une erreur\n\n\nSteam: https://steamcommunity.com/id/IFNET\nDiscord: IFNET#4955\n\n\n\n                                                      -IFNOVPN: " .. ifnovpn_version .. "")
		else
			print("[IFNOVPN] ⚠️ ERREUR API INCONNU ⚠️")
			game.KickID( ifnovpn_clientid, "Erreur IFNOVPN Inconnue.\n\n Veuillez contacter > IFNET#4955" )
		end
	end,
	function(failed)
        print("[IFNOVPN] ⚠️ ERREUR LIB HTTP ⚠️"
		print(failed)
	end)
end)
