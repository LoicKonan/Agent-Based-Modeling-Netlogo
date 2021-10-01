;;;;    Author:		     Loic Konan
;;;;    Label:		     Project # 3
;;;;    Title:		     Prairie Dogs
;;;;    Course:		     CMPS 4553
;;;;    Semester:	     Summer 2021


extensions [ sound ]

breed [ clouds cloud ]
clouds-own [cloud-speed cloud-id ]

breed [ suns sun ]
breed [ moons moon ]
breed [ stars star ]
breed [ raindrops raindrop ]

breed [ squirrels squirrel]
breed [ rabbits rabbit ]
rabbits-own [ rabbits-speed ]
breed [ mice mouse ]
mice-own [ target mice-speed]

breed [ birds bird ]
birds-own [ birds-speed]

breed [ Butterflies butterfly ]
Butterflies-own[ Butterflies-speed ]

breed [ flowers flower ]
breed [ plants plant ]
breed [ trees tree ]
breed [ holes hole ]                                   ;; the holes
breed [ tiles tile ]

globals
[
  sky-bottom                                           ;; y coordinate of top row of sky
  ground                                               ;; Green land
]

;;;;;;;;;; Setup Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  set-default-shape clouds "cloud"
  set-default-shape raindrops "circle"
  set-default-shape holes "hole"

  setup-world
  setup-trees
  setup-flowers
  setup-plants
  add-sun
  setup-tiles


  create-birds initial-number-birds                    ;; create the birds
  [
    set birds-speed (random-float 0.5) + 0.01          ;; build a speed for the birds
    set shape "bird side"
    set color one-of [ red lime magenta  cyan orange violet ]
    set size 3
    setxy (random 8 - random 12) (random 14 - random 1)
    set heading one-of [ -88 -89 -91 -92 -98 -93 -96  -90 ]  ;; the direction of the birds
  ]

  create-butterflies initial-number-butterflies        ;; create the butterflies
  [
    set butterflies-speed  (random-float 0.1) + 0.01   ;; build a speed for the butterflies.
    set shape "butterfly 2"
    set color one-of [magenta orange sky yellow]
    set size 1
    setxy random-xcor -10 + random 10                  ;; start them in the green land
    set heading one-of [ -88 -89 -91 -92 -98 -93 -96  -90 ]
  ]

  create-ordered-holes number-of-holes                 ;; create the holes.
  [
    fd max-pxcor
    set size 6 + random-float 0.15
    setxy random-xcor -14 + random 10                  ;; random location of the holes
    fd random-float 1 + .45                            ;; move the hole shape a bit within the patch
  ]

  create-mice Prairie-Dogs                             ;; create the Prairie Dogs
  [
    set mice-speed (random-float 0.15) + .01           ;; build a speed for the dogs
    set shape "rabbit"
    set size 2 + random-float 0.15
    set color brown
    setxy (max-pxcor - random 20) (max-pycor -  25)

    set target one-of holes
    face target
  ]

  create-rabbits number-of-hide                        ;; create the Prairie Dogs
  [
    set rabbits-speed (random-float 0.15) + .01        ;; build a speed for the dogs
    set shape "rabbit"                                 ;; using rabbit
    set size 2 + random-float 0.15
    set color brown
    setxy random-xcor -14 + random 10;(max-pxcor - random 20) (max-pycor -  25)
    set heading one-of [ -91 -92 -93 -90 ]
  ]
  reset-ticks
end

;;;;;;;;;;;;;;;;;;;;;;;;;; the hatch procedure ;;;;;;;;;;;;;;;;;;;;;;

;to born-mice
;  if random-float 1 < born-mouse
;  [
;    hatch 1
;    [
;      setxy (max-pxcor - random 20) (max-pycor -  25)
;      set mice-speed (random-float 0.15) + .01
;    ]
;  ]
;end

to add-sun
 ifelse sun?                                           ;; If the user pick the sun
 [
    create-suns 1                                      ;; Create a sun
    [
     set shape "sun"
     setxy (max-pxcor - 2) (max-pycor - 3)
     set size 4
     set color yellow
    ]
  ]

  [
    create-moons 1                                     ;; else create the moon for the user.
    [
      set shape "moon"
      setxy (max-pxcor - 30) (max-pycor - 3)
      set size 4
      set color white
    ]

    create-stars 15                                    ;; create some stars.
    [
      set shape "star"
      set color one-of [ yellow white grey ]           ;; Pick random colors between white-grey-yellow
      setxy (max-pxcor - random 32) (max-pycor - random 10)
      fd random-float .45                              ;; move the stars shape a bit within the sky.
      set size 1 + random-float 0.15
    ]
  ]
