local frame=CreateFrame("Frame");
frame:RegisterEvent("VARIABLES_LOADED");
frame:SetScript("OnEvent",function(self,event,...)
	if (IsAddOnLoaded("pfQuest")) then
		DEFAULT_CHAT_FRAME.editBox:SetText("/db rares") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
		DEFAULT_CHAT_FRAME.editBox:SetText("/db chests") ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
	end
end);