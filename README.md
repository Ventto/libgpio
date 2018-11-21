libgpio
=======

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](./LICENSE)
[![Powered by Bash)](https://img.shields.io/badge/powered_by-Bash-brightgreen.svg)](https://www.gnu.org/software/bash/)

*"libgpio is a Bash library to manage GPIO chips through
a sysfs user interface"*

For futher reading, take a look at [Documentation/gpio/sysfs.txt](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/gpio/sysfs.txt?h=v4.4.164) (v4.4).

# Compatibility

- [x] *libgpio* works for Linux kernels from v4.1.x to v4.7.x.
- [x] The kernel must be compiled with the `CONFIG_GPIOLIB`
      and `CONFIG_GPIO_SYSFS` option

# Install

```bash
$ wget https://raw.githubusercontent.com/ventto/libgpio/master/libgpio.sh
$ . libgpio.sh
```

# Usage

* In scripts:

```
#!/bin/bash

. libgpio.sh

gpio_select_gpiochip 224   # target /sys/class/gpio/gpiochip224
gpio_count
gpio_export '0'
gpio_set_value '0' '1'
```

# Functions

```
    Name                    |    Output
____________________________|________________________________________
gpio_select_gpiochip()      | -
gpio_gpiochip_isset()       | -
gpio_count()                | Positive Integer
gpio_export()               | -
gpio_unexport()             | -
gpio_exported()             | -
gpio_unexported()           | -
gpio_export_all()           | -
gpio_unexport_all()         | -
gpio_get_edge()             | String: 'none', 'rising' or 'falling'
gpio_get_active_low()       | Positive Integer: 0 or 1
gpio_set_active_low()       | -
gpio_get_direction()        | String: 'in' or 'out'
gpio_direction_input()      | -
gpio_direction_output()     | -
gpio_get_value()            | Positive Integer: 0 or 1
gpio_set_value()            | -
```

