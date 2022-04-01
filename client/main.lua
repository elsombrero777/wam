ESX = nil
Citizen.CreateThread(function() while ESX == nil do TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end) Citizen.Wait(0) end PlayerData = ESX.GetPlayerData() end)

--------------[ WAM ]--------------

local name = ''
local market = ''

for i = 1, #Config.Locations, 1 do
    local MarketPoint = lib.points.new(Config.Locations[i].pos, 7, { market = Config.Locations[i].market, name = Config.Locations[i].name})
    function MarketPoint:nearby()
        DrawMarker(29,self.coords.x, self.coords.y, self.coords.z, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.75, 31, 94, 255, 155, 0, 0, 2, 1, 0, 0, 0);
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            OpenMarket(self.id ,self.market)
            name = self.name
            market = self.market
        end
    end
end

function OpenMarket(id ,market)
    if market == 'black' then
        TriggerServerEvent('wam:soldOrNot')
    end
end

RegisterNetEvent('wam:blackMain', function()
    TriggerEvent('nh-context:createMenu', {
        {
            header = "BlackMarket",
        },
        {
            header = "Your Warehouse",
            context = "Open your Warehouse Menu.",
            subMenu = true,
            server = true,
            event = 'wam:hasWarehouse'
        },
        {
            header = "Collect your Money",
            context = "All the money received from Sales",
            event = 'wam:collectMoney',
            disabled = true
        },
        {
            header = "Browse the Market",
            context = "Look for Items you might want to buy.",
            server = true,
            event = 'wam:browseMarket'
        }
    })
end)

RegisterNetEvent('wam:blackMainC', function()
    TriggerEvent('nh-context:createMenu', {
        {
            header = "BlackMarket",
        },
        {
            header = "Your Warehouse",
            context = "Open your Warehouse Menu.",
            subMenu = true,
            server = true,
            event = 'wam:hasWarehouse'
        },
        {
            header = "Collect your Money",
            context = "All the money received from Sales",
            server = true,
            event = 'wam:collectMoney'
        },
        {
            header = "Browse the Market",
            context = "Look for Items you might want to buy.",
            server = true,
            event = 'wam:browseMarket'
        }
    })
end)

RegisterNetEvent('wam:bMarket', function(desc, price, s_id, id)
    local n = 0
    TriggerEvent('nh-context:createMenu', {
        {
            header = "Go Back",
            context = "Return to the Main Menu",
            subMenu = true,
            event = 'wam:blackMain'
        },
        {
            header = "Warehouse #" .. n+1,
            context = desc,
            footer = price .. '€',
            event = 'wam:areYouSure',
            args = {
                s_id, price, id
            }
        }
    })
end)

RegisterNetEvent('wam:areYouSure', function(s_id, price, id)
    TriggerEvent('nh-context:createMenu', {
        {
            header = "Are you sure you want to buy this Lot?",
            disabled = true
        },
        {
            header = "Yes",
            server = true,
            event = 'wam:buyWarehouse',
            args = {
                s_id, price, id
            }
        },
        {
            header = "No",
            server = true,
            event = 'wam:browseMarket'
        }
    })
end)

RegisterNetEvent('wam:buyWarehouse', function()
    local marketType = ''
    if market == 'black' then
        marketType = ' - Blackmarket'
        local w = {
            label = name .. marketType,
            slots = Config.Slots,
            weight = Config.Weight
        }
        TriggerServerEvent('wam:checkMoney', w.label, w.slots, w.weight)
    elseif market == 'market' then
        marketType = ' - Marketplace'
    elseif market == 'vehicle' then
        marketType = ' - Vehicle Market'
    end
end)

RegisterNetEvent('wam:openWarehouseS', function(stash_id)
    exports.ox_inventory:openInventory('stash', {id=stash_id})
end)

RegisterNetEvent('wam:warehouseOptionsB', function()
    TriggerEvent('nh-context:createMenu', {
        {
            header = "Buy a Warehouse",
            context = "Buy your Warehouse",
            event = 'wam:buyWarehouse'
        },
        {
            header = "Open your Warehouse",
            context = "Deposit or Withdraw items before you sell",
            disabled = true
        },
        {
            header = "Put your Package for sale",
            context = "Your Warehouse's items will be put for sale",
            disabled = true
        },
        {
            header = "Go Back",
            context = "Return to the Main Menu",
            subMenu = true,
            event = 'wam:blackMain'
        }
    })
end)

RegisterNetEvent('wam:warehouseOptionsS', function(s_id)
    TriggerEvent('nh-context:createMenu', {
        {
            header = "Buy a Warehouse",
            context = "Buy your own Warehouse",
            disabled = true
        },
        {
            header = "Open your Warehouse",
            context = "Deposit or Withdraw items before you sell",
            event = 'wam:openWarehouseS',
            args = {
                s_id
            }
        },
        {
            header = "Put your Package for sale",
            context = "Your Warehouse's items will be put for sale",
            event = 'wam:warehousePriceDesc'
        },
        {
            header = "Go Back",
            context = "Return to the Main Menu",
            subMenu = true,
            event = 'wam:blackMain'
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