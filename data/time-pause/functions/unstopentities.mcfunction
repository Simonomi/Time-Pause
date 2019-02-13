#The reason I'm using another function here is because in 1.13, the data command can only affect 1 entity
#so I have an execute command make every entity it or it would take 1 tick per entity to unfreeze them all
data merge entity @e[limit=1,tag=frozen] {NoAI:0,Silent:0,NoGravity:0,Fuse:20,TNTFuse:20}
tag @e[limit=1,tag=frozen] remove frozen
