local JOBS = {
	Model = {
		OutputPath = "shutdown.rbxm",
		ProjectPath = "default.project.json",
	},
	TestingMain = {
		OutputPath = "shutdown-test-main.rbxl",
		ProjectPath = "test-main.project.json",
	},
	TestingMigration = {
		OutputPath = "shutdown-test-migration.rbxl",
		ProjectPath = "test-migration.project.json",
	},
}

local LINE = string.rep("=", 30)

print(LINE)
print("Building all environments...")
print(LINE)

local count = 0

for _name, job in pairs(JOBS) do
	os.execute(string.format('rojo build %s -o "%s"', job.ProjectPath, job.OutputPath))
	count = count + 1
end

print(LINE)
print(string.format("Built %i/%i environments.", count, count))
print(LINE)
