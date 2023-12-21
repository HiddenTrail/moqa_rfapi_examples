*** Settings ***
Documentation    Test Suite for photos API requests

Resource       ../resources/vars/common_vars.robot

Library        ../resources/libs/ApiUser.py    ${URL}    ${username}    ${password}
Library        ../resources//libs/response_validation.py

Test Tags      api    photos


*** Variables ***
${PHOTOS_RESPONSE_FILE}    photos_response.json


*** Test Cases ***
Verify Users Api
    [Tags]    photos    json_validation
    [Documentation]    Verify /photos endpoint
    ${response}=    Get Photos
    Validate Json Schema    ${PHOTOS_RESPONSE_FILE}    ${response.json()}
    Validate Full Json Data    ${PHOTOS_RESPONSE_FILE}    ${response.json()}
