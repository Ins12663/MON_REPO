--[[
    Module d'Autofarm
    Gère l'activation et l'exécution de l'autofarm.
--]]

return function(UI, Config)
    local Player = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    
    local isFarming = Config.AutoFarm.Enabled
    local farmConnection = nil

    local farmSection = UI:CreateSection("⚔️ AUTOFARM", 2)
    
    local farmButton = UI:CreateButton(farmSection, "Activer AutoFarm", nil)

local function findNearestEnemy()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

    local playerPos = character.HumanoidRootPart.Position
    local nearestDist = Config.AutoFarm.AttackDistance
    local nearestEnemy = nil

    -- NOUVELLE LOGIQUE POUR TROUVER LE DOSSIER DE MANIÈRE SÉCURISÉE
    local mobFolder = game.Workspace
    for _, folderName in ipairs(Config.AutoFarm.MobFolderPath) do
        -- On utilise WaitForChild pour attendre que le dossier soit créé par le jeu (jusqu'à 5 secondes)
        mobFolder = mobFolder:WaitForChild(folderName, 5) 
        if not mobFolder then
            warn("Dossier des mobs non trouvé, chemin invalide à l'étape : " .. folderName)
            return nil
        end
    end
    -- À ce stade, mobFolder est le bon dossier _Enemies, trouvé en toute sécurité.

    if not mobFolder then
         warn("Le chemin des mobs est introuvable après attente.")
         return nil
    end

    for _, enemy in ipairs(mobFolder:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
            local dist = (playerPos - enemy.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestEnemy = enemy
            end
        end
    end
    return nearestEnemy
end

    local function farmLoop()
        local enemy = findNearestEnemy()
        if enemy and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            -- 1. Se déplacer vers l'ennemi (si nécessaire)
            Player.Character.Humanoid:MoveTo(enemy.HumanoidRootPart.Position)
            
            -- 2. Attaquer l'ennemi
            -- ⚠️ L'attaque dépend du jeu. Souvent, il faut appeler un RemoteEvent.
            -- Ceci est un EXEMPLE. Tu devras trouver le bon RemoteEvent et les bons arguments.
            -- Utilise un outil comme "RemoteSpy" pour le trouver.
            
            -- Exemple de structure de RemoteEvent
            -- local AttackRemote = game.ReplicatedStorage.Remotes.AttackEvent
            -- AttackRemote:FireServer(enemy)

            print("Attaque de : " .. enemy.Name)
        end
    end

    local function toggleFarm()
        isFarming = not isFarming
        Config.AutoFarm.Enabled = isFarming
        
        if isFarming then
            farmButton.Text = "Désactiver AutoFarm"
            farmConnection = RunService.Heartbeat:Connect(farmLoop)
            print("AutoFarm activé.")
        else
            farmButton.Text = "Activer AutoFarm"
            if farmConnection then
                farmConnection:Disconnect()
                farmConnection = nil
            end
            print("AutoFarm désactivé.")
        end
    end

    farmButton.MouseButton1Click:Connect(toggleFarm)
end
