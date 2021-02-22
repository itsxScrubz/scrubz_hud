---------------------------
-- Variables --
---------------------------
Data = {
    PlayerLoaded = false,
    Health = 0,
    Armor = 0
}

---------------------------
-- NUI Stoof --
---------------------------
RegisterCommand('showmenu', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'showMenu'
    })
end)

RegisterNUICallback('exitmenu', function(data, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

---------------------------
-- Threads --
---------------------------
function vitalsTickEvent()
    if Data.PlayerLoaded then
        local plyPed = PlayerPedId()
        local currentHealth = GetEntityHealth(plyPed) - 100
        local currentArmor = GetPedArmour(plyPed)
        if Data.Health ~= currentHealth
            or Data.Armor ~= currentArmor
            then
            Data.Health = currentHealth
            Data.Armor = currentArmor
            SendNUIMessage({
                type = 'update',
                health = Data.Health,
                armor = Data.Armor
            })
        end
    end
    SetTimeout(350, vitalsTickEvent)
end
vitalsTickEvent()

function needsUpdate()
    if Data.PlayerLoaded then
        -- Grab needs values.
        -- Make sure it's on a 0 - 100 scale
        SendNUIMessage({
            type = 'update',
            hunger = hungerValue,
            thirst = thirstValue,
            stress = stressValue
        })
    end
    SetTimeout(1000, needsUpdate)
end
needsUpdate()

---------------------------
-- Event Handlers --
---------------------------
RegisterNetEvent('ScrubzHud:Init')
AddEventHandler('ScrubzHud:Init', function()
    local plyPed = PlayerPedId()
    local currentHealth = GetEntityHealth(plyPed) - 100
    local currentArmor = GetPedArmour(plyPed)
    Data.Health = currentHealth
    Data.Armor = currentArmor
    -- Also grab current needs values (0 - 100 scale)
    SendNUIMessage({
        type = 'init',
        health = currentHealth,
        armor = currentArmor,
        hunger = hungerValue,
        thirst = thirstValue,
        stress = stressValue
    })
    Data.PlayerLoaded = true
end)

---------------------------
-- Exports --
---------------------------
-- exports['scrubz_hud']:setVoiceLevel(int)
exports('setVoiceLevel', function(level)
    -- 1 for whisper (33%), 2 for normal (66%), 3 for shout (100%)
    SendNUIMessage({
        type = 'voiceLevel',
        value = level
    })
end)

-- exports['scrubz_hud']:toggleVoiceActive(bool)
exports('toggleVoiceActive', function(isTalking)
    -- true/false
    SendNUIMessage({
        type = 'toggleVoice',
        value = isTalking
    })
end)
