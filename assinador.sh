#!/bin/sh

# O argumento da linha de comando, é o endereço da pasta onde as faturas serão diretamente exportadas
if [ -n "$1" ]; then
  cd "$1"
  [ $? -ne 0 ] && exit 2
else
  cd "faturas/"
  [ $? -ne 0 ] && exit 2
fi

echo " ---- INICIADO ÀS $(date +'%H:%M de %d/%m/%Y') ---- "
# Caso o diretório exista, começamos um loop de procura por arquivos a serem assinados
while [ 0 ]; do
  if [ -r "assinar.pdf" ]; then
    arq="assinar.pdf"

    echo "[$(date +'%H:%M')] Assinando arquivo com GnuPG..."
    gpg --output "Fatura - $(date +'%Y-%m-%d %H%M').signed.pdf" --clearsign --not-dash-escaped "$arq"
    ec=$? # "exit code" de "gpg"
    [ $ec -ne 0 ] && exit $ec
    rm "$arq"
    echo "	Concluído!"
    # Encerrar o agente do GnuPG para evitar assinatura posterior sem senha
    pkill gpg-agent
  fi
  sleep 1
done
