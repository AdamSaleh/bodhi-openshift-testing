let labeledmeta= {
    apiVersion: Text,
    kind: Text,
    metadata: {
        name: Text,
        labels: {
            app: Text,
            service: Text
        }
    }
}
let selectable = {
    selector: {
              deploymentconfig: Text
    }
}
let container = {
    image: Text,
    imagePullPolicy: Text,
    name: Text,
    resources: {},
    terminationMessagePath: Text,
    terminationMessagePolicy: Text,
    volumeMounts: List < STD: {
        mountPath: Text,
        name: Text
    } | RO: {
        mountPath: Text,
        name: Text,
        readOnly: Bool
    } | Subpath : {
        mountPath: Text,
        name: Text,
        readOnly: Bool,
        subPath: Text
    } >
}
let container_ports = {
    ports: List {
        containerPort: Natural,
        protocol: Text
    }
}
let probe = {
    failureThreshold: Natural,
    httpGet: {
        path: Text,
        port: Natural,
        scheme: Text
    },
    initialDelaySeconds: Natural,
    periodSeconds: Natural,
    successThreshold: Natural,
    timeoutSeconds: Natural
}
let container_readiness = {
    readinessProbe: probe
}
let container_liveness = {
    livenessProbe: probe
}
in
 (labeledmeta //\\ {
      spec : selectable //\\ {
          replicas: Natural,
          revisionHistoryLimit: Natural,
          strategy: {
            activeDeadlineSeconds: Natural,
            recreateParams: {
                timeoutSeconds: Natural
            },
            resources: {},
            rollingParams: {
                intervalSeconds: Natural,
                maxSurge: Text,
                maxUnavailable: Text,
                timeoutSeconds: Natural,
                updatePeriodSeconds: Natural
            },
            type: Text
          },
          template: {
              metadata: {
                  labels: {
                    app: Text,
                    deploymentconfig: Text
                  }
              },
              spec: {
                containers: List < C: container 
                  | C_L : container 
                    //\\ container_liveness
                  | C_L_R_P : container 
                    //\\ container_liveness
                    //\\ container_readiness
                    //\\ container_ports
                  >,
                dnsPolicy: Text,
                restartPolicy: Text,
                schedulerName: Text,
                securityContext: {},
                terminationGracePeriodSeconds: Natural,
                volumes: List < ConfigMap : {
                    configMap: {
                        defaultMode: Natural,
                        name: Text
                    },
                    name: Text
                } | Empty: {
                    emptyDir: {},
                    name: Text
                } | Secret : {
                    name: Text,
                    secret: {
                        defaultMode: Natural,
                        secretName: Text
                    }
                }>
              }
          },
          test: Bool,
          triggers: List < ImageChange : {
              imageChangeParams: {
                  automatic: Bool,
                  containerNames: List Text,
                  from: {
                      kind: Text,
                      name: Text,
                      namespace: Text
                  }
              },
              type: Text
            } | ConfigChange : {
                type: Text
            } >
          }
    })