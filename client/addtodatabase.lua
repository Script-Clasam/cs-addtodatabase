RegisterNetEvent('addtodatabase:showMenu', function()
    local function openMainMenu()
        local options = {}
        table.insert(options, {
            title = Config.Translations.addVehicleTitle,
            description = Config.Translations.addVehicleDescription,
            onSelect = function()
                local input = lib.inputDialog(Config.Translations.addVehicleTitle, {
                    { type = 'input', label = Config.Translations.brand, placeholder = 'Exemple : BMW', required = true },
                    { type = 'input', label = Config.Translations.name, placeholder = 'Exemple : M5', required = true },
                    { type = 'input', label = Config.Translations.model, placeholder = 'Exemple : bmwm5', required = true },
                    { type = 'number', label = Config.Translations.price, placeholder = 'Exemple : 50000', min = 1, required = true },
                    { type = 'number', label = Config.Translations.orderPrice, placeholder = 'Exemple : 45000', min = 1000,  required = true },
                    { 
                        type = 'select', 
                        label = Config.Translations.category,
                        options = {
                            { label = "Motorcycles", value = 'motorcycles' },
                            { label = "SUVs", value = 'suvs' },
                            { label = "Sedans", value = 'sedans' },
                            { label = "Offroad", value = 'offroad' },
                            { label = "Muscle", value = 'muscle' },
                            { label = "Compacts", value = 'compacts' },
                            { label = "Sports Classics", value = 'sportsclassics' },
                            { label = "Super", value = 'super' },
                            { label = "Bikes", value = 'bikes' },
                            { label = "Planes", value = 'planes' },
                            { label = "Coupes", value = 'coupes' },
                            { label = "Vans", value = 'vans' },
                            { label = "Boats", value = 'boats' },
                            { label = "Helicopters", value = 'helicopters' },
                            { label = "Commercial", value = 'commercial' }
                        },
                        required = true 
                    },
                    { 
                        type = 'select', 
                        label = Config.Translations.type, 
                        options = { 
                            { label = Config.Translations.vehicleType, value = 'vehicle' },
                            { label = Config.Translations.planeType, value = 'plane' },
                            { label = Config.Translations.boatType, value = 'boat' },
                            { label = Config.Translations.helicoptereType, value = 'helicopters' },
                        }, 
                        required = true 
                    },
                    { 
                        type = 'select', 
                        label = Config.Translations.requiredLicense, 
                        options = { 
                            { label = Config.Translations.bikeLicense, value = 'drive_a' },
                            { label = Config.Translations.carLicense, value = 'drive_b' },
                            { label = Config.Translations.truckLicense, value = 'drive_c' },
                            { label = Config.Translations.planeLicense, value = 'practical_plane' },
                            { label = Config.Translations.boatLicense, value = 'practical_boat' },
                            { label = Config.Translations.helicopterLicense, value = 'practical_helicopter' },
                            { label = Config.Translations.vipLicense, value = 'vip' }
                        }, 
                        required = true 
                    },
                })
                if input then
                    local brand = input[1]
                    local name = input[2]
                    local model = input[3]
                    local price = tonumber(input[4])
                    local orderPrice = tonumber(input[5])
                    local category = input[6]
                    local type = input[7]
                    local requiredLicense = input[8]

                    if price then
                        TriggerServerEvent('addtodatabase:addVehicle', brand, name, model, price, orderPrice, category, type, requiredLicense)
                        lib.notify({ title = 'Succès', description = Config.Translations.vehicleAddedSuccess, type = 'success' })
                        openMainMenu()
                    else
                        lib.notify({ title = Config.Translations.errors, description = Config.Translations.invalidPrice, type = 'error' })
                    end
                else
                    lib.notify({ title = 'Annulé', description = Config.Translations.anulation, type = 'error' })
                    openMainMenu()
                end
            end
        })
        table.insert(options, {
            title = Config.Translations.managePrices,
            description = Config.Translations.showVehiclePrices,
            onSelect = function()
                TriggerServerEvent('addtodatabase:getVehiclePrices')
            end
        })
        table.insert(options, {
            title = Config.Translations.restartScriptTitle,
            description = Config.Translations.restartScriptDescription,
            onSelect = function()
                ExecuteCommand(Config.Restart)
                lib.notify({ title = 'Success', description = Config.Translations.restartScriptSuccess, type = 'success' })
            end
        })
        lib.registerContext({
            id = 'addtodatabase_menu',
            title = Config.Translations.vehicleManagementMenu,
            options = options
        })

        lib.showContext('addtodatabase_menu')
    end
    openMainMenu()
end)


