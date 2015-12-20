#Mariadb Dockerfile

Just a small mariadb powered with alpine linux optimized for k8s

##Kubernetes

### PO
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-test-pod
spec:
  containers:
    - name: mariadb-container
      image: alpinelib/mariadb:10.1
      volumeMounts:
          - name: secret-volume
            mountPath: /etc/secret-volume
  volumes:
    - name: secret-volume
      secret:
        secretName: mariadb-1
```

### Secret

For generate k8s secret just use 

```bash
./gen_k8s_secret.sh -n mariadb-1 -P $(openssl rand -base64 32)
```
