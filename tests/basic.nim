
import unittest
from nesm import serializable

# Just a codegen test
serializable:
  static:
    type
      MySInt* = distinct int32

suite "Trivial types":
  test "Direct typing":
    serializable:
      static:
        type
          MyInt = int32

    let mi = MyInt(4)
    let smi = mi.serialize()
    let dsmi = MyInt.deserialize(@smi)
    check(smi.len == MyInt.sizeof)
    require(mi.repr == dsmi.repr)

  test "Distinct typing":
    serializable:
      static:
        type
          MyDInt = distinct int32

    let mdi = MyDInt(4)
    let smdi = mdi.serialize()
    let dsmdi = MyDInt.deserialize(@smdi)
    check(smdi.len == MyDInt.sizeof)
    require(mdi.repr == dsmdi.repr)

  test "Arrays":
    serializable:
      static:
        type
          MyAInt = distinct array[0..10, int32]

    let mi = MyAInt([ 4'i32 , 5'i32,6'i32,3'i32,3'i32,4'i32,1'i32,
      1'i32,5'i32,7'i32,8'i32])
    let smi = mi.serialize()
    let dsmi = MyAInt.deserialize(@smi)
    check(smi.len == MyAInt.sizeof)
    require(mi.repr == dsmi.repr)

  test "Arrays with constant":
    const ARRAYSIZE = 11
    serializable:
      static:
        type
          MyCAInt = distinct array[ARRAYSIZE, int32]

    let mi = MyCAInt([ 4'i32 , 5'i32,6'i32,3'i32,3'i32,4'i32,1'i32,
      1'i32,5'i32,7'i32,8'i32])
    let smi = mi.serialize()
    let dsmi = MyCAInt.deserialize(@smi)
    check(smi.len == MyCAInt.sizeof)
    require(mi.repr == dsmi.repr)

  test "Tuples":
    serializable:
      static:
        type
          MyTInt =  tuple[q:char, w:int64]

    let mi = MyTInt((q:'q',w:4'i64))
    let smi = mi.serialize()
    let dsmi = MyTInt.deserialize(@smi)
    require(mi.repr == dsmi.repr)