end



to setup-world
   set sky-bottom 0                                    ;; Setting the sky
   set ground max-pycor                                ;; the green land

  ask patches                                          ;; set colors for the different sections of the world
  [
    ifelse Day-time?                                   ;; If day time show suns and nice blue sky
    [
      if pycor <= ground and pycor >= sky-bottom       ;; sky
      [                                                ;; Reports a shade of color proportional to the value of number.
        set pcolor scale-color blue pycor -20 20       ;; If a range of numbes the larger the number, the lighter the shade of color or inverted.
      ]

      if pycor <= sky-bottom [ set pcolor green - 2 ]  ;; Green land
    ]

    [
      if pycor <= ground and pycor >= sky-bottom       ;; If night time show the moon and dark sky
      [                                                ;; Reports a shade of color proportional to the value of number.
        set pcolor black                               ;; set the color
      ]

      if pycor <= sky-bottom  [ set pcolor green - 2 ] ;; Green land
    ]
  ]
end

;;;;;;;;;;;;;;; Runtime Procedures ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
  ask clouds [ fd cloud-speed ]                        ;; move clouds along
  make-snow-fall

  ask birds
  [
    fd birds-speed
  ]

  ask butterflies
  [
    fd butterflies-speed
  ]

  ask rabbits
  [
    if mouse-down?
    [
      set shape "squirrel"
       set heading one-of [ 89 91 90 ]
    ]
      fd rabbits-speed
  ]

  ask mice
  [
    fd mice-speed                                     ;; they regular speed
    rt -92
    left -89

    if mouse-down?
    [
     set shape "squirrel"
     set size 2
     sound:play-note "Distortion Guitar" 60 64 1        ;; play the alarm

      ifelse distance target < 2                            ;; if at target, choose a new random target
      [
          ask  n-of 1 mice  [hide-turtle ]
      ]

      [
        fd mice-speed + .1
        rt -92
        left -89
      ]
     ]
    ]

  tick
end


;;;;;;;;;;;;;;; Building the clouds ;;;;;;;;;;;;;;;;;;;;;;;

to add-cloud
  let y ground + (random-float (4)) + 23               ;; random altitude for the clouds but in the sky.
  let x random-xcor
  let id 0                                             ;; id for each cloud.
  if any? clouds
  [ set id max [cloud-id] of clouds + 1 ]

  create-clouds number-clouds                          ;; create the clouds.
  [
    set cloud-speed(random-float 0.1) + 0.01           ;; no clouds should have speed 0
    set cloud-id id                                    ;; number each cloud to make it easy
    setxy x + random 9 - 4                             ;; x-cor of the clouds
    y + 2.5 + random-float 2 - random-float 2          ;; y-cor of the clouds.
    set color white                                    ;; setting the color of the clouds
    set size 2 + random 2                              ;; setting the size of the clouds
    set heading 90                                     ;; setting the direction of the clouds to the right
  ]
end

;;;;;;;;;;;;;;;;; Making it snow ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to make-snow-fall
  create-raindrops snow-intensity                      ;; Create raindrops
  [
    setxy random-xcor max-pycor
    set heading 180                                    ;; direction top down.
    fd 0.5 - random-float 1.0
    set size .3
    set color white
  ]
  ask raindrops [ fd random-float 2 ]                  ;; moves
end


;;;;;;;;;;;;;;;;;;; Making the environment a little nice ;;;;;;;;;;;;

to setup-flowers
    create-flowers 15                                  ;;  Create 15 random flowers
    [
      set color one-of [magenta orange sky yellow]     ;; pick one of the color randomly
      setxy 3 + random-xcor -15 + random 12            ;; stay in the green land
      set shape "flower"
      fd random-float .45                              ;; move the grass shape a bit within the patch
      set size 2 + random-float 0.15
   ]
end

to setup-tiles                                         ;; build the wall
  create-tiles 30
  [
    set color brown
    set shape "tile brick"
    set size 5
    setxy random 30 35                                 ;; location of the brick wall

  ]
