# terraform
Модуль ec2_proxy создает инстанс, SG и  ssh ключ. Модуль eks разворачивает control-plane для кластера куберенес в aws и autoscaling-group для worker-nodes.
Для применения, необходимо предварительно добавить в переменные окружения свой ключ TF_VAR_key.
Для работы применяются следующие команды:
terraform init для скачивания провайдеров, инициализации модулей и настройки terraform для работы с s3 как хранилища для state.
terraform plan для просмотра того, какие ресурсы есть в инфраструктуре, и какие будут созданы при следующем terraform apply. Опционально -out сохраняет план в файл.
terraform apply для применения вссего плана к инфраструктуре. Опционально -target=resource для развертывания не всего плана, а лишь  конкретного ресурса.
Перед apply можно сделать taint ресурсов, которые вы хотите пересоздать, даже в случае их наличия. 
