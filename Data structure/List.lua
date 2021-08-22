local Node = {}

function Node:new(in_Elm, in_Pre, in_Next)
    local _NewNode = {}
    setmetatable(_NewNode, self)
    self.__index = self
    _NewNode.Elm = in_Elm or nil
    _NewNode._Pre = in_Pre or nil
    _NewNode._Next = in_Next or nil
    return _NewNode
end

function Node:pre()
    return self._Pre
end

function Node:next()
    return self._Next
end

function Node:print()
    print(self.Elm)
end

local List = {}

function List:list()
    local _NewList = {}
    setmetatable(_NewList, self)
    self.__index = self
    _NewList._Head = nil
    return _NewList
end

function List:push(in_Elm)
    local _NewNode = Node:new(in_Elm)
    if (self._Head == nil) then
        self._Head = _NewNode
    else
        local _ListEnd = self:getEnd()
        _ListEnd._Next = _NewNode
        _NewNode._Pre = _ListEnd
    end

    return _NewNode
end

function List:insert(in_Node, in_Elm)
    local p = self:findNode(in_Node)
    if (p == nil) then
        print("Node unexisted!")
        return
    end

    local _NewNode = Node:new(in_Elm, p._Pre, p)
    p._Pre = _NewNode
    if (p == self._Head) then
        self._Head = _NewNode
    else
        p._Pre._Next = _NewNode
    end
    return _NewNode
end

function List:remove(in_Node)
    local p = self:findNode(in_Node)
    if (p == nil) then
        print("Node unexisted!")
        return
    end

    local pre = p._Pre
    local next = p._Next
    if (pre ~= nil) then
        pre._Next = next
    end
    if (next ~= nil) then
        next._Pre = pre
    end
end

function List:head()
    return self._Head
end

function List:tail()
    return self:getEnd()
end

function List:popAll()
    self._Head = nil
end

function List:findNode(in_Node)
    local p = self._Head
    while (p ~= nil and p ~= in_Node) do
        p = p._Next
    end
    return p
end

function List:getEnd()
    local _Head = self._Head
    if (_Head == nil) then
        return _Head
    end
    local p = _Head
    while (p._Next ~= nil) do
        p = p._Next
    end
    return p
end

function List:print()
    local p = self._Head
    local str_Out = ""
    while (p ~= nil) do
        str_Out = str_Out .. p.Elm .. "  "
        p = p._Next
    end
    print(str_Out)
    print("**********************")
end

return List