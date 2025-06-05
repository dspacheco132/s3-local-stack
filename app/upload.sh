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
