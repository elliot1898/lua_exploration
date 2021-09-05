local function checkFormat(inStr_Elm, inInt_Index, in_Formats)
    local str_Format = in_Formats[inInt_Index]
    if (str_Format == "n_") then
        return inStr_Elm:match("%d+") == inStr_Elm
    elseif (str_Format == "s_") then
        return true
    elseif (str_Format == "b_") then
        return inStr_Elm == "true" or inStr_Elm == "false"
    end
    return false
end

local function formatByHead(inStr_Elm, inInt_Index, in_Formats)
    local str_Format = in_Formats[inInt_Index]
    if (str_Format == "n_") then
        return inStr_Elm
    elseif (str_Format == "s_") then
        return "\"" .. inStr_Elm .. "\""
    elseif (str_Format == "b_") then
        return inStr_Elm
    end
end

local function tableToLua(inStr_File)
    local file_Table = io.open(inStr_File, "r")
    if (file_Table == nil) then
        print(string.format("Unexisted file %s, please check the file name!", inStr_File))
        return
    end

    local str_Heads = file_Table:read()
    if (str_Heads == nil) then
        print("File is empty!")
        return
    end

    local _Heads = {}
    local _Formats = {}

    for str_Head in str_Heads:gmatch("%g+") do
        local str_Format = str_Head:sub(1, 2)
        if (str_Format ~= "n_" and str_Format ~= "s_" and str_Format ~= "b_") then
            print(string.format("Wrong format %s!", str_Format))
            return
        end
        table.insert(_Formats, str_Format)
        table.insert(_Heads, str_Head:sub(3))
    end

    local str_Result =
    "local config = require(\"ecs.config\")" .. "\n" ..
    "config(" .. "\n"..
    "{" .. "\n"

    local str_Row = file_Table:read()
    local int_RowIndex = 1
    while (str_Row ~= nil) do
        local _Row = {}
        for str_Elm in str_Row:gmatch("%g+") do
            table.insert(_Row, str_Elm)
        end

        if (_Row[1] ~= nil) then
            if (not checkFormat(_Row[1], 1, _Formats)) then
                print(string.format("Wrong format in the %d row, %d colomn!", int_RowIndex, 1))
                return
            end
            str_Result = str_Result .. "\t[" .. formatByHead(_Row[1], 1, _Formats) .. "] =" .. "\n"
            str_Result = str_Result .. "\t{" .. "\n"

            for i = 2, #_Formats do
                if (not checkFormat(_Row[i], i, _Formats)) then
                    print(string.format("Wrong format in the %d row, %d colomn!", int_RowIndex, i))
                    return
                end
                str_Result = str_Result .. "\t\t" .. _Heads[i] .. " = " .. formatByHead(_Row[i], i, _Formats) .. "," .. "\n"
            end

            str_Result = str_Result .. "\t}" .. "," .. "\n"
        end

        str_Row = file_Table:read()
        int_RowIndex = int_RowIndex + 1
    end
    str_Result = str_Result .. "}" .. "\n" ..
    ")"

    local int_Sep
    for i = #inStr_File, 1, -1 do
        if (inStr_File:sub(i, i) == ".") then
            int_Sep = i
            break
        end
    end

    local str_OutFile = inStr_File:sub(1, int_Sep) .. ".lua"

    local file_OutFile, str_Wrong = io.open(str_OutFile, "w")
    if (file_OutFile == nil) then
        print(str_Wrong)
        return
    end

    local file_OutFile1, str_Wrong1 = file_OutFile:write(str_Result)
    if (file_OutFile1 == nil) then
        print(str_Wrong1)
        return
    end
end

return tableToLua