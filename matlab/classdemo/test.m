clear
clc
mckinley = Baby('McKinley');
keegan = Baby('keegan');

for i = 1:2
    keegan.hourPasses();
    mckinley.feed();
    
    for j = 1:4
        mckinley.hourPasses();
    end
end

