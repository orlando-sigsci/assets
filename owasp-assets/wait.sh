#!/bin/bash

show_progress()
{
  printf "\033[0;32m\n\n"
  echo -n "Starting"
  printf "\n\nSetting up Application Security Fundamentals - Course\n\nOWASP Injection Attacks - Scenario\n\nPlease wait...\n\n"; 
  local -r pid="${1}"
  local -r delay='0.75'
  local spinstr='\|/-'
  local temp

  echo -n "Configuring Fastly - Signal Sciences"
  while true; do 
    sudo grep -i "done" /opt/.sigscifinished &> /dev/null
    if [[ "$?" -ne 0 ]]; then     
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Configured"

  echo -n "Configuring Vulnerable Application"
  while true; do 
    sudo grep -i "done" /opt/.appfinished &> /dev/null
    if [[ "$?" -ne 0 ]]; then     
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Configured"

  while true; do 
    sudo grep -i "done" /opt/.backgroundfinished &> /dev/null
    if [[ "$?" -ne 0 ]]; then     
      temp="${spinstr#?}"
      printf " [%c]  " "${spinstr}"
      spinstr=${temp}${spinstr%"${temp}"}
      sleep "${delay}"
      printf "\b\b\b\b\b\b"
    else
      break
    fi
  done
  printf "    \b\b\b\b"
  echo ""
  echo "Completed"
  sleep 3
  printf "\[\033[0m\]"
  printf "\033c"
}

show_progress