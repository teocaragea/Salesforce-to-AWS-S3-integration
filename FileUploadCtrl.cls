public with sharing class FileUploadCtrl {

    @AuraEnabled(cacheable=false)
    public static Boolean toS3(String contentVersionId, String recordId){

        Boolean success = false;

		List<WorkOrderSheetPicture__c> workOrderSheetPictureList = new List<WorkOrderSheetPicture__c>();
		List<Id> toDeleteIds = new List<Id>();

		NamedCredential s3NamedCredential = [SELECT Id, Endpoint FROM NamedCredential WHERE DeveloperName = 'AWSSignature'];


        for (ContentVersion cvItem : [
                                    SELECT Id, VersionData, FileExtension, ContentDocumentId 
                                    FROM ContentVersion 
                                    WHERE Id = :contentVersionId
                                    ]){
			try {
                String fileName = Datetime.now().format('yyyyMMdd') + '-' + recordId;
                HttpRequest req = new HttpRequest();
				req.setMethod('PUT');
				req.setEndpoint(
					'callout:AWSSignature' +
					'/' +
                    fileName + 
					'.' +
					cvItem.FileExtension.toLowerCase()
				);
				
                req.setBodyAsBlob(cvItem.VersionData);
				

				Http http = new Http();
				HTTPResponse res = http.send(req);
				if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
					System.debug('+++ Status 200');

					WorkOrderSheetPicture__c workOrderSheetPicture = new WorkOrderSheetPicture__c(
					WorkOrderSheetId__c = recordId,
					FileName__c = fileName,
					FileExt__c = cvItem.FileExtension.toLowerCase(),
					S3Url__c = s3NamedCredential.Endpoint + fileName + '.' + cvItem.FileExtension.toLowerCase()
					);
					workOrderSheetPictureList.add(workOrderSheetPicture);
					
                    toDeleteIds.add(cvItem.ContentDocumentId);
					success = true;
				}
			} catch (Exception ex) {
				throw new HandledException(ex);
			}
		}
		Database.insert(workOrderSheetPictureList);
        Database.delete(toDeleteIds);
        Database.emptyRecycleBin(toDeleteIds);
		return success;
    }
}