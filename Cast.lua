Circle_Cast2_Default = {
	["blizz"] = false,
	["Player_Ring"] = {
		["r"] = 0.0,    --Red
		["g"] = 0.5, --Green
		["b"] = 1.0, --Blue
		["a"] = 0.3, --Alpha
		["s"] = 0.9, --Scale
		["x"] = 0,          --X Coordinate Offset from parent
		["y"] = 0,          --Y Coordinate Offset from parent
		["p"] = "UIParent", --Frame's Parent
		["Icon"] = {     --Set to nil to disable
			["a"] = 1.0,
			["s"] = 1.3,
			["d"] = 32, --dimensions
			["x"] = 0,
			["y"] = 0,
			},
		["Ping"] = {     --Set to nil to disable
			["r"] = 1.0,
			["g"] = 0.0,
			["b"] = 0.0,
			["a"] = 0.3,
			},
		["Timer"] = {    --Set to nil to disable
			["r"] = 1.0,
			["g"] = 1.0,
			["b"] = 1.0,
			["a"] = 1.0,
			["s"] = 1.0,
			["h"] = 20,
			["w"] = 50,
			["frame"] = "Player_Ring_Icon",  --Frame to anchor to
			["orientA"] = "TOP",             --This frame's anchor
			["orientB"] = "BOTTOM",          --Other frame's anchor
			["x"] = 0,
			["y"] = 0,
			},
		["Text"] = nil,
		},
	-------------------
	["Target_Ring"] = {
		["r"] = 0.9,
		["g"] = 0.9,
		["b"] = 0.0,
		["a"] = 0.3,
		["s"] = 1.12,
		["x"] = 0,
		["y"] = 0,
		["p"] = "UIParent",
		["InteruptColor"] = {
			["r"] = 0,
			["g"] = 0,
			["b"] = 0,
			["a"] = 0.3,
			},
		["Icon"] = nil,
		["Ping"] = nil,
		["Timer"] = {
			["r"] = 1,
			["g"] = 0,
			["b"] = 0,
			["a"] = 1,
			["s"] = 1.0,
			["h"] = 20,
			["w"] = 32,
			["frame"] = "Target_Ring",
			["orientA"] = "BOTTOM",
			["orientB"] = "TOP",
			["x"] = 0,
			["y"] = -18,
			},
		["Text"] = {
			["r"] = 1,
			["g"] = 1,
			["b"] = 1,
			["a"] = 1,
			["s"] = 1.0,
			["h"] = 20,
			["w"] = 128,
			["frame"] = "Target_Ring",
			["orientA"] = "BOTTOM",
			["orientB"] = "TOP",
			["x"] = 0,
			["y"] = 0,
			},
		},
};

CIRCLE_CAST_TOC = 30300;
CIRCLE_CAST_VER = "v"..CIRCLE_CAST_TOC.."-3.0 Alpha";

local _G = _G;
local loaded = nil;
local CC2_parts = {
	[1] = "_Part1",
	[2] = "_Part2",
	[3] = "_Part3",
	[4] = "_Part4",
	[5] = "_Slice",
	[6] = "_Red",
	[7] = "_Blue",
}

function Circle_Cast2_CreateFrames()
	Circle_Cast2_SetupRing("Player_Ring");
	Circle_Cast2_SetupRing("Target_Ring");
end

