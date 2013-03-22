
RCDB = { }

local function onDragStart(self) self:StartMoving() end

local function onDragStop(self)
	self:StopMovingOrSizing()
	RCDB.x = self:GetLeft()
	RCDB.y = self:GetTop()
end

--------------------------------

local locked = true
local RareIDs = {
	50358, -- Haywire Sunreaver Construct
	69664, -- Mumta
	69996, -- Ku'lai Skyclaw
	69997, -- Progenitus
	69998, -- Goda
	69999, -- God-Hulk Ramuk
	70000, -- Al'tabim the All-Seeing
	70001, -- Backbreaker Uru
	70002, -- Lu-Ban
	70003, -- Molthor
	70530, -- Ra'sha
	--69384  -- Luminescent Crawler - FOR TESTING ONLY
}
local RareNamesLocalized = {};
RareNamesLocalized['enUS'] = {}
RareNamesLocalized['enUS'][50358] = "Haywire Sunreaver Construct"
RareNamesLocalized['enUS'][69664] = "Mumta"
RareNamesLocalized['enUS'][69996] = "Ku'lai the Skyclaw"
RareNamesLocalized['enUS'][69997] = "Progenitus"
RareNamesLocalized['enUS'][69998] = "Goda"
RareNamesLocalized['enUS'][69999] = "God-Hulk Ramuk"
RareNamesLocalized['enUS'][70000] = "Al'tabim the All-Seeing"
RareNamesLocalized['enUS'][70001] = "Backbreaker Uru"
RareNamesLocalized['enUS'][70002] = "Lu-Ban"
RareNamesLocalized['enUS'][70003] = "Molthor"
RareNamesLocalized['enUS'][70530] = "Ra'sha"
--RareNamesLocalized['enUS'][69384] = "Luminescent Crawler"
RareNamesLocalized['deDE'] = {}
RareNamesLocalized['deDE'][50358] = "Konstrukt der Sonnenhäscher"
RareNamesLocalized['deDE'][69664] = "Mumta"
RareNamesLocalized['deDE'][69996] = "Ku'lai die Himmelsklaue"
RareNamesLocalized['deDE'][69997] = "Progenitus"
RareNamesLocalized['deDE'][69998] = "Goda"
RareNamesLocalized['deDE'][69999] = "Gottkoloss Ramuk"
RareNamesLocalized['deDE'][70000] = "Al'tabim der Allsehende"
RareNamesLocalized['deDE'][70001] = "Rückenbrecher Uru"
RareNamesLocalized['deDE'][70002] = "Lu-Ban"
RareNamesLocalized['deDE'][70003] = "Molthor"
RareNamesLocalized['deDE'][70530] = "Ra'sha"
RareNamesLocalized['esES'] = {}
RareNamesLocalized['esES'][50358] = "Atracasol descontrolado"
RareNamesLocalized['esES'][69664] = "Mumta"
RareNamesLocalized['esES'][69996] = "Ku'lai el Garracielo"
RareNamesLocalized['esES'][69997] = "Progenitus"
RareNamesLocalized['esES'][69998] = "Goda"
RareNamesLocalized['esES'][69999] = "Dios mole Ramuk"
RareNamesLocalized['esES'][70000] = "Al'tabim"
RareNamesLocalized['esES'][70001] = "Backbreaker Uru" -- need translation
RareNamesLocalized['esES'][70002] = "Lu-Ban" -- need translation
RareNamesLocalized['esES'][70003] = "Molthor" -- need translation
RareNamesLocalized['esES'][70530] = "Ra'sha" -- need translation
RareNamesLocalized['frFR'] = {}
RareNamesLocalized['frFR'][50358] = "Saccage-soleil détraqué"
RareNamesLocalized['frFR'][69664] = "Mumta"
RareNamesLocalized['frFR'][69996] = "Ku’lai, la Griffe du ciel"
RareNamesLocalized['frFR'][69997] = "Progénitus"
RareNamesLocalized['frFR'][69998] = "Goda"
RareNamesLocalized['frFR'][69999] = "Dieu-mastodonte Ramuk"
RareNamesLocalized['frFR'][70000] = "Al’tabim Qui-Voit-Tout"
RareNamesLocalized['frFR'][70001] = "Backbreaker Uru" -- need translation
RareNamesLocalized['frFR'][70002] = "Lu-Ban" -- need translation
RareNamesLocalized['frFR'][70003] = "Molthor" -- need translation
RareNamesLocalized['frFR'][70530] = "Ra'sha" -- need translation


