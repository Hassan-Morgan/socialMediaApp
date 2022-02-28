abstract class AppStates {}

class AppInitialState extends AppStates {}


class ChangeNavigationBarState extends AppStates {}


class GetUserDataLoadingState extends AppStates {}
class GetUserDataSuccessState extends AppStates {}
class GetUserDataErrorState extends AppStates {}

class PickProfileImageSuccessState extends AppStates {}
class PickProfileImageErrorState extends AppStates {}

class UpdateUserDataLoadingState extends AppStates{}
class UpdateUserDataSuccessState extends AppStates{}
class UpdateUserDataErrorState extends AppStates{}

class PickPostImageSuccessState extends AppStates {}
class PickPostImageErrorState extends AppStates {}

class AddPostLoadingState extends AppStates{}
class AddPostSuccessState extends AppStates{}
class AddPostErrorState extends AppStates{}

class GetPostsLoadingState extends AppStates {}
class GetPostsSuccessState extends AppStates {}
class GetPostsErrorState extends AppStates {}

class LikePostSuccessState extends AppStates {}
class LikePostErrorState extends AppStates {}

class AddCommentSuccessState extends AppStates {}
class AddCommentErrorState extends AppStates {}

class FollowSuccessState extends AppStates {}
class FollowErrorState extends AppStates {}

class SendMessageSuccessState extends AppStates {}
class SendMessageErrorState extends AppStates {}

class AddNotificationSuccessState extends AppStates {}
class AddNotificationErrorState extends AppStates {}
