clc
clear all
close all

for i = 1:5
    variableName = sprintf('myVariable%d', i); % Create a variable name
    value = i * 10; % Example value
    
    % Assign the value to the dynamically generated variable
    eval([variableName{i} ' = ' num2str(value) ';']);
end