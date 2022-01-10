script_name = 'Paradox Toolbox'-------------------------- |````````````````````````````| --------------
script_prefix = '{B58FDB}[Paradox Toolbox] {ffffff}'----- | Если вам не важна -------- | -----------------------------------
script_author = 'ASKIT'------------------------------- | собственная репутация, --- | -------
script_version = '11.12.21'--------------------------- | можете удалить эти строки. | -----------
script_site = 'vk.com/moonstd'------------------------ |____________________________| --------------
script_color1 = '{B58FDB}'

require "lib.moonloader"
event = require 'lib.samp.events'
inicfg = require 'inicfg'
imgui = require 'imgui'
vkeys = require 'vkeys'
encoding = require 'encoding'
wm = require 'lib.windows.message'
fa = require 'fAwesome5'

direct_cfg = '../config/Paradox Toolbox.ini'
cfg = inicfg.load(inicfg.load({
    tab1 = {
        status = false,
        hotkey_open = true,
        hotkey_open1 = 18,
        hotkey_open2 = 81,
    },
    tab2 = {
        fisheye = false,
        fisheye_scale = 101,
        fix_openChat = false,
        fast_lock = false,
        fast_lock_hotkey = 76,
        radar_finder = false,
        radar_finder_distance = 80,
        clear_cnn = false,
    },
    tab3 = {
        autospeed = false,
        wallhack = false,
        textdraw_ids = false,
    },
    tab4 = {
        antiflood_work_wfactory = false,
        antiflood_fraction_materials = false,
        antiflood_fraction_rpchat = false,
        antiflood_fraction_nrpchat = false,
        antiflood_family = false,
    },
}, direct_cfg))
inicfg.save(cfg, direct_cfg)

encoding.default = 'cp1251'
u8 = encoding.UTF8
function recode(u8) return encoding.UTF8:decode(u8) end

resX, resY = getScreenResolution()
--=================================--
window_main = imgui.ImBool(false)

status = imgui.ImBool(cfg.tab1.status)
hotkey_open = imgui.ImBool(cfg.tab1.hotkey_open)
hotkey_open1 = imgui.ImInt(cfg.tab1.hotkey_open1)
hotkey_open2 = imgui.ImInt(cfg.tab1.hotkey_open2)

tab = imgui.ImInt(1)
fisheye = imgui.ImBool(cfg.tab2.fisheye)
fisheye_scale = imgui.ImInt(cfg.tab2.fisheye_scale)
fix_openChat = imgui.ImBool(cfg.tab2.fix_openChat)
fast_lock = imgui.ImBool(cfg.tab2.fast_lock)
fast_lock_hotkey = imgui.ImInt(cfg.tab2.fast_lock_hotkey)
radar_finder = imgui.ImBool(cfg.tab2.radar_finder)
radar_finder_distance = imgui.ImInt(cfg.tab2.radar_finder_distance)
clear_cnn = imgui.ImBool(cfg.tab2.clear_cnn)

textdraw_ids = imgui.ImBool(cfg.tab3.textdraw_ids)
autospeed = imgui.ImBool(cfg.tab3.autospeed)
wallhack = imgui.ImBool(cfg.tab3.wallhack)

antiflood_work_wfactory = imgui.ImBool(cfg.tab4.antiflood_work_wfactory)
antiflood_fraction_materials = imgui.ImBool(cfg.tab4.antiflood_fraction_materials)
antiflood_fraction_rpchat = imgui.ImBool(cfg.tab4.antiflood_fraction_rpchat)
antiflood_fraction_nrpchat = imgui.ImBool(cfg.tab4.antiflood_fraction_nrpchat)
antiflood_family = imgui.ImBool(cfg.tab4.antiflood_family)

radio = imgui.ImInt(cfg.tab4.radio)
--=================================--
devside = false
clist = 0
font = renderCreateFont('Arial', 8, 5)

