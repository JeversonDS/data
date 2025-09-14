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
mkdir -p /usr/share/git-core/templates
git --version

rm -- "$0"
