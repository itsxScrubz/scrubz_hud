---@class StatusGetter
local StatusGetter = {
    ---@param pedId number
    ---@return number
    handler = function(pedId)

    end,
    cachedValue = 0
}

---@class SCRUBZ_HUD
SCRUBZ_HUD = {
    ---@type StatusGetter[]
    StatusGetters = {},
    PlayerLoaded = false
}

function SCRUBZ_HUD:Tick()

    if self.PlayerLoaded then
        local payload = self.GenerateInfo()

        self.EmitNUI("update", payload)
    end

    SetTimeout(1000, function()
        self.Tick()
    end)
end

function SCRUBZ_HUD:GenerateInfo()
    local payload = {}
    local pedId = PlayerPedId()
    for k,v in pairs(self.StatusGetters) do
        local tmpStat = v.handler(pedId)
        if tmpStat == nil then tmpStat = v.cachedValue end
        self.StatusGetters[k].cachedValue = tmpStat
        payload[k] = tmpStat
    end
    return payload
end

---@param eventType string
---@param payload table
function SCRUBZ_HUD:EmitNUI(eventType, payload)
    if type(payload) ~= "table" then
        if type(payload) == "string" then
            local tmpPayload = json.decode(payload)
            if tmpPayload == nil then payload = {} end
        end
    end

    payload.type = eventType


    SendNUIMessage(payload)
end

---@param eventName string
---@param handler fun(data: any, cb: fun(...: any): void)
function SCRUBZ_HUD:OnNUI(eventName, handler)
    RegisterNUICallback(eventName, function(data, cb)
        handler(data, cb)
    end)
end

---@param name string
---@param default number
---@param handler fun(): number
function SCRUBZ_HUD:SetGetter(name, default, handler)
    self.StatusGetters[name] = {
        cachedValue = default,
        handler = handler
    }
end

--- Make the object MessagePack friendly
SCRUBZ_HUD = toPack(SCRUBZ_HUD)

SCRUBZ_HUD.SetGetter("health", 0, function(pedId)
    return GetEntityHealth(pedId) - 100
end)

SCRUBZ_HUD.SetGetter("armor", 0, function(pedId)
    return GetPedArmour(pedId)
end)

---@param level number
exports('setVoiceLevel', function(level)
    SCRUBZ_HUD.EmitNUI("voiceLevel", {value = level})
end)

---@param isTalking boolean
exports('toggleVoiceActive', function(isTalking)
    if type(isTalking) ~= "boolean" then
        tmpTalking = tonumber(isTalking)
        if tmpTalking == nil then tmpTalking = false end
        isTalking = tmpTalking == 1 and true or false
    end
    SCRUBZ_HUD.EmitNUI("toggleVoice", {value = isTalking})
end)

exports('GetApp', function()
    return SCRUBZ_HUD
end)

RegisterCommand('showmenu', function()
    SetNuiFocus(true, true)
    SCRUBZ_HUD.EmitNUI("showMenu", {})
end)

SCRUBZ_HUD.OnNUI("exitmenu", function(_, cb)
    cb('ok')
    SetNuiFocus(false, false)
end)

RegisterNetEvent('ScrubzHud:Init')
AddEventHandler('ScrubzHud:Init', function()
    local payload = SCRUBZ_HUD:GenerateInfo()
    SCRUBZ_HUD.EmitNUI('init', payload)
    SCRUBZ_HUD.PlayerLoaded = true
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

SCRUBZ_HUD.Tick()