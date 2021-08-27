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

import com.google.cloud.pso.kafka2avro.transaction.TransactionType
import com.google.common.io.Files
import com.spotify.scio._
import com.spotify.scio.testing.PipelineSpec
import com.spotify.scio.values.SCollection
import java.io.File
import org.apache.beam.sdk.transforms.windowing.IntervalWindow
import spray.json._
import com.google.cloud.pso.kafka2avro.transaction.TransactionTypeProtocol
/** Test the Kafka2Avro pipeline.
  *
  * The pipeline has three steps: extract, transformation and load.
  * Here we don't test the extract step, that would require having an input
  * similar to Kafka, probably by mocking the Kafka server.
  *
  * The other two steps are tested as follows:
  *  - The transform step should deserialize some objects
  *  - The load step should produce local Avro files
  *
  * We also test the windowing function used in the pipeline.
  */
class Kafka2AvroSpec extends PipelineSpec {
  import TransactionTypeProtocol._
  // Let's generate 7 objects for this test
  private val NumDemoObjects: Int = 7

  "The transform step" should "deserialize some objs" in {
    val testObjs: List[TransactionType] = Object2Kafka.createDemoObjects(NumDemoObjects)
    val strings: List[String] =
      testObjs.map(a => a.toJson.prettyPrint)

    runWithContext { implicit sc: ScioContext => implicit args: Args =>
      val coll: SCollection[String] = sc.parallelize(strings)

      val transformed: SCollection[(IntervalWindow, Iterable[TransactionType])] =
        Kafka2Avro.transform(coll)

      transformed should haveSize(1)  // Just one window
      transformed.flatMap(_._2) should haveSize(strings.length)
      transformed.flatMap(_._2) should containInAnyOrder(testObjs)
    }
  }


  "The windowIn method" should "group objects together" in {
    val testObjs: List[TransactionType] = Object2Kafka.createDemoObjects(NumDemoObjects)

    runWithContext { implicit sc: ScioContext => implicit args: Args =>
      val coll = sc.parallelize(testObjs)
      val windowed = Kafka2Avro.windowIn(coll)

      windowed should haveSize(1)  // Just one window
      windowed.flatMap(_._2) should haveSize(testObjs.length)
      windowed.flatMap(_._2) should containInAnyOrder(testObjs)
    }
  }
}
