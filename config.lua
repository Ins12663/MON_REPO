--[[
    Fichier de configuration pour Arise Crossover Hub
    Centralise toutes les valeurs modifiables.
--]]

local Config = {}

-- Paramètres de l'Interface Utilisateur (UI)
Config.UI = {
    Title = "⚙️ ARISE TP HUB",
    ToggleKey = Enum.KeyCode.K, -- Touche pour montrer/cacher l'UI
    Position = UDim2.new(0.5, -200, 0.5, -200), -- Position de départ
    Size = UDim2.new(0, 350, 0, 400), -- Taille de la fenêtre principale
    Colors = {
        Background = Color3.fromRGB(25, 25, 30),
        TitleBar = Color3.fromRGB(40, 40, 45),
        Text = Color3.fromRGB(220, 220, 225),
        Primary = Color3.fromRGB(60, 120, 255), -- Couleur des boutons, etc.
        Hover = Color3.fromRGB(80, 140, 255)
    },
    Transparency = 0.15 -- Semi-transparence du fond (0 = opaque, 1 = invisible)
}

-- Coordonnées de Téléportation
-- Extraites de ton image. J'ai pris les 3 premières valeurs (X, Y, Z).
Config.TeleportLocations = {
    ["Hurricane Town"] = Vector3.new(-1289.81, 24.91, -4613.44),
    ["Nen City"] = Vector3.new(-4779.98, 34.65, -2668.45),
    ["Summer Island"] = Vector3.new(-352.71, 47.03, -2580.31),
    ["Hunters City"] = Vector3.new(1482.90, 24.10, -2628.19),
    ["Winter Raid"] = Vector3.new(4930.82, 29.72, -2153.01),
    ["Kindama City"] = Vector3.new(-2471.64, 21.96, 2952.65),
    ["XZ City"] = Vector3.new(2286.91, 25.39, 1842.56),
    ["Dragon City"] = Vector3.new(-653.28, 27.19, 36.51),
    ["World Arena"] = Vector3.new(1650.90, 23.64, -66.52),
}

-- Paramètres de l'AutoFarm
Config.AutoFarm = {
    Enabled = false, -- État par défaut
    AttackDistance = 50, -- Distance en studs pour détecter les ennemis
    LoopDelay = 0.5, -- Temps en secondes entre chaque recherche d'ennemi
    -- ⚠️ IMPORTANT: Tu devras trouver le nom du dossier où sont les mobs dans le jeu !
    MobFolderPath = game.Workspace.Mobs -- EXEMPLE, à adapter !
}

return Config
