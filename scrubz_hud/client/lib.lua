function toPack(tb)
    local tmpObj = {}
    local tmpMt = getmetatable(tb) or {}

    for k, v in pairs(tb) do
        tmpObj[k] = v
    end

    for k, v in pairs(tmpMt) do
        if k ~= "__index" and k ~= "__call" and k ~= "new" then
            tmpObj[k] = v
        end
    end

    for k, v in pairs(tmpObj) do
        if type(v) == "function" then
            tmpObj[k] = function(...)
                return v(tmpObj, ...)
            end
        end

    end

    return tmpObj
end