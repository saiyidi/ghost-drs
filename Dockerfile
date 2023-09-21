FROM ghost:4.48.0
# RUN apt-get update -y && \
#    apt-get install -y mysql-client

# copy config.production.json
COPY ghostapp/config.development.json config.production.json

# copy themes/images to container
COPY ghostapp/content /var/lib/ghost/content

# Add app-insights globally
RUN  mkdir /opt/ai && \
    cd /opt/ai && \
    npm init -y && \
    npm install --production --save applicationinsights && \
    npm install --production --save applicationinsights-native-metrics

# Copy the appinsights.js file
COPY ghostapp/appinsights.js /opt/ai/

# Configure AI via ENV VARS
# ENV APPINSIGHTS_INSTRUMENTATIONKEY xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# ENV APPLICATIONINSIGHTS_ROLE_NAME Frontend
# ENV APPLICATIONINSIGHTS_ROLE_INSTANCE GhostInstance
# Lets use platform agnostic node method to load AI instead of monkey patching i.e. NODE_OPTIONS='--require "/opt/ai/appinsights.js"'
ENV NODE_OPTIONS='--require /opt/ai/appinsights.js'

# COPY ./wait.sh /usr/local/bin/wait.sh