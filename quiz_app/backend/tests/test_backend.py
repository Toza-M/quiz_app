import unittest
import json
import os
import sqlite3
from app import app
from auth import init_db

class BackendTestCase(unittest.TestCase):
    def setUp(self):
        """Set up a temporary database and test client before each test."""
        app.config['TESTING'] = True
        # Use a separate test database to avoid messing with your real data
        app.config['DATABASE'] = 'test_quiz_app.db'
        self.client = app.test_client()
        
        # Initialize the test database schema
        init_db()

    def tearDown(self):
        """Clean up the test database after each test."""
        if os.path.exists('quiz_app.db'):
            # Note: auth.py hardcodes 'quiz_app.db', so we ensure it's cleared
            pass 

    def test_register_user(self):
        """Test user registration functionality."""
        response = self.client.post('/auth/register', 
            data=json.dumps({
                'username': 'testuser',
                'email': 'test@example.com',
                'password': 'password123'
            }),
            content_type='application/json')
        
        self.assertEqual(response.status_code, 201)
        self.assertIn(b'User registered successfully', response.data)

    def test_register_duplicate_email(self):
        """Test that duplicate emails are rejected."""
        # Register first time
        self.client.post('/auth/register', 
            data=json.dumps({
                'username': 'user1',
                'email': 'dup@example.com',
                'password': 'pass'
            }), content_type='application/json')
        
        # Register second time with same email
        response = self.client.post('/auth/register', 
            data=json.dumps({
                'username': 'user2',
                'email': 'dup@example.com',
                'password': 'pass'
            }), content_type='application/json')
        
        self.assertEqual(response.status_code, 400)
        self.assertIn(b'Email already exists', response.data)

    def test_login_success(self):
        """Test successful login."""
        # First, register a user
        self.client.post('/auth/register', 
            data=json.dumps({
                'username': 'loginuser',
                'email': 'login@example.com',
                'password': 'securepassword'
            }), content_type='application/json')

        # Attempt login
        response = self.client.post('/auth/login', 
            data=json.dumps({
                'email': 'login@example.com',
                'password': 'securepassword'
            }), content_type='application/json')
        
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['user']['username'], 'loginuser')

    def test_login_invalid_credentials(self):
        """Test login with wrong password."""
        response = self.client.post('/auth/login', 
            data=json.dumps({
                'email': 'nonexistent@example.com',
                'password': 'wrong'
            }), content_type='application/json')
        
        self.assertEqual(response.status_code, 401)
        self.assertIn(b'Invalid email or password', response.data)

    def test_generate_quiz_no_file(self):
        """Test that generation fails if no file is provided."""
        response = self.client.post('/generate-quiz')
        self.assertEqual(response.status_code, 400)
        self.assertIn(b'No file uploaded', response.data)

if __name__ == '__main__':
    unittest.main()