tabs = {
    fa.ICON_FA_GLOBE_ASIA..u8' Настройки',
    fa.ICON_FA_COGS..u8' Основное',
    fa.ICON_FA_SPINNER..u8' В разработке',
    fa.ICON_FA_SPINNER..u8' Антифлуд',
}


-- radio = { 'https://radioheart.ru:9024/RH55420', }


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    -- Команды.
        sampRegisterChatCommand('mtb', cmd_mtb)

    -- Функции.
        Process()

    -- Аудио стримы.
        -- radio_paradoxfm = loadAudioStream('https://a4.radioheart.ru:8024/RH55420')
        -- radio_record = loadAudioStream('https://radio-srv1.11one.ru/record192k.mp3')
        -- radio_europaplus = loadAudioStream('http://ep128.hostingradio.ru:8030/ep128')

end

-- Основная команда.
function cmd_mtb(arg)
    if arg == '' then
        window_main.v = not window_main.v
        imgui.Process = window_main.v
    elseif arg == 'dev' then
        devside = not devside
        sampAddChatMessage('Скин: '..getCharModel(PLAYER_PED), -1)
    elseif arg == 'coord' then
        player_x, player_y, player_z = getCharCoordinates(PLAYER_PED)
        sampAddChatMessage(script_prefix..'Ваши координаты: '..player_x..' | '..player_y..' | '..player_z, -1)
        setClipboardText(player_x..', '..player_y..', '..player_z)
        -- setClipboardText('x='..player_x..', y='..player_y)
    elseif arg == 'reload' then
        scriptReload()
    end
end


local fa_font_14 = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
    if fa_font_14 == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true

        fa_font_14 = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end


