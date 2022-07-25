#!/bin/sh

# O argumento da linha de comando, é o endereço da pasta onde as faturas serão diretamente exportadas
[ -z "$1" ] && exit 1
cd "$1"
[ $? -ne 0 ] && exit 2

# Caso o diretório exista, começamos um loop de procura por arquivos a serem assinados
while [ 0 ]; do
  arq="$(ls | grep -Eom 1 'Fatura - [- [:digit:]]+\.pdf')"
  if [ -n "$arq" ] && [ -r "$arq" ]; then
    echo "Encontrado: $arq"

    data="$(echo $arq | sed -E 's/.*- ([-[:digit:]]+).*/\1/g')"
    hora=$(echo $arq | sed -E 's/.* ([[:digit:]]{4})\.pdf/\1/g')

    echo "Assinando arquivo com GnuPG..."
    gpg --output "Fatura - ${data} ${hora}.signed.pdf" --clearsign --not-dash-escaped "$arq"
    [ $? -ne 0 ] && exit 4
    rm "$arq"
    echo "Concluído!"
    # Encerrar o agente do GnuPG para evitar assinatura sem confirmação com senha
    pkill gpg-agent
  fi
  sleep 1
done