end


to setup-trees
    create-trees 5
    [
      setxy random-xcor -10 + random 9                  ;; location of the trees
      set shape "tree"
      fd random-float .45                               ;; move the grass shape a bit within the patch
      set size 3 + random-float 0.15
   ]
end

to setup-plants
    create-plants 5
    [
      set color one-of [magenta orange sky yellow]      ;; pick one of the color randomly
      setxy random-xcor -11 + random 10                 ;; stay in the green land
      set shape "plant"
      fd random-float .45                               ;; move the grass shape a bit within the patch
      set size 3 + random-float 0.15
   ]
end
@#$#@#$#@
GRAPHICS-WINDOW
273
10
710
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
13
10
76
43
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
87
11
177
44
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
188
11
263
44
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

SLIDER
48
343
220
376
snow-intensity
snow-intensity
0
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
51
459
223
492
initial-number-birds
initial-number-birds
0
10
10.0
1
1
NIL
HORIZONTAL

SLIDER
50
265
222
298
number-clouds
number-clouds
12
30
15.0
3
1
NIL
HORIZONTAL

BUTTON
88
298
180
331
NIL
add-cloud\n
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
43
401
228
434
initial-number-butterflies
initial-number-butterflies
0
10
5.0
1
1
NIL
HORIZONTAL

SWITCH
15
59
126
92
Day-time?
Day-time?
0
1
-1000

SWITCH
158
59
261
92
sun?
sun?
0
1
-1000

SLIDER
47
203
219
236
number-of-holes
number-of-holes
0
15
3.0
1
1
NIL
HORIZONTAL

SLIDER
47
158
219
191
Prairie-Dogs
Prairie-Dogs
0
15
3.0
1
1
NIL
HORIZONTAL

TEXTBOX
97
98
247
116
Prairie-Dogs
13
15.0
1

TEXTBOX
102
244
252
262
environment
13
15.0
1

SLIDER
274
461
446
494
number-of-hide
number-of-hide
0
15
0.0
1
1
%
HORIZONTAL

BUTTON
8
116
136
149
watch-Prarie-Dog
watch one-of mice
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
145
116
255
149
stop-watching
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
538
461
710
494
born-mouse
born-mouse
0.0
15
9.0
1.0
1
%
HORIZONTAL

TEXTBOX
106
382
256
400
Butterflies
13
15.0
1

TEXTBOX
118
443
268
461
Birds
13
15.0
1

@#$#@#$#@
## Name
**Author:**		Loic Konan
**Label:**		Project # 3
**Title:**		Prairie Dogs
**Course:**		CMPS 4553
**Semester:**		Summer 2021

## WHAT IS IT?

 - This is a model Simulate a prairie dog habitat.

1. In this ecosystem the Prairie Dogs, Butterflies and Birds are the **agents**.

2. The grass, sky are the **environment**.

3. For the **interaction** we have: 

	- The Prairie Dogs make an alarm and run around the landscape to go hide in their holes.
	

## HOW IT WORKS

- **Birds** and **Butterflies** and **Prairie Dogs** wander randomly around the landscape.

- When the mouse is down the Prairie dogs make an alarm and they go hide.


## HOW TO USE IT

1. Press the **SETUP** button.

2. Press the **GO** button to begin the simulation and to run forever until the model stop.

3. Press the **GO** button again to Pause to the simulation.

4. Press the **GO ONCE** button to advance the model by one tick (time step) unlike the Go button that run forever.

7. Press the **watch a Prairie Dog** button to see the path of that specific prairie dog

8. Press the **stop watching** button to stop watching the one Prairie dog.


#### Adjusting the slider parameters

- **Prairie Dogs:** The initial number of the Prairie Dogs population

- **INITIAL-NUMBER-BIRDS:** The initial number of the BIRDS population  

- **INITIAL-NUMBER-BUTTERFLIES:** The initial number of the BUTTERFLIES population

- **DAY-TIME?:** This switch make it a day time or it will display the night time.

- **SUN?:** This switch ask if sun? if not it will display the moon with few stars

- **NUMBER-OF-HOLES:** The number of holes for the Prairie dogs.

- **SNOW-INTENSITY:** How much snow you want to fall from the sky.

- **ADD-CLOUD:** This one is a butter that Make few clouds and make them move left to right.


