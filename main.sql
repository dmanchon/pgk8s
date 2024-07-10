create extension plpython3u; 


CREATE OR REPLACE FUNCTION hello_plpython3u()
RETURNS text AS $$
from kubernetes import client, config
config.load_kube_config()
return json.dumps({"a":"Hello, PL/Python!"})
$$ LANGUAGE plpython3u;

select hello_plpython3u();

create or replace function store_credentials()
returns text as $$
import os
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

# Suppress insecure request warnings
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

K8S_API_SERVER = os.environ.get('KUBERNETES_SERVICE_HOST')
K8S_API_PORT = os.environ.get('KUBERNETES_SERVICE_PORT')
TOKEN_PATH = '/var/run/secrets/kubernetes.io/serviceaccount/token'
NAMESPACE_PATH = '/var/run/secrets/kubernetes.io/serviceaccount/namespace'

with open(TOKEN_PATH, 'r') as token_file:
    token = token_file.read()

with open(NAMESPACE_PATH, 'r') as namespace_file:
    namespace = namespace_file.read()

api_url = f"https://{K8S_API_SERVER}:{K8S_API_PORT}/api/v1/namespaces/{namespace}/pods"
headers = {
    'Authorization': f'Bearer {token}',
    'Accept': 'application/json',
}

response = requests.get(api_url, headers=headers, verify=False)

if response.status_code == 200:
    return response.json()

$$ language plpython3u;

SELECT store_credentials();

