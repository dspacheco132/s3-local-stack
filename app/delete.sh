#!/bin/bash

FILE_TO_DELETE=$1
LOCAL_FOLDER="./imagens"

if [ -z "$FILE_TO_DELETE" ]; then
  echo "Uso: ./delete_s3.sh nome-do-arquivo"
  exit 1
fi

# Pega o caminho absoluto da pasta Imagens
ABS_LOCAL_FOLDER=$(realpath "$LOCAL_FOLDER")
LOCAL_FILE_PATH="$ABS_LOCAL_FOLDER/$FILE_TO_DELETE"

echo "Tentando remover o arquivo local em: $LOCAL_FILE_PATH"

# Deleta no bucket S3 via container
docker run --rm \
  --network s3-local_default \
  -e AWS_ACCESS_KEY_ID=test \
  -e AWS_SECRET_ACCESS_KEY=test \
  python:3.11-slim bash -c "
pip install boto3 > /dev/null &&
python -c \"
import sys
import boto3
file_to_delete = sys.argv[1]
s3 = boto3.client('s3', endpoint_url='http://localstack:4566', region_name='us-east-1', aws_access_key_id='test', aws_secret_access_key='test')
s3.delete_object(Bucket='imagens', Key=file_to_delete)
print(f'Arquivo {file_to_delete} deletado do bucket imagens.')
\" $FILE_TO_DELETE
"

# Remove o arquivo local da pasta Imagens
if [ -f "$LOCAL_FILE_PATH" ]; then
  rm "$LOCAL_FILE_PATH"
  echo "Arquivo $LOCAL_FILE_PATH removido da pasta local."
else
  echo "Arquivo $LOCAL_FILE_PATH não encontrado na pasta local."
fi
