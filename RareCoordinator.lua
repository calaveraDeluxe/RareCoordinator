
RCDB = { }

local function onDragStart(self) self:StartMoving() end

local function onDragStop(self)
	self:StopMovingOrSizing()
	RCDB.x = self:GetLeft()
	RCDB.y = self:GetTop()
end

local function OnDragHandleMouseDown(self) self.frame:StartSizing("BOTTOMRIGHT") end

local function OnDragHandleMouseUp(self, button) self.frame:StopMovingOrSizing() end

local function onResize(self, width, height)
	height = width*1.69
	RCDB.width = width
	RCDB.height = height
	self:SetHeight(height)
	
	local scale = width/300
	
	
	if self.left ~= nil then 
		self.left:SetPoint("TOPLEFT", self, 4*scale, -5*scale)
		self.left:SetHeight(height-9*scale)
		self.left:SetWidth(width/20*12)
		if self.left.text ~= nil then
			local i
			for i=0,table.getn(self.left.text) do
				self.left.text[i]:SetPoint("TOP", "RC.left", 2*scale, (-2 + -15.4*i)*scale)
				if i == 0 then
					self.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale,"OUTLINE")
				else
					self.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale)
				end
			end
		end
		if self.left.icon ~= nil then
			local i
			for i=0,table.getn(self.left.icon) do
				if i == 0 then
					self.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", 6*scale, -3*scale)
					self.left.icon[i]:SetWidth(20*scale)
					self.left.icon[i]:SetHeight(20*scale)
				else
					self.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", -3*scale, (-2 + -15.5*i)*scale)
					self.left.icon[i]:SetWidth(10*scale)
					self.left.icon[i]:SetHeight(10*scale)
				end
			end
		end
		
	end
	if self.mid ~= nil then
		self.mid:SetHeight(height-9*scale)
		self.mid:SetWidth(width/20*4-6*scale)
		self.mid:SetPoint("TOPLEFT", self.left, "TOPRIGHT", 2*scale, 0)
		if self.mid.text ~= nil then
			local i
			for i=0,table.getn(self.mid.text) do
				self.mid.text[i]:SetPoint("TOP", "RC.mid", 2*scale, (-2 + -15.4*i)*scale)
				if i == 0 then
					self.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale,"OUTLINE")
				else
					self.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale)
				end
			end
		end
		if self.mid.button ~= nil then
			local i
			for i=0,table.getn(self.mid.button) do
				self.mid.button[i]:SetPoint("TOPLEFT", "RC.mid", 0, -2-(15.5*i)*scale)
				self.mid.button[i]:SetHeight(13*scale)
				self.mid.button[i]:SetWidth(self.mid:GetWidth())
				self.mid.button[i].icon:SetWidth(10*scale)
				self.mid.button[i].icon:SetHeight(10*scale)
			end
		end
	end
	if self.right ~= nil then 
		self.right:SetHeight(height-9*scale) 
		self.right:SetWidth(width/20*4-6*scale)
		self.right:SetPoint("TOPLEFT", self.mid, "TOPRIGHT", 2*scale, 0)
		if self.right.text ~= nil then
			local i
			for i=0,table.getn(self.right.text) do
				self.right.text[i]:SetPoint("TOP", "RC.right", 2*scale, (-2 + -15.4*i)*scale)
				if i == 0 then
					self.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale,"OUTLINE")
				else
					self.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12*scale)
				end
			end
		end
	end
end

--------------------------------

