let types = ./openshift-types.dhall

let defaults = ./openshift-defaults.dhall

let templateObjectTypes =
      < BuildConfig : types.BuildConfig
      | DeploymentConfig : types.DeploymentConfig
      | ImageStream : types.ImageStream
      | Route : types.Route
      | Service : types.Service
      | ConfigMap : types.ConfigMap
      >

let defaultMounts =
      [   defaults.VolumeMount
        ⫽ { mountPath = "/etc/bodhi"
          , name = "config-volume"
          , readOnly = Some True
          }
      ,   defaults.VolumeMount
        ⫽ { mountPath = "/srv/bodhi/development.ini"
          , name = "config-ini-volume"
          , readOnly = Some True
          , subPath = Some "development.ini"
          }
      ]

let defaultVolumes =
      [   defaults.Volume
        ⫽ { configMap = Some { defaultMode = 420, name = "bodhi-configmap" }
          , name = "config-volume"
          }
      ,   defaults.Volume
        ⫽ { configMap = Some { defaultMode = 420, name = "bodhi-dev-ini" }
          , name = "config-ini-volume"
          }
      ]

let bodhiBaseImageTrigger =
      { automatic = True
      , from =
          { kind = "ImageStreamTag"
          , name = "bodhi-base:latest"
          , namespace = "asaleh-test"
          }
      }

