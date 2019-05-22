class UserChat {
  final String displayName;
  final String avatar;
  final String uid;
  final String aboutMe;
  final String dateCreated;

  bool isUndefined() => uid == null || uid.isEmpty;

  UserChat(
      this.displayName, this.avatar, this.uid, this.aboutMe, this.dateCreated);

  static UserChat undefined() {
    return UserChat(
      "",
      "",
      "",
      "",
      "",
    );
  }
}
