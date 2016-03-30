//

//  DeveloperAuthenticatedIdentityProvider.swift

//  S3TransferManagerSampleSwift

//

//  Created by Tim Rozmajzl on 3/19/16.

//  Copyright Â© 2016 Amazon Web Services. All rights reserved.

//





import Foundation





class DeveloperAuthenticatedIdentityProvider: AWSAbstractCognitoIdentityProvider {
    
    var _token: String!

    var _logins: [ NSObject : AnyObject ]
    
    var _providerName: String!
    
    
/*    
     // Original function:
    init(regionType: AWSRegionType, identityId: String!, accountId: String!, identityPoolId: String!, logins: [ NSObject : AnyObject]!, providerName: String!)
        
    {
        self._logins = logins
        
        self._providerName = providerName
        
        self._token = "notoken"
        
        super.init(regionType: regionType, identityId: identityId, accountId: accountId, identityPoolId: identityPoolId, logins: logins)
        
    }
*/
    

    //Mikhail's change:
    init(regionType: AWSRegionType, identityPoolId: String!)
        
    {
        self._logins = [DeveloperProviderName: ""]
        
        self._providerName = ""
        
        self._token = "notoken"
        
        super.init(
            regionType: regionType,
            identityId: "",
            accountId: "",
            identityPoolId: identityPoolId,
            logins: _logins
        )
    }
    
    override var token: String {
        
        get {
            
            return _token
            
        }
        
    }
    
    
    
    override var logins: [ NSObject : AnyObject ]! {
        
        get {
            
            return _logins
            
        }
        
        set {
            
            _logins = newValue!
            
        }
        
    }
    
    
    
    override var providerName: String! {
        
        get {
            
            return _providerName
            
        }
        
        set {
            
            _providerName = newValue
            
        }
        
    }
    
    
    
    override func getIdentityId() -> AWSTask! {
        
        
        
        if self.identityId != nil {
            
            return AWSTask(result: self.identityId)
            
        }else{
            
            return AWSTask(result: nil).continueWithBlock({ (task) -> AnyObject! in
                
                if self.identityId == nil {
                    
                    return self.refresh()
                    
                }
                
                return AWSTask(result: self.identityId)
                
            })
            
        }
        
    }
    
    
    
    override func refresh() -> AWSTask! {
        
        let awsTask = AWSTaskCompletionSource()
        
        
        
        let url = NSURL(string: LoginUrl)
        
        let request = NSMutableURLRequest(URL:url!);
        
        request.HTTPMethod = "POST";
        
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            data, response, error in
            
            
            
            //Convert to NSDictionary
            
            var json: NSDictionary?
            
            do {
                
                try json = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                
            } catch let error as NSError{
                
                print(error)
                
            }
            
            
            
            // Need some error checking below
            
            if let parsedJSON = json {
                
                let identityId = parsedJSON["IdentityId"] as? String
                
                let token = parsedJSON["Token"] as? String
                
                self.identityId = identityId
                
                self._token = token
                
                self.logins = [self.providerName: self.token]
                
            }
            
            awsTask.setResult(self.identityId)
            
        }
        
        task.resume()
        
        
        
        return awsTask.task
        
    }
    
}
