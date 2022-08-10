local fileRequire = require -- Avoid linting
local ENVIRONMENTS = fileRequire("ENVIRONMENTS")

local LINE = string.rep("=", 30)

print(LINE)
print("Building all environments...")
print(LINE)

local count = 0

for _name, env in pairs(ENVIRONMENTS) do
	os.execute(string.format('rojo build %s -o "%s"', env.ProjectPath, env.OutputPath))
	count = count + 1
end

print(LINE)
print(string.format("Built %i/%i environments.", count, count))
print(LINE)
