Config = {}



--   /$$$$$$        /$$       /$$   /$$                     /$$             /$$               /$$                                    
--  /$$__  $$      | $$      | $$  | $$                    | $$            | $$              | $$                                    
-- | $$  \ $$  /$$$$$$$  /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$    /$$$$$$ | $$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$ 
-- | $$$$$$$$ /$$__  $$ /$$__  $$|_  $$_/   /$$__  $$ /$$__  $$ |____  $$|_  $$_/   |____  $$| $$__  $$ |____  $$ /$$_____/ /$$__  $$
-- | $$__  $$| $$  | $$| $$  | $$  | $$    | $$  \ $$| $$  | $$  /$$$$$$$  | $$      /$$$$$$$| $$  \ $$  /$$$$$$$|  $$$$$$ | $$$$$$$$
-- | $$  | $$| $$  | $$| $$  | $$  | $$ /$$| $$  | $$| $$  | $$ /$$__  $$  | $$ /$$ /$$__  $$| $$  | $$ /$$__  $$ \____  $$| $$_____/
-- | $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$| $$$$$$$/|  $$$$$$$ /$$$$$$$/|  $$$$$$$
-- |__/  |__/ \_______/ \_______/   \___/   \______/  \_______/ \_______/   \___/   \_______/|_______/  \_______/|_______/  \_______/



Config.framework = 'QBCore'  -- Or 'ESX'

if Config.framework == 'QBCore' then
    Config.FrameworkObject = exports['qb-core']:GetCoreObject()
elseif Config.framework == 'ESX' then
    Config.FrameworkObject = exports["es_extended"]:getSharedObject()
else
    print('No framework detect')
end

Config.Command = 'Addtodatabase'
Config.Restart = 'restart vms_vehicleshopv2'
Config.webhook = "ADD YOUR WEBHOOK" 

---@field StaffLicenses : Add your license for use command
Config.StaffLicenses = {
    ' licence ', -- Admin 1
   -- ' licence ', -- Admin 2 
}

Config.Translations = {
    addVehicleTitle = "Add a Vehicle",
    addVehicleDescription = "Add a new vehicle to the database.",
    managePricesTitle = "Manage Vehicle Prices",
    managePricesDescription = "View and modify the prices of existing vehicles.",
    successMessage = "Vehicle added successfully.",
    errorMessage = "Error adding the vehicle.",
    cancelMessage = "Action canceled.",
    searchMessage = "Search for vehicle",
    noperms = "You don't have the required permissions.",
    errors = "Error",
    filter = "Filtered Vehicles",
    principalmenu = "Return to the main menu",
    returne = "Return",
    anulation = "Action canceled.",
    pricenovalid = "Invalid price.",
    sendprice = "Price update sent.",
    newprice = "New price",
    modf = "Modify the price",
    priceactu = "Current price: $",
    list = "Vehicle list by category",
    vehicle = "Vehicles - ",
    choicecat = "Click to view vehicles from this category.",
    annulation = "Search canceled.",
    whatvehicle = "No vehicle found.",
    entername = "Enter the name or part of the name",
    cherchvehicle = "Search for a vehicle",
    recherche = "🔍 Search",
    tapetocherch = "Tap to search for a vehicle by name.",
    brand = "Brand",
    name = "Name",
    model = "Model",
    price = "Price",
    orderPrice = "Order price",
    category = "Category",
    type = "Type",
    requiredLicense = "Required License",
    bikeLicense = "Motorcycle License",
    carLicense = "Car License",
    truckLicense = "Truck License",
    planeLicense = "Plane License",
    boatLicense = "Boat License",
    helicopterLicense = "Helicopter License",
    vipLicense = "VIP",
    success = "Success",
    vehicleAddedSuccess = "Vehicle added successfully.",
    invalidPrice = "The price is invalid.",
    cancel = "Canceled",
    error = "Error",
    cancellationMessage = "Action canceled.",
    managePrices = "Manage vehicle prices",
    showVehiclePrices = "View and modify the prices of existing vehicles.",
    vehicleManagementMenu = "Vehicle database management",
    filterVehicles = "Filter vehicles",
    restartScriptTitle = "📥 RESTART the VMS script to update the SQL",
    restartScriptDescription = "Restart the vms_vehicleshopv2 script.",
    restartScriptSuccess = "Vehicle shop script has been restarted."
    
}

--[[ 
  /$$$$$$  /$$        /$$$$$$   /$$$$$$   /$$$$$$  /$$      /$$
 /$$__  $$| $$       /$$__  $$ /$$__  $$ /$$__  $$| $$$    /$$$
| $$  \__/| $$      | $$  \ $$| $$  \__/| $$  \ $$| $$$$  /$$$$
| $$      | $$      | $$$$$$$$|  $$$$$$ | $$$$$$$$| $$ $$/$$ $$
| $$      | $$      | $$__  $$ \____  $$| $$__  $$| $$  $$$| $$
| $$    $$| $$      | $$  | $$ /$$  \ $$| $$  | $$| $$\  $ | $$
|  $$$$$$/| $$$$$$$$| $$  | $$|  $$$$$$/| $$  | $$| $$ \/  | $$
\______/ |________/|__/  |__/ \______/ |__/  |__/|__/     |__/ ]]