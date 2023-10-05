function result = choose_no_randomly(prob,a1,a2)
% Generate a random number between 0 and 1
randomNumber = rand();

% Map the random number to either 1 or 2
if randomNumber < prob
    result = a1;
else
    result = a2;
end

disp(result);
end

