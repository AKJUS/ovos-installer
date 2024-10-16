#!/bin/env bash

CONTENT="
Trobeu la informació detectada:

    - Sistema operatiu: ${DISTRO_NAME^} $DISTRO_VERSION
    - Nucli: $KERNEL
    - RPi: $RASPBERRYPI_MODEL
    - Python: $(echo "$PYTHON" | awk '{ print $NF }')
    - AVX2/SIMD: $CPU_IS_CAPABLE
    - Maquinari: $HARDWARE_DETECTED
    - Venv: $VENV_PATH
    - So: $SOUND_SERVER
    - Pantalla: ${DISPLAY_SERVER^}
"
TITLE="Instal·lació de l'Open Voice OS - Informació detectada"

export CONTENT TITLE
