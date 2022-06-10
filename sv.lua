ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_riisuliivit:annaliivit', function(itemi)
    ukko = ESX.GetPlayerFromId(source)
    ukko.addInventoryItem(itemi, 1)
end)