## THINGS TO TRY

1. Try adjusting the parameters under various settings.

2. Try using the watch a Prairie Dogs.

3. Try changing to day time or night time and make it snow or rain. 


## EXTENDING THE MODEL

- Maybe by adding few more agents: ***bees, cars, highways, and human***.

- Maybe by adding ***water*** to the environment.

- Maybe by adding ***more rules*** and making this model more realistic



## RELATED MODELS

- ***"Move Towards Target"*** 

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
Polygon -1 true false 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

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
Polygon -13840069 true false 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -13840069 true false 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -1184463 true false 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -1184463 true false 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -955883 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -1184463 true false 135 90 30
Line -13840069 false 150 105 195 60
Line -13840069 false 150 105 105 60

butterfly 2
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

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

cloud
false
0
Circle -7500403 true true 13 118 94
Circle -7500403 true true 86 101 127
Circle -7500403 true true 51 51 108
Circle -7500403 true true 118 43 95
Circle -7500403 true true 158 68 134

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

flower budding
false
0
Polygon -7500403 true true 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Polygon -7500403 true true 189 233 219 188 249 173 279 188 234 218
Polygon -7500403 true true 180 255 150 210 105 210 75 240 135 240
Polygon -7500403 true true 180 150 180 120 165 97 135 84 128 121 147 148 165 165
Polygon -7500403 true true 170 155 131 163 175 167 196 136

hawk
true
0
Polygon -7500403 true true 151 170 136 170 123 229 143 244 156 244 179 229 166 170
Polygon -1 true false 152 154 137 154 125 213 140 229 159 229 179 214 167 154
Polygon -7500403 true true 151 140 136 140 126 202 139 214 159 214 176 200 166 140
Polygon -1 true false 151 125 134 124 128 188 140 198 161 197 174 188 166 125
Polygon -2674135 true false 152 86 227 72 286 97 272 101 294 117 276 118 287 131 270 131 278 141 264 138 267 145 228 150 153 147
Polygon -2674135 true false 160 74 159 61 149 54 130 53 139 62 133 81 127 113 129 149 134 177 150 206 168 179 172 147 169 111
Circle -16777216 true false 144 55 7
Polygon -16777216 true false 129 53 135 58 139 54
Polygon -2674135 true false 148 86 73 72 14 97 28 101 6 117 24 118 13 131 30 131 22 141 36 138 33 145 72 150 147 147

hole
false
1
Polygon -6459832 true false 75 150 105 105 135 120 165 120 195 105 225 150 165 150
Polygon -6459832 false false 107 106 135 94 162 93 191 103 165 120 137 123
Polygon -16777216 true false 112 109 134 99 162 98 185 105 162 122 135 122

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

moon
false
0
Polygon -7500403 true true 175 7 83 36 25 108 27 186 79 250 134 271 205 274 281 239 207 233 152 216 113 185 104 132 110 77 132 51

mouse side
false
0
Polygon -7500403 true true 38 162 24 165 19 174 22 192 47 213 90 225 135 230 161 240 178 262 150 246 117 238 73 232 36 220 11 196 7 171 15 153 37 146 46 145
Polygon -7500403 true true 289 142 271 165 237 164 217 185 235 192 254 192 259 199 245 200 248 203 226 199 200 194 155 195 122 185 84 187 91 195 82 192 83 201 72 190 67 199 62 185 46 183 36 165 40 134 57 115 74 106 60 109 90 97 112 94 92 93 130 86 154 88 134 81 183 90 197 94 183 86 212 95 211 88 224 83 235 88 248 97 246 90 257 107 255 97 270 120
Polygon -16777216 true false 234 100 220 96 210 100 214 111 228 116 239 115
Circle -2674135 true false 246 117 20
Line -7500403 true 270 153 282 174
Line -7500403 true 272 153 255 173
Line -7500403 true 269 156 268 177

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -6459832 true false 110 5 80
Polygon -13840069 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -11221820 true false 127 79 172 94
Polygon -11221820 true false 195 90 240 150 225 180 165 105
Polygon -11221820 true false 105 90 60 150 75 180 135 105
Circle -2674135 true false 120 30 30
Circle -2674135 true false 150 30 30
Rectangle -16777216 true false 135 60 165 75

