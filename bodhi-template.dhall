let types =
      { BuildConfig =
          { apiVersion : Text
          , kind : Text
          , metadata : { labels : { build : Text }, name : Text }
          , spec :
              { failedBuildsHistoryLimit : Natural
              , output : { to : { kind : Text, name : Text } }
              , postCommit : {}
              , resources : {}
              , runPolicy : Text
              , source : { dockerfile : Text, type : Text }
              , strategy :
                  { dockerStrategy :
                      < Empty : {}
                      | Tag : { from : { kind : Text, name : Text } }
                      >
                  , type : Text
                  }
              , successfulBuildsHistoryLimit : Natural
              , triggers : List { imageChange : {}, type : Text }
              }
          }
      , DeploymentConfig =
          { apiVersion : Text
          , kind : Text
          , metadata : { labels : { app : Text, service : Text }, name : Text }
          , spec :
              { replicas : Natural
              , revisionHistoryLimit : Natural
              , selector : { deploymentconfig : Text }
              , strategy :
                  { activeDeadlineSeconds : Natural
                  , recreateParams : { timeoutSeconds : Natural }
                  , resources : {}
                  , rollingParams :
                      { intervalSeconds : Natural
                      , maxSurge : Text
                      , maxUnavailable : Text
                      , timeoutSeconds : Natural
                      , updatePeriodSeconds : Natural
                      }
                  , type : Text
                  }
              , template :
                  { metadata :
                      { labels : { app : Text, deploymentconfig : Text } }
                  , spec :
                      { containers :
                          List
                            < C :
                                { image : Text
                                , imagePullPolicy : Text
                                , name : Text
                                , resources : {}
                                , terminationMessagePath : Text
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    List
                                      < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >
                                }
                            | C_L :
                                { image : Text
                                , imagePullPolicy : Text
                                , livenessProbe :
                                    { failureThreshold : Natural
                                    , httpGet :
                                        { path : Text
                                        , port : Natural
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , periodSeconds : Natural
                                    , successThreshold : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , resources : {}
                                , terminationMessagePath : Text
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    List
                                      < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >
                                }
                            | C_L_R_P :
                                { image : Text
                                , imagePullPolicy : Text
                                , livenessProbe :
                                    { failureThreshold : Natural
                                    , httpGet :
                                        { path : Text
                                        , port : Natural
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , periodSeconds : Natural
                                    , successThreshold : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , name : Text
                                , ports :
                                    List
                                      { containerPort : Natural
                                      , protocol : Text
                                      }
                                , readinessProbe :
                                    { failureThreshold : Natural
                                    , httpGet :
                                        { path : Text
                                        , port : Natural
                                        , scheme : Text
                                        }
                                    , initialDelaySeconds : Natural
                                    , periodSeconds : Natural
                                    , successThreshold : Natural
                                    , timeoutSeconds : Natural
                                    }
                                , resources : {}
                                , terminationMessagePath : Text
                                , terminationMessagePolicy : Text
                                , volumeMounts :
                                    List
                                      < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >
                                }
                            >
                      , dnsPolicy : Text
                      , restartPolicy : Text
                      , schedulerName : Text
                      , securityContext : {}
                      , terminationGracePeriodSeconds : Natural
                      , volumes :
                          List
                            < ConfigMap :
                                { configMap :
                                    { defaultMode : Natural, name : Text }
                                , name : Text
                                }
                            | Empty : { emptyDir : {}, name : Text }
                            | Secret :
                                { name : Text
                                , secret :
                                    { defaultMode : Natural, secretName : Text }
                                }
                            >
                      }
                  }
              , test : Bool
              , triggers :
                  List
                    < ConfigChange : { type : Text }
                    | ImageChange :
                        { imageChangeParams :
                            { automatic : Bool
                            , containerNames : List Text
                            , from :
                                { kind : Text, name : Text, namespace : Text }
                            }
                        , type : Text
                        }
                    >
              }
          }
      , ImageStream =
          { apiVersion : Text
          , kind : Text
          , metadata : { name : Text }
          , spec :
              { lookupPolicy : { local : Bool }
              , tags :
                  List
                    { annotations : Optional Text
                    , from : { kind : Text, name : Text }
                    , importPolicy : {}
                    , name : Text
                    , referencePolicy : { type : Text }
                    }
              }
          }
      , Route =
          { apiVersion : Text
          , kind : Text
          , metadata : { labels : { app : Text }, name : Text }
          , spec :
              { host : Text
              , port : { targetPort : Text }
              , tls :
                  { insecureEdgeTerminationPolicy : Text, termination : Text }
              , to : { kind : Text, name : Text, weight : Natural }
              , wildcardPolicy : Optional Text
              }
          }
      , Service =
          { apiVersion : Text
          , kind : Text
          , metadata : { labels : { app : Text, service : Text }, name : Text }
          , spec :
              { ports :
                  List
                    { name : Text
                    , port : Natural
                    , protocol : Text
                    , targetPort : Natural
                    }
              , selector : { deploymentconfig : Text }
              , sessionAffinity : Optional Text
              , type : Text
              }
          }
      }

let templateObjectTypes =
      < BuildConfig : types.BuildConfig
      | DeploymentConfig : types.DeploymentConfig
      | ImageStream : types.ImageStream
      | Route : types.Route
      | Service : types.Service
      >

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
                      , targetPort = 8080
                      }
                    ]
                , selector = { deploymentconfig = "bodhi-web" }
                , sessionAffinity = Some "None"
                , type = "ClusterIP"
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
                , strategy =
                    { activeDeadlineSeconds = 21600
                    , recreateParams = { timeoutSeconds = 600 }
                    , resources = {=}
                    , rollingParams =
                        { intervalSeconds = 1
                        , maxSurge = "25%"
                        , maxUnavailable = "25%"
                        , timeoutSeconds = 600
                        , updatePeriodSeconds = 1
                        }
                    , type = "Rolling"
                    }
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-celery"
                            , deploymentconfig = "bodhi-celery"
                            }
                        }
                    , spec =
                        { containers =
                            [ < C :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , name : Text
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              | C_L :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , livenessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , name : Text
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              | C_L_R_P :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , livenessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , name : Text
                                  , ports :
                                      List
                                        { containerPort : Natural
                                        , protocol : Text
                                        }
                                  , readinessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              >.C
                                { image =
                                    "docker-registry.default.svc:5000/bodhi/bodhi-celery:latest"
                                , imagePullPolicy = "Always"
                                , name = "bodhi-celery"
                                , resources = {=}
                                , terminationMessagePath =
                                    "/dev/termination-log"
                                , terminationMessagePolicy = "File"
                                , volumeMounts =
                                    [ < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/bodhi"
                                        , name = "config-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/keytabs"
                                        , name = "keytab-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/fedora-messaging"
                                        , name =
                                            "fedora-messaging-config-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/cacert.pem"
                                        , name = "fedora-messaging-ca-volume"
                                        , readOnly = True
                                        , subPath = "cacert.pem"
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/bodhi-cert.pem"
                                        , name = "fedora-messaging-crt-volume"
                                        , readOnly = True
                                        , subPath = "bodhi-cert.pem"
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/bodhi-key.pem"
                                        , name = "fedora-messaging-key-volume"
                                        , readOnly = True
                                        , subPath = "bodhi-key.pem"
                                        }
                                    ]
                                }
                            ]
                        , dnsPolicy = "ClusterFirst"
                        , restartPolicy = "Always"
                        , schedulerName = "default-scheduler"
                        , securityContext = {=}
                        , terminationGracePeriodSeconds = 30
                        , volumes =
                            [ < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.ConfigMap
                                { configMap =
                                    { defaultMode = 420
                                    , name = "bodhi-configmap"
                                    }
                                , name = "config-volume"
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "keytab-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-keytab"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.ConfigMap
                                { configMap =
                                    { defaultMode = 420
                                    , name = "fedora-messaging-configmap"
                                    }
                                , name = "fedora-messaging-config-volume"
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-ca-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-ca"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-crt-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-crt"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-key-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-key"
                                    }
                                }
                            ]
                        }
                    }
                , test = False
                , triggers =
                    [ < ConfigChange : { type : Text }
                      | ImageChange :
                          { imageChangeParams :
                              { automatic : Bool
                              , containerNames : List Text
                              , from :
                                  { kind : Text, name : Text, namespace : Text }
                              }
                          , type : Text
                          }
                      >.ImageChange
                        { imageChangeParams =
                            { automatic = True
                            , containerNames = [ "bodhi-celery" ]
                            , from =
                                { kind = "ImageStreamTag"
                                , name = "bodhi-celery:latest"
                                , namespace = "bodhi"
                                }
                            }
                        , type = "ImageChange"
                        }
                    , < ConfigChange : { type : Text }
                      | ImageChange :
                          { imageChangeParams :
                              { automatic : Bool
                              , containerNames : List Text
                              , from :
                                  { kind : Text, name : Text, namespace : Text }
                              }
                          , type : Text
                          }
                      >.ConfigChange
                        { type = "ConfigChange" }
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
                , strategy =
                    { activeDeadlineSeconds = 21600
                    , recreateParams = { timeoutSeconds = 600 }
                    , resources = {=}
                    , rollingParams =
                        { intervalSeconds = 1
                        , maxSurge = "25%"
                        , maxUnavailable = "25%"
                        , timeoutSeconds = 600
                        , updatePeriodSeconds = 1
                        }
                    , type = "Rolling"
                    }
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-consumer"
                            , deploymentconfig = "bodhi-consumer"
                            }
                        }
                    , spec =
                        { containers =
                            [ < C :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , name : Text
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              | C_L :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , livenessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , name : Text
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              | C_L_R_P :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , livenessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , name : Text
                                  , ports :
                                      List
                                        { containerPort : Natural
                                        , protocol : Text
                                        }
                                  , readinessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              >.C
                                { image =
                                    "docker-registry.default.svc:5000/bodhi/bodhi-consumer@sha256:835653af4e6d1a800c3fbd13f64ded94e607984a149b26e1e15f7ab522dfa188"
                                , imagePullPolicy = "Always"
                                , name = "bodhi-consumer"
                                , resources = {=}
                                , terminationMessagePath =
                                    "/dev/termination-log"
                                , terminationMessagePolicy = "File"
                                , volumeMounts =
                                    [ < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/bodhi"
                                        , name = "config-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/keytabs"
                                        , name = "keytab-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/fedora-messaging"
                                        , name =
                                            "fedora-messaging-config-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/cacert.pem"
                                        , name = "fedora-messaging-ca-volume"
                                        , readOnly = True
                                        , subPath = "cacert.pem"
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/bodhi-cert.pem"
                                        , name = "fedora-messaging-crt-volume"
                                        , readOnly = True
                                        , subPath = "bodhi-cert.pem"
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/bodhi-key.pem"
                                        , name = "fedora-messaging-key-volume"
                                        , readOnly = True
                                        , subPath = "bodhi-key.pem"
                                        }
                                    ]
                                }
                            ]
                        , dnsPolicy = "ClusterFirst"
                        , restartPolicy = "Always"
                        , schedulerName = "default-scheduler"
                        , securityContext = {=}
                        , terminationGracePeriodSeconds = 30
                        , volumes =
                            [ < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.ConfigMap
                                { configMap =
                                    { defaultMode = 420
                                    , name = "bodhi-configmap"
                                    }
                                , name = "config-volume"
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "keytab-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-keytab"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.ConfigMap
                                { configMap =
                                    { defaultMode = 420
                                    , name = "fedora-messaging-configmap"
                                    }
                                , name = "fedora-messaging-config-volume"
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-ca-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-ca"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-crt-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-crt"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-key-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-key"
                                    }
                                }
                            ]
                        }
                    }
                , test = False
                , triggers =
                    [ < ConfigChange : { type : Text }
                      | ImageChange :
                          { imageChangeParams :
                              { automatic : Bool
                              , containerNames : List Text
                              , from :
                                  { kind : Text, name : Text, namespace : Text }
                              }
                          , type : Text
                          }
                      >.ImageChange
                        { imageChangeParams =
                            { automatic = True
                            , containerNames = [ "bodhi-consumer" ]
                            , from =
                                { kind = "ImageStreamTag"
                                , name = "bodhi-consumer:latest"
                                , namespace = "bodhi"
                                }
                            }
                        , type = "ImageChange"
                        }
                    , < ConfigChange : { type : Text }
                      | ImageChange :
                          { imageChangeParams :
                              { automatic : Bool
                              , containerNames : List Text
                              , from :
                                  { kind : Text, name : Text, namespace : Text }
                              }
                          , type : Text
                          }
                      >.ConfigChange
                        { type = "ConfigChange" }
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
                , strategy =
                    { activeDeadlineSeconds = 21600
                    , recreateParams = { timeoutSeconds = 600 }
                    , resources = {=}
                    , rollingParams =
                        { intervalSeconds = 1
                        , maxSurge = "25%"
                        , maxUnavailable = "25%"
                        , timeoutSeconds = 600
                        , updatePeriodSeconds = 1
                        }
                    , type = "Rolling"
                    }
                , template =
                    { metadata =
                        { labels =
                            { app = "bodhi-web"
                            , deploymentconfig = "bodhi-web"
                            }
                        }
                    , spec =
                        { containers =
                            [ < C :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , name : Text
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              | C_L :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , livenessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , name : Text
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              | C_L_R_P :
                                  { image : Text
                                  , imagePullPolicy : Text
                                  , livenessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , name : Text
                                  , ports :
                                      List
                                        { containerPort : Natural
                                        , protocol : Text
                                        }
                                  , readinessProbe :
                                      { failureThreshold : Natural
                                      , httpGet :
                                          { path : Text
                                          , port : Natural
                                          , scheme : Text
                                          }
                                      , initialDelaySeconds : Natural
                                      , periodSeconds : Natural
                                      , successThreshold : Natural
                                      , timeoutSeconds : Natural
                                      }
                                  , resources : {}
                                  , terminationMessagePath : Text
                                  , terminationMessagePolicy : Text
                                  , volumeMounts :
                                      List
                                        < RO :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            }
                                        | STD :
                                            { mountPath : Text, name : Text }
                                        | Subpath :
                                            { mountPath : Text
                                            , name : Text
                                            , readOnly : Bool
                                            , subPath : Text
                                            }
                                        >
                                  }
                              >.C_L_R_P
                                { image =
                                    "docker-registry.default.svc:5000/bodhi/bodhi-web@sha256:e3fc48ca9f3cdb16b761b7d85b936ef7ff0187c29cc9fff31f8ff3005c4d7238"
                                , imagePullPolicy = "Always"
                                , livenessProbe =
                                    { failureThreshold = 3
                                    , httpGet =
                                        { path = "/"
                                        , port = 8080
                                        , scheme = "HTTP"
                                        }
                                    , initialDelaySeconds = 30
                                    , periodSeconds = 10
                                    , successThreshold = 1
                                    , timeoutSeconds = 10
                                    }
                                , name = "bodhi-web"
                                , ports =
                                    [ { containerPort = 8080, protocol = "TCP" }
                                    ]
                                , readinessProbe =
                                    { failureThreshold = 3
                                    , httpGet =
                                        { path = "/"
                                        , port = 8080
                                        , scheme = "HTTP"
                                        }
                                    , initialDelaySeconds = 5
                                    , periodSeconds = 10
                                    , successThreshold = 1
                                    , timeoutSeconds = 10
                                    }
                                , resources = {=}
                                , terminationMessagePath =
                                    "/dev/termination-log"
                                , terminationMessagePolicy = "File"
                                , volumeMounts =
                                    [ < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/bodhi"
                                        , name = "config-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/keytabs"
                                        , name = "keytab-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.STD
                                        { mountPath = "/httpdir"
                                        , name = "httpdir-volume"
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.RO
                                        { mountPath = "/etc/fedora-messaging"
                                        , name =
                                            "fedora-messaging-config-volume"
                                        , readOnly = True
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/cacert.pem"
                                        , name = "fedora-messaging-ca-volume"
                                        , readOnly = True
                                        , subPath = "cacert.pem"
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/bodhi-cert.pem"
                                        , name = "fedora-messaging-crt-volume"
                                        , readOnly = True
                                        , subPath = "bodhi-cert.pem"
                                        }
                                    , < RO :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          }
                                      | STD : { mountPath : Text, name : Text }
                                      | Subpath :
                                          { mountPath : Text
                                          , name : Text
                                          , readOnly : Bool
                                          , subPath : Text
                                          }
                                      >.Subpath
                                        { mountPath =
                                            "/etc/pki/fedora-messaging/bodhi-key.pem"
                                        , name = "fedora-messaging-key-volume"
                                        , readOnly = True
                                        , subPath = "bodhi-key.pem"
                                        }
                                    ]
                                }
                            ]
                        , dnsPolicy = "ClusterFirst"
                        , restartPolicy = "Always"
                        , schedulerName = "default-scheduler"
                        , securityContext = {=}
                        , terminationGracePeriodSeconds = 30
                        , volumes =
                            [ < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.ConfigMap
                                { configMap =
                                    { defaultMode = 420
                                    , name = "bodhi-configmap"
                                    }
                                , name = "config-volume"
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "keytab-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-keytab"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Empty
                                { emptyDir = {=}, name = "httpdir-volume" }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.ConfigMap
                                { configMap =
                                    { defaultMode = 420
                                    , name = "fedora-messaging-configmap"
                                    }
                                , name = "fedora-messaging-config-volume"
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-ca-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-ca"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-crt-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-crt"
                                    }
                                }
                            , < ConfigMap :
                                  { configMap :
                                      { defaultMode : Natural, name : Text }
                                  , name : Text
                                  }
                              | Empty : { emptyDir : {}, name : Text }
                              | Secret :
                                  { name : Text
                                  , secret :
                                      { defaultMode : Natural
                                      , secretName : Text
                                      }
                                  }
                              >.Secret
                                { name = "fedora-messaging-key-volume"
                                , secret =
                                    { defaultMode = 420
                                    , secretName = "bodhi-fedora-messaging-key"
                                    }
                                }
                            ]
                        }
                    }
                , test = False
                , triggers =
                    [ < ConfigChange : { type : Text }
                      | ImageChange :
                          { imageChangeParams :
                              { automatic : Bool
                              , containerNames : List Text
                              , from :
                                  { kind : Text, name : Text, namespace : Text }
                              }
                          , type : Text
                          }
                      >.ImageChange
                        { imageChangeParams =
                            { automatic = True
                            , containerNames = [ "bodhi-web" ]
                            , from =
                                { kind = "ImageStreamTag"
                                , name = "bodhi-web:latest"
                                , namespace = "bodhi"
                                }
                            }
                        , type = "ImageChange"
                        }
                    , < ConfigChange : { type : Text }
                      | ImageChange :
                          { imageChangeParams :
                              { automatic : Bool
                              , containerNames : List Text
                              , from :
                                  { kind : Text, name : Text, namespace : Text }
                              }
                          , type : Text
                          }
                      >.ConfigChange
                        { type = "ConfigChange" }
                    ]
                }
            }
        , templateObjectTypes.BuildConfig
            { apiVersion =
                "build.openshift.io/v1"
            , kind = "BuildConfig"
            , metadata =
                { labels = { build = "bodhi-base" }, name = "bodhi-base" }
            , spec =
                { failedBuildsHistoryLimit =
                    5
                , output =
                    { to =
                        { kind = "ImageStreamTag", name = "bodhi-base:latest" }
                    }
                , postCommit = {=}
                , resources = {=}
                , runPolicy = "Serial"
                , source =
                    { dockerfile =
                        ''
                        FROM fedora:30
                        LABEL \
                          name="bodhi-base" \
                          vendor="Fedora Infrastructure" \
                          license="MIT"
                        RUN curl -o /etc/yum.repos.d/infra-tags-stg.repo https://infrastructure.fedoraproject.org/cgit/ansible.git/plain/files/common/fedora-infra-tags-stg.repo
                        # While dnf has a --nodocs, it doesen't have a --docs...
                        RUN sed -i '/nodocs/d' /etc/dnf/dnf.conf
                        RUN dnf install -y \
                            git                         \
                            python3-pip                 \
                            fedora-messaging            \
                            httpd                       \
                            intltool                    \
                            python3-alembic             \
                            python3-arrow               \
                            python3-backoff             \
                            python3-bleach              \
                            python3-celery              \
                            python3-click               \
                            python3-colander            \
                            python3-cornice             \
                            python3-dogpile-cache       \
                            python3-fedora-messaging    \
                            python3-feedgen             \
                            python3-jinja2              \
                            python3-markdown            \
                            python3-psycopg2            \
                            python3-py3dns              \
                            python3-pyasn1-modules      \
                            python3-pylibravatar        \
                            python3-pyramid             \
                            python3-pyramid-fas-openid  \
                            python3-pyramid-mako        \
                            python3-bugzilla            \
                            python3-fedora              \
                            python3-pyyaml              \
                            python3-simplemediawiki     \
                            python3-sqlalchemy          \
                            python3-waitress            \
                            python3-dnf                 \
                            python3-koji                \
                            python3-librepo             \
                            python3-mod_wsgi            \
                            koji && \
                            dnf clean all
                        
                        RUN git clone -b 5.0 https://github.com/fedora-infra/bodhi.git /srv/bodhi && \
                            cd /srv/bodhi && \
                            python3 -m pip install . --no-use-pep517 && \
                            mkdir -p /usr/share/bodhi && \
                            cp /srv/bodhi/apache/bodhi.wsgi /usr/share/bodhi/bodhi.wsgi
                        
                        # Set up krb5
                        RUN rm -f /etc/krb5.conf && \
                            ln -sf /etc/bodhi/krb5.conf /etc/krb5.conf && \
                            ln -sf /etc/keytabs/koji-keytab /etc/krb5.bodhi_bodhi.stg.fedoraproject.org.keytab
                        ENV USER=openshift''
                    , type = "Dockerfile"
                    }
                , strategy =
                    { dockerStrategy =
                        < Empty : {}
                        | Tag : { from : { kind : Text, name : Text } }
                        >.Empty
                          {=}
                    , type = "Docker"
                    }
                , successfulBuildsHistoryLimit = 5
                , triggers = [] : List { imageChange : {}, type : Text }
                }
            }
        , templateObjectTypes.BuildConfig
            { apiVersion =
                "build.openshift.io/v1"
            , kind = "BuildConfig"
            , metadata =
                { labels = { build = "bodhi-celery" }, name = "bodhi-celery" }
            , spec =
                { failedBuildsHistoryLimit =
                    5
                , output =
                    { to =
                        { kind = "ImageStreamTag"
                        , name = "bodhi-celery:latest"
                        }
                    }
                , postCommit = {=}
                , resources = {=}
                , runPolicy = "Serial"
                , source =
                    { dockerfile =
                        ''
                        FROM bodhi-base
                        LABEL \
                          name="bodhi-celery" \
                          vendor="Fedora Infrastructure" \
                          license="MIT"
                        ENTRYPOINT /usr/bin/celery worker -A bodhi.server.tasks.app -l info -Q celery''
                    , type = "Dockerfile"
                    }
                , strategy =
                    { dockerStrategy =
                        < Empty : {}
                        | Tag : { from : { kind : Text, name : Text } }
                        >.Tag
                          { from =
                              { kind = "ImageStreamTag"
                              , name = "bodhi-base:latest"
                              }
                          }
                    , type = "Docker"
                    }
                , successfulBuildsHistoryLimit = 5
                , triggers = [ { imageChange = {=}, type = "ImageChange" } ]
                }
            }
        , templateObjectTypes.BuildConfig
            { apiVersion = "build.openshift.io/v1"
            , kind = "BuildConfig"
            , metadata =
                { labels = { build = "bodhi-consumer" }
                , name = "bodhi-consumer"
                }
            , spec =
                { failedBuildsHistoryLimit = 5
                , output =
                    { to =
                        { kind = "ImageStreamTag"
                        , name = "bodhi-consumer:latest"
                        }
                    }
                , postCommit = {=}
                , resources = {=}
                , runPolicy = "Serial"
                , source =
                    { dockerfile =
                        ''
                        FROM bodhi-base
                        LABEL \
                          name="bodhi-consumer" \
                          vendor="Fedora Infrastructure" \
                          license="MIT"
                        ENTRYPOINT /usr/bin/fedora-messaging consume''
                    , type = "Dockerfile"
                    }
                , strategy =
                    { dockerStrategy =
                        < Empty : {}
                        | Tag : { from : { kind : Text, name : Text } }
                        >.Tag
                          { from =
                              { kind = "ImageStreamTag"
                              , name = "bodhi-base:latest"
                              }
                          }
                    , type = "Docker"
                    }
                , successfulBuildsHistoryLimit = 5
                , triggers = [ { imageChange = {=}, type = "ImageChange" } ]
                }
            }
        , templateObjectTypes.BuildConfig
            { apiVersion = "build.openshift.io/v1"
            , kind = "BuildConfig"
            , metadata =
                { labels = { build = "bodhi-web" }, name = "bodhi-web" }
            , spec =
                { failedBuildsHistoryLimit = 5
                , output =
                    { to =
                        { kind = "ImageStreamTag", name = "bodhi-web:latest" }
                    }
                , postCommit = {=}
                , resources = {=}
                , runPolicy = "Serial"
                , source =
                    { dockerfile =
                        ''
                        FROM bodhi-base
                        LABEL \
                          name="bodhi-web" \
                          vendor="Fedora Infrastructure" \
                          license="MIT"
                        RUN dnf install --refresh -y python3-pyramid_sawing
                        EXPOSE 8080
                        ENTRYPOINT bash /etc/bodhi/start.sh''
                    , type = "Dockerfile"
                    }
                , strategy =
                    { dockerStrategy =
                        < Empty : {}
                        | Tag : { from : { kind : Text, name : Text } }
                        >.Tag
                          { from =
                              { kind = "ImageStreamTag"
                              , name = "bodhi-base:latest"
                              }
                          }
                    , type = "Docker"
                    }
                , successfulBuildsHistoryLimit = 5
                , triggers = [ { imageChange = {=}, type = "ImageChange" } ]
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
                    [ { annotations =
                          None Text
                      , from =
                          { kind =
                              "DockerImage"
                          , name =
                              "docker-registry.default.svc:5000/bodhi/bodhi-base:latest"
                          }
                      , importPolicy = {=}
                      , name = "latest"
                      , referencePolicy = { type = "" }
                      }
                    ]
                }
            }
        , templateObjectTypes.ImageStream
            { apiVersion =
                "image.openshift.io/v1"
            , kind = "ImageStream"
            , metadata = { name = "bodhi-celery" }
            , spec =
                { lookupPolicy =
                    { local = False }
                , tags =
                    [ { annotations =
                          None Text
                      , from =
                          { kind =
                              "DockerImage"
                          , name =
                              "docker-registry.default.svc:5000/bodhi/bodhi-celery:latest"
                          }
                      , importPolicy = {=}
                      , name = "latest"
                      , referencePolicy = { type = "" }
                      }
                    ]
                }
            }
        , templateObjectTypes.ImageStream
            { apiVersion =
                "image.openshift.io/v1"
            , kind = "ImageStream"
            , metadata = { name = "bodhi-consumer" }
            , spec =
                { lookupPolicy =
                    { local = False }
                , tags =
                    [ { annotations =
                          None Text
                      , from =
                          { kind =
                              "DockerImage"
                          , name =
                              "docker-registry.default.svc:5000/bodhi/bodhi-consumer:latest"
                          }
                      , importPolicy = {=}
                      , name = "latest"
                      , referencePolicy = { type = "" }
                      }
                    ]
                }
            }
        , templateObjectTypes.ImageStream
            { apiVersion =
                "image.openshift.io/v1"
            , kind = "ImageStream"
            , metadata = { name = "bodhi-web" }
            , spec =
                { lookupPolicy =
                    { local = False }
                , tags =
                    [ { annotations =
                          None Text
                      , from =
                          { kind =
                              "DockerImage"
                          , name =
                              "docker-registry.default.svc:5000/bodhi/bodhi-web:latest"
                          }
                      , importPolicy = {=}
                      , name = "latest"
                      , referencePolicy = { type = "" }
                      }
                    ]
                }
            }
        , templateObjectTypes.Route
            { apiVersion = "route.openshift.io/v1"
            , kind = "Route"
            , metadata = { labels = { app = "bodhi" }, name = "bodhi-web" }
            , spec =
                { host = "bodhi.stg.fedoraproject.org"
                , port = { targetPort = "web" }
                , tls =
                    { insecureEdgeTerminationPolicy = "Redirect"
                    , termination = "edge"
                    }
                , to = { kind = "Service", name = "bodhi-web", weight = 100 }
                , wildcardPolicy = Some "None"
                }
            }
        ]
    }
