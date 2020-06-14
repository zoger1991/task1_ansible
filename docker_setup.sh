#!/bin/bash

ansible-playbook docker_setup.yml -l $3 --extra-vars "dversion=$1 dcversion=$2"
