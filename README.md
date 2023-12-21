# moqa_rfapi
Masters of QA - Robot Framework API testing

## Installation

Tests can be run by installing required software in your computer or using docker.

### Local

1. Install Python 3
2. Install requirements with pip (preferably in venv)
    - python3 -m pip install -r- requirements.txt

### Docker

1. Install Docker
2. Run test (see below) with -d option
    - docker image is build if not already existing and the test is run inside a docker container

## Running the tests

Use the run_test.sh script to run the tests.

Script has a help option to list all the available options:
``` shell
./run_test.sh -h
```

### Example

Run all the "api" tagged tests using docker:
``` shell
./run_test.sh -d -t api
```

- By default tests are run using variables from the variable file: ./environments/test_env.py
