import { LightningElement, track, api } from 'lwc';
import toS3 from '@salesforce/apex/FileUploadCtrl.toS3';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Fileupload extends LightningElement {

    @api recordId;
    @track success;
    @track error;
    
    get acceptedFormats() {
        return ['.jpeg','.png','.jpg'];
    }
 
    handleUploadFinished(event) {
        
        let contentVersionId  = event.detail.files[0].contentVersionId;

        const evt = new ShowToastEvent({
            title: 'SUCCES',
            message: 'Fotografia a fost incarcata cu succes in AWS-S3',
            variant: 'success',
        });

        toS3({contentVersionId:contentVersionId, recordId:this.recordId})
        .then(result=>{
            this.success = result;
            this.error = undefined;
            dispatchEvent(evt);
        }).catch(error=>{
            this.success = undefined;
            this.error = error;
        })
    }
 
}