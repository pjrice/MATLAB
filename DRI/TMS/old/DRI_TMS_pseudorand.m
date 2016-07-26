


rpspns = zeros(30,4);

for y = 1:4
    
    for z = 1:3:length(rpspns)-2
        
        rpspns(z:z+2,y) = Shuffle([0;1;2]);
        
    end
end
    

    