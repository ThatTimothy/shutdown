-- In a real example, this value would be hardcoded.
-- However, with testing games that might differ, we need a consistent way of finding the Migration place.

local AssetService = game:GetService("AssetService")

local places = {}

local pages = AssetService:GetGamePlacesAsync()

while true do
	for _, place in pairs(pages:GetCurrentPage()) do
		table.insert(places, place)
	end
	if pages.IsFinished then
		-- we reached the last page of results
		break
	end
	pages:AdvanceToNextPageAsync()
end

for _, place in places do
	if string.find(string.lower(place.Name), "migration") then
		return place.PlaceId
	end
end

return error("Expected to find a migration place with migration in the name (for testing purposes)")
