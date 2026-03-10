
### MLOps EKS + ArgoCD


**Структура проекту**

```
goit-infra/
├── eks-vpc-cluster/    # Terraform: VPC + EKS кластер
└── argocd/             # Terraform: встановлення ArgoCD
goit-argo/
├── apps/
│   └── values/
│       └── argocd-values.yaml
├── namespaces/
│   ├── application/
│   │   ├── nginx.yaml
│   │   └── ns.yaml
│   └── infra-tools/
│       └── ns.yaml
├── application.yaml    # ArgoCD Application CR
└── README.md
```


**Запуск проекту:**


1. Створити S3 bucket для стейтів

   ```
      aws s3 mb s3://mlops-tfstate-pikachu-2026 --region us-east-1
   ```

2. Розгорнути VPC + EKS класте

         сd eks-vpc-cluster/
         terraform init
         terraform plan
         terraform apply

3. Оновити kubeconfig

         aws eks update-kubeconfig --name goit --region us-east-1 --profile default

4. Розгорнути ArgoCD

         сd argocd/
         terraform init
         terraform plan
         terraform apply

5. Перевірка що ArgoCD працює

         kubectl get pods -n infra-tools

6. Застосувати Application CR

         kubectl apply -f application.yaml

   перевірка:

         kubectl get applications -n infra-tools

6. Отримати пароль до ArgoCD

         kubectl get secret argocd-initial-admin-secret -n infra-tools \
         -o jsonpath='{.data.password}' | base64 --decode


7. Відкрити UI ArgoCD

         kubectl port-forward svc/argocd-server -n infra-tools 8080:80
      
   в браузері:

         http://localhost:8080

8. Перевірка деплою

   статус application
         
            kubectl get applications -n infra-tools

   namespace application
         
            kubectl get pods -n application

   namespace infra-tools
         
            kubectl get all -n infra-tools



9. Видалення проекту

         cd argocd/
         terraform destroy

         cd eks-vpc-cluster/
         terraform destroy

**Посилання**

- Git рупозиторій з application.yaml: https://github.com/tatiana-lapteva/lesson-7

- ArgoCD Helm chart: https://argoproj.github.io/argo-helm
