# terraform-init

Разворачиваем remote backend для хранения состояния terraform инфраструктуры на основе облаков (s3 + dynamodb).

Статья: https://ru.hexlet.io/courses/terraform-basics/lessons/remote-state/theory_unit

# Как запустить

Выписываем себе токен:
```
yc iam create-token
```

Кладем его в env'ы:
```
PS> $env:YC_TOKEN = 'your_token'
```

Запускаем terraform

```
terraform init
terraform get -update=true
terraform fmt
terraform validate
terraform plan -var-file .\tfvars\testing.tfvars
terraform apply -var-file .\tfvars\testing.tfvars
```

Запускаем python-скрипт для инициализации базы (в env'ы положить все переменные для Config):

```
cd scripts
python -m venv venv
source venv/bin/activate
python -m pip install -r requirements.txt
python dynamodb_init.py
```
