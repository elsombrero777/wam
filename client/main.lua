local coords = GetEntityCoords(PlayerPedId())
local market = lib.points.new(coords, 7, { inZone = true})


function market:nearby()
    DrawMarker(29, 463.0681, -770.5978, 27.34216, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.75, 31, 94, 255, 155, 0, 0, 2, 1, 0, 0, 0);
end