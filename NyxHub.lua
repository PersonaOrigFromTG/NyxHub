local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Parent = CoreGui

if gethui then
    local ok, result = pcall(gethui)
    if ok and result then
        Parent = result
    end
end

local old = Parent:FindFirstChild("NyxHubUI")
if old then
    old:Destroy()
end

local BaseUrl = "https://raw.githubusercontent.com/USERNAME/REPOSITORY/main/icons/"

local IconFiles = {
    home = "home.png",
    user = "user.png",
    eye = "eye.png",
    tools = "tools.png",
    settings = "settings.png",
    minus = "minus.png",
    x = "x.png"
}

local IconCache = {}

local function getAsset(path)
    if getcustomasset then
        local ok, result = pcall(getcustomasset, path)

        if ok and result then
            return result
        end
    end

    if getsynasset then
        local ok, result = pcall(getsynasset, path)

        if ok and result then
            return result
        end
    end

    return nil
end

local function loadIcon(name)
    if IconCache[name] ~= nil then
        return IconCache[name] or nil
    end

    local fileName = IconFiles[name]

    if not fileName then
        IconCache[name] = false
        return nil
    end

    if not writefile then
        IconCache[name] = false
        return nil
    end

    local localPath = "nyx_" .. fileName

    if isfile then
        local ok, exists = pcall(isfile, localPath)

        if ok and exists then
            local asset = getAsset(localPath)

            if asset then
                IconCache[name] = asset
                return asset
            end
        end
    end

    local url = BaseUrl .. fileName

    local ok, data = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or not data or #data < 100 then
        IconCache[name] = false
        return nil
    end

    local writeOk = pcall(function()
        writefile(localPath, data)
    end)

    if not writeOk then
        IconCache[name] = false
        return nil
    end

    local asset = getAsset(localPath)

    if asset then
        IconCache[name] = asset
        return asset
    end

    IconCache[name] = false
    return nil
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "NyxHubUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = Parent

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(520, 330)
Main.Position = UDim2.new(0.5, -260, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 13)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(104, 78, 255)
MainStroke.Transparency = 0.55
MainStroke.Thickness = 1
MainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundTransparency = 1
Header.Active = true
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Position = UDim2.fromOffset(18, 0)
Title.Size = UDim2.fromOffset(48, 52)
Title.BackgroundTransparency = 1
Title.Text = "NYX"
Title.TextColor3 = Color3.fromRGB(244, 244, 249)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local HubTag = Instance.new("TextLabel")
HubTag.Position = UDim2.fromOffset(61, 17)
HubTag.Size = UDim2.fromOffset(38, 18)
HubTag.BackgroundColor3 = Color3.fromRGB(105, 75, 255)
HubTag.BorderSizePixel = 0
HubTag.Text = "HUB"
HubTag.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTag.TextSize = 10
HubTag.Font = Enum.Font.GothamBold
HubTag.Parent = Header

local HubCorner = Instance.new("UICorner")
HubCorner.CornerRadius = UDim.new(0, 5)
HubCorner.Parent = HubTag

local function CreateHeaderButton(iconName, fallback, offset)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(32, 32)
    Button.Position = UDim2.new(1, offset, 0, 10)
    Button.BackgroundColor3 = Color3.fromRGB(24, 25, 32)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Header

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local Icon = Instance.new("ImageLabel")
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.Position = UDim2.fromScale(0.5, 0.5)
    Icon.Size = UDim2.fromOffset(17, 17)
    Icon.BackgroundTransparency = 1
    Icon.ImageColor3 = Color3.fromRGB(175, 176, 187)
    Icon.Visible = false
    Icon.Parent = Button

    local Fallback = Instance.new("TextLabel")
    Fallback.Size = UDim2.fromScale(1, 1)
    Fallback.BackgroundTransparency = 1
    Fallback.Text = fallback
    Fallback.TextColor3 = Color3.fromRGB(175, 176, 187)
    Fallback.TextSize = 18
    Fallback.Font = Enum.Font.GothamMedium
    Fallback.Parent = Button

    task.spawn(function()
        local asset = loadIcon(iconName)

        if asset then
            Icon.Image = asset
            Icon.Visible = true
            Fallback.Visible = false
        end
    end)

    Button.MouseEnter:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(32, 33, 42)}
        ):Play()
    end)

    Button.MouseLeave:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(24, 25, 32)}
        ):Play()
    end)

    return Button
end

