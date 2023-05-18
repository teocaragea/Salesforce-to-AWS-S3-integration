@isTest
global class S3FileServiceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'jpg');
        response.setBody('Sample file content');
        response.setStatusCode(200);
        return response; 
    }
}