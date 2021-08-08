#!/bin/bash -x

P=acs-pipeline-demo

oc new-project $P >/dev/null || oc project $P || exit 1

oc get secret roxsecrets >/dev/null 2>&1 || oc get secret roxsecrets -o yaml -n stackrox-pipeline-demo | grep -v '^\s*namespace:\s' | oc create -f - || exit 1

oc create -f clustertasks >/dev/null

oc create -f vote-app-pipeline-acs.yaml

oc delete pipelinerun vote-app-pipelinerun >/dev/null

sed "s#/project_name/#/`oc project -q`/#g" < vote-app-pipelinerun-acs.yaml | oc create -f - 

tkn pipelinerun logs -L -f
