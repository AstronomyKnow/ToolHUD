print("[ToolHUD] starting this amazing script...")

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local baseUrl = "https://raw.githubusercontent.com/AstronomyKnow/ToolHUD/main/"

local function fetch(path)
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

local function import(path)
    local source = fetch(path)
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

local Config = import("Core/Config.lua")
local UI = import("Core/UI.lua")

if not Config or not UI then
    warn("[ToolHUD] EVERYTHING EXPLODED NOOO: failed to load core modules.")
    return
end

local config = Config.load()

UI.init(config, function(updatedConfig)
    Config.save(updatedConfig)
end)

-- Cargar modulos activos
if config.modules.AntiAFK.enabled then
    local bg, btn, indicator = UI.createButton("AntiAFK", config.modules.AntiAFK)

    local antiAFKEnabled = false

    local function updateVisuals()
        if antiAFKEnabled then
            indicator.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            indicator.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end

    updateVisuals()

    btn.MouseButton1Click:Connect(function()
        antiAFKEnabled = not antiAFKEnabled
        updateVisuals()
        if antiAFKEnabled then
            print("[ToolHUD] AntiAFK ENABLED.")
        else
            print("[ToolHUD] AntiAFK DISABLED.")
        end
    end)

    task.spawn(function()
        while true do
            task.wait(60)
            if antiAFKEnabled then
                local ok, err = pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                if ok then
                    print("[ToolHUD] AntiAFK activity simulated, i hope so.")
                else
                    warn("[ToolHUD] AntiAFK error: " .. tostring(err))
                end
            end
        end
    end)
end

if config.modules.MusicPlayer.enabled then
    local bg, btn, indicator = UI.createButton("MusicPlayer", config.modules.MusicPlayer)
    print("[ToolHUD] MusicPlayer loaded, coming soon :)")
end

print("[ToolHUD] Script loaded somehow. Press Ctrl+Shift+H to open the menu.")
