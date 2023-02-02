## Requeriments
---
* GKE/Kubernetes >= 1.20.8-gke.900
* Kubectl >= 1.22.0-rc.0
* Docker Engine >= 20.10.8
* Cluster: 2CPU 4RAM(minimum for one instance pods)
----
## Instalation Zabbix
----
* Create namespace to kubernetes:
   ```
   kubectl create namespace zabbix
  ```
   * Note: This command runs only once before starting the project.
----
* Configuration Deploy server:
  * By default the system would start with the following settings:
    * Replica:
       ```
        replicas: 1
        ```
    * Disk:
        ```
        apiVersion: v1
        kind: PersistentVolumeClaim
        metadata:
           name: scripts-alerts
           namespace: zabbix
        spec:
        accessModes:
            - ReadWriteOnce
        resources:
            requests:
            storage: 2Gi
        ```
    * Default CPU:
       ```
       resources:
            requests:
              cpu: "100m"
              memory: "250Mi"
            limits:
              cpu: "150m"
              memory: "500Mi"
        ```
   * Configure the parameter in ./server/deploy.yaml
----
* Configuration HPA :
  * By default the system would start with the following settings:
    * HorizontalPodAutoscaler:
       ```
        spec:
          minReplicas: 1
          maxReplicas: 3
       ```
    * Metrics:
        ```
        metrics:
        - type: Resource
          resource:
            name: cpu
            targetAverageUtilization: 80
        - type: Resource
          resource:
            name: memory
            targetAverageUtilization: 90
        ```
  ----

  * Configure the parameter in ./server/hpa.yaml

### Initializing the pods in
   ```
     kubectl apply -f server/
   ```
----
* Configuration Secrets :
  * By default the system would start with the following settings:
    * Secret:
       ```
       data:
          DB_HOST: changeme
          DB_PASSWORD: changeme
          DB_PORT: changeme
          DB_USER: changeme
      ```
  ----
  * Configure the parameter in ./secrets/sql-credenctials.yaml
    * Note: Change bank password.
### Initializing the pods in
   ```
     kubectl apply -f secrets/
  ```
----
* Configuration Web :
  * By default the system would start with the following settings:
     * Replica:
       ```
        replicas: 1
        ```
     * Default CPU:
          ```
          resources:
            requests:
              cpu: "150m"
              memory: "250Mi"
            limits:
              cpu: "1000m"
              memory: "500Mi"
        ```
   * Configure the parameter in ./web/deploy.yaml
### Initializing the pods in
   ```
     kubectl apply -f web/
   ```
----
* Configuration Deploy Agent:
  * By default the system would start with the following settings:
    * Replica:
       ```
        replicas: 1
        ```
    * Default CPU:
      ```
          resources:
            requests:
              cpu: "10m"
              memory: "25Mi"
            limits:
              cpu: "25m"
              memory: "50Mi"
        ```
### Initializing the pods in
   ```
     kubectl apply -f agent/
   ```
----
* Configuration Deploy ingress - https:
  * By default the system would start with the following settings:
    * ManagedCertificate:
        ```
         spec:
            domains:
             - mydomain.com
        ```
    * Ingress:
    ```
        metadata:
          name: zabbix
          namespace: zabbix
          annotations:
            networking.gke.io/managed-certificates: "zabbix"
          spec:
            rules:
              - host: mydomain.com
                http:
                  paths:
                    - backend:
                        serviceName: web
                        servicePort: 8080
       ```
  * Configure the parameter in ./ingress/ingress.yaml
    * Note: Change part of mydomain.com to your desired dns example www.zabbix-prod.com.br
### Initializing the pods in
   ```
     kubectl apply -f ingress/
   ```
----
* Configuration Deploy ingress - https:
  * By default the system would start with the following settings:
    * FrontendConfig:
        ```
        metadata:
          name: http-redirect-https
          namespace: zabbix
      spec:
        redirectToHttps:
          enabled: true
          responseCodeName: MOVED_PERMANENTLY_DEFAULT
        ```
  * Configure the parameter in ./front/front.yaml
### Initializing the pods in
   ```
     kubectl apply -f front/
   ```
----
* Note Server conection bank:
    *  To allow multiple connections to the bank, it is necessary to enable the configuration of the bank "max_replication_slots" above 10.

* Note Web cpu:
   *  If you want more speed on zabbix graphics, increase the cpu resource in the web deploy
---

## Download and branch

  ```
  git clone  https://github.com/aoliveira94/zabbix.git ~/zabbix
   cd ~/zabbix
```
## Note file image
 ```
  If you want to use the Zabbix alert to forward it to the google chat, do the docker build of the image in the repositor folder image.
```