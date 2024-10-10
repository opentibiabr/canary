
# Livestream System

The Canary Livestream System allows players to broadcast their gameplay to other players in real-time, creating a dynamic and engaging streaming experience directly within the game client. Players can set passwords, mute or ban spectators, and even receive experience bonuses while streaming.

To use this, need login with:
email: @livestream
password: any password for client 13+ and no password for otc, if the streamer has set a password, you will need to set his password. 

## Features

- **Stream Broadcasting**: Players can broadcast their gameplay using a set of in-game commands.
- **Password Protection**: Streams can be password-protected to limit access.
- **Viewer Management**: Players can manage viewers by kicking, muting, or banning them.
- **Experience Bonus**: Casters may receive an experience bonus when broadcasting.
- **Player and Viewer Level Requirements**: Only players and viewers of a certain level can participate in livestreams.
- **Viewer Name Customization**: Viewers can change their display name while watching streams.
- **Commands for Casters**: Various commands allow casters to control their streams effectively.
- **Commands for Viewers**: Viewers have access to commands to see the list of spectators or change their display name.
  
## Configuration

The system can be customized via the configuration file (`config.lua`) with the following settings:

```lua
livestreamExperienceMultiplier = 1.15 -- Experience bonus multiplier (15%) set to 1.0 for disable
livestreamMaximumViewersPerIP = 2 -- Maximum viewers per IP
livestreamMaximumViewers = 10 -- Maximum total viewers for non-premium accounts (to 0 for enable system only to premium accounts)
livestreamPremiumMaximumViewers = 20 -- Maximum viewers for premium accounts
livestreamCasterMinLevel = 200 -- Minimum level required to broadcast
```

To disable the livestream system, set the `FEATURE_LIVESTREAM` directive to `0` in `features.hpp`.

## Livestream Commands

### Casters
Casters (players broadcasting the stream) have access to a variety of commands to control their livestreams. All commands begin with `!livestream`.

- `!livestream on`: Enables the livestream.
- `!livestream off`: Disables the livestream.
- `!livestream desc, description`: Sets a description for the livestream.
- `!livestream desc, remove`: Removes the current description.
- `!livestream password, password`: Sets a password for the livestream.
- `!livestream password off`: Removes the password protection.
- `!livestream kick, name`: Kicks a spectator from the livestream.
- `!livestream ban, name`: Bans a spectator by IP from the livestream.
- `!livestream unban, name`: Unbans a previously banned spectator.
- `!livestream bans`: Shows the list of banned spectators.
- `!livestream mute, name`: Mutes a spectator in the chat.
- `!livestream unmute, name`: Unmutes a previously muted spectator.
- `!livestream mutes`: Shows the list of muted spectators.
- `!livestream show`: Displays the current list of spectators.
- `!livestream status`: Displays the status of the livestream.

### Viewers
Viewers have access to a limited set of commands to interact with the stream:

- `/show`: Displays the list of current spectators.
- `/name new_name`: Changes the viewer's display name.

## Backend Database

The `active_livestream_casters` table is used to track the status and viewer count of active livestreams:

```sql
CREATE TABLE IF NOT EXISTS `active_livestream_casters` (
  `caster_id` INT(11) UNSIGNED NOT NULL,
  `livestream_status` TINYINT(1) NOT NULL DEFAULT '0',
  `livestream_viewers` INT(11) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`caster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

The table includes the following columns:
- `caster_id`: The unique identifier for the player broadcasting the livestream.
- `livestream_status`: The current status of the livestream (0 = offline, 1 = online).
- `livestream_viewers`: The current number of viewers watching the livestream.

## Conclusion

The Livestream System enhances the social experience of the game by allowing players to share their adventures in real-time. With robust controls and a clear set of commands, both casters and viewers can enjoy an interactive and secure livestreaming environment.
