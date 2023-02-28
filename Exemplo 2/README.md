# Terraws-script
Migração do site da empresa Marisa Store para AWS
feito pelo grupo-03

PREMISSAS:
1- ter um certificado na AWS ja validado pelo ACM
    da forma como fizemos, sem usar o serviço route 53 pra diminuir os gastos é necessario ter um certificado validado no ACM 
    para que funcione o Listener HTTPS, a validação é feita por entradas nome CNAME e valor CNAME no seu Hostgator, homehost....

2- exportar suas credenciais da AWS como variavel de ambiaente
    -export AWS_ACCESS_KEY_ID=
    -export AWS_SECRET_ACCESS_KEY=

3- ter um Bucket S3 ja criado na sua conta AWS para salvar o Backend
    dentro da pasta principal do progeto existe uma subpasta com esse proposito, basta iniciar o terraform dentro dela primeiro
        -terraform init
        -terraform plan
        -terraform apply
    depois volta para a pasta principal pra rodar o projeto todo

Desafio-02:
Desafio: A empresa 'Marisa Store' possui um site que constantemente fica inoperante por estar hospedado em infraestrutura local na sede da empresa,  Martin que é CTO da empresa não está contente com isso pois está recebendo diversas reclamações de clientes que não conseguem finalizar suas compras fazendo a empresa perder muito dinheiro, por indicação de um amigo ele decidiu lhe contratar para montar uma nova infraestrutura em nuvem para tentar resolver esse problema.

Em conversa com a equipe de TI da 'Marisa Store' as informações que lhe passaram foram estas:

O site é em Wordpress com banco de dados MySQL;
Atualmente ele está rodando em uma maquina com 2 vCPU e 2GB RAM;
Atualmente a empresa ainda não possui um certificado HTTPS;
O domínio da empresa (marisastore.emmatech.com.br) está atualmente hospedado em um servidor local.

As exigências de Martin são:

A infraestrutura deve ser desenvolvida como código com Terraform;
A infraestrutura deve ser de fácil portabilidade;
A infraestrutura deve ser criada na nuvem da AWS.

Com base nas informações acima desenvolva a sua versão da infraestrutura conforme pedido de Martin usando dos conhecimentos e boas práticas aprendidas até agora, insira seu projeto IaC em um repositório GIT e compartilhe com seus colegas no grupo da comunidade.