in  { apiVersion =
        "template.openshift.io/v1"
    , kind = "Template"
    , metadata = { name = "bodhi-template" }
    , objects =
        [ templateObjectTypes.Service
            { apiVersion = "v1"
            , kind = "Service"
            , metadata =
                { labels = { app = "bodhi", service = "web" }
                , name = "bodhi-web"
                }
            , spec =
                { ports =
                    [ { name = "web"
                      , port = 8080
                      , protocol = "TCP"
                      , targetPort = 6543
                      }
                    ]
                , selector = { deploymentconfig = "bodhi-web" }
                , sessionAffinity = Some "None"
                , type = "ClusterIP"
                }
            }
        , templateObjectTypes.Service
            { apiVersion = "v1"
            , kind = "Service"
            , metadata =
                { labels = { app = "bodhi", service = "postgres" }
                , name = "bodhi-web"
                }
            , spec =
                { ports =
                    [ { name = "postgres"
                      , port = 5432
                      , protocol = "TCP"
                      , targetPort = 5432
                      }
                    ]
                , selector = { deploymentconfig = "postgresql" }
                , sessionAffinity = Some "None"
                , type = "ClusterIP"
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
                { replicas =
                    1
                , revisionHistoryLimit = 10
                , selector = { deploymentconfig = "postgresql" }
                , strategy =
                      defaults.DeploymentStrategy
                    ⫽ { type =
                          "Recreate"
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
                          defaults.DeploymentTemplateSpec
                        ⫽ { containers =
                              [   defaults.Container
                                ⫽ { image =
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
                                        (   defaults.Probe
                                          ⫽ { exec =
                                                Some
                                                  { command =
                                                      [ "/usr/libexec/check-container"
                                                      , "--live"
                                                      ]
                                                  }
                                            }
                                        )
                                  , readinessProbe =
                                      Some
                                        (   defaults.Probe
                                          ⫽ { exec =
                                                Some
                                                  { command =
                                                      [ "/usr/libexec/check-container"
                                                      ]
                                                  }
                                            }
                                        )
                                  , name = "postgresql"
                                  , volumeMounts =
                                      [   defaults.VolumeMount
                                        ⫽ { mountPath = "/var/lib/pgsql/data"
                                          , name = "postgresql-data"
                                          }
                                      ]
                                  }
                              ]
                          , volumes =
                              [   defaults.Volume
                                ⫽ { emptyDir = Some {=}
                                  , name = "postgresql-data"
                                  }
                              ]
                          }
                    }
                , test = False
                , triggers = [] : List types.Trigger
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
                , strategy = defaults.RollingStrategy
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-celery"
                            , deploymentconfig = "bodhi-celery"
                            }
                        }
                    , spec =
                          defaults.DeploymentTemplateSpec
                        ⫽ { containers =
                              [   defaults.Container
                                ⫽ { image =
                                      "docker-registry.default.svc:5000/asaleh-test/bodhi-base:latest"
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
                    [   defaults.Trigger
                      ⫽ { imageChangeParams =
                            Some
                              (   bodhiBaseImageTrigger
                                ∧ { containerNames = [ "bodhi-celery" ] }
                              )
                        , type = "ImageChange"
                        }
                    , defaults.Trigger ⫽ { type = "ConfigChange" }
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
                , strategy = defaults.RollingStrategy
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-consumer"
                            , deploymentconfig = "bodhi-consumer"
                            }
                        }
                    , spec =
                          defaults.DeploymentTemplateSpec
                        ⫽ { containers =
                              [   defaults.Container
                                ⫽ { image =
                                      "docker-registry.default.svc:5000/asaleh-test/bodhi-base:latest"
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
                    [   defaults.Trigger
                      ⫽ { imageChangeParams =
                            Some
                              (   bodhiBaseImageTrigger
                                ∧ { containerNames = [ "bodhi-consumer" ] }
                              )
                        , type = "ImageChange"
                        }
                    , defaults.Trigger ⫽ { type = "ConfigChange" }
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
                , strategy = defaults.RollingStrategy
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-web"
                            , deploymentconfig = "bodhi-web"
                            }
                        }
                    , spec =
                          defaults.DeploymentTemplateSpec
                        ⫽ { containers =
                              [   defaults.Container
                                ⫽ { image =
                                      "docker-registry.default.svc:5000/asaleh-test/bodhi-base:latest"
                                  , imagePullPolicy = "Always"
                                  , command = [ "/usr/bin/pserve-3" ]
                                  , args =
                                      [ "/srv/bodhi/development.ini"
                                      , "--reload"
                                      ]
                                  , livenessProbe =
                                      Some
                                        (   defaults.Probe
                                          ⫽ { httpGet =
                                                Some
                                                  { path = "/"
                                                  , port = 6543
                                                  , scheme = "HTTP"
                                                  }
                                            }
                                        )
                                  , name = "bodhi-web"
                                  , ports =
                                      [ { containerPort = 6543
                                        , protocol = "TCP"
                                        }
                                      ]
                                  , readinessProbe =
                                      Some
                                        (   defaults.ProbeReady
                                          ⫽ { httpGet =
                                                Some
                                                  { path = "/"
                                                  , port = 6543
                                                  , scheme = "HTTP"
                                                  }
                                            }
                                        )
                                  , volumeMounts = defaultMounts
                                  }
                              ]
                          , volumes = defaultVolumes
                          }
                    }
                , test = False
                , triggers =
                    [   defaults.Trigger
                      ⫽ { imageChangeParams =
                            Some
                              (   bodhiBaseImageTrigger
                                ∧ { containerNames = [ "bodhi-web" ] }
                              )
                        , type = "ImageChange"
                        }
                    , defaults.Trigger ⫽ { type = "ConfigChange" }
                    ]
                }
            }
        , templateObjectTypes.BuildConfig
            { apiVersion = "build.openshift.io/v1"
            , kind = "BuildConfig"
            , metadata =
                { labels = { build = "bodhi-base" }, name = "bodhi-base" }
            , spec =
                { failedBuildsHistoryLimit = 5
                , output =
                    { to =
                        { kind = "ImageStreamTag", name = "bodhi-base:latest" }
                    }
                , postCommit = {=}
                , resources = {=}
                , runPolicy = "Serial"
                , source =
                    { dockerfile = ./files/Dockerfile.base as Text
                    , type = "Dockerfile"
                    }
                , strategy =
                    { dockerStrategy = None types.DockerStrategy
                    , type = "Docker"
                    }
                , successfulBuildsHistoryLimit = 5
                , triggers = [] : List types.Trigger
                }
            }
        , templateObjectTypes.ImageStream
            { apiVersion =
                "image.openshift.io/v1"
            , kind = "ImageStream"
            , metadata = { name = "bodhi-base" }
            , spec =
                { lookupPolicy =
                    { local = False }
                , tags =
                    [ { from =
                          { kind =
                              "DockerImage"
                          , name =
                              "docker-registry.default.svc:5000/asaleh-test/bodhi-base:latest"
                          }
                      , importPolicy = {=}
                      , name = "latest"
                      , referencePolicy = { type = "" }
                      }
                    ]
                }
            }
        , templateObjectTypes.ConfigMap
            { apiVersion = "v1"
            , kind = "ConfigMap"
            , metadata = { name = "bodhi-configmap" }
            , data =
                [ { mapKey = "celeryconfig.py"
                  , mapValue = ./files/celeryconfig.py as Text
                  }
                ]
            }
        , templateObjectTypes.ConfigMap
            { apiVersion = "v1"
            , kind = "ConfigMap"
            , metadata = { name = "bodhi-dev-ini" }
            , data =
                [ { mapKey = "development.ini"
                  , mapValue = ./files/development.ini as Text
                  }
                ]
            }
        , templateObjectTypes.ConfigMap
            { apiVersion = "v1"
            , kind = "ConfigMap"
            , metadata = { name = "bodhi-dev-ini" }
            , data =
                [ { mapKey = "development.ini"
                  , mapValue = ./files/development.ini as Text
                  }
                ]
            }
        , templateObjectTypes.ConfigMap
            { apiVersion = "v1"
            , kind = "ConfigMap"
            , metadata = { name = "bodhi-db-init" }
            , data =
                [ { mapKey = "db_init.sh"
                  , mapValue = ./files/db_init.sh as Text
                  }
                ]
            }
        ]
    }
