local ClothShop = {
    vector3(-158.731, -297.06, 39.7),
    vector3(10.78, 6514.1, 31.8),
}

local Opti = {}

for k,v in pairs(ClothShop) do
    RegisterActionZone({name = "clothShop", pos = v}, "Press ~INPUT_PICKUP~ to do action", function()
        OpenClothShop()
    end)
end

function unloadClothShops()
    UnregisterActionZone("clothShop")
end

local open = false
RMenu.Add('core', 'clothshop', RageUI.CreateMenu("Magasin vètement", "~b~Géstion des vétement de votre personnage."))
RMenu:Get('core', 'clothshop').Closed = function()
    open = false
end;

RMenu.Add('core', "tenues_create", RageUI.CreateSubMenu(RMenu:Get('core', 'clothshop'), "Magasin vètement", "~b~Géstion des vétement de votre personnage."))
RMenu:Get('core', "tenues_create").Closed = function()
end;

RMenu.Add('core', "tenues", RageUI.CreateSubMenu(RMenu:Get('core', 'clothshop'), "Magasin vètement", "~b~Géstion des vétement de votre personnage."))
RMenu:Get('core', "tenues").Closed = function()
end;

local clothing = {}
function GetClothValues()
    local _clothing = {
        {price = 24, label = "t-Shirt", r = "tshirt_2",                                 item = "tshirt_1", 	max = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 8) - 1,	 min = 0,},
        {price = 12, label = "Couleur du t-Shirt",       c = 8, o = "tshirt_1",  		item = "tshirt_2", 	                                                                     min = 0,},
        {price = 36, label = "Veste", 	r = "torso_2",                                  item = "torso_1", 	max	= GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 11) - 1,	 min = 0,},
        {price = 9,  label = "Couleur de la veste", c = 11, o = "torso_1",   	        item = "torso_2", 		 		                                                         min = 0,},
        {price = 5,  label = "calques 1", r = "decals_2",                               item = "decals_1", 	max = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 10) - 1,	 min = 0,},
        {price = 2,  label = "calques 2",c = 10, o = "decals_1",  				        item = "decals_2", 			                                                             min = 0,},
        {price = 12,  label = "bras", r = "arms_2",                                     item = "arms", 		max = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 3) - 1,	 min = 0,},
        {price = 2,  label = "Couleur des gants.", 		                                item = "arms_2", 	max = 10,															 min = 0,},
        {price = 15, label = "Pantalon", r = "pants_2",                                 item = "pants_1", 	max = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 4) - 1,	 min = 0,},
        {price = 5,  label = "Couleur du pantalon",c = 4, o = "pants_1",  		        item = "pants_2", 		 	                                                             min = 0,},
        {price = 18, label = "chaussures 1", r = "shoes_2",                             item = "shoes_1", 	max = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), 6) - 1,	 min = 0,},
        {price = 10, label = "Style des chaussures",c = 6, o = "shoes_1",  	            item = "shoes_2", 		 	                                                             min = 0,},
    }
    clothing = _clothing
end

Citizen.CreateThread(function()
    GetClothValues()
    for k,v in pairs(clothing) do
        RMenu.Add('core', v.item.."1", RageUI.CreateSubMenu(RMenu:Get('core', 'tenues_create'), "Cloth Shop", "~b~Clotch Menu."))
        RMenu:Get('core', v.item.."1").Closed = function()
        end
    end
end)


function OpenClothShop()
    RageUI.Visible(RMenu:Get('core', 'clothshop'), not RageUI.Visible(RMenu:Get('core', 'clothshop')))
    OpenClothShopThread()
    GetClothValues()
end


function OpenClothShopThread()
    if open then return end
    Citizen.CreateThread(function()
        open = true
        while open do

            if IsControlJustReleased(1, 22) then
                ClearPedTasks(GetPlayerPed(-1))
                local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -5.0, 0.0)
                TaskTurnPedToFaceCoord(GetPlayerPed(-1), coords, 3000)
            end

            Wait(1)

            RageUI.IsVisible(RMenu:Get('core', 'clothshop'), true, true, true, function()
                RageUI.ButtonWithStyle("Faire une nouvelle tenue", nil, { RightLabel = "→→" }, true, function()
                end, RMenu:Get('core', 'tenues_create'))

            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('core', 'tenues_create'), true, true, true, function()  
                for k,v in pairs(clothing) do
                   RageUI.ButtonWithStyle(v.label, nil, { RightLabel = "→→" }, true, function(_,_,s)
                        if s then
                        end
                    end, RMenu:Get('core', v.item.."1"))
                end

            end, function()
            end)

            for k,v in pairs(clothing) do
                RageUI.IsVisible(RMenu:Get('core', v.item.."1"), true, true, true, function()
                    RageUI.ButtonWithStyle("Faire tourner son personnage.", nil, {}, true, function(_,_,s)
                        if s then
                            ClearPedTasks(GetPlayerPed(-1))
                            local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, -5.0, 0.0)
                            TaskTurnPedToFaceCoord(GetPlayerPed(-1), pos, 3000)
                        end
                    end)
                    if v.c ~= nil then
                        for i = v.min, GetNumberOfPedTextureVariations(GetPlayerPed(-1), v.c, value) - 1 do
                            if Opti[k] == nil then Opti[k] = i end
                            RageUI.ButtonWithStyle(v.label.." "..i, nil, { RightLabel = "→→ Acheter ~r~"..v.price.."~s~ $" },  true , function(_,h,s)
                                print(v.label)
                                if s then
                                    TriggerEvent("skinchanger:getSkin", function(skin)
                                        TriggerServerEvent("creator:SaveSkin", skin , identity)
                                    end)
                                    local id = GetPlayerServerId(PlayerId())
                                    local rmv = v.price
                                   -- print(id)
                                    TriggerServerEvent("rFw:RemoveMoney", id , rmv)
                                    ShowNotification("Vous avez payer ~r~"..rmv.."~w~ $ .~g~ Merci de votre confiance !")
                                end
                               if h then
                                    if Opti[k] ~= i then
                                        TriggerEvent("skinchanger:change", v.item, i)
                                        Opti[k] = i
                                    end
                               end
                            end) 
                        end
                    else
                        for i = v.min, v.max do
                            if Opti[k] == nil then Opti[k] = i end
                            RageUI.ButtonWithStyle(v.label.." "..i, nil, { RightLabel = "→→ Acheter ~r~"..v.price.."~s~ $" },  true ,function(_,h,s)
                               if s then
                                TriggerEvent("skinchanger:getSkin", function(skin)
                                    TriggerServerEvent("creator:SaveSkin", skin)
                                end)
                                local id = GetPlayerServerId(PlayerId())
                                local rmv = v.price
                                TriggerServerEvent("rFw:RemoveMoney", id , rmv)
                                ShowNotification("Vous avez payer ~r~"..rmv.."~w~ $ .~g~ Merci de votre confiance !")

                               end
                               if h then
                                    if Opti[k] ~= i then
                                        TriggerEvent("skinchanger:change", v.item, i)
                                        Opti[k] = i
                                    end
                               end
                            end) 
                        end
                    end
                end, function()

                end)
            end
        end
    end)
end