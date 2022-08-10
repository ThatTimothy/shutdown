-- This file defines the enviroments we can deploy to.

return {
	Production = {
		OutputPath = "shutdown.rbxm",
		ProjectPath = "default.project.json",
	},
	Testing = {
		OutputPath = "shutdown.rbxl",
		ProjectPath = "test.project.json",
	},
}
