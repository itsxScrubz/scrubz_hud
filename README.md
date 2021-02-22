# scrubz_hud [Scrubz#0001]

Given that you could be using ANY needs system, just insert your code that handles retrieving those values inside cl_hud.lua inside the `needsUpdate` thread.
You MUST also include that same code inside the `ScrubzHud:Init` event. This event is meant to be triggered after the player has chosen a character and their relevant stats/needs have been assigned (if you save these to the database of course).

I have provided exports to use with voice stoof. Use them.

```
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

```

You are free to change things or edit as you see fit. Any release of edits/changes MUST include proper credits and a link back to this repo.
This resource as a whole or parts of it's code IS NOT to be sold or included in any kind of paid resource.
