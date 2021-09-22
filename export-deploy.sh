#!/bin/bash
# Author zhangweilong
namespace=$1
exportDir=$2
mkdir -p ${exportDir} &> /dev/null
for i in $(kubectl get deploy -n ${namespace} | awk 'NR>1{print $1}');do
        kubectl get deploy -n ${namespace} $i -o yaml > ${exportDir}/${namespace}-$i.yaml
        cat ${exportDir}/${namespace}-$i.yaml | \
        yq e 'del(.metadata.managedFields) | del(.status) | del(.metadata.annotations."kubectl.kubernetes.io/last-applied-configuration") | del (.metadata.resourceVersion) | del (.metadata.creationTimestamp)'  - | \
        tee ${exportDir}/${namespace}-$i.yaml
done
