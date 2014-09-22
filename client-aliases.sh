export PSQL_FORWARD_PORT=5555

function engine {
  command=$1
  shift
  function ssh-cmd {
    ssh engine@$ENGINE_HOST $*
  }
  case $command in
    push)
      git push -f ssh://engine@$ENGINE_HOST/home/engine/ovirt-engine.git "$(git rev-parse --abbrev-ref HEAD)"
    ;;
    debug)
      echo "Starting debug port-forward to host $ENGINE_HOST"
      ssh-cmd -nNT -L 8787:localhost:8787 -L "$PSQL_FORWARD_PORT":localhost:5432 -L 8000:localhost:8000
    ;;
    psql)
      PGPASSWORD=engine psql -h localhost -p $PSQL_FORWARD_PORT -U engine
    ;;
    run)
      ssh-cmd '$SCRIPTS_DIR/run.sh'
    ;;
    cleanup)
      ssh-cmd '$SCRIPTS_DIR/cleanup.sh'
    ;;
    gwt)
      ssh-cmd -X -A "\$SCRIPTS_DIR/gwt.sh $1" &
      $BROWSER $ENGINE_HOST:8080/ovirt-engine/$1/?gwt.codesvr=$ENGINE_HOST
    ;;
    log)
      ssh-cmd 'tail -f $PREFIX/var/log/ovirt-engine/engine.log'
    ;;
  esac
}

function vdsm {
  command=$1
  shift
  function ssh-cmd {
    ssh root@$VDSM_HOST "$*"
  }
  case $command in
    push)
      git push -f ssh://root@$VDSM_HOST/root/vdsm.git "$(git rev-parse --abbrev-ref HEAD)"
    ;;
    status)
      ssh-cmd "service vdsmd status"
    ;;
    restart)
      ssh-cmd "service vdsmd restart"
    ;;
  esac
}
