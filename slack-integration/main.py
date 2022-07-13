import os
from flask import Flask,request
from typing import no_type_check
from googleapiclient import discovery
from oauth2client.client import GoogleCredentials
import time
import subprocess as sb
import requests


project_id= os.getenv('GCP_PROJECT_ID') #type project name in env variable 
credentials = GoogleCredentials.get_application_default()
service = discovery.build('container', 'v1', credentials=credentials)
default_dic={"imply-data":[3,3],"storage":[6,6],"worker":[3,20]}
headers = {'Content-type': 'application/json',}
app = Flask(__name__)


def node_pool_start(project_id,location,cluster_name,node_pools):
    #this functio is to scale up the node pools
    #It will first enable the auto scalling at the node pool
    #second it will resize the node pool from zero to default value 
    for pool in node_pools:
        node_pool_name = pool['name']
        print("name:" ,node_pool_name)
        if node_pool_name in default_dic:
            count = default_dic[node_pool_name]
            cmd=f"gcloud container node-pools update {node_pool_name} --cluster {cluster_name} --project {project_id} --region {location} --min-nodes {count[0]} --max-nodes {count[1]} --enable-autoscaling"
            sb.check_output(cmd,shell=True)
            cmd = f"gcloud container clusters resize {cluster_name} --node-pool {node_pool_name} --num-nodes {count[0]} --region {location} --project {project_id} --quiet"
            sb.check_output(cmd,shell=True)
    return

def node_pool_stop(project_id,location,cluster_name,node_pools):
    #this functio is to scale up the node pools
    #It will first enable the auto scalling at the node pool
    #second it will resize the node pool from zero to default value
    for pool in node_pools:
        node_pool_name = pool['name']
        print("name:" ,node_pool_name)
        cmd=f"gcloud container clusters update {cluster_name} --no-enable-autoscaling --node-pool={node_pool_name} --region={location} --project={project_id}"
        sb.check_output(cmd,shell=True)
        cmd = f"gcloud container clusters resize {cluster_name} --node-pool {node_pool_name} --num-nodes 0 --region {location} --project {project_id} --quiet"
        sb.check_output(cmd,shell=True)
    return

def get_node_pool_list(project_id,command,cluster_name,location):
    #This function is to get the name of the node pools available in the cluster which we want to scale up or down
    parent = f'projects/{project_id}/locations/{location}/clusters/{cluster_name}'
    request = service.projects().locations().clusters().nodePools().list(parent=parent)
    response = request.execute()
    node_pools = response['nodePools']
    if command == "start":
        print("performing start")
        msg= {"text":f"Start operation is in progress for {cluster_name} cluster"}   
        msg_data = str(msg)
        #the aboe message will be posted to the slack channel using the webhook url which we will copy from slack bot basic information page
        requests.post('', headers=headers, data=msg_data)
        #To post the mesaage at slack channel the webhook url should be place in above request function.
        node_pool_start(project_id,location,cluster_name,node_pools)
        message=f"Node-polls for {cluster_name} cluster started"
        return message
        
    elif command == "stop":
        print("performing stop")
        msg= {"text":f"Stop operation is in progress for {cluster_name} cluster"}   
        msg_data = str(msg)
        #the aboe message will be posted to the slack channel using the webhook url which we will copy from slack bot basic information page
        requests.post('', headers=headers, data=msg_data)
        #To post the mesaage at slack channel the webhook url should be place in above request function.
        node_pool_stop(project_id,location,cluster_name,node_pools)
        message = f"Node-polls for {cluster_name} cluster stopped"
        return message

@app.route("/", methods=['POST'])
def main():
    #this function is the entry point of the post request send through the slack bot
    #Only those slack bot request will be accepted whose token value matches (already stored in secret manager)
    #Also from a particular channel.
    data=request.form
    secret_token=os.environ['slack_token']
    if secret_token==request.form['token']:
        if request.form['channel_name']=="cogility-gcp-us":
            text=request.form["text"]
            spec=text.split()    
            command=spec[0]
            cluster_name=spec[1]
            location=spec[2]
            message=get_node_pool_list(project_id,command,cluster_name,location)
            return message
if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
