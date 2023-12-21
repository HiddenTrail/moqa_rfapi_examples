*** Settings ***
Resource       ../resources/vars/common_vars.robot

Library    RequestsLibrary


*** Keywords ***
Authenticate And Login
    [Arguments]         ${username}           ${password}
    ${token_type}       ${access_token}       Get Access Token
    ${authorization}    Catenate              ${token_type}    ${access_token}
    &{login_headers}    Create Dictionary     Authorization=${authorization}
    Login User With Headers    ${username}    ${password}    &{login_headers}
    Create Session      jsonplaceholder       url=${URL}     headers=&{login_headers}    verify=true

Get Access Token
    ${response}        RequestsLibrary.GET    ${AUTH_URL}/samuli-paasimaa-ht/fake_auth/token
    ...    expected_status=200
    ${token_type}      Set Variable           ${response.json()}[token_type]
    ${access_token}    Set Variable           ${response.json()}[access_token]
    RETURN    ${token_type}    ${access_token}

Login User With Headers
    [Arguments]    ${username}    ${password}    &{headers}
    &{login_body}    Create Dictionary     username=${username}    password=${password}
    ${response}    RequestsLibrary.POST    ${AUTH_URL}/samuli-paasimaa-ht/fake_auth/login
    ...    headers=${headers}    json=${login_body}
    ...    expected_status=201

Get Users With Session
    ${response}    Get On Session    jsonplaceholder    /users
    ...    expected_status=200
    ${length_of_response_array}    Get Length    ${response.json()}
    Should Be Equal As Integers    10    ${length_of_response_array}
