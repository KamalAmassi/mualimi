/// Why a download is paused (or waiting). Only [network] pauses resume on
/// their own; a [user] pause waits for the user.
enum PauseReason { user, network }
