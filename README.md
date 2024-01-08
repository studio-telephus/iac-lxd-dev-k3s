# iac-lxd-dev-k3s

DEV cluster

## Move Kubernetes config file to Gitlab runner

    lxc exec container-adm-glrunner-k1 -- bash -c 'mkdir -p /home/gitlab-runner/.kube'
    lxc file push .terraform/kube_config.yml container-adm-glrunner-k1/home/gitlab-runner/.kube/config
    lxc exec container-adm-glrunner-k1 -- bash -c 'chown gitlab-runner: /home/gitlab-runner/.kube'
    
Then
    
    lxc exec container-adm-glrunner-k1 -- /bin/bash
    su - gitlab-runner
    kubectl get pods --all-namespaces

