script_name('TaserInfo')
script_author('Ben_Puls')
script_description('Taser and Siren info')
require 'lib.moonloader'
local ini = require 'inicfg'
local nCfg = 'taserinfo.ini'
local cfg = ini.load({ pos = { posX = 500, posY = 500 }, taser = { lock = true, size = 20,  font = 73}, siren = { lock = true } }, nCfg)
local move = false
local font = renderCreateFont('Arial', cfg.taser.size, cfg.taser.taserstyle)
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
        sampAddChatMessage("{58c9b1}[TaserInfo by Ben Puls] {ffffff}������� ������� (/taserinfo, /tasers, /sirens, /taserpos, /tasersize, /taserstyle)", -1)
        print("Has been started by Ben Puls")
        sampRegisterChatCommand('taserpos', function() move = not move end)
        sampRegisterChatCommand("taserinfo", function ()
            sampShowDialog(6405, 'Taser and Siren by Ben Puls', '{FFFFFF}���������:\nTaser: ' .. (cfg.taser.lock and "{AAFFAA}�������" or "{FFAAAA}��������")..'\n{FFFFFF}Siren: ' .. (cfg.siren.lock and "{AAFFAA}�������" or "{FFAAAA}��������")..'\n{FFFFFF}Size: {AAFFAA}'.. cfg.taser.size .. '\n{FFFFFF}Style: {AAFFAA}'.. cfg.taser.style ..'\n{FFFFFF}Position oX, oY: {AAFFAA}'..cfg.pos.posX..'{FFFFFF}, {AAFFAA}'..cfg.pos.posY ..'\n\n{FFFFFF}��������:\n������ ���������� ������� ������� � ���������.\n� ����� ��������� ������� ������.\n\n�������� �������:\n{B8FF02}/taserinfo{FFFFFF} - �������� ������� {B8FF02}\n/tasers {FFFFFF}- ���������/���������� �������\n{B8FF02}/sirens {FFFFFF} - ���������/���������� ������ {B8FF02}\n/taserpos {FFFFFF}- ��������� ��������� �����������\n{B8FF02}/tasersize 3-35 {FFFFFF}- ��������� �������� ������\n{B8FF02}/taserstyle 1-100{FFFFFF} - ��������� ����� ������', '�������', '', DIALOG_STYLE_MSGBOX)
        end)
        sampRegisterChatCommand("tasers", function()
            cfg.taser.lock = not cfg.taser.lock
            if ini.save(cfg, nCfg) then
                sampAddChatMessage("{58c9b1}[TaserInfo]{FFFFFF} ����������� �������: " .. (cfg.taser.lock and "{AAFFAA}��������" or "{FFAAAA}���������"), 0xEEEEEE)
            end
        end)
        sampRegisterChatCommand("tasersize", function(number)
            number = tonumber(number)
            if number ~= nil and (number >= 3 and number <= 35) then
               cfg.taser.size = number          
               if ini.save(cfg, 'taserinfo.ini') then
                    font = renderCreateFont('Arial', cfg.taser.size, cfg.taser.style)
                    sampAddChatMessage("{58c9b1}[TaserInfo]{FFFFFF} ����� ������ ������: {AAFFAA}" .. cfg.taser.size, 0xEEEEEE)
                end 
            else 
                sampAddChatMessage("{58c9b1}[TaserInfo]{FFFFFF} �����������: {AAFFAA}/tasersize 3-35", 0xEEEEEE)
            end
        end)
        sampRegisterChatCommand("taserstyle", function(number)
            number = tonumber(number)
            if number ~= nil and (number >= 1 and number <= 100) then
               cfg.taser.style = number          
               if ini.save(cfg, 'taserinfo.ini') then
                    font = renderCreateFont('Arial', cfg.taser.size, cfg.taser.style)
                    sampAddChatMessage("{58c9b1}[TaserInfo]{FFFFFF} ����� ����� ������: {AAFFAA}" .. cfg.taser.style, 0xEEEEEE)
                end 
            else 
                sampAddChatMessage("{58c9b1}[TaserInfo]{FFFFFF} �����������: {AAFFAA}/taserstyle 1-100", 0xEEEEEE)
            end
        end)
        sampRegisterChatCommand("sirens", function()
            cfg.siren.lock = not cfg.siren.lock
            if ini.save(cfg, nCfg) then
                sampAddChatMessage("{58c9b1}[TaserInfo]{FFFFFF} ����������� �����: " .. (cfg.siren.lock and "{AAFFAA}��������" or "{FFAAAA}���������"), 0xEEEEEE)
            end
        end)
    while true do wait(0)     
        if move then
            showCursor(true)
            cfg.pos.posX, cfg.pos.posY = getCursorPos()
            if isKeyJustPressed(1) then
                if ini.save(cfg, 'taserinfo.ini') then
                    sampAddChatMessage('{58c9b1}[TaserInfo]{FFFFFF} ����� ��������� ������ (oX, oY): {AAFFAA}'.. cfg.pos.posX..', '..cfg.pos.posY, -1)
                    move = false
                    showCursor(false)
                end
            end
        end
        if cfg.taser.lock then
            if  hasCharGotWeapon(PLAYER_PED, 23) then
                renderFontDrawText(font,'{FFFFFF}Taser: {18EC18}ON!', cfg.pos.posX, cfg.pos.posY, 0xFFFFFF00)
            else 
                renderFontDrawText(font,'{FFFFFF}Taser: {FF0000}OFF', cfg.pos.posX, cfg.pos.posY, 0xFFFFFF00)
            end 
        end
        if cfg.siren.lock then
            if isCharInAnyCar(PLAYER_PED) then
                if isCarSirenOn(storeCarCharIsInNoSave(PLAYER_PED)) then
                   renderFontDrawText(font,'{FFFFFF}Siren: {18EC18}ON!', cfg.pos.posX, cfg.pos.posY + 30, 0xFFFFFF00)
                else 
                   renderFontDrawText(font,'{FFFFFF}Siren: {FF0000}OFF', cfg.pos.posX, cfg.pos.posY + 30, 0xFFFFFF00)
                end
            end 
        end
    end
end