local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shutdown = require(ReplicatedStorage.ServerPackages.Shutdown)

Shutdown.Init({
	-- Indicate this is the migration place
	IsMigrationPlace = true,
	-- Teleport back to the place these players came from
	Destination = function(players)
		return players[1]:GetJoinData().SourcePlaceId
	end,
	-- Enable debugging (optional)
	Debug = true,
})
