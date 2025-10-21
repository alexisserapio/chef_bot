enum MessageSender { user, bot }

class ChatMessage {
  final String text;
  final MessageSender sender;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.sender,
    this.isLoading = false,
  });
}