-- Отрисовка ImGui.
function imgui.OnDrawFrame()

    if window_main.v then
        imgui.SetNextWindowPos(imgui.ImVec2(resX/3, resY/3), 2, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(script_name..' - '..script_version, window_main, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
        imgui.PushFont(fa_font_14)

            imgui.SetCursorPos(imgui.ImVec2(0, 45))
            imgui.CustomMenu(tabs, tab, imgui.ImVec2(135, 30), _, true)

            imgui.PushCustomStyle('var', 'WindowPadding', 20, 20)
            imgui.SetCursorPos(imgui.ImVec2(150, 35))
            imgui.BeginChild('##main', imgui.ImVec2(700, 400), true)
                if tab.v == 1 then -- Настройки скрипта.

                    if imgui.Checkbox('##hotkey_open', hotkey_open) then
                        cfg.tab1.hotkey_open = hotkey_open.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Включить быстрое открытие окна скрипта.\nДля установки горячих клавиш, используйте их номера.')
                    imgui.SameLine()
                    imgui.PushItemWidth(35)
                    imgui.sInputInt('##hotkey_open1', hotkey_open1, 'hotkey_open1', 0, 0)
                    imgui.SameLine()
                    imgui.sInputInt('Быстрое открытие', hotkey_open2, 'hotkey_open2', 0, 0)
                    imgui.Spacing() imgui.Separator() imgui.Spacing()

                elseif tab.v == 2 then -- Основное.

                    if imgui.Checkbox('##fisheye', fisheye) then
                        cfg.tab2.fisheye = fisheye.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Увеличение угла обзора.\nСтандарт - 70, Мин - 30, Макс - 101')
                    imgui.SameLine()
                    imgui.PushItemWidth(35)
                    imgui.sInputInt('Увеличить FOV', fisheye_scale, 'fisheye_scale', 0, 0)
                    if imgui.Checkbox(u8'Чат на Т', fix_openChat) then
                        cfg.tab2.fix_openChat = fix_openChat.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Чат будет открываться на русской раскладке.')
                    if imgui.Checkbox(u8'##fast_lock', fast_lock) then
                        cfg.tab2.fast_lock = fast_lock.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Закрытие/Открытие ТС на клавишу.')
                    imgui.SameLine()
                    imgui.sInputInt('Fast /lock', fast_lock_hotkey, 'fast_lock_hotkey', 0, 0) imgui.Question('Горячая клавиша.')
                    if imgui.Checkbox(u8'##radar_finder', radar_finder) then
                        cfg.tab2.radar_finder = radar_finder.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Предупреждение о радарах.')
                    imgui.SameLine()
                    imgui.sInputInt('Radar Finder', radar_finder_distance, 'radar_finder_distance', 0, 0) imgui.Question('Дистанция срабатывания.')
                    if imgui.Checkbox(u8'CNN Clear', clear_cnn) then
                        cfg.tab2.clear_cnn = clear_cnn.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Удалять все объявления кроме ваших.')

                    -- ===== Для разработчикА ===== --

                elseif devside and tab.v == 3 then

                    if imgui.Checkbox(u8'* Wallhack', wallhack) then
                        cfg.tab3.wallhack = wallhack.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Увеличение скорости передвижения.')
                    if imgui.Checkbox(u8'* Автоподжим', autospeed) then
                        cfg.tab3.autospeed = autospeed.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Увеличение скорости передвижения.')

                    if imgui.Checkbox(u8'Textdraw IDs', textdraw_ids) then
                        cfg.tab3.textdraw_ids = textdraw_ids.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Отображает айди всех текстдравов.')
                    imgui.ShowStyleEditor()

                elseif tab.v == 4 then

                    if imgui.Checkbox(u8'[Работа] Оружейный завод', antiflood_work_wfactory) then
                        cfg.tab4.antiflood_work_wfactory = antiflood_work_wfactory.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Удалять все сообщения на работе "Оружейный завод".')

                    if imgui.Checkbox(u8'[Организация] Материалы', antiflood_fraction_materials) then
                        cfg.tab4.antiflood_fraction_materials = antiflood_fraction_materials.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Удалять все сообщения о операциях с материалами (положил/взял).')

                    if imgui.Checkbox(u8'[Организация] РП чат', antiflood_fraction_rpchat) then
                        cfg.tab4.antiflood_fraction_rpchat = antiflood_fraction_rpchat.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Удалять все сообщения из РП чата организации.')

                    if imgui.Checkbox(u8'[Организация] Нон РП чат', antiflood_fraction_nrpchat) then
                        cfg.tab4.antiflood_fraction_nrpchat = antiflood_fraction_nrpchat.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Удалять все сообщения из Нон РП чата организации.')

                    if imgui.Checkbox(u8'[Семья] РП чат', antiflood_family) then
                        cfg.tab4.antiflood_family = antiflood_family.v
                        inicfg.save(cfg, direct_cfg)
                    end imgui.Question('Удалять все сообщения из РП чата семьи.\n- Важные сообщения будут отображаться')

                end
            imgui.EndChild()
            imgui.PopCustomStyle('var')

        imgui.PopFont()
        imgui.End()
    end

    if not window_main.v then imgui.ShowCursor = false else imgui.ShowCursor = true end

end


-- Process
function Process()
    lua_thread.create(function()
        while true do wait(0)

            -- Получение информации о Игроке.
            player_id_result, player_id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            player_name = sampGetPlayerNickname(player_id)
            -- player_score = sampGetPlayerScore(player_id)
            -- player_ping = sampGetPlayerPing(player_id)
            -- player_health = sampGetPlayerHealth(player_id)
            -- player_armor = sampGetPlayerArmor(player_id)
            -- player_color = '{'..RGBtoHEX(sampGetPlayerColor(player_id))..'}'

            -- Радио.
            if isCharInAnyCar(PLAYER_PED) and getRadioChannel(PLAYER_PED) < 12 then setRadioChannel(12) end
            -- if cfg.tab4.radio == 0 then
            --     setAudioStreamState(radio_paradoxfm, 0)
            --     setAudioStreamState(radio_record, 0)
            --     setAudioStreamState(radio_europaplus, 0)
            -- elseif cfg.tab4.radio == 1 then
            --     setAudioStreamState(radio_paradoxfm, 1)
            --     setAudioStreamState(radio_record, 0)
            --     setAudioStreamState(radio_europaplus, 0)
            -- elseif cfg.tab4.radio == 2 then
            --     setAudioStreamState(radio_paradoxfm, 0)
            --     setAudioStreamState(radio_record, 1)
            --     setAudioStreamState(radio_europaplus, 0)
            -- elseif cfg.tab4.radio == 3 then
            --     setAudioStreamState(radio_paradoxfm, 0)
            --     setAudioStreamState(radio_record, 0)
            --     setAudioStreamState(radio_europaplus, 1)
            -- end

            -- Увеличение скорости передвижения.
            if cfg.tab3.autospeed and not sampIsCursorActive() then
                bike = {[481] = true, [509] = true, [510] = true}
                moto = {[448] = true, [461] = true, [462] = true, [463] = true, [468] = true, [471] = true, [521] = true, [522] = true, [523] = true, [581] = true, [586] = true}
                if isCharOnAnyBike(playerPed) and isKeyDown(0xA0) then    -- onBike&onMoto SpeedUP [[LSHIFT]] --
                    if bike[getCarModel(storeCarCharIsInNoSave(playerPed))] then
                        setGameKeyState(16, 255)
                        wait(10)
                        setGameKeyState(16, 0)
                    elseif moto[getCarModel(storeCarCharIsInNoSave(playerPed))] then
                        setGameKeyState(1, -128)
                        wait(10)
                        setGameKeyState(1, 0)
                    end
                end
                
                if isCharOnFoot(playerPed) and isKeyDown(0x31) then -- onFoot&inWater SpeedUP [[1]] --
                    setGameKeyState(16, 256)
                    wait(50)
                    setGameKeyState(16, 0)
                elseif isCharInWater(playerPed) and isKeyDown(0x31) then
                    setGameKeyState(16, 256)
                    wait(0)
                    setGameKeyState(16, 0)
                end
            end

            if cfg.tab3.wallhack then

                --

            end


            -- Быстрое открытие окна скрипта.
            if cfg.tab1.hotkey_open and isKeyDown(cfg.tab1.hotkey_open1) and isKeyJustPressed(cfg.tab1.hotkey_open2) and not sampIsCursorActive() then
                window_main.v = not window_main.v
                imgui.Process = window_main.v
            end
    
            -- Увеличение FOV.
            if cfg.tab2.fisheye and cfg.tab2.fisheye_scale >= 30 and cfg.tab2.fisheye_scale <= 101 then
                cameraSetLerpFov(cfg.tab2.fisheye_scale, cfg.tab2.fisheye_scale, 1000, 1)
            else
                cameraSetLerpFov(70.0, 70.0, 1000, 1)
            end

            -- Fast Lock.
            if cfg.tab2.fast_lock and isKeyJustPressed(cfg.tab2.fast_lock_hotkey) and not sampIsCursorActive() then
                sampSendChat('/lock')
            end

            -- Radar Finder.
            if cfg.tab2.radar_finder then
                for _, v in pairs(getAllObjects()) do
                    local asd
                    if sampGetObjectSampIdByHandle(v) ~= -1 then
                        asd = sampGetObjectSampIdByHandle(v)
                    end
                    if isObjectOnScreen(v) then
                        local model_result, model_x, model_y, model_z = getObjectCoordinates(v)
                        local model = getObjectModel(v)
                        local player_x, player_y, player_z = getCharCoordinates(PLAYER_PED)
                        local distance = getDistanceBetweenCoords3d(model_x, model_y, model_z, player_x, player_y, player_z)
                        if model == 18880 and isCharInCar(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED)) then
                            local speed = getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED))
                            local carSpeed = math.ceil(speed)
                            -- printStyledString(carSpeed, 500, 7)
                            if speed > 24 and distance < cfg.tab2.radar_finder_distance then printStyledString('RADAR', 10, 5) end
                        end
                    end
                end
            end

            -- Фикс чата.
            if cfg.tab2.fix_openChat and isKeyJustPressed(VK_T) and not sampIsCursorActive() then
                sampSetChatInputEnabled(true)
            end

            -- ID текстдравов.
            if cfg.tab3.textdraw_ids then
                for a = 0, 2304 do
                    if sampTextdrawIsExists(a) then
                        x, y = sampTextdrawGetPos(a)
                        x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y)
                        renderFontDrawText(font, a, x1, y1, 0xFFBEBEBE)
                    end
                end
            end

        end
    end)
