local Output = {}

local debugEnabled = false

function pretty(input)
	local inputType = typeof(input)

	if inputType == "string" then
		return string.format('"%s"', input)
	end

	return tostring(input)
end

function Output.PrettyTable(input)
	local output = "{"

	for i, v in input do
		output ..= string.format("\n\t%s = %s,", pretty(i), pretty(v))
	end

	output ..= "\n}"

	return output
end

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
