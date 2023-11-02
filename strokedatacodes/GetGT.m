function groundtruth = GetGT(Xmarkers,len)

%% Initialising 
groundtruth = zeros(len,1);
%%
if isempty(Xmarkers) == 0
    if (mod(length(Xmarkers),2) == 0)
        for markind = 1:2:length(Xmarkers) 
            groundtruth(Xmarkers(markind):Xmarkers(markind+1)) = 1;
        end
    elseif (mod(length(Xmarkers),2) == 1)
        Xmarkers = [Xmarkers len];
        for markind = 1:2:length(Xmarkers) 
            groundtruth(Xmarkers(markind):Xmarkers(markind+1)) = 1;
        end
    end
end


end