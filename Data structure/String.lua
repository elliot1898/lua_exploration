local String = {}

function String:string(in_String)
    if (type(in_String) ~= "string") then
        print("Invalid parameter type!")
        return
    end

    self.str_Data = in_String
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

    self.str_Data = in_String
end

function String:len() return string.len(self.str_Data) end

function String:sub(inInt_Begin, inInt_End)
    if (type(inInt_Begin) ~= "number" or (type(inInt_End) ~= "nil" and type(inInt_End) ~= "number")) then
        print("Invalid parameter type!")
        return
    end

    return string.sub(self.str_Data, inInt_Begin, inInt_End)
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
