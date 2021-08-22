local Array = require("Array")
local String = require("String")
local List = require("List")
local Map = require("Map")

local _Array1 = Array:array()
local _Array2 = Array:array()

_Array1:push(1)
_Array2:push(2)
_Array1:push(3)
_Array2:push(4)

_Array1:print()
_Array2:print()

_Array1:insert(100, 10)

_Array1:insert(1, 10)
_Array2:insert(1, 10)

_Array1:print()
_Array2:print()

_Array1:pop()
_Array2:pop()

_Array1:print()
_Array2:print()

_Array1:clear()
_Array2:clear()

_Array1:print()
_Array2:print()




local _Test1 = String:string({"t", "e", "s", "t", "1"})
local _Test2 = String:string({"t", "e", "s", "t", "2"})

_Test1:print()
_Test2:print()

_Test1:reset({"t", "e", "s", "t", "3"})
_Test1:print()

print(_Test1:len())

local _Sub = _Test1:sub(1, 2)
_Sub:print()

_Test1:append({"a", "p", "p", "e", "n", "d"})
_Test1:print()

print(_Test1:equal(_Test2))




local _List1 = List:list()
local _List2 = List:list()

local _Node1 = _List1:push(1)
local _Node2 = _List1:push(2)
_List2:push(3)

_List1:print()
_List2:print()

_List1:insert(_Node1, 3)
_List1:print()

_List1:remove(_Node2)
_List1:print()

local _NodeHead = _List1:head()
_NodeHead:print()

local _NodeTail = _List1:tail()
_NodeTail:print()

local _Pre = _NodeTail:pre()
_Pre:print()

local _Next = _NodeHead:next()
_Next:print()

_List1:popAll()
_List1:print()

local _Map = Map:map()
_Map:insert(1, 2)
_Map:insert(2, 3)
_Map:print()

_Map:remove(1)
_Map:print()

local bool_Found = _Map:find(2)
print(bool_Found)

_Map:clear()
_Map:print()