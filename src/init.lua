local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Shutdown = {}

local Output = require(script.Output)

local MAX_PLAYERS_PER_TELEPORT = 50
local ALREADY_INITIALIZED = "Shutdown.Init may only be called once"
local INVALID_ARGUMENTS = "Invalid arguments, expected Shutdown.Init(options)"
local NO_DESTINATION_PROVIDED = "Destination was not provided, required to determine where to send players"
local DESTINATION_SHOULD_BE_NUMBER_OR_METHOD = "Destination provided should be a number or method"
local DESTINATION_SHOULD_BE_CONSTANT_WHEN_NOT_MIGRATION_PLACE =
	"Destination should be a constant number representing the migration place to teleport to when not a miration place"

local DEFAULT_OPTIONS = {
	WaitBeforeReturn = 5,
}

type Options = {
	Debug: boolean?,

	BeforeTeleport: ((players: Array<Player>) -> ())?,
	Destination: number | (players: Array<Player>) -> { PlaceId: number, ReservedServerAccessCode: number? },
	CreateTeleportData: ((players: Array<Player>) -> (any))?,

	IsMigrationPlace: boolean?,

	WaitBeforeReturn: number?,
}

local initialized = false

local function teleport(players, destinationPlaceId, teleportData, reservedServerAccessCode)
	local options = Instance.new("TeleportOptions")

	if reservedServerAccessCode then
		options.ReservedServerAccessCode = reservedServerAccessCode
	end

	if teleportData then
		options:SetTeleportData(teleportData)
	end

	return TeleportService:TeleportAsync(destinationPlaceId, players, options)
end

local function tryForever(delay, dropoff, ...)
	local args = table.pack(pcall(...))

	if not args[1] then
		task.wait(delay)
		return tryForever(delay + dropoff, dropoff, ...)
	end

	return select(2, table.unpack(args))
end

function Shutdown.Init(options: Options)
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

	if not options.Destination then
		error(NO_DESTINATION_PROVIDED)
	end

	if typeof(options.Destination) ~= "number" and typeof(options.Destination) ~= "function" then
		error(DESTINATION_SHOULD_BE_NUMBER_OR_METHOD)
	end

	table.freeze(options)

	Output.SetDebug(options.Debug)

	Output.Debug("Started with options:", Output.PrettyTable(options))

	if RunService:IsStudio() then
		Output.Debug("Ended: not running in studio")
		return
	end

	local function handleTeleport(players, reservedServerAccessCode)
		if options.BeforeTeleport then
			options.BeforeTeleport(players)
		end

		local destination = options.Destination

		if typeof(destination) == "function" then
			destination = destination(players)
		end

		local teleportData

		if options.CreateTeleportData then
			teleportData = options.CreateTeleportData(players, destination)
		end

		task.spawn(teleport, players, destination, teleportData, reservedServerAccessCode)
	end

	local isMigrationPlace = options.IsMigrationPlace

	if isMigrationPlace then
		Output.Debug("Is migration place, waiting for players...")

		if #Players:GetPlayers() <= 0 then
			Players.PlayerAdded:Wait()
		end

		Output.Debug("Players found, waiting for additional players to arrive...")

		task.wait(options.WaitBeforeReturn)

		local function handleGroup(group)
			local subGroups = { {} }

			for _, player in group do
				local subGroup = subGroups[#subGroups]

				table.insert(subGroup, player)

				if #subGroup >= MAX_PLAYERS_PER_TELEPORT then
					table.insert(subGroups, {})
				end
			end

			Output.Debug(string.format("Teleporting group of %s players as %s subgroups", #group, #subGroups))

			for _, subGroup in subGroups do
				task.spawn(handleTeleport, subGroup)
			end
		end

		Players.PlayerAdded:Connect(function(player)
			handleGroup({ player })
		end)

		while true do
			local players = Players:GetPlayers()

			handleGroup(players)

			task.wait(1)
		end
	else
		if typeof(options.Destination) ~= "number" then
			error(DESTINATION_SHOULD_BE_CONSTANT_WHEN_NOT_MIGRATION_PLACE)
		end

		Output.Debug("Reserving server...")
		local reservedServerAccessCode =
			tryForever(5, 5, TeleportService.ReserveServer, TeleportService, options.Destination)
		Output.Debug("Reserved server")

		game:BindToClose(function()
			Output.Debug("Server closing...")

			while true do
				local players = Players:GetPlayers()

				if #players <= 0 then
					Output.Debug("No players left, ending...")
					break
				end

				Output.Debug("Teleporting all players...")

				for _, player in players do
					task.spawn(handleTeleport, { player }, reservedServerAccessCode)
				end

				task.wait(1)
			end
		end)
	end
end

return Shutdown
