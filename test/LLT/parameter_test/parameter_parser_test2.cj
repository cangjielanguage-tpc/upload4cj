
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*
from upload4cj import upload4cj.*
from std import collection.*
from serialization import serialization.*

main(){
    let s: String = "test; test1 =  stuff   ; test2 =  \"stuff; stuff\"; test3=\"stuff"
    var parser: ParameterParser = ParameterParser()
    let s1: Option<String> = s
    var arrayChar: Option<Array<Char>> = [',', ';']
    var map: Map<String, Option<String>> = parser.parse(s1, arrayChar)

    let isTest: Bool = match(map.get("test").getOrThrow()) {
        case None =>
            false
        case Some(v) =>
            true
    }

    if (isTest) {
        return -1
    } 

    if (map.get("test1").getOrThrow().getOrThrow() != "stuff") {
        return -2
    } 

    if (map.get("test2").getOrThrow().getOrThrow() != "stuff; stuff") {
        return -3
    }

    if (map.get("test3").getOrThrow().getOrThrow() != "\"stuff") {
        return -4
    }
    return 0
}