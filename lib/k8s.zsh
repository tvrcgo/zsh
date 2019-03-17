
alias kc="kubectl"

kc_pods() {
  kubectl get pods -o wide $@
}

kc_deps() {
  kubectl get deployments $@
}

kc_desc() {
  kubectl describe $@
}

kc_svcs() {
  kubectl get services $@
}

kc_ing() {
  kubectl get ingress $@
}

kc_nodes() {
  kubectl get nodes --show-labels $@
}

kc_deploy() {
  kubectl create -f ${1-deploy.yml} --save-config
}

kc_apply() {
  kubectl apply -f ${1-deploy.yml}
}

kc_delete() {
  kubectl delete -f ${1-deploy.yml}
}
