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
        secretName: mysql-secret-1
```

### Secret
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret-1
data:
  mysql-config: base64(Config)
```

###config
```
MYSQL_ROOT_PASSWORD = PASSWORD_DIOJAZIODJZAODIA
MYSQL_USER      = ME        <-  (OPTION)
MYSQL_PASSWORD  = PWD       <-  (OPTION)
MYSQL_DATABASE  = MYDB      <-  (OPTION)
```
