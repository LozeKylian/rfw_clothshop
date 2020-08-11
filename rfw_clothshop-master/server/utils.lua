RegisterNetEvent(config.prefix.."RemoveMoney")
AddEventHandler(config.prefix.."RemoveMoney", function(id , rmv)
   
    if exports.rFw:GetMoney(id) >= rmv then
        
        exports.rFw:RemoveMoney(id , rmv)
        
        TriggerClientEvent(config.prefix.."OnRemoveMoney", id, rmv)
    else
        print("Le jouer n'as pas asser d'argent")
    
    end
end)

RegisterNetEvent(config.prefix.."SaveSkin")
AddEventHandler(config.prefix.."SaveSkin", function(skin)
    exports.rFw:SavePlayerSkin(source, skin)
end)