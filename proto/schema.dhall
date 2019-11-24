let meta= {
    apiVersion: Text,
    kind: Text,
    metadata: {
        name: Text
    }
}
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
let deploymentConfig = ./deployments-schema.dhall
let buildConfig = ./builds-schema.dhall

in meta //\\ {
    objects: List  
    < Service : labeledmeta //\\ {
      spec : selectable //\\ {
          ports : List {
              name: Text,
              port: Natural,
              protocol: Text,
              targetPort: Natural
          },
          sessionAffinity: Optional Text,
          type: Text
      }
    } | DeploymentConfig : deploymentConfig
     | BuildConfig : buildConfig
     | ImageStream : meta //\\ {
        spec: {
            lookupPolicy: {
                local: Bool
            },
            tags: List {
                annotations: Optional Text,
                from: {
                    kind: Text,
                    name: Text
                },
                importPolicy: {},
                name: Text,
                referencePolicy: {
                    type: Text
                }
            }
        }
    } | Route : {        
        apiVersion: Text,
        kind: Text,
        metadata: {
            name: Text,
            labels: {
                app: Text
            }
        },
        spec: {
            host: Text,
            port: {
                targetPort: Text
            },
            tls: {
                insecureEdgeTerminationPolicy: Text,
                termination: Text
            },
            to: {
                kind: Text,
                name: Text,
                weight: Natural
            },
            wildcardPolicy: Optional Text
        }
    } >
}