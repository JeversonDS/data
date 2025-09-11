#!/bin/bash

dir_work="/userdata/system/.dev/scripts/JCGAMESCLASSICOS/GIT"
mkdir -p "$dir_work"
cd "$dir_work"
wget https://github.com/JeversonDS/data/releases/download/v1.0/git


#/userdata/system/.dev/scripts/JCGAMESCLASSICOS/GIT
# Diretório de origem onde os arquivos do Git foram copiados
SRC_DIR=$(pwd)

# Lista de diretórios principais onde o Git deve ser instalado
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

# Instalando os arquivos do Git nos locais apropriados
for DIR in "${GIT_DIRS[@]}"; do
    if [ -e $SRC_DIR$DIR ]; then
        echo "Instalando $DIR a partir de $SRC_DIR$DIR"
        ln -s $SRC_DIR$DIR $(dirname $DIR)
    else
        echo "Arquivos do diretório $DIR não encontrados em $SRC_DIR, pulando..."
    fi
done
ln -s /userdata/system/.dev/scripts/JCGAMESCLASSICOS/GIT/lib/* /usr/lib

batocera-save-overlay
