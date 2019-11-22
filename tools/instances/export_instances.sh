#!/bin/bash

usage() {
   cat << EOT
Usage: $0 [option] command
Options:
   --profile        profile     the aws cli profile to use
   --shard-id       shard id    the shard id to use for filtering instances
   --format         format      the export format. Available formats are json, text and table (defaults to json)
   --ip-addresses               export ip addresses to a separate file per shard - requires that jq is installed in order to parse JSON
   --help                       print this help section
EOT
}

while [ $# -gt 0 ]
do
  case $1 in
  --profile) profile="$2" ; shift;;
  --shard-id) shard_id="$2" ; shift;;
  --format) format="$2" ; shift;;
  --ip-addresses) ip_address_export=true;;
  -h|--help) usage; exit 1;;
  (--) shift; break;;
  (-*) usage; exit 1;;
  (*) break;;
  esac
  shift
done

declare -a ip_addresses

set_variables() {
  if [ -z "$profile" ]; then
    profile="seb_mfa_pangaea"
  fi

  if [ -z "$format" ]; then
    format="json"
  fi

  if [ ! -z "$shard_id" ]; then
    filters="Name=tag:hmy:Shard,Values=${shard_id}"
  fi
  
  if [ "$ip_address_export" = true ]; then
    check_jq_dependency
    
    if [ -z "$shard_id" ]; then
      echo "You need to specify a Shard ID using --shard-id when using the --ip-addresses argument!"
      exit 1
    fi
  fi

  case $format in
  json)
    extension=json
    ;;
  text|table)
    extension=txt
    ;;
  *)
    ;;
  esac
}

check_aws_cli_dependency() {
  if ! command -v aws >/dev/null 2>&1; then
    echo "AWS CLI is required to run this script."
    echo "Please install it using https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html or a similar installation procedure."
    exit 1
  fi
}

check_jq_dependency() {
  if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required to run this script. Please install it:"
    echo "Linux: sudo apt-get install jq"
    echo "Mac: brew install jq"
    exit 1
  fi
}

export_per_region() {
  mkdir -p export/ec2

  for region in `aws ec2 describe-regions --output text --profile ${profile} | cut -f4`
  do
    echo -e "\nListing Instances in region:'$region'..."
    
    instance_data=$(aws ec2 describe-instances --region ${region} --output ${format} --profile ${profile} --filters Name=tag:Name,Values='Pangaea Node' ${filters})

    if [[ -z $instance_data ]] || [[ $instance_data =~ "\"Reservations\": []" ]]; then
      echo "Didn't find any instance data for region ${region}. Proceeding..."
    else
      
      echo "Found instance data for region ${region} - exporting the data to export/ec2/${region}.${extension}!"
      rm -rf export/ec2/${region}.${extension}
      touch export/ec2/${region}.${extension}

      # Prettify the JSON output if Python is available on the system
      if [ "$format" = "json" ] && command -v python >/dev/null 2>&1; then
        echo $instance_data | python -m json.tool > export/ec2/${region}.${extension}
      else
        echo $instance_data > export/ec2/${region}.${extension}
      fi
      
      if [ "$ip_address_export" = true ]; then
        parse_ip_addresses "${instance_data}"
      fi
      
    fi
  done
}

parse_ip_addresses() {
  local addresses=$(echo "${1}" | jq ".Reservations[].Instances[].PublicIpAddress" | tr -d '"')
  
  if (( ${#addresses[@]} )); then
    for address in "${addresses[@]}"; do
    	ip_addresses+=("${address}")
    done
  fi
}

export_ip_addresses() {
  if [ "$ip_address_export" = true ] && (( ${#ip_addresses[@]} )); then
    touch export/ec2/shard-${shard_id}-ip-addresses.txt
    printf "%s\n" "${ip_addresses[@]}" > export/ec2/shard-${shard_id}-ip-addresses.txt
  fi
}

run() {
  check_aws_cli_dependency
  set_variables
  export_per_region
  export_ip_addresses
}

run