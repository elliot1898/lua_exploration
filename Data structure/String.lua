local String = {}

function String:string(_InString)
    if (type(_InString) ~= "table") then
        print("Invalid parameter type!")
        return
    end

    local _NewString = {}
    setmetatable(_NewString, self)
    self.__index = self

    _NewString._StrData = {}
    local _StrData = _NewString._StrData
    local int_Length = 0
    for int_Index, str_Char in ipairs(_InString) do
        if (type(str_Char) ~= "string") then
            print("Invalid parameter!")
            return
        end
        table.insert(_StrData, str_Char)
        int_Length = int_Length + 1
    end

    _NewString.int_Length = int_Length

    return _NewString
end

function String:getString()
    local str_Data = ""
    for int_Index, str_Char in ipairs(self._StrData) do
        str_Data = str_Data .. str_Char
    end
    return str_Data
end

function String:reset(_InString)
    if (type(_InString) ~= "table") then
        print("Invalid parameter type!")
        return
    end

    self._StrData = {}
    local _StrData = self._StrData
    local int_Length = 0

    for int_Index, str_Char in ipairs(_InString) do
        if (type(str_Char) ~= "string") then
            print("Invalid parameter!")
            return
        end
    end

    for int_Index, str_Char in ipairs(_InString) do
        table.insert(_StrData, str_Char)
        int_Length = int_Length + 1
    end

    self.int_Length = int_Length
end

function String:len()
    return self.int_Length
end

function String:sub(inInt_Begin, inInt_End)
    if (type(inInt_Begin) ~= "number" or (type(inInt_End) ~= "nil" and type(inInt_End) ~= "number")) then
        print("Invalid parameter type!")
        return
    end

    local int_End = self.int_Length
    if (type(inInt_End) ~= "nil") then
        int_End = inInt_End
    end

    local _NewString = {}
    local _StrData = self._StrData
    for i = inInt_Begin, int_End do
        if (_StrData[i] ~= nil) then
            table.insert(_NewString, _StrData[i])
        end
    end

    return self:string(_NewString)
end

function String:append(_InString)
    if (type(_InString) ~= "table") then
        print("Invalid parameter type!")
        return
    end

    for int_Index, str_Char in ipairs(_InString) do
        if (type(str_Char) ~= "string") then
            print("Invalid parameter!")
            return
        end
    end

    for int_Index, str_Char in ipairs(_InString) do
        table.insert(self._StrData, str_Char)
    end
end

function String:equal(_InString)
    if (type(_InString) ~= "table") then
        print("Invalid parameter type!")
        return
    end

    local str_InString = _InString:getString()
    if (str_InString == nil) then
        print("Invalid parameter!")
    end

    return self:getString() == str_InString
end

function String:output()
    print(self:getString())
    print("**************")
end

return String
