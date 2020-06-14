import unittest
import camelize
import json

suite "snake -> camel":
  test "simple node":
    check camelize(%*{"snake_case_key": "value"}) == %*{"snakeCaseKey": "value"}
  
  test "deep node":
    check camelize(%*{
      "root_key": {
        "first_level_key": {
          "second_level_key": "deep_content",
          "array_key": [1, 2, 3]
        }
      }
    }) == %*{
      "rootKey": {
        "firstLevelKey": {
          "secondLevelKey": "deep_content",
          "arrayKey": [1, 2, 3]
        }
      }
    }
  
  test "array node":
    check camelize(%*[
      {"element_name": "first"},
      {"element_name": "second"}
    ]) == %*[
      {"elementName": "first"},
      {"elementName": "second"}
    ]

  test "deep array node":
    check camelize(%*[
      [
        {"deep_element_name": "first"}
      ],
      [
        {"deep_element_name": "second"}
      ]
    ]) == %*[
      [
        {"deepElementName": "first"}
      ],
      [
        {"deepElementName": "second"}
      ]
    ]
  
  test "string node":
    check camelize(%*"string") == %*"string"
    
  test "string":
    check camelize("snake_case_string") == "snakeCaseString"

suite "camel -> snake":
  test "simple node":
    check underscore(%*{"snakeCaseKey": "value"}) == %*{"snake_case_key": "value"}

  test "string":
    check underscore("snakeCaseString") == "snake_case_string"
  
