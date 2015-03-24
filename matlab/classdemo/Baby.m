classdef Baby < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hour
        name
    end
    
    methods
        function obj = Baby(name)
            obj.name = name;
            obj.hour = 0;
            fprintf('Baby %s created\n', name);
        end
        
        function hourPasses(obj)
            obj.hour = obj.hour + 1;
            switch obj.hour
                case 1
                    fprintf('Baby %s sleeping\n', obj.name);
                case 2
                    fprintf('Baby %s awake\n', obj.name);
                case 3
                    fprintf('Baby %s crying\n', obj.name);
            end
        end
        
        function feed(obj)
            obj.hour = 0;
            fprintf('Baby %s fed\n', obj.name);
        end
    end
    
end
