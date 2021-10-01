;;;;    Author:		     Loic Konan
;;;;    Label:		     Project # 1
;;;;    Title:		     Food Chain
;;;;    Course:		     CMPS 4553
;;;;    Semester:	     Summer 2021


extensions [ sound ]                            ; This allow me to access the sound library.

globals [ max-bug ]                             ; don't let the bug population grow too large

breed [ bugs bug ]                              ; bugs breeds of turtles
breed [ birds bird ]                            ; birds breeds of turtles

breed [ flowers flower ]                        ; flowers breeds of turtles
flowers-own [age]

turtles-own [ energy ]                          ; both bugs and birds have energy
patches-own [ countdown ]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; setup procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  ca
    ask patches
    [
      set pcolor one-of [ green grey]           ; Setting the color of the grass
      ifelse pcolor = green
       [ set countdown grass-regrowth-time ]
       [ set countdown random grass-regrowth-time ]
    ]

  create-bugs initial-number-bugs               ; create the bug
  [
    set shape  "ant 2"
    set color blue
    set size 1.5
    set energy random (2 * bug-gain-from-food)
    setxy random-xcor random-ycor
  ]

  create-birds initial-number-birds             ; create the birds
  [
    set shape "hawk"
    set color red
    set size 3
    set energy random (2 * bird-gain-from-food)
    setxy random-xcor random-ycor
  ]
  display-labels
  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; runtime procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  animate                                      ; for the flower.
                                               ; stop the model if there are no birds and no bugs and 50 flowers.
  if not any? birds and count flowers > 50
  [
    sound:play-note "Bird Tweet" 60 64 1       ; Added a bird sound
    user-message "extinction of the birds and the bugs!!!" stop
  ]

                                               ; stop the model if there are no birds and the number of bug gets very large
  if not any? birds and count bugs > max-bug
  [
    sound:play-note "Bird Tweet" 60 64 1       ; Added a bird sound
    user-message "extinction of the birds, The bugs took over this world!!!" stop
  ]

  ask bugs
  [
    move
    set energy energy - 1                      ; deduct energy for bug
    eat-grass                                  ; bug eat grass only
    death                                      ; bug die from starvation
    reproduce-bug                              ; bug reproduce at a random rate governed by a slider
  ]
  ask birds
  [
    move
    set energy energy - 1                      ; birds lose energy as they move
    eat-bug                                    ; birds eat a bug on their patch
    death                                      ; birds die if they run out of energy
    reproduce-birds                            ; birds reproduce at a random rate governed by a slider
  ]

  ask patches [ grow-grass ]

  tick
  display-labels
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Flowers procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to animate
  ask flowers [ age-flower ]                   ; using a random number generator to make the flower grow.
  if random 100 < 20
    [ make-flower ]
end

to age-flower                                  ; flower procedure
   set age (age + 1)                           ; age is used to keep track of how old the flower is
                                               ; each older plant is a little bit taller with a little bit
                                               ; larger leaves and flower.
   if (age >= 16) [ set age 16 ]               ; we only have 16 frames of animation, so stop age at 16
   set shape "flower"
end

