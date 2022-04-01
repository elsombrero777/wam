ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

lib.versionCheck('elsombrero777/wam')
if not lib.checkDependency('ox_lib', '2.1.0') then error('You don\'t have latest version of ox_lib') end
if not lib.checkDependency('ox_inventory', '2.7.2') then error('You don\'t have latest version of ox_inventory') end

--------------[ WAM ]--------------

AddEventHandler('onServerResourceStart', function(wam)
    local m = MySQL.query.await('SELECT * FROM wam')

    for i = 1, #m, 1 do
        local id = 'wam_'..m[i].stash_id
        exports.ox_inventory:RegisterStash(id, m[i].place, Config.Slots, Config.Weight)
    end
end)


RegisterNetEvent('wam:checkMoney')
AddEventHandler('wam:checkMoney', function(label, slots, weight, loc)
    local _source = source
    local p = ESX.GetPlayerFromId(source)
    local money = p.getAccount('bank').money
    local seller_id = p.identifier
    local place = loc

    if money > Config.Price then
        p.removeAccountMoney('bank', Config.Price)
        MySQL.insert('INSERT INTO wam (seller_id, place) VALUES (?, ?)', {seller_id, label}, function(id2)
            local id = 'wam_'..id2
            exports.ox_inventory:RegisterStash(id, label, slots, weight)
            TriggerClientEvent('wam:warehouseOptionsS', _source, id)
            TriggerClientEvent('ox_inventory:notify', _source, {type = 'success', text = 'You bought a Warehouse for ' .. Config.Price .. '€'})
        end)
    else
        TriggerClientEvent('ox_inventory:notify', _source, {type = 'error', text = 'Your need at least ' .. Config.Price .. '€!'})
    end
end)

RegisterNetEvent('wam:hasWarehouse')
AddEventHandler('wam:hasWarehouse', function()
    local _source = source
    local p = ESX.GetPlayerFromId(source)
    local seller_id = p.identifier
    local x = MySQL.query.await('SELECT * FROM wam WHERE onSale = 0 AND seller_id = ?', {seller_id})
    local y = MySQL.scalar.await('SELECT stash_id FROM wam WHERE onSale = 0 AND seller_id = ?', {seller_id})
    local z = ''

    if y then
        z = 'wam_'..y
    end

    if x[1] == nil then
        TriggerClientEvent('wam:warehouseOptionsB', _source)
    else
        TriggerClientEvent('wam:warehouseOptionsS', _source, z)
    end
end)

RegisterNetEvent('wam:warehouseForSale')
AddEventHandler('wam:warehouseForSale', function(price, desc)
    local _source = source
    local p = ESX.GetPlayerFromId(source)
    local seller_id = p.identifier
    local v = price
    local d = desc
    local onsale = 1
    local s_id = MySQL.scalar.await('SELECT stash_id FROM wam WHERE onSale = 0 AND seller_id = ?', {seller_id})

    MySQL.update('UPDATE wam SET price = ?, description = ?, onSale = ? WHERE stash_id = ?', {v, d, onsale, s_id}, function() end)
    TriggerClientEvent('ox_inventory:notify', _source, {type = 'success', text = 'Your lot is now being sold for ' .. v .. '€!'})
end)