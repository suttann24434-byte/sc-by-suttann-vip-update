-- SuttannHub vUltimate (Intro GUI + Key System + FPS Boost + Effects Disabler)

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ===== Key System =====
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

-- ===== Intro GUI + Sound =====
local IntroGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
IntroGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", IntroGui)
Frame.Size = UDim2.new(0,400,0,200)
Frame.Position = UDim2.new(0.5,-200,0.5,-100)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BackgroundTransparency = 0.5
Instance.new("UICorner", Frame)

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1,0,1,0)
Label.Text = "SuttannHub Loading..."
Label.Font = Enum.Font.GothamBold
Label.TextSize = 28
Label.TextColor3 = Color3.fromRGB(255,170,0)
Label.BackgroundTransparency = 1

local IntroSound = Instance.new("Sound", LocalPlayer:WaitForChild("PlayerGui"))
IntroSound.SoundId = "rbxassetid://1837635071" -- Contoh suara
IntroSound.Volume = 0.5
IntroSound:Play()
wait(3)
IntroSound:Stop()
IntroGui:Destroy()

-- ===== Effects Disabler =====
local ToDisable = {
    Textures = true,
    VisualEffects = true,
    Parts = true,
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
            table.insert(Stuff,1,v)
        end
    end

    if ToDisable.Particles then
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
            v.Enabled = false
            table.insert(Stuff,1,v)
        end
    end

    if ToDisable.VisualEffects then
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
            table.insert(Stuff,1,v)
        end
    end

    if ToDisable.Textures then
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Texture = ""
            table.insert(Stuff,1,v)
        end
    end

    if ToDisable.Sky then
        if v:IsA("Sky") then
            v.Parent = nil
            table.insert(Stuff,1,v)
        end
    end
end

game:GetService("TestService"):Message("Effects Disabler Script : Disabled "..#Stuff.." assets / effects.")

if ToEnable.FullBright then
    Lighting.FogColor = Color3.fromRGB(255,255,255)
    Lighting.FogEnd = math.huge
    Lighting.FogStart = math.huge
    Lighting.Ambient = Color3.fromRGB(255,255,255)
    Lighting.Brightness = 5
    Lighting.ColorShift_Bottom = Color3.fromRGB(255,255,255)
    Lighting.ColorShift_Top = Color3.fromRGB(255,255,255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    Lighting.Outlines = true
end

-- ===== FPS Boost Button =====
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local FPSButton = Instance.new("TextButton", ScreenGui)
FPSButton.Position = UDim2.new(0.85,0,0.02,0)
FPSButton.Size = UDim2.new(0,90,0,30)
FPSButton.Text = "FPS Boost ON"
FPSButton.Font = Enum.Font.GothamBold
FPSButton.TextSize = 14
FPSButton.TextColor3 = Color3.fromRGB(255,255,255)
FPSButton.BackgroundColor3 = Color3.fromRGB(255,170,0)
Instance.new("UICorner", FPSButton)

FPSButton.MouseButton1Click:Connect(function()
    -- Tidak bisa dimatikan, otomatis aktif
    game:GetService("TestService"):Message("FPS Boost sudah aktif.")
end)

-- ===== Key Validation Example =====
if not HasAccess() then
    local inputKey = "MasukkanKeyAnda" -- Bisa diganti GUI input
    if CheckKey(inputKey) then
        SaveHWID(HWID)
    else
        error("Key invalid! Hubungi admin.")
    end
end
