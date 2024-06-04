## Characters
- **Lauren "`gift`" Hanley**: a brave cybersecurity hobbyist, armed with a digital map, a cyberdeck and an outlandishly colourful outfit, she seeks to find the killswitch (antidote) to a virus that is sweeping the world, which the mastermind behind the virus has hidden somewhere in a digital maze, guarded by the Datawump.
	- `gift` will move through the environment using move_to_room(). It will check whether the inputted room number is valid to move through, this will involve keeping a set of "edges" that connect two rooms, and storing whether they are blocked by a firewall or not.
	- She will be able to use `shoot` (uses 1 code arrow, tracked in `number_of_code_arrows`) to attack the Datawump. 
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
```
health = 3
current_room = 12
attack_cooldown_timer = seconds
currrent_attack_index = 1
move_to_room(num) # Will have to be validated
attack()
```
- **The Virus**: known as *Number Four* because of the strange arbitrary limitation programmed into it: each computer only gets erased after infecting 4 surrounding computers. This has lead to networks being rearranged to only have 3 connections per node for safety, slowing down communications and making the internet very difficult to navigate.
```
type = "infected"|"infecting"
current_room = 19
infection_progress = 1
progress() # Moves infection_progress towards 12, or creates a new virus entity in neighboring room if status is "infected"
```
- **The Firewalls:** appear randomly throughout the network, blocking passage between two servers. (Implemented as part of the "world")
- **CodeArrows:** appear randomly throughout the network. Need three of them to kill the Datawump
```
on_collide_with_wumpus()
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


