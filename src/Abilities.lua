-- THIS ENTIRE THING WILL NOT BE USED PROBABLY, JUST TESTING OUT POSSIBLE WAYS THIS COULD WORK


Abilities = {}

function Abilities.orbitSync() --Synchronise speed with closest orbit
    
end 


function Abilities.update(dt)
    for i, #player.abilities do 
        if player.abilities[i] == "orbitSync" then 
            Abilities.orbitSync()
        end
    end
end



