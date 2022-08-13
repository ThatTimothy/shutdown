local args = table.pack(...)

if #args ~= 3 then
	error(
		"Invalid number of arguments! Format should be: remodel run upload-example [example] [mainPlaceId] [migrationPlaceId]"
	)
end

local example = args[1]
local mainPlaceId = tonumber(args[2])
local migrationPlaceId = tonumber(args[3])

os.execute("remodel run build")

local mainPlacePath = string.format("examples/%s/main.rbxl", example)
local migrationPlacePath = string.format("examples/%s/migration.rbxl", example)

print(string.format("Reading place file at `%s`", mainPlacePath))
local mainPlace = remodel.readPlaceFile(mainPlacePath)

print(string.format("Reading place file at `%s`", migrationPlacePath))
local migrationPlace = remodel.readPlaceFile(migrationPlacePath)

print(string.format("Publishing `%s` to `roblox.com/games/%i`", mainPlacePath, mainPlaceId))
remodel.writeExistingPlaceAsset(mainPlace, mainPlaceId)

print(string.format("Publishing `%s` to `roblox.com/games/%i`", migrationPlacePath, migrationPlaceId))
remodel.writeExistingPlaceAsset(migrationPlace, migrationPlaceId)
