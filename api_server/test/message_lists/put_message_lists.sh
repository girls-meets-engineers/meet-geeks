if [ $# -ne 1 ]; then
  echo "invalid argument error"
  exit 1
fi
curl -X PUT -d 'json={"engineer": 2, "girl" : 10}' http://127.0.0.1:9292/message_lists/$1
