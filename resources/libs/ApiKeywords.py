from resources.libs.ApiUser import ApiUser
import random
import logging


class ApiKeywords(ApiUser):
    def __init__(self, url, username, password, auth_url):
        super().__init__(url, username, password, auth_url)

    def verify_users_api_response(self, expected_users_count, expected_user_id, expected_username):
        response = self.get_users()
        response.raise_for_status()
        actual_users_list = response.json()
        actual_users_count = len(actual_users_list)
        assert actual_users_count == int(expected_users_count), \
            f'Expected users response to have {expected_users_count} users but had {actual_users_count}'
        actual_user_data = None
        for user in actual_users_list:
            if user['id'] == int(expected_user_id):
                actual_user_data = user
        assert 'id' and 'name' in actual_user_data, \
            f'Expected id or name not found in response'
        assert actual_user_data['name'] == expected_username, \
            f'Expected username to be "{expected_username}" but was "{actual_user_data["name"]}"'
        return actual_users_list

    def verify_posts_api_response(self, expected_posts_count, expected_post_id, expected_post_title):
        response = self.get_posts()
        response.raise_for_status()
        actual_posts_list = response.json()
        actual_posts_count = len(actual_posts_list)
        assert actual_posts_count == int(expected_posts_count), \
            f'Expected posts response to have {expected_posts_count} posts but had {actual_posts_count}'
        actual_post_data = None
        for post in actual_posts_list:
            if post['id'] == int(expected_post_id):
                actual_post_data = post
        assert 'id' and 'title' in actual_post_data, \
            f'Expected id or title not found in response'
        assert actual_post_data['title'] == expected_post_title, \
            f'Expected post title to be "{expected_post_title}" but was "{actual_post_data["title"]}"'
        return actual_posts_list
    
    def verify_creating_a_post_api_response(self, expected_user_id, expected_post_title, expected_post_body):
        response = self.post_posts(expected_user_id, expected_post_title, expected_post_body)
        response.raise_for_status()
        actual_post_data = response.json()
        assert 'id' and 'title' and 'body' and 'userId' in actual_post_data, \
            f'Expected id or title or body not found in response'
        assert actual_post_data['title'] == expected_post_title, \
            f'Expected post title to be "{expected_post_title}" but was "{actual_post_data["title"]}"'
        assert actual_post_data['body'] == expected_post_body, \
            f'Expected post body to be "{expected_post_body}" but was "{actual_post_data["body"]}"'
        assert actual_post_data['userId'] == expected_user_id, \
            f'Expected post userId to be "{expected_user_id}" but was "{actual_post_data["userId"]}"'
        return actual_post_data

    def verify_post_from_user_api_response(self,
                                           expected_user_id, 
                                           expected_post_id,
                                           expected_post_title):
        response = self.get_post_from_user(expected_user_id, expected_post_id)
        response.raise_for_status()
        actual_post_from_user = response.json()
        actual_length = len(actual_post_from_user)
        assert actual_length == 1, \
            f'Expected response to have 1 post but had {actual_length}'
        assert 'userId' and 'id' and 'title' and 'body' in actual_post_from_user[0], \
            f'Expected the response to have "userId", "id", "title" or "body" elements but some of the elements were not found'
        assert actual_post_from_user[0]['userId'] == int(expected_user_id), \
            f'Expected post userId to be "{expected_user_id}" but was "{actual_post_from_user[0]["userId"]}"'
        assert actual_post_from_user[0]['id'] == int(expected_post_id), \
            f'Expected post id to be "{expected_post_id}" but was "{actual_post_from_user[0]["id"]}"'
        assert actual_post_from_user[0]['title'] == expected_post_title, \
            f'Expected post title to be "{expected_post_title}" but was "{actual_post_from_user[0]["title"]}"'
        return actual_post_from_user
    
    def verify_not_found_users_error_code(self, user_id):
        response = self.get_a_user(user_id)
        assert response.status_code == 404
        return response
    
    def verify_incorrect_path(self, incorrect_path):
        response = self.get(incorrect_path)
        assert response.status_code == 404
        return response
    
    def verify_incorrect_method(self, http_method, endpoint_path):
        response = self.request(http_method, endpoint_path)
        assert response.status_code == 404
        return response
