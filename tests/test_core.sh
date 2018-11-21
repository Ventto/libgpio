#!/bin/bash

. "../libgpio.sh"

[ -z "$DEBUG" ] && DEBUG=0

DEBUG() {
    if [ "$DEBUG" = "1" ]; then
        echo "$1"
    fi
}

if [ "$(id -u)" -ne 0 ]; then
    printf '\nerror: root is required\n'
    exit 1
fi

if [ -z "$GPIOCHIP_N" ]; then
    printf '\nerror: GPIOCHIP_N environment variable must be set\n'
    printf '       to target a `/sys/class/gpio/gpiochip<N>` directory.\n\n'
    echo "example:"
    printf '$ GPIOCHIP_N=224 bash_unit ./tests_core.sh\n\n'
    exit 1
fi

export GPIOCHIP_N

test_1_gpio_select_gpiochip()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"

    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1
    gpio_select_gpiochip "$chip_n"
    assert "gpio_gpiochip_isset"
    assert "test '$GPIOCHIP_N' -ge 0"
}

test_1_gpio_select_gpiochop_bad()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_select_gpiochip abc"

    gpio_select_gpiochip abc >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"

    assert_fails "gpio_gpiochip_isset"

    gpio_gpiochip_isset >/dev/null
    rc="$?"
    assert "test '$rc' -eq 1"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_2_gpio_count()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "gpio_count"
    assert "test '$(gpio_count)' -gt 0"
}

test_2_gpio_count_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_count"
    gpio_count >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_3_gpio_export()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"
    assert "gpio_export 0"

    gpio_n=$((GPIOCHIP_N + 0))

    assert "test -d ${GPIO_SYS}/gpio${gpio_n}"
}

test_3_gpio_export_bad()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert_fails "gpio_export a"
    gpio_export a >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"

    assert_fails "gpio_export -1"
    gpio_export '-1' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"
}

test_3_gpio_export_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_export 0"
    gpio_export 0 >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_4_gpio_unexport()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"
    assert "gpio_export '0'"
    assert "gpio_unexport '0'"

    gpio_n=$((GPIOCHIP_N + 0))

    assert_fails "test -d ${GPIO_SYS}/gpio${gpio_n}"
}

test_4_gpio_unexport_bad()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert_fails "gpio_unexport a"
    gpio_unexport a >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"

    assert_fails "gpio_unexport -1"
    gpio_unexport '-1' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"
}

test_4_gpio_unexport_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_unexport 0"
    gpio_unexport 0 >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_5_gpio_exported()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"
    assert "gpio_exported '0'"

    assert "gpio_unexport '0'"
    assert_fails "gpio_exported '0'"

    gpio_exported '0'
    rc="$?"
    assert "test '$rc' -eq 1"
}

test_5_gpio_exported_bad()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert_fails "gpio_exported a"
    gpio_exported a >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"

    assert_fails "gpio_exported -1"
    gpio_exported '-1' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"
}

test_5_gpio_exported_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_exported 0"
    gpio_exported 0 >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_6_gpio_unexported()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"
    assert_fails "gpio_unexported '0'"
    gpio_unexported '0'
    rc="$?"
    assert "test '$rc' -eq 1"

    assert "gpio_unexport '0'"
    assert "gpio_unexported '0'"
}

test_6_gpio_unexported_bad()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert_fails "gpio_unexported a"
    gpio_unexported a >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"

    assert_fails "gpio_unexported -1"
    gpio_unexported '-1' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 2"
}

test_6_gpio_unexported_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_unexported 0"
    gpio_unexported 0 >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_7_gpio_export_all()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"
    assert "gpio_export_all"

    count="$(gpio_count)"
    count=$((count - 1))

    for i in $(seq 0 "$count"); do
        assert "gpio_exported '${i}'"
    done
}

test_7_gpio_export_all_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_export_all"
    gpio_export_all >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_8_gpio_unexport_all()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"
    assert "gpio_unexport_all"

    count="$(gpio_count)"
    count=$((count - 1))

    for i in $(seq 0 "$count"); do
        assert "gpio_unexported '${i}'"
    done
}

test_8_gpio_unexport_all_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_unexport_all"
    gpio_export_all >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_9_gpio_get_direction()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"
    assert "gpio_get_direction '0'"
    val="$(gpio_get_direction 0)"
    assert "echo '$val' | grep -E '^(in|out)$' >/dev/null 2>&1"
    assert "gpio_unexport '0'"
}

