local pedSpawned = false



local stash = {
    id = Config.Tray.id,
    label = Config.Tray.stashLabel,
    slots = Config.Tray.slots,
    weight = Config.Tray.weight,
    owner = Config.Tray.owner,
    groups = Config.Tray.groups,
    coords = Config.Tray.coords.xyz
}
local BossStash = {
    id = Config.BossStash.id,
    label = Config.BossStash.stashLabel,
    slots = Config.BossStash.slots,
    weight = Config.BossStash.weight,
    owner = Config.BossStash.owner,
    groups = Config.BossStash.groups,
    coords = Config.BossStash.coords.xyz
}

AddEventHandler('QBCore:Server:SetDuty', function(source, onDuty)
    local employeesOnDuty = exports.qbx_core:GetDutyCountJob(Config.Job)

        if employeesOnDuty == 0 and not pedSpawned then
            pedSpawned = true
            TriggerClientEvent('bl_pawnshop:client:spawnPed', -1)
        elseif employeesOnDuty > 0 and pedSpawned then
            pedSpawned = false
            TriggerClientEvent('bl_pawnshop:client:despawnPed', -1)
        end
end)

RegisterNetEvent('bl_pawnshop:server:searchTray', function ()  
    local stashItems = exports.ox_inventory:GetInventoryItems(stash.id)
    print(json.encode(stashItems, {indent = true}))
    
end)

RegisterNetEvent('bl_pawnshop:server:sellItems', function()
    local src = source
    local xPlayer = exports.qbx_core:GetPlayer(src)


    local items = exports.ox_inventory:GetInventoryItems(stash.id)
    print(json.encode(#items))
    if not items then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'There are no items in the tray to sell.'
        })
        return
    end

    
    local total = 0
    local stashItems = 0

    

    for i, item in pairs(items) do
        
        local itemName = item.name
        local count = item.count
        local price = Config.SellableItems[itemName]

        if price then
            total = total + (price * count)
            exports.ox_inventory:RemoveItem(stash.id, itemName, count)
            exports.ox_inventory:AddItem(BossStash.id, itemName, count)
        end
        stashItems = i
    end

    if total > 0 then
        xPlayer.Functions.AddMoney('cash', total, 'pawnshop-sale')
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success',
            description = ('You sold items for $%s'):format(total),
        })
    elseif stashItems <= 0 then 
        
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'There are no items in the tray to sell.'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'None of the items in the tray are accepted.',
            
        })
    end

end)

RegisterNetEvent('bl_pawnshop:server:sellToExporter', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    local inventory = exports.ox_inventory:GetInventoryItems(src)
    local total = 0
    local soldItems = {}

    for _, item in pairs(inventory) do
        local itemName = tostring(item.name)
        local count = item.count
        local price = Config.ExporterSeller[itemName]

        if price and count > 0 then
            total = total + (price * count)
            table.insert(soldItems, {name = itemName, count = count})
        end
    end
    if total > 0 then
        for _, sold in ipairs(soldItems) do
            exports.ox_inventory:RemoveItem(src, sold.name, sold.count)
        end
        Player.Functions.AddMoney('cash', total, 'pawnshop-export-sale')
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success',
            description = ('You exported items for $%s'):format(total)
        })
    else 
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'You have nothing the exporter wants.'
        })
    end
end)


RegisterCommand('searchtray', function()
    TriggerEvent('bl_pawnshop:server:searchTray')
end, false)



AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    Citizen.Wait(1000)
    local employeesOnDuty = exports.qbx_core:GetDutyCountJob(Config.Job)
    if employeesOnDuty == 0 then
        pedSpawned = true
        TriggerClientEvent('bl_pawnshop:client:spawnPed', -1)
    end
    
    exports.ox_inventory:RegisterStash(
        stash.id,
        stash.label,
        stash.slots,
        stash.weight,
        stash.owner,
        stash.groups,
        stash.coords
    )


    exports.ox_inventory:RegisterStash(
    BossStash.id,
    BossStash.label,  
    BossStash.slots,
    BossStash.weight,
    BossStash.owner,
    BossStash.groups,
    BossStash.coords
)

end)



