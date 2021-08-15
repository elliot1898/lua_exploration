local function newRBNode(inInt_Color, in_Key, in_Left, in_Right, in_Parent)
    local _RBNode = {}
    _RBNode.int_Color = inInt_Color
    _RBNode.Key = in_Key
    _RBNode._Left = in_Left
    _RBNode._Right = in_Right
    _RBNode.Parent = in_Parent
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


-- 对红黑树的节点(x)进行左旋转

--      px                              px
--     /                               /
--    x                               y
--   /  \      --(左旋)-->           / \
--  lx   y                          x  ry
--     /   \                       /  \
--    ly   ry                     lx  ly


function RBTree:leftRotate(x)
    local y = x._Right
    local ly = y._Left
    x._Right = ly
    if (ly ~= nil) then
        ly._Parent = x
    end

    local px = x._Parent
    y._Parent = px
    if (px == nil) then
        self._Root = y
    else
        if (x == px._Left) then
            px._Left = y
        else
            px._Right = y
        end
    end

    y._Left = x
    x._Parent = y
end

-- 对红黑树的节点(y)进行右旋转

--            py                               py
--           /                                /
--          y                                x
--         /  \      --(右旋)-->            /  \
--        x   ry                           lx   y
--       / \                                   / \
--      lx  rx                                rx  ry

function RBTree:rightRotate(y)
    local x = y._Left
    local rx = x._Right
    y._Left = rx
    if (rx ~= nil) then
        rx._Parent = y
    end

    local py = y._Parent
    x._Parent = py
    if (py == nil) then
        self._Root = x
    else
        if (y == py._Left) then
            py._Left = x
        else
            py._Right = x
        end
    end

    x._Right = y
    y._Parent = x
end

function RBTree:insert(in_RBNode)
    local p = self._Root
    while (p ~= nil) do
        if (p.Key == in_RBNode.Key) then
            print("Exist a same element!")
            return
        elseif (p.Key < in_RBNode.Key) then
            p = p._Right
        elseif (p.Key > in_RBNode.Key) then
            p = p._Left
        end
    end
    in_RBNode._Parent = p._Parent

    
end
