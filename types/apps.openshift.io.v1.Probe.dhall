{ failureThreshold : Natural
, httpGet : Optional { path : Text, port : Natural, scheme : Text }
, exec : Optional {command : List Text}
, initialDelaySeconds : Natural
, periodSeconds : Natural
, successThreshold : Natural
, timeoutSeconds : Natural
}
