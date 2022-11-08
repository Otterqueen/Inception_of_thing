k3d cluster create iot -p 8080:8080@loadbalancer -p 8888:8888@loadbalancer # -p redirige le port 8080 de notre cluster sur 8080 du sercice loadbalancer
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 
   
kubectl wait deployment -n argocd argocd-redis                       --for condition=Available=True --timeout=90s
kubectl wait deployment -n argocd argocd-notifications-controller    --for condition=Available=True --timeout=90s
kubectl wait deployment -n argocd argocd-applicationset-controller   --for condition=Available=True --timeout=90s
kubectl wait deployment -n argocd argocd-repo-server                 --for condition=Available=True --timeout=90s
kubectl wait deployment -n argocd argocd-dex-server                  --for condition=Available=True --timeout=90s
kubectl wait deployment -n argocd argocd-server                      --for condition=Available=True --timeout=90s

kubectl apply -f .\argoCD\argocd-secret.yml 
kubectl apply -f .\argoCD\development-project.yaml 
kubectl apply -f .\argoCD\wil-app.yaml 
kubectl apply -f .\argoCD\argocd-server-svc.yml 