local locked = true
local RareIDs = {
	73174, -- Archiereus of Flame
	72775, -- Bufo
	73171, -- Champion of the Black Flame
	72045, -- Chelon
	73175, -- Cinderfall
	73854, -- Cranegnasher
	73281, -- Dread Ship Vazuvius
	73158, -- Emerald Gander
	73279, -- Evermaw
	73172, -- Flintlord Gairan
	73282, -- Garnia
	72970, -- Golganarr
	73161, -- Great Turtle Furyshell
	72909, -- Gu'chi the Swarmbringer
	73167, -- Huolon 
	73163, -- Imperial Python
	73160, -- Ironfur Steelhorn
	73169, -- Jakur of Ordon
	72193, -- Karkanos
	73277, -- Leafmender
	73166, -- Monstrous Spineclaw
	72048, -- Rattleskew
	73157, -- Rock Moss
	71864, -- Spelurk
	72769, -- Spirit of Jadefire
	73704, -- Stinkbraid 
	72808, -- Tsavo'ka
	73173, -- Urdur the Cauterizer
	73170, -- Watcher Osu
	72245, -- Zesqua
	71919 -- Zhu-Gon the Sour
	--69384  -- Luminescent Crawler - FOR TESTING ONLY
}
local RareCoords = {
	"varied spawn: either 53.8 / 32.2 or 36.0 / 30.0", -- Archiereus of Flame
	"around 65.4 / 70.0", -- Bufo
	"patrols between the 2 big bridges", -- Champion of the Black Flame
	"25.3 / 35.8", -- Chelon
	"54.0 / 52.4", -- Cinderfall
	"44.5 / 69.0", -- Cranegnasher
	"25.8 / 23.2", -- Dread Ship Vazuvius
	"varied spawn in the forest", -- Emerald Gander
	"swims around the isle", -- Evermaw
	"varied spawn around Ordon Sanctuary", -- Flintlord Gairan
	"64.8 / 28.8", -- Garnia
	"62.5 / 63.5", -- Golganarr
	"varied spawn around west coast", -- Great Turtle Furyshell
	"varied spawn around Old Pi'jiu village", -- Gu'chi the Swarmbringer
	"varied spawn flying around the bridges", -- Huolon 
	"varied spawn around the forests in the center area", -- Imperial Python
	"varied spawn around the center area", -- Ironfur Steelhorn
	"52.0 / 83.4", -- Jakur of Ordon
	"33.9 / 85.1", -- Karkanos
	"67.3 / 44.1", -- Leafmender
	"varied spawn around the beach", -- Monstrous Spineclaw
	"60.6 / 87.2", -- Rattleskew
	"45.4 / 29.4", -- Rock Moss
	"59.0 / 48.8", -- Spelurk
	"45.4 / 38.9", -- Spirit of Jadefire
	"71.5 / 80.7", -- Stinkbraid 
	"54.6 / 44.3", -- Tsavo'ka
	"45.4 / 26.6", -- Urdur the Cauterizer
	"57.5 / 77.1", -- Watcher Osu
	"47.6 / 87.3", -- Zesqua
	"37.4 / 77.4" -- Zhu-Gon the Sour
}
local RareCoordsRaw = {
	{x=0, y=0}, -- Archiereus of Flame
	{x=65.4, y=70.0}, -- Bufo
	{x=0, y=0}, -- Champion of the Black Flame
	{x=25.3, y=35.8}, -- Chelon
	{x=54.0, y=52.4}, -- Cinderfall
	{x=44.5, y=69.0}, -- Cranegnasher
	{x=25.8, y=23.2}, -- Dread Ship Vazuvius
	{x=0, y=0}, -- Emerald Gander
	{x=0, y=0}, -- Evermaw
	{x=0, y=0}, -- Flintlord Gairan
	{x=64.8, y=28.8}, -- Garnia
	{x=62.5, y=63.5}, -- Golganarr
	{x=0, y=0}, -- Great Turtle Furyshell
	{x=0, y=0}, -- Gu'chi the Swarmbringer
	{x=0, y=0}, -- Huolon 
	{x=0, y=0}, -- Imperial Python
	{x=0, y=0}, -- Ironfur Steelhorn
	{x=52.0, y=83.4}, -- Jakur of Ordon
	{x=33.9, y=85.1}, -- Karkanos
	{x=67.3, y=44.1}, -- Leafmender
	{x=0, y=0}, -- Monstrous Spineclaw
	{x=60.6, y=87.2}, -- Rattleskew
	{x=45.4, y=29.4}, -- Rock Moss
	{x=59.0, y=48.8}, -- Spelurk
	{x=45.4, y=38.9}, -- Spirit of Jadefire
	{x=71.5, y=80.7}, -- Stinkbraid 
	{x=54.6, y=44.3}, -- Tsavo'ka
	{x=45.4, y=26.6}, -- Urdur the Cauterizer
	{x=57.5, y=77.1}, -- Watcher Osu
	{x=47.6, y=87.3}, -- Zesqua
	{x=37.4, y=77.4} -- Zhu-Gon the Sour
}
local RareNamesLocalized = {};
RareNamesLocalized['enUS'] = {}
RareNamesLocalized['enUS'][73174] = "Archiereus of Flame"
RareNamesLocalized['enUS'][72775] = "Bufo"
RareNamesLocalized['enUS'][73171] = "Champion of the Black Flame"
RareNamesLocalized['enUS'][72045] = "Chelon"
RareNamesLocalized['enUS'][73175] = "Cinderfall"
RareNamesLocalized['enUS'][73854] = "Cranegnasher"
RareNamesLocalized['enUS'][73281] = "Dread Ship Vazuvius"
RareNamesLocalized['enUS'][73158] = "Emerald Gander"
RareNamesLocalized['enUS'][73279] = "Evermaw"
RareNamesLocalized['enUS'][73172] = "Flintlord Gairan"
RareNamesLocalized['enUS'][73282] = "Garnia"
RareNamesLocalized['enUS'][72970] = "Golganarr"
RareNamesLocalized['enUS'][73161] = "Great Turtle Furyshell"
RareNamesLocalized['enUS'][72909] = "Gu'chi the Swarmbringer"
RareNamesLocalized['enUS'][73167] = "Huolon "
RareNamesLocalized['enUS'][73163] = "Imperial Python"
RareNamesLocalized['enUS'][73160] = "Ironfur Steelhorn"
RareNamesLocalized['enUS'][73169] = "Jakur of Ordon"
RareNamesLocalized['enUS'][72193] = "Karkanos"
RareNamesLocalized['enUS'][73277] = "Leafmender"
RareNamesLocalized['enUS'][73166] = "Monstrous Spineclaw"
RareNamesLocalized['enUS'][72048] = "Rattleskew"
RareNamesLocalized['enUS'][73157] = "Rock Moss"
RareNamesLocalized['enUS'][71864] = "Spelurk"
RareNamesLocalized['enUS'][72769] = "Spirit of Jadefire"
RareNamesLocalized['enUS'][73704] = "Stinkbraid "
RareNamesLocalized['enUS'][72808] = "Tsavo'ka"
RareNamesLocalized['enUS'][73173] = "Urdur the Cauterizer"
RareNamesLocalized['enUS'][73170] = "Watcher Osu"
RareNamesLocalized['enUS'][72245] = "Zesqua"
RareNamesLocalized['enUS'][71919] = "Zhu-Gon the Sour"
--RareNamesLocalized['enUS'][69384] = "Luminescent Crawler"
RareNamesLocalized['deDE'] = {}
RareNamesLocalized['deDE'][73174] = "Archiereus der Flamme"
RareNamesLocalized['deDE'][72775] = "Bufo"
RareNamesLocalized['deDE'][73171] = "Champion der Schwarzen Flamme"
RareNamesLocalized['deDE'][72045] = "Chelon"
RareNamesLocalized['deDE'][73175] = "Glutfall"
RareNamesLocalized['deDE'][73854] = "Kranichknirscher"
RareNamesLocalized['deDE'][73281] = "Schreckensschiff Vazuvius"
RareNamesLocalized['deDE'][73158] = "Smaragdkranich"
RareNamesLocalized['deDE'][73279] = "Tiefenschlund"
RareNamesLocalized['deDE'][73172] = "Funkenlord Gairan"
RareNamesLocalized['deDE'][73282] = "Garnia"
RareNamesLocalized['deDE'][72970] = "Golganarr"
RareNamesLocalized['deDE'][73161] = "Großschildkröte Zornpanzer"
RareNamesLocalized['deDE'][72909] = "Gu'chi der Schwarmbringer"
RareNamesLocalized['deDE'][73167] = "Huolon"
RareNamesLocalized['deDE'][73163] = "Kaiserpython"
RareNamesLocalized['deDE'][73160] = "Eisenfellstahlhorn"
RareNamesLocalized['deDE'][73169] = "Jakur von Ordos"
RareNamesLocalized['deDE'][72193] = "Karkanos"
RareNamesLocalized['deDE'][73277] = "Blattheiler"
RareNamesLocalized['deDE'][73166] = "Monströse Dornzange"
RareNamesLocalized['deDE'][72048] = "Klapperknochen"
RareNamesLocalized['deDE'][73157] = "Steinmoos"
RareNamesLocalized['deDE'][71864] = "Spelurk"
RareNamesLocalized['deDE'][72769] = "Jadefeuergeist"
RareNamesLocalized['deDE'][73704] = "Stinkezopf"
RareNamesLocalized['deDE'][72808] = "Tsavo'ka"
RareNamesLocalized['deDE'][73173] = "Urdur der Kauterisierer"
RareNamesLocalized['deDE'][73170] = "Behüter Osu"
RareNamesLocalized['deDE'][72245] = "Zesqua"
RareNamesLocalized['deDE'][71919] = "Zhu-Gon der Saure"
RareNamesLocalized['esES'] = {}
RareNamesLocalized['esES'][73174] = "Sacerdote ilustre de las llamas"
RareNamesLocalized['esES'][72775] = "Buffo"
RareNamesLocalized['esES'][73171] = "Campeón de la Llama Negra"
RareNamesLocalized['esES'][72045] = "Quelón"
RareNamesLocalized['esES'][73175] = "Carbonos"
RareNamesLocalized['esES'][73854] = "Mascagrullas"
RareNamesLocalized['esES'][73281] = "Barco aterrador Vazuvius"
RareNamesLocalized['esES'][73158] = "Ganso esmeralda"
RareNamesLocalized['esES'][73279] = "Fauce Eterna"
RareNamesLocalized['esES'][73172] = "Señor del sílex Gairan"
RareNamesLocalized['esES'][73282] = "Garnia"
RareNamesLocalized['esES'][72970] = "Golganarr"
RareNamesLocalized['esES'][73161] = "Gran tortuga Irazón"
RareNamesLocalized['esES'][72909] = "Gu'chi el Portaenjambres"
RareNamesLocalized['esES'][73167] = "Huolon"
RareNamesLocalized['esES'][73163] = "Pitón imperial"
RareNamesLocalized['esES'][73160] = "Astado acerado Cueracero"
RareNamesLocalized['esES'][73169] = "Jakur el Ordon"
RareNamesLocalized['esES'][72193] = "Karkanos"
RareNamesLocalized['esES'][73277] = "Sanador de hojas"
RareNamesLocalized['esES'][73166] = "Pinzaespina monstruoso"
RareNamesLocalized['esES'][72048] = "Ossotremulus"
RareNamesLocalized['esES'][73157] = "Musgo de roca"
RareNamesLocalized['esES'][71864] = "Espectrante"
RareNamesLocalized['esES'][72769] = "Espíritu de fuego de jade"
RareNamesLocalized['esES'][73704] = "Barbasucia"
RareNamesLocalized['esES'][72808] = "Tsavo'ka"
RareNamesLocalized['esES'][73173] = "Urdur el Cauterizador"
RareNamesLocalized['esES'][73170] = "Vigía Osu"
RareNamesLocalized['esES'][72245] = "Zesqua"
RareNamesLocalized['esES'][71919] = "Zhu Gon el Agrio"
RareNamesLocalized['frFR'] = {}
RareNamesLocalized['frFR'][73174] = "Archiprêtre de flammes"
RareNamesLocalized['frFR'][72775] = "Bufo"
RareNamesLocalized['frFR'][73171] = "Champion de la flamme noire"
RareNamesLocalized['frFR'][72045] = "Chelon"
RareNamesLocalized['frFR'][73175] = "Cendrechute"
RareNamesLocalized['frFR'][73854] = "Croque-grue"
RareNamesLocalized['frFR'][73281] = "Bateau de l’effroi Vazuvius"
RareNamesLocalized['frFR'][73158] = "Jars émeraude"
RareNamesLocalized['frFR'][73279] = "Gueule-Éternelle"
RareNamesLocalized['frFR'][73172] = "Seigneur des silex Gairan"
RareNamesLocalized['frFR'][73282] = "Garnia"
RareNamesLocalized['frFR'][72970] = "Golganarr"
RareNamesLocalized['frFR'][73161] = "Grande tortue Écaille-de-Fureur"
RareNamesLocalized['frFR'][72909] = "Gu’chi l’Essaimeur"
RareNamesLocalized['frFR'][73167] = "Huolon"
RareNamesLocalized['frFR'][73163] = "Python impérial"
RareNamesLocalized['frFR'][73160] = "Corne-d’acier ferpoil"
RareNamesLocalized['frFR'][73169] = "Jakur d’Ordos"
RareNamesLocalized['frFR'][72193] = "Karkanos"
RareNamesLocalized['frFR'][73277] = "Soigne-Feuille"
RareNamesLocalized['frFR'][73166] = "Pincépine monstrueux"
RareNamesLocalized['frFR'][72048] = "Déglingois"
RareNamesLocalized['frFR'][73157] = "Mousse des rochers"
RareNamesLocalized['frFR'][71864] = "Souterrant"
RareNamesLocalized['frFR'][72769] = "Esprit de Jadefeu"
RareNamesLocalized['frFR'][73704] = "Fouettnatte"
RareNamesLocalized['frFR'][72808] = "Tsavo’ka"
RareNamesLocalized['frFR'][73173] = "Urdur le Cautérisateur"
RareNamesLocalized['frFR'][73170] = "Guetteur Osu"
RareNamesLocalized['frFR'][72245] = "Zesqua"
RareNamesLocalized['frFR'][71919] = "Zhu Gon l’Amer"


