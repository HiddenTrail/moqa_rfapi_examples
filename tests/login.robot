*** Settings ***
Documentation    Test Suite for login and authentication

Resource       ../resources/vars/common_vars.robot
Resource       ../resources/api_resource.robot

Library        ../resources/libs/ApiUser.py    ${URL}    ${username}    ${password}

Test Tags      api    login    auth


*** Test Cases ***
Verify Authentication And Login And Users Api With Robot Requests
    [Documentation]    Verify authentication, login and users api using Robot's Requests library
    Authenticate And Login    ${username}    ${password}
    Get Users With Session

Test Authentication And Login
    [Documentation]    Verify authentication and login using ApiUser library
    Fetch Token    ${AUTH_URL}
    Login User    ${AUTH_URL}
