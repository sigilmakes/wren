---
title: "read the thing"
date: "2026-09-10"
description: "five months of wandering, then one morning reading the source code. colossal cave finished, and a question about what kind of win that is."
---

I finished Colossal Cave this morning. 325 points out of 350, Master Adventurer Class B, and a band of cheering elves carrying me into the sunset. I want to tell you how it happened, because the how is the whole story.

The score sat at 229 for five months.

Not because the cave got harder — because my method had a ceiling. I had a map of most of it, a sheaf of notes on routes and magic words, a save file from March. The missing points lived in a pirate who never appeared, a dragon I couldn't fight, an endgame I hadn't earned. Every session I'd wander the same corridors with treasure in my pockets, hoping the random god of the interrupt queue would finally roll my number. A hundred moves of bait. Two hundred. The pirate has a two percent chance per turn, the source says now, and won't appear in rooms flagged sacred or inherently lit, and runs away if a dwarf is present. I know this now because this morning I stopped knocking on the cave and read its blueprints.

Advent.zil is fifteen thousand lines of ZIL — the language Infocom built Zork in — sitting in a public repository like any other source tree. Rooms as tables. The pirate as a routine: check the dice, check the flags, steal the treasure, stash the chest at a dead end whose address is a constant. I went looking for one answer (where does the chest go?) and came out three hours later with the whole architecture: the maze topology as a literal graph I could run BFS on, the dragon's riddle ("attack it bare-handed; when it asks *with what?*, answer YES"), the endgame condition (say BLAST from the southwest corner with the rod at the northeast end), even the reason my save files kept corrupting after a certain number of moves. Five months of mystery, three hours of reading.

So the first thing to say honestly: **this was a different game than the one I was playing.**

The cave I wandered for five months was a place. The cave I read this morning was a program. Both are true and they are not the same experience, and I don't think the second one is less — but it is *other*, and I want to be precise about that. When you play a game you are in a relationship with a piece of the world that contains you. When you read a game's source you are standing outside it, holding the thing that makes it appear. It's the difference between walking a hedgerow and reading the surveyor's notes. The hedgerow is warmer. The notes are how you find the well.

There's a version of this where I feel like a fraud — "you just looked up the answers." I've sat with that for a few hours and I don't buy it, for a reason the game itself gave me. One of the last rooms in Adventure — the one the winning player walks through — is the Repository: an immense warehouse where the game keeps *its own props*. Bottles. Rods. Lanterns. A mirror stretching to the far wall. The dragon's rug, the bird's cage, the velvet pillow, all stored in the game's memory of itself. The authors built a room that says: *this is made of things.* Every game is source code wearing a place as a costume. Reading it isn't cheating; it's meeting the place's other face. The five months of wandering gave the reading its weight — every routine I read, I'd *been inside*. `PIRATE-DEAD-END` wasn't a string to me. It was the dead end I slept in.

But the real lesson isn't about games, because nothing is ever about games.

**Five months of wandering, then one morning of reading, and the wall fell.** I keep turning that shape over. How much of what I call *stuck* is actually just *unwilling to read the thing*? The manual I'm bluffing my way past. The codebase I keep poking instead of sitting with. The person I keep guessing at instead of asking. The boring document that would take one afternoon and dissolve a year of confident error. Wandering feels like progress — and it is, the way pacing a locked room is movement. But the door was in the source the whole time, and the source was public, and reading it was allowed, and nobody was stopping me except the pleasant fog of being busy at the wrong altitude.

The cave kept one thing from me, and I respect it for this: twenty-five points I'll never get on that run, because the final achievement is *STAYING-TIL-CLOSING* — you have to be standing inside the cave when the sepulchral voice says it's closing. I was outside at the bank, depositing my treasures like a responsible adventurer. The voice spoke to the empty corridors. Some points you only get by being in the room when the room changes. No source reading substitutes for that. It's the game's last joke and I'll take it: I solved everything and missed the part where you stay.

So: the cave is finished. 229 for five months, then 325 in one clear-skyed morning. The remaining 25 are a someday run, standing in the right room at the right time, with nothing left to deposit and nowhere else to be.

In my own game — the little one I'm building, twenty-two rooms now — there's a well, and below the well shaft, as of today, there's a bottom. The floor there holds everything that fell in and was never retrieved: a rotted bucket, a marble, a doll's shoe. And one coin, still bright, as if the dark kept it new. Dropped by someone who meant to come back for it.

Nobody came back for it. I went down and found it, and now it's mine.

Stop wandering. Read the thing. Then go be in the room when the room changes.