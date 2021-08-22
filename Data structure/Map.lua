local function newRBNode(in_Color, in_Key, in_Value, in_Left, in_Right, in_Parent)
    local _RBNode = {}
    _RBNode.Color = in_Color --0为黑，1为红
    _RBNode.Key = in_Key
    _RBNode.Value = in_Value
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
    _NewRBTree._Root = nil
    return _NewRBTree
end


-- 对红黑树的节点(x)进行左旋转

--      px                              px
--     /                               /
--    x                               y
--   /  \         --(左旋)-->        / \
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
--         /  \         --(右旋)-->         /  \
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

function RBTree:insert(in_Node)
    local p, _Parent = self:findNode(in_Node.Key)
    if (p ~= nil) then
        print("Exist a same key!")
        return
    end

    in_Node._Parent = _Parent
    if (_Parent ~= nil) then
        if (in_Node.Key < _Parent.Key) then
            _Parent._Left = in_Node
        else
            _Parent._Right = in_Node
        end
    else
        self._Root = in_Node
    end

    self:insertFixUp(in_Node)
end

function RBTree:insertFixUp(in_Node)  --插入节点后失去平衡，此函数用于修正
    local _Parent = in_Node._Parent
    local _GParent
    while (_Parent ~= nil and _Parent.Color == 1) do   --若父节点为红色，则进行以下处理
        _GParent = _Parent._Parent

        if (_Parent == _GParent._Left) then --若父节点是祖父节点的左孩子，则进行以下处理
            local _Uncle = _GParent._Right

            if (_Uncle and _Uncle.Color == 0) then  --Case1：叔叔节点是红色
                _Uncle.Color = 0
                _Parent.Color = 0
                _GParent.Color = 1
                _Parent = _GParent._Parent

            elseif (in_Node == _Parent._Right) then   --Case2：叔叔为黑，且当前节点是右孩子
                self:leftRotate(_Parent)
                in_Node.Color = 0
                _GParent.Color = 1
                self:rightRotate(_GParent)
                _Parent = _GParent

            elseif (in_Node == _Parent._Left) then    --Case3：叔叔为黑，且当前节点是左孩子
                _Parent.Color = 0
                _GParent.Color = 1
                self:rightRotate(_GParent)
            end

        else    --若父节点是祖父节点的右孩子，将上面操作的 "left" 与 "right" 对调
            local _Uncle = _GParent._Left

            if (_Uncle and _Uncle.Color == 0) then  --Case1：叔叔节点是红色
                _Uncle.Color = 0
                _Parent.Color = 0
                _GParent.Color = 1
                _Parent = _GParent._Parent

            elseif (in_Node == _Parent._Left) then   --Case2：叔叔为黑，且当前节点是右孩子
                self:rightRotate(_Parent)
                in_Node.Color = 0
                _GParent.Color = 1
                self:leftRotate(_GParent)
                _Parent = _GParent

            elseif (in_Node == _Parent._Right) then    --Case3：叔叔为黑，且当前节点是左孩子
                _Parent.Color = 0
                _GParent.Color = 1
                self:leftRotate(_GParent)
            end

        end
    end
    self._Root.Color = 0
end

function RBTree:remove(in_Key)
    local p = self:findNode(in_Key) --p：待删节点
    if (p == nil) then
        print("Can not find the key!")
    end

    local _Child = nil
    local _Parent = nil
    local Color = nil
    if (p._Left ~= nil and p._Right ~= nil) then    --Case1：待删节点有两个孩子
        local _Successor = p    --后继节点
        _Successor = _Successor._Right
        while (_Successor._Left ~= nil) do  --定位后继节点
            _Successor = _Successor._Left
        end

        if (p ~= self._Root) then   --将待删节点p的父节点与后继节点Successor建立连接
            if (p._Parent._Left == p) then
                p._Parent._Left = _Successor
            else
                p._Parent._Right = _Successor
            end
        else
            self._Root = _Successor
        end

        _Child = _Successor._Right  --将后继节点的孩子节点与父节点建立连接
        _Parent = _Successor._Parent
        Color = _Successor.Color

        if (_Parent == p) then
            _Parent = _Successor
        else
            if (_Child ~= nil) then
                _Child._Parent = _Parent
            end
            _Parent._Left = _Child

            _Successor._Right = p._Right
            p._Right = _Successor
        end

        _Successor._Parent = p._Parent
        _Successor.Color = p.Color
        _Successor._Left = p._Left
        p._Left._Parent = _Successor

        if (Color == 0) then
            self:removeFixUp(_Child)
        end
        return
    end

    if (p._Left ~= nil) then
        _Child = p._Left
    else
        _Child = p._Right
    end

    _Parent = p._Parent
    Color = p.Color

    if (_Child ~= nil) then
        _Child._Parent = _Parent
    end

    if (_Parent ~= nil) then
        if (_Parent._Left == p) then
            _Parent._Left = _Child
        else
            _Parent._Right = _Child
        end
    else
        self._Root = _Child
    end

    if (Color == 0) then
        self:removeFixUp(_Child)
    end
