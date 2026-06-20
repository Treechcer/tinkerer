# Plans

## Gameplay plans

- Add basic progression
- More island types
- Make better sprites
- ...

## future FIXES / bugs rn

- when walking you can kinda phase through object in specific angle (because it check (6?) points and not the whole square) - use AABB like algorithm maybe?
- when you walk and then stop you can be angled incorrectly -- can't recreate, it might be fixed?

### fixed / need testing / need recreation 

- `local en = entities.ents[value.id]` on line 38 in droppedItems.lua can be nil which crashes the game -- this shouldn't happen, if this happen this mean the dropped items is incorrect (which I actually fixed yesterday I think)
