--[[
    ARISE CROSSOVER HUB - Loader
    Chargé via : loadstring(game:HttpGet("https://raw.githubusercontent.com/MON_PSEUDO/MON_REPO/main/AriseCrossover.lua"))()
    Rôle : Charger tous les modules nécessaires pour le Hub.
--]]

-- Remplace par tes informations GitHub
local GITHUB_USER = "Ins12663"
local GITHUB_REPO = "MON_REPO"
local BRANCH = "main"

-- URL de base pour un accès plus facile
local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/", GITHUB_USER, GITHUB_REPO, BRANCH)

-- Fonction pour charger un module depuis GitHub
local function loadModule(path)
    local url = BASE_URL .. path
    local success, scriptContent = pcall(function()
        return game:HttpGet(url)
    end)

    if success and scriptContent then
        local func, err = loadstring(scriptContent)
        if func then
            return func()
        else
            warn("Erreur de compilation dans le module " .. path .. ": " .. tostring(err))
        end
    else
        warn("Impossible de charger le module depuis : " .. url)
    end
    return nil
end

-- 1. Charger la configuration
local Config = loadModule("config.lua")
if not Config then return end

-- 2. Charger la bibliothèque UI
local UI = loadModule("core/ui.lua")
if not UI then return end

-- Initialiser l'UI avec la configuration
UI:Init(Config.UI)

-- 3. Charger les fonctionnalités en passant l'UI et la Config
loadModule("features/teleport.lua")(UI, Config)
loadModule("features/autofarm.lua")(UI, Config)

-- Optionnel : ajouter le footer
UI:AddFooter("Made by Ins12663")

-- Rendre l'UI visible au lancement
UI:SetVisible(true)

print("Ins12663 Hub chargé avec succès !")
