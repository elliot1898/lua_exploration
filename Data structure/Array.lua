local Array = {}

function Array:array()
    Array._Data = {}
    Array.Size = 0
    return self
end

function Array:push(in_Elm)
    table.insert(self._Data, in_Elm)
    self.Size = self.size + 1
end

function Array:pop()
    local int_Size = self.Size
    if (int_Size == 0) then
        print("Invalid operation!")
        return
    end

    table.remove(self._Data)
    self.size = self.size - 1 
end

function Array:insert(inInt_Pos, in_Elm)
    local int_Size = self.Size
    if (type(inInt_Pos) ~= "number" or inInt_Pos <= 0 or inInt_Pos > int_Size + 1) then
        print("Invalid position!")
        return
    end

    table.insert(self._Data, inInt_Pos, in_Elm)
    self.Size = int_Size + 1
end

function Array:remove(inInt_Pos)
    local int_Size = self.Size
    if (type(inInt_Pos) ~= "number" or inInt_Pos <= 0 or inInt_Pos > int_Size) then
        print("Invalid position!")
        return
    end

    table.remove(self._Data, inInt_Pos)
    self.Size = int_Size - 1
end

function Array:clear()
    self._Data = {}
    self.Size = 0
end

function Array:output()
    for int_Index, int_Value in ipairs(self._Data) do
        print(int_Index, int_Value)
    end
    print("*********")
end

return Array