test_9_gpio_get_direction_bad()
{
    assert_fails "gpio_get_direction '-1'"

    out=$(gpio_get_direction '-1')
    rc="$?"

    assert "test '$rc' -eq 2"
    assert "echo '$out' | grep 'not a positive integer'"
}

test_9_gpio_get_direction_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_get_direction '0'"
    gpio_get_direction '0' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_A0_gpio_direction_output_and_input()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"

    assert "gpio_direction_output '0'"
    assert "test \"$(gpio_get_direction '0')\" = \"out\""
    assert "gpio_direction_input '0'"
    assert "test \"$(gpio_get_direction '0')\" = \"in\""

    assert "gpio_unexport '0'"
}

test_A0_gpio_direction_output_and_input_bad()
{
    assert_fails "gpio_direction_output '-1'"

    out=$(gpio_direction_output '-1')
    rc="$?"

    assert "test '$rc' -eq 2"
    assert "echo '$out' | grep 'not a positive integer'"

    assert_fails "gpio_direction_input '-1'"

    out=$(gpio_direction_input '-1')
    rc="$?"

    assert "test '$rc' -eq 2"
    assert "echo '$out' | grep 'not a positive integer'"
}

test_A0_gpio_direction_output_and_input_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_direction_output '0'"
    assert_fails "gpio_direction_input '0'"

    gpio_direction_output '0' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    gpio_direction_input '0' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_A1_gpio_get_value()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"
    assert "gpio_get_value '0'"
    val="$(gpio_get_value 0)"
    assert "echo '$val' | grep -E '^[01]$' >/dev/null 2>&1"
    assert "gpio_unexport '0'"
}

test_A1_gpio_get_value_bad()
{
    assert_fails "gpio_get_value '-1'"

    out=$(gpio_get_value '-1')
    rc="$?"

    assert "test '$rc' -eq 2"
    assert "echo '$out' | grep 'not a positive integer'"
}

test_A1_gpio_get_value_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_get_value '0'"
    gpio_get_value '0' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_A2_gpio_set_value()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"

    assert "gpio_direction_output '0'"
    assert "test \"$(gpio_get_direction 0)\" = \"out\""

    assert "gpio_set_value '0' '0'"
    assert "test \"$(gpio_get_value 0)\" = \"0\""
    assert "gpio_set_value '0' '1'"
    assert "test \"$(gpio_get_value 0)\" = \"1\""

    assert "gpio_unexport '0'"
}

test_A3_gpio_set_value_bad()
{
    assert_fails "gpio_set_value '-1'"

    out=$(gpio_set_value '-1' '0')
    rc="$?"

    assert "test '$rc' -eq 2"
    assert "echo '$out' | grep 'not a positive integer'"

    assert_fails "gpio_set_value '0' '-1'"

    out=$(gpio_set_value '0' '-1')
    rc="$?"

    assert "test '$rc' -eq 2"
    assert "echo '$out' | grep 'not a positive integer'"
}

test_A3_gpio_set_value_no_gpiochip_n_set()
{
    chip_n="$GPIOCHIP_N"
    unset GPIOCHIP_N >/dev/null 2>&1

    assert_fails "gpio_set_value '0' '0'"

    gpio_set_value '0' '0' >/dev/null
    rc="$?"
    assert "test '$rc' -eq 3"

    GPIOCHIP_N="$chip_n"
    export GPIOCHIP_N
}

test_A4_gpio_set_active_low()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"

    assert "gpio_direction_input '0'"
    assert "test \"$(gpio_get_direction 0)\" = \"in\""

    assert "gpio_set_active_low '0' '0'"
    assert "test \"$(gpio_get_active_low 0)\" = \"0\""
    assert "gpio_set_active_low '0' '1'"
    assert "test \"$(gpio_get_active_low 0)\" = \"1\""

    assert "gpio_unexport '0'"
}

test_A5_gpio_get_edge()
{
    assert "gpio_select_gpiochip ${GPIOCHIP_N}"
    assert "test '$(gpio_count)' -gt 0"

    assert "gpio_export '0'"
    assert "gpio_get_edge '0'"
    val="$(gpio_get_edge 0)"
    assert "echo '$val' | grep -E '^(none|rising|falling)$' >/dev/null 2>&1"
    assert "gpio_unexport '0'"
}
