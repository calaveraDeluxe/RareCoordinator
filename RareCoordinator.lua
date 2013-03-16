
RCDB = { }

local function onDragStart(self) self:StartMoving() end

local function onDragStop(self)
	self:StopMovingOrSizing()
	RCDB.x = self:GetLeft()
	RCDB.y = self:GetTop()
end



--------------------------------

local locked = true

local RareNames = {
	"Haywire Sunreaver Construct",
	"Mumta",
	"Ku'lai the Skyclaw",
	"Progenitus",
	"Goda",
	"God-Hulk Ramuk",
	"Al'tabim the All-Seeing",
	"Backbreaker Uru",
	"Lu-Ban",
	"Molthor"
	--"Elvador",
	--"Luminescent Crawler"
}
local RareSeen = {}
local RareKilled = {}
local RareAlive = {}
local LastSent = {}

local txt = ""

local needStatus = false

--------------------------------
local RC = CreateFrame("Frame", "RC", UIParent)
RC.version = "1"

RC:SetFrameStrata("BACKGROUND")
RC:SetWidth(400) 
RC:SetHeight(table.getn(RareNames)*15) 
RC:SetPoint("CENTER",0,0)

RC.texture = RC:CreateTexture(nil,"BACKGROUND")
RC.texture:SetTexture(0,0,0,0.4)
RC.texture:SetAllPoints(RC)


RC.content = RC:CreateFontString("content", nil, "GameFontNormal")
RC.content:SetTextColor(1,0,0)
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
	if GetZoneText() == "Isle of Thunder" then
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
			message = string.sub(message, 9)
			local eventRareName,eventType,eventTime
			
			firstSeperator,_ = string.find(message, "-")
			if firstSeperator ~= nil then
				eventRareName = string.sub(message, 0, firstSeperator-1)
				message = string.sub(message, firstSeperator+1)
			end
			
			secondSeperator,_ = string.find(message, "-")
			if secondSeperator ~= nil then
				eventType = string.sub(message, 0, secondSeperator-1)
				message = string.sub(message, secondSeperator+1)
			end
			
			thirdSeperator,_ = string.find(message, "-")
			if thirdSeperator ~= nil then
				eventTime = string.sub(message, 0, thirdSeperator-1)
				message = string.sub(message, thirdSeperator+1)
			end
			
			for _,v in pairs(RareNames) do
				if v == eventRareName and eventType ~= nil and eventTime ~= nil then
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
					break
				end
			end
			
		end
	end
end

function RC:AddonMsg(prefix, message, channel, sender)
	if prefix == "RCELVA" then
		
		if channel == "WHISPER" and message == "GetStatus" then
			for name,timestamp in pairs(RareSeen) do
				SendAddonMessage("RCELVA", name.."-seen-"..timestamp.."-", "WHISPER", sender)
			end
			for name,timestamp in pairs(RareKilled) do
				SendAddonMessage("RCELVA", name.."-killed-"..timestamp.."-", "WHISPER", sender)
			end
			for name,timestamp in pairs(RareAlive) do
				SendAddonMessage("RCELVA", name.."-alive-"..timestamp.."-", "WHISPER", sender)
			end
		end
		if channel == "WHISPER" then
			count = 0
			for match in string.gmatch(message, "-") do count = count + 1 end
			if count == 3 then
				local eventRareName,eventType,eventTime
				
				firstSeperator,_ = string.find(message, "-")
				if firstSeperator ~= nil then
					eventRareName = string.sub(message, 0, firstSeperator-1)
					message = string.sub(message, firstSeperator+1)
				end
				
				secondSeperator,_ = string.find(message, "-")
				if secondSeperator ~= nil then
					eventType = string.sub(message, 0, secondSeperator-1)
					message = string.sub(message, secondSeperator+1)
				end
				
				thirdSeperator,_ = string.find(message, "-")
				if thirdSeperator ~= nil then
					eventTime = string.sub(message, 0, thirdSeperator-1)
					message = string.sub(message, thirdSeperator+1)
				end
				
				
				for _,v in pairs(RareNames) do
					if v == eventRareName and eventType ~= nil and eventTime ~= nil then
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
						break
					end
				end
				needStatus = false
			end
		end
	end
end


--3/8 18:03:12.537 UNIT_DIED,0x0000000000000000,nil,        0x80000000,  0x80000000,0xF13108BC0004C67E,"Creeping Moor Beast",0x10a48,0x0
function RC:CombatLog(timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if event == "UNIT_DIED" then
		for _,v in pairs(RareNames) do
			if v == destName then
					msg = time() .. " Rare Mob killed: " .. v
					RareKilled[v] = time()
					--self:DebugMsg(msg)
					SendChatMessage("[RCELVA]"..v.."-killed-"..time().."-", "CHANNEL", nil, self:getChanID(GetChannelList()))
					RareAlive[v] = nil
					SendChatMessage("[RCELVA]"..v.."-dead-"..time().."-", "CHANNEL", nil, self:getChanID(GetChannelList()))
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
	name,_  = UnitName("target");
	for _,v in pairs(RareNames) do
		if v == name then
				msg = time() .. " Rare Mob targeted: " .. v
				if UnitHealth("target") > 0 then
					RareAlive[v] = time()
					SendChatMessage("[RCELVA]"..name.."-alive-"..time().."-", "CHANNEL", nil, self:getChanID(GetChannelList()))
				else
					RareAlive[v] = nil
					SendChatMessage("[RCELVA]"..name.."-dead-"..time().."-", "CHANNEL", nil, self:getChanID(GetChannelList()))
				end
				RareSeen[v] = time()
				if LastSent[v] == nil then
					SendChatMessage("[RCELVA]"..name.."-seen-"..time().."-", "CHANNEL", nil, self:getChanID(GetChannelList()))
					LastSent[v] = time()
				else
					if (LastSent[v] + 30) < time() then
						SendChatMessage("[RCELVA]"..name.."-seen-"..time().."-", "CHANNEL", nil, self:getChanID(GetChannelList()))
						LastSent[v] = time()
					end
				end
				--self:DebugMsg(msg)
				self:updateText()
			break
		end
	end
end

function RC:updateText()
	txt = ""
	for _,name in pairs(RareNames) do
		gotATime = false
		gotAKill = false
		alive = false
		timeSeen = 0;
		timeKilled = 0;
		for timedName,timestamp in pairs(RareSeen) do
			if name == timedName then
				timeSeen = timestamp
				gotATime = true
			end
		end
		for timedName,timestamp in pairs(RareKilled) do
			if name == timedName then
				timeKilled = timestamp
				gotAKill = true
			end
		end
		for timedName,timestamp in pairs(RareAlive) do
			if name == timedName then
				alive = true
			end
		end
		if alive then
			txt = txt .. " " .. name .. " -            ~~~ is ALIVE ~~~             \n"
		elseif gotATime or gotAKill then
			if gotAKill and gotATime then
				txt = txt .. " " .. name .. " - seen: ".. date("%X", timeSeen) .." - killed: ".. date("%X", timeKilled) .."  \n"
			end
			if gotAKill and not gotATime then
				txt = txt .. " " .. name .. " - seen: not seen - killed: ".. date("%X", timeKilled) .."  \n"
			end
			if not gotAKill and gotATime then
				txt = txt .. " " .. name .. " - seen: ".. date("%X", timeSeen) .." - killed: not killed\n"
			end
		else
			txt = txt .. " " .. name .. " - seen: not seen - killed: not killed\n"
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
		RC:SetScript("OnUpdate", RC.join)
		
		
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
