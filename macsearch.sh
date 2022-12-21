#!/bin/bash
# Search mac address BDCOM by orfeybg qweasd@abv.bg


# Prompt the user for the mac address to search for
echo -n "Enter the mac address to search for: "
read mac

# Convert the mac address to the desired format

if [[ ${mac} == ??:??:??:??:??:?? ]]; then
        mac=$(sed 's/\://;s/\:/./;s/\://;s/\:/./;s/\://' <<< ${mac})
elif [[ ${mac} == ????.????.???? ]]; then
        mac=$(sed 's/\.//g;s/\(..\)/\1:/g;s/:$//' <<< ${mac})
fi

# Function to search for mac address in a device with a given IP address
search_mac() {
  local ip=$1

  # Create the output file if it does not exist
  touch output.txt

  # Send commands to the device via telnet
  (
  sleep 2
  echo "admin"
  sleep 2
  echo "admin"
  sleep 2
  echo "enable"
  sleep 2
  echo "terminal length 0"
  sleep 2
  echo "show mac address-table"
  sleep 20
  echo "quit"
  ) | telnet $ip > output.txt

  # Check if the mac address was found in the output
  if grep -qi $mac output.txt; then
    # Output the line in which the mac address was found
    grep -i $mac output.txt
    # Print a message indicating that the mac address was found
    echo "Found mac address $mac in device with IP $ip"
    return 0
  else
    return 1
  fi
}
# Search for mac address in each device
if search_mac 192.168.0.1; then
  exit 0
elif search_mac 1192.168.0.2; then
  exit 0
elif search_mac 192.168.0.3; then
  exit 0
elif search_mac 192.168.0.4; then
  exit 0
else
  echo "Mac address not found in any of the devices"
  exit 1
fi
