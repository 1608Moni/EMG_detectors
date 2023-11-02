function saveOnSpaceKeyPress()
    % Wait for a key press event
    disp('Press the space bar to save the file...');
    pause;
    
    % Check if the pressed key is the space bar (ASCII code: 32)
    key = get(gcf, 'CurrentCharacter');
    if double(key) == 32
        % Perform file saving here
        data = magic(5);  % Sample data, replace with your actual data
        save('saved_file.mat', 'data');
        disp('File saved successfully.');
    else
        disp('Key other than space bar was pressed. File not saved.');
    end
end