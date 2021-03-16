//
//  AWSTransaction.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/03/2021.
//

import AWSDynamoDB

class AWSConstants {
  static let COGNITO_REGIONTYPE = AWSRegionType.USEast1
  static let COGNITO_IDENTITY_POOL_ID = "us-east-1:602956b1-c5e3-41b3-9bdf-a87bce26feb6"
  static let DYNAMODB_DB_TRANSACTIONS_TABLE = "transaction"
  static let DYNAMODB_DB_TRANSACTIONS_TABLE_PK = "pk"
}

@objcMembers
class AWSTransaction: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
  
  var pk: String = ""
  var category: String = ""
  var top_level_category: String = ""
  var date: String = ""
  var amount: NSNumber = 0.0
  var currency_code: String = ""
  var original_description: String = ""
  
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
  
  private static func authenticateWithCognito() {
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSConstants.COGNITO_REGIONTYPE,
                                                            identityPoolId: AWSConstants.COGNITO_IDENTITY_POOL_ID)
    
    let serviceConfiguration = AWSServiceConfiguration(region: AWSConstants.COGNITO_REGIONTYPE,
                                                       credentialsProvider: credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
  }
  
  static func getTransactionData() {
    authenticateWithCognito()
    guard let scanInput = AWSDynamoDBScanInput() else {
      return
      // handle errors
    }
    
    scanInput.tableName = AWSConstants.DYNAMODB_DB_TRANSACTIONS_TABLE
    
    let mapper = AWSDynamoDBObjectMapper.default()
    let exp = AWSDynamoDBScanExpression()
    exp.limit = 100
    mapper.scan(AWSTransaction.self, expression: exp) { (scanOutput, error) in
      if let error = error as NSError? {
        print("ERROR WORKING WITH DYNAMO DB: \(error.userInfo)")
      }
      else {
        if let transactions = scanOutput?.items {
          for transaction in transactions {
            if let transaction = transaction as? AWSTransaction {
              print(transaction.amount)
            }
          }
        }
      }
    }
  }
}