local RareSeen = {}
local RareKilled = {}
local RareAlive = {}
local RareAliveHP = {}
local RareAnnounced = {}
local LastSent = {}
local RareAv = {}
local SoundPlayed = {}

--local SoundPlayed = 0
local VersionNotify = false
local myChan = false

local txt = ""
local currentWaypointX = false
local currentWaypointY = false
local currentWaypointNPCID = false

local needStatus = false

--------------------------------
local RC = CreateFrame("Frame", "RC", UIParent)
RC.version = "5.4.0-2"


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

function RC:getTargetPercentHP()
	local currhp = UnitHealth("target")
	local maxhp = UnitHealthMax("target")
	if currhp == 0 and maxhp == 0 then
		return false
	else
		return math.floor(currhp/maxhp * 100) 
	end
end

function RC:getTargetPercentHProunded()
	local per = self:getTargetPercentHP()
	if per then
		return math.floor(per/10)*10
	else
		return false
	end
end

function RC:setWaypoint(id)
	if TomTom ~= nil then
		if currentWaypointX == false and currentWaypointY == false then
			if RareCoordsRaw[id]["x"] ~= 0 and RareCoordsRaw[id]["y"] ~= 0 then
				TomTom:AddWaypoint(RareCoordsRaw[id]["x"],RareCoordsRaw[id]["y"],self:getLocalRareName(RareIDs[id]))
				currentWaypointX = RareCoordsRaw[id]["x"]
				currentWaypointY = RareCoordsRaw[id]["y"]
				currentWaypointNPCID = RareIDs[id]
			end
		end
	end
