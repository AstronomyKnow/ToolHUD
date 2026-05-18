local UI = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function UI.init(config, onSave)

    if playerGui:FindFirstChild("ToolHUDGui") then
        playerGui.ToolHUDGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ToolHUDGui"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 100
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = playerGui

    -- Grid visual (solo visible al arrastrar)
    local gridFrame = Instance.new("Frame")
    gridFrame.Size = UDim2.new(1, 0, 1, 0)
    gridFrame.Position = UDim2.new(0, 0, 0, 0)
    gridFrame.BackgroundTransparency = 1
    gridFrame.ZIndex = 5
    gridFrame.Visible = false
    gridFrame.Parent = screenGui

    local function drawGrid()
        for _, v in ipairs(gridFrame:GetChildren()) do v:Destroy() end
        local gridSize = config.gridSize or 20
        local screenSize = screenGui.AbsoluteSize

        for x = 0, screenSize.X, gridSize do
            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, 1, 1, 0)
            line.Position = UDim2.new(0, x, 0, 0)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 0.85
            line.BorderSizePixel = 0
            line.ZIndex = 5
            line.Parent = gridFrame
        end

        for y = 0, screenSize.Y, gridSize do
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, y)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 0.85
            line.BorderSizePixel = 0
            line.ZIndex = 5
            line.Parent = gridFrame
        end
    end

    -- Menu (Ctrl + Shift + H)
    local menuOpen = false

    local menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 320, 0, 400)
    menuFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    menuFrame.BorderSizePixel = 0
    menuFrame.ZIndex = 50
    menuFrame.Visible = false
    menuFrame.Parent = screenGui

    Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)

    -- Titulo del menu
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Text = "ToolHUD"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 51
    title.Parent = menuFrame

    -- Subtitulo
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -20, 0, 20)
    subtitle.Position = UDim2.new(0, 10, 0, 46)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.Text = "Drag buttons to reposition them"
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 51
    subtitle.Parent = menuFrame

    -- Separador
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, -20, 0, 1)
    separator.Position = UDim2.new(0, 10, 0, 72)
    separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    separator.BorderSizePixel = 0
    separator.ZIndex = 51
    separator.Parent = menuFrame

    -- Grid settings
    local gridLabel = Instance.new("TextLabel")
    gridLabel.Size = UDim2.new(1, -20, 0, 20)
    gridLabel.Position = UDim2.new(0, 10, 0, 84)
    gridLabel.BackgroundTransparency = 1
    gridLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    gridLabel.Font = Enum.Font.Gotham
    gridLabel.TextSize = 13
    gridLabel.Text = "Grid size: " .. (config.gridSize or 20) .. "px"
    gridLabel.TextXAlignment = Enum.TextXAlignment.Left
    gridLabel.ZIndex = 51
    gridLabel.Parent = menuFrame

    local gridSlider = Instance.new("TextBox")
    gridSlider.Size = UDim2.new(0, 60, 0, 24)
    gridSlider.Position = UDim2.new(1, -80, 0, 80)
    gridSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    gridSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    gridSlider.Font = Enum.Font.Gotham
    gridSlider.TextSize = 13
    gridSlider.Text = tostring(config.gridSize or 20)
    gridSlider.BorderSizePixel = 0
    gridSlider.ZIndex = 51
    gridSlider.Parent = menuFrame

    Instance.new("UICorner", gridSlider).CornerRadius = UDim.new(0, 6)

    gridSlider.FocusLost:Connect(function()
        local val = tonumber(gridSlider.Text)
        if val and val >= 5 and val <= 100 then
            config.gridSize = val
            gridLabel.Text = "Grid size: " .. val .. "px"
            onSave(config)
        else
            gridSlider.Text = tostring(config.gridSize or 20)
        end
    end)

    -- Toggle grid
    local gridToggleLabel = Instance.new("TextLabel")
    gridToggleLabel.Size = UDim2.new(1, -20, 0, 20)
    gridToggleLabel.Position = UDim2.new(0, 10, 0, 116)
    gridToggleLabel.BackgroundTransparency = 1
    gridToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    gridToggleLabel.Font = Enum.Font.Gotham
    gridToggleLabel.TextSize = 13
    gridToggleLabel.Text = "Show grid while dragging"
    gridToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    gridToggleLabel.ZIndex = 51
    gridToggleLabel.Parent = menuFrame

    local gridToggle = Instance.new("TextButton")
    gridToggle.Size = UDim2.new(0, 44, 0, 24)
    gridToggle.Position = UDim2.new(1, -64, 0, 112)
    gridToggle.BorderSizePixel = 0
    gridToggle.Font = Enum.Font.Gotham
    gridToggle.TextSize = 11
    gridToggle.ZIndex = 51
    gridToggle.Parent = menuFrame

    Instance.new("UICorner", gridToggle).CornerRadius = UDim.new(1, 0)

    local function updateGridToggle()
        if config.gridEnabled then
            gridToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            gridToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            gridToggle.Text = "ON"
        else
            gridToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            gridToggle.TextColor3 = Color3.fromRGB(150, 150, 150)
            gridToggle.Text = "OFF"
        end
    end

    updateGridToggle()

    gridToggle.MouseButton1Click:Connect(function()
        config.gridEnabled = not config.gridEnabled
        updateGridToggle()
        onSave(config)
    end)

    -- Separador 2
    local separator2 = Instance.new("Frame")
    separator2.Size = UDim2.new(1, -20, 0, 1)
    separator2.Position = UDim2.new(0, 10, 0, 148)
    separator2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    separator2.BorderSizePixel = 0
    separator2.ZIndex = 51
    separator2.Parent = menuFrame

    -- Modules label
    local modulesLabel = Instance.new("TextLabel")
    modulesLabel.Size = UDim2.new(1, -20, 0, 20)
    modulesLabel.Position = UDim2.new(0, 10, 0, 158)
    modulesLabel.BackgroundTransparency = 1
    modulesLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    modulesLabel.Font = Enum.Font.Gotham
    modulesLabel.TextSize = 11
    modulesLabel.Text = "MODULES"
    modulesLabel.TextXAlignment = Enum.TextXAlignment.Left
    modulesLabel.ZIndex = 51
    modulesLabel.Parent = menuFrame

    -- Lista de modulos
    local moduleList = Instance.new("ScrollingFrame")
    moduleList.Size = UDim2.new(1, -20, 0, 180)
    moduleList.Position = UDim2.new(0, 10, 0, 182)
    moduleList.BackgroundTransparency = 1
    moduleList.BorderSizePixel = 0
    moduleList.ScrollBarThickness = 3
    moduleList.ZIndex = 51
    moduleList.Parent = menuFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = moduleList

    local moduleNames = {"AntiAFK", "MusicPlayer"}
    local moduleLabels = {AntiAFK = "AFK", MusicPlayer = "IMP"}

    for _, name in ipairs(moduleNames) do
        local modConfig = config.modules[name]

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 36)
        row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        row.BorderSizePixel = 0
        row.ZIndex = 52
        row.Parent = moduleList

        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -80, 1, 0)
        nameLabel.Position = UDim2.new(0, 12, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextSize = 13
        nameLabel.Text = name .. "  ·  " .. moduleLabels[name]
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 53
        nameLabel.Parent = row

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 44, 0, 22)
        toggle.Position = UDim2.new(1, -54, 0.5, -11)
        toggle.BorderSizePixel = 0
        toggle.Font = Enum.Font.Gotham
        toggle.TextSize = 11
        toggle.ZIndex = 53
        toggle.Parent = row

        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local function updateToggle()
            if modConfig.enabled then
                toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
                toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggle.Text = "ON"
            else
                toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                toggle.TextColor3 = Color3.fromRGB(150, 150, 150)
                toggle.Text = "OFF"
            end
        end

        updateToggle()

        toggle.MouseButton1Click:Connect(function()
            modConfig.enabled = not modConfig.enabled
            updateToggle()
            onSave(config)
        end)
    end

    -- Boton cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -34, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Text = "✕"
    closeBtn.ZIndex = 52
    closeBtn.Parent = menuFrame

    closeBtn.MouseButton1Click:Connect(function()
        menuFrame.Visible = false
        menuOpen = false
        gridFrame.Visible = false
        print("[ToolHUD] Menu closed.")
    end)

    -- Abrir/cerrar con Ctrl + Shift + H
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.H
            and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            menuOpen = not menuOpen
            menuFrame.Visible = menuOpen
            if menuOpen then
                drawGrid()
                print("[ToolHUD] Menu opened.")
            else
                gridFrame.Visible = false
                print("[ToolHUD] Menu closed.")
            end
        end
    end)

    -- Funcion para crear botones arrastrables
    function UI.createButton(name, cfg, screenGuiRef)
        local label = ({AntiAFK = "AFK", MusicPlayer = "IMP"})[name] or name

        local bg = Instance.new("Frame")
        bg.AnchorPoint = Vector2.new(0, 0.5)
        bg.Size = UDim2.new(0, 44, 0, 44)
        bg.Position = UDim2.new(0, cfg.position.x, 0, cfg.position.y)
        bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        bg.BorderSizePixel = 0
        bg.ZIndex = 2
        bg.Parent = screenGuiRef or screenGui

        Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

        local btn = Instance.new("TextButton")
        btn.AnchorPoint = Vector2.new(0.5, 0.5)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(0.5, 0, 0.5, 0)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Text = label
        btn.ZIndex = 3
        btn.Parent = bg

        if cfg.useCustomImage and cfg.imageId ~= "" then
            local img = Instance.new("ImageLabel")
            img.AnchorPoint = Vector2.new(0.5, 0.5)
            img.Size = UDim2.new(0, 26, 0, 26)
            img.Position = UDim2.new(0.5, 0, 0.5, 0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://" .. cfg.imageId
            img.ScaleType = Enum.ScaleType.Fit
            img.ZIndex = 4
            img.Parent = bg
            btn.Text = ""
        end

        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 11, 0, 11)
        indicator.Position = UDim2.new(1, -2, 1, -2)
        indicator.AnchorPoint = Vector2.new(1, 1)
        indicator.BorderSizePixel = 0
        indicator.ZIndex = 100
        indicator.Parent = bg

        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

        -- Drag solo cuando el menu esta abierto
        local dragging = false
        local dragStart, startPos

        btn.InputBegan:Connect(function(input)
            if not menuOpen then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = bg.Position
                if config.gridEnabled then
                    drawGrid()
                    gridFrame.Visible = true
                end
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y

                if config.gridEnabled then
                    local gs = config.gridSize or 20
                    newX = math.round(newX / gs) * gs
                    newY = math.round(newY / gs) * gs
                end

                bg.Position = UDim2.new(0, newX, 0, newY)
                cfg.position.x = newX
                cfg.position.y = newY
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                gridFrame.Visible = false
                onSave(config)
            end
        end)

        return bg, btn, indicator
    end

end

return UI