function Circle_Cast2_SetupRing(name)
	local opt = CC2Options[name];
	local ring = CreateFrame("Frame", name, _G[opt["p"]], "CastRingTemplate");

	--fix parts
	_G[name.."_Part2"]:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0);
	_G[name.."_Part3"]:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0);
	_G[name.."_Part4"]:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1);
	
	--Ping
	if opt["Ping"] then
		local ping = CreateFrame("Frame", name.."_Ping", ring, "CastRingTemplate_Simple");
		for i = 1, 7 do
			_G[name.."_Ping"..CC2_parts[i]]:SetVertexColor(Circle_Cast2_Get_Color(name, "Ping"));
		end
		_G[name.."_Ping_Part2"]:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0);
		_G[name.."_Ping_Part3"]:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0);
		_G[name.."_Ping_Part4"]:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1);
		
		ping:SetPoint("CENTER", ring, "CENTER");
	end
	
	--Icon
	if opt["Icon"] then
		local icon = ring:CreateTexture(name.."_Icon", "ARTWORK");
		local d = opt["Icon"]["s"] * opt["Icon"]["d"]
		icon:SetWidth(d);
		icon:SetHeight(d);
		icon:SetPoint("CENTER", ring, "CENTER", opt["Icon"]["x"], opt["Icon"]["y"]);
	end
	
	--Timer
	if opt["Timer"] then
		local timer = ring:CreateFontString(name.."_Timer", "ARTWORK", "GameFontNormal");
		timer:SetWidth(opt["Timer"]["s"] * opt["Timer"]["w"]);
		timer:SetHeight(opt["Timer"]["s"] * opt["Timer"]["h"]);
		timer:SetVertexColor(Circle_Cast2_Get_Color(name, "Timer"));
		timer:SetFont("Fonts\\FRIZQT__.TTF", 11 * opt["Timer"]["s"], "OUTLINE")
		timer:SetPoint(opt["Timer"]["orientA"], _G[opt["Timer"]["frame"]], opt["Timer"]["orientB"], opt["Timer"]["x"], opt["Timer"]["y"]);
	end
	
	--Text
	if opt["Text"] then
		local Text = ring:CreateFontString(name.."_Text", "ARTWORK", "GameFontNormal");
		Text:SetWidth(opt["Text"]["s"] * opt["Text"]["w"]);
		Text:SetHeight(opt["Text"]["s"] * opt["Text"]["h"]);
		Text:SetVertexColor(Circle_Cast2_Get_Color(name, "Text"));
		Text:SetFont("Fonts\\FRIZQT__.TTF", 11 * opt["Text"]["s"], "OUTLINE")
		Text:SetPoint(opt["Text"]["orientA"], _G[opt["Text"]["frame"]], opt["Text"]["orientB"], opt["Text"]["x"], opt["Text"]["y"]);
	end
	
	--Color
	for i = 1, 7 do
		_G[name..CC2_parts[i]]:SetVertexColor(Circle_Cast2_Get_Color(name));
	end
	
	--Scale
	ring:SetScale(opt["s"]);
	
	--Position
	ring:SetPoint("CENTER", _G[opt["p"]], "CENTER", opt["x"], opt["y"]);
	_G[name]:Hide();
end

function Circle_Cast2_Get_Color(index, index2)
	local r, g, b, a;
	
	if index2 then
		r = CC2Options[index][index2].r;
		g = CC2Options[index][index2].g;
		b = CC2Options[index][index2].b;
		a = CC2Options[index][index2].a;
	else
		r = CC2Options[index].r;
		g = CC2Options[index].g;
		b = CC2Options[index].b;
		a = CC2Options[index].a;
	end

	return r, g, b, a;
end

function Circle_Cast2_OnLoad(self, unit, showTradeSkills)
	self:RegisterEvent("UNIT_SPELLCAST_START");
	self:RegisterEvent("UNIT_SPELLCAST_STOP");
	self:RegisterEvent("UNIT_SPELLCAST_FAILED");
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED");
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
	self:RegisterEvent("UNIT_TARGET");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");

	self.casting = nil;
	self.channeling = nil;
	self.targetCasting = nil;
	self.targetChanneling = nil;
	
	if CC2Options == nil then
		CC2Options = Circle_Cast2_Default;
	end
	
	SLASH_CC2SLASH1, SLASH_CC2SLASH2 = '/cc2', '/circlecast';

	if not CC2Options["blizz"] then
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_START");
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_STOP");
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_FAILED");
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
		CastingBarFrame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		CastingBarFrame:Hide();
	end
	
	Circle_Cast2_CreateFrames();
end

function cc2SlashVar(var)
	return "|cff03C03C"..var.."|r";
end

function cc2SlashStatic(static)
	return "|cffBCD4E6"..static.."|r";
end

function cc2SlashTitle(title)
	return "|cffFF1111"..title.."|r";
end

function cc2SlashSplit(str)
	local ret = {}
	local c = 0;
	for w in string.gmatch(str, " ") do
		ret[c] = w;
		c=c+1;
	end
	return ret
end

