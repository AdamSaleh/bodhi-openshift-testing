{ Type =
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
    
, default = {
                , sessionAffinity = Some "None"
                , type = "ClusterIP"
}
}