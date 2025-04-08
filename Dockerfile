# Builds Solr image for a Windows container environment

FROM openjdk:8u151-jdk-nanoserver-sac2016

# Download and extract Solr project files
RUN Invoke-WebRequest -Method Get -Uri "http://dlcdn.apache.org/lucene/solr/8.11.4/solr-8.11.4.zip" -OutFile /solr.zip ; \
    Expand-Archive -Path /solr.zip -DestinationPath /solr ; \
    Remove-Item /solr.zip -Force

WORKDIR "/solr/solr-8.11.4"

# Copy custom config files
COPY extlib/ server/extlib
COPY jpoc_vm/ server/solr/jpoc_vm

EXPOSE 8983

HEALTHCHECK CMD powershell -command \
    try { \
        $response = iwr "http://localhost:8983" -UseBasicParsing; \
        if ($response.StatusCode -eq 200) { return 0} else {return 1}; \
    } catch { return 1 }

ENTRYPOINT bin/solr start -port 8983 -f -noprompt