end


-- Кастомные элементы.
function imgui.sInputInt(title, var, var_string, is1, is2)
    if imgui.InputInt(u8(title), var, is1, is1) then
        cfg.tab1[var_string] = var.v
        inicfg.save(cfg, direct_cfg)
    end
end
function imgui.sInputText(title, var, var_string)
    if imgui.InputText(u8(title), var) then
        cfg.tab1[var_string] = var.v
        inicfg.save(cfg, direct_cfg)
    end
end
function imgui.PushCustomStyle(type, class, vec1, vec2)
    if type == 'var' then
        imgui.PushStyleVar(imgui.StyleVar[class], imgui.ImVec2(vec1, vec2))
    end
end
function imgui.PopCustomStyle(type)
    if type == 'var' then
        imgui.PopStyleVar()
    elseif type == 'color' then
        imgui.PopStyleColor()
    end
end


-- Обработка сообщений.
function event.onServerMessage(color, text)

    -- CNN Clear.
    if cfg.tab2.clear_cnn then
        if text:find('.+ Отправил: %w+_%w+ %[%d+%] %(тел. %d+%)') then
            return false
        elseif text:find('.+ Отправил: '..player_name..' %[%d+%] %(тел. %d+%)') then
        end
        if text:find('Объявление отредактировал сотрудник CNN') then
            return false
        end
    end

    if cfg.tab4.antiflood_work_wfactory and getCharModel(PLAYER_PED) == 27 then
        if text:find('Отправляйтесь за ящиком с заготовкой, который лежит на полке.') then return false end
        if text:find('Замечательно! Теперь отправляйтесь к рабочему столу, чтобы собрать оружие') then return false end
        if text:find('Склад отмечен') then return false end
        if text:find('Вы успешно собрали оружие, отнесите его на склад') then return false end
        if text:find('Вы положили готовое оружие на склад. Продолжайте в том же духе!') then return false end
        if text:find('У Вас не получилось собрать оружие. Попробуйте заново!') then return false end
        if text:find('Возьмите ящик с заготовкой с полки.') then return false end
        if text:find('К сожалению, Вам попалась бракованная заготовка, собрать оружие не удалось') then return false end
        if text:find('Отправляйтесь к полке и возьмите ящик с заготовкой снова.') then return false end
    end

    if cfg.tab4.antiflood_fraction_materials then
        if text:find('%w+_%w+ взял со склада %d+ ед. материалов') then return false end
        if text:find('%w+_%w+ положил на склад %d+ ед. материалов') then return false end
    end

    if cfg.tab4.antiflood_fraction_rpchat then
        if text:find('%[F%] %w+ '..player_name..' %[%d+%]: .+') then -- Нелегал
        elseif text:find('%[F%] %w+ %w+_%w+ %[%d+%]: .+') then
            return false
        end
        if text:find('%[R%] %w+ '..player_name..' %[%d+%]: .+') then -- Гос
        elseif text:find('%[R%] %w+ %w+_%w+ %[%d+%]: .+') then
            return false
        end
    end

    if cfg.tab4.antiflood_fraction_nrpchat then
        if text:find('%(%( %[F%] %w+ '..player_name..' %[%d+%]: .+ %)%)') then -- Нелегал
        elseif text:find('%(%( %[F%] %w+ %w+_%w+ %[%d+%]: .+ %)%)') then
            return false
        end
        if text:find('%(%( %[R%] %w+ '..player_name..' %[%d+%]: .+ %)%)') then -- Гос
        elseif text:find('%(%( %[R%] %w+ %w+_%w+ %[%d+%]: .+ %)%)') then
            return false
        end
    end

    if cfg.tab4.antiflood_family then
        if text:find('%[FC%] .+ '..player_name..' %[%d+%]: .+') then
        elseif text:find('%[FC%] .+ %w+_%w+ %[%d+%]: ВАЖНО: .+') then
        elseif text:find('%[FC%] .+ %w+_%w+ %[%d+%]: ВНИМАНИЕ: .+') then
        elseif text:find('%[FC%] .+ %w+_%w+ %[%d+%]: .+') then
            return false
        end
    end

