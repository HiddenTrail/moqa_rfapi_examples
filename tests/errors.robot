*** Settings ***
Documentation    Test Suite for API requests

Resource       ../resources/vars/common_vars.robot

Library        ../resources/libs/ApiKeywords.py    ${URL}    ${username}    ${password}    ${AUTH_URL}

Test Tags      api    errors


*** Variables ***
${NOT_EXISTING_USER_ID}    11
${INCORRECT_PATH}          /images


*** Test Cases ***
Verify User Is Not Found
    [Tags]    user_not_found
    [Documentation]    Verify 404 error code in /users endpoint
    Verify Not Found Users Error Code    ${NOT_EXISTING_USER_ID}

Verify An Incorrect Enpoint
    [Tags]    incorrect_path
    [Documentation]    Verify 404 error code with incorrect endpoint
    Verify Incorrect Path    ${INCORRECT_PATH}

Verify An Incorrect Http Method
    [Tags]    incorrect_method
    [Documentation]    Verify 404 error code with incorrect http method
    Verify Incorrect Method    DELETE    /posts
