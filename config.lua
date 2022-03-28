Config = {}
Config.Locale = 'en'

Config.Locations = {
	{type = 'black' , pos = vector3(462.5275,-770.6901,27.34216)},
	{type = 'black' , pos = vector3(1514.242,3784.352,34.45276)}
}

-----------------------------------------------------------------------------------------------------------------
Locales = {}

function _(str, ...) -- Translate string

	if Locales[Config.Locale] ~= nil then

		if Locales[Config.Locale][str] ~= nil then
			return string.format(Locales[Config.Locale][str], ...)
		else
			return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.Locale .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end