function SlashCmdList.CC2SLASH(msg, editbox)
	if msg == "help" or msg == "" then
		print("### "..cc2SlashTitle("CC2 Configuration Help").." ###");
		print(" - Commands: (all parameters and commands must be lowercase!)");
		print(cc2SlashStatic("/cc2 shift").." -- shift the rings position ("..cc2SlashStatic("/cc2 shift help").." for more info)");
		print(cc2SlashStatic("/cc2 color").." -- select new colors for the rings("..cc2SlashStatic("/cc2 color help").." for more info)")
		print(cc2SlashStatic("/cc2 reset").." -- restore default position and colors")
	elseif msg == "shift help" or msg == "shift"	then
		print("### "..cc2SlashTitle("CC2 Shift Help").." ###");
		print(cc2SlashStatic("/CC2 SHIFT").." "..cc2SlashVar("DIRECTION OBJECT PIXELS"));
		print(cc2SlashVar("DIRECTION").." must be up, down, left or right")
		print(cc2SlashVar("OBJECT").." must be player or target");
		print(cc2SlashVar("PIXELS").." must be an integer");
	elseif msg == "color help" or msg == "color" then
		print("### "..cc2SlashTitle("CC2 Color Help").." ###");
		print(cc2SlashStatic("/CC2 COLOR").." "..cc2SlashVar("OBJECT RED GREEN BLUE ALPHA"));
		print(cc2SlashVar("OBJECT").." must be player, target, or ping");
		print(cc2SlashVar("RED").."/"..cc2SlashVar("GREEN").."/"..cc2SlashVar("BLUE").."/"..cc2SlashVar("ALPHA").." must all be a number between or equal to 0 and 255");
		print(cc2SlashVar("ALPHA").." is the level of transparency, 0 being completely clear and 255 being completely solid");
	elseif msg:match("shift %a+ %a+ %d+") then
		-- /CC2 SHIFT [DIRECTION] [PLAYER or TARGET] [PIXELS]
		msg          = msg:sub(7);
		local loc    = msg:find(" ");
		local direct = msg:sub(1, loc-1);
		msg          = msg:sub(loc+1);
		loc          = msg:find(" ");
		local obj    = msg:sub(1, loc-1);
		msg          = msg:sub(loc+1);
		local px     = msg;
		
		local x = 0;
		local y = 0;
		if direct == "down" then
			y = -px;
		elseif direct == "right" then
			x = px;
		elseif direct == "left" then
			x = -px;
		else
			y = px;
		end
		
		local name;
		if obj == "target" then
			name = "Target_Ring";
		else
			name = "Player_Ring";
		end
			
		obj = _G[name];
		CC2Options[name]["x"] = CC2Options[name]["x"] + x;
		CC2Options[name]["y"] = CC2Options[name]["y"] + y;
		obj:ClearAllPoints();
		obj:SetPoint("CENTER", _G[CC2Options[name]["p"]], "CENTER", CC2Options[name]["x"], CC2Options[name]["y"])
	elseif msg:match("color %a+ %d+ %d+ %d+ %d+") then
		-- /CC2 COLOR [PLAYER or TARGET or PING] [RED] [GREEN] [BLUE] [ALPHA]
		msg       = msg:sub(7);
		local loc = msg:find(" ");
		local obj = msg:sub(1, loc-1);
		msg       = msg:sub(loc+1);
		loc       = msg:find(" ");
		local r   = msg:sub(1, loc-1);
		msg       = msg:sub(loc+1);
		loc       = msg:find(" ");
		local g   = msg:sub(1, loc-1);
		msg       = msg:sub(loc+1);
		loc       = msg:find(" ");
		local b   = msg:sub(1, loc-1);
		msg       = msg:sub(loc+1);
		local a   = msg;
		print("Object : "..obj);
		print("r/g/b/a: "..r.."/"..g.."/"..b.."/"..a)
	elseif msg == "reset" then
		local objects = {"Player_Ring", "Target_Ring"};
		
		for obj in objects do
			CC2Options[obj]["x"] = Circle_Cast2_Default[obj]["x"];
			CC2Options[obj]["y"] = Circle_Cast2_Default[obj]["y"];
			CC2Options[obj]["s"] = Circle_Cast2_Default[obj]["s"];
			_G[obj]:ClearAllPoints();
			_G[obj]:SetPoint("CENTER", _G[CC2Options[obj]["p"]], "CENTER", CC2Options[obj]["x"], CC2Options[obj]["y"])
		end
	else
		print("Invalid parameter to CC2");
	end
end

