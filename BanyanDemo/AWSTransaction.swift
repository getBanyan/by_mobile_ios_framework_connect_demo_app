//
//  AWSTransaction.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/03/2021.
//

import AWSDynamoDB

enum AWSEnvironment {
  case laboratory
  case development
  case production
}

class AWSConstants {
  static let COGNITO_REGIONTYPE = AWSRegionType.USEast1
  static let COGNITO_IDENTITY_POOL_ID_LABORATORY = "us-east-1:602956b1-c5e3-41b3-9bdf-a87bce26feb6"
  static let COGNITO_IDENTITY_POOL_ID_DEVELOPMENT = "us-east-1:b244ca7b-9f4f-45fd-b3d1-fda5bbaaa36d"
  static let COGNITO_IDENTITY_POOL_ID_PRODUCTION = "us-east-1:d6903e54-5e45-4f9a-9397-e9b046462cee"
  static let DYNAMODB_DB_TRANSACTIONS_TABLE = "transaction"
  static let DYNAMODB_DB_TRANSACTIONS_TABLE_PK = "pk"
}

@objcMembers
class AWSTransaction: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
  
  var pk = ""
  var category = ""
  var top_level_category = ""
  var date = ""
  var amount = NSNumber(0.0)
  var currency_code = ""
  var original_description = ""
  
  static func hashKeyAttribute() -> String {
    return AWSConstants.DYNAMODB_DB_TRANSACTIONS_TABLE_PK
  }
  
  static func dynamoDBTableName() -> String {
    return AWSConstants.DYNAMODB_DB_TRANSACTIONS_TABLE
  }
  
  override init!() { super.init() }
  
  //required to let DynamoDB Mapper create instances of this class
  override init(dictionary dictionaryValue: [AnyHashable : Any]!, error: ()) throws {
    try super.init(dictionary: dictionaryValue, error: error)
  }
  
  required init!(coder: NSCoder!) {
    super.init(coder: coder)
  }
}

class AWSTransactionManager {
  
  private static func authenticateWithCognito(inEnvironment environment: AWSEnvironment) {
    var identityPoolId = AWSConstants.COGNITO_IDENTITY_POOL_ID_DEVELOPMENT
    
    if environment == .laboratory {
      identityPoolId = AWSConstants.COGNITO_IDENTITY_POOL_ID_LABORATORY
    }
    else if environment == .production {
      identityPoolId = AWSConstants.COGNITO_IDENTITY_POOL_ID_PRODUCTION
    }
    
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSConstants.COGNITO_REGIONTYPE,
                                                            identityPoolId: identityPoolId)
    
    let serviceConfiguration = AWSServiceConfiguration(region: AWSConstants.COGNITO_REGIONTYPE,
                                                       credentialsProvider: credentialsProvider)

    AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
  }
  
  private static func tearDownCognito() {
    if let credentialsProvider = AWSServiceManager.default().defaultServiceConfiguration.credentialsProvider as? AWSCognitoCredentialsProvider {
      credentialsProvider.invalidateCachedTemporaryCredentials()
      credentialsProvider.clearCredentials()
      credentialsProvider.clearKeychain()
    }
  }
  
  static func getTransactionData(fromEnvironment environment: AWSEnvironment, completion: (([AWSTransaction]?, NSError?) -> Void)?) {
    authenticateWithCognito(inEnvironment: environment)
    guard let scanInput = AWSDynamoDBScanInput() else {
      return
      // handle errors
    }
    
    scanInput.tableName = AWSConstants.DYNAMODB_DB_TRANSACTIONS_TABLE
    
    let mapper = AWSDynamoDBObjectMapper.default()
    let exp = AWSDynamoDBScanExpression()
    exp.limit = 100
    mapper.scan(AWSTransaction.self, expression: exp) { (scanOutput, error) in
      
      tearDownCognito()
      
      if let error = error as NSError? {
        if let completion = completion {
          completion(nil, error)
        }
        print("ERROR WORKING WITH DYNAMO DB: \(error.userInfo)")
        return
      }
      
      if let results = scanOutput?.items {
        var transactions = [AWSTransaction]()
        
        for result in results {
          if let transaction = result as? AWSTransaction {
            transactions.append(transaction)
          }
        }
        
        if let completion = completion {
          completion(transactions, nil)
        }
      }
    }
  }
}
