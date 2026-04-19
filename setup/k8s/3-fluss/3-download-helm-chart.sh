BASE_URL=https://downloads.apache.org/incubator/fluss/helm-chart/0.9.0-incubating/
HELM_CHART=fluss-0.9.0-incubating.tgz
HELM_CHART_SHA512=fluss-0.9.0-incubating.tgz.sha512

# Download helm chart and checksums
curl -O "${BASE_URL}${HELM_CHART}"
curl -O "${BASE_URL}${HELM_CHART_SHA512}"

# Verify the helm chart
if sha512sum -c "${HELM_CHART_SHA512}"; then
    echo "Checksum verified. Unzipping..."
    tar -xzf "${HELM_CHART}"
    rm $HELM_CHART
    rm $HELM_CHART_SHA512
else
    echo "Checksum verification failed. Aborting unzip."
    exit 1
fi