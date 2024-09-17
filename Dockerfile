FROM brew.registry.redhat.io/rh-osbs/openshift-golang-builder:rhel_9_golang_1.22 AS builder
WORKDIR /go/src/github.com/openshift/cert-manager-operator
COPY . .
RUN make build --warn-undefined-variables


FROM registry.access.redhat.com/ubi9-minimal:9.4-1227.1725849298
COPY --from=builder /go/src/github.com/openshift/cert-manager-operator/cert-manager-operator /usr/bin/
USER 65534:65534
ENTRYPOINT ["/usr/bin/cert-manager-operator"]
LABEL com.redhat.component="cert-manager-operator-container" \
      name="cert-manager/cert-manager-operator-rhel9" \
      version="v${CI_CERT_MANAGER_OPERATOR_UPSTREAM_VERSION_SANITIZED}" \
      summary="cert-manager-operator" \
      maintainer="Red Hat, Inc." \
      description="cert-manager-operator-container" \
      io.openshift.expose-services="" \
      io.openshift.build.commit.id=${CI_CERT_MANAGER_OPERATOR_UPSTREAM_COMMIT} \
      io.openshift.build.source-location=${CI_CERT_MANAGER_OPERATOR_UPSTREAM_URL} \
      io.openshift.build.commit.url=${CI_CERT_MANAGER_OPERATOR_UPSTREAM_URL}/commit/${CI_CERT_MANAGER_OPERATOR_UPSTREAM_COMMIT} \
      io.openshift.maintainer.product="OpenShift Container Platform" \
      io.openshift.tags="data,images,operator,cert-manager" \
      io.k8s.display-name="openshift-cert-manager-operator" \
      io.k8s.description="cert-manager-operator-container"
