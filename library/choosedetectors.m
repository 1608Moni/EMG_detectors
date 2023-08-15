function params = choosedetectors(detectorName) 
%%


%%
    switch detectorName 
        case "hodges1"
           params = hodge_param(mode,type,SNR,"hodges");          
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