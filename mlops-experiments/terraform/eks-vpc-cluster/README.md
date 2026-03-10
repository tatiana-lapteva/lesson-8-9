**EKS + VPC Terraform Project**

створює інфраструктуру в AWS за допомогою Terraform:

-   VPC

-   Public та Private Subnets

-   Amazon EKS Cluster

-   Managed Node Group

-   S3 backend для зберігання Terraform state


**Передумови:**

-   Terraform ≥ 1.5

-   AWS CLI

-   kubectl

-   налаштований AWS profile

**Запуск проекту:**

1. Створити S3 bucket

        aws s3 mb s3://mlops-tfstate-pikachu-2026 --region us-east-1 --profile default

2. Перейти у корінь проєкту

        cd eks-vpc-cluster

3. Ініціалізувати Terraform

        terraform init

    Очикуваний результат: Terraform has been successfully initialized!

4. Створити інфраструктуру

        terraform apply

    підтвердити: yes

    Створення займає приблизно 30 хвилин.


5. Перевірка кластера

        aws eks list-clusters --region us-east-1 --profile default


6. Налаштувати kubeconfig

        aws eks --region us-east-1 update-kubeconfig --name goit --profile default

7. Перевірити nodes

        kubectl get nodes


8. Оutput

        terraform output

9. Видалення інфраструктури

        terraform destroy