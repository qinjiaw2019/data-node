
case $1 in
  --start)
  if [ -f "tpid" ];then
  echo "data-node is running."
  exit
  fi
  echo "start data-node ..."
  nohup java -jar -Dspring.config.location=application.yml data-node-1.0.jar &
  echo $! > tpid
  echo "all apps started."
  ;;
  --stop)
  if [ ! -f "tpid" ];then
  echo "data-node is stoped."
  exit
  fi
  
  tpid=`cat tpid|awk '{print $1}'`
  kill -9 $tpid
  echo "data-node(tpid:$tpid) stop success."  
  rm -rf tpid
esac