## Rooms
```
class room:
	id:int #0 < x <= 20
	contents:list
	3d_position:Vector3
```
## Room manager/world
```
rooms:list[connection]
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

