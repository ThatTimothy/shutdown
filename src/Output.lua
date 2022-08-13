local Output = {}

local debugEnabled = false

function Output.SetDebug(debugEnabledProvided)
	debugEnabled = debugEnabledProvided
end

function Output.Debug(...)
	if not debugEnabled then
		return
	end

	print("[Shutdown Debug]", ...)
end

return Output
