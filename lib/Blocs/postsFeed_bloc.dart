import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/Events/postsFeed_events.dart';
import 'package:fntat/Blocs/States/postsFeed_states.dart';
import 'package:fntat/Data/postsFeed_data.dart';

class PostsFeedBloc extends Bloc<PostsFeedEvent, PostsFeedState> {
  PostsData api;
  PostsFeedBloc(PostsFeedState initialState, this.api) : super(initialState);

  @override
  Stream<PostsFeedState> mapEventToState(PostsFeedEvent event) async* {
    if (event is StartEvent) {
      yield PostsFeedInitialState();
    } else if (event is GettingPosts) {}
  }
}
