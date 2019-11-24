let labeledmeta= {
    apiVersion: Text,
    kind: Text,
    metadata: {
        name: Text,
        labels: {
            build: Text
        }
    }
}
in (labeledmeta //\\ {
        spec: {
            failedBuildsHistoryLimit: Natural,
            output: {
                to: {
                    kind: Text,
                    name: Text
                }
            },
            postCommit: {},
            resources: {},
            runPolicy: Text,
            source: {
                dockerfile: Text,
                type: Text
            },
            strategy: {
                type: Text,
                dockerStrategy: < Empty: {} | Tag: {
                    from : {
                        kind: Text,
                        name: Text
                    }
                } >
            },
            successfulBuildsHistoryLimit: Natural,
            triggers: List {
                type: Text,
                imageChange: {}
            }
        }
})