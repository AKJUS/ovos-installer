#!/bin/env bash

CONTENT="
¡Ya casi has terminado! Aquí tienes un resumen de las opciones que has elegido para instalar Open Voice OS:

- Method: $METHOD
- Version: $CHANNEL
- Profile: $PROFILE
- GUI: $FEATURE_GUI
- Skills: $FEATURE_SKILLS
- Tuning: $TUNING

Las decisiones que has tomado durante el proceso de instalación de Open Voice OS han sido cuidadosamente consideradas para adaptar el sistema a tus necesidades y preferencias.

¿Este resumen es correcto? Si no es así, puedes volver atrás y hacer cambios.
"
TITLE="Instalación de Open Voice OS - Resumen"

export CONTENT TITLE
