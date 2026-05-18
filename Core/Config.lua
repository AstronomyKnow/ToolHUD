local Config = {}

local defaultConfig = {
    gridEnabled = true,
    gridSize = 20,
    modules = {
        AntiAFK = {
            enabled = true,
            position = {x = 172, y = 34},
            useCustomImage = false,
            imageId = ""
        },
        MusicPlayer = {
            enabled = true,
            position = {x = 224, y = 34},
            useCustomImage = false,
            imageId = ""
        }
    }
}

local configPath = "ToolHUD_config.json"

function Config.load()
    local ok, result = pcall(function()
        if isfile(configPath) then
            local data = readfile(configPath)
            return game:GetService("HttpService"):JSONDecode(data)
        end
    end)
    if ok and result then
        print("[ToolHUD] Config loaded successfully.")
        return result
    else
        print("[ToolHUD] No config found, using defaults.")
        return defaultConfig
    end
end

function Config.save(data)
    local ok, err = pcall(function()
        local json = game:GetService("HttpService"):JSONEncode(data)
        writefile(configPath, json)
    end)
    if ok then
        print("[ToolHUD] Config saved successfully.")
    else
        warn("[ToolHUD] Failed to save config: " .. tostring(err))
    end
end

function Config.default()
    return defaultConfig
end

return Config
