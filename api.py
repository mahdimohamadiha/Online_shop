from flask import Flask, request, json

app = Flask(__name__)

@app.route('/signup', methods=['GET', 'POST'])
def sign_up():
    username_and_password = []
    if (request.method == 'POST'):
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        username_and_password[0] = request_data['username']
        username_and_password[1] = request_data['password']
        return username_and_password

if __name__ == '__main__':
    app.run()