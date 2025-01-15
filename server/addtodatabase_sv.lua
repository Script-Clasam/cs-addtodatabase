

--  /$$      /$$           /$$       /$$                           /$$      
-- | $$  /$ | $$          | $$      | $$                          | $$      
-- | $$ /$$$| $$  /$$$$$$ | $$$$$$$ | $$$$$$$   /$$$$$$   /$$$$$$ | $$   /$$
-- | $$/$$ $$ $$ /$$__  $$| $$__  $$| $$__  $$ /$$__  $$ /$$__  $$| $$  /$$/
-- | $$$$_  $$$$| $$$$$$$$| $$  \ $$| $$  \ $$| $$  \ $$| $$  \ $$| $$$$$$/ 
-- | $$$/ \  $$$| $$_____/| $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$_  $$ 
-- | $$/   \  $$|  $$$$$$$| $$$$$$$/| $$  | $$|  $$$$$$/|  $$$$$$/| $$ \  $$
-- |__/     \__/ \_______/|_______/ |__/  |__/ \______/  \______/ |__/  \__/
                                                                         
                                                                   
function sendDiscordWebhook(vehicleData, oldPrice, newPrice)
    local embedData = {
        {
            ["color"] = 5814783,
            ["title"] = ":dollar: **Price Change Notification** :dollar:",
            ["description"] = "**A vehicle price has been updated!** :tada:",
            ["fields"] = {
                {
                    ["name"] = " 🚗 **Vehicle:**",
                    ["value"] = vehicleData.brand .. " " .. vehicleData.name,
                    ["inline"] = true
                },
                {
                    ["name"] = ":arrow_down: **Old Price:**",
                    ["value"] = "$" .. oldPrice,
                    ["inline"] = true
                },
                {
                    ["name"] = ":arrow_up: **New Price:**",
                    ["value"] = "$" .. newPrice,
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Vehicle Price Update |  Admin Action",
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    PerformHttpRequest(Config.webhook, function(err, text, headers) 
    end, 'POST', json.encode({embeds = embedData}), { ['Content-Type'] = 'application/json' })
end





RegisterNetEvent('addtodatabase:checkAdmin', function()
    local src = source
    local playerLicense = GetIdentifier(src, 'license')

    if Config.framework == 'QBCore' then
        local Player = Config.FrameworkObject.Functions.GetPlayer(src)
        if Player and (Player.PlayerData.group == 'admin' or IsStaffLicence(playerLicense)) then
            TriggerClientEvent('addtodatabase:isAdmin', src, true)
        else
            TriggerClientEvent('addtodatabase:isAdmin', src, false)
        end
    elseif Config.framework == 'ESX' then
        local Player = Config.FrameworkObject.GetPlayerFromId(src)
        if Player and (Player.getGroup() == 'admin' or IsStaffLicence(playerLicense)) then
            TriggerClientEvent('addtodatabase:isAdmin', src, true)
        else
            TriggerClientEvent('addtodatabase:isAdmin', src, false)
        end
    else
        print('Framework non détecté')
    end
end)

function IsStaffLicence(license)
    if not Config or not Config.StaffLicenses then
        return false
    end
    for _, v in ipairs(Config.StaffLicenses) do
        if v == license then
            return true
        end
    end
    return false
end

function GetIdentifier(playerId, idType)
    local identifiers = GetPlayerIdentifiers(playerId)

    for _, identifier in ipairs(identifiers) do
        if identifier:find(idType .. ":") then
            return identifier
        end
    end
    return nil
end


RegisterNetEvent('addtodatabase:addVehicle', function(brand, name, model, price, orderPrice, category, type, requiredLicense)
    exports.oxmysql:insert('INSERT INTO vehicles (brand, name, model, price, orderprice, category, type, requiredLicense) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        brand, name, model, price, orderPrice or 0, category, type, requiredLicense or 'none'
    }, function(insertedId)
        if insertedId then
            print('Success')
        else
            print('Erreur lors de l\'ajout du véhicule.')
        end
    end)
end)
RegisterNetEvent('addtodatabase:addCategory', function(name, label)
    exports.oxmysql:insert('INSERT INTO vehicle_categories (name, label) VALUES (?, ?)', { name, label }, function(insertedId)
        if insertedId then
            print('Success')
        else
            print('Erreur lors de l\'ajout de la catégorie.')
        end
    end)
end)
RegisterNetEvent('addtodatabase:getVehiclePrices', function()
    local src = source

    exports.oxmysql:execute('SELECT category, brand, name, price FROM vehicles', {}, function(result)
        if result and #result > 0 then
            TriggerClientEvent('addtodatabase:showPricesMenu', src, result)
        else
            TriggerClientEvent('addtodatabase:showPricesMenu', src, {})
        end
    end)
end)
RegisterNetEvent('addtodatabase:updateVehiclePrice', function(brand, name, newPrice)
    local src = source

    if not brand or not name or not newPrice then
        TriggerClientEvent('addtodatabase:notifyUpdate', src, false)
        return
    end
    exports.oxmysql:execute('SELECT price FROM vehicles WHERE brand = ? AND name = ?', { brand, name }, function(result)
        if result and #result > 0 then
            local oldPrice = result[1].price
            exports.oxmysql:update('UPDATE vehicles SET price = ? WHERE brand = ? AND name = ?', { newPrice, brand, name }, function(affectedRows)
                if affectedRows and affectedRows > 0 then
                    sendDiscordWebhook({brand = brand, name = name}, oldPrice, newPrice)

                    TriggerClientEvent('addtodatabase:notifyUpdate', src, true)
                else
                    TriggerClientEvent('addtodatabase:notifyUpdate', src, false)
                end
            end)
        else
            TriggerClientEvent('addtodatabase:notifyUpdate', src, false)
        end
    end)
end)
RegisterNetEvent('addtodatabase:spawnPreviewVehicle', function(coords, vehicleModel)
    local src = source
    TriggerClientEvent('addtodatabase:spawnPreviewVehicleClient', src, coords, vehicleModel)
end)




