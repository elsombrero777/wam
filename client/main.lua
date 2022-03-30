ESX = nil
Citizen.CreateThread(function() while ESX == nil do TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end) Citizen.Wait(0) end PlayerData = ESX.GetPlayerData() end)

--------------[ WAM ]--------------

local name = ''

for i = 1, #Config.Locations, 1 do
    local MarketPoint = lib.points.new(Config.Locations[i].pos, 7, { type = Config.Locations[i].type, name = Config.Locations[i].name})
    function MarketPoint:nearby()
        DrawMarker(29,self.coords.x, self.coords.y, self.coords.z, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.75, 31, 94, 255, 155, 0, 0, 2, 1, 0, 0, 0);
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            OpenMarket(self.id ,self.type)
            name = self.name
        end
    end
end

function OpenMarket(id ,type)
    if type == 'black' then
        TriggerEvent('wam:testMenu')
    --elseif type == 'market' then
    --elseif type == 'vehicle' then
    end
end

RegisterNetEvent('wam:testMenu', function()
    TriggerEvent('nh-context:createMenu', {
        {
            header = "BlackMarket",
        },
        {
            header = "Buy your Warehouse",
            context = "Get a space to store your sellables.",
            event = 'wam:buyWarehouse'
        },
        {
            header = "Open your Warehouse",
            context = "If you have a Warehouse already.",
            event = 'wam:openWarehouseS'
        }
        --[[{
            header = "Browse the Market",
            txt = "Look for Items you might want to buy.",
            params = {
                event = ''
            }
        }]]--
    })
end)

RegisterNetEvent('wam:buyWarehouse', function()
    local w = {
        id = name,
        label = name .. ' - Blackmarket',
        slots = 10,
        weight = 1000000,
        owner = PlayerData.identifier
    }
    TriggerServerEvent('wam:checkMoney', w.id, w.label, w.slots, w.weight, w.owner)
end)

RegisterNetEvent('wam:openWarehouseS', function(id, owner)
    lib.callback('wam:isOnSale', false, function(result)
        local y = result
        if y == 0 then
            exports.ox_inventory:openInventory('stash', {id=id, owner=owner})
        else
            TriggerEvent('ox_inventory:notify', {type = 'error', text = "You must first buy a Warehouse!"})
        end
    end)
end)

RegisterNetEvent('wam:warehouseOptionsS', function(id, owner)
    local i = id
    local o = owner
    TriggerEvent('nh-context:createMenu', {
        {
            header = "Open your Warehouse",
            context = "Deposit or Withdraw items before you sell.",
            event = 'wam:openWarehouseS',
            args = {
                i, o
            }
        },
        {
            header = "Put your Package for sale",
            context = "Your Warehouse's items will be put for sale.",
            event = 'wam:warehousePriceDesc'
        }
    })
end)

RegisterNetEvent('wam:warehousePriceDesc', function()
    local data = exports.ox_inventory:Keyboard("Specify the Price and Description of the Lot", {'Price', 'Description'})

    if data then
        local price = tonumber(data[1])
        local desc = data[2]
        TriggerServerEvent('wam:warehouseForSale', price, desc)
    else
        TriggerEvent('ox_inventory:notify', {type = 'error', text = "You must specify the Price and Description!"})
    end
end)