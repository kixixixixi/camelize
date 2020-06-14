from strutils import join, capitalizeAscii, toLowerAscii
from sequtils import map, concat
import json
from re import re, split, findAll

proc splitByUpperCharacter(key: string): seq[string] =
  return key.findAll(re"(^[a-z][a-z]+|[A-Z][a-z]+)").map(toLowerAscii)

proc splitByDelimiter(key: string): seq[string] =
  return split(key, re"(-|_|/|\s)")

proc isRecursion(node: JsonNode): bool =
  return node.kind == JObject or node.kind == JArray

proc camelize(key: string): string =
  let parts = key.splitByDelimiter
  let capitalizedParts = map(parts[1..parts.len - 1], capitalizeAscii)
  return join(concat([parts[0..0], capitalizedParts]))

proc camelize(node: JsonNode): JsonNode =
  var newNode: JsonNode
  if node.kind == JObject:
    newNode = %*{}
    for key, value in node.pairs:
      var newValue = value
      if value.isRecursion:
        newValue = value.camelize
      let newKey = key.camelize
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

proc underscore(key: string): string =
  let parts = key.splitByDelimiter.join.splitByUpperCharacter
  return parts.join("_")

proc underscore(node: JsonNode): JsonNode =
  var newNode: JsonNode
  if node.kind == JObject:
    newNode = %*{}
    for key, value in node.pairs:
      var newValue = value
      if value.isRecursion:
        newValue = value.underscore
      let newKey = key.underscore
      newNode.add(newKey, newValue)
  elif node.kind == JArray:
    newNode = %*[]
    for element in node.getElems:
      var newValue = element
      if element.isRecursion:
        newValue = element.underscore
      newNode.add(newValue)
  else:
    newNode = node
  return newNode

export camelize, underscore