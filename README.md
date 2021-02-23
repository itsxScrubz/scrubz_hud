# scrubz_hud [Scrubz#0001]

Given that you could be using ANY needs system, just insert your code that handles retrieving those values inside cl_hud.lua inside the `needsUpdate` thread.
You MUST also include that same code inside the `ScrubzHud:Init` event. This event is meant to be triggered after the player has chosen a character and their relevant stats/needs have been assigned (if you save these to the database of course).

I have provided exports to use with voice stoof. Use them.

```lua
--- returns the instance of the SCRUBZ_HUD app
exports.scrubz_hud:GetApp()

--- voice level can be 1 (33%), 2 (66%) or 3 (100%)
exports.scrubz_hud:setVoiceLevel(voiceLevel)

--- active can be either true or false
exports.scrubz_hud:toggleVoiceActive(active)
```

### Functions

---

#### SCRUBZ_HUD.SetGetter(name: string, defaultValue: number, handler: function(playerId))

Sets the default value and function to get value for the desired stat name.

Available Stat names:
    - hunger
    - thirst
    - armor
    - health
    - stress

Health and armor are pre-set, but can be overwritten

Example:

```lua
SCRUBZ_HUD = exports.scrubz_hud:GetApp()

SCRUBZ_HUD.SetGetter("thirst", 0, function(playerId)
    local thirst = SomeMethodToGetThirst()
    return thirst
end)
```


### Events

---

#### ScrubzHud:Init

Tells the HUD to start. This should be performed only **AFTER** all setup is complete (i.e. all stat getters set).


Example:

```lua
--- Client
TriggerEvent('ScrubzHud:Init')
```

```lua
--- Server
TriggerClientEvent('ScrubzHud:Init', source)
```


### Commands

---

#### showmenu

Will display the menu for configuring interface colors

You are free to change things or edit as you see fit. Any release of edits/changes MUST include proper credits and a link back to this repo.
This resource as a whole or parts of it's code IS NOT to be sold or included in any kind of paid resource.
