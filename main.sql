

create extension plpython3u; 


CREATE OR REPLACE FUNCTION hello_plpython3u()
RETURNS text AS $$
import json
from kubernetes import client, config
config.load_incluster_config()
v1 = client.CoreV1Api()
ret = v1.list_namespaced_pod("default")
pods_json = client.ApiClient().sanitize_for_serialization(ret)
return json.dumps(pods_json)
$$ LANGUAGE plpython3u;

select hello_plpython3u();


