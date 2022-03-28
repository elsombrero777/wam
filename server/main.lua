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

    if money > Config.Price then
        p.removeAccountMoney('bank', Config.Price)
        exports.ox_inventory:RegisterStash(id, label, slots, weight, owner)
    end
end)