to make-flower
                                                ; if every patch has a flower on it, then kill all of them off
                                                ; and start over
  if all? patches [any? flowers-here]
    [ ask flowers [ die ] ]
                                                ; now that we're sure we have room, actually make a new flower
  ask one-of patches with [not any? flowers-here]
  [
    sprout 1
    [
      set size 4
      set breed flowers
      set shape "flower"
      set age 0
      set color one-of [magenta sky yellow]
    ]
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Turtles move procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to move                                          ; turtle procedure
  rt random 360
  lt random 120
  fd 1
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; eat procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to eat-grass                                     ; bug procedure
                                                 ; bug eat grass and turn the patch black
  if pcolor = green
  [
   set pcolor grey                               ; set the color of the grass to that.
   set energy energy + bug-gain-from-food        ; bug gain energy by eating
  ]
end

to reproduce-bug                                ; bug procedure
  if random-float 100 < bug-reproduce
  [                                             ; throw "dice" to see if you will reproduce
    set energy (energy / 2)                     ; divide energy between parent and offspring
    hatch 1 [ rt random-float 360 fd 1 ]        ; hatch an offspring and move it forward 1 step
  ]
end

to reproduce-birds                              ; bird procedure
  if random-float 100 < bird-reproduce
  [                                             ; throw "dice" to see if you will reproduce
    set energy (energy / 2)                     ; divide energy between parent and offspring
    hatch 1 [ rt random-float 360 fd 1 ]        ; hatch an offspring and move it forward 1 step
  ]
end

to eat-bug                                      ; bird procedure
  let prey one-of bugs-here                     ; grab a random bug
  if prey != nobody
  [                                             ; did we get one? if so,
    ask prey [ die ]                            ; kill it, and...
    set energy energy + bird-gain-from-food     ; get energy from eating
  ]
end

to death                                        ; turtle procedure
                                                ; when energy dips below zero, die
  if energy < 0 [ die ]
end

to grow-grass                                   ; patch procedure
                                                ; countdown on black patches: if you reach 0, grow some grass
  if pcolor = grey
  [
    ifelse countdown <= 0
      [ set pcolor green
       set countdown grass-regrowth-time ]
      [ set countdown countdown - 1 ]
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; display energy procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to display-labels
  ask turtles [ set label "" ]                  ; showing the energy of the turtles.
  if show-energy?
  [
    ask birds [ set label round energy ]
    ask bugs [ set label round energy ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
365
10
883
529
-1
-1
10.0
1
14
1
1
1
0
1
1
1
-25
25
-25
25
1
1
1
ticks
30.0

SLIDER
10
215
184
248
initial-number-bugs
initial-number-bugs
0
250
250.0
1
1
NIL
HORIZONTAL

SLIDER
10
285
184
318
bug-gain-from-food
bug-gain-from-food
0.0
50.0
50.0
1.0
1
NIL
HORIZONTAL

SLIDER
10
350
184
383
bug-reproduce
bug-reproduce
1.0
20.0
20.0
1.0
1
%
HORIZONTAL

SLIDER
190
215
355
248
initial-number-birds
initial-number-birds
0
250
5.0
1
1
NIL
HORIZONTAL

SLIDER
190
285
355
318
bird-gain-from-food
bird-gain-from-food
0.0
50
5.0
1.0
1
NIL
HORIZONTAL

SLIDER
190
350
355
383
bird-reproduce
bird-reproduce
0.0
20.0
3.0
1.0
1
%
HORIZONTAL

BUTTON
25
30
94
63
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
250
30
332
63
go/pause
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
910
140
1250
310
populations
time
pop.
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"bug" 1.0 0 -14730904 true "" "plot count bugs"
"bird" 1.0 0 -2674135 true "" "plot count birds"
"flower" 1.0 0 -4079321 true "" "plot count flowers"

MONITOR
925
55
992
100
Bugs
count bugs
3
1
11

MONITOR
1170
55
1237
100
Birds
count birds
3
1
11

TEXTBOX
20
155
160
205
Bugs settings
12
105.0
1

TEXTBOX
270
155
383
173
Birds settings
12
14.0
1

SWITCH
105
75
241
108
show-energy?
show-energy?
1
1
-1000

SLIDER
90
115
262
148
grass-regrowth-time
grass-regrowth-time
0
100
70.0
1
1
NIL
HORIZONTAL

BUTTON
135
30
210
63
go once
go 
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
10
175
107
208
watch a bug
watch one-of bugs\nask subject [ pen-down ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
255
175
352
208
watch a bird
watch one-of birds\nask subject [ pen-down ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1035
55
1122
100
NIL
count flowers
17
1
11

TEXTBOX
1005
20
1155
38
Display Turtles Data
15
14.0
0

@#$#@#$#@
## Name
**Author:**		Loic Konan
**Label:**		Project # 1
**Title:**		Food Chain
**Course:**		CMPS 4553
**Semester:**		Summer 2021

## WHAT IS IT?

 - This is a model that explores a **Food Chain** ecosystem.

1. In this ecosystem the bugs and birds are the **agents**.

2. The grass is the **environment**.

3. For the **interaction** we have: 

	- the bugs eat the grass. 
	-  the birds eat the bugs
	


#### Such system is called unstable if it tends to result in the extinction of one or more species involved or it is called stable if it maintains itself over time.

## HOW IT WORKS

- **Birds** and **Bugs** wander randomly around the landscape.

- Each step costs the **Bugs** and the **Birds energy**.

- Each **Agent / Turtles** must **eat** in order to replenish their **energy**. 

- When they run out of energy they **die**.

- Once the **grass is eaten** it will only **regrow** after a **fixed amount of time**.

- The **Reproductions** of the **Agents** was created using a fixed probability method.

- The **Flowers** are just for decoration.


***One unit of energy is deducted for every step that each Agent takes.***

## HOW TO USE IT

1. Press the **SETUP** button.

2. Press the **GO** button to begin the simulation and to run forever until the model stop.

3. Press the **GO** button again to Pause to the simulation.

4. Press the **GO ONCE** button to advance the model by one tick (time step) unlike the Go button that run forever.

5. Look at the **monitors** to see the current population sizes

6. Look at the **POPULATIONS plot** to watch the populations fluctuate over time.

7. Press the **watch a bug** button to see the path of that specific bug until it dies.

8. Press the **watch a bird** button to see the path of that specific bird until it dies.

	
Added 2 note call: **bugs settings** and **birds settings** to show the locations of each Agent parameters.

#### Adjusting the slider parameters

- **INITIAL-NUMBER-BUGS:** The initial number of the BUGS population

- **INITIAL-NUMBER-BIRDS:** The initial number of the BIRDS population

- **BUGS-GAIN-FROM-FOOD:** The amount of energy BUGS gets for every grass eaten 

- **BIRDS-GAIN-FROM-FOOD:** The amount of energy BIRDS gets for every BUGS eaten

- **BUGS-REPRODUCE:** The probability of a BUGS reproducing at each time step

- **BIRDS-REPRODUCE:** The probability of a BIRDS reproducing at each time step

- **GRASS-REGROWTH-TIME:** How long it takes for grass to regrow once it is eaten.

- **SHOW-ENERGY?:** Whether or not to show the energy of each animal as a number


There are **three monitors** to show the populations of:

1. Birds
2. Bugs
3. Flowers

And **The populations plot** displays the population values over time.



If there are **no Birds left and too many Bugs:** 

	1) the model stops running.
	2) It will Play a sound: "Bird Tweet"
	3) It will Display a message saying: "extinction of the birds, The bugs took over this world!!!"



If there are **no more Bugs, no more Birds left, and the number flowers is more than 50:**

	1) The model stops running.
	2) It will Play a sound: "Bird Tweet"
	3) It will Display a message saying: "extinction of the birds and the bugs."


