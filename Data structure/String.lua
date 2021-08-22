local Array = require("Array")

local String = {}

function String:string(_InString)
    if (not self:checkString(_InString)) then
        return
    end

    local _NewString = {}
    setmetatable(_NewString, self)
    self.__index = self

    _NewString._StrData = Array:array()
    local _StrData = _NewString._StrData
    local int_Length = 0
    for int_Index, str_Char in ipairs(_InString) do
        _StrData:push(str_Char)
        int_Length = int_Length + 1
    end

    _NewString.int_Length = int_Length
    return _NewString
end

function String:reset(_InString)
    if (not self:checkString(_InString)) then
        return
    end

    self._StrData =  Array:array()
    local _StrData = self._StrData
    local int_Length = 0
    for int_Index, str_Char in ipairs(_InString) do
        _StrData:push(str_Char)
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

    local _NewString = Array:array()
    local _StrData = self._StrData._Data
    for i = inInt_Begin, int_End do
        if (_StrData[i] ~= nil) then
            _NewString:push(_StrData[i])
        end
    end

    return self:string(_NewString._Data)
end

function String:append(_InString)
    if (not self:checkString(_InString)) then
        return
    end

    local _StrData = self._StrData
    local int_Length = 0
    for int_Index, str_Char in ipairs(_InString) do
        _StrData:push(str_Char)
        int_Length = int_Length + 1
    end

    self.int_Length = int_Length
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

function String:getString()
    local str_Result = ""
    local _StrData = self._StrData._Data
    for int_Index, str_Char in ipairs(_StrData) do
        str_Result = str_Result .. str_Char
    end
    return str_Result
end

function String:checkString(_InString)
    if (type(_InString) ~= "table") then
        print("Invalid parameter type!")
        return false
    end

    for int_Index, str_Char in ipairs(_InString) do
        if (type(str_Char) ~= "string" or #str_Char ~= 1) then
            print("Invalid parameter!")
            return false
        end
    end

    return true
end

function String:print()
    print(self:getString())
    print("**************")
end

return String
