local Array = {}

function Array:array()
    Array._Data = {}
    self.Size = 0
    return self
end

function Array:push(inInt_num)
    table.insert(self._Data, inInt_num)
    self.Size = self.Size + 1
end

function Array:pop()
    local int_Size = self.Size
    if (int_Size == 0) then
        print("Invalid operation!")
        return
    end

    table.remove(self._Data)
    self.Size = int_Size - 1
end

function Array:insert(inInt_Pos, inInt_Num)
    local int_Size = self.Size
    if (inInt_Pos <= 0 or inInt_Pos > int_Size + 1) then
        print("Invalid position!")
        return
    end

    table.insert(self._Data, inInt_Pos, inInt_Num)
    self.Size = int_Size + 1
end

function Array:remove(inInt_Pos)
    local int_Size = self.Size
    if (inInt_Pos <= 0 or inInt_Pos > int_Size) then
        print("Invalid position!")
        return
    end

    table.remove(self._Data, inInt_Pos)
    self.Size = int_Size - 1
end

function Array:clear()
    for int_Index = 1, self.Size do
        table.remove(self._Data)
    end
    self.Size = 0
end

function Array:output()
    for int_Index, int_Value in ipairs(self._Data) do
        print(int_Index, int_Value)
    end
    print("*********")
end

return Array