## THINGS TO NOTICE

1. When there is excess amount of the bugs and about 10% of the birds population, the bugs go extinct before the birds.

2. When there is excess amount of the birds and about 10% of the bugs population, the birds are the only one that go extinct and the bugs inherit the earth.

3. When all the parameters of the bugs are all max out and the the parameters of the birds are around 5% with the growth time of the grass at 70 we have the most stable ecosystem so far **(4000 years)**. 

## THINGS TO TRY

1. Try adjusting the parameters under various settings.

2. Try using the watch a bug or watch a bird button to see the after math on the screen.

2. Try finding the right parameters that will generate a stable ecosystem for more than 1000 years.


## EXTENDING THE MODEL

- Maybe by adding few more agents: ***bees, rats and human***.

- Maybe by adding ***water and moving clouds*** to the environment.

- Maybe by adding ***more rules*** and making this model more realistic


## NETLOGO FEATURES

- Note the use of **breeds** to model two different kinds of "turtles": **Birds** and **Bugs**. 

- Note the use of **patches** to model grass.

- Note the use of **"watch a bug"** and **"watch a bird"**, to follow a turtle path until it die.


## RELATED MODELS

Look at ***"Rabbits Grass Weeds"*** for another model of interacting populations with different rules.

Look at ***“sheep-wolves-grass”*** for another model of interacting populations with different rules.

