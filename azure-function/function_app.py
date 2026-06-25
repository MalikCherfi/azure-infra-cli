import azure.functions as func
import json
import socket

app = func.FunctionApp()


@app.route(route="hello", auth_level=func.AuthLevel.ANONYMOUS)
def hello(req: func.HttpRequest) -> func.HttpResponse:
    response = {
        "message": "Hello from AzureTech !",
        "service": "Azure Functions (Serverless)",
        "runtime": "Python 3.11",
        "host": socket.gethostname(),
    }
    return func.HttpResponse(
        json.dumps(response), mimetype="application/json", status_code=200
    )