function Circle_Cast2_OnEvent(self, event, unit)
	if event == "UNIT_SPELLCAST_START" then
		local _, _, text, icon, startTime, endTime, _, notInterruptible = UnitCastingInfo(unit); 
		if unit == "player" and not self.casting and not self.channeling and startTime then
			Circle_Cast2_SpellCast_Start(self, startTime, text, endTime - startTime, icon);
		elseif unit == "target" and startTime then
			Circle_Cast2_SpellCast_TargetStart(self, startTime, text, endTime - startTime, icon, notInteruptable);
		end
	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if unit == "player" then
			Circle_Cast2_Reset(self);
		elseif unit == "target" then
			Circle_Cast2_Reset_Target(self);
		end
	--let's save the cheerleader...
	elseif event == "UNIT_TARGET" and unit == "player" then
		Circle_Cast2_Reset_Target(self);
		
		if UnitExists("target") then
			local _, _, text, icon, startTime, endTime = UnitCastingInfo("target");
			if startTime then
				Circle_Cast2_SpellCast_TargetStart(self, startTime, text, endTime - startTime, icon);
			end
		end
	elseif event == "UNIT_SPELLCAST_DELAYED" then
		local _, _, _, _, startTime, endTime = UnitCastingInfo(unit);
		if unit == "player" and self.casting and startTime then
			local delay = (startTime / 1000) - self.startTime;
			self.startTime = self.startTime + delay;
			self.maxValue = self.maxValue + delay;
		elseif unit == "target" and self.casting_target and startTime then
			local delay = (startTime / 1000) - self.startTime_target;
			self.startTime_target = self.startTime_target + delay;
			self.maxValue_target = self.maxValue_target + delay;
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		local _, _, text, icon, startTime, endTime = UnitChannelInfo(unit);
		if unit == "player" and not self.channeling and not self.casting and startTime then
			Circle_Cast2_SpellChannel_Start(self, startTime, text, endTime - startTime, icon);
		elseif unit == "target" and startTime then
			Circle_Cast2_SpellChannel_TargetStart(self, startTime, text, endTime - startTime, icon);
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		local _, _, _, _, _, endTime = UnitChannelInfo(unit);
		if unit == "player" and self.channeling and endTime then
			self.maxValue = endTime / 1000;
		elseif unit == "target" and self.channeling_target and endTime then
			self.maxValue_target = endTime / 1000;
		end
	end
end

function Circle_Cast2_Reset(self)
	self.casting = nil;
	self.channeling = nil;
	_G["Player_Ring"]:Hide();
end

function Circle_Cast2_Reset_Target(self)
	self.casting_target = nil;
	self.channeling_target = nil;
	_G["Target_Ring"]:Hide();
end

function Circle_Cast2_OnUpdate(self, elapsed)
	if self.casting or self.channeling then
		local time = GetTime();
		if (time > self.maxValue) then
			time = self.maxValue
		end
		local timeLeft = math.floor((self.maxValue - time)*10)/10;
		local v = (time - self.startTime) / (self.maxValue - self.startTime) * 100;
		_G["Player_Ring_Timer"]:SetText(string.format("(%.1f)", timeLeft));
		if self.casting and not self.channeling then
			Circle_Cast2_SetBarHeight(_G["Player_Ring"], v);
		elseif self.channeling and not self.casting then
			Circle_Cast2_SetBarHeight(_G["Player_Ring"], 100-v);
		end
	end

	if self.casting_target or self.channeling_target then
		local time = GetTime();
		if (time > self.maxValue_target) then
			time = self.maxValue_target;
		end
		local timeLeft = self.maxValue_target - time;
		local v = (time - self.startTime_target) / (self.maxValue_target - self.startTime_target) * 100;

		_G["Target_Ring_Text"]:SetText(self.spellname_target);
		_G["Target_Ring_Timer"]:SetText(string.format("(%.1f)", timeLeft));
		if self.casting_target and not self.channeling_target then
			Circle_Cast2_SetBarHeight(_G["Target_Ring"], v);
		elseif self.channeling_target and not self.casting_target then
			Circle_Cast2_SetBarHeight(_G["Target_Ring"], 100-v);
		end
	end
end

