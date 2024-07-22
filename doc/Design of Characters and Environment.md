## Characters
- **Lauren "`gift`" Hanley**: a brave cybersecurity hobbyist, armed with a digital map, a cyberdeck and an outlandishly colourful outfit, she seeks to find the killswitch (antidote) to a virus that is sweeping the world, which the mastermind behind the virus has hidden somewhere in a digital maze, guarded by the Datawump.
	- `gift` will move through the environment using move_to_room(). It will check whether the inputted room number is valid to move through, this will involve keeping a set of "edges" that connect two rooms, and storing whether they are blocked by a firewall or not.
	- She will be able to use `shoot` (uses 1 code arrow, tracked in `number_of_code_arrows`) to attack the Datawump. 
	- `block_connection` can be used to disconnect two servers, similar to firewalls. Essentially it removes one of the server connections from the master list, so viruses can't spread through it.
```
number_of_code_arrows = 4
has_wumpvision = false
current_room = 1
found_rooms = [<Room Object>, <Room Object>]
move_to_room(num) # Will have to be validated
shoot()
block_connection(num1, num2)
```
- **The Datawump**: A nasty cybercreature who holds the decryption key to the antidote. He is very protective of his treasure, and you'll have to fight him hard to get it.
	- It can use `attack()` to run one of a list of preset attacks. Attacks will show red and white zones on the ground, and the player must not stand in the red zone at the end of the timer, as it will kill them. This will be done using Godot's built-in area collision detection.
	- The Datawump also has the ability to move between rooms, but I'm not sure if this functionality will be used in game. Most likely he will stay in one room.
```
health = 3
current_room = 12
attack_cooldown_timer = seconds
currrent_attack_index = 1
move_to_room(num) # Will have to be validated
attack()
```
- **The Virus**: known as *Number Four* because of the strange arbitrary limitation programmed into it: each computer only gets erased after infecting 4 surrounding computers. This has lead to networks being rearranged to only have 3 connections per node for safety, slowing down communications and making the internet very difficult to navigate.
	- Can make more copies of itself once its type is "infected", using the `progress()` function. This will either occur each time the player moves between rooms, or after a timer cooldown.
	- Newly created virus will have the type "infecting", and will have to `progress` 6 times to reach a fully infected state, before it can start to infect adjacent servers.
	- Rooms adjacent to the virus will have a glitch effect on the doorway to indicate that its unsafe. `source_room` will be used to mark the connection.
```
type = "infected"|"infecting"
current_room = 19
infection_progress = 1
source_room = 18
progress() # Moves infection_progress towards 12, or creates a new virus entity in neighboring room if status is "infected"
```
- **The Firewalls:** appear randomly throughout the network, blocking passage between two servers. (Implemented as part of the "world")
- **CodeArrows:** appear randomly throughout the network. Need three of them to kill the Datawump
	- Spawning the CodeArrows as "fired" will be handled by the player, and the movement collision will be handled by Godot's physics system. When Godot tells the arrow it has collided with something, if it's the DataWump, it will deal damage to it.
```
on_collide_with_datawump()
```
## Parent class
```
class entity:
	current_room: int
	move_to_room()
	validate_room() # Check if a given room number is connected to the current
```
## Environment
- `gift` is able to hop between servers in virtual reality, with each one experienced as a small world where she can see and travel through network connections, and see/interact with anything that could be hiding in the corners of the machine.
- The network she's in is set up so that each node is only connected to three others, in order to prevent the virus travelling. If `gift` ends up in a room with the virus in it, it will make its way onto her network, meaning game over. Servers next to the virus will start to show damage and glitches moving in through the connection ports. She must disconnect these ports as soon as possible
- The Datawump's home server is invisible without wearing WumpVision glasses, hidden somewhere in the network. Once you have them, the room will reveal itself as a fourth connection from one room.
## Success criteria
- **Movement and Navigation**:
    - It is immediately obvious to the player that they can move smoothly between rooms
    - Room transitions are validated, ensuring the player only moves to adjacent, connected rooms.
- **Virus Mechanics**:
    - The virus, _Number Four_, progresses and infects adjacent rooms correctly using the `progress()` function.
    - Rooms adjacent to the virus display a glitch effect on the doorway, indicating danger.
- **Datawump Mechanics**:
    - The Datawump can attack using predefined patterns, and the player must avoid red zones in the attack area.
	- Player can use `shoot()` to attack the Datawump, reducing its health upon successful hits.
- **Gameplay is fun and repeatable**