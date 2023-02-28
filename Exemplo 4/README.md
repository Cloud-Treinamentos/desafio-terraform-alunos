Para iniciar defina um local onde vai armazenado o projeto, crie uma pasta nesse local e baixe o projeto através do comando abaixo.
git clone https://gitlab.com/devops3041/desafio-grupo2.git

Após realizar o clone vamos baixar os arquivos inicialização atraves do comando
terraform init

Para verificar tudo o que vai ser criado, execute o comando abaixo.
terraform plan

Tudo conferido, para iniciar a criação dos recursos, execute o comando abaixo e e confirme com yes, caso contrário os recursos não serão criados
terraform apply

Vai ser gerado a infra para inicialização do Wordpress (vai ser necessário inicializar um novo projeto ou restaurar um bkp de projeto anterior)

Após finalizado essa primeira configuração inicial, será gerado uma imagem AMI através do console com o projeto já funcionando, essa imagem AMI será utilizada no serviço de autoscaling (necessário fornecer o código da AMI gerada no arquivo autoscaling.tf e alterar a min_size e desired_capacity que vai estar 0, colocar a quantidade de instância desejada conforme comentários no arquivo.
  
Depois de alterar o arquivo autoscaling.tf, salve as modificações e vamos executar o comando abaixo para aplicar as modificações.
terraform apply

Agora temos X instâncias trabalhando em load balancer e com autoscaling. A primeira estância que foi criada pode ser desligada, estaremos trabalhando agora só com a imagem AMI que foi gerada.
