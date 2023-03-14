clc
clear all
close all 

x = 1:5;

y = @x;
for i = 1:length(x)
    if x(i) <=2
        y(i) = 1;
    else
        y(i) = 0;
    end
end