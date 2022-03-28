Citizen.CreateThread(function()
    for i = 1, #Config.Locations, 1 do
        local BlackMarketPoint = lib.points.new(Config.Locations[i].pos, 7, { type = Config.Locations[i].type})
    end
    

end)

function BlackMarketPoint:nearby()
    DrawMarker(29,self.coords.x, self.coords.y, self.coords.z, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.75, 31, 94, 255, 155, 0, 0, 2, 1, 0, 0, 0);
    if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
        OpenMarket(self.type)
    end
end

function OpenMarket(type)
    print('marketOpen : '..type)
end