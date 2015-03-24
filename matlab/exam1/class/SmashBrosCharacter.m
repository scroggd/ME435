classdef SmashBrosCharacter < handle
    
    properties
        name
        life
        damage
    end
    
    methods
        function obj = SmashBrosCharacter(name, life, damage)
            obj.name = name;
            obj.damage = damage;
            obj.life = life;
            
            fprintf('%s is at %i life.\n', name, life); 
        end
        
        function attack(obj, target)
            if(obj.life <= 0)
                fprintf('%s has already been defeated and cannot attack.\n', obj.name);
            elseif(target.life <= 0)
                fprintf('%s has already been defeater, so %s cannot attack them.\n', target.name, obj.name);
            else
                target.life = target.life - obj.damage;
                if(target.life <= 0)
                    fprintf('%s defeats %s!\n', obj.name, target.name);
                else
                    fprintf('%s attacks %s, doing %i damage. %s life = %i.\n', obj.name, target.name, obj.damage, target.name, target.life);
                end
            end
        end
    end
    
end

