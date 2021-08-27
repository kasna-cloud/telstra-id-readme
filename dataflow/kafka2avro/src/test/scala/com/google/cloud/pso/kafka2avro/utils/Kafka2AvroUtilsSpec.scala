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

package com.google.cloud.pso.kafka2avro.utils

import com.google.cloud.pso.kafka2avro.transaction.TransactionType
import org.scalatest.Matchers._
import org.scalatest.WordSpec

/** Test some of the utility functions in the utils package */
class Kafka2AvroUtilsSpec extends WordSpec {
  "The object2String and string2Object methods" should {
    "reconstruct a case class object" in {
      val o = TransactionType(
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

      val s: String = Kafka2AvroUtils.object2String(o)
      Kafka2AvroUtils.string2Object[TransactionType](s) shouldEqual o
    }

    "reconstruct a complex type (option of list of integers)" in {
      val o = Some(List(1,2,3,5))
      val s: String = Kafka2AvroUtils.object2String(o)
      Kafka2AvroUtils.string2Object[Option[List[Int]]](s) shouldEqual o
    }
  }
}
