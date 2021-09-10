local str_TabFolder = "Tab_Config"
local str_LuaFolder = "Lua_Config"

local function formatByPrefix(inStr_Elm, inInt_Index, in_Prefix)        -- 通过前缀，对表中元素的格式进行修饰
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

local function findKeyInTable(in_Key, in_Table)                         -- 在传入Table中查找Key
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

-- 将配置文件读取为 Table
local function convertFileToTable(inStr_File)
    -- 获取文件句柄
    local file_Table = io.open(str_TabFolder .. "/" .. inStr_File, "r")
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
            print("Wrong format \"" .. str_Format .. "\" in file \"" .. inStr_File .. "\"!")
            return
        end
        table.insert(_Prefixs, str_Format)
        table.remove(_Temp, 1)

        local _Suffix = {}
        if (_Temp[#_Temp]:sub(1, 1) == "@") then
            for str_Suffix in _Temp[#_Temp]:gmatch("[^@]+") do
                local int_Suffix = nil
                if (str_Suffix:match("%d+") == str_Suffix) then
                    int_Suffix = tonumber(str_Suffix)
                end
                table.insert(_Suffix, int_Suffix or str_Suffix)
            end
            table.remove(_Temp)
        end
        table.insert(_Suffixs, _Suffix)

        local str_HeadName = ""
        for index, value in ipairs(_Temp) do
            str_HeadName = str_HeadName .. value
            if (index ~= #_Temp) then
                str_HeadName = str_HeadName .. "_"
            end
        end
        local int_HeadName = nil
        if (str_HeadName:match("%d+") == str_HeadName) then
            int_HeadName = tonumber(str_HeadName)
        end
        table.insert(_HeadNames, int_HeadName or str_HeadName)
    end

    local _DataTable = {}       -- 用来存表。由于要求结果按Key升序输出，所以存表时采用 _DataTable = {{key1, value1}, {key2, value2}} 的格式进行存储

    -- 开始存表
    local str_Row = file_Table:read()
    local int_RowIndex = 1
    while (str_Row ~= nil) do
        local _Row = {}
        for str_Elm in str_Row:gmatch("[^\t]*") do
            table.insert(_Row, str_Elm)
        end

        if (_Row[1] ~= "comment") then      -- 注释行不读取
            local Key = formatByPrefix(_Row[1], 1, _Prefixs)
            if (Key ~= nil) then
                local int_Index, bool_Find = findKeyInTable(Key, _DataTable)
                if (bool_Find) then
                    print("Exist repeated ID \"" .. Key ..  "\" in file \"" .. inStr_File .. "\"!")
                    return
                end
                table.insert(_DataTable, int_Index, {Key, {}})

                for i = 2, #_HeadNames do
                    local key = _HeadNames[i]
                    local value = formatByPrefix(_Row[i], i, _Prefixs)
                    if (key ~= "comment" and value ~= nil) then     -- 注释列和值为nil的不读取
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
                            print("Exist repeated HeadName \"" .. key .. "\" in file \"" .. inStr_File .. "\"!")
                            return
                        end
                        table.insert(p, index, {key, value})
                    end
                end
            end
        end

        str_Row = file_Table:read()
        int_RowIndex = int_RowIndex + 1
    end

    file_Table:close()
    return _DataTable
end

local function printBlock(inInt_BlockCount)
    local str_Tab = ""
    for i = 1, inInt_BlockCount do
        str_Tab = str_Tab .. "  "
    end
    return str_Tab
end

-- 将传入 Table 输出为 String
local function printTable(inInt_TabCount, in_Table)
    local str_Table = "{" .. "\n"
    for _, _KVTable in ipairs(in_Table) do
        local key, value = _KVTable[1], _KVTable[2]

        if (type(value) == "table") then
            if (next(value) == nil) then        -- 若value为空Table，不输出此key value
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
            str_Table = str_Table .. printTable(inInt_TabCount + 1, value)      -- 若value为Table，递归调用printTable
        else
            str_Table = str_Table .. value .. "," .. "\n"
        end
        ::continue::
    end
    str_Table = str_Table .. printBlock(inInt_TabCount - 1) .. "}," .. "\n"
    return str_Table
end

-- 将Table转化为字符串
local function convertTableToString(inStr_File, in_DataTable)
    local str_Result =
    "local config = require(\"ecs.config\")" .. "\n" ..
    "local empty = {}" .. "\n" ..
    "config(\"" .. inStr_File .. "\"," .. "\n"..
    "empty," .. "\n"

    str_Result = str_Result .. printTable(1, in_DataTable)
    str_Result = str_Result:sub(1, -3) .. ")"
    return str_Result
end

-- 将字符串输出为Lua配置文件
local function createLuaConfig(inStr_File, inStr_Table)
    local str_OutFile = str_LuaFolder .. "/" .. inStr_File .. ".lua"

    local file_OutFile, str_Wrong1 = io.open(str_OutFile, "w")
    if (file_OutFile == nil) then
        print("open", str_Wrong1)
        return
    end

    local file_OutFile1, str_Wrong2 = file_OutFile:write(inStr_Table)
    if (file_OutFile1 == nil) then
        print("write", str_Wrong2)
        return
    end

    file_OutFile:close()
end

local function getFileList(inStr_Path)                                  -- 返回传入参数文件夹下所有文件
	local _FolderHandle = io.popen("dir /b " .. inStr_Path)
	local _FileList = {}

	if (_FolderHandle ~= nil) then
		for file in _FolderHandle:lines() do
			table.insert(_FileList, file)
		end
	end
    _FolderHandle:close()
	return _FileList
end

local function tabToLua()
    os.execute("rmdir /s /q " .. str_LuaFolder)
    os.execute("mkdir " .. str_LuaFolder)

    local _FileList = getFileList(str_TabFolder)
    for _, str_File in ipairs(_FileList) do
        if (str_File:match("[^_]+") == "cfg") then          -- 只导前缀为"cfg"的文件
            local _DataTable = convertFileToTable(str_File)
            if (_DataTable ~= nil) then
                local str_FileName = str_File:match("[^.]+")
                local str_Table = convertTableToString(str_FileName, _DataTable)
                createLuaConfig(str_FileName, str_Table)
            end
        end
    end
end

return tabToLua
