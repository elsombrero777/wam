ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

lib.versionCheck('elsombrero777/wam')
if not lib.checkDependency('ox_lib', '2.0.2') then error('You don\'t have latest version of ox_lib') end
if not lib.checkDependency('ox_inventory', '2.6.0') then error('You don\'t have latest version of ox_inventory') end

--------------[ WAM ]--------------

RegisterNetEvent('wam:checkMoney')
AddEventHandler('wam:checkMoney', function(id, label, slots, weight, owner)
    local p = ESX.GetPlayerFromId(source)
    local money = p.getAccount('bank').money
    local seller_id = p.identifier

    if money > Config.Price then
        p.removeAccountMoney('bank', Config.Price)
        exports.ox_inventory:RegisterStash(id, label, slots, weight, owner)

        MySQL.insert('INSERT INTO wam (seller_id) VALUES (?)', {seller_id}, function() end)

        TriggerClientEvent('wam:warehouseOptionsS', source, id, owner)
    end
end)

RegisterNetEvent('wam:warehouseForSale')
AddEventHandler('wam:warehouseForSale', function(price, desc)
    local p = ESX.GetPlayerFromId(source)
    local seller_id = p.identifier
    local v = price
    local d = desc
    local onsale = 1

    MySQL.update('UPDATE wam SET price, description, onSale VALUES (?, ?, ?) WHERE seller_id = ?', {v, d, onsale, seller_id}, function() end)
    TriggerEvent('ox_inventory:notify', {type = 'success', text = 'Your lot is now being sold for ' .. v .. '€!'})
end)

lib.callback.register('wam:isOnSale', function()
    local p = ESX.GetPlayerFromId(source)
    local seller_id = p.identifier
    print(seller_id)
    local cb
    MySQL.single('SELECT onSale FROM wam WHERE seller_id = ?', {seller_id}, function(result)
        print(json.encode(result, {indent = true}))
        cb = result.seller_id
    end)
    return cb
end)