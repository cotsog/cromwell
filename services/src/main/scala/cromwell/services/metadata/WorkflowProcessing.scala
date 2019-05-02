package cromwell.services.metadata

import java.beans.Introspector
import java.time.OffsetDateTime

import akka.actor.ActorRef
import cromwell.core.WorkflowId
import cromwell.services.metadata.MetadataService.PutMetadataAction

import scala.util.Random


object WorkflowProcessing {
  val ProcessingEventsKey = "processingEvents"

  sealed trait ProcessingMetadataKey {
    // FooBar => fooBar
    def forPublication: String = Introspector.decapitalize(getClass.toString)
  }

  case object PickedUp extends ProcessingMetadataKey
  case object Released extends ProcessingMetadataKey
  case object Terminal extends ProcessingMetadataKey

  def publishProcessingEvents(workflowId: WorkflowId, cromwellId: String, key: ProcessingMetadataKey, serviceRegistry: ActorRef): Unit = {
    def randomNumberString: String = Random.nextInt.toString.stripPrefix("-")

    def metadataKey(workflowId: WorkflowId, randomNumberString: String, key: String) =
      MetadataKey(workflowId = workflowId, jobKey = None, s"$ProcessingEventsKey[$randomNumberString]:$key")

    val random = randomNumberString

    val processingFields = List(
      "description" -> key.forPublication,
      "cromwellId" -> cromwellId,
      "timestamp" -> OffsetDateTime.now()
    )

    val metadata = processingFields map { case (k, v) =>
      MetadataEvent(metadataKey(workflowId = workflowId, randomNumberString = random, key = k), MetadataValue(v))
    }

    serviceRegistry ! PutMetadataAction(metadata)
  }
}

