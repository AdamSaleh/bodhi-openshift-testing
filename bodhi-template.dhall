-- Definition for our deployment 
let schema = ./openshift-schema.dhall

let livenessProbe =
      { Type = schema.Probe.Type
      , default =
          schema.Probe::{
          , failureThreshold = 3
          , initialDelaySeconds = 30
          , periodSeconds = 10
          , successThreshold = 1
          , timeoutSeconds = 10
          }
      }

let readinessProbe =
      { Type = schema.Probe.Type
      , default =
          schema.Probe::{
          , failureThreshold = 5
          , initialDelaySeconds = 10
          , periodSeconds = 10
          , successThreshold = 1
          , timeoutSeconds = 10
          }
      }

let templateObjectTypes =
      < BuildConfig : schema.BuildConfig.Type
      | DeploymentConfig : schema.DeploymentConfig.Type
      | ImageStream : schema.ImageStream.Type
      | Route : schema.Route.Type
      | Service : schema.Service.Type
      | ConfigMap : schema.ConfigMap.Type
      >

let defaultMounts =
      [ schema.VolumeMount::{
        , mountPath = "/etc/bodhi"
        , name = "config-volume"
        , readOnly = Some True
        }
      , schema.VolumeMount::{ mountPath = "/httpdir", name = "httpdir-volume" }
      ]

let defaultVolumes =
      [ schema.Volume::{
        , configMap = Some { defaultMode = 365, name = "bodhi-configmap" }
        , name = "config-volume"
        }
      , schema.Volume::{ name = "httpdir-volume", emptyDir = Some {=} }
      ]

let bodhiBaseImageTrigger =
      { automatic = True
      , from =
          { kind = "ImageStreamTag"
          , name = "bodhi-base:latest"
          , namespace = "\${NAMESPACE}"
          }
      }

