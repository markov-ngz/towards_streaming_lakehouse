import argparse
import logging
import s3

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S",
)
logger = logging.getLogger(__name__)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Recursively delete all objects in an S3 bucket."
        )
    parser.add_argument(
        "--bucket",
        required=True,
        help="Name of the S3 bucket to clean",
        )
    parser.add_argument(
        "--log-level",
        default="INFO",
        choices=["DEBUG", "INFO", "WARNING", "ERROR"],
        help="Set the logging verbosity (default: INFO)",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    logging.getLogger().setLevel(args.log_level)

    s3_client = s3.create_client()
    s3.delete_all_objects(s3_client, args.bucket)