local Hide = CreateHeaderButton("minus", "−", -78)
local Close = CreateHeaderButton("x", "×", -42)

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(12, 52)
Sidebar.Size = UDim2.fromOffset(145, 266)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 19, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 10)
SidePadding.PaddingLeft = UDim.new(0, 8)
SidePadding.PaddingRight = UDim.new(0, 8)
SidePadding.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(169, 52)
Content.Size = UDim2.fromOffset(339, 266)
Content.BackgroundTransparency = 1
Content.Parent = Main

local PageTitle = Instance.new("TextLabel")
PageTitle.Size = UDim2.new(1, 0, 0, 35)
PageTitle.BackgroundTransparency = 1
PageTitle.Text = "Home"
PageTitle.TextColor3 = Color3.fromRGB(242, 242, 247)
PageTitle.TextSize = 18
PageTitle.Font = Enum.Font.GothamBold
PageTitle.TextXAlignment = Enum.TextXAlignment.Left
PageTitle.Parent = Content

local Description = Instance.new("TextLabel")
Description.Position = UDim2.fromOffset(0, 29)
Description.Size = UDim2.new(1, 0, 0, 25)
Description.BackgroundTransparency = 1
Description.Text = "Welcome to NYX HUB"
Description.TextColor3 = Color3.fromRGB(120, 121, 135)
Description.TextSize = 12
Description.Font = Enum.Font.Gotham
Description.TextXAlignment = Enum.TextXAlignment.Left
Description.Parent = Content

local Card = Instance.new("Frame")
Card.Position = UDim2.fromOffset(0, 62)
Card.Size = UDim2.new(1, 0, 0, 175)
Card.BackgroundColor3 = Color3.fromRGB(19, 20, 27)
Card.BorderSizePixel = 0
Card.Parent = Content

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 10)
CardCorner.Parent = Card

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(53, 54, 65)
CardStroke.Transparency = 0.5
CardStroke.Parent = Card

local CardTitle = Instance.new("TextLabel")
CardTitle.Position = UDim2.fromOffset(14, 10)
CardTitle.Size = UDim2.new(1, -28, 0, 25)
CardTitle.BackgroundTransparency = 1
CardTitle.Text = "Dashboard"
CardTitle.TextColor3 = Color3.fromRGB(166, 142, 255)
CardTitle.Font = Enum.Font.GothamBold
CardTitle.TextSize = 14
CardTitle.TextXAlignment = Enum.TextXAlignment.Left
CardTitle.Parent = Card

local function CreateToggle(name, y, default)
    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.fromOffset(14, y)
    Label.Size = UDim2.fromOffset(220, 32)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(205, 205, 215)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local Button = Instance.new("TextButton")
    Button.Position = UDim2.new(1, -54, 0, y + 6)
    Button.Size = UDim2.fromOffset(40, 20)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Card

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = Button

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.fromOffset(14, 14)
    Dot.BackgroundColor3 = Color3.fromRGB(236, 236, 241)
    Dot.BorderSizePixel = 0
    Dot.Parent = Button

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Enabled = default == true

    local function update(instant)
        if instant then
            Button.BackgroundColor3 =
                Enabled
                and Color3.fromRGB(105, 75, 255)
                or Color3.fromRGB(48, 49, 59)

            Dot.Position =
                Enabled
                and UDim2.fromOffset(23, 3)
                or UDim2.fromOffset(3, 3)
        else
            TweenService:Create(
                Button,
                TweenInfo.new(0.15),
                {
                    BackgroundColor3 =
                        Enabled
                        and Color3.fromRGB(105, 75, 255)
                        or Color3.fromRGB(48, 49, 59)
                }
            ):Play()

            TweenService:Create(
                Dot,
                TweenInfo.new(
                    0.17,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                {
                    Position =
                        Enabled
                        and UDim2.fromOffset(23, 3)
                        or UDim2.fromOffset(3, 3)
                }
            ):Play()
        end
    end

    update(true)

    Button.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        update(false)
    end)
end

CreateToggle("UI animations", 47, true)
CreateToggle("Notifications", 86, false)
CreateToggle("Example option", 125, false)

local Tabs = {}

local TabInfo = {
    Home = {
        icon = "home",
        fallback = "⌂"
    },
    Player = {
        icon = "user",
        fallback = "○"
    },
    Visuals = {
        icon = "eye",
        fallback = "◉"
    },
    Misc = {
        icon = "tools",
        fallback = "+"
    },
    Settings = {
        icon = "settings",
        fallback = "⚙"
    }
}