in  { apiVersion =
        "template.openshift.io/v1"
    , kind = "Template"
    , metadata = { name = "bodhi-template" }
    , parameters =
        [ { description = "Namespace, mostly for image building"
          , name = "NAMESPACE"
          , value = "asaleh-test"
          }
        , { description = "Domain to serve apps on"
          , name = "APPDOMAIN"
          , value = "app.os.stg.fedoraproject.org"
          }
        ]
    , objects =
        [ templateObjectTypes.Service
            schema.Service::{
            , metadata =
                { labels = { app = "bodhi", service = "web" }
                , name = "bodhi-web"
                }
            , spec =
                schema.ServiceSpec::{
                , ports =
                    [ { name = "web"
                      , port = 8080
                      , protocol = "TCP"
                      , targetPort = 8000
                      }
                    , { name = "admin"
                      , port = 8001
                      , protocol = "TCP"
                      , targetPort = 8001
                      }
                    ]
                , selector = { deploymentconfig = "bodhi-web" }
                }
            }
        , templateObjectTypes.Service
            schema.Service::{
            , metadata =
                { labels = { app = "bodhi", service = "postgres" }
                , name = "postgres"
                }
            , spec =
                schema.ServiceSpec::{
                , ports =
                    [ { name = "postgres"
                      , port = 5432
                      , protocol = "TCP"
                      , targetPort = 5432
                      }
                    ]
                , selector = { deploymentconfig = "postgresql" }
                }
            }
        , templateObjectTypes.DeploymentConfig
            { apiVersion =
                "apps.openshift.io/v1"
            , kind = "DeploymentConfig"
            , metadata =
                { labels = { app = "bodhi", service = "postgres" }
                , name = "postgresql"
                }
            , spec =
                schema.DeploymentConfigSpec::{
                , replicas = 1
                , selector = { deploymentconfig = "postgresql" }
                , strategy =
                    schema.Strategy::{
                    , type = "Recreate"
                    , recreateParams =
                        { timeoutSeconds =
                            600
                        , post =
                            Some
                              { execNewPod =
                                  { command =
                                      [ "/bin/sh"
                                      , "-c"
                                      , "export PGPASSWORD=password && export PGUSER=postgres && export PGPORT=5432 && export PGHOST=postgres && export LD_LIBRARY_PATH=/opt/rh/rh-postgresql96/root/usr/lib64/:\$LD_LIBRARY_PATH && export PATH=/opt/rh/rh-postgresql96/root/usr/bin:\$PATH && hostname && sleep 5 && echo \$PATH && psql  -c 'CREATE DATABASE bodhi2;' && psql -c 'CREATE ROLE bodhi2 SUPERUSER;' && psql -c 'GRANT bodhi2 TO postgres;' && curl https://infrastructure.fedoraproject.org/infra/db-dumps/bodhi2.dump.xz -o /tmp/bodhi2.dump.xz && xzcat /tmp/bodhi2.dump.xz | psql bodhi2"
                                      ]
                                  }
                              , containerName = "postgresql"
                              , failurePolicy = "ignore"
                              }
                        }
                    }
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi", deploymentconfig = "postgresql" }
                        }
                    , spec =
                        schema.DeploymentConfigTemplateSpec::{
                        , containers =
                            [ schema.Container::{
                              , image =
                                  "registry.hub.docker.com/centos/postgresql-96-centos7:latest"
                              , imagePullPolicy = "IfNotPresent"
                              , env =
                                  [ { name = "POSTGRESQL_USER"
                                    , value = "postgres"
                                    }
                                  , { name = "POSTGRESQL_PASSWORD"
                                    , value = "password"
                                    }
                                  ]
                              , livenessProbe =
                                  Some
                                    livenessProbe::{
                                    , exec =
                                        Some
                                          { command =
                                              [ "/usr/libexec/check-container"
                                              , "--live"
                                              ]
                                          }
                                    }
                              , readinessProbe =
                                  Some
                                    readinessProbe::{
                                    , exec =
                                        Some
                                          { command =
                                              [ "/usr/libexec/check-container" ]
                                          }
                                    }
                              , name = "postgresql"
                              , volumeMounts =
                                  [ schema.VolumeMount::{
                                    , mountPath = "/var/lib/pgsql/data"
                                    , name = "postgresql-data"
                                    }
                                  ]
                              }
                            ]
                        , volumes =
                            [ schema.Volume::{
                              , emptyDir = Some {=}
                              , name = "postgresql-data"
                              }
                            ]
                        }
                    }
                }
            }
        , templateObjectTypes.DeploymentConfig
            { apiVersion =
                "apps.openshift.io/v1"
            , kind = "DeploymentConfig"
            , metadata =
                { labels = { app = "bodhi", service = "celery" }
                , name = "bodhi-celery"
                }
            , spec =
                { replicas =
                    1
                , revisionHistoryLimit = 10
                , selector = { deploymentconfig = "bodhi-celery" }
                , strategy = schema.Strategy.default
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-celery"
                            , deploymentconfig = "bodhi-celery"
                            }
                        }
                    , spec =
                        schema.DeploymentConfigTemplateSpec::{
                        , containers =
                            [ schema.Container::{
                              , image =
                                  "docker-registry.default.svc:5000/\${NAMESPACE}/bodhi-base:latest"
                              , imagePullPolicy = "Always"
                              , name = "bodhi-celery"
                              , resources = {=}
                              , command = [ "/usr/bin/celery" ]
                              , args =
                                  [ "worker"
                                  , "-A"
                                  , "bodhi.server.tasks.app"
                                  , "-l"
                                  , "info"
                                  , "-Q"
                                  , "celery"
                                  ]
                              , volumeMounts = defaultMounts
                              }
                            ]
                        , volumes = defaultVolumes
                        }
                    }
                , test = False
                , triggers =
                    [ schema.Trigger::{
                      , imageChangeParams =
                          Some
                            (   bodhiBaseImageTrigger
                              ⫽ { containerNames = [ "bodhi-celery" ] }
                            )
                      , type = "ImageChange"
                      }
                    , schema.Trigger::{ type = "ConfigChange" }
                    ]
                }
            }
        , templateObjectTypes.DeploymentConfig
            { apiVersion =
                "apps.openshift.io/v1"
            , kind = "DeploymentConfig"
            , metadata =
                { labels = { app = "bodhi", service = "consumer" }
                , name = "bodhi-consumer"
                }
            , spec =
                { replicas =
                    1
                , revisionHistoryLimit = 10
                , selector = { deploymentconfig = "bodhi-consumer" }
                , strategy = schema.Strategy.default
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-consumer"
                            , deploymentconfig = "bodhi-consumer"
                            }
                        }
                    , spec =
                        schema.DeploymentConfigTemplateSpec::{
                        , containers =
                            [ schema.Container::{
                              , image =
                                  "docker-registry.default.svc:5000/\${NAMESPACE}/bodhi-base:latest"
                              , imagePullPolicy = "Always"
                              , name = "bodhi-consumer"
                              , command = [ "/usr/bin/fedora-messaging" ]
                              , args = [ "consume" ]
                              , volumeMounts = defaultMounts
                              }
                            ]
                        , volumes = defaultVolumes
                        }
                    }
                , test = False
                , triggers =
                    [ schema.Trigger::{
                      , imageChangeParams =
                          Some
                            (   bodhiBaseImageTrigger
                              ∧ { containerNames = [ "bodhi-consumer" ] }
                            )
                      , type = "ImageChange"
                      }
                    , schema.Trigger::{ type = "ConfigChange" }
                    ]
                }
            }
        , templateObjectTypes.DeploymentConfig
            { apiVersion =
                "apps.openshift.io/v1"
            , kind = "DeploymentConfig"
            , metadata =
                { labels = { app = "bodhi", service = "web" }
                , name = "bodhi-web"
                }
            , spec =
                { replicas =
                    1
                , revisionHistoryLimit = 10
                , selector = { deploymentconfig = "bodhi-web" }
                , strategy = schema.RollingStrategy.default
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-web"
                            , deploymentconfig = "bodhi-web"
                            }
                        }
                    , spec =
                        schema.DeploymentConfigTemplateSpec::{
                        , containers =
                            [ schema.Container::{
                              , image =
                                  "docker-registry.default.svc:5000/\${NAMESPACE}/bodhi-base:latest"
                              , imagePullPolicy = "Always"
                              , command = [ "/usr/bin/pserve-3" ]
                              , args = [  "/etc/bodhi/production.ini"
                                      , "--reload" ]
                              , livenessProbe =
                                  Some
                                    schema.Probe::{
                                    , failureThreshold = 3
                                    , initialDelaySeconds = 30
                                    , periodSeconds = 10
                                    , successThreshold = 1
                                    , timeoutSeconds = 10
                                    , httpGet =
                                        Some
                                          { path = "/"
                                          , port = 6543
                                          , scheme = "HTTP"
                                          }
                                    }
                              , name = "bodhi-web"
                              , ports =
                                  [ { containerPort = 6543, protocol = "TCP" } ]
                              , readinessProbe =
                                  Some
                                    schema.Probe::{
                                    , failureThreshold = 5
                                    , initialDelaySeconds = 10
                                    , periodSeconds = 10
                                    , successThreshold = 1
                                    , timeoutSeconds = 10
                                    , httpGet =
                                        Some
                                          { path = "/"
                                          , port = 6543
                                          , scheme = "HTTP"
                                          }
                                    }
                              , volumeMounts = defaultMounts
                              }
                            , schema.Container::{
                              , image =
                                  "docker-registry.default.svc:5000/\${NAMESPACE}/bodhi-base:latest"
                              , imagePullPolicy = "Always"
                              , command = [ "sh" ]
                              , args = [  "/etc/bodhi/start.sh" ]
                              , name = "bodhi-static"
                              , ports =
                                  [ { containerPort = 8080, protocol = "TCP" } ]
                              , volumeMounts = defaultMounts
                              }
                            , schema.Container::{
                              , image =
                                  "registry.hub.docker.com/envoyproxy/envoy-alpine:v1.8.0"
                              , imagePullPolicy = "Always"
                              , command = [ "/usr/local/bin/envoy" ]
                              , args = [  "-c"
                              , "/etc/bodhi/envoy.yaml"
                              ,  "--v2-config-only"
                              , "--service-cluster", "bodhi-envoy"]
                              , name = "bodhi-envoy"
                              , ports =
                                  [ { containerPort = 8000, protocol = "TCP" }
                                  , { containerPort = 8001, protocol = "TCP" } ]
                              , volumeMounts = defaultMounts
                              }
                            ]
                        , volumes = defaultVolumes
                        }
                    }
                , test = False
                , triggers =
                    [ schema.Trigger::{
                      , imageChangeParams =
                          Some
                            (   bodhiBaseImageTrigger
                              ∧ { containerNames = [ "bodhi-web" ] }
                            )
                      , type = "ImageChange"
                      }
                    , schema.Trigger::{ type = "ConfigChange" }
                    ]
                }
            }
        , templateObjectTypes.BuildConfig
            schema.BuildConfig::{
            , metadata =
                { labels = { build = "bodhi-base" }, name = "bodhi-base" }
            , spec =
                schema.BuildConfigSpec::{
                , output =
                    { to =
                        { kind = "ImageStreamTag", name = "bodhi-base:latest" }
                    }
                , source =
                    { dockerfile = ./files/Dockerfile.base as Text
                    , type = "Dockerfile"
                    }
                , strategy = schema.DockerStrategy.defaults
                }
            }
        , templateObjectTypes.ImageStream
            schema.ImageStream::{
            , metadata = { name = "bodhi-base" }
            , spec =
                { lookupPolicy =
                    { local = False }
                , tags =
                    [ { from =
                          { kind =
                              "DockerImage"
                          , name =
                              "docker-registry.default.svc:5000/\${NAMESPACE}/bodhi-base:latest"
                          }
                      , importPolicy = {=}
                      , name = "latest"
                      , referencePolicy = { type = "" }
                      }
                    ]
                }
            }
        , templateObjectTypes.ConfigMap
            schema.ConfigMap::{
            , metadata = { name = "bodhi-configmap" }
            , data =
                [ { mapKey = "celeryconfig.py"
                  , mapValue = ./files/celeryconfig.py as Text
                  }
                , { mapKey = "envoy.yaml"
                  , mapValue = ./files/envoy.yaml as Text
                  }
                , { mapKey = "start.sh", mapValue = ./files/start.sh as Text }
                , { mapKey = "httpd.conf"
                  , mapValue = ./files/httpd.conf as Text
                  }
                , { mapKey = "production.ini"
                  , mapValue = ./files/production.ini as Text
                  }
                ]
            }
        , templateObjectTypes.ConfigMap
            schema.ConfigMap::{
            , metadata = { name = "bodhi-dev-ini" }
            , data =
                [ { mapKey = "production.ini"
                  , mapValue = ./files/production.ini as Text
                  }
                ]
            }
        , templateObjectTypes.Route
            schema.Route::{
            , metadata =
                { labels = { app = "bodhi", service = "web" }
                , name = "bodhi-web"
                }
            , spec =
                { host = "bodhi-web-\${NAMESPACE}.\${APPDOMAIN}"
                , port = { targetPort = "web" }
                , tls = { termination = "edge" }
                , to = { kind = "Service", name = "bodhi-web", weight = 100 }
                , wildcardPolicy = Some "None"
                }
            }
        ]
    }