end

local function OnMouseDownAnnounce(id)
	if RareAnnounced[RareIDs[id]] == nil then
		if RareAliveHP[RareIDs[id]] == nil then
			SendChatMessage("{rt1} [RareCoordinator] "..RC:getLocalRareName(RareIDs[id])..": "..RareCoords[id].." {rt1}", "CHANNEL", nil, 1)
		else
			SendChatMessage("{rt1} [RareCoordinator] "..RC:getLocalRareName(RareIDs[id]).."("..RareAliveHP[RareIDs[id]].."%): "..RareCoords[id].." {rt1}", "CHANNEL", nil, 1)
		end
		RareAnnounced[RareIDs[id]] = time()
	end
end


RC:SetWidth(300)
RC:SetHeight(200)
RC:SetFrameStrata("BACKGROUND")
RC:SetPoint("CENTER",0,0)
RC:SetClampedToScreen(true)
RC:SetMinResize(150, 0)
RC:SetMaxResize(500, 0)

RC.texture = RC:CreateTexture(nil,"BACKGROUND")
RC.texture:SetTexture(0,0,0,0.4)
RC.texture:SetAllPoints(RC)


RC.left = CreateFrame("Frame", "RC.left", RC)
RC.left:SetWidth(200)
RC.left:SetHeight(RC:GetHeight()-9)
RC.left:SetPoint("TOPLEFT", RC, 5, -5)
RC.left.texture = RC:CreateTexture(nil,"BACKGROUND", nil, 1)
RC.left.texture:SetTexture(0,0,0,0.2)
RC.left.texture:SetAllPoints(RC.left)

