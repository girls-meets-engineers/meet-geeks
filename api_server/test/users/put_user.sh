if [ $# -ne 1 ]; then
  echo "invalid argument error"
  exit 1
fi
curl -X PUT -d 'json={"image_url": "http://timpo.com"}' http://127.0.0.1:9292/users/$1
