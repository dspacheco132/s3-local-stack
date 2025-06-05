import boto3
import os
import time

# Garante que LocalStack esteja pronto
time.sleep(10)

s3 = boto3.client(
    "s3",
    endpoint_url="http://localstack:4566",  # 👈 usa o nome do serviço
    region_name="us-east-1",
    aws_access_key_id="test",
    aws_secret_access_key="test",
)

bucket = "imagens"

try:
    s3.create_bucket(Bucket=bucket)
except s3.exceptions.BucketAlreadyOwnedByYou:
    pass

for nome_arquivo in os.listdir("imagens"):
    caminho = os.path.join("imagens", nome_arquivo)
    if os.path.isfile(caminho):
        s3.upload_file(caminho, bucket, nome_arquivo)
        print(f"✅ Enviado: {nome_arquivo}")
