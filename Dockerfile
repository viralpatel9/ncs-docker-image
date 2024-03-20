# Build nRF applications using the docker file and west. 

#Base image
FROM ubuntu:20.04

# Label
LABEL MAINTAINER Viral Patel <viralp2121@gmail.com> Name=ncs-docker

# Arguments
ARG name=defaultValue