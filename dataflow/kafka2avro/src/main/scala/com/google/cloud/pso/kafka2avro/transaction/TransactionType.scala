/**
  * Copyright 2019 Google LLC
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  * https://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

package com.google.cloud.pso.kafka2avro.transaction

import spray.json._
/** A demo type to showcase the Kafka2Avro pipeline.
  *
  * This is just a demo type showing how you can can read a Scala case class
  * from a string in Kafka, and persist it in Avro format in GCS.
  *
  * Similarly, you could import any type (coming from a Java, Scala, etc,
  * library), and use it with this pipeline. The only requirement is that the
  * type must be serializable.
  *
  * @param txn_accounting_entry
  * @param acc_number String, 
  * @param txn_accounting_entry String,
  * @param txn_card_present_flag Int,
  * @param txn_country String,
  * @param txn_currency String,
  * @param txn_date String,
  * @param txn_id String,
  * @param txn_merchant_id String, 
  * @param txn_amount Float, 
  * @param payment_id String,
  * @param txn_available_balance Float,
  * @param txn_merchant_code Int,
  * @param txn_description String,
  * @param txn_stmt_description String,
  * @param txn_time String,
  * @param txn_status String, 
  * @param txn_bpay_biller_code String 
  */
case class TransactionType(
  acc_number: String, 
  txn_accounting_entry: Option[String],
  txn_card_present_flag: Option[Int],
  txn_country: Option[String],
  txn_currency: Option[String],
  txn_date: Option[String],
  txn_id: String,
  txn_merchant_id: Option[String], 
  txn_amount: Option[Float], 
  payment_id: Option[String],
  txn_available_balance: Option[Float],
  txn_merchant_code: Option[Int],
  txn_description: Option[String],
  txn_stmt_description: Option[String],
  txn_time: Option[String],
  txn_status: Option[String], 
  txn_bpay_biller_code: Option[String] 
)
import DefaultJsonProtocol._

object TransactionTypeProtocol extends DefaultJsonProtocol {
  implicit val TransactionTypeFormat = jsonFormat17(TransactionType)
}