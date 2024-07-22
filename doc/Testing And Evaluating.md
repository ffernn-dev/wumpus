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


