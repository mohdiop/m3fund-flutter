enum CampaignState { inProgress, finished }

enum CampaignType { donation, volunteering, investment }

enum FileExtension {
  jpg,
  jpeg,
  png,
  gif,
  bmp,
  webp,
  mp4,
  mov,
  avi,
  mkv,
  webm,
  pdf,
  doc,
  docx,
  xls,
  xlsx,
  ppt,
  pptx,
  txt,
}

enum FileType {
  picture,
  logo,
  video,
  residence,
  biometricCard,
  associationStatus,
  rccm,
  bankStatement,
  businessModel,
}

enum NotificationType {
  newMessage,
  newContribution,
  newComment,
  projectValidated,
  projectRejected,
  targetBudgetReached,
  campaignFinished,
  systemAlert,
}

enum PaymentState { pending, success, failed }

enum PaymentType { orangeMoney, moovMoney, paypal, bankCard }

enum ProjectDomain {
  agriculture,
  breeding,
  education,
  health,
  mine,
  culture,
  environment,
  computerScience,
  solidarity,
  shopping,
  social,
}

enum ProjectOwnerType { individual, organization, association }

enum RewardType { symbolic, product }

enum RewardWinningState { pending, gained, canceled }

enum UserRole {
  superAdmin,
  system,
  validationsAdmin,
  paymentsAdmin,
  usersAdmin,
  contributor,
  projectOwner,
}

enum UserState { active, inactive, suspended }
