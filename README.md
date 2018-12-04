libgpio
=======

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](./LICENSE)
[![Powered by Bash)](https://img.shields.io/badge/powered_by-Bash-brightgreen.svg)](https://www.gnu.org/software/bash/)

*"libgpio is a Bash library to manage GPIO chips through
the sysfs user interface"*

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

## Manually

```bash
$ cd /sys/class/gpio
$ ls -l
gpiochip224/
[... truncated output...]

$ cat gpiochip224/ngpio   # print 32, so 32 GPIOS provided by the gpiochip
$ echo 230 > export       # export the GPIO n°6: 224 + 6
                          # make the GPIO n°6 ready to use
$ echo out > gpio230/direction   # set the direction
$ echo 1 > gpio230/value         # set the GPIO n°6 high
$ echo 230 > unexport            # release the GPIO
```

## With libgpio

```bash
#!/bin/bash

. libgpio.sh

gpio_select_gpiochip 224   # select `/sys/class/gpio/gpiochip224`
gpio_count                 # print 32, so 32 GPIOs provided by the gpiochip
gpio_export '6'            # make the GPIO n°6 ready to use
gpio_direction_output '6'  # set the direction
gpio_set_value '6' '1'     # set the GPIO n°6 high
gpio_unexport '6'          # release the GPIO
```

# Functions

```
    Name                |    Output                             |   Return
________________________|_______________________________________|_____________
gpio_select_gpiochip()  | -                                     |   0,1,2
gpio_gpiochip_isset()   | -                                     |   0,1
gpio_count()            | unsigned char: [0;254]                |   0,1,3
gpio_export()           | -                                     |   0,1,2,3
gpio_unexport()         | -                                     |   0,1,2,3
gpio_exported()         | -                                     |   0,1,2,3
gpio_unexported()       | -                                     |   0,1,2,3
gpio_export_all()       | -                                     |   0,1,3
gpio_unexport_all()     | -                                     |   0,1,3
gpio_get_edge()         | "none", "rising" or "falling"         |   0,1,2,3
gpio_get_active_low()   | "0" (active_low) or "1" (active_high) |   0,1,2,3
gpio_set_active_low()   | -                                     |   0,1,2,3
gpio_get_direction()    | "in" (input) or "out" (output)        |   0,1,2,3
gpio_direction_input()  | -                                     |   0,1,2,3
gpio_direction_output() | -                                     |   0,1,2,3
gpio_get_value()        | "0" (low) or "1" (high)               |   0,1,2,3
gpio_set_value()        | -                                     |   0,1,2,3
```

* `return 0`: success
* `return 1`: fail
* `return 2`: bad args
* `return 3`: `GPIOCHIP_N` variable not set (c.f: use `gpio_select_gpiochip()`)
