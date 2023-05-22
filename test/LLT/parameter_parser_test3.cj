
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*
from upload4cj import upload4cj.*
from std import collection.*
from serialization import serialization.*

main(){
    let s: String = "  test  , test1=stuff   ,  , test2=, test3, "
    var parser: ParameterParser = ParameterParser()
    let s1: Option<String> = s
    var map: Map<String, Option<String>> = parser.parse(s1, ',')
    println(map.size)

    println(map.get("test1").getOrThrow().getOrThrow())

    let isTest: Bool = match(map.get("test").getOrThrow()) {
        case None =>
            false
        case Some(v) =>
            true
    }

    if (isTest) {
        return -1
    } 

    let isTest2: Bool = match(map.get("test2").getOrThrow()) {
        case None =>
            false
        case Some(v) =>
            true
    }

    if (isTest2) {
        return -2
    } 

    let isTest3: Bool = match(map.get("test3").getOrThrow()) {
        case None =>
            false
        case Some(v) =>
            true
    }

    if (isTest3) {
        return -3
    } 

    if (map.get("test1").getOrThrow().getOrThrow() != "stuff") {
        return -4
    } 

    return 0
}