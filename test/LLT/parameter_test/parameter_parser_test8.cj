
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*
from upload4cj import upload4cj.*
from std import collection.*
from serialization import serialization.*

main(){
    let s: String = "param = \"stuff\\\"; more stuff\""
    var parser: ParameterParser = ParameterParser()
    let s1: Option<String> = s
    
    var map: Map<String, Option<String>> = parser.parse(s1, ';')
    if (map.size != 1) {
        return -1
    }

    if (map.get("param").getOrThrow().getOrThrow() != "stuff\\\"; more stuff") {
        return -2
    }

    return 0
}