from strutils import join, capitalizeAscii
from sequtils import map, concat
import json
from re import re, split

proc splitByDelimiter(key: string): seq[string] =
  return split(key, re"(-|_|/|\s)")

proc isRecursion(node: JsonNode): bool =
  return node.kind == JObject or node.kind == JArray

proc camelize(node: JsonNode): JsonNode =
  var newNode: JsonNode
  if node.kind == JObject:
    newNode = %*{}
    for key, value in node.pairs:
      var newValue = value
      if value.isRecursion:
        newValue = value.camelize
      let parts = key.splitByDelimiter
      let capitalizedParts = map(parts[1..parts.len - 1], capitalizeAscii)
      let newKey = join(concat([parts[0..0], capitalizedParts]))
      newNode.add(newKey, newValue)
  elif node.kind == JArray:
    newNode = %*[]
    for element in node.getElems:
      var newValue = element
      if element.isRecursion:
        newValue = element.camelize
      newNode.add(newValue)
  else:
    newNode = node
  return newNode

export camelize