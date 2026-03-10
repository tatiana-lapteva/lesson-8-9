**Cтруктура проекту**

├───experiments
│       .env
│       requirements.txt
│       train_and_push.py
├───goit-argo
│   │   .gitignore
│   │   application.yaml
│   │   README.md
│   │   terraform.tfstate
│   ├───apps
│   │   └───values
│   │           argocd-values.yaml
│   └───namespaces
│       ├───application
│       │       minio.yaml
│       │       mlflow-postgres.yaml
│       │       mlflow.yaml
│       │       prometheus-pushgateway.yaml
│       └───infra-tools
│   README.md


**1. Встановлення залежностей: **
pip install -r requirements.txt

**Перевірка 


**Як перевірити наявність MLflow:**

        kubectl get svc -n application | grep mlflow

**Як перевірити наявність PushGateway у кластері:**

        kubectl get pods -n monitoring
        kubectl get svc -n monitoring | grep pushgateway

**Як зробити port-forward:**

- MLflow UI (порт 5000):
        kubectl port-forward -n application svc/mlflow 5000:5000

http://localhost:5000

- MinIO API (порт 9000):
        kubectl port-forward -n application svc/minio 9000:9000

- MinIO UI (порт 9001):
    kubectl port-forward -n application svc/minio 9001:9001
http://localhost:9001

- PushGateway (порт 9091):
    kubectl port-forward -n monitoring svc/prometheus-pushgateway 9091:9091
http://localhost:9091і

**Запуск експериментів**
train_and_push.py
Результати експериментів доступні в MLflow UI: http://localhost:5000


**Як подивитись метрики в Grafana:**
port-forward для Grafana:
        kubectl port-forward -n infra-tools svc/prometheus-operator-grafana 3000:80
Відкрити Grafana: http://localhost:3000
Авторизуватись:
    login:    admin
    password: prom-operator

Додати Dashboard для MLflow метрик:
    Перейти в Dashboards → New → New Dashboard
    Натиснути Add visualization
    Обрати datasource Prometheus
    Ввести запити:
        mlflow_accuracy
        mlflow_loss

        
Посилання на скриншоти MLflow UI та Grafana Explore.
