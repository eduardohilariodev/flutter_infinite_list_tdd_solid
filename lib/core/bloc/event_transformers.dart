import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

/// Combines [throttle] and [droppable] to create a custom [EventTransformer].
///
/// The [throttle] part blocks events for a specific [duration] after an event
/// is emitted. This is useful for preventing rapid-fire events, like multiple
/// button clicks.
///
/// The [droppable] part ignores any new events while the current one is being
/// processed. This ensures that only one event is processed at a time, avoiding
/// race conditions.
///
/// Together, they ensure that events are not only spaced out over time but also
/// that multiple events don't get processed simultaneously.
///
/// Example:
/// ```dart
/// EventTransformer<E> customTransformer = throttleDroppable(Duration(milliseconds: 100));
/// ```
///
/// [E] is the type of the event.
///
/// Returns a new [EventTransformer].
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}
