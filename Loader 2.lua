
--// Loader.lua - SuttannHub vStable
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- File simpan key/HWID
local keyFile = "SuttannHubKey.txt"

-- HWID unik
local HWID = (gethwid and gethwid()) or tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- Ambil daftar key dari Pastebin
local success, ValidKeyData = pcall(function()
    return game:HttpGet("https://pastebin.com/raw/c7DnMX7z")
end)
if not success then
    warn("⚠️ Gagal ambil key data dari Pastebin!")
    ValidKeyData = ""
end

-- Sistem HWID tersimpan
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
    for key in string.gmatch(ValidKeyData, "[^\r\n]+") do
        if inputKey == key then
            return true
        end
    end
    return false
end

-- Fungsi jalankan script utama
local function RunMainScript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
end

-- Intro GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(1,0,1,0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
IntroFrame.BackgroundTransparency = 1

local Glow = Instance.new("ImageLabel", IntroFrame)
Glow.AnchorPoint = Vector2.new(0.5,0.5)
Glow.Position = UDim2.new(0.5,0,0.5,0)
Glow.Size = UDim2.new(0,600,0,600)
Glow.Image = "rbxassetid://5028857472"
Glow.ImageColor3 = Color3.fromRGB(0, 170, 255)
Glow.ImageTransparency = 0.6
Glow.BackgroundTransparency = 1

local IntroText = Instance.new("TextLabel", IntroFrame)
IntroText.AnchorPoint = Vector2.new(0.5,0.5)
IntroText.Position = UDim2.new(0.5,0,0.5,0)
IntroText.Size = UDim2.new(0,500,0,60)
IntroText.Text = "🌌 SuttannHub 🌌"
IntroText.TextColor3 = Color3.fromRGB(255,255,255)
IntroText.TextTransparency = 1
IntroText.TextScaled = true
IntroText.Font = Enum.Font.GothamBold
IntroText.BackgroundTransparency = 1

local Ambient = Instance.new("Sound", IntroFrame)
Ambient.SoundId = "rbxassetid://5410086212"
Ambient.Volume = 0.6
Ambient.Looped = true
Ambient:Play()

local Whoosh = Instance.new("Sound", IntroFrame)
Whoosh.SoundId = "rbxassetid://9127401354"
Whoosh.Volume = 1

TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()

task.spawn(function()
    while Glow.Parent do
        TweenService:Create(Glow, TweenInfo.new(2), {Size=UDim2.new(0,700,0,700), ImageTransparency=0.3}):Play()
        task.wait(2)
        TweenService:Create(Glow, TweenInfo.new(2), {Size=UDim2.new(0,600,0,600), ImageTransparency=0.6}):Play()
        task.wait(2)
    end
end)

wait(4.5)
Ambient:Stop()
Whoosh:Play()
TweenService:Create(IntroFrame, TweenInfo.new(1.5), {BackgroundTransparency=1}):Play()
TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency=1}):Play()
TweenService:Create(Glow, TweenInfo.new(1.5), {ImageTransparency=1}):Play()
wait(1.6)
IntroFrame:Destroy()
