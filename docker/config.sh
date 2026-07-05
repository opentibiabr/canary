#!/bin/bash

# ./config.sh
# ./config.sh maxPlayers 88
# ./config.sh maxPlayers 88 serverName Teste maxItem 5 --file other_name.lua --env .env

# Replace values in .lua file
substitute_lua_variable() {
  variable_name="$1"
  new_value="$2"
  if [[ "$new_value" == "true" || "$new_value" == "false" ]]; then
    sed "s|$variable_name =.*|$variable_name = $new_value|" "$lua_file" > "$lua_file.tmp"
  elif [[ $( echo "$new_value" | grep -E "^[0-9]+$") ]]; then
    sed "s|$variable_name =.*|$variable_name = $new_value|" "$lua_file" > "$lua_file.tmp"
  else
    sed "s|$variable_name =.*|$variable_name = \"$new_value\"|" "$lua_file" > "$lua_file.tmp"
  fi

  mv "$lua_file.tmp" "$lua_file" 2>&1
}

# Get a named argument
get_named_arg() {
  arg_name="$1"
  shift
  while [[ $# -gt 0 ]]; do
    if [[ $1 == "$arg_name" && $# -gt 1 ]]; then
      echo "$2"
      return
    fi
    shift
  done
}

lua_file=$( get_named_arg "--file" "$@")
env_file=$( get_named_arg "--env" "$@")

if [ -z "$lua_file" ]; then
  lua_file="config.lua"
fi
if [ -z "$env_file" ]; then
  env_file=".env"
fi

verify_file() {
	if [ ! -f "$1" ]; then
		echo "$2 not found"
		echo "path: $1"
		exit 1
	fi
}

verify_file "$env_file" "env"
verify_file "$lua_file" "lua"

# Reads the env file
while IFS='=' read -r key value; do
  if [[ "$key" != "#"* && "$key" != "" ]]; then
    case $key in
      CANARY_DB_HOST)
        substitute_lua_variable "mysqlHost" "$value"
        ;;
      CANARY_DB_NAME)
        substitute_lua_variable "mysqlDatabase" "$value"
        ;;
      CANARY_DB_USER)
        substitute_lua_variable "mysqlUser" "$value"
        ;;
      CANARY_DB_PASSWORD)
        substitute_lua_variable "mysqlPass" "$value"
        ;;
      CANARY_DB_PORT)
        substitute_lua_variable "mysqlPort" "$value"
        ;;
      CANARY_SERVER_NAME)
        substitute_lua_variable "serverName" "$value"
        ;;
      CANARY_SERVER_IP)
        substitute_lua_variable "ip" "$value"
        ;;
      CANARY_LOGIN_PORT)
        substitute_lua_variable "loginProtocolPort" "$value"
        ;;
      CANARY_GAME_PORT)
        substitute_lua_variable "gameProtocolPort" "$value"
        ;;
      CANARY_LEGACY_1100_GAME_PORT)
        substitute_lua_variable "legacy1100GameProtocolPort" "$value"
        ;;
      CANARY_LEGACY_860_GAME_PORT)
        substitute_lua_variable "legacy860GameProtocolPort" "$value"
        ;;
      CANARY_STATUS_PORT)
        substitute_lua_variable "statusProtocolPort" "$value"
        ;;
      CANARY_STATUS_TIMEOUT)
        substitute_lua_variable "statusTimeout" "$value"
        ;;
      CANARY_DATA_PACK)
        substitute_lua_variable "dataPackDirectory" "$value"
        ;;
      CANARY_MAP_URL)
        substitute_lua_variable "mapDownloadUrl" "$value"
        ;;
      MYSQL_HOST)
        substitute_lua_variable "mysqlHost" "$value"
        ;;
      MYSQL_DBNAME)
        substitute_lua_variable "mysqlDatabase" "$value"
        ;;
      MYSQL_USER)
        substitute_lua_variable "mysqlUser" "$value"
        ;;
      MYSQL_PASS)
        substitute_lua_variable "mysqlPass" "$value"
        ;;
      SERVER_NAME)
        substitute_lua_variable "serverName" "$value"
        ;;
      SERVER_IP)
        substitute_lua_variable "ip" "$value"
        ;;
      SERVER_PORT)
        substitute_lua_variable "gameProtocolPort" "$value"
        ;;
			*)
        substitute_lua_variable "$key" "$value"
        ;;
    esac
  fi
done < "$env_file"

# # Substitutes other variables provided as command line arguments
args=("$@")
for ((i=0; i<${#args[@]}; i+=2)); do
  if [[ "${args[i]}" == "--file" || "${args[i]}" == "--env" ]]; then
    continue
  fi

  variable_name="${args[i]}"
  new_value="${args[i+1]}"
  substitute_lua_variable "$variable_name" "$new_value"
done
