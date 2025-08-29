-- SuttannHub vFinal (FPS Boost + Key System + Intro GUI)

local ToDisable = {
    Textures = true,
    VisualEffects = true,
    Parts = false, -- sudah diubah false
    Particles = true,
    Sky = true
}

local ToEnable = {
    FullBright = false
}

local Stuff = {}

for _, v in next, game:GetDescendants() do
    if ToDisable.Parts then
        if v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            table.insert(Stuff, 1, v)
        end
    end

    if ToDisable.Particles then
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
            v.Enabled = false
            table.insert(Stuff, 1, v)
        end
    end

    if ToDisable.VisualEffects then
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
            table.insert(Stuff, 1, v)
        end
    end

    if ToDisable.Textures then
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Texture = ""
            table.insert(Stuff, 1, v)
        end
    end

    if ToDisable.Sky then
        if v:IsA("Sky") then
            v.Parent = nil
            table.insert(Stuff, 1, v)
        end
    end
end

game:GetService("TestService"):Message("Effects Disabler Script : Successfully disabled "..#Stuff.." assets / effects. Settings :")

for i, v in next, ToDisable do
    print(tostring(i)..": "..tostring(v))
end

if ToEnable.FullBright then
    local Lighting = game:GetService("Lighting")
    Lighting.FogColor = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = math.huge
    Lighting.FogStart = math.huge
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 5
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Outlines = true
end

-- FPS Boost
local FPSBoostEnabled = false
local function ApplyFPSBoost()
    _G.Settings = {
        Players = {["Ignore Me"]=true, ["Ignore Others"]=true},
        Meshes = {Destroy=false, LowDetail=true},
        Images = {Invisible=true, LowDetail=false, Destroy=false},
        ["No Particles"]=true,
        ["No Camera Effects"]=true,
        ["No Explosions"]=true,
        ["No Clothes"]=true,
        ["Low Water Graphics"]=true,
        ["No Shadows"]=true,
        ["Low Rendering"]=true,
        ["Low Quality Parts"]=true
    }
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local FPSButton = Instance.new("TextButton", ScreenGui)
FPSButton.Position = UDim2.new(0.85,0,0.02,0)
FPSButton.Size = UDim2.new(0,90,0,30)
FPSButton.Text = "FPS Boost OFF"
FPSButton.Font = Enum.Font.GothamBold
FPSButton.TextSize = 14
FPSButton.TextColor3 = Color3.fromRGB(255,255,255)
FPSButton.BackgroundColor3 = Color3.fromRGB(255,170,0)
Instance.new("UICorner", FPSButton)

FPSButton.MouseButton1Click:Connect(function()
    FPSBoostEnabled = not FPSBoostEnabled
    if FPSBoostEnabled then
        FPSButton.Text = "FPS Boost ON"
        ApplyFPSBoost()
    else
        FPSButton.Text = "FPS Boost OFF"
    end
end)

-- Key System
local HttpService = game:GetService("HttpService")
local keyFile = "SuttannHubKey.txt"
local HWID = (gethwid and gethwid()) or tostring(game:GetService("RbxAnalyticsService"):GetClientId())

local function LoadValidHWIDs()
    local hwids = {}
    if isfile and isfile(keyFile) then
        for _, line in pairs(string.split(readfile(keyFile), "\n")) do
            hwids[line] = true
        end
    end
    return hwids
end

local function SaveHWID(hwid)
    local hwids = LoadValidHWIDs()
    if not hwids[hwid] and writefile then
        local data = ""
        for k in pairs(hwids) do
            data = data .. k .. "\n"
        end
        data = data .. hwid .. "\n"
        writefile(keyFile, data)
    end
end

local function HasAccess()
    local hwids = LoadValidHWIDs()
    return hwids[HWID] or false
end

local function CheckKey(inputKey)
    local success, ValidKeyData = pcall(function()
        return game:HttpGet("https://pastebin.com/raw/c7DnMX7z")
    end)
    if not success then return false end
    for key in string.gmatch(ValidKeyData, "[^\r\n]+") do
        if inputKey == key then return true end
    end
    return false
end
