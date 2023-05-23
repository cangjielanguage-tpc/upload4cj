
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from net import http.*
from std import io.*
from upload4cj import upload4cj.*
from std import collection.*
from serialization import serialization.*

main(){
    let parser: ParameterParser = ParameterParser()

    let s: Option<String> = "Content-type: multipart/form-data , boundary=AaB03x"
    let s_new: Option<String> = "Content-type: multipart/form-data, boundary=AaB03x"
    
    var arrayChar: Option<Array<Char>> = [',', ';']
    var arrayChar_new: Option<Array<Char>> = [';', ',']

    var map: Map<String, Option<String>> = parser.parse(s, arrayChar)
    var map_new: Map<String, Option<String>> = parser.parse(s_new, arrayChar_new)
    
    if (map.get("boundary").getOrThrow().getOrThrow() != "AaB03x") {
        return -1
    }

    if (map_new.get("boundary").getOrThrow().getOrThrow() != "AaB03x") {
        return -2
    }

    let s2: Option<String> = "Content-type: multipart/mixed, boundary=BbC04y"
    var arrayChar2: Option<Array<Char>> = [',', ';']
    var map2: Map<String, Option<String>> = parser.parse(s2, arrayChar2)

    if (map2.get("boundary").getOrThrow().getOrThrow() != "BbC04y") {
        return -3
    }

    return 0
}