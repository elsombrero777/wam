ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.GetPlayerData()
end)


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
        if name == 'SandyShores' then
            TriggerEvent('wam:testMenu')
                





        elseif name == 'Los Santos' then






        end
    end
end

RegisterNetEvent('wam:testMenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "BlackMarket",
            txt = ""
        },
        {
            id = 2,
            header = "Buy your Warehouse",
            txt = "Get a space to store your sellables.",
            params = {
                event = 'wam:buyWarehouse'
            }
        }
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