#!/bin/bash

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
