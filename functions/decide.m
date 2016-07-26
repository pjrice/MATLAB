%Function to decide between n choices

function decide(n)

pick = randi([1 n],[1 1000000]);

fprintf('The Chosen One is: %d!!!!!!!!\n',mode(pick));

end



