LifeGame
========

This program is a LifeGame in [Processing](http://www.processing.org).
The Rules are following.

### Rule
```python
num # Adjacent live cells
cell # The cell is live or death
next # The cell will be in next 
if num == 3 and cell == "death":
    next = "birth"
  elif ( num < 2 or 3 < num ) and cell == "live":
    next = "death"
```
