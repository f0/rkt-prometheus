#!/usr/bin/env bash
set -e

ACBUILD="/opt/bin/acbuild --debug"

acbuildend () {
    export EXIT=$?;
    $ACBUILD end && exit $EXIT;
}

wget https://github.com/prometheus/prometheus/releases/download/0.16.1/prometheus-0.16.1.linux-amd64.tar.gz -O prometheus.tar.gz
mkdir -p tmp
tar xvf prometheus.tar.gz -C tmp/ --strip-components=1
$ACBUILD begin /home/core/aci-store/centos-base.aci
trap acbuildend EXIT

$ACBUILD set-name f0/prometheus
$ACBUILD copy ./tmp /prometheus
$ACBUILD run -- mkdir /data
$ACBUILD copy prometheus.yaml /prometheus.yaml 
$ACBUILD run -- useradd -m prometheus -s /bin/false -u 5000
$ACBUILD set-user 5000
$ACBUILD set-exec -- /prometheus/prometheus -config.file=/prometheus.yaml -storage.local.path=/data
$ACBUILD write --overwrite /home/core/aci-store/prometheus.aci


