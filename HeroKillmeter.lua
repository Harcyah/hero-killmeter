
local frame = CreateFrame('Frame');
frame:RegisterEvent('ADDON_LOADED');
frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');

local function GetGuid(guid)

	local tokens = {}
	for match in string.gmatch(guid, '[^-]+') do
		table.insert(tokens, match)
	end

	local result = {}
	result.type = tokens[1]
	result.server = tokens[3]
	result.instance = tokens[4]
	result.zone = tokens[5]
	result.id = tokens[6]

	return result;
end

frame:SetScript('OnEvent', function(self, event, ...)
	local arg = {...}

	if (event == 'ADDON_LOADED' and arg[1] == 'HeroKillmeter') then
		if (HeroKillmeterDB == nil) then
			HeroKillmeterDB = {}
		end
	end

	if (event == 'COMBAT_LOG_EVENT_UNFILTERED') then
		local timestamp, subEvent, hideCaster, s_guid, s_name, s_flags, s_raidflags, d_guid, d_name, d_flags, d_raidflags = CombatLogGetCurrentEventInfo()
		if subEvent == 'PARTY_KILL' then

			local guid = GetGuid(d_guid)

			if (guid.type ~= 'Creature') then
				return;
			end

			local id = guid.id;

			if (HeroKillmeterDB[id] == nil) then
				HeroKillmeterDB[id] = {}
				HeroKillmeterDB[id].first = timestamp
				HeroKillmeterDB[id].last = timestamp
				HeroKillmeterDB[id].count = 1
			else
				HeroKillmeterDB[id].last = timestamp
				HeroKillmeterDB[id].count = HeroKillmeterDB[id].count + 1
			end

			DEFAULT_CHAT_FRAME:AddMessage('[' .. d_name .. '] => ' .. HeroKillmeterDB[id].count .. ' kills', 0.976, 0.501, 0.062);

		end
	end

end)
