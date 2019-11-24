
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