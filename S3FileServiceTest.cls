@IsTest
private class S3FileServiceTest{
    @IsTest
    static void testContentType() {
        // Test valid file types
        System.assertEquals('application/vnd.openxmlformats-officedocument.wordprocessingml.document', S3FileService.ContentType('docx'));
        System.assertEquals('application/vnd.ms-excel', S3FileService.ContentType('csv'));
        System.assertEquals('audio/wav', S3FileService.ContentType('wav'));
        System.assertEquals('video/x-ms-wmv', S3FileService.ContentType('wmv'));
        System.assertEquals('audio/mpeg', S3FileService.ContentType('mp3'));
        System.assertEquals('video/mp4', S3FileService.ContentType('mp4'));
        System.assertEquals('image/png', S3FileService.ContentType('png'));
        System.assertEquals('application/pdf', S3FileService.ContentType('pdf'));
        
        // Test invalid file type
        System.assertEquals('image/jpeg', S3FileService.ContentType('txt'));
    }
    
    @IsTest
    static void testGetDocumentUsingFileId() {
        WorkOrderSheet__c wos= new WorkOrderSheet__c(
            Status__c = 'Vizitat'
            );
        insert wos;
        // Create a test WorkOrderSheetPicture__c record
        WorkOrderSheetPicture__c testRecord = new WorkOrderSheetPicture__c(
            FileName__c = 'your_filename',
            FileExt__c = 'png',
            S3Url__c = 'URL',
            WorkOrderSheetId__c = wos.Id // object where we upload photo
        );
        insert testRecord;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new S3FileServiceMock());  
        FileData data = S3FileService.getDocumentUsingFileId(String.valueOf(testRecord.Id));
        Test.stopTest();
        
	}
}