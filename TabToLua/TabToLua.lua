local function getFileList()
	local _FolderHandle = io.popen("dir /b Tab_Config")
	local _FileList = {}

	if (_FolderHandle ~= nil) then
		for file in _FolderHandle:lines() do
			table.insert(_FileList, file)
		end
	end
    _FolderHandle:close()
	return _FileList
end

local function formatByPrefix(inStr_Elm, inInt_Index, in_Prefix)
    if (inStr_Elm == "nil") then
        return
    end

    local str_Format = in_Prefix[inInt_Index]
    if (str_Format == "s") then
        return "\"" .. inStr_Elm .. "\""

    else
        if (inStr_Elm == "") then
            return
        end

        if (str_Format == "u") then
            return inStr_Elm

        elseif (str_Format == "n") then
            return tonumber(inStr_Elm)

        elseif (str_Format == "b") then
            if (inStr_Elm == "TRUE") then
                return "true"
            elseif (inStr_Elm == "FALSE") then
                return "false"
            end
        end
    end
end

local function findKeyInTable(in_Key, in_Table)
    local int_Index = 1
    local bool_Find = false
    for index, _KVTable in ipairs(in_Table) do
        if (_KVTable[1] >= in_Key) then
            if (_KVTable[1] == in_Key) then
                bool_Find = true
            end
            break
        end
        int_Index = index + 1
    end
    return int_Index, bool_Find
end

local function convertFileToTable(inStr_File)
    -- 获取文件句柄
    local file_Table = io.open("Tab_Config/" .. inStr_File, "r")
    local str_Heads = file_Table:read()
    if (str_Heads == nil) then
        print("File is empty!")
        return
    end

    local _Prefixs = {}         -- 表头前缀
    local _HeadNames = {}       -- 表头名
    local _Suffixs = {}         -- 表头后缀

    -- 获取前缀、名、后缀
    for str_Head in str_Heads:gmatch("[^\t]+") do
        local _Temp = {}
        for word in str_Head:gmatch("[^_]+") do
            table.insert(_Temp, word)
        end

        local str_Format = _Temp[1]
        if (str_Format ~= "n" and str_Format ~= "s" and str_Format ~= "b" and str_Format ~= "u") then
            print("Wrong format \"" .. str_Format .. "\"!")
            return
        end

        table.insert(_Prefixs, str_Format)

        local str_HeadName = _Temp[2]
        if (str_HeadName:match("%d+") == str_HeadName) then
            str_HeadName = tonumber(str_HeadName)
        end
        table.insert(_HeadNames, str_HeadName)

        local _Suffix = {}
        if (_Temp[3] ~= nil) then
            for str_Suffix in _Temp[3]:gmatch("[^@]+") do
                if (str_Suffix:match("%d+") == str_Suffix) then
                    str_Suffix = tonumber(str_Suffix)
                end
                table.insert(_Suffix, str_Suffix)
            end
        end

        table.insert(_Suffixs, _Suffix)
    end
    file_Table:read()           -- 跳过备注行

    local _DataTable = {}       -- 用来存表

    -- 开始存表
    local str_Row = file_Table:read()
    local int_RowIndex = 1
    while (str_Row ~= nil) do
        local _Row = {}
        for str_Elm in str_Row:gmatch("[^\t]*") do
            table.insert(_Row, str_Elm)
        end

        local Key = formatByPrefix(_Row[1], 1, _Prefixs)
        if (Key ~= nil) then
            local int_Index, bool_Find = findKeyInTable(Key, _DataTable)
            if (bool_Find) then
                print("Exist two same ID!")
                return
            end
            table.insert(_DataTable, int_Index, {Key, {}})

            for i = 2, #_HeadNames do
                local key = _HeadNames[i]
                local value = formatByPrefix(_Row[i], i, _Prefixs)
                if (key ~= "comment" and value ~= nil) then
                    local _Suffix = _Suffixs[i]
                    local p = _DataTable[int_Index][2]       -- p指针定位最终存储数据的位置

                    for j = #_Suffix, 1, -1 do
                        local SuffixKey = _Suffix[j]
                        local index, bool_find = findKeyInTable(SuffixKey, p)
                        if (not bool_find) then
                            table.insert(p, index, {SuffixKey, {}})
                        end
                        p = p[index][2]
                    end

                    local index, bool_find = findKeyInTable(key, p)
                    if (bool_find) then
                        print("Exist two same HeadName!")
                        return
                    end
                    table.insert(p, index, {key, value})
                end
            end

        end

        str_Row = file_Table:read()
        int_RowIndex = int_RowIndex + 1
    end

    return _DataTable
end

local function printBlock(inInt_TabCount)
    local str_Tab = ""
    for i = 1, inInt_TabCount do
        str_Tab = str_Tab .. "  "
    end
    return str_Tab
end

local function printTable(inInt_TabCount, in_Table)
    local str_Table = "{" .. "\n"
    for _, _KVTable in ipairs(in_Table) do
        local key, value = _KVTable[1], _KVTable[2]

        if (type(value) == "table") then
            if (next(value) == nil) then
                goto continue
            end
            str_Table = str_Table .. "\n"
        end

        str_Table = str_Table .. printBlock(inInt_TabCount)
        if (type(key) == "number") then
            str_Table = str_Table .. "[" .. key .. "] = "
        else
            str_Table = str_Table .. key .. " = "
        end

        if (type(value) == "table") then
            str_Table = str_Table .. printTable(inInt_TabCount + 1, value)
        else
            str_Table = str_Table .. value .. "," .. "\n"
        end
        ::continue::
    end
    str_Table = str_Table .. printBlock(inInt_TabCount - 1) .. "}," .. "\n"
    return str_Table
end

local function convertTableToString(inStr_File, in_DataTable)
    local str_Result =
    "local config = require(\"ecs.config\")" .. "\n" ..
    "local empty = {}" .. "\n" ..
    "config(\"" .. inStr_File:match("[^.]+") .. "\"," .. "\n"..
    "empty," .. "\n"

    str_Result = str_Result .. printTable(1, in_DataTable)
    str_Result = str_Result:sub(1, -3) .. ")"
    return str_Result
end

local function createLuaConfig(inStr_File, inStr_Table)
    local str_File = inStr_File:match("[^.]+")
    local str_OutFile = "Lua_Config/" .. str_File .. ".lua"
    io.open("Lua_Config/", "w")
    local file_OutFile, str_Wrong = io.open(str_OutFile, "w")
    if (file_OutFile == nil) then
        print("open", str_Wrong)
        return
    end

    local file_OutFile1, str_Wrong1 = file_OutFile:write(inStr_Table)
    if (file_OutFile1 == nil) then
        print("write", str_Wrong1)
        return
    end

    file_OutFile:close()
end

local function tabToLua()
    -- os.execute("del Lua_Config")
    -- io.popen("del Lua_Config")
    local _FileList = getFileList()
    for _, str_File in ipairs(_FileList) do
        local _DataTable = convertFileToTable(str_File)
        local str_Table = convertTableToString(str_File, _DataTable)
        createLuaConfig(str_File, str_Table)
    end
end

return tabToLua