*** Settings ***
Documentation    Test Suite for API requests

Resource       ../resources/vars/common_vars.robot

Library        ../resources/libs/ApiKeywords.py    ${URL}    ${username}    ${password}    ${AUTH_URL}

Test Tags      api    users    posts


*** Variables ***
${expected_users_count}         10
${expected_user_id}             3
${expected_username}            Clementine Bauch
${expected_posts_count}         100
${expected_post_id}             30
${expected_post_title}          a quo magni similique perferendis
${expected_new_post_user_id}    1
${expected_new_post_title}      Test Post Title
${expected_new_post_body}       Test Post Body


*** Test Cases ***
Verify Users Api
    [Tags]    users
    [Documentation]    Verify /users endpoint
    Verify Users Api Response    ${expected_users_count}    ${expected_user_id}    ${expected_username}

Verify Posts Api
    [Tags]    posts
    [Documentation]    Verify /posts endpoint
    Verify Posts Api response    ${expected_posts_count}    ${expected_post_id}    ${expected_post_title}

Verify Users Api With Filtering UserId and PostId
    [Tags]    filter_user
    [Documentation]    Verify /users/user_id/posts endpoint with filtering
    Verify Post From User Api Response    ${expected_user_id}    ${expected_post_id}    ${expected_post_title}

Verify Creating a Post
    [Tags]    create_post
    [Documentation]    Verify /posts endpoint with POST method
    Verify Creating A Post Api Response
    ...    ${expected_new_post_user_id}    ${expected_new_post_title}    ${expected_new_post_body}
