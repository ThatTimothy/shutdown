local JOBS = {
	-- Model
	{
		OutputPath = "shutdown.rbxm",
		ProjectPath = "default.project.json",
	},
}

-- Examples
local EXAMPLES = { "basic" }

for _, example in pairs(EXAMPLES) do
	table.insert(JOBS, {
		OutputPath = string.format("examples/%s/main.rbxl", example),
		ProjectPath = string.format("examples/%s/main/default.project.json", example),
	})
	table.insert(JOBS, {
		OutputPath = string.format("examples/%s/migration.rbxl", example),
		ProjectPath = string.format("examples/%s/migration/default.project.json", example),
	})
end

local LINE = string.rep("=", 30)

print(LINE)
print("Starting jobs...")
print(LINE)

local count = 0

for _name, job in pairs(JOBS) do
	os.execute(string.format('rojo build %s -o "%s"', job.ProjectPath, job.OutputPath))
	count = count + 1
end

print(LINE)
print(string.format("Completed %i/%i jobs.", count, count))
print(LINE)
