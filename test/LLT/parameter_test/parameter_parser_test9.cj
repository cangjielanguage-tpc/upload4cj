
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*
from upload4cj import upload4cj.*
from std import collection.*
from serialization import serialization.*

main(){
    let s: String = "param = \"stuff\\\\\"; anotherparam"
    var parser: ParameterParser = ParameterParser()
    let s1: Option<String> = s
    
    var map: Map<String, Option<String>> = parser.parse(s1, ';')
    if (map.size != 2) {
        return -1
    }

    if (map.get("param").getOrThrow().getOrThrow() != "stuff\\\\") {
        return -2
    }

    let isTest: Bool = match(map.get("anotherparam").getOrThrow()) {
        case None =>
            false
        case Some(v) =>
            true
    }

    if (isTest) {
        return -3
    } 

    return 0
}