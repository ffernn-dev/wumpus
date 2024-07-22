# Design of Characters and Environment
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
- **Code is well structured and maintainable**

# Converting Wumpus to OOC
## Rooms
```
class room:
	id:int #0 < x <= 20
	contents:list
	3d_position:Vector3
```
## Room manager/world
```
rooms:list[room]
connections:dict{"${start}-${end}": "blocked"}
block_connection(start, end)
```
Notes:
- Rooms\[] stores the room objects.
- A connection's status can be clear, firewall, blocked, or invisible (for the connection to the Datawump's room)
- Connections are stored in a dictionary like so:
	- {"1-2": "clear"} means that the connection between 1 and 2 is clear.
	-  This is to make looking up and modifying connections super easy. Rather than having connection objects (you would have to search the list of objects and check if start_id and end_id match the ones you're looking for), instead you can just index the dict with a string you create from the two ids.
## Entity
See [[Design of Characters and Environment#Parent class]]

# Charts
![[dfd_zero.drawio.png]]
![[dfd_one.drawio.png]]![[classes.drawio.png]]
# Testing and Evaluating
**Unit testing** - creating ways to test small areas of the project without the influence of the rest of the project. Useful for tricky bugs that only occur in specific situations
- I used it in my project to trial the DataWump fight on it's own, and found a bug where his health went into the negatives, as the signal wasn't emitting properly. This caused him not to die because the death check was `health == 0`
- I also used it to create the 3D map separately to the whole game, as it was a difficult task to get working initially.
**System testing** - Alpha and Beta testing that covers the whole system.
- Once I had my game close to completion, I did some alpha testing on my own, and discovered a few critical bugs. One being that the virus was spreading through walls, which I hadn't noticed as I hadn't had a long enough playthrough for it to occur yet
- The second bug I found was that due to the way I was creating pickup-able items, once the player left and went back into a room, they were there again ready for the taking. I had to rewrite the way they're instantiated and destroyed to get it to work.
**Black box testing** - testing a system without knowing the internal workings at all
**User testing** - allowing your target audience to test the system to find any flaws that you as the developer missed
- I used the two of these together when making the game, and discovered three things
	- Death messages needed to be clearer, and give a hint of what to try doing differently
	- The map looked ugly and needed changing (Also to show blocked off connections on the map, because that's hard to keep in one's head)
	- It wasn't clear how the map was laid out, so I added a "you are here" marker on top which they said improved it greatly
**Grey box testing** - collaboration between knowing and not knowing the internal workings while testing
- Once my testers had played through without me, they played again with me explaining a bit more, and I was able to get some feedback on them about
	- Movement speed of the DataWump
	- Progression of the virus
	- Finding the DataWump's room once the goggles are found

## Success criteria
- ***Movement and Navigation**:*
    - *It is immediately obvious to the player that they can move smoothly between rooms*
    - I believe I successfully did this
    - *Room transitions are validated, ensuring the player only moves to adjacent, connected rooms.*
    - This works perfectly
- ***Virus Mechanics**:*
    - *The virus, Number Four, progresses and infects adjacent rooms correctly using the `progress()` function.*
    - This works perfectly
    - *Rooms adjacent to the virus display a glitch effect on the doorway, indicating danger.*
    - This ended up being too hard to implement, so I instead opted for a marker on the map
- ***Datawump Mechanics**:*
    - *The Datawump can attack using predefined patterns, and the player must avoid red zones in the attack area.*
    - Due to time constraints I had to scrap this and use plain Melee combat which is not as interesting as I would have liked
	- *Player can use `shoot()` to attack the Datawump, reducing its health upon successful hits.*
	- Success.
- ***Gameplay is fun and repeatable***
- In my subjective opinion, the random variation in the levels allows for a new interesting puzzle each time on how to squander the virus
- ***Code is well structured and maintainable***
- Unfortunately this fell out the window, and the final product is a huge mess that needs refactoring. The main mistake I made was seperating GlobalData and the world_manager, which resulting in awkward data passing around



# Bibliography
https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html
https://www.reddit.com/r/godot/comments/xvf5nr/exporting_enums_help_godot_4/
https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_format_string.html
https://docs.godotengine.org/en/stable/tutorials/animation/animation_tree.html
https://docs.godotengine.org/en/stable/classes/class_tween.html
https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
https://stackoverflow.com/questions/72242732/how-do-i-create-a-timer-in-godot
https://docs.godotengine.org/en/stable/classes/class_packedstringarray.html
https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html#connecting-a-signal-via-code
https://www.reddit.com/r/godot/comments/5e3lan/how_does_inheritance_of_nodes_works_in_godot/
