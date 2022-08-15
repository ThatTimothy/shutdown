local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shutdown = require(ReplicatedStorage.ServerPackages.Shutdown)

-- In a real example, you'd likely just hardcode this value.
-- To allow other people to contirbute, we just find a place with "Migration" in its name.
local MIGRATION_PLACE_ID = require(ReplicatedStorage.ServerPackages.GetMigrationPlace)

Shutdown.Init({
	-- Set the destination players will be teleported to when the server closes
	Destination = MIGRATION_PLACE_ID,
	-- Enable debugging (optional)
	Debug = true,
})