## CREDITS AND REFERENCES

Wilensky, U., & Rand, W. (2015). An introduction to agent-based modeling: Modeling natural, social and engineered complex systems with NetLogo. Cambridge, MA: MIT Press.

Lotka, A. J. (1925). Elements of physical biology. New York: Dover.

Volterra, V. (1926, October 16). Fluctuations in the abundance of a species considered mathematically. Nature, 118, 558–560.

Gause, G. F. (1934). The struggle for existence. Baltimore: Williams & Wilkins.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant 2
true
0
Polygon -7500403 true true 150 19 120 30 120 45 130 66 144 81 127 96 129 113 144 134 136 185 121 195 114 217 120 255 135 270 165 270 180 255 188 218 181 195 165 184 157 134 170 115 173 95 156 81 171 66 181 42 180 30
Polygon -7500403 true true 150 167 159 185 190 182 225 212 255 257 240 212 200 170 154 172
Polygon -7500403 true true 161 167 201 150 237 149 281 182 245 140 202 137 158 154
Polygon -7500403 true true 155 135 185 120 230 105 275 75 233 115 201 124 155 150
Line -7500403 true 120 36 75 45
Line -7500403 true 75 45 90 15
Line -7500403 true 180 35 225 45
Line -7500403 true 225 45 210 15
Polygon -7500403 true true 145 135 115 120 70 105 25 75 67 115 99 124 145 150
Polygon -7500403 true true 139 167 99 150 63 149 19 182 55 140 98 137 142 154
Polygon -7500403 true true 150 167 141 185 110 182 75 212 45 257 60 212 100 170 146 172

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bird
false
0
Polygon -7500403 true true 135 165 90 270 120 300 180 300 210 270 165 165
Rectangle -7500403 true true 120 105 180 237
Polygon -7500403 true true 135 105 120 75 105 45 121 6 167 8 207 25 257 46 180 75 165 105
Circle -16777216 true false 128 21 42
Polygon -7500403 true true 163 116 194 92 212 86 230 86 250 90 265 98 279 111 290 126 296 143 298 158 298 166 296 183 286 204 272 219 259 227 235 240 241 223 250 207 251 192 245 180 232 168 216 162 200 162 186 166 175 173 171 180
Polygon -7500403 true true 137 116 106 92 88 86 70 86 50 90 35 98 21 111 10 126 4 143 2 158 2 166 4 183 14 204 28 219 41 227 65 240 59 223 50 207 49 192 55 180 68 168 84 162 100 162 114 166 125 173 129 180

bird side
false
0
Polygon -7500403 true true 0 120 45 90 75 90 105 120 150 120 240 135 285 120 285 135 300 150 240 150 195 165 255 195 210 195 150 210 90 195 60 180 45 135
Circle -16777216 true false 38 98 14

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -8630108 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

hawk
true
0
Polygon -7500403 true true 151 170 136 170 123 229 143 244 156 244 179 229 166 170
Polygon -16777216 true false 152 154 137 154 125 213 140 229 159 229 179 214 167 154
Polygon -7500403 true true 151 140 136 140 126 202 139 214 159 214 176 200 166 140
Polygon -16777216 true false 151 125 134 124 128 188 140 198 161 197 174 188 166 125
Polygon -7500403 true true 152 86 227 72 286 97 272 101 294 117 276 118 287 131 270 131 278 141 264 138 267 145 228 150 153 147
Polygon -7500403 true true 160 74 159 61 149 54 130 53 139 62 133 81 127 113 129 149 134 177 150 206 168 179 172 147 169 111
Circle -16777216 true false 144 55 7
Polygon -16777216 true false 129 53 135 58 139 54
Polygon -7500403 true true 148 86 73 72 14 97 28 101 6 117 24 118 13 131 30 131 22 141 36 138 33 145 72 150 147 147

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
set model-version "sheep-wolves-grass"
set show-energy? false
setup
repeat 75 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