function Circle_Cast2_SetBarHeight(frame, p, Rev)
	local ring1 = _G[frame:GetName().."_Part1"];
	local ring2 = _G[frame:GetName().."_Part2"];
	local ring3 = _G[frame:GetName().."_Part3"];
	local ring4 = _G[frame:GetName().."_Part4"];
	local slice = _G[frame:GetName().."_Slice"];
	local red   = _G[frame:GetName().."_Red"];
	local blue  = _G[frame:GetName().."_Blue"];
	
	--fix down the percent
	local quadrant = math.ceil(p / 25);
	if quadrant == 2 then
		p = p - 25;
	elseif quadrant == 3 then
		p = p - 50;
	elseif quadrant == 4 then
		p = p - 75;
	end
	
	--constants because of texture
	local IR = 90; --Inner Radius
	local OR = 110; --Outer Radius
	local SIZE = 128;
	
	--trig time
	local degree = (p * 360) / 100;
	local radian = math.rad(degree);
	local Ix = math.sin(radian) * IR;
	local Iy = SIZE - math.cos(radian) * IR;
	local Ox = math.sin(radian) * OR;
	local Oy = SIZE - math.cos(radian) * OR;
	local IxCoord = Ix / SIZE;
	local IyCoord = Iy / SIZE;
	local OxCoord = Ox / SIZE;
	local OyCoord = Oy / SIZE;
	
	red:ClearAllPoints();
	blue:ClearAllPoints();
	slice:ClearAllPoints();
	
	if(p <= 0 or p > 100) then
		ring1:Hide();
		ring2:Hide();
		ring3:Hide();
		ring4:Hide();
		return;
	elseif quadrant == 1 then --inside 1
		--hides
		ring1:Hide();
		ring2:Hide();
		ring3:Hide();
		ring4:Hide();
		if Rev then
			red:SetTexCoord(IxCoord, 0, IxCoord, IyCoord, 0, 0, 0, IyCoord);
			red:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -SIZE, 0);
			red:SetWidth(Ix);
			red:SetHeight(Iy);
			red:Show();
			
			blue:SetTexCoord(OxCoord, 0, OxCoord, OyCoord, IxCoord, 0, IxCoord, OyCoord);
			blue:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -SIZE - Ix, 0);
			blue:SetWidth(Ox-Ix);
			blue:SetHeight(Oy);
			blue:Show();
			
			slice:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1);
			slice:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -SIZE - Ix,-Oy);
			slice:SetWidth(Ox-Ix);
			slice:SetHeight(Iy-Oy);
			slice:Show();
		else
			red:SetTexCoord(0, IxCoord, 0, IyCoord);
			red:SetPoint("TOPLEFT", frame, "TOPLEFT", SIZE, 0);
			red:SetWidth(Ix);
			red:SetHeight(Iy);
			red:Show();
			
			blue:SetTexCoord(IxCoord, OxCoord, 0, OyCoord);
			blue:SetPoint("TOPLEFT", frame, "TOPLEFT", SIZE + Ix, 0);
			blue:SetWidth(Ox-Ix);
			blue:SetHeight(Oy);
			blue:Show();
			
			slice:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1);
			slice:SetPoint("TOPLEFT", frame, "TOPLEFT",SIZE + Ix,-Oy);
			slice:SetWidth(Ox-Ix);
			slice:SetHeight(Iy-Oy);
			slice:Show();
		end
	elseif quadrant == 2 then --inside 2
		if Rev then
		else
			--hides
			ring2:Hide();
			ring3:Hide();
			ring4:Hide();
			--shows
			ring1:Show();
			
			red:SetTexCoord(0, IyCoord, IxCoord, IyCoord, 0, 0, IxCoord, 0);
			red:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -SIZE);
			red:SetWidth(Iy);
			red:SetHeight(Ix);
			red:Show();
			
			blue:SetTexCoord(IxCoord, OyCoord, OxCoord, OyCoord, IxCoord, 0, OxCoord, 0);
			blue:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -SIZE-Ix);
			blue:SetWidth(Oy);
			blue:SetHeight(Ox-Ix);
			blue:Show();

			slice:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0);
			slice:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -Oy,-SIZE-Ix);
			slice:SetWidth(Iy-Oy);
			slice:SetHeight(Ox-Ix);
			slice:Show();
		end
	elseif quadrant == 3 then --inside 3
		--hides
		ring3:Hide();
		ring4:Hide();
		--shows
		ring1:Show();
		ring2:Show();
		
		--partial
		red:SetTexCoord(IxCoord, IyCoord, IxCoord, 0, 0, IyCoord, 0, 0);
		red:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -SIZE, 0);
		red:SetWidth(Ix);
		red:SetHeight(Iy);
		red:Show();
		
		blue:SetTexCoord(OxCoord, OyCoord, OxCoord, 0, IxCoord, OyCoord, IxCoord, 0);
		blue:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -SIZE-Ix, 0);
		blue:SetWidth(Ox-Ix);
		blue:SetHeight(Oy);
		blue:Show();
		
		slice:SetTexCoord(1, 1, 1, 0, 0, 1, 0, 0);
		slice:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -SIZE-Ix,Oy);
		slice:SetWidth(Ox-Ix);
		slice:SetHeight(Iy-Oy);
		slice:Show(); 
	elseif quadrant == 4 then --inside 4
		--hides
		ring4:Hide();
		--shows
		ring1:Show();
		ring2:Show();
		ring3:Show();
		
		--partial
		red:SetTexCoord(IxCoord, 0, 0, 0, IxCoord, IyCoord, 0, IyCoord);
		red:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, SIZE);
		red:SetWidth(Iy);
		red:SetHeight(Ix);
		red:Show();
		
		blue:SetTexCoord(OxCoord, 0, IxCoord, 0, OxCoord, OyCoord, IxCoord, OyCoord);
		blue:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, SIZE+Ix);
		blue:SetWidth(Oy);
		blue:SetHeight(Ox-Ix);
		blue:Show();
		
		slice:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1);
		slice:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", Oy,SIZE+Ix);
		slice:SetWidth(Iy-Oy);
		slice:SetHeight(Ox-Ix);
		slice:Show(); 
	else
		print("ERROR: Quadrant Exceded 4!");
	end
	
	--slice fix
	if p == 25 then
		slice:Hide();
	else
		slice:Show();
	end
