// create a pod
kubectl run my_pod --image nginx
// get pods
kubectl get pods
// in detail
kubectl get pods -o wide
// disrcibe the pod
kubectl describe pod my_pod
// to see logs of pod
kubectl logs my_pod
// delete the pod
kubectl delete pod my_pod
// to exec into the pod
kubectl exec -it my_pod -- bash

// create manifest file for pod 
vi first.yml
// inside it write the following code
apiVersion: v1
kind: Pod   
metadata:
  name: my_pod
spec:
  containers:
  - name: nginx
    image: nginx
// apply the manifest file
kubectl apply -f first.yml
// to see the pod
kubectl get pods
// to delete the pod
kubectl delete -pod my_pod

// create replica set
vi replicaset.yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-replicaset
  labels:
    app: bank
spec:
  replicas: 3
  selector:
    matchLabels:
      app: bank
  template:
  metadata:
    labels:
      app: bank
  spec:
    containers:
    - name: nginx
      image: nginx
// apply the replicaset
kubectl apply -f replicaset.yml
// to see the replicaset
kubectl get replicaset
// to see the pods created by replicaset
kubectl get pods -l app=bank
// to show labels
kubectl get pods --show-labels
// watch
kubectl pods watch

kubectl get pods -l app=bank -o wide
// scale the replicaset
kubectl scale replicaset my-replicaset --replicas=5

kubectl describe pod -l     app=bank | grep -i Image
// i want to update the image of the replicaset
kubectl set image replicaset my-replicaset nginx=nginx:latest

for kind: deployment

vi deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ib-deployment
  labels:
    app: bank
spec:
  replicas: 3
  selector:
    matchLabels:
      app: bank
  template:
  metadata:
    labels:
      app: bank
  spec:
    containers:
    - name: cont1
      image: sk/ib-image:latest
// apply the deployment
kubectl apply -f deployment.yml
// to see the deployment
kubectl get deployment
// to see the pods created by deployment
kubectl get pods -l app=bank
// detials
kubectl describe deployment ib-deployment
// to scale the deployment
kubectl scale deployment ib-deployment --replicas=5
// describe
kubectl dewcrube deploye -ib=deployment

// edit 
kubestl edit deploye ib-deployment
// roll out

kubectl rollout history  deployment ib-deployment

kubectl rollout status  deployment ib-deployment
