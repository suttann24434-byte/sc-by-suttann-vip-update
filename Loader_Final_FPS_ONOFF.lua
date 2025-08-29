
--// Loader.lua - SuttannHub vStable (Final with persistent FPS Boost)
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

-- FPS Boost
_G.FPSBoostEnabled = false
local function ApplyFPSBoost()
    local ToDisable = {Textures=true, VisualEffects=true, Parts=true, Particles=true, Sky=true}
    local Stuff = {}
    for _, v in next, game:GetDescendants() do
        if ToDisable.Parts and (v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart")) then
            v.Material = Enum.Material.SmoothPlastic
            table.insert(Stuff, 1, v)
        end
        if ToDisable.Particles and (v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire")) then
            v.Enabled = false
            table.insert(Stuff, 1, v)
        end
        if ToDisable.VisualEffects and (v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect")) then
            v.Enabled = false
            table.insert(Stuff, 1, v)
        end
        if ToDisable.Textures and (v:IsA("Decal") or v:IsA("Texture")) then
            v.Texture = ""
            table.insert(Stuff, 1, v)
        end
        if ToDisable.Sky and v:IsA("Sky") then
            v.Parent = nil
            table.insert(Stuff, 1, v)
        end
    end
    game:GetService("TestService"):Message("Effects Disabler Script : Successfully disabled "..#Stuff.." assets / effects.")
end

-- GUI Helper
local function CreateFPSButton()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("FPSButton") then PlayerGui.FPSButton:Destroy() end

    local FPSButton = Instance.new("TextButton")
    FPSButton.Name = "FPSButton"
    FPSButton.Size = UDim2.new(0,90,0,30)
    FPSButton.Position = UDim2.new(0.85,0,0.02,0)
    FPSButton.Font = Enum.Font.GothamBold
    FPSButton.TextSize = 14
    FPSButton.TextColor3 = Color3.fromRGB(255,255,255)
    FPSButton.BackgroundColor3 = Color3.fromRGB(255,170,0)
    FPSButton.Text = _G.FPSBoostEnabled and "FPS Boost ON" or "FPS Boost OFF"
    Instance.new("UICorner", FPSButton)
    FPSButton.Parent = PlayerGui

    FPSButton.MouseButton1Click:Connect(function()
        _G.FPSBoostEnabled = not _G.FPSBoostEnabled
        FPSButton.Text = _G.FPSBoostEnabled and "FPS Boost ON" or "FPS Boost OFF"
        if _G.FPSBoostEnabled then ApplyFPSBoost() end
    end)
end

-- Buat button pertama kali & reconnect saat respawn
CreateFPSButton()
LocalPlayer.CharacterAdded:Connect(function()
    CreateFPSButton()
    if _G.FPSBoostEnabled then ApplyFPSBoost() end
end)

-- Jika HWID sudah tersimpan, langsung jalankan script utama
if HasAccess() then
    RunMainScript()
    return
end

-- Key GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.IgnoreGuiInset = true
local Frame = Instance.new("Frame", ScreenGui)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.Position = UDim2.new(0.5,0,0.5,0)
Frame.Size = UDim2.new(0,340,0,250)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", Frame)
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🔑 Enter your Key"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
local KeyBox = Instance.new("TextBox", Frame)
KeyBox.Position = UDim2.new(0.1,0,0.35,0)
KeyBox.Size = UDim2.new(0.8,0,0.15,0)
KeyBox.PlaceholderText = "Masukkan Key..."
KeyBox.TextColor3 = Color3.fromRGB(0,0,0)
KeyBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
local SubmitButton = Instance.new("TextButton", Frame)
SubmitButton.Position = UDim2.new(0.3,0,0.65,0)
SubmitButton.Size = UDim2.new(0.4,0,0.15,0)
SubmitButton.Text = "Submit"
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 18
SubmitButton.TextColor3 = Color3.fromRGB(255,255,255)
SubmitButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", SubmitButton)
local Notif = Instance.new("TextLabel", Frame)
Notif.Size = UDim2.new(1,0,0,30)
Notif.Position = UDim2.new(0,0,0.85,0)
Notif.TextColor3 = Color3.fromRGB(255,80,80)
Notif.BackgroundTransparency = 1
Notif.Font = Enum.Font.Gotham
Notif.TextSize = 16

SubmitButton.MouseButton1Click:Connect(function()
    Notif.Text = "⏳ Checking Key..."
    Notif.TextColor3 = Color3.fromRGB(255,255,0)
    task.wait(1.5)
    local InputKey = KeyBox.Text
    if (function() for key in string.gmatch(ValidKeyData,"[^\r\n]+") do if InputKey==key then return true end end end)() then
        SaveHWID(HWID)
        Notif.Text = "✅ Key benar & tersimpan!"
        Notif.TextColor3 = Color3.fromRGB(80,255,80)
        task.wait(1)
        Frame:Destroy()
        RunMainScript()
    else
        Notif.Text = "❌ Key salah!"
        Notif.TextColor3 = Color3.fromRGB(255,80,80)
        task.wait(1.5)
        LocalPlayer:Kick("Key salah!")
    end
end)
