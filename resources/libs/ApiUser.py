from requests import Session
from urllib.parse import urljoin
import logging


class ApiUser(Session):
    def __init__(self, url, username, password, auth_url=None):
        super().__init__()
        self.url = url
        self.username = username
        self.password = password
        if auth_url:
            self.fetch_token(auth_url)
            self.login_user(auth_url)

    def request(self, method, url, *args, **kwargs):
        if url.startswith('http'):
            joined_url = url
        else:
            joined_url = urljoin(self.url, url)
        logging.info(f'{method} Request to {joined_url}')
        logging.debug(f'Request headers: {self.headers}')
        response = super().request(method, joined_url, *args, **kwargs)
        logging.debug(f'Response: {response.text}')
        logging.debug(f'Response headers: {response.headers}')
        return response

    def fetch_token(self, auth_url, ok_status=True):
        response = self.get(f'{auth_url}/samuli-paasimaa-ht/fake_auth/token')
        if ok_status: response.raise_for_status()
        json_response = response.json()
        try:
            self.access_token = json_response['access_token']
        except KeyError:
            raise AssertionError('access_token not present in the response')
        try:
            self.token_type = json_response['token_type']
        except KeyError:
            raise AssertionError('token_type not present in the response')
        self.headers['Authorization'] = f'{self.token_type} {self.access_token}'
        return response

    def login_user(self, auth_url, ok_status=True):
        payload = {
            "username": self.username,
            "password": self.password
        }
        logging.info(f'Payload {payload}')
        response = self.post(f'{auth_url}/samuli-paasimaa-ht/fake_auth/login', json=payload)
        if ok_status: response.raise_for_status()
        json_response = response.json()
        assert 'username' and 'password' in json_response, \
            'username and/or password not present in the response'
        return response

    def get_users(self):
        response = self.get('/users')
        return response
    
    def get_a_user(self, user_id):
        response = self.get(f'/users/{user_id}')
        return response

    def get_posts(self):
        response = self.get('/posts')
        return response
    
    def post_posts(self, user_id, title, body):
        payload = {
            "userId": user_id,
            "title": title,
            "body": body
        }
        response = self.post('/posts', json=payload)
        return response

    def get_post_from_user(self, user_id, post_id):
        response = self.get(f'/users/{user_id}/posts?id={post_id}')
        return response

    def get_photos(self):
        response = self.get('/photos')
        return response
