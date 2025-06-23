-- =================================================================
-- FICHIER core/ui.lua - VERSION CORRIGÉE - 23/06/2025
-- =================================================================

-- Supprime l'ancienne UI si elle existe pour le rechargement
if game.Players.LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("AriseHubUI") then
    game.Players.LocalPlayer.PlayerGui.AriseHubUI:Destroy()
end

local UI = {}
local UserInputService = game:GetService("UserInputService")

local mainFrame, titleBar, contentFrame, footerLabel
local isDragging = false
local dragStart
local startPos
local isMinimized = false
local originalSize

function UI:Init(config)
    -- Stocker la configuration pour une utilisation ultérieure dans ce module
    UI.Config = config

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AriseHubUI"
    screenGui.Parent = game.Players.LocalPlayer:FindFirstChild("PlayerGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.ResetOnSpawn = false

    screenGui.Enabled = true
    
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = config.Size
    mainFrame.Position = config.Position
    mainFrame.BackgroundColor3 = config.Colors.Background
    mainFrame.BackgroundTransparency = config.Transparency
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true

    originalSize = mainFrame.Size

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://10636353942"
    shadow.ImageColor3 = Color3.new(0,0,0)
    shadow.BackgroundTransparency = 1
    shadow.SliceCenter = Rect.new(49, 49, 50, 50)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame

    titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = config.Colors.TitleBar
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Text = config.Title
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextColor3 = config.Colors.Text
    titleLabel.TextSize = 16
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextColor3 = config.Colors.Text
    closeButton.TextSize = 16
    closeButton.BackgroundTransparency = 1
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.Parent = titleBar
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Text = "—"
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.TextColor3 = config.Colors.Text
    minimizeButton.TextSize = 18
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -65, 0.5, -15)
    minimizeButton.Parent = titleBar
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        contentFrame.Visible = not isMinimized
        footerLabel.Visible = not isMinimized
        if isMinimized then
            mainFrame:TweenSize(UDim2.new(0, mainFrame.AbsoluteSize.X, 0, titleBar.AbsoluteSize.Y), "Out", "Quad", 0.2, true)
        else
            mainFrame:TweenSize(originalSize, "Out", "Quad", 0.2, true)
        end
    end)
    
    contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -20, 1, -65) -- Espace pour header et footer
    contentFrame.Position = UDim2.new(0, 10, 0, 45)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarImageColor3 = config.Colors.Primary
    contentFrame.ScrollBarThickness = 5
    contentFrame.Parent = mainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = contentFrame

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local newPos = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + newPos.X, startPos.Y.Scale, startPos.Y.Offset + newPos.Y)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == config.ToggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    footerLabel = Instance.new("TextLabel")
    footerLabel.Name = "Footer"
    footerLabel.Size = UDim2.new(1, 0, 0, 20)
    footerLabel.Position = UDim2.new(0, 0, 1, -20)
    footerLabel.BackgroundColor3 = config.Colors.TitleBar
    footerLabel.BackgroundTransparency = 0.5
    footerLabel.BorderSizePixel = 0
    footerLabel.Font = Enum.Font.SourceSans
    footerLabel.TextSize = 12
    footerLabel.TextColor3 = config.Colors.Text
    footerLabel.ZIndex = 2
    footerLabel.Parent = mainFrame
end

function UI:SetVisible(visible)
    if mainFrame then
        mainFrame.Visible = visible
    end
end

function UI:AddFooter(text)
    if footerLabel then
        footerLabel.Text = text
    end
end

function UI:CreateSection(title, order)
    -- On utilise la config stockée dans UI.Config au lieu de require()
    local config = UI.Config.UI 
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = title .. "Section"
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.Size = UDim2.new(1, 0, 0, 30)
    sectionFrame.LayoutOrder = order
    sectionFrame.ClipsDescendants = true
    sectionFrame.Parent = contentFrame
    
    local headerButton = Instance.new("TextButton")
    headerButton.Name = "Header"
    headerButton.Text = "  " .. title .. " ▼"
    headerButton.Font = Enum.Font.SourceSansBold
    headerButton.TextSize = 16
    headerButton.TextColor3 = config.Colors.Text
    headerButton.BackgroundColor3 = config.Colors.Background
    headerButton.Size = UDim2.new(1, 0, 0, 30)
    headerButton.TextXAlignment = Enum.TextXAlignment.Left
    headerButton.Parent = sectionFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = headerButton

    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "Items"
    itemFrame.BackgroundTransparency = 1
    itemFrame.Size = UDim2.new(1, 0, 0, 0)
    itemFrame.Position = UDim2.new(0,0,0,30)
    itemFrame.Parent = sectionFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.Parent = itemFrame

    local isExpanded = false
    
    headerButton.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        local contentHeight = listLayout.AbsoluteContentSize.Y
        local itemsTargetSize = UDim2.new(1, 0, 0, contentHeight)
        local frameTargetSize = UDim2.new(1, 0, 0, 30 + contentHeight + 5)

        if isExpanded then
            headerButton.Text = "  " .. title .. " ▲"
            game:GetService("TweenService"):Create(itemFrame, TweenInfo.new(0.2), {Size = itemsTargetSize}):Play()
            game:GetService("TweenService"):Create(sectionFrame, TweenInfo.new(0.2), {Size = frameTargetSize}):Play()
        else
            headerButton.Text = "  " .. title .. " ▼"
            game:GetService("TweenService"):Create(itemFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            game:GetService("TweenService"):Create(sectionFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 30)}):Play()
        end
    end)
    
    return itemFrame
end

function UI:CreateButton(parent, text, callback)
    -- On utilise la config stockée dans UI.Config au lieu de require()
    local config = UI.Config.UI
    
    local button = Instance.new("TextButton")
    button.Name = text
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.TextColor3 = config.Colors.Text
    button.BackgroundColor3 = config.Colors.Primary
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = config.Colors.Hover}):Play()
    end)
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.1), {BackgroundColor3 = config.Colors.Primary}):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

return UI