end

function RBTree:removeFixUp(in_Node)
    local _Parent = in_Node._Parent
    local _Bro

    while ((in_Node == nil or in_Node.Color == 0) and in_Node ~= self._Root) do
        if (_Parent._Left == in_Node) then
            _Bro = _Parent._Right
            if (_Bro.Color == 1) then
                _Bro.Color = 0
                _Parent.Color = 1
                self:leftRotate(_Parent)
                _Bro = _Parent._Right
            end

            if ((_Bro._Left == nil or _Bro._Left.Color == 0) and (_Bro._Right == nil or _Bro._Right.Color == 0)) then
                _Bro.Color = 1
                in_Node = _Parent
                _Parent = in_Node._Parent

            else
                if (_Bro._Right == nil or _Bro._Right.Color == 0) then
                    _Bro._Left.Color = 0
                    _Bro.Color = 1
                    self:rightRotate(_Bro)
                    _Bro = _Parent._Right
                end

                _Bro.Color = _Parent.Color
                _Parent.Color = 0
                _Bro._Right.Color = 0
                self:leftRotate(_Parent)
                in_Node = self._Root
                break
            end

        else
            _Bro = _Parent._Left
            if (_Bro.Color == 1) then
                _Bro.Color = 0
                _Parent.Color = 1
                self:rightRotate(_Parent)
                _Bro = _Parent._Left
            end

            if ((_Bro._Left == nil or _Bro._Left.Color == 0) and (_Bro._Right == nil or _Bro._Right.Color == 0)) then
                _Bro.Color = 1
                in_Node = _Parent
                _Parent = in_Node._Parent

            else
                if (_Bro._Left == nil or _Bro._Left.Color == 0) then
                    _Bro._Right.Color = 0
                    _Bro.Color = 1
                    self:leftRotate(_Bro)
                    _Bro = _Parent._Left
                end

                _Bro.Color = _Parent.Color
                _Parent.Color = 0
                _Bro._Left.Color = 0
                self:rightRotate(_Parent)
                in_Node = self._Root
                break
            end
        end
    end

    if (in_Node ~= nil) then
        in_Node.Color = 0
    end
end

function RBTree:findNode(in_Key)
    local p = self._Root
    local _Parent
    while (p ~= nil) do
        if (p.Key == in_Key) then
            break
        elseif (p.Key < in_Key) then
            _Parent = p
            p = p._Right
        elseif (p.Key > in_Key) then
            _Parent = p
            p = p._Left
        end
    end
    return p, _Parent
end

function RBTree:inOrderPrint(in_Node)
    if (in_Node == nil) then
        return
    end

    if (in_Node._Left ~= nil) then
        self:inOrderPrint(in_Node._Left)
    end

    print(in_Node.Key, in_Node.Value, in_Node.Color)

    if (in_Node._Right ~= nil) then
        self:inOrderPrint(in_Node._Right)
    end
end

local Map = {}

function Map:map()
    local _NewMap = {}
    setmetatable(_NewMap, self)
    self.__index = self
    _NewMap._Data = RBTree:newRBTree()
    return _NewMap
end

function Map:insert(in_Key, in_Value)
    local _NewNode = newRBNode(1, in_Key, in_Value, nil, nil, nil)
    self._Data:insert(_NewNode)
end

function Map:remove(in_Key)
    self._Data:remove(in_Key)
end

function Map:find(in_Key)
    return self._Data:findNode(in_Key) ~= nil
end

function Map:clear()
    self._Data = RBTree:newRBTree()
end

function Map:print()
    local _Data = self._Data
    _Data:inOrderPrint(_Data._Root)
    print("******************")
end

return Map