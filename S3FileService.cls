public class S3FileService {
   
    public static string ContentType(string fileType)
    {
        switch on fileType.toLowerCase()
        {
            when 'docx'
            {
                return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
            }
            when 'csv'
            {
                return 'application/vnd.ms-excel';
            }
            when 'wav'
            {
                return 'audio/wav';
            }
            when 'wmv'
            {
                return 'video/x-ms-wmv';
            }
            when 'mp3'
            {
                return 'audio/mpeg';
            }
            when 'mp4'
            {
                return 'video/mp4';
            }
            when 'png'
            {
                return 'image/png';
                
            }
            when 'pdf'
            {
                return 'application/pdf';
                
            }
            when else {
                return 'image/jpeg';
            }
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static FileData getDocumentUsingFileId(string recordId)
    {
        List<WorkOrderSheetPicture__c> files=[SELECT  Id, S3Url__c, FileExt__c, FileName__c FROM WorkOrderSheetPicture__c 
                                  where Id=:recordId];
        WorkOrderSheetPicture__c file=files[0];/// WorkOrderSheetPicture__c  is an object that store photo, related to the object where we upload photo
        try
        {
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint('callout:AWSSignature/'+ file.FileName__c + 
					'.' +
					file.FileExt__c.toLowerCase()); //AWSSignature is named credential
            Http http = new Http();
            HTTPResponse res = http.send(req);
            system.debug('res.getStatusCode():'+res.getBody());
            if (res.getStatusCode() == 200 || res.getStatusCode()==201) 
            {
                FileData data=new FileData();
                data.Content= EncodingUtil.Base64Encode(res.getBodyAsBlob());
                data.ContentType=ContentType(file.FileExt__c);
                data.FileName=file.FileName__c;
                system.debug(data);
                return data;
            }
        }
        catch(Exception ex)
        {
            throw new HandledException(ex);
        }
        return null;
    }
}