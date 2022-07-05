import os
import json
import boto3
from PIL import Image

def lambda_handler(event, context):
    """
    Lambda Function for Sending Data event
    Args:
        event ([type]): Json event
        context ([type]): [description]
    """
s3 = boto3.resource('s3')
image = Image.open('image_file.jpeg')

# next 3 lines strip exif
data = list(image.getdata())
image_without_exif = Image.new(image.mode, image.size)
image_without_exif.putdata(data)

im = image_without_exif.save('image_file_without_exif.jpeg')
source = im.jpeg

s3.meta.client.copy(source, 'bucketb', 'otherkey')