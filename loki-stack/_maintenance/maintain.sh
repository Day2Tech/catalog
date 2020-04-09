#!/bin/bash
set -ex

DIR=grafana-$RANDOM
ORIGINAL_DIR=$(pwd)
git clone https://github.com/grafana/loki $DIR
cp _values.yaml $DIR/production/helm/loki-stack/values.yaml

cd $DIR/production/helm/
mkdir -p loki-stack/charts
mv promtail loki-stack/charts
mv fluent-bit loki-stack/charts
mv loki loki-stack/charts


helm repo add stable https://kubernetes-charts.storage.googleapis.com || true
cd loki-stack/charts

helm pull stable/grafana
tar -zxvf grafana-*tgz
rm -v grafana-*tgz

helm pull stable/prometheus
tar -zxvf prometheus-*tgz
rm -v prometheus-*tgz

cd ..

helm template loki-stack . --namespace=loki-stack > mandatory.yaml

mv mandatory.yaml $ORIGINAL_DIR
cd $ORIGINAL_DIR

rm -r $DIR