RC.mid = CreateFrame("Frame", "RC.mid", RC)
RC.mid:SetWidth(80)
RC.mid:SetHeight(RC:GetHeight()-9)
RC.mid:SetPoint("TOPLEFT", RC.left, "TOPRIGHT", 2, 0)
RC.mid.texture = RC:CreateTexture(nil,"BACKGROUND", nil, 1)
RC.mid.texture:SetTexture(0,0,0,0.2)
RC.mid.texture:SetAllPoints(RC.mid)

RC.right = CreateFrame("Frame", "RC.right", RC)
RC.right:SetWidth(80)
RC.right:SetHeight(RC:GetHeight()-9)
RC.right:SetPoint("TOPLEFT", RC.mid, "TOPRIGHT", 2, 0)
RC.right.texture = RC:CreateTexture(nil,"BACKGROUND", nil, 1)
RC.right.texture:SetTexture(0,0,0,0.2)
RC.right.texture:SetAllPoints(RC.right)

RC.res = CreateFrame("Frame", "RC.res", RC)
RC.res.frame = RC
RC.res:SetWidth(16)
RC.res:SetHeight(16)
RC.res:SetPoint("BOTTOMRIGHT", RC, -1, 1)
RC.res:EnableMouse(true)
RC.res:SetScript("OnMouseDown", OnDragHandleMouseDown)
RC.res:SetScript("OnMouseUp", OnDragHandleMouseUp)
RC.res:SetAlpha(0.5)

RC.res.texture = RC.res:CreateTexture(nil, "OVERLAY")
RC.res.texture:SetTexture([[Interface\AddOns\RareCoordinator\resize.tga]])
RC.res.texture:SetWidth(16)
RC.res.texture:SetHeight(16)
RC.res.texture:SetBlendMode("ADD")
RC.res.texture:SetPoint("CENTER", RC.res)

RC.res:Hide()


