local String = {}

function String:string(in_String)
    if (type(in_String) ~= "string") then
        print("Invalid parameter type!")
        return
    end

    self._StrData = {}
    local _Data = self._StrData
    local int_Len = string.len(in_String)
    for i = 1, int_Len do
        _Data[i] = string.sub(in_String, i, i)
    end
    self.int_Length = int_Len
    return self
end

function String:getString()
    return self.str_Data
end

function String:reset(in_String)
    if (type(in_String) ~= "string") then
        print("Invalid parameter type!")
        return
    end

    self._StrData = {}
    local _Data = self._StrData
    local int_Len = string.len(in_String)
    for i = 1, string.len(in_String) do
        _Data[i] = string.sub(in_String, i, i)
    end
    self.int_Length = int_Len
end

function String:len()
    return self.int_Length
end

function String:sub(inInt_Begin, inInt_End)
    if (type(inInt_Begin) ~= "number" or (type(inInt_End) ~= "nil" and type(inInt_End) ~= "number")) then
        print("Invalid parameter type!")
        return
    end

    local int_Length = self.int_Length
    if (inInt_Begin < 0) then
        inInt_Begin = int_Length + inInt_Begin + 1
    end
    if (inInt_End < 0) then
        inInt_End = int_Length + inInt_End + 1
    end
    if () then
        
    end


end

function String:append(in_String)
    if (type(in_String) ~= "string") then
        print("Invalid parameter type!")
        return
    end

    self.str_Data = self.str_Data..in_String
end

function String:equal(in_String)
    local str_InString = in_String:getString()
    if (type(str_InString) ~= "string") then
        print("Invalid parameter type!")
        return
    end

    return self.str_Data == str_InString
end

function String:output()
    print(self.str_Data)
end

return String
