# Deployment configuration for testing Bodhi in Open Shift

*Warning, this is a work in progress*

This configuration should deploy Bodhi server in simmilar manner as you'd
be used to if you were developing Bodhi in Vagrant.

To help me with understanding of the Openshift Confiuration, I typed all of it in Dhall language,
and run

`dhall-to-yaml --file bodhi-template.dhall | oc process -f - -p NAMESPACE=$MY_NAMESPACE | oc apply -f -`

to update the configuration in my project.

If you don't find Dhall helpfull, I stored the resultig yaml in test-template.yaml.
