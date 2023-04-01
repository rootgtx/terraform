#!/bin/bash

# Configuração
BUCKET_NAME="your-bucket-name"
LOG_FILE="s3_cleanup.log"

# Data de três anos atrás
THREE_YEARS_AGO=$(date -d '3 years ago' +%s)

# Função para verificar duplicatas
check_duplicates() {
  aws s3 ls "s3://${BUCKET_NAME}" --recursive --output text | awk '{print $4}' | sort | uniq -d > duplicates.txt
}

# Função para verificar arquivos antigos
check_old_files() {
  aws s3 ls "s3://${BUCKET_NAME}" --recursive --output text | while read -r line; do
    # Extrai a data do arquivo e converte para timestamp
    FILE_DATE=$(echo "$line" | awk '{print $1" "$2}' | date -d "$(awk '{print $1" "$2}')" +%s)
    FILE_NAME=$(echo "$line" | awk '{print $4}')
    
    # Verifica se o arquivo é mais antigo que 3 anos
    if [ "$FILE_DATE" -lt "$THREE_YEARS_AGO" ]; then
      echo "$FILE_NAME" >> old_files.txt
    fi
  done
}

# Executa as verificações
check_duplicates
check_old_files

# Cria o arquivo de log
echo "Arquivos duplicados:" > "$LOG_FILE"
cat duplicates.txt >> "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "Arquivos com mais de 3 anos:" >> "$LOG_FILE"
cat old_files.txt >> "$LOG_FILE"

# Remove os arquivos temporários
rm duplicates.txt old_files.txt

echo "Log gerado com sucesso no arquivo: $LOG_FILE"