plant
false
0
Rectangle -6459832 true false 135 90 165 300
Polygon -13840069 true false 133 255 88 210 43 195 73 255 133 285
Polygon -13840069 true false 165 255 210 210 255 195 225 255 165 285
Polygon -13840069 true false 135 180 90 135 45 120 75 180 135 210
Polygon -13840069 true false 165 180 165 210 225 180 255 120 210 135
Polygon -13840069 true false 135 105 90 60 45 45 75 105 135 135
Polygon -13840069 true false 165 105 165 135 225 105 255 45 210 60
Polygon -6459832 true false 135 90 120 45 150 15 180 45 165 90

plant small
false
0
Rectangle -7500403 true true 135 240 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 240 120 195 150 165 180 195 165 240

rabbit
false
0
Polygon -7500403 true true 61 150 76 180 91 195 103 214 91 240 76 255 61 270 76 270 106 255 132 209 151 210 181 210 211 240 196 255 181 255 166 247 151 255 166 270 211 270 241 255 240 210 270 225 285 165 256 135 226 105 166 90 91 105
Polygon -7500403 true true 75 164 94 104 70 82 45 89 19 104 4 149 19 164 37 162 59 153
Polygon -7500403 true true 64 98 96 87 138 26 130 15 97 36 54 86
Polygon -7500403 true true 49 89 57 47 78 4 89 20 70 88
Circle -16777216 true false 37 103 16
Line -16777216 false 44 150 104 150
Line -16777216 false 39 158 84 175
Line -16777216 false 29 159 57 195
Polygon -5825686 true false 0 150 15 165 15 150
Polygon -5825686 true false 76 90 97 47 130 32
Line -16777216 false 180 210 165 180
Line -16777216 false 165 180 180 165
Line -16777216 false 180 165 225 165
Line -16777216 false 180 210 210 240

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

squirrel
false
0
Polygon -6459832 true false 87 267 106 290 145 292 157 288 175 292 209 292 207 281 190 276 174 277 156 271 154 261 157 245 151 230 156 221 171 209 214 165 231 171 239 171 263 154 281 137 294 136 297 126 295 119 279 117 241 145 242 128 262 132 282 124 288 108 269 88 247 73 226 72 213 76 208 88 190 112 151 107 119 117 84 139 61 175 57 210 65 231 79 253 65 243 46 187 49 157 82 109 115 93 146 83 202 49 231 13 181 12 142 6 95 30 50 39 12 96 0 162 23 250 68 275
Polygon -16777216 true false 237 85 249 84 255 92 246 95
Line -16777216 false 221 82 213 93
Line -16777216 false 253 119 266 124
Line -16777216 false 278 110 278 116
Line -16777216 false 149 229 135 211
Line -16777216 false 134 211 115 207
Line -16777216 false 117 207 106 211
Line -16777216 false 91 268 131 290
Line -16777216 false 220 82 213 79
Line -16777216 false 286 126 294 128
Line -16777216 false 193 284 206 285

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

sun
false
0
Circle -7500403 true true 75 75 150
Polygon -7500403 true true 300 150 240 120 240 180
Polygon -7500403 true true 150 0 120 60 180 60
Polygon -7500403 true true 150 300 120 240 180 240
Polygon -7500403 true true 0 150 60 120 60 180
Polygon -7500403 true true 60 195 105 240 45 255
Polygon -7500403 true true 60 105 105 60 45 45
Polygon -7500403 true true 195 60 240 105 255 45
Polygon -7500403 true true 240 195 195 240 255 255

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tile brick
false
0
Rectangle -1 true false 0 0 300 300
Rectangle -7500403 true true 15 225 150 285
Rectangle -7500403 true true 165 225 300 285
Rectangle -7500403 true true 75 150 210 210
Rectangle -7500403 true true 0 150 60 210
Rectangle -7500403 true true 225 150 300 210
Rectangle -7500403 true true 165 75 300 135
Rectangle -7500403 true true 15 75 150 135
Rectangle -7500403 true true 0 0 60 60
Rectangle -7500403 true true 225 0 300 60
Rectangle -7500403 true true 75 0 210 60

tree
false
0
Circle -10899396 true false 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -10899396 true false 65 21 108
Circle -10899396 true false 116 41 127
Circle -10899396 true false 45 90 120
Circle -10899396 true false 104 74 152

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
0
@#$#@#$#@
