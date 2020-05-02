# shellcheck shell=bash
# no need for shebang - this file is loaded from charts.d.plugin
# SPDX-License-Identifier: GPL-3.0-or-later

# netdata
# real-time performance and health monitoring, done right!
# (C) 2016 Costa Tsaousis <costa@tsaousis.gr>
#

# if this chart is called X.chart.sh, then all functions and global variables
# must start with X_

# _update_every is a special variable - it holds the number of seconds
# between the calls of the _update() function
freq_update_every=

# the priority is used to sort the charts on the dashboard
# 1 = the first chart
freq_priority=1

# global variables to store our collected data
# remember: they need to start with the module name example_
freq_cpu=800
freq_cpu_file=/sys/devices/system/cpu/cpu[04]/cpufreq/cpuinfo_cur_freq

freq_get() {
  # do all the work to collect / calculate the values
  # for each dimension
  #
  # Remember:
  # 1. KEEP IT SIMPLE AND SHORT
  # 2. AVOID FORKS (avoid piping commands)
  # 3. AVOID CALLING TOO MANY EXTERNAL PROGRAMS
  # 4. USE LOCAL VARIABLES (global variables may overlap with other modules)

  if [ -f "$freq_cpu_file" ]; then
    freq_cpu=$(cat $freq_cpu_file)
  else
    return 1
  fi

  # this should return:
  #  - 0 to send the data to netdata
  #  - 1 to report a failure to collect the data

  return 0
}

# _check is called once, to find out if this chart should be enabled or not
freq_check() {
  # this should return:
  #  - 0 to enable the chart
  #  - 1 to disable the chart

  # check something

  # check that we can collect data
  freq_get || return 1

  return 0
}

# _create is called once, to create the charts
freq_create() {
  # create the chart with 3 dimensions
  cat << EOF
CHART CPU.Frequency 'Frequency' "CPU Frequency" "MHz" "Frequency" "" line $freq_priority $freq_update_every
DIMENSION CPU '' absolute 1 1000
EOF

  return 0
}

# _update is called continuously, to collect the values
freq_update() {
  # the first argument to this function is the microseconds since last update
  # pass this parameter to the BEGIN statement (see bellow).

  freq_get || return 1

  # write the result of the work.
  cat << VALUESEOF
BEGIN CPU.Frequency $1
SET CPU = $freq_cpu
END
VALUESEOF

  return 0
}