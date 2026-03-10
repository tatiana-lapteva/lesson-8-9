import os
import shutil
from dotenv import load_dotenv
load_dotenv()

import mlflow
import mlflow.sklearn
from mlflow.tracking import MlflowClient
from sklearn.datasets import load_iris
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, log_loss
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway


experiment_name = "Iris Classification"
pushgateway_url = os.environ.get("PUSHGATEWAY_URL", "http://localhost:9091")

param_grid = [
    {"learning_rate": 0.001, "epochs": 50},
    {"learning_rate": 0.01, "epochs": 100},
    {"learning_rate": 0.1, "epochs": 200},   
]

mlflow.set_tracking_uri(os.environ['MLFLOW_TRACKING_URI'])

experiment = mlflow.get_experiment_by_name(experiment_name)
if experiment is None:
    experiment_id = mlflow.create_experiment(experiment_name)
    print(f"✅ Створено експеримент '{experiment_name}' (ID={experiment_id})")
else:
    experiment_id = experiment.experiment_id
    print(f"ℹ️ Використовується існуючий експеримент '{experiment_name}' (ID={experiment_id})")

X, y = load_iris(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=42)

results = []

for params in param_grid:
    learning_rate = params["learning_rate"]
    epochs = params["epochs"]

    with mlflow.start_run(experiment_id=experiment_id) as run:
        run_id = run.info.run_id
        mlflow.log_param("learning_rate", learning_rate)
        mlflow.log_param("epochs", epochs)

        model = LogisticRegression(C=learning_rate, max_iter=epochs)
        model.fit(X_train, y_train)
        y_pred = model.predict(X_test)
        y_proba = model.predict_proba(X_test)

        acc = accuracy_score(y_test, y_pred)
        loss = log_loss(y_test, y_proba)

        mlflow.log_metric("accuracy", acc)
        mlflow.log_metric("loss", loss)

        mlflow.sklearn.log_model(model, "model")

        print("✅ Експеримент завершено. Перевірте результати в MLflow UI.")

        # PushGateway
        try:
            registry = CollectorRegistry()

            g_acc = Gauge(
                "mlflow_accuracy",
                "Model_accuracy",
                labelnames=['run_id'],
                registry=registry
            )
            g_loss = Gauge(
                "mlflow_loss",
                "Model log loss",
                labelnames=["run_id"],
                registry=registry
            )

            g_acc.labels(run_id=run_id).set(acc)
            g_loss.labels(run_id=run_id).set(loss)

            push_to_gateway(pushgateway_url, job="mlflow_training", registry=registry)
            print(f"Метрики запушено в PushGateway")
        except Exception as e:
            print(f"PushGateway недоступний: {e}")

        results.append({
            "run_id": run_id,
            "accuracy": acc,
            "loss": loss,
            "params": params,
        })

best_run = max(results, key=lambda x: x["accuracy"])
print(f"Найкращий запуск: run_id={best_run['run_id']}, accuracy={best_run['accuracy']:.4f}")

best_model_dir = "best_model"
if os.path.exists(best_model_dir):
    shutil.rmtree(best_model_dir)

client = MlflowClient()
local_path = client.download_artifacts(best_run["run_id"], "model", ".")
shutil.copytree(local_path, best_model_dir)
print(f"Найкращу модель збережено в '{best_model_dir}/'")
print(f"Параметри: {best_run['params']}")