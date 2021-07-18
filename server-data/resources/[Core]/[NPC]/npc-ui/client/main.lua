RegisterNetEvent('npc-ui:ShowUI')
AddEventHandler('npc-ui:ShowUI', function(action, text)
	SendNUIMessage({
		action = action,
		text = text,
	})
end)

RegisterNetEvent('npc-ui:HideUI')
AddEventHandler('npc-ui:HideUI', function()
	SendNUIMessage({
		action = 'hide'
	})
end)

