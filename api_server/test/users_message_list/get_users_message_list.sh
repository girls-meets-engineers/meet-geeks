if [ $# -ne 1 ]; then
  echo "invalid argument error"
  exit 1
fi
curl -X GET http://127.0.0.1:9292/users_message_list/$1
