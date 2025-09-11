#!/bin/bash

# Solicitar o nome do usuário (sem a extensão .txt)
echo "Digite o nome do usuário (sem .txt):"
read USERNAME

# URL do repositório e do arquivo
REPO_URL="git@github.com:JeversonDS/data.git"
USER_FILE="users/$USERNAME.txt"

# Caminho para o repositório local
REPO_DIR="data"

# Definir a chave SSH para o GitHub
export GIT_SSH_COMMAND="ssh -i /userdata/system/ssh/id_rsa -o IdentitiesOnly=yes"

# Verificar se a chave SSH está configurada corretamente
echo "Tentando conectar ao GitHub..."
ssh -T git@github.com
if [ $? -ne 1 ]; then
  echo "Falha ao autenticar com a chave SSH!"
  exit 1
fi

# Clonar o repositório se não existir
if [ ! -d "$REPO_DIR" ]; then
  echo "Clonando o repositório..."
  git clone $REPO_URL
fi

# Navegar até o diretório do repositório
cd $REPO_DIR

# Verificar se o arquivo de usuário existe no repositório remoto
git fetch origin
if ! git ls-tree -r origin/main --name-only | grep -q "$USER_FILE"; then
  echo "Usuário não encontrado ou nome inválido!"
  exit 1
fi

# Baixar o arquivo do GitHub (garantindo que estamos pegando a versão mais recente)
git checkout origin/main -- $USER_FILE

# Ler o valor do arquivo
USER_VALUE=$(cat $USER_FILE)

# Exibir o valor lido para debug
echo "Valor encontrado para $USERNAME: $USER_VALUE"

# Verificar se o valor do usuário é maior que 0
if [ "$USER_VALUE" -le 0 ]; then
  echo "Valor do usuário $USERNAME é 0 ou menor. Não autorizado a continuar!"
  exit 1
fi

# Subtrair 1 do valor do usuário
NEW_VALUE=$((USER_VALUE - 1))

# Atualizar o valor do arquivo
echo $NEW_VALUE > "$USER_FILE"

# Exibir mensagem de sucesso
echo "Usuário $USERNAME autenticado com sucesso!"
echo "Novo valor para $USERNAME: $NEW_VALUE"

# Adicionar, comitar e empurrar as alterações
git add $USER_FILE
git commit -m "Decrementando valor de $USERNAME"
git push origin main

rm -rf "$REPO_DIR"
echo "Alterações no arquivo $USER_FILE foram enviadas para o repositório!"
