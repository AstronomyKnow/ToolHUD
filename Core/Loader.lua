local Loader = {}

local baseUrl = "https://raw.githubusercontent.com/AstronomyKnow/ToolHUD/main/"

function Loader.fetch(path)
    local ok, result = pcall(function()
        return game:HttpGet(baseUrl .. path)
    end)
    if ok and result then
        print("[ToolHUD] Loaded: " .. path)
        return result
    else
        warn("[ToolHUD] Failed to load: " .. path .. " | " .. tostring(result))
        return nil
    end
end

function Loader.run(path)
    local source = Loader.fetch(path)
    if source then
        local ok, err = pcall(loadstring(source))
        if not ok then
            warn("[ToolHUD] Error running: " .. path .. " | " .. tostring(err))
        end
    end
end

function Loader.import(path)
    local source = Loader.fetch(path)
    if source then
        local ok, result = pcall(loadstring(source))
        if ok then
            return result
        else
            warn("[ToolHUD] Error importing: " .. path .. " | " .. tostring(result))
        end
    end
    return nil
end

return Loader
