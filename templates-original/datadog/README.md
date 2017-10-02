# DataDog Agent

This template deploys a [DataDog](https://www.datadoghq.com/) agent stack consisting of the official [docker-dd-agent](https://www.github.com/Datadog/docker-dd-agent) image and a configuration sidekick that provides closer integration with Rancher:

* Hosts in Datadog are named correctly
* Host labels can be exported as DataDog host tags
* Service labels can be exported as DataDog metric tags
