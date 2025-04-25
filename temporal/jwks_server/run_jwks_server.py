import json
import os

from flask import Flask

app = Flask(__name__)


@app.route('/.well-known/jwks.json', methods=['GET'])
def get_jwks():
    jwks_data = os.getenv('JWKS_DATA', "{}")
    return json.loads(jwks_data)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