end


-- Подсказка.
function imgui.Question(text)
    if imgui.IsItemHovered() then
        imgui.PushCustomStyle('var', 'WindowPadding', 10, 10)
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextColoredRGB(script_color1..fa.ICON_FA_INFO_CIRCLE..u8' Подсказка:\n'..text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
        imgui.PopCustomStyle('var')
    end 
end


-- Цветной текст
function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b 
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4() 
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n 
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w) 
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], (text[i]))
                    imgui.SameLine(nil, 0) 
                end
                imgui.NewLine()
            else imgui.Text(u8(w))
            end 
        end 
    end

    render_text(text) 
end


-- Закрытие окна ImGui на ESC.
function onWindowMessage(msg, wparam, lparam)

    if wparam == vkeys.VK_ESCAPE and window_main.v then
        if msg == wm.WM_KEYDOWN then
            consumeWindowMessage(true, false)
        end
        if msg == wm.WM_KEYUP then
            window_main.v = false
        end
    end

end


-- labels - Array - названия элементов меню
-- selected - imgui.ImInt() - выбранный пункт меню
-- size - imgui.ImVec2() - размер элементов
-- speed - float - скорость анимации выбора элемента (необязательно, по стандарту - 0.2)
-- centering - bool - центрирование текста в элементе (необязательно, по стандарту - false)
function imgui.CustomMenu(labels, selected, size, speed, centering)
    local bool = false
    speed = speed and speed or 0.2
    local radius = size.y * 0.50
    local draw_list = imgui.GetWindowDrawList()
    if LastActiveTime == nil then LastActiveTime = {} end
    if LastActive == nil then LastActive = {} end
    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
    for i, v in ipairs(labels) do
        local c = imgui.GetCursorPos()
        local p = imgui.GetCursorScreenPos()
        if imgui.InvisibleButton(v..'##'..i, size) then
            selected.v = i
            LastActiveTime[v] = os.clock()
            LastActive[v] = true
            bool = true
        end
        imgui.SetCursorPos(c)
        local t = selected.v == i and 1.0 or 0.0
        if LastActive[v] then
            local time = os.clock() - LastActiveTime[v]
            if time <= 0.3 then
                local t_anim = ImSaturate(time / speed)
                t = selected.v == i and t_anim or 1.0 - t_anim
            else
                LastActive[v] = false
            end
        end
        local col_bg = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.ButtonActive] or imgui.ImVec4(0,0,0,0))
        local col_box = imgui.GetColorU32(selected.v == i and imgui.GetStyle().Colors[imgui.Col.Button] or imgui.ImVec4(0,0,0,0))
        local col_hovered = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
        local col_hovered = imgui.GetColorU32(imgui.ImVec4(col_hovered.x, col_hovered.y, col_hovered.z, (imgui.IsItemHovered() and 0.2 or 0)))
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + t * size.x, p.y + size.y), col_bg, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x-size.x/6, p.y), imgui.ImVec2(p.x + (radius * 0.65) + size.x, p.y + size.y), col_hovered, 10.0)
        draw_list:AddRectFilled(imgui.ImVec2(p.x, p.y), imgui.ImVec2(p.x+5, p.y + size.y), col_box)
        imgui.SetCursorPos(imgui.ImVec2(c.x+(centering and (size.x-imgui.CalcTextSize(v).x)/2 or 15), c.y+(size.y-imgui.CalcTextSize(v).y)/2))
        imgui.Text(v)
        imgui.SetCursorPos(imgui.ImVec2(c.x, c.y+size.y))
    end
    return bool