end

function Circle_Cast2_SpellCast_Start(self, start, name, duration, icon)
	self.spellname  = name;
	self.startTime  = start /1000;
	self.maxValue   = self.startTime + (duration / 1000);
	self.casting    = true;
	self.channeling = nil;
	self.duration   = floor(duration / 100) / 10;
	
	_G["Player_Ring_Icon"]:SetTexture(icon);	
	_G["Player_Ring_Icon"]:Show();
	
	_G["Player_Ring"]:Show();
	
	local _, _, lag = GetNetStats();
	local ping = ((lag / 1000) / self.duration) * 100;
	Circle_Cast2_SetBarHeight(_G["Player_Ring_Ping"], ping, true);
end

function Circle_Cast2_SpellChannel_Start(self, start, name, duration, icon)
	self.spellname  = name;
	self.startTime  = start /1000;
	self.maxValue   = self.startTime + (duration / 1000);
	self.casting    = nil;
	self.channeling = true;
	self.duration   = floor(duration / 100) / 10;
	
	_G["Player_Ring_Icon"]:SetTexture(icon);
	_G["Player_Ring_Icon"]:Show();
	
	_G["Player_Ring"]:Show();
	
	local _, _, lag = GetNetStats();
	local ping = ((lag / 1000) / self.duration) * 100;
	Circle_Cast2_SetBarHeight(_G["Player_Ring_Ping"], ping);
end 

function Circle_Cast2_SpellCast_TargetStart(self, start, name, duration, icon, notI)
	self.spellname_target  = name;
	self.startTime_target  = start /1000;
	self.maxValue_target   = self.startTime_target + (duration / 1000);
	self.casting_target    = true;
	self.channeling_target = nil;
	self.duration_target   = floor(duration / 100) / 10;
	
	Circle_Cast2_InteruptColor(notI)
	
	_G["Target_Ring"]:Show();
end 

function Circle_Cast2_SpellChannel_TargetStart(self, start, name, duration, icon, notI)
	self.spellname_target  = name;
	self.startTime_target  = start /1000;
	self.maxValue_target   = self.startTime_target + (duration / 1000);
	self.casting_target    = nil;
	self.channeling_target = true;
	self.duration_target   = floor(duration / 100) / 10;
	
	Circle_Cast2_InteruptColor(notI)
	
	_G["Target_Ring"]:Show();
end

function Circle_Cast2_InteruptColor(notI)
	if notI then
		for i = 1, 7 do
			_G["Target_Ring"..CC2_parts[i]]:SetVertexColor(Circle_Cast2_Get_Color("Target_Ring", "InteruptColor"));
		end
	else
		for i = 1, 7 do
			_G["Target_Ring"..CC2_parts[i]]:SetVertexColor(Circle_Cast2_Get_Color("Target_Ring"));
		end
	end
end