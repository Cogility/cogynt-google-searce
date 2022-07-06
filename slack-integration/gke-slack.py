import os
def gke_slack(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    request_json = request.get_json()
    secret_token=os.environ['slack_token']
    if secret_token==request.form['token']:
        if request.form['channel_name']=="rishabh_private_bot_space":
            if "stop" in request.form["text"]:
                return f'Performing stop operation'
            elif "start" in request.form["text"]:
                return f'Performing start operation'
