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

function Node:output()
    print(self.Elm)
end

local List = {}

function List:list()
    local _NewList = {}
    setmetatable(_NewList, self)
    self.__index = self
    _NewList._Head = Node:new()
    return _NewList
end

function List:findNode(in_Node)
    local p = self._Head._Next
    local pre = self._Head
    while (p ~= nil and p ~= in_Node) do
        pre = p
        p = p._Next
    end
    return p, pre
end

function List:getEnd()
    local p = self._Head
    while (p._Next ~= nil) do
        p = p._Next
    end
    return p
end

function List:push(in_Elm)
    local _NewNode = Node:new(in_Elm)
    local _ListEnd = self:getEnd()
    _ListEnd._Next = _NewNode
    _NewNode._Pre = _ListEnd
    return _NewNode
end

function List:insert(in_Node, in_Elm)
    local p, pre = self:findNode(in_Node)
    if (p == nil) then
        print("Node unexisted!")
    end

    local _NewNode = Node:new(in_Elm, p)
    pre._Next = _NewNode
    _NewNode._Pre = pre
    _NewNode._Next = p
    p._Pre = _NewNode
    return _NewNode
end

function List:remove(in_Node)
    local p, pre = self:findNode(in_Node)
    if (p == nil) then
        print("Node unexisted!")
    end

    pre._Next = p._Next
    if (p._Next ~= nil) then
        p._Next._Pre = pre
    end
end

function List:head()
    return self._Head._Next
end

function List:tail()
    return self:getEnd()
end

function List:popAll()
    self._Head._Next = nil
end

function List:output()
    local p = self._Head
    local str_Out = ""
    while (p._Next ~= nil) do
        p = p._Next
        str_Out = str_Out .. p.Elm .. "  "
    end
    print(str_Out)
    print("**********************")
end

return List