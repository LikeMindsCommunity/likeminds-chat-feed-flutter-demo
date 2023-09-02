// Poll Creation String constants

class PollCreationStringConstants {
  static const String newPoll = 'New Poll';
  static const String pollQuestionText = 'Poll question';
  static const String answerOptions = 'Answer options';
  static const String pollQuestionHint = "Ask a question";
  static const String addOption = 'Add an option...';
  static const String optionHint = 'Option';
  static const String pollExpiresOn = 'Poll expires on';
  static const String pollExpiryHint = 'DD-MM-YYYY hh:mm';
  static const String atMaxVotes = "At max";
  static const String exactlyVotes = "Exactly";
  static const String atLeastVotes = "At least";
  static const String votingTypeText = "Users can vote for";
  static const String duplicateOptionsError = "Please avoid duplicate options";
  static const String enterPollOptionError = "Please enter poll option";
  static const String pollExpiryError = "Please select poll expiry date";
  static const String pollTitleError = "Poll title cannot be empty";
}

class PollBubbleStringConstants {
  static const String instantPoll = "Instant poll";
  static const String deferredPoll = "Deferred poll";
  static const String isAnonymousPoll = "Secret voting";
  static const String isNotAnonymousPoll = "Public voting";
  static const String firstUserToVote = "Be the first to vote";
  static const String addAnOption = "+ Add an option";
  static const String userAddedOption = "Added by you";
  static const String addNewPollOption = "Add new poll option";
  static const String pollResults = "Poll Results";
  static const String addNewPollOptionDescription =
      "Enter an option that you think is missing in this poll. This can not be undone.";
  static const String typeNewOption = "Type new option";
  static const String voteSubmissionSuccess = "Vote submission successful";
  static const String voteSubmissionSuccessDescription =
      "Your vote has been submitted successfully. You can change and resubmit your vote anytime till the voting ends.";
  static const String resultWillBeAnnounced =
      "Results will be announced when voting ends on";
  static const String pollEnded = "Poll ended";
}

List<String> usersCanVoteForList = [
  PollCreationStringConstants.atMaxVotes,
  PollCreationStringConstants.exactlyVotes,
  PollCreationStringConstants.atLeastVotes,
];

List<String> numOfVotes = [
  "Select option",
  "1 option",
  "2 options",
  "3 options",
  "4 options",
  "5 options",
  "6 options",
  "7 options",
  "8 options",
  "9 options",
  "10 options",
];
