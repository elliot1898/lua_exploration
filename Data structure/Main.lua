local Array = require("Array")
local String = require("String")
local List = require("List")

local _Array1 = Array:array()
local _Array2 = Array:array()

_Array1:push(1)
_Array2:push(2)
_Array1:push(3)
_Array2:push(4)

_Array1:output()
_Array2:output()

_Array1:insert(100, 10)

_Array1:insert(1, 10)
_Array2:insert(1, 10)

_Array1:output()
_Array2:output()

_Array1:pop()
_Array2:pop()

_Array1:output()
_Array2:output()

_Array1:clear()
_Array2:clear()

_Array1:output()
_Array2:output()




local _Test1 = String:string({"t", "e", "s", "t", "1"})
local _Test2 = String:string({"t", "e", "s", "t", "2"})

_Test1:output()
_Test2:output()

_Test1:reset({"t", "e", "s", "t", "3"})
_Test1:output()

print(_Test1:len())

local _Sub = _Test1:sub(1, 2)
_Sub:output()

_Test1:append({"a", "p", "p", "e", "n", "d"})
_Test1:output()

print(_Test1:equal(_Test2))




local _List1 = List:list()
local _List2 = List:list()

local _Node1 = _List1:push(1)
local _Node2 = _List1:push(2)
_List2:push(3)

_List1:output()
_List2:output()

_List1:insert(_Node1, 3)
_List1:output()

_List1:remove(_Node2)
_List1:output()

local _NodeHead = _List1:head()
_NodeHead:output()

local _NodeTail = _List1:tail()
_NodeTail:output()

local _Pre = _NodeTail:pre()
_Pre:output()

local _Next = _NodeHead:next()
_Next:output()

_List1:popAll()
_List1:output()
