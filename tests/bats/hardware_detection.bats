#!/usr/bin/env bats

function setup() {
    load "$HOME/shell-testing/test_helper/bats-support/load"
    load "$HOME/shell-testing/test_helper/bats-assert/load"
    load ../../utils/constants.sh
    load ../../utils/common.sh
    LOG_FILE=/tmp/ovos-installer.log
    RUN_AS="testuser"
    RASPBERRYPI_MODEL="N/A"
}

# Test avrdude setup function
@test "function_setup_avrdude_file_creation" {
    AVRDUDE_BINARY_PATH=/tmp/test_avrdude
    RUN_AS_HOME=/tmp/test_home
    mkdir -p "$RUN_AS_HOME"

    function curl() {
        # Mock successful curl download
        touch "$AVRDUDE_BINARY_PATH"
        return 0
    }
    export -f curl

    run setup_avrdude
    assert_success
    # Should create avrdude binary
    [ -f "$AVRDUDE_BINARY_PATH" ]
    # Should create avrduderc file
    [ -f "$RUN_AS_HOME/.avrduderc" ]

    # Clean up
    rm -f "$AVRDUDE_BINARY_PATH" "$RUN_AS_HOME/.avrduderc"
    rmdir "$RUN_AS_HOME"
}

@test "function_setup_avrdude_existing_file_removal" {
    AVRDUDE_BINARY_PATH=/tmp/test_avrdude
    RUN_AS_HOME=/tmp/test_home
    mkdir -p "$RUN_AS_HOME"

    # Create existing file
    touch "$AVRDUDE_BINARY_PATH"

    function curl() {
        # Mock successful curl download - recreate the file
        touch "$AVRDUDE_BINARY_PATH"
        return 0
    }
    export -f curl

    run setup_avrdude
    assert_success
    # Should still have created the avrdude binary
    [ -f "$AVRDUDE_BINARY_PATH" ]
    # Should create avrduderc file
    [ -f "$RUN_AS_HOME/.avrduderc" ]

    # Clean up
    rm -f "$AVRDUDE_BINARY_PATH" "$RUN_AS_HOME/.avrduderc"
    rmdir "$RUN_AS_HOME"
    unset -f curl
}



# Test I2C scan function
@test "function_i2c_scan_raspberry_pi_detected" {
    RASPBERRYPI_MODEL="Raspberry Pi 4"

    function dtparam() {
        return 0
    }
    function lsmod() {
        return 0
    }
    function i2c_get() {
        return 1  # No devices detected
    }
    export -f dtparam lsmod i2c_get

    run i2c_scan
    assert_success
}

@test "function_i2c_scan_not_raspberry_pi" {
    RASPBERRYPI_MODEL="N/A"

    run i2c_scan
    assert_success
    # Should not attempt I2C operations
}

# Test apt_ensure function
@test "function_apt_ensure_all_packages_installed" {
    function dpkg-query() {
        # Mock all packages as installed
        echo "install ok installed"
    }
    export -f dpkg-query

    run apt_ensure "git" "curl" "htop"
    assert_success
    # Should not attempt installation
}



# Test state directory function
@test "function_state_directory_creation" {
    RUN_AS_HOME=/tmp/test_home
    mkdir -p "$RUN_AS_HOME"

    run state_directory
    assert_success
    # Should create the directory structure
    [ -d "$RUN_AS_HOME/.local/state/ovos" ]

    # Clean up
    rm -rf "$RUN_AS_HOME"
}

@test "function_state_directory_existing" {
    RUN_AS_HOME=/tmp/test_home
    mkdir -p "$RUN_AS_HOME/.local/state/ovos"

    run state_directory
    assert_success
    # Should still work with existing directory
    [ -d "$RUN_AS_HOME/.local/state/ovos" ]

    # Clean up
    rm -rf "$RUN_AS_HOME"
}

# Test apt_ensure more thoroughly
@test "function_apt_ensure_mixed_packages" {
    UPDATE=1
    export UPDATE

    function dpkg-query() {
        if [[ "$1" == "git" ]]; then
            echo "install ok installed"
        elif [[ "$1" == "curl" ]]; then
            echo ""
        fi
    }
    function sudo() {
        # Mock sudo
        "$@"
    }
    function apt() {
        # Mock apt install
        return 0
    }
    export -f dpkg-query sudo apt

    run apt_ensure "git" "curl"
    assert_success
    unset -f dpkg-query sudo apt
    unset UPDATE
}

function teardown() {
    rm -f "$LOG_FILE"
    unset DETECTED_DEVICES AVRDUDE_BINARY_PATH RUN_AS_HOME RASPBERRYPI_MODEL
}
