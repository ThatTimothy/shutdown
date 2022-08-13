local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shutdown = require(ReplicatedStorage.Packages.Shutdown)

Shutdown.Init({
	IsMigrationPlace = true,
	Debug = true,
	-- WaitBeforeReturn = 5,
	-- DetermineDestination = function(players)
	-- 	return 123456
	-- end,
	-- HandleTeleport = function(players, destinationPlaceID, reservedServerAccessCode)
	-- 	-- Code to handle teleport
	-- end
})
