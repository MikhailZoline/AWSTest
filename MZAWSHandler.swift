//
//  MZAWSHandler.swift
//  AWSTest
//  This AWSHandler class contains the static functions of download/upload operation.
//  Created by Mikhail Zoline on 3/25/16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

class MZAWSHandler{
    
    /**
     *
     * Example of usage of Amazon S3 TransferManager Handler to download from AWS S3 cloud
     * @Parameter: awsObjectKey = name of the resource in AWS S3 bucket
     * @Parameter: awsBucket = Amazon Resource Name of S3 Bucket and directory
     * @Exemple  : examplebucket/developers/design_info.doc
     *           : identifying developers/design_info.doc
     *           : object in the examplebucket bucket
     * @Parameter: completion = completion handler called when asynchronous work is finished
     * @Parameter: completion: filePath = local URL path to downloaded file in case of succes
     * @Parameter: completion: error = description of whats went wrong in case of failure
     *
     */
    static func downloadFile( awsObjectKey awsFileName: String, awsBucket awsBucketName: String, completion: ((filePath : NSURL, error : NSError?)->Void)) -> Void{
        
        // Construct the NSURL for the download location.
        let downloadingFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(awsFileName)
        
        // Construct the download request
        // Note: if you want to attach Progress, Cancel or Suspend fuctions
        // to your download request the 3 lines of code below can be a distinctive function
        // which return AWSS3TransferManagerDownloadRequest
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = awsBucketName
        downloadRequest.key = awsFileName
        downloadRequest.downloadingFileURL = downloadingFilePath
        
        // Create a TransferManager client
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        // Download the file
        transferManager.download(downloadRequest).continueWithBlock({ (task) -> AnyObject! in
            
            // Execute comletion block when the download is finished
            completion( filePath: downloadingFilePath, error: task.error )
            
            //No further tasks to continue
            return nil
        })
    }
    
    /**
     *
     * Example of usage of Amazon S3 TransferManager Handler to upload for AWS S3 cloud
     * @Parameter: fromLocalFile = URL path to local file to upload
     * @Parameter: awsObjectKey = name of the uploaded file in AWS S3 bucket
     * @Parameter: awsBucket = Amazon Resource Name of S3 Bucket and directory
     * @Parameter: completion = completion handler called when asynchronous work is finished
     * @Parameter: completion: error = description of whats went wrong in case of failure
     *
     */
    
    static func uploadFile(fromLocalFile uploadFilePath: NSURL, awsObjectKey awsFileName: String, awsBucket awsBucketName: String, completion: ((error : NSError?)->Void )) ->Void{
        
        // Construct the upload request
        // This can be a distinctive function which return AWSS3TransferManagerUploadRequest
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = awsBucketName
        uploadRequest.key = awsFileName
        uploadRequest.body = uploadFilePath
        
        // Create a TransferManager client
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        // Upload the file
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject? in
            
            completion(error: task.error)
            
            return nil
        }
        
    }
    
    /**
     *
     * Convinience function to construct AWS Download Request
     * @Note     : AWSRequest can be useful to track a Progress and for Cancel or Suspend fuctions
     * @Parameter: awsObjectKey = name of the resource in AWS S3 bucket
     * @Parameter: awsBucket = Amazon Resource Name of S3 Bucket and directory
     * @Exemple  : examplebucket/developers/design_info.doc
     *           : identifying developers/design_info.doc
     *           : object in the examplebucket bucket
     *
     */
    
    static func constructDownloadRequest(awsObjectKey awsFileName: String, awsBucket awsBucketName: String )->AWSS3TransferManagerDownloadRequest{
        
        // Construct the download request
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        // Construct the NSURL for the download location.
        let downloadingFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(awsFileName)
        downloadRequest.bucket = awsBucketName
        downloadRequest.key = awsFileName
        downloadRequest.downloadingFileURL = downloadingFilePath
        return downloadRequest
    }
    
    /**
     *
     * Convinience function to construct AWS Upload Request
     * @Note     : AWSRequest can be useful to track a Progress and for Cancel or Suspend fuctions
     * @Parameter: awsObjectKey = name of the resource in AWS S3 bucket
     * @Parameter: awsBucket = Amazon Resource Name of S3 Bucket and directory
     * @Exemple  : examplebucket/developers/design_info.doc
     *           : identifying developers/design_info.doc
     *           : object in the examplebucket bucket
     *
     */
    
    static func constructUploadRequest(fromLocalFile uploadFilePath: NSURL, awsObjectKey awsFileName: String, awsBucket awsBucketName: String )->AWSS3TransferManagerUploadRequest{
        
        // Construct the upload request
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = awsBucketName
        uploadRequest.key = awsFileName
        uploadRequest.body = uploadFilePath
        
        return uploadRequest
    }
}