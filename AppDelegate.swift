/*

* Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.

*

* Licensed under the Apache License, Version 2.0 (the "License").

* You may not use this file except in compliance with the License.

* A copy of the License is located at

*

*  http://aws.amazon.com/apache2.0

*

* or in the "license" file accompanying this file. This file is distributed

* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either

* express or implied. See the License for the specific language governing

* permissions and limitations under the License.

*/



import UIKit



@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    var window: UIWindow?
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        let identityProvider = DeveloperAuthenticatedIdentityProvider (
//            
//            regionType: CognitoRegionType,
//            
//            identityId: nil, accountId: AccountId,
//            
//            identityPoolId: CognitoIdentityPoolId,
//            
//            logins: [DeveloperProviderName: ""],
//            
//            providerName: DeveloperProviderName
//            
//        )
//        
//       
//        
//        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoRegionType, identityProvider: identityProvider, unauthRoleArn: nil, authRoleArn: nil)
//        
//        let configuration = AWSServiceConfiguration(region: DefaultServiceRegionType, credentialsProvider: credentialsProvider)
//        
//        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
   

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: CognitoRegionType, identityPoolId: CognitoIdentityPoolId)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
        
        return true
        
    }
    
    
}



