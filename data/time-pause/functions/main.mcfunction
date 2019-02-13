#Changing gamerule and making scoreboard
gamerule commandBlockOutput false
scoreboard objectives add temp dummy
scoreboard objectives add timer dummy
scoreboard objectives add selectclock dummy
scoreboard objectives add motion_x dummy
scoreboard objectives add motion_y dummy
scoreboard objectives add motion_z dummy

#detecting when player puts clock in their off-hand and changes selectclock score
scoreboard players set @a[scores={selectclock=1}] selectclock 2
execute as @a[nbt={Inventory:[{id:"minecraft:clock",tag:{display:{Name:"{\"text\":\"Time stopper\"}",Lore:["Stops time"]},Enchantments:[{id:44,lvl:10}]},Count:1b,Slot:-106b}]}] run scoreboard players set @s temp 1
execute as @a[scores={temp=1..}] run clear @s minecraft:clock{display:{Name:"{\"text\":\"Time stopper\"}",Lore:["Stops time"]},Enchantments:[{id:44,lvl:10}]}
execute as @a[scores={temp=1..}] run give @s minecraft:clock{display:{Name:"{\"text\":\"Time stopper\"}",Lore:["Stops time"]},Enchantments:[{id:44,lvl:10}]}
execute as @a[scores={temp=1..}] run scoreboard players add @a selectclock 1
execute as @a[scores={temp=1..}] run scoreboard players set @a temp 0





#Pause time

#Effects
execute as @a[scores={selectclock=2}] run effect give @a speed 1 1 true
execute as @a[scores={selectclock=2}] run effect give @a resistance 1 100 true
execute as @a[scores={selectclock=2}] run effect give @a fire_resistance 1 100 true

#freezes arrows and stores their momentum in motion_x, motion_y, and motion_z
execute as @a[scores={selectclock=2}] run execute as @e[tag=!savedX] run execute store result score @s motion_x run data get entity @s Motion[0] 1000
execute as @a[scores={selectclock=2}] run tag @e[tag=!savedX] add savedX
execute as @a[scores={selectclock=2}] run execute as @e[tag=!savedY] run execute store result score @s motion_y run data get entity @s Motion[1] 1000
execute as @a[scores={selectclock=2}] run tag @e[tag=!savedY] add savedY
execute as @a[scores={selectclock=2}] run execute as @e[tag=!savedZ] run execute store result score @s motion_z run data get entity @s Motion[2] 1000
execute as @a[scores={selectclock=2}] run tag @e[tag=!savedZ] add savedZ

#Entity data
execute as @a[scores={selectclock=2}] run execute as @e run function time-pause:stopentities
execute as @a[scores={selectclock=2}] run execute as @e[type=falling_block] run data merge entity @s {Time:1}

# prevents players from ricing horses
execute as @a[scores={selectclock=2}] run execute at @a as @a run tp @s ~ ~ ~

#Gamerules
execute at @a[scores={selectclock=1}] run gamerule doFireTick false
execute at @a[scores={selectclock=1}] run gamerule randomTickSpeed 0
execute at @a[scores={selectclock=1}] run gamerule doDaylightCycle false
execute at @a[scores={selectclock=1}] run gamerule naturalRegeneration false
execute at @a[scores={selectclock=1}] run gamerule doWeatherCycle false



#Unpause time

#Effects
execute as @a[scores={selectclock=3}] run effect clear @a minecraft:speed
execute as @a[scores={selectclock=3}] run effect clear @a minecraft:resistance
execute as @a[scores={selectclock=3}] run effect clear @a minecraft:fire_resistance

# Entity data
execute as @a[scores={selectclock=3}] run execute as @e run function time-pause:unstopentities

# unpauses arrows from their motion x y and z variables
execute as @a[scores={selectclock=3}] run execute as @e[tag=savedX] run execute store result entity @s Motion[0] double .001 run scoreboard players get @s motion_x
execute as @a[scores={selectclock=3}] run tag @e[tag=savedX] remove savedX
execute as @a[scores={selectclock=3}] run execute as @e[tag=savedY] run execute store result entity @s Motion[1] double .001 run scoreboard players get @s motion_y
execute as @a[scores={selectclock=3}] run tag @e[tag=savedY] remove savedY
execute as @a[scores={selectclock=3}] run execute as @e[tag=savedZ] run execute store result entity @s Motion[2] double .001 run scoreboard players get @s motion_z
execute as @a[scores={selectclock=3}] run tag @e[tag=savedZ] remove savedZ

# Gamerules
execute at @a[scores={selectclock=3}] run gamerule doFireTick true
execute at @a[scores={selectclock=3}] run gamerule randomTickSpeed 3
execute at @a[scores={selectclock=3}] run gamerule doDaylightCycle true
execute at @a[scores={selectclock=3}] run gamerule naturalRegeneration true
execute at @a[scores={selectclock=3}] run gamerule doWeatherCycle true





#Floorcrafting
#gives items tags to detect when touching
tag @e[type=item,nbt={Item:{id:"minecraft:nether_star",Count:1b},OnGround:1b}] add nether_star 
tag @e[type=item,nbt={Item:{id:"minecraft:clock",Count:1b},OnGround:1b}] add clock 

#Makes invisible armor stand to be used as a marker for the animation with timer
scoreboard players add @e[type=armor_stand] timer 1
execute at @e[tag=nether_star,limit=1] run execute at @e[tag=clock,distance=..1,limit=1] run summon armor_stand ~ ~ ~ {Marker:1,Tags:["craft"],Invisible:1}
scoreboard players set @e[tag=!timed,type=armor_stand] timer 0
tag @e[type=armor_stand] add timed


#Animation for crafting, timer is ticks since items touched
execute at @e[tag=craft,scores={timer=0..1}] run kill @e[distance=..1,tag=nether_star]
execute at @e[tag=craft,scores={timer=0..1}] run kill @e[distance=..1,tag=clock]

execute at @e[tag=craft,scores={timer=0}] run playsound minecraft:block.portal.trigger block @a ~ ~ ~ 1 2
execute at @e[tag=craft,scores={timer=0}] run particle minecraft:enchant ~ ~1 ~ .1 .1 .1 1 500

execute at @e[tag=craft,scores={timer=40}] run particle minecraft:instant_effect ~ ~ ~ .2 .4 .2 .5 1000
execute at @e[tag=craft,scores={timer=41}] run playsound minecraft:entity.generic.explode block @a ~ ~ ~ 1 2
execute at @e[tag=craft,scores={timer=42}] run summon item ~ ~ ~ {Item:{id:"minecraft:clock",tag:{display:{Name:"{\"text\":\"Time stopper\"}",Lore:["Stops time"]},Enchantments:[{id:44,lvl:10}]},Count:1b}}
kill @e[tag=craft,scores={timer=50}]





#This is used so when a player's selectclock score goes past 2, it resets to 0
scoreboard players set @a[scores={selectclock=3..}] selectclock 0

#fix fireballs