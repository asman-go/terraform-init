import boto3
import os
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


if __name__ == '__main__':
    config = Config()
    dynamodb = DocumentAPI(config)
    dynamodb.create_table(
        config.TABLE_NAME,
        [{'AttributeName': 'LockID', 'KeyType': 'HASH'}],
        [{'AttributeName': 'LockID', 'AttributeType': 'S'}]
    )
    os.environ['AWS_ACCESS_KEY_ID'] = '***'
    os.environ['AWS_SECRET_ACCESS_KEY'] = '***'