local function SetTab(name)
    for tabName, data in pairs(Tabs) do
        local active = tabName == name

        TweenService:Create(
            data.Button,
            TweenInfo.new(0.15),
            {
                BackgroundColor3 =
                    active
                    and Color3.fromRGB(48, 38, 84)
                    or Color3.fromRGB(18, 19, 25)
            }
        ):Play()

        TweenService:Create(
            data.Label,
            TweenInfo.new(0.15),
            {
                TextColor3 =
                    active
                    and Color3.fromRGB(224, 215, 255)
                    or Color3.fromRGB(145, 146, 158)
            }
        ):Play()

        data.Icon.ImageColor3 =
            active
            and Color3.fromRGB(173, 148, 255)
            or Color3.fromRGB(135, 136, 150)

        data.Fallback.TextColor3 =
            active
            and Color3.fromRGB(173, 148, 255)
            or Color3.fromRGB(135, 136, 150)
    end

    PageTitle.Text = name

    if name == "Home" then
        Description.Text = "Welcome to NYX HUB"
        CardTitle.Text = "Dashboard"
    else
        Description.Text = name .. " settings"
        CardTitle.Text = name
    end
end

local function CreateTab(name, order)
    local info = TabInfo[name]

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(18, 19, 25)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.LayoutOrder = order
    Button.Parent = Sidebar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local Icon = Instance.new("ImageLabel")
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.Position = UDim2.new(0, 18, 0.5, 0)
    Icon.Size = UDim2.fromOffset(17, 17)
    Icon.BackgroundTransparency = 1
    Icon.ImageColor3 = Color3.fromRGB(135, 136, 150)
    Icon.Visible = false
    Icon.Parent = Button

    local Fallback = Instance.new("TextLabel")
    Fallback.AnchorPoint = Vector2.new(0.5, 0.5)
    Fallback.Position = UDim2.new(0, 18, 0.5, 0)
    Fallback.Size = UDim2.fromOffset(20, 20)
    Fallback.BackgroundTransparency = 1
    Fallback.Text = info.fallback
    Fallback.TextColor3 = Color3.fromRGB(135, 136, 150)
    Fallback.TextSize = 15
    Fallback.Font = Enum.Font.GothamMedium
    Fallback.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Position = UDim2.fromOffset(37, 0)
    Label.Size = UDim2.new(1, -43, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(145, 146, 158)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    Tabs[name] = {
        Button = Button,
        Icon = Icon,
        Fallback = Fallback,
        Label = Label
    }

    task.spawn(function()
        local asset = loadIcon(info.icon)

        if asset then
            Icon.Image = asset
            Icon.Visible = true
            Fallback.Visible = false
        end
    end)

    Button.MouseButton1Click:Connect(function()
        SetTab(name)
    end)
end

CreateTab("Home", 1)
CreateTab("Player", 2)
CreateTab("Visuals", 3)
CreateTab("Misc", 4)
CreateTab("Settings", 5)

SetTab("Home")

local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.fromOffset(58, 58)
MiniButton.Position = UDim2.new(0, 18, 0.5, -29)
MiniButton.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
MiniButton.BorderSizePixel = 0
MiniButton.Text = "NYX"
MiniButton.TextColor3 = Color3.fromRGB(220, 210, 255)
MiniButton.TextSize = 13
MiniButton.Font = Enum.Font.GothamBold
MiniButton.AutoButtonColor = false
MiniButton.Visible = false
MiniButton.Parent = Gui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 16)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(105, 75, 255)
MiniStroke.Transparency = 0.25
MiniStroke.Thickness = 1
MiniStroke.Parent = MiniButton

Close.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

Hide.MouseButton1Click:Connect(function()
    Main.Visible = false
    MiniButton.Visible = true
end)

local miniMoved = false

MiniButton.MouseButton1Click:Connect(function()
    if miniMoved then
        return
    end

    Main.Visible = true
    MiniButton.Visible = false
end)

local dragging = false
local dragInput
local dragStart
local startPosition

local function UpdateDrag(input)
    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        UpdateDrag(input)
    end
end)

local miniDragging = false
local miniDragInput
local miniDragStart
local miniStartPosition

local function UpdateMiniDrag(input)
    local delta = input.Position - miniDragStart

    if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
        miniMoved = true
    end

    MiniButton.Position = UDim2.new(
        miniStartPosition.X.Scale,
        miniStartPosition.X.Offset + delta.X,
        miniStartPosition.Y.Scale,
        miniStartPosition.Y.Offset + delta.Y
    )
end

MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true
        miniMoved = false
        miniDragStart = input.Position
        miniStartPosition = MiniButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                miniDragging = false
            end
        end)
    end
end)

MiniButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        miniDragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if miniDragging and input == miniDragInput then
        UpdateMiniDrag(input)
    end
end)
