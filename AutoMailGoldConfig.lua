-- Ensure our settings exist.
if not AMG_Settings then
    AMG_Settings = {
        recipient = "",
        percentage = 90
    }
end

-- Main Frame for options
local options = CreateFrame("Frame", "AutoMailGoldOptions", InterfaceOptionsFramePanelContainer)
options.name = "AutoMailGold"
InterfaceOptions_AddCategory(options)

-- Title
local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("AutoMailGold Options")

-- Recipient label
local recipientLabel = options:CreateFontString(nil, "ARTWORK", "GameFontNormal")
recipientLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -32)
recipientLabel:SetText("Recipient:")

-- Recipient input
local recipientEditBox = CreateFrame("EditBox", nil, options, "InputBoxTemplate")
recipientEditBox:SetAutoFocus(false)
recipientEditBox:SetWidth(200)
recipientEditBox:SetHeight(20)
recipientEditBox:SetPoint("LEFT", recipientLabel, "RIGHT", 10, 0)
recipientEditBox:SetScript("OnEditFocusLost", function(self)
    AMG_Settings.recipient = self:GetText()
end)
recipientEditBox:SetText(AMG_Settings.recipient)
options.recipientEditBox = recipientEditBox

-- Percentage label
local percentageLabel = options:CreateFontString(nil, "ARTWORK", "GameFontNormal")
percentageLabel:SetPoint("TOPLEFT", recipientLabel, "BOTTOMLEFT", 0, -32)
percentageLabel:SetText("Percentage:")

-- Percentage slider
local percentageSlider = CreateFrame("Slider", "AMG_PercentageSlider", options, "OptionsSliderTemplate")
percentageSlider:SetWidth(200)
percentageSlider:SetHeight(20)
percentageSlider:SetPoint("LEFT", percentageLabel, "RIGHT", 10, 0)
percentageSlider:SetMinMaxValues(0, 100)
percentageSlider:SetValueStep(1)
percentageSlider:SetObeyStepOnDrag(true)
percentageSlider:SetValue(AMG_Settings.percentage)
_G[percentageSlider:GetName() .. 'Low']:SetText('0%')
_G[percentageSlider:GetName() .. 'High']:SetText('100%')

-- Percentage input box (right of the slider)
local percentageEditBox = CreateFrame("EditBox", nil, options, "InputBoxTemplate")
percentageEditBox:SetAutoFocus(false)
percentageEditBox:SetWidth(50)
percentageEditBox:SetHeight(20)
percentageEditBox:SetPoint("LEFT", percentageSlider, "RIGHT", 10, 0)
percentageEditBox:SetMaxLetters(3)
percentageEditBox:SetNumber(AMG_Settings.percentage)
percentageEditBox:SetNumeric(true)  -- Accept only numeric input
percentageEditBox:SetScript("OnEnterPressed", function(self)
    self:ClearFocus()  -- Release focus after pressing Enter
end)
percentageEditBox:SetScript("OnTextChanged", function(self, userInput)
    if userInput then  -- Check if the change was due to user input
        local val = tonumber(self:GetText()) or 0
        val = math.min(100, math.max(0, val))  -- Ensure the value is between 0 and 100
        AMG_Settings.percentage = val
        percentageSlider:SetValue(val)
    end
end)

-- Synchronize slider and input box
percentageSlider:SetScript("OnValueChanged", function(self, value)
    AMG_Settings.percentage = math.floor(value)
    _G[self:GetName() .. 'Text']:SetText(AMG_Settings.percentage .. '%')
    percentageEditBox:SetNumber(AMG_Settings.percentage)
end)
