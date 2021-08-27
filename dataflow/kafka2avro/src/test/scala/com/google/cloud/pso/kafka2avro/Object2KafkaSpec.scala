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

package com.google.cloud.pso.kafka2avro

import com.google.cloud.pso.kafka2avro.config.Kafka2AvroConfig
import com.google.cloud.pso.kafka2avro.transaction.TransactionType
import com.spotify.scio.ScioContext
import com.spotify.scio.testing.PipelineSpec
import com.spotify.scio.values.SCollection
import com.google.cloud.pso.kafka2avro.transaction.TransactionTypeProtocol
/** Test the Object2Kafka pipeline.
  *
  * The pipeline has three steps: extract, transformation and load.
  * Here we don't test the load step, sending messages to Kafka. That would
  * probably require mocking a Kafka server.
  *
  * The other two steps are tested as follows:
  *  - The extract step creates some objects that will be serialized and
  *    written to Kafka
  *  - The transform step serializes the objects into base64 encoded strings
  */
class Object2KafkaSpec extends PipelineSpec {

  // Just a sample config to perform these tests
  implicit val testConfig: Kafka2AvroConfig = Kafka2AvroConfig(
  "broker", 
  "kafkaTopic",
  3 
  )

  "The extract step" should "create objects correctly" in {
    val testObjs = Object2Kafka.createDemoObjects(testConfig.numDemoObjects)
    runWithContext { implicit sc: ScioContext =>
      val objs: SCollection[TransactionType] = Object2Kafka.extract(testConfig)
      objs should haveSize(3)
      objs should containInAnyOrder(testObjs)
    }
  }

  "The transform step" should "create strings correctly" in {
    // Three objects to test the transform step
    val obj1 = TransactionType(
      "acc_number: String", 
      Some("txn_accounting_entry: String"),
      Some(0),
      Some("txn_country: String"),
      Some("txn_currency: String"),
      Some("txn_date: String"),
      "txn_id: String",
      Some("txn_merchant_id: String"), 
      Some(0.0f), 
      Some("payment_id: String"),
      Some(0.0f),
      Some(0),
      Some("txn_description: String"),
      Some("txn_stmt_description: String"),
      Some("txn_time: String"),
      Some("txn_status: String"), 
      Some("txn_bpay_biller_code: String")
      )
    val obj2 = TransactionType(
      "acc_number: String", 
      Some("txn_accounting_entry: String"),
      Some(1),
      Some("txn_country: String"),
      Some("txn_currency: String"),
      Some("txn_date: String"),
      "txn_id: String",
      Some("txn_merchant_id: String"), 
      Some(0.0f), 
      Some("payment_id: String"),
      Some(0.0f),
      Some(0),
      Some("txn_description: String"),
      Some("txn_stmt_description: String"),
      Some("txn_time: String"),
      Some("txn_status: String"), 
      Some("txn_bpay_biller_code: String")
      )
    val obj3 = TransactionType(
      "acc_number: String", 
      Some("txn_accounting_entry: String"),
      Some(1),
      Some("txn_country: String"),
      Some("txn_currency: String"),
      Some("txn_date: String"),
      "txn_id: String",
      Some("txn_merchant_id: String"), 
      Some(0.0f), 
      Some("payment_id: String"),
      Some(0.0f),
      Some(0),
      Some("txn_description: String"),
      Some("txn_stmt_description: String"),
      Some("txn_time: String"),
      Some("txn_status: String"), 
      Some("txn_bpay_biller_code: String")
      )

    val objs = List(obj1, obj2, obj3)
    val strings = objs.map(utils.Kafka2AvroUtils.object2String)

    runWithContext { sc: ScioContext =>
      val coll: SCollection[TransactionType] = sc.parallelize(objs)
      val transformed: SCollection[String] = Object2Kafka.transform(coll)

      transformed should haveSize(3)
      transformed should containInAnyOrder(strings)
    }
  }

  "The createDemoObjects function" should "create proper lists" in {
    Object2Kafka.createDemoObjects(0) shouldEqual Nil
    Object2Kafka.createDemoObjects(-3) shouldEqual Nil
    Object2Kafka.createDemoObjects(7).length shouldEqual 7
    Object2Kafka.createDemoObjects(1).length shouldEqual 1
    Object2Kafka.createDemoObjects(11).length shouldEqual 11
  }
}
