# -*- coding: utf-8 -*-
# EVGEN - Christer Jonassen

from flask import Flask, render_template, request, url_for
from functools import wraps
from flask import request, Response
import time
import subprocess

def check_auth(username, password):
    """This function is called to check if a username /
    password combination is valid.
    """
    return username == 'changeme' and password == 'changeme'

def authenticate():
    """Sends a 401 response that enables basic auth"""
    return Response(
    'Could not verify your access level for that URL.\n'
    'Beklager, ingen adgang :/', 401,
    {'WWW-Authenticate': 'Basic realm="Givz credentialz plz"'})

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            return authenticate()
        return f(*args, **kwargs)
    return decorated

# Initialize the Flask application
app = Flask(__name__)

# Define a route for the default URL, which loads the form
@app.route('/')
@requires_auth
def form():
    return render_template('form_submit.html')

# Define a route for the action of the form, for example '/hello/'
# We are also defining which type of requests this route is 
# accepting: POST requests in this case
@app.route('/evgen/', methods=['POST'])
@requires_auth
def evgen():
    timestamp = int(time.time())
    sted=request.form['sted']
    tidspunkt=request.form['tidspunkt']
    ekstratekst=request.form['ekstratekst']
    subprocess.check_call(['./evgen.sh', sted.encode("utf-8"), tidspunkt.encode("utf-8"), ekstratekst.encode("utf-8")])
    return render_template('form_action.html', sted=sted, tidspunkt=tidspunkt, ekstratekst=ekstratekst, timestamp=timestamp)

# Run the app :)
#app.debug = True

if __name__ == '__main__':
  app.run( 
        host="0.0.0.0",
        port=int("1337")
  )

