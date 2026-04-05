Launch Amazon Linux 2023 , t2.micro

Attach a IAM ROLE TE=EC2, Permisions = admin

vi .bashrc

export PATH=$PATH:/usr/local/bin/
:wq!

source .bashrc

ssh-keygen

cp /root/.ssh/id_rsa.pub my-keypair.pub

chmod 777 my-keypair.pub

vi kops.sh

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
wget https://github.com/kubernetes/kops/releases/download/v1.32.0/kops-linux-amd64
chmod +x kops-linux-amd64 kubectl
mv kubectl /usr/local/bin/kubectl
mv kops-linux-amd64 /usr/local/bin/kops



aws s3api create-bucket --bucket sk-kops-testbkt143333.k8s.local --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1
aws s3api put-bucket-versioning --bucket sk-kops-testbkt143333.k8s.local --region ap-south-1 --versioning-configuration Status=Enabled
export KOPS_STATE_STORE=s3://sk-kops-testbkt143333.k8s.local
kops create cluster --name=sk.k8s.local --zones=ap-south-1a,ap-south-1b --control-plane-count=1 --control-plane-size=t3.medium --node-count=2 --node-size=t3.small --node-volume-size=20 --control-plane-volume-size=20 --ssh-public-key=my-keypair.pub --image=ami-02d26659fd82cf299 --networking=calico --topology=public
kops update cluster --name sk.k8s.local --yes --admin


wq!

sh kops.sh

export KOPS_STATE_STORE=s3://sk-kops-testbkt143333.k8s.local

kops validate cluster --wait 10m


-- kops get cluster

-- kubectl get nodes/no

-- kubectl get nodes -o wide

Suggestions:
 * list clusters with: kops get cluster
 * edit this cluster with: kops edit cluster sk.k8s.local
 * edit your node instance group: kops edit ig --name=sk.k8s.local nodes-ap-south-1a
 * edit your control-plane instance group: kops edit ig --name=sk.k8s.local control-plane-ap-south-1a


kops delete cluster --name sk.k8s.local --yes


// create pods 
vi deployments.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
  metadata:
    labels:
      app: nginx
  spec:
    containers:
    - name: nginx
      image: nginx:latest
      ports:
      - containerPort: 80   


kubectl apply -f deployments.yaml
// get pods
kubectl get pods

// which pod in which node
kubectl get pods -o wide 
// get deployments
kubectl get deployments
// delete deployment
kubectl delete deployment nginx-deployment
// scaleout deployment
kubectl scale deployment nginx-deployment --replicas=5 // horizontal scaling
// scaleup deployment
kubectl scale deployment nginx-deployment --replicas=10 // vertical scaling
// namespace
kubectl get namespaces
// to check which namsape have pods
kubectl get pods --all-namespaces
// 
kubectl config view
// switch to another context
kubectl config set-context --current --namespace=<namespace-name>

// create namespace
kubectl create namespace my-namespace 
// create pods here
kubectl run prod1 --image nginx


// Role-Based Access Control (RBAC)

// daemon set

// waht is nodeport and cluster ip and loadbalancer

kubectl get services
kubectl delete service nginx-service

// mterics server
kubectl top nodes
kubectl top pods
// how to insall 
kubetctl apply -f https://github.com/kubernets-sign/metrics-server/releases/latest/download/components.yaml 


kubectl autoscale deployment nginx-deployment --min=2 --max=10 --cpu-percent=50

kubectl get hpa


// resource Quota
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi 
    pods: "10"


// persistante volume 
apiVersion: v1
kind: PersistentVolume  
metadata:
  name: pv1
spec:
  capacity: 
    storage: 10Gi
  accessModes:
    - ReadWriteOnce 
    awsElasticBlockStore:
    volumeID: <volume-id>
    fsType: ext4

kubectl apply -f pv.yaml
// list pv
kubectl get pv
// create pvc
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc1  
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi 
kubectl apply -f pvc.yaml
// list pvc 
kubectl get pvc
// create pod with pvc
apiVersion: v1
kind: Deployment
metadata: 
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
  metadata:
    labels:
      app: nginx
  spec:
    containers:
    - name: nginx
      image: nginx:latest
      ports:
      - containerPort: 80 
      volumeMounts:
      - name: nginx-storage
        mountPath: /tem/persistant
  volumes:
   - name: nginx
    persistentVolumeClaim:
      claimName: pvc1


// set env
kubectl set env deployment/nginx-deployment MYSQL_PASSWORD=abc123

// configmap
// create configmap file vars
MYSQL_PASSWORD=abc123
MYSQL_USER=root

kubectl create configmap mysql-config --from-env-file=vars
kubectl set env deploy nginx-deployment --from=configmap/db-config
// delte configmap
kubectl delete configmap mysql-config
// secret
kubectl create secret generic my_secret --from-env-file=vars
// get secret
kubectl get secrets
// desribe secret
kubectl describe secret my_secret
// set secret as env
kubectl set env deploy/nginx-deployment --from=secret/my_secret


kubectl get secrets my_secret -o yaml
// decode secret
echo "base64_encoded_value" | base64 --decode

// sidecar container what is it and how to use it

apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: main-container
    image: my-app:latest
  - name: sidecar-container
    image: log-collector:latest
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log/app
  volumes:
  - name: shared-logs
    emptyDir: {}  

// what is init container and how to use it
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  initContainers:
  - name: init-container
    image: busybox
    command: ['sh', '-c', 'echo Initializing... && sleep 5']
  containers:
  - name: main-container
    image: my-app:latest  


// how to check logs of sidecar container
kubectl logs my-pod -c sidecar-container
// how to check logs of init container
kubectl logs my-pod -c init-container

// how to check logs of main container
kubectl logs my-pod -c main-container
// how to check logs of all container in a pod
kubectl logs my-pod --all-containers=true
// how to check logs of a pod with label
kubectl logs -l app=nginx --all-containers=true


//ingress controller how to use it and what is it
apiVersion: networking.k8s.io/v1
kind: Ingress 
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http: 
      paths:  


// how to install ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml 

// create httpd deployment
// create nginx deployment
// create ingress resource to route traffic to httpd and nginx deployment based on path
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths: 



// how to check ingress resource
kubectl get ingress
// how to check ingress resource with details
kubectl describe ingress my-ingress 

// how to check ingress controller logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx --tail=-1

// how to delete ingress resource
kubectl delete ingress my-ingress

// how to delete ingress controller
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v

// pods sheduling
// node selector
// node affinity
// taints and tolerations


// install hellm
curl -fsSl -o get_helm.sh  https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 
chmod 700 get_helm.sh
./get_helm.sh
helm version

// install ArgoCD using helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update