RegisterNetEvent('addtodatabase:showPricesMenu', function(vehicles)
    local categorizedVehicles = {}
    for _, vehicle in pairs(vehicles) do
        if vehicle.category and vehicle.brand and vehicle.name and vehicle.price then
            if not categorizedVehicles[vehicle.category] then
                categorizedVehicles[vehicle.category] = {}
            end
            table.insert(categorizedVehicles[vehicle.category], vehicle)
        else
           -- print('Donnée manquante)
        end
    end

    local menuOptions = {}
    table.insert(menuOptions, {
        title = Config.Translations.recherche,
        description = Config.Translations.tapetocherch,
        icon = 'fas fa-search',
        onSelect = function()
            local input
            local searchTerm
            local filteredVehicles
            repeat
                input = lib.inputDialog(Config.Translations.cherchvehicle, {
                    { type = 'input', label = Config.Translations.entername, required = true }
                })

                if input then
                    searchTerm = input[1]:lower()
                    filteredVehicles = {}
                    for _, vehicle in pairs(vehicles) do
                        if vehicle.name:lower():find(searchTerm) then
                            table.insert(filteredVehicles, vehicle)
                        end
                    end
                    if #filteredVehicles > 0 then
                        showFilteredVehicles(filteredVehicles)
                        break
                    else
                        lib.notify({ title = 'Aucun résultat', description = Config.Translations.whatvehicle, type = 'error' })
                    end
                else
                    lib.notify({ title = 'Annulé', description = Config.Translations.annulation, type = 'error' })
                    break
                end
            until false
        end
    })
    for category, vehiclesInCategory in pairs(categorizedVehicles) do
        local categoryIcon
        if category == "boats" then
            categoryIcon = 'fas fa-ship'
        elseif category == "planes" then
            categoryIcon = 'fas fa-plane'
        elseif category == "helicopters" then
            categoryIcon = 'fas fa-helicopter'
        elseif category == "bikes" then
            categoryIcon = 'fas fa-bicycle'
        elseif category == "motorcycles" then
            categoryIcon = 'fas fa-motorcycle'
        else
            categoryIcon = 'fas fa-cogs'
        end
        table.insert(menuOptions, {
            title = category,
            description = Config.Translations.choicecat,
            icon = categoryIcon,
            onSelect = function()
                local vehicleOptions = {}
                for _, vehicle in pairs(vehiclesInCategory) do
                    local vehicleIcon = 'fas fa-car'
                    if category == "planes" then
                        vehicleIcon = 'fas fa-plane'
                    elseif category == "helicopters" then
                        vehicleIcon = 'fas fa-helicopter'
                    elseif category == "boats" then
                        vehicleIcon = 'fas fa-ship'
                    elseif category == "bikes" then
                        vehicleIcon = 'fas fa-bicycle'
                    elseif category == "motorcycles" then
                        vehicleIcon = 'fas fa-motorcycle'
                    end
                    table.insert(vehicleOptions, {
                        title = vehicle.name .. ' (' .. vehicle.brand .. ')',
                        description = Config.Translations.priceactu .. vehicle.price,
                        icon = vehicleIcon,
                        onSelect = function()
                            local input = lib.inputDialog(Config.Translations.modf, {
                                { type = 'number', label = Config.Translations.newprice, placeholder = tostring(vehicle.price), min = 1, required = true }
                            })

                            if input then
                                local newPrice = tonumber(input[1])
                                if newPrice and newPrice > 0 then
                                    TriggerServerEvent('addtodatabase:updateVehiclePrice', vehicle.brand, vehicle.name, newPrice)
                                    lib.notify({ title = 'Succès', description = Config.Translations.sendprice, type = 'success' })
                                else
                                    lib.notify({ title = Config.Translations.errors, description = Config.Translations.pricenovalid, type = 'error' })
                                end
                            else
                                lib.notify({ title = 'Annulé', description = Config.Translations.anulation, type = 'error' })
                            end
                        end
                    })
                end
                table.insert(vehicleOptions, {
                    title = Config.Translations.returne,
                    description = Config.Translations.principalmenu,
                    icon = 'fas fa-arrow-left',
                    onSelect = function()
                        lib.showContext('vehicle_prices_menu')
                    end
                })
                lib.registerContext({
                    id = 'vehicles_in_category_' .. category,
                    title = Config.Translations.vehicle .. category,
                    options = vehicleOptions
                })

                lib.showContext('vehicles_in_category_' .. category)
            end
        })
    end
    lib.registerContext({
        id = 'vehicle_prices_menu',
        title = Config.Translations.list,
        options = menuOptions
    })
   lib.showContext('vehicle_prices_menu')
function showFilteredVehicles(filteredVehicles)
    local filteredOptions = {}

    for _, vehicle in pairs(filteredVehicles) do
        local vehicleIcon = 'fas fa-car'
        if vehicle.category == "planes" then
            vehicleIcon = 'fas fa-plane'
        elseif vehicle.category == "helicopters" then
            vehicleIcon = 'fas fa-helicopter'
        elseif vehicle.category == "boats" then
            vehicleIcon = 'fas fa-ship'
        elseif vehicle.category == "bikes" then
            vehicleIcon = 'fas fa-bicycle'
        elseif vehicle.category == "motorcycles" then
            vehicleIcon = 'fas fa-motorcycle'
        end

        table.insert(filteredOptions, {
            
            title = vehicle.name .. ' (' .. vehicle.brand .. ')',
            description = Config.Translations.priceactu .. vehicle.price,
            icon = vehicleIcon,
            onSelect = function()
                local input = lib.inputDialog(Config.Translations.modf, {
                    { type = 'number', label = Config.Translations.newprice, placeholder = tostring(vehicle.price), min = 1, required = true }
                })

                if input then
                    local newPrice = tonumber(input[1])
                    if newPrice and newPrice > 0 then
                        TriggerServerEvent('addtodatabase:updateVehiclePrice', vehicle.brand, vehicle.name, newPrice)
                        lib.notify({ title = 'Succès', description = Config.Translations.sendprice, type = 'success' })
                        showFilteredVehicles(filteredVehicles)
                    else
                        lib.notify({ title = Config.Translations.errors, description = Config.Translations.pricenovalid, type = 'error' })
                    end
                else
                    lib.notify({ title = 'Annulé', description = Config.Translations.anulation, type = 'error' })
                end
            end
        })
    end

    table.insert(filteredOptions, {
        title = Config.Translations.returne,
        description = Config.Translations.principalmenu,
        icon = 'fas fa-arrow-left',
        onSelect = function()
            lib.showContext('vehicle_prices_menu')
        end
    })

    lib.registerContext({
        id = 'filtered_vehicles_menu',
        title = Config.Translations.filter,
        options = filteredOptions
    })

    lib.showContext('filtered_vehicles_menu')
end
end)
RegisterCommand(Config.Command, function()
    TriggerServerEvent('addtodatabase:checkAdmin')
end, false)

RegisterNetEvent('addtodatabase:isAdmin', function(isAdmin)
    if isAdmin then
        TriggerEvent('addtodatabase:showMenu')
    else
        lib.notify({ title = Config.Translations.errors, description = Config.Translations.noperms, type = 'error' })
    end
end)

