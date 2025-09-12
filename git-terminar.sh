#!/bin/bash
# Curitiba, 12 de Setembro de 2025.
# Editor: Jeverson D. Silva   ///@JCGAMESCLASSICOS.

# Estilização visual
clear
ROXO="\033[1;35m"
VERDE="\033[1;92m"
AZUL="\033[1;34m"
AMARELO="\033[1;33m"
VERMELHO="\033[1;31m"
RESET="\033[0m"
BOLD="\033[1m"
UNDERLINE="\033[4m"


DISPOSITIVO=$(findmnt -no SOURCE /userdata)
DISCO=$(lsblk -no PKNAME $DISPOSITIVO)
SERIAL=$(udevadm info --query=all --name=/dev/$DISCO | grep ID_SERIAL= | cut -d= -f2)

#echo "$SERIAL" > /usr/share/retroluxxo/dep/hash.zip



echo -e "${ROXO}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${ROXO}${BOLD}  INSTALAÇÃO DO "PATCH DE SCRIPTS"  ${RESET} ${VERDE}PANDORA LINUX v1.0${RESET}"
echo -e "${ROXO}${BOLD}  V40 E V41 - JEVERTON DIAS DA SILVA - 05 SETEMBRO 2025  ${RESET}"
echo -e "${ROXO}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}"
sleep 0.5









#############
#############
#############


# 🔐 Token do GitHub com acesso ao repositório
TOKEN="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"  # <-- Substitua aqui

# URL e nome do repositório
REPO_URL="https://${TOKEN}@github.com/JeversonDS/data.git"
REPO_DIR="data"

# Função para validar o usuário com base nos créditos no GitHub
validar_chave() {
    while true; do
        echo -e "${AMARELO}${BOLD}DIGITE A CHAVE DE AUTENTICAÇÃO PARA A INSTALAÇÃO DO PATCH${RESET} ${BOLD}${VERDE}v1.0:${RESET}"
        read -p ":: " USERNAME

        # Caminho do arquivo .txt no GitHub
        USER_FILE="users/${USERNAME}.txt"
        GITHUB_RAW="https://raw.githubusercontent.com/JeversonDS/data/main/${USER_FILE}"

        echo -e "\n${BOLD}AGUARDE A VERIFICAÇÃO NA AUTENTICAÇÃO...${RESET}"

        # Consulta os créditos
        USER_VALUE=$(curl -s -H "Authorization: token ${TOKEN}" "$GITHUB_RAW")

        # Validação do conteúdo
        if ! [[ "$USER_VALUE" =~ ^[0-9]+$ ]]; then
            echo -e "${VERMELHO}${BOLD}USUÁRIO NÃO ENCONTRADO OU FORMATO INVÁLIDO!${RESET}\n"
            continue
        fi

        # Verifica se possui créditos
        if [ "$USER_VALUE" -le 0 ]; then
            echo -e "${VERMELHO}${BOLD}CRÉDITOS INSUFICIENTES PARA ${USERNAME^^}!${RESET}\n"
            continue
        fi

        # Exibe créditos restantes antes da autenticação
        echo -e "${BOLD}${ROXO}${USERNAME^^}${RESET} POSSUI ${BOLD}${VERDE}${USER_VALUE} CRÉDITO(S) RESTANTE(S).${RESET}"

        # Apaga clone anterior (caso haja)
        rm -rf "$REPO_DIR"

        # Clona o repositório silenciosamente
        git clone -q "$REPO_URL" "$REPO_DIR"
        if [ $? -ne 0 ]; then
            echo -e "${VERMELHO}${BOLD}ERRO AO CLONAR O REPOSITÓRIO!${RESET}\n"
            continue
        fi

        # Decrementa
        NEW_VALUE=$((USER_VALUE - 1))
        echo "$NEW_VALUE" > "$REPO_DIR/$USER_FILE"

        # Commita e envia
        cd "$REPO_DIR"
        git config user.name "Batocera Auth"
        git config user.email "batocera@local"
        git add "$USER_FILE"
        git commit -q -m "Decrementando valor de $USERNAME"
        git push -q origin main
        cd ..
        rm -rf "$REPO_DIR"

        # Mensagem final
        echo -e "\n${BOLD}${VERDE}USUÁRIO ${USERNAME^^} AUTENTICADO COM SUCESSO!${RESET}"
        echo -e "${BOLD}${ROXO}CRÉDITOS RESTANTES: ${VERDE}${NEW_VALUE}${RESET}\n"
        break
    done
}

# Chama a função no script principal
validar_chave



#############
#############
#############




# Criar diretório temporário
mkdir -p "/userdata/system/.dev/.tmp"

# Definir diretório de trabalho
dir_work="/userdata/system/.dev/scripts/JCGAMESCLASSICOS/GIT"
mkdir -p "$dir_work"

# Baixar arquivo squashfs corretamente
wget https://github.com/JeversonDS/data/releases/download/v1.0/git -O "/userdata/system/.dev/.tmp/git"

# Extrair conteúdo do squashfs no diretório de trabalho
unsquashfs -d "$dir_work" "/userdata/system/.dev/.tmp/git"

# Remover o arquivo squashfs baixado
rm -f "/userdata/system/.dev/.tmp/git"

# Ir para o diretório extraído
cd "$dir_work" || exit 1

# Diretório de origem onde os arquivos foram extraídos
SRC_DIR=$(pwd)

# Lista de caminhos esperados dentro do squashfs (caminhos absolutos)
GIT_DIRS=(
    /usr/bin/git
    /usr/local/bin/git
    /usr/lib/git-core
    /usr/local/libexec/git-core
    /etc/gitconfig
    /usr/share/doc/git
    /usr/share/man/man1/git.1
    /usr/share/git
    /usr/local/share/git
)

# Criar links simbólicos se os arquivos existirem no squashfs extraído
for DIR in "${GIT_DIRS[@]}"; do
    SRC_PATH="$SRC_DIR$DIR"
    DEST_DIR=$(dirname "$DIR")
    
    if [ -e "$SRC_PATH" ]; then
        echo "Instalando $DIR a partir de $SRC_PATH"
        ln -sf "$SRC_PATH" "$DIR"
    else
        echo "Arquivos do diretório $DIR não encontrados em $SRC_PATH, pulando..."
    fi
done

# Linkar bibliotecas, se existirem
if [ -d "$SRC_DIR/lib" ]; then
    for lib in "$SRC_DIR/lib/"*; do
        ln -sf "$lib" /usr/lib/
    done
fi

# Salvar overlay do Batocera (persistência)
batocera-save-overlay

echo "Instalação do Git finalizada com sucesso."
sleep 2
git --version

rm -- "$0"
