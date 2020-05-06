/***** Role *****/

enum Role {
  Member,
  Checker,
  Admin
}

/***** Status challenge *****/

enum StatusChallenge {
  InProgress,
  Succeed,
  Failed
}

extension CatExtension on StatusChallenge {

  String get value {
    switch (this) {
      case StatusChallenge.InProgress:
        return 'In progress';
      case StatusChallenge.Succeed:
        return 'Succeed';
      case StatusChallenge.Failed:
        return 'Failed';
      default:
        return null;
    }
  }
}