RC.left.text = {}
local i
for i=0, #RareIDs do
	RC.left.text[i] = RC.left:CreateFontString("RC.left.text["..i.."]", nil, "GameFontNormal")
	RC.left.text[i]:SetPoint("TOP", "RC.left", 2, -2 + -14.5*i)
	RC.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12)
	RC.left.text[i]:SetTextColor(1,1,1)
	if i == 0 then
		RC.left.text[i]:SetText("Rare")
		RC.left.text[i]:SetFont("Fonts\\ARIALN.TTF",12,"OUTLINE")
	else
		RC.left.text[i]:SetText(RC:getLocalRareName(RareIDs[i]))
	end
end
RC.left.icon = {}
local i
for i=0, #RareIDs do
	RC.left.icon[i] = CreateFrame("Frame", "RC.left.icon["..i.."]", RC)

	if i == 0 then
		RC.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", 6, -5)
		RC.left.icon[i]:SetWidth(20)
		RC.left.icon[i]:SetHeight(20)
		RC.left.icon[i].texture = RC.left.icon[i]:CreateTexture(nil, "OVERLAY")
		RC.left.icon[i].texture:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-TinyShield]])
		RC.left.icon[i].texture:SetAllPoints(RC.left.icon[i])
	else
		RC.left.icon[i]:SetPoint("TOPRIGHT", "RC.left", -3, -3 + -14.8*i)
		RC.left.icon[i]:SetWidth(10)
		RC.left.icon[i]:SetHeight(10)
		RC.left.icon[i].texture = RC.left.icon[i]:CreateTexture(nil, "OVERLAY")
		RC.left.icon[i].texture:SetAllPoints(RC.left.icon[i])
	end
end
RC.mid.button = {}
for i=0, #RareIDs do
	RC.mid.button[i] = CreateFrame("Frame", "RC.mid.button["..i.."]", RC)
	RC.mid.button[i]:SetPoint("TOPLEFT", "RC.mid", 0, -2 + -14.5*i)
	RC.mid.button[i]:SetHeight(13)
	RC.mid.button[i]:SetWidth(RC.mid:GetWidth())
	RC.mid.button[i].texture = RC.mid.button[i]:CreateTexture(nil,"BACKGROUND", nil, 2)
	RC.mid.button[i].texture:SetTexture(0,0.5,0,0.4)
	RC.mid.button[i].texture:SetAllPoints(RC.mid.button[i])
	
	RC.mid.button[i].icon = CreateFrame("Frame", "RC.mid.icon["..i.."].icon", RC.mid.button[i])
	RC.mid.button[i].icon:SetPoint("RIGHT", "RC.mid.button["..i.."]", 2, 0)
	RC.mid.button[i].icon:SetWidth(10)
	RC.mid.button[i].icon:SetHeight(10)
	RC.mid.button[i].icon.texture = RC.mid.button[i].icon:CreateTexture(nil, "OVERLAY")
	RC.mid.button[i].icon.texture:SetTexture([[Interface\AddOns\RareCoordinator\announce.tga]])
	RC.mid.button[i].icon.texture:SetAllPoints(RC.mid.button[i].icon)
	if i ~= 0 then
		RC.mid.button[i]:SetScript("OnMouseDown", function (self) OnMouseDownAnnounce(i) end)
	end
	RC.mid.button[i]:Hide()
end
RC.mid.text = {}
local i
for i=0, #RareIDs do
	RC.mid.text[i] = RC.mid:CreateFontString("RC.mid.text["..i.."]", nil, "GameFontNormal")
	RC.mid.text[i]:SetPoint("TOP", "RC.mid", 2, -2 + -14.5*i)
	RC.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12)
	RC.mid.text[i]:SetTextColor(1,1,1)
	if i == 0 then
		RC.mid.text[i]:SetText("Seen")
		RC.mid.text[i]:SetFont("Fonts\\ARIALN.TTF",12,"OUTLINE")
	end
end
RC.right.text = {}
local i
for i=0, #RareIDs do
	RC.right.text[i] = RC.right:CreateFontString("RC.right.text["..i.."]", nil, "GameFontNormal")
	RC.right.text[i]:SetPoint("TOP", "RC.right", 2, -2 + -14.5*i)
	RC.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12)
	RC.right.text[i]:SetTextColor(1,1,1)
	if i == 0 then
		RC.right.text[i]:SetText("Killed")
		RC.right.text[i]:SetFont("Fonts\\ARIALN.TTF",12,"OUTLINE")
	end
end

