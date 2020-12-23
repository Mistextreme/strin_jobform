ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getInfo(source)

	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local info = result[1]

		return {
			firstname = info['firstname'],
			lastname = info['lastname'],
			dateofbirth = info['dateofbirth'],
			sex = info['sex'],
            phone = info['phone_number']
		}
	else
		return nil
	end
end

ESX.RegisterServerCallback('strin_jobform:getInfo', function(source,cb) 
    info = getInfo(source)
    cb(info)
end)

RegisterServerEvent('strin_jobform:sendWebhook')
AddEventHandler('strin_jobform:sendWebhook', function(source, data)
	local job = data.job
	info = getInfo(source)
	local headers = {
		['Content-Type'] = 'application/json'
	}
	local data = {
		["username"] = 'Job Form',
		["embeds"] = {{
		  	["color"] = 3447003,
		  	['description'] = '📝**Person Information**📝\nFirstname: '..info.firstname..'\nLastname: '..info.lastname..'\nDate of Birth: '..info.dateofbirth..'\nGender: '..info.sex..'\nPhone Number: '..info.phone..'\n \nWhy are you joining our company?\n'..data.wayjoc..'\n \nTell us about yourself\n'..data.tuaby,
		  	["footer"] = {
			  	["text"] = GetPlayerName(source)
		  	}
		}}
	}
	PerformHttpRequest(sConfig.Webhooks[job], function(err, text, headers) end, 'POST', json.encode(data), headers)
end)