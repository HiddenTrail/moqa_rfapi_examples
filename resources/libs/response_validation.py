from genson import SchemaBuilder
from jsonschema import validate
from pathlib import Path
from json import load as json_to_dict
from unittest import TestCase
import logging


test_data_path = Path(__file__).parent.parent.parent.absolute() / 'test_data'


def validate_json_schema(expected_data_file, actual_dict):
    logging.info(f'Validates response JSON schema (element keys and value types) against the file "{expected_data_file}"')
    builder = SchemaBuilder()
    test_file_path =  test_data_path / expected_data_file
    test_data = _get_json_file_as_dict(test_file_path)
    builder.add_object(test_data)
    json_schema = builder.to_schema()
    logging.debug(f'JSON schema: \n{builder.to_json(indent=2)}')
    validate(instance=actual_dict, schema=json_schema)


def validate_full_json_data(expected_data_file, actual_dict):
    logging.info(f'Validates response JSON data completely against the file "{expected_data_file}"')
    test_file_path =  test_data_path / expected_data_file
    test_data = _get_json_file_as_dict(test_file_path)
    test_case = TestCase()
    test_case.assertEqual(test_data, actual_dict)


def _get_json_file_as_dict(file_path):
    with open(file_path) as json_file:
        data_dict = json_to_dict(json_file)
    return data_dict