local total = 0
local function updateText(self,elapsed)
	if elapsed == nil then elapsed = 0 end
    total = total + elapsed
    if total >= 10 then
		for i=1,GetAchievementNumCriteria(8714) do
			_, _, completed, _, _, _, _, assetID, _, _ = GetAchievementCriteriaInfo(8714,i)
			if completed then
				RareAv[assetID] = true
			else
				RareAv[assetID] = false
			end		
		end
		for k,v in pairs(RareSeen) do
			if tonumber(v)+2*60*60 < time() then
				RareSeen[k] = nil
			end
		end
		for k,v in pairs(RareKilled) do
			if tonumber(v)+2*60*60 < time() then
				RareKilled[k] = nil
			end
		end
		for k,v in pairs(RareAlive) do
			if tonumber(v)+10*60 < time() then
				RareAlive[k] = nil
				RareAliveHP[k] = nil
			end
		end
		if RC.left ~= nil then
			if RC.left.icon ~= nil then
				local i
				for i=1,table.getn(RC.left.icon) do
					if RareAv[RareIDs[i]] ~= nil then
						if RareAv[RareIDs[i]] then
							RC.left.icon[i].texture:SetTexture([[Interface\AddOns\RareCoordinator\green.tga]])
						else
							RC.left.icon[i].texture:SetTexture([[Interface\AddOns\RareCoordinator\red.tga]])
						end
					end
				end
			end
		end
		if RC.mid ~= nil then
			if RC.mid.text ~= nil then
				local i
				for i=1,table.getn(RC.mid.text) do
					if RareAlive[RareIDs[i]] ~= nil then
						if SoundPlayed[RareIDs[i]] == nil then
							PlaySoundFile("sound\\CREATURE\\MANDOKIR\\VO_ZG2_MANDOKIR_LEVELUP_EVENT_01.ogg", "MASTER")
							SoundPlayed[RareIDs[i]] = time()
						elseif time() > SoundPlayed[RareIDs[i]] + 600 then
							PlaySoundFile("sound\\CREATURE\\MANDOKIR\\VO_ZG2_MANDOKIR_LEVELUP_EVENT_01.ogg", "MASTER")
							SoundPlayed[RareIDs[i]] = time()
						end
						RC.mid.button[i]:Show()
						RC.mid.text[i]:SetText("|cff00ff00alive|r")
						RC:setWaypoint(i)
					elseif RareSeen[RareIDs[i]] ~= nil then
						RC.mid.button[i]:Hide()
						RC.mid.text[i]:SetText(math.floor((time()-RareSeen[RareIDs[i]])/60).."m ago")
					else
						RC.mid.button[i]:Hide()
						RC.mid.text[i]:SetText("never")
					end
				end
			end
		end
		if RC.right ~= nil then
			if RC.right.text ~= nil then
				local i
				for i=1,table.getn(RC.right.text) do
					if RareAliveHP[RareIDs[i]] ~= nil and RareAlive[RareIDs[i]] then
						RC.right.text[i]:SetText("|cff00ff00"..RareAliveHP[RareIDs[i]].."%|r")
					elseif RareKilled[RareIDs[i]] ~= nil then
						RC.right.text[i]:SetText(math.floor((time()-RareKilled[RareIDs[i]])/60).."m ago")
					else
						RC.right.text[i]:SetText("never")
					end
				end
			end
		end
        total = 0
    end
end




