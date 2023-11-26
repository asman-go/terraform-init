import argparse
import boto3
import pydantic_settings


class Config(pydantic_settings.BaseSettings):
    TABLE_NAME: str = "lock"
    DOCUMENT_API_ENDPOINT: str = "https://example.com/path/to/your/db"
    REGION_NAME: str = "ru-central1"
    AWS_ACCESS_KEY_ID: str = "<key-id>"
    AWS_SECRET_ACCESS_KEY: str = "<secret-access-key>"


class DocumentAPI(object):
    def __init__(self, config: Config) -> None:
        self._client = boto3.client(
            'dynamodb',
            endpoint_url=config.DOCUMENT_API_ENDPOINT,
            region_name=config.REGION_NAME,
            aws_access_key_id=config.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=config.AWS_SECRET_ACCESS_KEY,
        )

        self._resource = boto3.resource(
            'dynamodb',
            endpoint_url=config.DOCUMENT_API_ENDPOINT,
            region_name=config.REGION_NAME,
            aws_access_key_id=config.AWS_ACCESS_KEY_ID,
            aws_secret_access_key=config.AWS_SECRET_ACCESS_KEY
        )
    
    def create_table(self, table_name: str, key_schema, attribute_definitions):
        table = self._resource.create_table(
            TableName=table_name,
            KeySchema=key_schema,
            AttributeDefinitions=attribute_definitions,
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5
            }
        )
        table.wait_until_exists()

        return table


def arg_parser():
    parser = argparse.ArgumentParser(description='Terraform infrastructure init')

    parser.add_argument('-a', '--access_key', help='AWS Access Key', required=True)
    parser.add_argument('-s', '--secret_key', help='AWS Secret Key', required=True)

    args = parser.parse_args()

    return args


if __name__ == '__main__':
    args = arg_parser()
    config = Config(AWS_ACCESS_KEY_ID=args.access_key, AWS_SECRET_ACCESS_KEY=args.secret_key)

    dynamodb = DocumentAPI(config)
    dynamodb.create_table(
        config.TABLE_NAME,
        [{'AttributeName': 'LockID', 'KeyType': 'HASH'}],
        [{'AttributeName': 'LockID', 'AttributeType': 'S'}]
    )
