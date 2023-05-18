# Salesforce-to-AWS-S3-integration
Upload and retrieve Files from Salesforce to AWS S3 with Put and Get requests. It works even if your bucket settings is set to private.

STEPS:
1. Create an AWS Account and create a bucket. It can be private or public, it will work anyway.
2. Create a named credential in your salesforce org, with credentials from AWS (key, secret key).
3. Create two objects in salesforce: WorkOrderSheet and WorkOrderSheetPicture
4. Create on WorkOrderSheetPicture following fields: (1. Lookup to WorkOrderSheet(link to object where we will upload file, parent obj), FileExt (here will be the extension of your uploaded file), FileName(name of your file), S3Url(url from AWS).
5. Go on WorkOrderSheet object, 'Edit Page' add 'fileupload' LWC to Record Page.
6. go to WorkOrderSheetPicture create an quick action that will call LWC 'S3FileDownload'

You can go on WorkOrderSheet, upload a photo, and then go on WorkOrderSheetPicture and press on action described at point 6 and your image will start downloading.