function RC:OnEvent(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		self:CombatLog(...)
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
	if event == "UNIT_HEALTH" then
		self:UnitHealth(...)
	end
end

function RC:OnLoad(...)
	if select(1, ...) == "RareCoordinator" then
		print("RareCoordinator loaded - type /rc or /rare for options");
		if RCDB.x == nil or RCDB.y == nil then
			self:SetPoint("CENTER",0,0)
		else
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", RCDB.x, RCDB.y)
		end
	end
end

function RC:UnitHealth(unit)
	if unit ~= "target" then return end
	if UnitGUID("target") ~= nil then
		id = tonumber(UnitGUID("target"):sub(6, 10), 16)
		for _,v in pairs(RareIDs) do
			if v == id then
				local per = self:getTargetPercentHProunded()
				if per and per >= 0 then
					if RareAliveHP[id] ~= nil then
						if RareAliveHP[id] > per then
							SendChatMessage("[RCELVA]"..self.version.."_"..id.."_alive"..per.."_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
							RareAliveHP[id] = per
							updateText(self, 100)
						end
					else
						SendChatMessage("[RCELVA]"..self.version.."_"..id.."_alive"..per.."_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
						RareAliveHP[id] = per
						updateText(self, 100)
					end
				end
			end
		end
	end
end


function RC:ShowOrHide(...)
	local zone = GetZoneText()
	if GetCurrentMapAreaID() == 951 then
		RareAlive = {}
		self:Show()
		myChan = false
		self:SetScript("OnUpdate", RC.join)
		self:RegisterEvent("UNIT_HEALTH")
	else
		self:Hide()
		LeaveChannelByName("RCELVA")
		self:UnregisterEvent("UNIT_HEALTH")
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
						elseif string.sub(eventType,0,5) == "alive" then
							RareAlive[v] = eventTime
							RareAliveHP[v] = tonumber(string.sub(eventType,6))
						elseif eventType == "dead" then
							RareAlive[v] = nil
							RareAliveHP[v] = nil
							if currentWaypointNPCID ~= nil then
								if currentWaypointNPCID == v then
									currentWaypointX = false
									currentWaypointY = false
								end
							end
						elseif eventType == "killed" then
							RareKilled[v] = eventTime
							RareAlive[v] = nil
							RareAliveHP[v] = nil
							if currentWaypointNPCID ~= nil then
								if currentWaypointNPCID == v then
									currentWaypointX = false
									currentWaypointY = false
								end
							end
						elseif eventType == "seen" then
							RareSeen[v] = eventTime
						end
						updateText(self, 100)
						self:CompareVersion(eventVersion)
						break
					end
				end
			end
		end
	end
end

function RC:AddonMsg(prefix, message, channel, sender)
	--print(prefix.." - "..channel.." - "..sender.."-"..message)
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
							RareAliveHP[v] = nil
						elseif eventType == "killed" then
							RareKilled[v] = eventTime
							RareAlive[v] = nil
							RareAliveHP[v] = nil
						elseif eventType == "seen" then
							RareSeen[v] = eventTime
						end
						updateText(self, 100)
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
		if     i == 0 then expan1 = tonumber(n)
		elseif i == 1 then cpatch1 = tonumber(n)
		elseif i == 2 then mpatch1 = tonumber(n)
		elseif i == 3 then revision1 = tonumber(n)
		end
		i = i + 1
	end
	i=0
	for n in string.gmatch(v, "%d+") do
		if     i == 0 then expan2 = tonumber(n)
		elseif i == 1 then cpatch2 = tonumber(n)
		elseif i == 2 then mpatch2 = tonumber(n)
		elseif i == 3 then revision2 = tonumber(n)
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
					RareAliveHP[v] = nil
					SendChatMessage("[RCELVA]"..self.version.."_"..npcID.."_dead_"..time().."_", "CHANNEL", nil, self:getChanID(GetChannelList()))
					if RareAnnounced[v] then
						SendChatMessage("{rt8} [RareCoordinator] "..RC:getLocalRareName(npcID).." is now dead {rt8}", "CHANNEL", nil, 1)
						RareAnnounced[v] = nil
					end
					if currentWaypointNPCID ~= nil then
						if currentWaypointNPCID == npcID then
							currentWaypointX = false
							currentWaypointY = false
						end
					end
					updateText(self, 100)
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
					updateText(self, 100)
				end
			end
		end
	end
end

function RC:getChanID(...)
	if myChan ~= false then
		return myChan
	end
	local gotID = false
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		if name == "RCELVA" then
			gotID = true
			myChan = id
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
						RareAliveHP[v] = nil
						if currentWaypointNPCID ~= nil then
							if currentWaypointNPCID == id then
								currentWaypointX = false
								currentWaypointY = false
							end
						end
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
					updateText(self, 100)
				break
			end
		end
	end
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

SLASH_RARECOORDINATOR1 = "/rare"
SLASH_RARECOORDINATOR2 = "/rarecoordinator"
SLASH_RARECOORDINATOR3 = "/rc"
local function SlashHandler(msg, editbox)
	--print("Usage")
	if locked then
		print("RareCoordinator is now unlocked. - Type /rc or /rare to lock it")
		
		RC:EnableMouse(true)
		RC:SetMovable(true)
		RC:SetResizable(true)
		RC:SetScript("OnSizeChanged", onResize)
		RC:SetScript("OnDragStart", onDragStart)
		RC:SetScript("OnDragStop", onDragStop)
		RC:RegisterForDrag("LeftButton")
		RC:Show()
		RC.res:Show()
		
		locked = false
	else
		print("RareCoordinator is now locked. - Type /rc or /rare to unlock it")	
		
		RC:SetMovable(false)
		RC:EnableMouse(false)
		RC:SetResizable(false)
		RC:RegisterForDrag()
		RC:SetScript("OnDragStart", nil)
		RC:SetScript("OnDragStop", nil)
		RC:SetScript("OnHide", nil)
		RC:ShowOrHide()
		RC.res:Hide()
		
		locked = true
	end
end
SlashCmdList["RARECOORDINATOR"] = SlashHandler;

RC.updater = CreateFrame("Frame", "RC.updater", RC)
RC.updater:SetScript("OnUpdate", updateText)

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


updateText(RC, 100)
onResize(RC, RC:GetWidth(), 0)
RC:Show()
