FROM registry-proxy.engineering.redhat.com/rh-osbs/openshift-golang-builder:v1.22.5-202407301806.g4c8b32d.el9 AS builder
WORKDIR /go/src/github.com/openshift/cert-manager-operator
COPY . .
RUN make build --warn-undefined-variables

FROM registry.access.redhat.com/ubi9-minimal:9.2
COPY --from=builder /go/src/github.com/openshift/cert-manager-operator/cert-manager-operator /usr/bin/

USER 65532:65532

ENTRYPOINT ["/usr/bin/cert-manager-operator"]
