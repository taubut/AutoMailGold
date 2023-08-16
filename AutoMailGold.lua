local frame = CreateFrame("Frame")

frame:RegisterEvent("MAIL_SHOW")

frame:SetScript("OnEvent", function()
    local totalGold = GetMoney()
    local mailGold = totalGold * (AMG_Settings.percentage / 100)
    
    if totalGold > 0 and mailGold >= 1 and AMG_Settings.recipient ~= "" then
        SetSendMailMoney(math.floor(mailGold))
        SendMail(AMG_Settings.recipient, "Auto Mail Gold", "")
    end
end)
