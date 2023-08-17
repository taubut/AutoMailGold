-- Ensure the settings table exists
if not AMG_Settings then
    AMG_Settings = {
        recipient = "",
        percentage = 90,
        confirmBeforeSending = true  -- Default value
    }
end 

local frame = CreateFrame("Frame")

frame:RegisterEvent("MAIL_SHOW")

-- Function to convert copper into gold, silver, and copper values
local function ConvertCoppersToGoldSilverCopper(coppers)
    local gold = math.floor(coppers / 10000)
    coppers = coppers % 10000
    local silver = math.floor(coppers / 100)
    local copper = coppers % 100
    return gold, silver, copper
end

-- Function to send the gold
local function SendTheMail(mailGoldAmount)
    if AMG_Settings.recipient ~= "" then
        SetSendMailMoney(math.floor(mailGoldAmount))
        SendMail(AMG_Settings.recipient, "Auto Mail Gold", "")
    end
end

frame:SetScript("OnEvent", function()
    local totalGoldInCoppers = GetMoney()
    local mailGoldInCoppers = totalGoldInCoppers * (AMG_Settings.percentage / 100)

    -- Check if we have more than 1 gold worth of coppers to send
    if totalGoldInCoppers > 0 and mailGoldInCoppers >= 10000 and AMG_Settings.recipient ~= "" then
        if AMG_Settings.confirmBeforeSending then
            local gold, silver, copper = ConvertCoppersToGoldSilverCopper(mailGoldInCoppers)
            StaticPopupDialogs["AMG_CONFIRM_SEND"] = {
                text = string.format("Do you want to send %d gold, %d silver, and %d copper to %s?", gold, silver, copper, AMG_Settings.recipient),
                button1 = "Yes",
                button2 = "No",
                OnAccept = function() SendTheMail(mailGoldInCoppers) end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
                preferredIndex = 3,  -- Use a unique index number for the static popup
            }
            StaticPopup_Show("AMG_CONFIRM_SEND")
        else
            SendTheMail(mailGoldInCoppers)
        end
    end
end)
