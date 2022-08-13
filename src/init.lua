local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Shutdown = {}

local Output = require(script.Output)

local ALREADY_INITIALIZED = "Shutdown.Init may only be called once"
local INVALID_ARGUMENTS = "Invalid arguments, expected Shutdown.Init(options) "

local function DEFAULT_HANDLE_TELEPORT(players, destinationPlaceID, reservedServerAccessCode)
	local options = Instance.new("TeleportOptions")

	if reservedServerAccessCode then
		options.ReservedServerAccessCode = reservedServerAccessCode
	end

	return TeleportService:TeleportAsync(destinationPlaceID, players, options)
end

local function DEFAULT_DETERMINE_DESTINATION(players)
	local joinData = players[1]:GetJoinData()

	return joinData.SourcePlaceId
end

local DEFAULT_OPTIONS = {
	Debug = false,
	DetermineDestination = DEFAULT_DETERMINE_DESTINATION,
	HandleTeleport = DEFAULT_HANDLE_TELEPORT,
	IsMigrationPlace = false,
	MigrationPlaceId = false,
	WaitBeforeReturn = 5,
}

local initialized = false

local function tryForever(delay, dropoff, ...)
	local args = table.pack(pcall(...))

	if not args[1] then
		task.wait(delay)
		return tryForever(delay + dropoff, dropoff, ...)
	end

	return select(2, table.unpack(args))
end

function Shutdown.Init(options)
	if initialized then
		error(ALREADY_INITIALIZED)
	else
		initialized = true
	end

	if not options or typeof(options) ~= "table" then
		error(INVALID_ARGUMENTS)
	end

	for prop, value in DEFAULT_OPTIONS do
		if not options[prop] then
			options[prop] = value
		end
	end

	Output.SetDebug(options.Debug)

	Output.Debug("Started with options:", options)

	if RunService:IsStudio() then
		Output.Debug("Ended: not running in studio")
		return
	end

	local isMigrationPlace = options.IsMigrationPlace

	if isMigrationPlace then
		Output.Debug("Is migration place, waiting for players...")

		if #Players:GetPlayers() <= 0 then
			Players.PlayerAdded:Wait()
		end

		Output.Debug("Players found, waiting for additional players to arrive...")

		task.wait(options.WaitBeforeReturn)

		local players = Players:GetPlayers()
		local playerGroups = { {} }

		for _, player in players do
			local group = playerGroups[#playerGroups]

			table.insert(group, player)
		end

		local function handleGroup(group)
			local destination = options.DetermineDestination(group)
			task.spawn(options.HandleTeleport, group, destination)
		end

		for _, group in playerGroups do
			handleGroup(group)
		end

		Players.PlayerAdded:Connect(function(player)
			handleGroup({ player })
		end)
	else
		local reservedServerAccessCode =
			tryForever(5, 5, TeleportService.ReserveServer, TeleportService, options.MigrationPlaceId)

		game:BindToClose(function()
			while true do
				local players = Players:GetPlayers()

				if #players <= 0 then
					Output.Debug("No players left, ending...")
					break
				end

				for _, player in players do
					task.spawn(options.HandleTeleport, { player }, options.MigrationPlaceId, reservedServerAccessCode)
				end

				task.wait(1)
			end
		end)
	end
end

return Shutdown
