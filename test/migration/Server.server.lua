local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shutdown = require(ReplicatedStorage.Packages.Shutdown)

Shutdown.Init({
	IsMigrationPlace = true,
	-- DetermineDestination = function(players)
	-- 	return 123456
	-- end,
	-- HandleTeleport = function(players, destinationPlaceID)
	-- 	-- Code to handle teleport
	-- end
})
