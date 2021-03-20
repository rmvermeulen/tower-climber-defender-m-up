# combo game

## tower-climber/defender m'up

working title

The player character is a simple platformer character. The platforms are actually walls and towers in a tower-defense game.
The PC can build towers etc near themself to jump on a climb higher. As the PC progresses more enemies spawn.
Enemies come in a few varieties;

- tower-defense enemies, which path towards either towers or the player to attack.
- schmup enemies, which fly in from various directions to attack the player.
- platformer enemies, which walk and jump on the platforms, attacking and obstructing the player.
- hybrids, which combine some of these traits.

The goal of the game for now is simply to get as high as possible. To this end, the player will have to build enough platforms to climb on,
as well as place the platforms strategically so they can effectively attack the waves of enemies.

The player can find and collect powerups throughout the level, and they might also be dropped by killed enemies.
These powerups can be for the player character itself, or the towers, or the enemies. Some are permanent, some are temporary.
For example:
| type | player | tower | enemies | duration |
|------|--------|-------|---------|----------|
| +attack |+|+|+| perm |
| +atkspd |+|+|+| perm |
| +hp |+|+|+| perm |
| +maxhp |+|+|+| perm |
| +waves | | |+| perm |
| -waves | | |+| perm |
| +hpgen |+|+| | temp |
| -grav |+| |+| temp |
| +grav |+| |+| temp |

## POC

goals:

- [ ] platform character
- [ ] tower placement system
- [ ] enemy waves
  - [ ] basic enemies
  - [ ] height-based spawning logic
- [ ] AI
  - [ ] towers
  - [ ] tower-defense enemies
  - [ ] platformer enemies
  - [ ] schmup enemies
