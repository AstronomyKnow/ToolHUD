local AntiAFK = {}

local VirtualUser = game:GetService("VirtualUser")

local active = false

function AntiAFK.init(btn, indicator, onToggle)
    active = false

    local function updateVisuals()
        if active then
            indicator.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            indicator.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end

    updateVisuals()

    btn.MouseButton1Click:Connect(function()
        active = not active
        updateVisuals()
        if active then
            print("[ToolHUD] AntiAFK ENABLED.")
        else
            print("[ToolHUD] AntiAFK DISABLED.")
        end
        if onToggle then onToggle(active) end
    end)

    task.spawn(function()
        while true do
            task.wait(60)
            if active then
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

return AntiAFK
