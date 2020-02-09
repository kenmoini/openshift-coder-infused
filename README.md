## openshift-coder-infused

This is a set of resources used to deploy the Coder Server as a container on Red Hat OpenShift Container Platform.

It has a few extra binaries stuffed in there to make things generally helpful, such as:

- Composer
- Golang
- NodeJS
- OpenJDK & Maven
- oc, odo, kubectl
- Python 2 & PIP
- Python 3 & PIP
- PHP7
- ZSH, Oh-My-ZSH, and thefuck

There have also been modifications to make the Coder built-in terminal work out-of-the-box, even with the random UID that OpenShift sets for running containers.

## Deploy via OpenShift Template

Use the `openshift-template.json` file to apply/create this template in OpenShift.  Pay attention to the input prompt for the PASSWORD variable.