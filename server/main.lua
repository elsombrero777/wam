ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

lib.versionCheck('elsombrero777/wam')
if not lib.checkDependency('ox_lib', '2.1.0') then error('You don\'t have latest version of ox_lib') end
if not lib.checkDependency('ox_inventory', '2.6.1') then error('You don\'t have latest version of ox_inventory') end

--------------[ WAM ]--------------

RegisterNetEvent('wam:soldOrNot')
AddEventHandler('wam:soldOrNot', function()
    local _source = source
    local p = ESX.GetPlayerFromId(source)
    local s_id = p.identifier
    local sold = MySQL.scalar.await('SELECT collect FROM wam_sold WHERE seller_id = ?', {s_id})

    if sold == nil or sold == 0 then
        TriggerClientEvent('wam:blackMain', _source)
    else
        TriggerClientEvent('wam:blackMainC', _source)
    end
end)

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
    local m = exports.ox_inventory:GetItem(_source, 'money')
    local money = m.count
    local seller_id = p.identifier
    local place = loc

    if money > Config.Price then
        exports.ox_inventory:RemoveItem(_source, 'money', Config.Price)
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

RegisterNetEvent('wam:browseMarket')
AddEventHandler('wam:browseMarket', function()
    local _source = source
    local b = MySQL.query.await('SELECT * FROM wam WHERE onSale = 1')

    TriggerClientEvent('wam:bMarket', _source, b[1].description, b[1].price, b[1].stash_id, b[1].seller_id)
end)

RegisterNetEvent('wam:buyWarehouse')
AddEventHandler('wam:buyWarehouse', function(s_id, price, seller_id)
    local _source = source
    local p = ESX.GetPlayerFromId(source)
    local m = exports.ox_inventory:GetItem(_source, 'money')
    local money = m.count
    local stash_id = 'wam_'..s_id
    local v = price
    local sl_id = seller_id
    print(sl_id)

    if money >= v then
        exports.ox_inventory:RemoveItem(_source, 'money', v)
        TriggerClientEvent('wam:openWarehouseS', _source, stash_id)
        MySQL.insert('INSERT INTO wam_sold (seller_id, collect) VALUES (? ,?)', {sl_id ,v})
    else
    end
end)

RegisterNetEvent('wam:collectMoney')
AddEventHandler('wam:collectMoney', function()
    local _source = source
    local p = ESX.GetPlayerFromId(source)
    local seller_id = p.identifier
    local money = MySQL.scalar.await('SELECT collect FROM wam_sold WHERE seller_id = ?', {seller_id})

    exports.ox_inventory:AddItem(_source, 'money', money)
    MySQL.update('UPDATE wam_sold SET collect = ? WHERE seller_id = ?', {0, seller_id})
end)