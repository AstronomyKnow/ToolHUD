local MusicPlayer = {}

local active = false
local currentSound = nil
local currentId = ""

function MusicPlayer.init(bg, btn, indicator, onToggle)
    active = false

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("ToolHUDGui")

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

    -- Menu del MusicPlayer
    local menuVisible = false

    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 220, 0, 90)
    menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    menu.BorderSizePixel = 0
    menu.ZIndex = 200
    menu.Visible = false
    menu.Parent = screenGui

    Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)

    -- Titulo
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.Text = "Music Player"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 201
    title.Parent = menu

    -- Boton cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    closeBtn.BorderSizePixel = 0
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Text = "X"
    closeBtn.ZIndex = 202
    closeBtn.Parent = menu

    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

    -- Input de ID
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 28)
    input.Position = UDim2.new(0, 10, 0, 36)
    input.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    input.BorderSizePixel = 0
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "Enter music ID..."
    input.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    input.Font = Enum.Font.Gotham
    input.TextSize = 12
    input.Text = currentId
    input.ZIndex = 201
    input.Parent = menu

    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

    -- Status label
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 68)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(150, 150, 150)
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.Text = "Enter an ID and press Enter"
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.ZIndex = 201
    status.Parent = menu

    -- Funcion para abrir menu al lado del boton
    local function openMenu()
        local bgPos = bg.AbsolutePosition
        local bgSize = bg.AbsoluteSize
        menu.Position = UDim2.new(0, bgPos.X + bgSize.X + 8, 0, bgPos.Y - bgSize.Y / 2)
        menu.Visible = true
        menuVisible = true
    end

    local function closeMenu()
        menu.Visible = false
        menuVisible = false
    end

    closeBtn.MouseButton1Click:Connect(closeMenu)

    -- Validar ID al presionar Enter
    input.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end
        local id = input.Text:match("%d+")
        if not id then
            status.TextColor3 = Color3.fromRGB(220, 50, 50)
            status.Text = "Invalid ID, numbers only"
            return
        end

        status.TextColor3 = Color3.fromRGB(150, 150, 150)
        status.Text = "Checking..."

        local ok, sound = pcall(function()
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. id
            s.Parent = game:GetService("SoundService")
            s:GetPropertyChangedSignal("IsLoaded"):Wait()
            return s
        end)

        if ok and sound and sound.IsLoaded and sound.TimeLength > 0 then
            if currentSound then
                currentSound:Destroy()
            end
            currentSound = sound
            currentId = id
            status.TextColor3 = Color3.fromRGB(0, 220, 80)
            status.Text = "Found! Press button to play"
            active = false
            updateVisuals()
            print("[ToolHUD] MusicPlayer ID set: " .. id)
        else
            if ok and sound then sound:Destroy() end
            status.TextColor3 = Color3.fromRGB(220, 50, 50)
            status.Text = "ID not found or invalid"
            print("[ToolHUD] MusicPlayer invalid ID: " .. id)
        end
    end)

    -- Doble click para abrir menu
    local lastClick = 0
    btn.MouseButton1Click:Connect(function()
        local now = tick()
        if now - lastClick < 0.3 then
            if menuVisible then
                closeMenu()
            else
                openMenu()
            end
        else
            -- Click simple: toggle musica
            if currentSound then
                active = not active
                updateVisuals()
                if active then
                    currentSound:Play()
                    print("[ToolHUD] MusicPlayer PLAYING: " .. currentId)
                else
                    currentSound:Pause()
                    print("[ToolHUD] MusicPlayer PAUSED.")
                end
                if onToggle then onToggle(active) end
            else
                status.Text = "Set an ID first!"
                openMenu()
            end
        end
        lastClick = now
    end)

end

return MusicPlayer
