function detectors(EMG, detectorName)
%% Function to call the detectors indiviually for each trial and plot the outputs
% Input params : emg          - Structure which contains emg parameters used for 
%                               generating data and the corresponding raw emg data
%                detectorName - Name of the detector to call

%% Call the corresponding detector
    switch detectorName 
        case "hodges1"
           hodgesmain(EMG,'1');
        case "hodges2"
           hodgesmain(EMG,'2');
        case "lidierth1"
           lidierthmain(EMG,'1');
        case "lidierth2"
           lidierthmain(EMG,'2');
        case "bonato"
            bonatomain(EMG,"bonato");
        case "TKEO"
            TKEOmain(EMG,"TKEO");
        case "Optest"
            Optestmain(EMG); 
        case "AGLRstep1"
            AGLRstepmain(EMG,'1')
        case "AGLRstep2"
            AGLRstepmain(EMG,'2')
        case "SampEnt"
            SamEntmain(EMG,"SampEnt")
        case "FuzzyEnt"
            FuzzyEntmain(EMG,"FuzzyEnt")
        case "SSA"
            SSAmain(EMG,"SSA")
        case "CWT"
            cwtmain(EMG,"CWT")
         case "Detector2018"
            EMGdetectormain(EMG,"Detector2018");
        otherwise
           disp('detector not found') 
    end
   

end