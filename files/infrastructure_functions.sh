#!/bin/bash

function checkinfrahealth() {
  #oc get pods --all-namespaces
  case $1 in

  logging)
    SEARCHSTRING="logging"
    TEXTRESPONSE="OpenShift Logging"
    ;;

  openshift-monitoring)
    SEARCHSTRING="openshift-monitoring"
    TEXTRESPONSE="OpenShift Monitoring"
    ;;

  openshift-metrics-server)
    SEARCHSTRING="openshift-metrics-server"
    TEXTRESPONSE="Open Shift Metrics Server"
    ;;

  openshift-infra)
    SEARCHSTRING="openshift-infra"
    TEXTRESPONSE="OpenShift Infrastructure"
    ;;

  router)
    SEARCHSTRING="router"
    TEXTRESPONSE="Router"
    ;;

  registry)
    SEARCHSTRING="registry"
    TEXTRESPONSE="Registry"
    ;;

  *)
    echo "please Pass approrate flag"
    exit 1
    ;;
  esac

  CONTAINERCOUNT=$(oc get pods --all-namespaces   | grep $SEARCHSTRING | wc -l)
  CONTAINERSREADY=$(oc get pods --all-namespaces   | grep $SEARCHSTRING | grep Running | wc -l)
  for (( i = 0; i < 5; i++ )); do
    if [[ $METRICSCOUNT -eq $METRICSREADY ]]; then
      echo "$TEXTRESPONSE Containers are running"
      break
    else
      echo "Waiting for $TEXTRESPONSE Containers to start up"
      sleep 30s
      METRICSCOUNT=$(oc get pods --all-namespaces   | grep $SEARCHSTRING | wc -l)
      METRICSREADY=$(oc get pods --all-namespaces   | grep $SEARCHSTRING | grep Running | wc -l)
    fi
  done

}
