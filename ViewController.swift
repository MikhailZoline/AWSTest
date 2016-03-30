//
//  ViewController.swift
//  AWSTest
//
//  This project contains an example of usage of
//  downloading/uploading of files from S3 AWS cloud.
//  The tests are done for the download and upload operations
//  in testDownload and tstUpload functions.
//  It is also possible to attach the blocks of code to monitor
//  the progress of the operation or to cancel or suspend it,
//  pls see testDownloadWithProgress and testUploadWithProgress.
//
//  Created by Mikhail Zoline on 3/21/16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myProgressView: UIProgressView!
    
    var currentRequest: AWSRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     *
     * Functional testing of MZAWSHandler::downloadFile function in order
     * to download a file for AWS S3 cloud using Amazon S3 TransferManager Handler
     *
     */
    
    @IBAction func testDownload(sender: UIButton) {
        // Call of the uploadFile function
        MZAWSHandler .downloadFile(awsObjectKey: "SMEGLY3.JPG", awsBucket: S3BucketName) { (filePath, error) in
            
            // This code is called when the download is finished
            // If the download task. error is not NULL, then do the error handling
            if error != nil{
                
                print(error?.description)
                
            }
                // else if the download task is finished successfully
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let data = NSData(contentsOfURL: filePath)
                    
                    self.myImageView.image = UIImage(data: data!)
                    
                    print("Download Complete.")
                })
            }
            
        }
        
    }
    
    
    /**
     *
     * Functional testing of MZAWSHandler::downloadFile function in order
     * to upload a file from AWS S3 cloud using Amazon S3 TransferManager Handler
     *
     */
    
    @IBAction func tstUpload(sender: UIButton) {
        
        // Construct the NSURL for the resource location.
        let uploadingFilePath =  NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Paul", ofType: "mp4")!)
        
        // Call of the uploadFile function
        MZAWSHandler .uploadFile(fromLocalFile: uploadingFilePath, awsObjectKey: "TEST.MP4", awsBucket: S3BucketName) { (error) in
            
            // This code is called when the upload is finished
            // If the upload task. error is not NULL, then do the error handling
            if error != nil{
                
                print(error?.description)
            }
                // else if the upload task is finished successfully
            else{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("Upload Complete.")
                    
                })
            }
        }
        
    }
    
    
    /**
     *
     * Functional testing of function MZAWSHandler::constructDownloadRequest to construct AWS Request
     * AWSRequest may be useful to monitor progress of the operation or to cancel or suspend
     * In this particular case it used to monitor the progress of the operation
     *
     */
    
    @IBAction func testDownloadWithProgress(sender: AnyObject) {
        
        // Construct the download request
        currentRequest = MZAWSHandler .constructDownloadRequest(awsObjectKey: "SMEGLY3.JPG", awsBucket: S3BucketName)
        
        // Set up the AWSNetworkingUploadProgressBlock to see the Progress
        currentRequest.downloadProgress = { [unowned self](bytesSent:Int64, totalBytesSent:Int64,totalBytesExpectedToSend:Int64) in
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                
                let progress : CGFloat = CGFloat(totalBytesSent) / CGFloat(totalBytesExpectedToSend)
                
                // Show current progress in the progress bar
                if ( progress < 1.0 ) {
                    
                    self.myProgressView.setProgress(Float((CGFloat(totalBytesSent) / CGFloat(totalBytesExpectedToSend))), animated: true)
                    
                }
            })
        }
        
        // Continue with the download setup
        // Create a TransferManager client
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        // Upload the file
        transferManager.download(currentRequest as! AWSS3TransferManagerDownloadRequest).continueWithBlock { (task) -> AnyObject? in
            
            // This code is called when the download is finished
            // If the upload task. error is not NULL, then do the error handling
            if task.error != nil{
                
                print(task.error?.description)
            }
                // else if the download task is finished successfully
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let data = NSData(contentsOfURL: NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("SMEGLY3.JPG"))
                    
                    self.myImageView.image = UIImage(data: data!)
                    
                    print("Upload Complete.")
                })
            }
            // Retun nil, because AWS::continueWithBlock expect to be concatenated with a task to continue with
            return nil
        }
        
    }
    
    
    /**
     *
     * Functional testing of function MZAWSHandler::constructUploadRequest to construct AWS Request
     * AWSRequest may be useful to monitor progress of the operation or to cancel or suspend
     * In this particular case it used to monitor the progress of the operation
     *
     */
    
    @IBAction func testUploadWithProgress(sender: UIButton) {
        
        // Construct the NSURL for local resource location
        let uploadingFilePath =  NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Paul", ofType: "mp4")!)
        
        // Construct the upload request
        currentRequest = MZAWSHandler.constructUploadRequest(fromLocalFile: uploadingFilePath, awsObjectKey: "TEST_PAUL.MP4", awsBucket: S3BucketName)
        
        // Set up the AWSNetworkingUploadProgressBlock to see the Progress
        currentRequest.uploadProgress = { [unowned self](bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                
                let progress : CGFloat = CGFloat(totalBytesSent) / CGFloat(totalBytesExpectedToSend)
                
                // Show current progress in the progress bar
                if ( progress < 1.0 ) {
                    
                    self.myProgressView.setProgress(Float((CGFloat(totalBytesSent) / CGFloat(totalBytesExpectedToSend))), animated: true)
                }
            })
        }
        
        // Continue with the upload setup
        // Create a TransferManager client
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        // Upload the file
        transferManager.upload(currentRequest as! AWSS3TransferManagerUploadRequest).continueWithBlock { (task) -> AnyObject? in
            
            // This code is called when the upload is finished
            // If the upload task. error is not NULL, then do the error handling
            if task.error != nil{
                
                print(task.error?.description)
            }
                
                // else if the upload task is finished successfully
            else{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("Upload Complete.")
                })
            }
            
            // Retun nil, because AWS::continueWithBlock expect to be concatenated with a task to continue with
            return nil
        }
        currentRequest = nil
        
    }
    

    @IBAction func cancelCurrentOperation(sender: AnyObject) {
        
        if currentRequest != nil{
            
            currentRequest.cancel()
            
            print("Operation Cancelled")
            
            currentRequest = nil
            
            self.myProgressView.setProgress(0, animated: true)
        }
        
    }
    
    
    @IBAction func resumeCurrentOperation(sender: AnyObject) {
        
        if currentRequest != nil{

//            AWSS3TransferManager.defaultS3TransferManager().resumeAll({ (self.currentRequest) in
//                return nil
//            })
//            
//            print("Operation Cancelled")
//            
//            currentRequest = nil
//            
//            self.myProgressView.setProgress(0, animated: true)
        }

    }
    
    
    @IBAction func suspendCurrentOperation(sender: AnyObject) {
        
    }
    
}

