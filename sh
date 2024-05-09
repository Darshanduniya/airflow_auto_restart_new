from airflow import DAG
from airflow.operators.python import PythonOperator, ShortCircuitOperator
from airflow.utils.dates import days_ago
from datetime import timedelta

# Replace the following function with your actual database connection and query logic
def check_no_of_models():
    # Logic to connect to MonetDB and fetch the number of models
    # For example:
    # connection = monetdblib.connect(...)
    # cursor = connection.cursor()
    # cursor.execute("SELECT COUNT(*) FROM models_table")
    # no_of_models = cursor.fetchone()[0]
    # cursor.close()
    # connection.close()
    no_of_models = 2  # Placeholder for actual fetched value
    return no_of_models > 1

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'my_dag',
    default_args=default_args,
    description='A simple DAG to check number of models in MonetDB',
    schedule_interval=timedelta(days=1),
    start_date=days_ago(1),
    catchup=False,
    tags=['example'],
) as dag:

    task1 = ShortCircuitOperator(
        task_id='check_no_of_models',
        python_callable=check_no_of_models,
    )

    task2 = PythonOperator(
        task_id='task2',
        python_callable=lambda: print("Running task2"),
    )

    task3 = PythonOperator(
        task_id='task3',
        python_callable=lambda: print("Running task3"),
    )

    task4 = PythonOperator(
        task_id='task4',
        python_callable=lambda: print("Running task4"),
    )

    task5 = PythonOperator(
        task_id='task5',
        python_callable=lambda: print("Running task5"),
    )

    task1 >> [task2, task3, task4, task5]
