;;;;    Author:		     Loic Konan
;;;;    Label:		     Project # 2
;;;;    Title:		     Hot Spots
;;;;    Course:		     CMPS 4553
;;;;    Semester:	     Summer 2021

extensions [ sound ]                      ; This allow me to access the sound library.

breed [ fish a-fish ]
breed [ bees bee ]
breed [ humans human ]
breed [ birds bird ]

breed [ raindrops raindrop ]

turtles-own [ energy ]                    ; energy

globals
[
  region-boundaries                       ; a list of regions definitions, where each region is a list of its min pxcor and max pxcor
]

patches-own
[
  region                                  ; the number of the region that the patch is in, patches outside all regions have region = 0
]



to setup
  ca
  setup-regions number-of-regions         ; Letting the user pick the number of region they want.
  color-regions                           ; To set the regions colors.
  setup-turtles                           ; Finally, distribute the turtles in the different regions
  set-default-shape raindrops "circle"

  display-labels
  reset-ticks
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go

   if not any? turtles
  [
     sound:play-note "Applause" 60 64 3   ; a round of applause for 4 seconds
     user-message "END of This Universe!!!" stop
  ]

  ask turtles
  [
    move
    set energy energy - 1                     ; deduct energy for bug

    if sun-brightness > 2                     ; if the sun brightness parameters is more than 3
    [
       set energy energy - 10                 ; deduct energy for bug
    ]

    death                                     ; kill the turtles if out of energy
  ]

  make-rain-fall                              ; the rain function
  tick
  display-labels
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Making different color for each region procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to color-regions
  ask patches with [ region != 0 ]            ; set the color of each region except region 0
  [
    if region = 1
    [
      set pcolor black
;      ask patch ( -22) (0.5 * max-pycor)     ; Code to Label which world or region that you are looking at.
;      [
;       set plabel-color white
;       set plabel "Human World"
;      ]
    ]

    if region = 2
    [
      set pcolor  white
;      ask patch (-1) (0.5 * max-pycor)        ; Code to Label which world or region that you are looking at.
;      [
;       set plabel-color black
;       set plabel "Bugs world"
;      ]
    ]

   if region = 4
    [
      set pcolor  blue

;      ask patch (14) (0.5 * max-pycor)        ; Code to Label which world or region that you are looking at.
;      [
;       set plabel-color red
;       set plabel "Birds world"
;      ]
    ]

    if region = 3
    [
      set pcolor  green

;      ask patch (25) (0.5 * max-pycor)        ; Code to Label which world or region that you are looking at.
;      [
;       set plabel-color black
;       set plabel "Fish world"
;      ]
    ]
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Creating the Turtles procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to setup-turtles                               ; This procedure simply creates turtles in the different regions.

  foreach (range 1 (length region-boundaries + 1))
  [
    region-number ->
    let region-patches patches with [ region = region-number ]
    create-turtles number-of-turtles-per-region
    [
      set energy initial-turtles-energy                ; setting the initial parameters of the turtles energy.
      if region = 0                                    ; This region is the Fish region
      [
       setxy random-xcor random-ycor
       set shape "fish 3"
       set size 2
       move-to one-of region-patches                   ; make sure they don't leave their regions
      ]

      if region = 2                                    ; The bees region or world
      [
       setxy random-xcor random-ycor
       set shape "bee 2"
       set size 2
       move-to one-of region-patches                   ; make sure they don't leave their regions
     ]

      if region = 1                                    ; This is the humans region or world
      [
       setxy random-xcor random-ycor
       set shape "person graduate"
       set size 2.5
       move-to one-of region-patches                   ; make sure they don't leave their regions
     ]

      if region = 3                                    ; This is the bird region.
      [
       setxy random-xcor random-ycor
       set shape "hawk"
       set size 2
       move-to one-of region-patches                   ; make sure they don't leave their regions
     ]
   ]
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Move procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to move                                                ; turtle procedure

  let current-region region                            ; Then, after saving the region, we can move the turtle:

    if region = 1
    [
     ifelse region1-temperature < 50                   ; If you in regiion 1 and the temperature is less than 50 you move normally
     [
      rt random 20
      left random 20
      fd .2
     ]
      [
      set energy energy - 10                           ; If you in regiion 1 and the temperature is more than 50 you hot so you will move fast and die early.
      rt random 20
      left random 20
      fd 2
     ]
    ]

    if region = 2
    [
        ifelse region2-temperature < 50                ; If you in regiion 2 and the temperature is less than 50 you move normally
     [
      rt random 20
      left random 20
      fd .2
     ]
      [
       set energy energy - 10                          ; If you in regiion 2 and the temperature is more than 50 you hot so you will move fast and die early.
       rt random 20
       left random 20
       fd 1.5
     ]
    ]

    if region = 3
    [
         ifelse region3-temperature < 50               ; If you in regiion 3 and the temperature is less than 50 you move normally
     [
       rt random 20
       left random 20
       fd .2
     ]
      [
       set energy energy - 10                          ; If you in regiion 3 and the temperature is more than 50 you hot so you will move fast and die early.
       rt random 20
       left random 20
       fd 1.5
     ]
    ]

    if region = 4
    [
        ifelse region4-temperature < 50                ; If you in regiion 4 and the temperature is less than 50 you move normally
     [
      rt random 20
      left random 20
      fd .2
     ]
      [
       set energy energy - 10                          ; If you in regiion 4 and the temperature is more than 50 you hot so you will move fast and die early.
       rt random 20
       left random 20
       fd 2
     ]
    ]

 keep-in-region current-region                                          ; stays in the region.

end


to setup-regions [ num-regions ]

  foreach region-divisions num-regions draw-region-division             ; First, draw some dividers at the intervals reported by `region-divisions`

  set region-boundaries calculate-region-boundaries num-regions         ; Store our region definitions globally for faster access:

  let region-numbers (range 1 (num-regions + 1))                        ; Set the `region` variable for all patches included in regions
  (foreach region-boundaries region-numbers
    [
      [boundaries region-number] ->
    ask patches with [ pxcor >= first boundaries and pxcor <= last boundaries ]
     [
      set region region-number
     ]
    ]
  )
end

to-report calculate-region-boundaries [ num-regions ]

  let divisions region-divisions num-regions
                                               ; Each region definition lists the min-pxcor and max-pxcor of the region.
                                               ; To get those, we use `map` on two "shifted" copies of the division list,
                                               ; which allow us to scan through all pairs of dividers
                                               ; and built our list of definitions from those pairs:
  report (map [ [d1 d2] -> list (d1 + 1) (d2 - 1) ] (but-last divisions) (but-first divisions))
end

to-report region-divisions [ num-regions ]
                                               ; This procedure reports a list of pxcor that should be outside every region.
                                               ; Patches with these pxcor will act as "dividers" between regions.
  report n-values (num-regions + 1)
  [
    n -> [ pxcor ] of patch (min-pxcor + (n * ((max-pxcor - min-pxcor) / num-regions))) 0
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Dividing the screen procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to draw-region-division [ x ]

  create-turtles 1
  [
    setxy x max-pycor + 0.5                     ; use a temporary turtle to draw a line in the middle of our division
    set heading 0
    pen-down
    forward world-height
    set xcor xcor + 1 / patch-size
    right 180
    forward world-height
    die                                         ; our turtle has done its job and is no longer needed
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Making sure each agents stay in their region procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to keep-in-region [ which-region ]              ; turtle procedure

                                                ; This is the procedure that make sure that turtles don't leave the region they're
                                                ; supposed to be in. It is your responsibility to call this whenever a turtle moves.
  if region != which-region
  [
                                                ; Get our region boundaries from the global region list:
    let region-min-pxcor first item (which-region - 1) region-boundaries
    let region-max-pxcor last item (which-region - 1) region-boundaries
                                                ; The total width is (min - max) + 1 because `pxcor`s are in the middle of patches:
    let region-width (region-max-pxcor - region-min-pxcor) + 1
    ifelse xcor < region-min-pxcor [            ; if we crossed to the left,
      set xcor xcor + region-width              ; jump to the right boundary
    ]
    [
      if xcor > region-max-pxcor
      [   ; if we crossed to the right,
        set xcor xcor - region-width            ; jump to the left boundary
      ]
    ]
  ]

end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Making the rain procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to make-rain-fall

  create-raindrops rain-intensity               ; Create new raindrops at the top of the world
  [
    setxy random-xcor max-pycor
    set heading 180                             ; set the direction to down
    fd 0.5 - random-float 1.0
    set size .3                                 ; set the size.
    set color white                             ; set the color.
  ]

  ask raindrops [ fd random-float 2 ]
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; The Death procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to death                                        ; turtle procedure
                                                ; when energy dips below zero, die
  if energy < 0 [ die ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; display energy procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to display-labels
  ask turtles [ set label "" ]                  ; showing the energy of the turtles.
  if show-energy?
  [
    ask turtles   [ set label round energy ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
290
60
1143
498
-1
-1
13.0
1
20
1
1
1
0
1
1
1
-32
32
-16
16
1
1
1
ticks
30.0

BUTTON
25
10
98
43
NIL
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

SLIDER
25
145
250
178
number-of-turtles-per-region
number-of-turtles-per-region
1
100
2.0
1
1
NIL
HORIZONTAL

BUTTON
105
10
177
43
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
185
10
272
43
go / pause
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

BUTTON
25
55
132
88
watch a Turtle
watch one-of turtles\nask subject [ pen-down ]
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
150
55
267
88
Stop Watching
ask turtles [ pen-up ]\nreset-perspective\nclear-drawing
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
315
20
492
53
region1-temperature
region1-temperature
0
110
43.0
1
1
°F
HORIZONTAL

SLIDER
525
20
707
53
region2-temperature
region2-temperature
0
110
47.0
1
1
°F
HORIZONTAL

SLIDER
735
20
917
53
region3-temperature
region3-temperature
0
110
44.0
1
1
°F
HORIZONTAL

SLIDER
945
20
1127
53
region4-temperature
region4-temperature
0
110
35.0
1
1
°F
HORIZONTAL

CHOOSER
70
95
208
140
number-of-regions
number-of-regions
1 2 3 4
3

SWITCH
80
270
212
303
show-energy?
show-energy?
1
1
-1000

SLIDER
55
185
227
218
initial-turtles-energy
initial-turtles-energy
500
3000
3000.0
1
1
NIL
HORIZONTAL

PLOT
55
310
255
460
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
"death" 1.0 0 -5298144 true "" "plot count turtles "

SLIDER
75
465
247
496
rain-intensity
rain-intensity
0
30
0.0
1
1
NIL
HORIZONTAL

SLIDER
60
230
232
263
sun-brightness
sun-brightness
0
5
0.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## Name
**Author:**		Loic Konan
**Label:**		Project # 2
**Title:**		Hot Spots
**Course:**		CMPS 4553
**Semester:**		Summer 2021


## WHAT IS IT?

- This is a model that shows how to **divide the world in regions** and keep different turtles confined to the region they start in.
- It also show how each turtles react to **different temperatures**.

1. **agents** are BIRDS, HUMANS, BEES, FISH.

2. we have different **environment** different colors..

3. For the **interaction** each agents just move randomly, then lose energy when they move.

## HOW IT WORKS

- The world is separated in regions divided by vertical lines.

- When a turtle reaches the left or right boundary of a region, it crosses to the other side.

- Turtles move fast depending on how hot the temperature is or other parameters in the interface.

- Each turtle lose energy when they move so the faster they move the more energy they lose.
 
- when the turtle run out of energy they die.

## HOW TO USE IT

Choose the **NUMBER-OF-REGIONS**, the **NUMBER-OF-TURTLES-PER-REGION**, the **INITIAL-TURTLE-ENERGY**, and decide how hot you want to make a particular region that you want, click SETUP, and then GO.

- Press the **SETUP** button.
- Press the **GO** button to begin the simulation and to run forever until the model stop.
- Press the **GO** button again to Pause to the simulation.
- Press the **GO ONCE** button to advance the model by one tick (time step) unlike the Go button that run forever.

- Look at the **Monitor** to see the **death** toll.
- Press the **watch a turtle** button to see the path of that specific turtle until it dies.
- Press the **stop watching** to erase that path created previously.

**Adjusting the slider parameters**

- **INITIAL-TURTLE-ENERGY** the energy of each Agents to start the model.
- **NUMBER-OF-TURTLES-PER-REGION:** The initial number of the turtle population in each region.
- **NUMBER-OF-REGIONS:** the number of region to look at.
- **REGION#-TEMPERATURE** the temperature of each region.(parameter that the user can set) that will affect how fast the agents move.

- **SUN-BRIGHTNESS**: to set how hot the sun is and make the agents move faster.
- **SHOW-ENERGY?:** Whether or not to show the energy 

If there are no more Agents:

   1) the model stops running. 
   2) It will Play a sound: "Applause" for 3 seconds. 
   3) It will Display a message saying: "END of This Universe!!!

## THINGS TO NOTICE

- If an agent migrate to a different region that is colder it tends to live longer because it will not be wasting as much energy. 

## THINGS TO TRY

- if you make the human world very hot they will migrate to other regions

## EXTENDING THE MODEL

- Maybe to make it into one big rectangle with different circle regions inside. 

- Maybe import a picture of the planet or the picture of a continent and make the environment for the agents.

- Maybe making "grid" of regions, where you would specify a number of rows and a number of columns?


## NETLOGO FEATURES

- Note the use of **“watch a turtle”** follow a turtle and draw a path until it die.
- The use of **“stop watching”** delete the path that was made by **"watch a turtle"**.

## RELATED MODELS

- The **Bug Hunt** models in the ModelSim folder of the library use a version of this code to separate the bugs in two distinct regions.

- Look at **“Autumn”** for another model of multiple regions.


## CREDITS AND REFERENCES
Wilensky, U. (2005). NetLogo Autumn model. http://ccl.northwestern.edu/netlogo/models/Autumn. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

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

bee 2
true
0
Polygon -1184463 true false 195 150 105 150 90 165 90 225 105 270 135 300 165 300 195 270 210 225 210 165 195 150
Rectangle -16777216 true false 90 165 212 185
Polygon -16777216 true false 90 207 90 226 210 226 210 207
Polygon -16777216 true false 103 266 198 266 203 246 96 246
Polygon -6459832 true false 120 150 105 135 105 75 120 60 180 60 195 75 195 135 180 150
Polygon -6459832 true false 150 15 120 30 120 60 180 60 180 30
Circle -16777216 true false 105 30 30
Circle -16777216 true false 165 30 30
Polygon -7500403 true true 120 90 75 105 15 90 30 75 120 75
Polygon -16777216 false false 120 75 30 75 15 90 75 105 120 90
Polygon -7500403 true true 180 75 180 90 225 105 285 90 270 75
Polygon -16777216 false false 180 75 270 75 285 90 225 105 180 90
Polygon -7500403 true true 180 75 180 90 195 105 240 195 270 210 285 210 285 150 255 105
Polygon -16777216 false false 180 75 255 105 285 150 285 210 270 210 240 195 195 105 180 90
Polygon -7500403 true true 120 75 45 105 15 150 15 210 30 210 60 195 105 105 120 90
Polygon -16777216 false false 120 75 45 105 15 150 15 210 30 210 60 195 105 105 120 90
Polygon -16777216 true false 135 300 165 300 180 285 120 285

bird side
false
0
Polygon -13840069 true false 0 120 45 90 75 90 105 120 150 120 240 135 285 120 285 135 300 150 240 150 195 165 255 195 210 195 150 210 90 195 60 180 45 135
Circle -2674135 true false 38 98 14

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
Polygon -1184463 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -13840069 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -13840069 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -2064490 true false 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

fish 2
false
0
Polygon -1 true false 56 133 34 127 12 105 21 126 23 146 16 163 10 194 32 177 55 173
Polygon -7500403 true true 156 229 118 242 67 248 37 248 51 222 49 168
Polygon -7500403 true true 30 60 45 75 60 105 50 136 150 53 89 56
Polygon -7500403 true true 50 132 146 52 241 72 268 119 291 147 271 156 291 164 264 208 211 239 148 231 48 177
Circle -1 true false 237 116 30
Circle -16777216 true false 241 127 12
Polygon -1 true false 159 228 160 294 182 281 206 236
Polygon -7500403 true true 102 189 109 203
Polygon -1 true false 215 182 181 192 171 177 169 164 152 142 154 123 170 119 223 163
Line -16777216 false 240 77 162 71
Line -16777216 false 164 71 98 78
Line -16777216 false 96 79 62 105
Line -16777216 false 50 179 88 217
Line -16777216 false 88 217 149 230

fish 3
false
0
Polygon -13840069 true false 137 105 124 83 103 76 77 75 53 104 47 136
Polygon -13840069 true false 226 194 223 229 207 243 178 237 169 203 167 175
Polygon -13840069 true false 137 195 124 217 103 224 77 225 53 196 47 164
Polygon -1184463 true false 40 123 32 109 16 108 0 130 0 151 7 182 23 190 40 179 47 145
Polygon -2064490 true false 45 120 90 105 195 90 275 120 294 152 285 165 293 171 270 195 210 210 150 210 45 180
Circle -1184463 true false 244 128 26
Circle -16777216 true false 248 135 14
Line -16777216 false 48 121 133 96
Line -16777216 false 48 179 133 204
Polygon -13840069 true false 241 106 241 77 217 71 190 75 167 99 182 125
Line -16777216 false 226 102 158 95
Line -16777216 false 171 208 225 205
Polygon -11221820 true false 252 111 232 103 213 132 210 165 223 193 229 204 247 201 237 170 236 137
Polygon -11221820 true false 135 98 140 137 135 204 154 210 167 209 170 176 160 156 163 126 171 117 156 96
Polygon -16777216 true false 192 117 171 118 162 126 158 148 160 165 168 175 188 183 211 186 217 185 206 181 172 171 164 156 166 133 174 121
Polygon -11221820 true false 40 121 46 147 42 163 37 179 56 178 65 159 67 128 59 116

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
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
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
Polygon -1 true false 151 170 136 170 123 229 143 244 156 244 179 229 166 170
Polygon -16777216 true false 152 154 137 154 125 213 140 229 159 229 179 214 167 154
Polygon -1 true false 151 140 136 140 126 202 139 214 159 214 176 200 166 140
Polygon -16777216 true false 151 125 134 124 128 188 140 198 161 197 174 188 166 125
Polygon -2674135 true false 152 86 227 72 286 97 272 101 294 117 276 118 287 131 270 131 278 141 264 138 267 145 228 150 153 147
Polygon -2674135 true false 160 74 159 61 149 54 130 53 139 62 133 81 127 113 129 149 134 177 150 206 168 179 172 147 169 111
Circle -16777216 true false 144 55 7
Polygon -16777216 true false 129 53 135 58 139 54
Polygon -2674135 true false 148 86 73 72 14 97 28 101 6 117 24 118 13 131 30 131 22 141 36 138 33 145 72 150 147 147

hex
false
0
Polygon -7500403 true true 0 150 75 30 225 30 300 150 225 270 75 270

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

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -6459832 true false 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57
Circle -6459832 true false 135 45 0
Circle -2674135 true false 135 45 0
Circle -6459832 true false 135 45 0
Circle -2674135 true false 150 30 30
Circle -2674135 true false 120 30 30
Rectangle -2674135 true false 150 60 150 75
Rectangle -16777216 true false 135 60 165 75

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

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

shark
false
4
Polygon -16777216 true false 283 153 288 149 271 146 301 145 300 138 247 119 190 107 104 117 54 133 39 134 10 99 9 112 19 142 9 175 10 185 40 158 69 154 64 164 80 161 86 156 132 160 209 164
Polygon -1 true false 199 161 152 166 137 164 169 154
Polygon -1 true false 188 108 172 83 160 74 156 76 159 97 153 112
Circle -16777216 true false 256 129 12
Line -16777216 false 222 134 222 150
Line -16777216 false 217 134 217 150
Line -16777216 false 212 134 212 150
Polygon -1 true false 78 125 62 118 63 130
Polygon -1 true false 121 157 105 161 101 156 106 152

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
