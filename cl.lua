
local mythicnotify = true -- Mikäli haluat mythic notifyn käyttöön
local riisumisaika = 5 -- sekunteina
local itemi = 'bulletproof' -- Itemin nimi jonka pelaaja saa kun on riisunut luotiliivit
local commandi = 'riisuliivit' -- commandi jolla voi riisua luotiliivit
local teksti = 'Riisutaan liivejä...' -- Teksti joka näkyy mythic progbarissa
local errornotify = 'Sinulla ei ole luotiliivejä tai ne ovat vaurioituneet!'
local cancelnotify = 'Keskeytit riisumisen!'

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterCommand(commandi, function()
    local ukko = PlayerPedId()
    local luottarit = GetPedArmour(ukko)
    if luottarit == 100 then
        riisumispalkki()
    else
        if mythicnotify then
            exports['mythic_notify']:DoHudText('error', errornotify)
        else
            ESX.ShowNotification(errornotify)
        end
    end
end)

function riisumispalkki()
    local ukko = PlayerPedId()
	TriggerEvent("mythic_progbar:client:progress", {
        name = "riisuliivit",
        duration = riisumisaika * 1000,
        label = teksti,
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "move_f@hiking",
            anim = "idle_intro",
            flags = 49,
        },
						
    }, function(canceled)
		if not canceled then
			ClearPedTasks(ukko)
            TriggerServerEvent('esx_riisuliivit:annaliivit', itemi)
            SetPedComponentVariation(ukko, 9, 0, 0, 2)
            SetPedArmour(ukko, 0)
		else
            ClearPedTasks(ukko)
            if mythicnotify then
                exports['mythic_notify']:DoHudText('error', cancelnotify)
            else
                ESX.ShowNotification(cancelnotify)
            end
		end
	end)
end