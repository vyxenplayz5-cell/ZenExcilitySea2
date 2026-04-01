if not game:IsLoaded() then game.Loaded:Wait() end

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/V5/Source.lua"))()

local TWSpeed = 0

--// SETTINGS
local AutoLevel = false
local BossList = {}
local SelectedBoss = nil

--// AUTO LEVEL FUNCTION
local function autoLevel()
    task.spawn(function()
        while AutoLevel do
            -- put your farming logic here
            print("Auto leveling...")
            task.wait(1)
        end
    end)
end

--// SCAN BOSSES FUNCTION
local function scanBoss()
    BossList = {} -- reset list

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") then
            if string.find(v.Name:lower(), "boss") then
                table.insert(BossList, v.Name)
            end
        end
    end
end

--// AUTO SCAN LOOP
task.spawn(function()
    while true do
        scanBoss()
        task.wait(5)
    end
end)

--// UI
local Window = redzlib:MakeWindow({
    Title = "XZen Hub",
    SubTitle = "by Xenorino",
    SaveFolder = "ZenXyz.orgify/saves"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://101063822545949", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

local Tab1 = Window:MakeTab({"Main", "cherry"})

Tab1:AddDiscordInvite({
    Name = "XZen Community",
    Description = "Join server",
    Logo = "rbxassetid://92312936161600",
    Invite = "https://discord.gg/5rQvKvKxuJ",
})

Window:SelectTab(Tab1)

Tab1:AddSection({"Main Section"})

Window:Dialog({
    Title = "Notice",
    Text = "You're using the beta version of XZen Hub, be careful.",
    Options = {
        {"Ok", function() end},
        {"Cancel", function() end}
    }
})

--// AUTO FARM TOGGLE
local Toggle1 = Tab1:AddToggle({
    Name = "Auto Farm",
    Description = "Automatically levels you up",
    Default = false
})

Toggle1:Callback(function(Value)
    AutoLevel = Value

    if Value then
        autoLevel()
    end
end)

--// AUTO ALL BOSSES
Tab1:AddToggle({
    Name = "Auto Farm All Boss",
    Default = false,
    Callback = function(v)
        if v then
            print("Farming all bosses...")
        end
    end
})

--// SELECTED BOSS FARM
Tab1:AddToggle({
    Name = "Auto Farm Selected Boss",
    Default = false,
    Callback = function(v)
        if v and SelectedBoss then
            print("Farming boss:", SelectedBoss)
        end
    end
})

--// DROPDOWN (UPDATED LIVE)
local Dropdown = Tab1:AddDropdown({
    Name = "Select Boss",
    Options = BossList,
    Default = "",
    Callback = function(Value)
        SelectedBoss = Value
        print("Selected:", Value)
    end
})

--// REFRESH DROPDOWN LOOP
task.spawn(function()
    while true do
        Dropdown:Refresh(BossList, true)
        task.wait(5)
    end
end)


--// SPEED SLIDER
Tab1:AddSlider({
    Name = "Tween Speed",
    Min = 100,
    Max = 400,
    Increase = 1,
    Default = 16,
    Callback = function(Value)
        TWSpeed = Value
    end
})

