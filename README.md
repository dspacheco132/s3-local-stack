## 📝 Estrutura do Projeto

O projeto está organizado da seguinte forma:

- 📁 Componentes Principais
    - LocalStack Container (S3)
    - Script de monitorização (inotifywait)
    - Aplicação Python
- 🔄 Fluxo de Trabalho (PipeLine)
    1. LocalStack inicia simulando S3
    2. Script está a monitorar a pasta de imagens
    3. Ao detetar um novo arquivo, trigger upload
    4. App Python processa e envia para S3

# Projeto LocalStack S3 com Docker e App Python

Este projeto utiliza o **LocalStack** para simular serviços AWS (S3) localmente via Docker, junto com uma aplicação Python para enviar e listar arquivos no bucket simulado.

---

## 🚀 O que este projeto faz?

- Roda um container LocalStack com o serviço S3 ativo
- Uma app Python que faz upload de imagens para o bucket S3 local
- Permite testar a integração S3 localmente, sem custo
- Facilita o desenvolvimento e testes rápidos antes de migrar para AWS real

---

## 📦 Tecnologias usadas

- [LocalStack](https://localstack.cloud/) (simulação local dos serviços AWS)
- Docker e Docker Compose
- Python 3 (com boto3 para interagir com S3)
- (Opcional) Nginx ou outro proxy para cache/load balancing

---

## ⚙️ Como usar

### Pré-requisitos

- Docker e Docker Compose instalados
- Python 3 instalado localmente (para testes locais)

### Passo 1: Rodar o LocalStack

```bash
docker-compose up -d localstack

```

### Ferramenta muito boa **- inotifywait (Vê que recebeu ficheiros na pasta)**

**inotifywait f**az parte do pacote inotify-tools, que permite monitorar eventos no sistema de arquivos.

```bash
sudo apt-get install inotify-tools
```

Script que usei neste projeto:

```bash
#!/bin/bash

WATCH_DIR="./imagens"

echo "Monitorando a pasta $WATCH_DIR para novos arquivos..."

inotifywait -m -e close_write,moved_to,create "$WATCH_DIR" --format '%w%f' | while read FILE
do
  echo "Novo arquivo detectado: $FILE"
  echo "Executando container s3-local-app para upload..."

  # Aqui assumimos que o container 's3-local-app' está configurado para subir, fazer upload e sair

  docker start s3-local-app

  echo "Upload feito!"
done

```

### Executar isto em Demon

```bash
nohup ./upload.sh > watch_upload.log 2>&1 &
```

Para terminar o processo depois:

```bash
ps aux | grep watch_upload.sh
kill <PID>
```

Outra maneira de ver os processos:

```bash
pgrep -fl watch_upload.sh
```

---

## 📚 Documentação Adicional

Para mais informações, consulte:

- [Documentação do LocalStack](https://localstack.cloud/)
- [Docker Documentation](https://docs.docker.com/)
- [Boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)