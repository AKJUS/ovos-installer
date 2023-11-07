#!/bin/env bash

message="Hello and welcome to the Open Voice OS installation!

We're excited to introduce you to Open Voice OS, the open-source voice assistant that's changing the way we interact with technology.

Installing Open Voice OS is a breeze, and it opens up a world of possibilities for voice-controlled convenience. Whether you're a tech enthusiast or just looking to simplify your daily tasks, Open Voice OS is here to make your life easier.

Get started with the installation today and let your voice guide you through the future of technology!🌟"

whiptail --msgbox --title "Open Voice OS Installation - Welcome" "$message" 25 80
