import asyncio
import contextlib
import json
import sys

import aioboto3


def load_aws_config():
    """Load the AWS configuration."""
    with open('../experiment-deploy/configs/aws.json') as f:
        return json.load(f)


async def main():
    async with contextlib.AsyncExitStack() as stack:
        aws_config = load_aws_config()
        region_names = [region['ext-name'] for region in aws_config['regions']]
        sess = aioboto3.Session()
        ec2_clients = {
                region_name: await stack.enter_async_context(
                    sess.client('ec2', region_name=region_name),
                )
                for region_name in region_names
        }
        all_instances = dict(zip(region_names, asyncio.gather((
            ec2_instances(
                ec2_clients['us-west-2'], Filters=[
                    dict(Name='tag:Name', Values=['Pangaea Node'])
                ],
            )
            for region_name in region_names
        ))))
        from pprint import pprint
        pprint(all_instances)


async def ec2_describe_instances(ec2, *poargs, **kwargs):
    max_results = 1000
    next_token = None
    while True:
        args = {}
        args.update(kwargs)
        args.update(MaxResults=max_results)
        if next_token is not None:
            args.update(NextToken=next_token)
        result = await ec2.describe_instances(*poargs, **kwargs)
        for reservation in result['Reservations']:
            for instance in reservation['Instances']:
                try:
                    tags = instance['Tags']
                except KeyError:
                    pass
                else:
                    instance['Tags'] = {
                            tag['Key']: tag['Value']
                            for tag in tags
                    }
                yield instance
        try:
            next_token = result['NextToken']
        except KeyError:
            return


async def ec2_instances(ec2, *poargs, **kwargs):
    return {
            instance.pop('InstanceId'): instance
            async for instance in ec2_describe_instances(ec2, *poargs, **kwargs)
    }


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    sys.exit(loop.run_until_complete(main()) or 0)
