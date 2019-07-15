#!/bin/bash

source infrastructure_functions.sh

function checkreadystate() {
  if [[ $1 = infra ]]; then
    NODEGROUP="infra"
  elif [[ $1 = compute ]]; then
    NODEGROUP="compute"
  else
    echo "Please pass approrate tag!"
    exit 1
  fi

  NODECOUNT=$(oc get nodes | grep $NODEGROUP | grep NotReady | wc -l )
  echo $NODECOUNT

  while [ $NODECOUNT -ne 0 ]
  do
    echo "Waiting for  $NODEGROUP nodes to startup"
    sleep 30s
    NODECOUNT=$(oc get nodes | grep $NODEGROUP | grep NotReady | wc -l )
    if [[ $NODECOUNT -eq  0 ]]; then
      echo "$NODEGROUP nodes are in healthy state. "
      oc get nodes | grep $NODEGROUP
      sleep 5s
    fi
  done
}

function enablescheduling() {
  if [[ $1 = infra ]]; then
    NODEGROUP="infra"
  elif [[ $1 = compute ]]; then
    NODEGROUP="compute"
  else
    echo "Please pass approrate tag!"
    exit 1
  fi


  SCHEDULECHECK=$(oc get nodes | grep $NODEGROUP | grep SchedulingDisabled | wc -l )
  if [[ $NODECOUNT -eq  0 ]]; then
    echo "$NODEGROUP nodes are set to SchedulingDisabled enabling Sceduling. "
    NODES=$(oc get nodes | grep $NODEGROUP | awk '{print $1}')
    for  n in $NODES ; do
      oc adm manage-node $n --schedulable=true
    done
    sleep 5s
  fi
}

if [[ -z $1 ]]; then
  echo "Please pass node type as argument."
  echo "Usage: $0  infra; $0 compute; or  $0 both"
  exit 1
fi

if [[ $1 == "infra" ]]; then
  # checking state of infra nodes
  checkreadystate infra || exit 1
  enablescheduling infra || exit 1
  checkinfrahealth router || exit 1
  checkinfrahealth registry || exit 1
  checkinfrahealth openshift-infra || exit 1
  checkinfrahealth openshift-metrics-server || exit 1
  checkinfrahealth openshift-monitoring || exit 1
  checkinfrahealth logging || exit 1
elif [[ $1 == "compute" ]];  then
  #checking state of compute nodes
  checkreadystate compute || exit 1
  enablescheduling compute || exit 1
elif  [[ $1 == "both" ]]; then
  # checking state of infra nodes
  checkreadystate infra || exit 1
  enablescheduling infra || exit 1
  checkinfrahealth router || exit 1
  checkinfrahealth registry || exit 1
  checkinfrahealth openshift-infra || exit 1
  checkinfrahealth openshift-metrics-server || exit 1
  checkinfrahealth openshift-monitoring || exit 1
  checkinfrahealth logging || exit 1
  #checking state of compute nodes
  checkreadystate compute || exit 1
  enablescheduling compute || exit 1
fi
