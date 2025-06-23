--[[
    Module de Téléportation
    Crée les boutons de téléportation dans l'UI.
--]]

return function(UI, Config)
    local Player = game.Players.LocalPlayer
    
    local tpSection = UI:CreateSection("🌍 TELEPORTS", 1)
    
    for name, position in pairs(Config.TeleportLocations) do
        UI:CreateButton(tpSection, name, function()
            local character = Player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                print("Téléportation vers : " .. name)
                character:MoveTo(position)
            else
                warn("Personnage non trouvé pour la téléportation.")
            end
        end)
    end
end
