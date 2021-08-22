local Array = {}

function Array:array()
    local _NewArray = {}
    setmetatable(_NewArray, self)
    self.__index = self
    _NewArray._Data = {}
    _NewArray.int_Size = 0;
    return  _NewArray
end

function Array:push(in_Elm)
    self.int_Size = self.int_Size + 1
    self._Data[self.int_Size] = in_Elm
end

function Array:pop()
    local int_Size = self.Size
    if (int_Size == 0) then
        print("Invalid operation!")
        return
    end

    self._Data[self.int_Size] = nil
    self.int_Size = self.int_Size - 1
end

function Array:insert(inInt_Pos, in_Elm)
    local int_Size = self.int_Size
    if (type(inInt_Pos) ~= "number" or inInt_Pos <= 0 or inInt_Pos > int_Size + 1) then
        print("Invalid position!")
        return
    end

    local _Data = self._Data
    for i = int_Size, inInt_Pos, -1 do
        _Data[i + 1] = _Data[i]
    end
    _Data[inInt_Pos] = in_Elm
    self.int_Size = int_Size + 1
end

function Array:remove(inInt_Pos)
    local int_Size = self.int_Size
    if (type(inInt_Pos) ~= "number" or inInt_Pos <= 0 or inInt_Pos > int_Size) then
        print("Invalid position!")
        return
    end

    local _Data = self._Data
    for i = inInt_Pos, int_Size - 1 do
        _Data[i] = _Data[i + 1]
    end
    self.int_Size = int_Size - 1
end

function Array:clear()
    self._Data = {}
    self.int_Size = 0
end

function Array:print()
    for int_Index, int_Value in ipairs(self._Data) do
        print(int_Index, int_Value)
    end
    print("*********")
end

return Array