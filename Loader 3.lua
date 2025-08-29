
-- Loader.lua - SuttannHub vStable
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
local success, ValidKeyData = pcall(function() return game:HttpGet("https://pastebin.com/raw/c7DnMX7z") end)
if not success then warn("⚠️ Gagal ambil key data dari Pastebin!") ValidKeyData = "" end

-- Sistem HWID tersimpan
local function LoadValidHWIDs()
    local hwids = {}
    if isfile and isfile(keyFile) then
        for _, line in pairs(string.split(readfile(keyFile), "
")) do
            hwids[line] = true
        end
    end
    return hwids
end

local function SaveHWID(hwid)
    local hwids = LoadValidHWIDs()
    if not hwids[hwid] and writefile then
        local data = ""
        for k in pairs(hwids) do data = data .. k .. "
" end
        data = data .. hwid .. "
"
        writefile(keyFile, data)
    end
end

local function HasAccess()
    local hwids = LoadValidHWIDs()
    return hwids[HWID] or false
end

local function CheckKey(inputKey)
    for key in string.gmatch(ValidKeyData, "[^
]+") do
        if inputKey == key then return true end
    end
    return false
end

-- Fungsi jalankan script utama
local function RunMainScript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
end

-- (Seluruh GUI, FPS Boost, Intro, Key GUI disalin sama persis dari loadstring sebelumnya)
-- ...

