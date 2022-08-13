local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shutdown = require(ReplicatedStorage.Packages.Shutdown)

-- In a real example, you'd likely just hardcode this value.
-- To allow other people to contirbute, we just find a place with "Migration" in its name.
local MIGRATION_PLACE_ID = require(script.Parent.GetMigrationPlace)

Shutdown.Init({
	MigrationPlaceId = MIGRATION_PLACE_ID,
	Debug = true,
	-- HandleTeleport = function(players, destinationPlaceID, reservedServerAccessCode)
	-- 	-- Code to handle teleport
	-- end
})
