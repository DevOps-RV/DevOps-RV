import json
import boto3
from botocore.exceptions import ClientError
import logging
import sys
from concurrent.futures import ThreadPoolExecutor

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

dynamodb = boto3.resource('dynamodb')

def get_file_name():
    if len(sys.argv) < 2:
        logger.error("Usage: %s <file_name.json>", sys.argv[0])
        sys.exit(1)
    return sys.argv[1]

def insert_item(table_name, item):
    try:
        table = dynamodb.Table(table_name)
        table.put_item(Item=item)
        logger.info("Inserted item into %s: %s", table_name, item)
    except ClientError as e:
        logger.error("Failed to insert item into %s: %s", table_name, e)

def process_table(table_name, items):
    try:
        table = dynamodb.Table(table_name)
        table.load()  # Check if table exists
        logger.info("Processing table: %s", table_name)
        with ThreadPoolExecutor() as executor:
            executor.map(lambda item: insert_item(table_name, item), items)
    except ClientError:
        logger.warning("Table %s does not exist. Skipping.", table_name)

def main():
    file_name = get_file_name()
    try:
        with open(file_name) as f:
            data = json.load(f)
            for table_name, items in data.items():
                process_table(table_name, items)
    except FileNotFoundError:
        logger.error("File %s not found.", file_name)
        sys.exit(1)

if __name__ == "__main__":
    main()