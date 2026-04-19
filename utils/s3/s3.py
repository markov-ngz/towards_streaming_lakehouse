import logging
import os
import boto3

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S",
)
logger = logging.getLogger(__name__)


def create_client():
    """
    Instantiates and returns an S3 client using environment variables.

    Required environment variables:
        AWS_ACCESS_KEY_ID     - AWS access key ID
        AWS_SECRET_ACCESS_KEY - AWS secret access key
        AWS_REGION            - AWS region (defaults to us-east-1 if not set)
    """
    region = os.environ["AWS_REGION"]
    logger.debug("Creating S3 client in region: %s", region)
    return boto3.client(
        "s3",
        aws_access_key_id=os.environ["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"],
        region_name=region,
    )


def delete_all_objects(s3_client, bucket_name: str):
    """
    Deletes all objects (files and folders) in an S3 bucket recursively.

    Args:
        s3_client:   A boto3 S3 client instance
        bucket_name: Name of the S3 bucket to clean
    """
    logger.info("Starting deletion of all objects in bucket: %s", bucket_name)
    deleted_count = 0

    paginator = s3_client.get_paginator("list_objects_v2")

    for page in paginator.paginate(Bucket=bucket_name):
        if "Contents" not in page:
            logger.debug("Empty page encountered, no objects to delete.")
            continue

        objects_to_delete = [{"Key": obj["Key"]} for obj in page["Contents"]]
        logger.debug("Deleting batch of %d object(s).", len(objects_to_delete))

        response = s3_client.delete_objects(
            Bucket=bucket_name,
            Delete={"Objects": objects_to_delete, "Quiet": False},
        )

        if "Deleted" in response:
            deleted_count += len(response["Deleted"])
            for obj in response["Deleted"]:
                logger.info("Deleted: %s", obj["Key"])

        if "Errors" in response:
            for err in response["Errors"]:
                logger.error(
                    "Failed to delete %s: %s",
                    err["Key"],
                    err["Message"]
                )

    logger.info("Done. Total objects deleted: %d", deleted_count)
