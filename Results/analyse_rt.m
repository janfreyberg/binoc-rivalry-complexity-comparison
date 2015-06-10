missedEventDurs = [];
allEventDurs = [];
miss_indexEventDurs = [];
type_indexEventDurs=[];
partic_indexEventDurs = [];
for igroup = 1:2;
for subject = 1:files(igroup).number
    
    load(fullfile(pwd, num2str(igroup-1), files(igroup).name(subject, :) ));
    
    
    
    % this is the 'smooth simulation' trials
    trialtype = 3;
    
    
    for stimtype = 1:2
        
        LRnow = LR(trialType == trialtype & stimType == stimtype);
        
        RTfromMiddleTotal = [];
        RTtoMiddleTotal = [];
        eventsTotal = 0;
        missedEventsTotal = 0;
        fromRevTotal = [];
        
        for trial = 1:6
            
            % reset variables
            LtoM = [];
            RtoM = [];
            MtoL = [];
            MtoR = [];
            LtoR = [];
            RtoL = [];
            
            RTtoMiddle = [];
            RTfromMiddle = [];
            fromReversion = [];
            
            missedEvent = 0;
            
            pressList = block(trialtype, stimtype).pressList(:, :, trial);
            pressSecs = block(trialtype, stimtype).pressSecs(:, :, trial);
            simCourse = block(trialtype, stimtype).course(1, :, trial);
            simSecs = linspace(0, 40, size(simCourse, 2));
            
            % get rid of every DUPLICATE event
            delObservations = [false; sum(pressList(2:end, 1:3) == pressList(1:end-1, 1:3), 2) == 3];
            pressList(delObservations, :) = [];
            pressSecs(delObservations, :) = [];
            
            % get rid of everything that's not single buttons
            delMisbuttons = sum( pressList(:, :), 2 ) ~= 1;
            pressList(delMisbuttons, :) = [];
            pressSecs(delMisbuttons, :) = [];
            
            % get rid of excess info in the simulation
            delSim = [false, simCourse(1:end-1) == simCourse(2:end)];
            simCourse(delSim) = [];
            simSecs(delSim) = [];
            
            % determine the length of each simulated stimulus
            [~, simDurs] = parse_percepts( simSecs, [], 40 );
            % Ignore events shorter than 150 ms
            
            delSim = simDurs < 0.75;
            simCourse(delSim) = [];
            simSecs(delSim) = [];
            
            
            % adjust the simCourse to match button presses
            if LRnow(trial) == 2
                simCourse(simCourse==45) = 2;
                simCourse(simCourse==1) = 3;
                simCourse(simCourse==90) = 1;
            elseif LRnow(trial) == 1
                simCourse(simCourse==45) = 2;
                simCourse(simCourse==90) = 3;
                simCourse(simCourse==1) = 1;
            end
            
            transitions = size(pressList, 1);
            events = size(simCourse, 2);
            
            
            
            % first, all the transitions get sorted into what kind they
            % were!
            for itrans = 2:transitions
                if isequal( pressList(itrans-1:itrans, 1:3), [1 0 0; 0 1 0])
                    LtoM = [LtoM, pressSecs(itrans)];
                elseif isequal( pressList(itrans-1:itrans, 1:3), [1 0 0; 0 0 1])
                    LtoR = [LtoR, pressSecs(itrans)];
                elseif isequal( pressList(itrans-1:itrans, 1:3), [0 0 1; 0 1 0])
                    RtoM = [RtoM, pressSecs(itrans)];
                elseif isequal( pressList(itrans-1:itrans, 1:3), [0 0 1; 1 0 0])
                    RtoL = [RtoL, pressSecs(itrans)];
                elseif isequal( pressList(itrans-1:itrans, 1:3), [0 1 0; 0 0 1])
                    MtoR = [MtoR, pressSecs(itrans)];
                elseif isequal( pressList(itrans-1:itrans, 1:3), [0 1 0; 1 0 0])
                    MtoL = [MtoL, pressSecs(itrans)];
                end
            end
            
            
            
            
            for ievent = 2:events-1
                respIndex = find(pressList(:, simCourse(ievent)) & pressSecs > simSecs(ievent), 1);
                nextEvent = find(simCourse==simCourse(ievent) & simSecs > simSecs(ievent), 1);
                
                allEventDurs = [allEventDurs, simDurs(ievent)];
                partic_indexEventDurs = [partic_indexEventDurs, igroup*100 + subject];
                if simCourse(ievent) == 2
                    type_indexEventDurs = [type_indexEventDurs, 2];
                else
                    type_indexEventDurs = [type_indexEventDurs, 1];
                end
                if isempty(respIndex) && simCourse(ievent) ~= 2
                    missedEvent = missedEvent + 1;
                    missedEventDurs = [missedEventDurs,simDurs(ievent)];
                    miss_indexEventDurs = [miss_indexEventDurs, 1];
                elseif ~isempty(nextEvent) && simCourse(ievent) ~= 2 && logical(pressSecs(respIndex) > simSecs(nextEvent))
                    missedEvent = missedEvent + 1;
                    missedEventDurs = [missedEventDurs,simDurs(ievent)];
                    miss_indexEventDurs = [miss_indexEventDurs, 1];
                else
                    miss_indexEventDurs = [miss_indexEventDurs, 0];
                end
                
                if isempty(respIndex)
                elseif ~isempty(nextEvent) && logical(pressSecs(respIndex) > simSecs(nextEvent))
                else
                    if simCourse(ievent) == 2
                        RTtoMiddle = [RTtoMiddle, pressSecs(respIndex) - simSecs(ievent)];
                    else
                        RTfromMiddle = [RTfromMiddle, pressSecs(respIndex) - simSecs(ievent)];
                        if ievent>2 && simCourse(ievent) == simCourse(ievent-2)
                            fromReversion = [fromReversion, true];
                        else 
                            fromReversion = [fromReversion, false];
                        end
                    end
                end
                
            end
            
            RTtoMiddleTotal = [RTtoMiddleTotal, RTtoMiddle]; %#ok<*AGROW>
            RTfromMiddleTotal = [RTfromMiddleTotal, RTfromMiddle];
            missedEventsTotal = missedEventsTotal + missedEvent;
            eventsTotal = eventsTotal + events;
            fromRevTotal = [fromRevTotal, fromReversion];
        end
        
        group(igroup).type(trialtype, stimtype).missedEvents(subject) = missedEventsTotal;
        group(igroup).type(trialtype, stimtype).eventsTotal(subject) = eventsTotal; %#ok<*SAGROW>
        group(igroup).type(trialtype, stimtype).percentageMissed(subject) = missedEventsTotal/eventsTotal;
        group(igroup).type(trialtype, stimtype).rtFromMiddle(subject) = mean(RTfromMiddleTotal);
        group(igroup).type(trialtype, stimtype).rtToMiddle(subject) = mean(RTtoMiddleTotal);
        
        group(igroup).type(trialtype, stimtype).rtRev(subject) = mean(RTfromMiddleTotal(logical(fromRevTotal)));
        group(igroup).type(trialtype, stimtype).rtSwi(subject) = mean(RTfromMiddleTotal(~logical(fromRevTotal)));
        
    end
    
