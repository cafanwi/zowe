##### ADD this for Cert

```
RUN apt-get update
RUN apt-get install -y ca-certificates openssl
RUN mkdir -p /certs
COPY zowe.crt /certs/

RUN cp /certs/zowe.crt /usr/local/share/ca-certificates/ && \
    chmod 644 /usr/local/share/ca-certificates/zowe.crt

RUN openssl rehash /usr/local/share/ca-certificates/
```

## CREATE A DEPloy and Svc

## Test the service access within the cluster

Test Connectivity Within the Cluster:
Run a temporary pod within the same Kubernetes cluster and try to access the service using its DNS name. This can help you verify that the service is accessible from within the cluster.

```
kubectl run -it --rm --restart=Never cafanwi-test-pod --image=ubuntu -- /bin/bash
```

Inside the pod, use curl or wget to access the service using its DNS name (service name).

```
apt-get update
apt-get install curl
curl ubuntu-apache-service:80
```

Access Service from Another Pod:
If your application pods need to access the service, deploy a test pod that tries to reach the service. This can help verify that your application can successfully connect to the service.

Test from Outside the Cluster:
If you need to access the service from outside the Kubernetes cluster, you can use port forwarding to access the service from your local machine. Run the following command to forward traffic from your local port to the service's port:

```
kubectl port-forward service/zowe-apache-service 8080:80
```

I just use nodePort and was able to get on localhost

```
localhost:31354
```

###  Automating with GitLab?
- Save your username and password to the project environment
  - Use the gitlab-ci.yml script to deploy
