if [ $# -ne 1 ]; then
  echo "invalid argument error"
  exit 1
fi
curl -X PUT -d 'json={"body": "twitter"}' http://127.0.0.1:9292/messages/$1
