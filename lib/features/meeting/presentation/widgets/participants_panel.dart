import 'package:bincang_visual_flutter/features/meeting/domain/entities/meeting_entities.dart';
import 'package:flutter/material.dart';

class ParticipantsPanel extends StatelessWidget {
  final List<Participant> participants;
  final VoidCallback onClose;

  const ParticipantsPanel({
    Key? key,
    required this.participants,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Participants (${participants.length + 1})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),


          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: participants.length + 1, // +1 for "You"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _ParticipantTile(
                    name: 'You',
                    isHost: true,
                    isMuted: false,
                    isVideoOff: false,
                  );
                }

                final participant = participants[index - 1];
                return _ParticipantTile(
                  name: participant.displayName,
                  isHost: participant.isHost,
                  isMuted: participant.isMuted,
                  isVideoOff: participant.isVideoOff,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final String name;
  final bool isHost;
  final bool isMuted;
  final bool isVideoOff;

  const _ParticipantTile({
    required this.name,
    required this.isHost,
    required this.isMuted,
    required this.isVideoOff,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Text(
          name[0].toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (isHost) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Host',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMuted) const Icon(Icons.mic_off, size: 18, color: Colors.red),
          if (isMuted) const SizedBox(width: 8),
          if (isVideoOff)
            const Icon(Icons.videocam_off, size: 18, color: Colors.red),
        ],
      ),
    );
  }
}
