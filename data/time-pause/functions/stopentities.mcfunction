#The reason I'm using another function here is because in 1.13, the data command can only affect 1 entity
#so I have an execute command make every entity run it or it would take 1 tick per entity to freeze them all
data merge entity @e[limit=1,tag=!frozen] {NoAI:1,Silent:1,NoGravity:1,Motion:[0.0,0.0,0.0],Fuse:9999,Time:1,life:1,direction:[0.0,0.0,0.0],Color:-1,TNTFuse:9999}
tag @e[limit=1,tag=!frozen] add frozen
