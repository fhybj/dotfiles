#!/bin/bash

ZSH_ENV_PROFILE=$HOME/.zshenv

if [[ ! -f ${ZSH_ENV_PROFILE} ]];then
	/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator > ${ZSH_ENV_PROFILE}
fi