end


for stimtype = 1:2
% find outliers in group!
group(igroup).type(trialtype, stimtype).rtFromMiddleOutliers = group(igroup).type(trialtype, stimtype).rtFromMiddle > median(group(igroup).type(trialtype, stimtype).rtFromMiddle) + 2* iqr(group(igroup).type(trialtype, stimtype).rtFromMiddle) |...
                                                               group(igroup).type(trialtype, stimtype).rtFromMiddle < median(group(igroup).type(trialtype, stimtype).rtFromMiddle) - 2* iqr(group(igroup).type(trialtype, stimtype).rtFromMiddle);

group(igroup).type(trialtype, stimtype).rtToMiddleOutliers = group(igroup).type(trialtype, stimtype).rtToMiddle > median(group(igroup).type(trialtype, stimtype).rtToMiddle) + 2* iqr(group(igroup).type(trialtype, stimtype).rtToMiddle) |...
                                                             group(igroup).type(trialtype, stimtype).rtToMiddle < median(group(igroup).type(trialtype, stimtype).rtToMiddle) - 2* iqr(group(igroup).type(trialtype, stimtype).rtToMiddle);

group(igroup).type(trialtype, stimtype).percentageMissedOutliers = group(igroup).type(trialtype, stimtype).percentageMissed > median(group(igroup).type(trialtype, stimtype).percentageMissed) + 2* iqr(group(igroup).type(trialtype, stimtype).percentageMissed);

end
meanMisses{igroup} = mean([group(igroup).type(trialtype, 1).percentageMissed; group(igroup).type(trialtype, 2).percentageMissed], 1);
meanRTfromMiddle{igroup} = nanmean([group(igroup).type(trialtype, 1).rtFromMiddle; group(igroup).type(trialtype, 2).rtFromMiddle], 1);
meanRTtoMiddle{igroup} = nanmean([group(igroup).type(trialtype, 1).rtToMiddle; group(igroup).type(trialtype, 2).rtToMiddle], 1);

end


for igroup = 1:2
meanMisses{3} = [meanMisses{1}, meanMisses{2}];
group(igroup).meanOutliers2 = meanMisses{igroup} > ( median(meanMisses{3}) + 3* iqr(meanMisses{3}) ) | meanMisses{igroup} < ( median(meanMisses{3}) - 3* iqr(meanMisses{3}) );
end