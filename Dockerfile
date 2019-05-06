FROM adoptopenjdk/openjdk8:alpine

RUN apk update && \
    apk add curl bash python git && \
    curl https://sdk.cloud.google.com | bash

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN /root/google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /root/google-cloud-sdk/lib/googlecloudsdk/core/config.json

VOLUME ["/.config"]
ENV PATH $PATH:/root/google-cloud-sdk/bin

CMD /bin/bash
