if [[ "$WERCKER_SETUP_SSH_PRIVATE_KEY" == "" ]] ; then
  error "private key is an empty string, please check"
  exit 1
fi

#save public key
export WERCKER_SETUP_SSH_ID_FILE=$WERCKER_STEP_TEMP/id.key
echo -e "$WERCKER_SETUP_SSH_PRIVATE_KEY" > "$WERCKER_SETUP_SSH_ID_FILE"

#set permission
chmod 0700 "$WERCKER_SETUP_SSH_ID_FILE"

#port option
PORT="22"
if [ -n "$WERCKER_SETUP_SSH_PORT" ]; # Check $WERCKER_SETUP_SSH_PORT exists and is not empty
then
PORT="$WERCKER_SETUP_SSH_PORT"
fi
info "using remote port $PORT"


export WERCKER_SSH="ssh $WERCKER_SETUP_SSH_HOST -p $PORT -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -l $WERCKER_SETUP_SSH_USERNAME -i $WERCKER_SETUP_SSH_ID_FILE"

$WERCKER_SSH echo 1 &> /dev/null || failed=true

if [ "$failed" == "true" ] ; then
  error "Could not connect"
  $WERCKER_SSH -v echo 1
  exit 1
fi
  

success "Created WERCKER_SHH $WERCKER_SSH"