local RareSeen = {}
local RareKilled = {}
local RareAlive = {}
local LastSent = {}
local RareAv = {}

local SoundPlayed = 0
local VersionNotify = false

local txt = ""

local needStatus = false

--------------------------------
local RC = CreateFrame("Frame", "RC", UIParent)
RC.version = "5.2.0-6"

RC:SetFrameStrata("BACKGROUND")
RC:SetWidth(415) 
RC:SetHeight(table.getn(RareIDs)*15) 
RC:SetPoint("CENTER",0,0)

RC.texture = RC:CreateTexture(nil,"BACKGROUND")
RC.texture:SetTexture(0,0,0,0.4)
RC.texture:SetAllPoints(RC)


RC.content = RC:CreateFontString("content", nil, "GameFontNormal")
RC.content:SetTextColor(1,1,1)
RC.content:SetPoint("LEFT", "RC")
RC.content:SetJustifyH("RIGHT")
RC.content:SetSpacing(2)

function RC:OnEvent(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		self:CombatLog(...);
	end
	if event == "PLAYER_TARGET_CHANGED" then
		self:Target(...)
	end
	if event == "CHAT_MSG_CHANNEL" then
		self:Chat(...)
	end
	if event == "ADDON_LOADED" then
		self:OnLoad(...)
	end
	if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		self:ShowOrHide(...)
	end
	if event == "CHAT_MSG_ADDON" then
		self:AddonMsg(...)
	end
	if event == "CHANNEL_ROSTER_UPDATE" then
		self:ChanRosterUpdate(...)
	end
end

function RC:OnLoad(...)
	if select(1, ...) == "RareCoordinator" then
		print("RareCoordinator loaded - type /rc for options");
		if RCDB.x == nil or RCDB.y == nil then
			self:SetPoint("CENTER",0,0)
		else
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", RCDB.x, RCDB.y)
		end
	end
end


function RC:ShowOrHide(...)
	local zone = GetZoneText()
	if zone == "Isle of Thunder" or zone == "Insel des Donners" or zone == "Isla del Trueno" or zone == "Île du Tonnerre" or zone == "Ilha do Trovão" or zone == "Остров Грома" then
		RareAlive = {}
		self:Show()
		self:SetScript("OnUpdate", RC.join)
	else
		self:Hide()
		LeaveChannelByName("RCELVA")
	end
end


function RC:Chat(message, sender, language, channelString, target, flags, unknown, channelNumber, channelName, unknown, counter, guid)
	if channelName == "RCELVA" then
		if string.find(message, "[RCELVA]") then
			count = 0
			for match in string.gmatch(message, "_") do count = count + 1 end
			if count == 4 then
				message = string.sub(message, 9)
				local eventVersion,eventRareID,eventType,eventTime
				
				firstSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventVersion = string.sub(message, 0, firstSeperator-1)
					message = string.sub(message, firstSeperator+1)
				end
				
				secondSeperator,_ = string.find(message, "_")
				if secondSeperator ~= nil then
					eventRareID = tonumber(string.sub(message, 0, secondSeperator-1))
					message = string.sub(message, secondSeperator+1)
				end
				
				thirdSeperator,_ = string.find(message, "_")
				if thirdSeperator ~= nil then
					eventType = string.sub(message, 0, thirdSeperator-1)
					message = string.sub(message, thirdSeperator+1)
				end
				
				fourthSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventTime = string.sub(message, 0, fourthSeperator-1)
					message = string.sub(message, fourthSeperator+1)
				end
				
				for _,v in pairs(RareIDs) do
					if v == eventRareID and eventType ~= nil and eventTime ~= nil then
						if eventType == "alive" then
							RareAlive[v] = eventTime
						elseif eventType == "dead" then
							RareAlive[v] = nil
						elseif eventType == "killed" then
							RareKilled[v] = eventTime
						elseif eventType == "seen" then
							RareSeen[v] = eventTime
						end
						self:updateText()
						self:CompareVersion(eventVersion)
						break
					end
				end
			end
		end
	end
end

function RC:AddonMsg(prefix, message, channel, sender)
	if prefix == "RCELVA" then
		if channel == "WHISPER" and message == "GetStatus" then
			for id,timestamp in pairs(RareSeen) do
				SendAddonMessage("RCELVA", self.version.."_"..id.."_seen_"..timestamp.."_", "WHISPER", sender)
			end
			for id,timestamp in pairs(RareKilled) do
				SendAddonMessage("RCELVA", self.version.."_"..id.."_killed_"..timestamp.."_", "WHISPER", sender)
			end
			for id,timestamp in pairs(RareAlive) do
				SendAddonMessage("RCELVA", self.version.."_"..id.."_alive_"..timestamp.."_", "WHISPER", sender)
			end
		end
		if channel == "WHISPER" then
			count = 0
			for match in string.gmatch(message, "_") do count = count + 1 end
			if count == 4 then
				firstSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventVersion = string.sub(message, 0, firstSeperator-1)
					message = string.sub(message, firstSeperator+1)
				end
				
				secondSeperator,_ = string.find(message, "_")
				if secondSeperator ~= nil then
					eventRareID = tonumber(string.sub(message, 0, secondSeperator-1))
					message = string.sub(message, secondSeperator+1)
				end
				
				thirdSeperator,_ = string.find(message, "_")
				if thirdSeperator ~= nil then
					eventType = string.sub(message, 0, thirdSeperator-1)
					message = string.sub(message, thirdSeperator+1)
				end
				
				fourthSeperator,_ = string.find(message, "_")
				if firstSeperator ~= nil then
					eventTime = string.sub(message, 0, fourthSeperator-1)
					message = string.sub(message, fourthSeperator+1)
				end
				
				for _,v in pairs(RareIDs) do
					if v == eventRareID and eventType ~= nil and eventTime ~= nil then
						if eventType == "alive" then
							RareAlive[v] = eventTime
						elseif eventType == "dead" then
							RareAlive[v] = nil
						elseif eventType == "killed" then
							RareKilled[v] = eventTime
						elseif eventType == "seen" then
							RareSeen[v] = eventTime
						end
						self:updateText()
						self:CompareVersion(eventVersion)
						break
					end
				end
				needStatus = false
			end
		end
	end
end

function RC:CompareVersion(v)
	local i=0
	local newVersion=false
	local expan1, cpatch1, mpatch1, revision1, expan2, cpatch2, mpatch2, revision2
	for n in string.gmatch(self.version, "%d+") do
		if     i == 0 then expan1 = n
		elseif i == 1 then cpatch1 = n
		elseif i == 2 then mpatch1 = n
		elseif i == 3 then revision1 = n
		end
		i = i + 1
	end
	i=0
	for n in string.gmatch(v, "%d+") do
		if     i == 0 then expan2 = n
		elseif i == 1 then cpatch2 = n
		elseif i == 2 then mpatch2 = n
		elseif i == 3 then revision2 = n
		end
		i = i + 1
	end
	if expan2 > expan1 then
		newVersion = true
	elseif cpatch2 > cpatch1 then
		newVersion = true
	elseif mpatch2 > mpatch1 then
		newVersion = true
	elseif revision2 > revision1 then
		newVersion = true
	end
	if newVersion and VersionNotify == false then
		print("RareCoordinator - New Version available: |cff00ff00"..v.."|r (You are using |cffff0000"..RC.version.."|r)")
		VersionNotify = true
	end
end

--3/8 18:03:12.537 UNIT_DIED,0x0000000000000000,nil,        0x80000000,  0x80000000,0xF13108BC0004C67E,"Creeping Moor Beast",0x10a48,0x0
function RC:CombatLog(timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if event == "UNIT_DIED" then
		for _,v in pairs(RareIDs) do
			local npcID = tonumber(destGUID:sub(6, 10), 16)
			if v == npcID then
					msg = time() .. " Rare Mob killed: " .. v
					RareKilled[v] = time()
					--self:DebugMsg(msg)
					SendChatMessage("[RCELVA]"..self.version.."_"..npcID.."_killed_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					RareAlive[v] = nil
					SendChatMessage("[RCELVA]"..self.version.."_"..npcID.."_dead_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					self:updateText()
				break
			end
		end
	end
end

function RC:ChanRosterUpdate(id)
	if needStatus == true then
		--print ("roster update: ".. id)
		--print (GetChannelDisplayInfo(id))
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(id)
		if name == "RCELVA" then
			self:SetScript("OnUpdate", nil)
			--print("Got displayId of "..name..": "..id)
			
			local count = select(5, GetChannelDisplayInfo(id))
			--print("count"..count)
			for i=1,count do
				local name = select(1, GetChannelRosterInfo(id, i))
				local owner = select(2, GetChannelRosterInfo(id, i))
				if owner then
					--print(name .." is the owner right now")
					SendAddonMessage("RCELVA", "GetStatus", "WHISPER", name)
					self:updateText()
				end
			end
		end
	end
end

function RC:getChanID(...)
	local gotID = false
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		if name == "RCELVA" then
			gotID = true
			return id
		end
	end
	if gotID == false then
		return false
	end
end

function RC:getChanDisplayID()
	local channels = GetNumDisplayChannels()
	local i = 1 
	
	while i <= channels do
		SetSelectedDisplayChannel(i)
		local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = GetChannelDisplayInfo(i)
		if name == "RCELVA" then
			--print("Got displayId of "..name..": "..i)
			return i
		end
		i = i + 1
	end
end

function RC:getChanOwner()
	local id = self:getChanDisplayID()
	if id ~= nil then
		SetSelectedDisplayChannel(id)
		local count = select(5, GetChannelDisplayInfo(id))
		--print("count"..count)
		for i=1,count do
			local name = select(1, GetChannelRosterInfo(id, i))
			local owner = select(2, GetChannelRosterInfo(id, i))
			if owner then
				return name
			end
		end
	end
end

function RC:Target(...)
--/run print(("NPC ID of %s: %d"):format(UnitName("target"), tonumber(UnitGUID("target"):sub(6, 10), 16)))
	if UnitGUID("target") ~= nil then
		id = tonumber(UnitGUID("target"):sub(6, 10), 16)
		for _,v in pairs(RareIDs) do
			if v == id then
					msg = time() .. " Rare Mob targeted: " .. id
					if UnitHealth("target") > 0 then
						RareAlive[v] = time()
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_alive_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					else
						RareAlive[v] = nil
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_dead_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					end
					RareSeen[v] = time()
					if LastSent[v] == nil then
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_seen_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
						LastSent[v] = time()
					else
						if (LastSent[v] + 30) < time() then
							SendChatMessage("[RCELVA]"..self.version.."_"..id.."_seen_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
							LastSent[v] = time()
						end
					end
					--self:DebugMsg(msg)
					self:updateText()
				break
			end
		end
	end
end

function RC:updateText()
	local i
	RareAv = {}
	for i=1,GetAchievementNumCriteria(8103) do
		_, _, completed, _, _, _, _, assetID, _, _ = GetAchievementCriteriaInfo(8103,i)
		if completed then
			RareAv[assetID] = "|cff00ff00"
		else
			RareAv[assetID] = "|cffff0000"
		end		
	end
	txt = ""
	for _,id in pairs(RareIDs) do
		gotATime = false
		gotAKill = false
		alive = false
		timeSeen = 0;
		timeKilled = 0;
		for timedID,timestamp in pairs(RareSeen) do
			if id == timedID then
				timeSeen = timestamp
				gotATime = true
			end
		end
		for timedID,timestamp in pairs(RareKilled) do
			if id == timedID then
				timeKilled = timestamp
				gotAKill = true
			end
		end
		for timedID,timestamp in pairs(RareAlive) do
			if id == timedID then
				alive = true
			end
		end
		if RareAv[id] ~= nil then
			avtxt = RareAv[id].."av|r"
		else
			avtxt = "   "
		end
		if alive then
			if time() > SoundPlayed + 60 then
				PlaySoundFile("sound\\CREATURE\\MANDOKIR\\VO_ZG2_MANDOKIR_LEVELUP_EVENT_01.ogg", "MASTER")
				SoundPlayed = time()
			end
			txt = txt .. " " .. self:getLocalRareName(id) .. " - "..avtxt.." -|cff00ff00            ~~~ is ALIVE ~~~             |r\n"
		elseif gotATime or gotAKill then
			if gotAKill and gotATime then
				txt = txt .. " " .. self:getLocalRareName(id) .. " - "..avtxt.." - seen: ".. date("%X", timeSeen) .." - killed: ".. date("%X", timeKilled) .."  \n"
			end
			if gotAKill and not gotATime then
				txt = txt .. " " .. self:getLocalRareName(id) .. " - "..avtxt.." - seen: not seen - killed: ".. date("%X", timeKilled) .."  \n"
			end
			if not gotAKill and gotATime then
				txt = txt .. " " .. self:getLocalRareName(id) .. " - "..avtxt.." - seen: ".. date("%X", timeSeen) .." - killed: not killed\n"
			end
		else
			txt = txt .. " " .. self:getLocalRareName(id) .. " - "..avtxt.." - seen: not seen - killed: not killed\n"
		end
	end
	self.content:SetText(txt)
end

local waittime = 0
local chanchecked = 0
function RC.join(self, elapsed)
  waittime = waittime + elapsed
  if waittime > 1 then
	local id = self:getChanID(GetChannelList())
	if ( id == false ) then 
		--print("no id, joining")
		JoinChannelByName("RCELVA")
		if RegisterAddonMessagePrefix("RCELVA") ~= true then
			print("RareCoordinator: Couldn't register AddonPrefix")
		end
		chanchecked = 0
		needStatus = true
		--print("getting status from" .. owner)
		--SendAddonMessage("RCELVA", "GetStatus", "WHISPER", owner)
	else
		--self:SetScript("OnUpdate", nil)
		local channels = GetNumDisplayChannels()
		if channels > chanchecked then
			SetSelectedDisplayChannel(channels - chanchecked)
			
		end
		chanchecked = chanchecked + 1 

	end	
	waittime = 0
  end
end

function RC:getLocalRareName(id)
	if RareNamesLocalized[GetLocale()] ~= nil then
		if RareNamesLocalized[GetLocale()][id] ~= nil then
			return RareNamesLocalized[GetLocale()][id]
		end
	end
	if RareNamesLocalized['enUS'][id] ~= nil then
		return RareNamesLocalized['enUS'][id]
	else
		return "Unkown Name"
	end
end


function RC:DebugMsg(msg)
	print(msg)
		
end

SLASH_RARECOORDINATOR1 = "/rc"
local function SlashHandler(msg, editbox)
	--print("Usage")
	if locked then
		print("RareCoordinator is now unlocked. - Type /rc to lock it")
		RC:SetMovable(true)
		RC:EnableMouse(true)
		RC:RegisterForDrag("LeftButton")
		RC:SetScript("OnDragStart", onDragStart)
		RC:SetScript("OnDragStop", onDragStop)
		RC:SetScript("OnHide", RC.StopMovingOrSizing)
		RC:Show()
		locked = false
	else
		print("RareCoordinator is now locked. - Type /rc to unlock it")		
		RC:SetMovable(false)
		RC:EnableMouse(false)
		RC:RegisterForDrag()
		RC:SetScript("OnDragStart", nil)
		RC:SetScript("OnDragStop", nil)
		RC:SetScript("OnHide", nil)
		RC:ShowOrHide()
		locked = true
	end
end
SlashCmdList["RARECOORDINATOR"] = SlashHandler;

RC:SetScript("OnEvent", RC.OnEvent)

--ONLY FOR TESTING
--		RC:SetScript("OnUpdate", RC.join)
		
		
RC:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
RC:RegisterEvent("ADDON_LOADED")
RC:RegisterEvent("PLAYER_TARGET_CHANGED")
RC:RegisterEvent("CHAT_MSG_CHANNEL")
RC:RegisterEvent("CHAT_MSG_ADDON")
RC:RegisterEvent("PLAYER_ENTERING_WORLD")
RC:RegisterEvent("ZONE_CHANGED_NEW_AREA")
RC:RegisterEvent("CHANNEL_ROSTER_UPDATE")
RC:updateText()
RC:Show()