end


-- Перезагрузка скрипта.
function scriptReload()
    thisScript():reload()
    sampAddChatMessage(script_prefix..'Скрипт перезагружен.', -1)
end


-- Применение стиля.
function SapphireStyle()

    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(10, 10)
    style.WindowRounding = 8
    style.ChildWindowRounding = 8
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.FramePadding = ImVec2(6, 4)
    style.FrameRounding = 5
    style.IndentSpacing = 0
    style.ItemSpacing = ImVec2(8, 3)
    style.ItemInnerSpacing = ImVec2(4, 4)
    style.GrabMinSize = 5
    style.GrabRounding = 8

    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.16, 0.17, 0.20, 1.00);
    colors[clr.ChildWindowBg]          = ImVec4(0.00, 0.00, 0.00, 0.00);
    colors[clr.PopupBg]                = ImVec4(0.22, 0.23, 0.27, 1.00);
    colors[clr.Border]                 = ImVec4(0.22, 0.24, 0.27, 0.80);
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00);
    colors[clr.FrameBg]                = ImVec4(0.22, 0.24, 0.27, 0.80);
    colors[clr.FrameBgHovered]         = ImVec4(0.22, 0.24, 0.27, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.22, 0.24, 0.27, 0.67);
    colors[clr.TitleBg]                = ImVec4(0.22, 0.24, 0.27, 0.93);
    colors[clr.TitleBgActive]          = ImVec4(0.22, 0.24, 0.27, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.22, 0.24, 0.27, 0.67);
    colors[clr.MenuBarBg]              = ImVec4(0.22, 0.24, 0.27, 0.80);
    colors[clr.ScrollbarBg]            = ImVec4(0.22, 0.24, 0.27, 0.80);
    colors[clr.ScrollbarGrab]          = ImVec4(0.71, 0.56, 0.86, 0.93);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.71, 0.56, 0.86, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.71, 0.56, 0.86, 0.67);
    colors[clr.ComboBg]                = ImVec4(0.22, 0.24, 0.27, 0.99);
    colors[clr.CheckMark]              = ImVec4(0.71, 0.56, 0.86, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.30);
    colors[clr.SliderGrabActive]       = ImVec4(0.71, 0.56, 0.86, 1.00);
    colors[clr.Button]                 = ImVec4(0.71, 0.56, 0.86, 0.87);
    colors[clr.ButtonHovered]          = ImVec4(0.71, 0.56, 0.86, 1.00);
    colors[clr.ButtonActive]           = ImVec4(0.71, 0.56, 0.86, 0.67);
    colors[clr.Header]                 = ImVec4(0.71, 0.56, 0.86, 0.87);
    colors[clr.HeaderHovered]          = ImVec4(0.71, 0.56, 0.86, 1.00);
    colors[clr.HeaderActive]           = ImVec4(0.71, 0.56, 0.86, 0.67);
    colors[clr.Separator]              = ImVec4(0.22, 0.24, 0.27, 0.80);
    colors[clr.SeparatorHovered]       = ImVec4(0.22, 0.24, 0.27, 1.00);
    colors[clr.SeparatorActive]        = ImVec4(0.22, 0.24, 0.27, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(1.00, 1.00, 1.00, 0.30);
    colors[clr.ResizeGripHovered]      = ImVec4(1.00, 1.00, 1.00, 0.60);
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 1.00, 1.00, 0.90);
    colors[clr.CloseButton]            = ImVec4(0.16, 0.17, 0.20, 0.80);
    colors[clr.CloseButtonHovered]     = ImVec4(0.16, 0.17, 0.20, 1.00);
    colors[clr.CloseButtonActive]      = ImVec4(0.16, 0.17, 0.20, 0.60);
    colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(0.71, 0.56, 0.86, 0.31);
    colors[clr.ModalWindowDarkening]   = ImVec4(0.16, 0.17, 0.20, 0.35);

end SapphireStyle()