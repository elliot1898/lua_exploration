local function newRBNode(inInt_Color, inInt_Key, in_Left, in_Right, in_Father)
    local _RBNode = {}
    _RBNode.int_Color = inInt_Color
    _RBNode.int_Key = inInt_Key
    _RBNode._Left = in_Left
    _RBNode._Right = in_Right
    _RBNode.Father = in_Father
    return _RBNode
end

local RBTree = {}

function RBTree:newRBTree()
    local _NewRBTree = {}
    setmetatable(_NewRBTree, self)
    self.__index = self
    _NewRBTree._Root = newRBNode(0)
    return _NewRBTree
end

function RBTree:insert(in_RBNode)
    
end
