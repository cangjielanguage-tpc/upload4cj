
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*

main(){
    let x1:Char=' '
    let r1=UInt32(x1)

    let boundary = Array<UInt8>(5, item: 0)
    let boundary1 = Array<UInt8>(5, item: 1)
    println(boundary)
    println(boundary1)

    boundary.copyTo(boundary1, 0, 0, boundary.size)


    println(boundary)
    println(boundary1)


    println(r1)
    println(x1)
    // println(Int64.parse("ty"))

    var charArray: Array<Char> = Array<Char>(5, item: Char(65))

}