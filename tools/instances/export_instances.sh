#!/bin/bash

usage() {
   cat << EOT
Usage: $0 [option] command
Options:
   --profile    profile    the aws cli profile to use
   --shard-id   shard id   the shard id to use for filtering instances
   --format     format     the export format. Available formats are json, text and table (defaults to json)
   --help                  print this help
EOT
}

while [ $# -gt 0 ]
do
  case $1 in
  --profile) profile="$2" ; shift;;
  --shard-id) shard_id="$2" ; shift;;
  --format) format="$2" ; shift;;
  -h|--help) usage; exit 1;;
  (--) shift; break;;
  (-*) usage; exit 1;;
  (*) break;;
  esac
  shift
done

if [ -z "$profile" ]; then
  profile="seb_mfa_pangaea"
fi

if [ -z "$format" ]; then
  format="json"
fi

if [ ! -z "$shard_id" ]; then
  filters="--filters Name=tag:hmy:Shard,Values=2"
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

mkdir -p export/ec2

for region in `aws ec2 describe-regions --output text --profile ${profile} | cut -f4`
do
  echo -e "\nListing Instances in region:'$region'..."
  
  instance_data=$(aws ec2 describe-instances --region ${region} ${filters} --output ${format} --profile ${profile})

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
  fi
done
