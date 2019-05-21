QuestieFramePool = {...} -- GLobal Functions
local _QuestieFramePool = {...} --Local Functions
local NumberOfFrames = 0

local unusedframes = {}

local allframes = {}

--TODO: Add all types
ICON_TYPE_AVAILABLE = "Interface\\Addons\\Questie\\Icons\\available.blp"
ICON_TYPE_SLAY = "Interface\\Addons\\Questie\\Icons\\slay.blp"
ICON_TYPE_COMPLETE = "Interface\\Addons\\Questie\\Icons\\complete.blp"
ICON_TYPE_ITEM = "Interface\\Addons\\Questie\\Icons\\item.blp"
ICON_TYPE_LOOT = "Interface\\Addons\\Questie\\Icons\\loot.blp"

-- Global Functions --
function QuestieFramePool:GetFrame()
	local f = tremove(unusedframes)
	if not f then
  	f = _QuestieFramePool:QuestieCreateFrame()
	end
	f.loaded = true;
	return f
end

--for i, frame in ipairs(allframes) do
--	if(frame.loaded == nil)then
--		return frame
--	end
--end

function QuestieFramePool:UnloadAll()

	Questie:Debug(DEBUG_DEVELOP, "[QuestieFramePool] Unloading all frames, count:", #allframes)
  for i, frame in ipairs(allframes) do
    _QuestieFramePool:UnloadFrame(frame);
  end
	qQuestIdFrames = {}
end


-- Local Functions --

--Use FRAME.Unload(FRAME) on frame object to unload!
function _QuestieFramePool:UnloadFrame(frame)
	--We are reseting the frames, making sure that no data is wrong.
  HBDPins:RemoveMinimapIcon(Questie, frame);
  HBDPins:RemoveWorldMapIcon(Questie, frame);
  frame.data = nil; -- Just to be safe
  frame.loaded = nil;
	table.insert(unusedframes, frame)
end

function _QuestieFramePool:QuestieCreateFrame()
	NumberOfFrames = NumberOfFrames + 1
	local f = CreateFrame("Button","QuestieFrame"..NumberOfFrames,nil)
  f:SetFrameStrata("TOOLTIP");
	f:SetWidth(16) -- Set these to whatever height/width is needed
	f:SetHeight(16) -- for your Texture
	local t = f:CreateTexture(nil,"TOOLTIP")
	--t:SetTexture("Interface\\Icons\\INV_Misc_Eye_02.blp")
	--t:SetTexture("Interface\\Addons\\!Questie\\Icons\\available.blp")
	t:SetWidth(16)
	t:SetHeight(16)
	t:SetAllPoints(f)
	f.texture = t;
	f:SetPoint("CENTER",0,0)
	f:EnableMouse()
	--f:SetScript('OnEnter', function() Questie:Print("Enter") end)
	--f:SetScript('OnLeave', function() Questie:Print("Leave") end)

  f:SetScript("OnEnter", function(self) _QuestieFramePool:Questie_Tooltip(self) end); --Script Toolip
  f:SetScript("OnLeave", function() if(WorldMapTooltip) then WorldMapTooltip:Hide() end if(GameTooltip) then GameTooltip:Hide() end end) --Script Exit Tooltip
  f:SetScript("OnClick", function(self) _QuestieFramePool:Questie_Click(self) end);
  f.Unload = function(frame) _QuestieFramePool:UnloadFrame(frame) end;
  f.data = {}
  f:Hide()
	table.insert(allframes, f)
	return f
end


function _QuestieFramePool:Questie_Tooltip(self)
  local Tooltip = GameTooltip;
  Tooltip:SetOwner(self, "ANCHOR_CURSOR"); --"ANCHOR_CURSOR" or (self, self)

  for k,v in pairs(self.data.tooltip) do
	Tooltip:AddLine(v);
  end
--	if(self.data.QuestData) then
--	  --TODO Logic for tooltip!
--	  Tooltip:AddLine("["..self.data.QuestData.Level.."] "..self.data.QuestData.Name);
--	  if(self.data.Starter.Type == "NPC") then
--	    Tooltip:AddLine("Started by: "..self.data.Starter.Name);
--	    -- Preferably call something outside, keep it "abstract" here
--	  end
--	elseif(self.data.NpcData) then
--		Tooltip:AddLine(self.data.NpcData.Name)
--	end


  Tooltip:SetFrameStrata("TOOLTIP");
  Tooltip:Show();
end

function _QuestieFramePool:Questie_Click(self)
  Questie:Print("Click!");
  --TODO Logic for click!
  -- Preferably call something outside, keep it "abstract" here
end
