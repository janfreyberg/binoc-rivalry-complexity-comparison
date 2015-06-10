missedEventDurs = [];
allEventDurs = [];
miss_indexEventDurs = [];
type_indexEventDurs=[];
partic_indexEventDurs = [];
for igroup = 1:2;
for subject = 1:files(igroup).number
    
    load(fullfile(pwd, num2str(igroup-1), files(igroup).name(subject, :) ));
    
    
    
    % this is the 'smooth simulation' trials
    trialtype = 2;
    
    
    for stimtype = 1:2
        
        LRnow = LR(trialType == trialtype & stimType == stimtype);
        
        critToMiddle = [];
        critFromMiddle = [];
        eventsTotal = 0;
        missedEventsTotal = 0;
        
        for trial = 1:6
            
            % reset variables
            LtoM = [];
            RtoM = [];
            MtoL = [];
            MtoR = [];
            LtoR = [];
            RtoL = [];
            
            missedEvent = 0;
            
            pressList = block(trialtype, stimtype).pressList(:, :, trial);
            pressSecs = block(trialtype, stimtype).pressSecs(:, :, trial);
            simCourse = block(trialtype, stimtype).course(1, :, trial);
            simSecs = linspace(0, 40, size(simCourse, 2));
            
            % keep these to later look up percentages
            originalSecs = simSecs;
            originalCourse = simCourse;
            
            % get rid of every DUPLICATE event and events that are not
            % single button presses
            delObservations = sum(pressList, 2) ~= 1;
            pressList(delObservations, :) = [];
            pressSecs(delObservations, :) = [];
            % now the dupl. events
            delObservations = [false; sum(pressList(2:end, 1:3) == pressList(1:end-1, 1:3), 2) == 3];
            pressList(delObservations, :) = [];
            pressSecs(delObservations, :) = [];
            
            % get rid of everything that's not single buttons
            delMisbuttons = sum( pressList(:, :), 2 ) ~= 1;
            pressList(delMisbuttons, :) = [];
            pressSecs(delMisbuttons, :) = [];
            
            delSim = simCourse(2:end) == simCourse(1:end-1);
            simCourse(delSim) = [];
            simSecs(delSim) = [];
            
            simCourseShort = simCourse;
            simSecsShort = simSecs;
            simCourseShort(simCourseShort> 5 & simCourseShort< 85) = 45;
            delShort = [false, simCourseShort(2:end) == simCourseShort(1:end-1)];
            delShort([ simCourseShort ~=1 & simCourseShort ~= 45 & simCourseShort ~=90 ]) = true;
            simCourseShort(delShort) = [];
            simSecsShort(delShort) = [];
            
            % determine the length of each simulated stimulus
            [~, simDurs] = parse_percepts( simSecsShort, [], 40 );
            % Ignore events shorter than 150 ms

            
            transitions = size(pressList, 1);
            events = size(simCourseShort, 2);
            alldata(trial).pressList = pressList;
            
            % adjust the simCourse to match button presses
            if LRnow(trial) == 2
                
                percentageCourse = (originalCourse - 1) / 89;
                percentageCourse(percentageCourse > 0.5) = 1 - percentageCourse(percentageCourse > 0.5);
                
                simCourseShort(simCourseShort==45) = 2;
                simCourseShort(simCourseShort==1) = 3;
                simCourseShort(simCourseShort==90) = 1;
            elseif LRnow(trial) == 1
                
                percentageCourse = (originalCourse - 1) / 89;
                percentageCourse(percentageCourse > 0.5) = 1 - percentageCourse(percentageCourse > 0.5);
                
                simCourseShort(simCourseShort==45) = 2;
                simCourseShort(simCourseShort==90) = 3;
                simCourseShort(simCourseShort==1) = 1;
            end

            
% %             first, all the transitions get sorted into what kind they
% %             were!
%             for itrans = 2:transitions
%                 if isequal( pressList(itrans-1:itrans, 1:3), [1 0 0; 0 1 0])
%                     LtoM = [LtoM, pressSecs(itrans)];
%                 elseif isequal( pressList(itrans-1:itrans, 1:3), [1 0 0; 0 0 1])
%                     LtoR = [LtoR, pressSecs(itrans)];
%                 elseif isequal( pressList(itrans-1:itrans, 1:3), [0 0 1; 0 1 0])
%                     RtoM = [RtoM, pressSecs(itrans)];
%                 elseif isequal( pressList(itrans-1:itrans, 1:3), [0 0 1; 1 0 0])
%                     RtoL = [RtoL, pressSecs(itrans)];
%                 elseif isequal( pressList(itrans-1:itrans, 1:3), [0 1 0; 0 0 1])
%                     MtoR = [MtoR, pressSecs(itrans)];
%                 elseif isequal( pressList(itrans-1:itrans, 1:3), [0 1 0; 1 0 0])
%                     MtoL = [MtoL, pressSecs(itrans)];
%                 end
%             end
            
            for itrans = 1:transitions
                
                if itrans > 1 && pressList(itrans-1, 2)==1 && pressList(itrans, 1)
                    critTime = pressSecs(itrans) - group(igroup).type(3, stimtype).rtFromMiddle(subject);
                    critIndex = find( originalSecs > critTime, 1 );
                    
                    critFromMiddle = [critFromMiddle, percentageCourse(critIndex)];
                elseif itrans > 1 && pressList(itrans-1, 2)==1 && pressList(itrans, 3)
                    critTime = pressSecs(itrans) - group(igroup).type(3, stimtype).rtFromMiddle(subject);
                    critIndex = find( originalSecs > critTime, 1 );
                    
                    critFromMiddle = [critFromMiddle, percentageCourse(critIndex)];
                elseif itrans > 1 && pressList(itrans, 2)==1
                    critTime = pressSecs(itrans) - group(igroup).type(3, stimtype).rtToMiddle(subject);
                    critIndex = find( originalSecs > critTime, 1 );
                    
                    critToMiddle = [critToMiddle, percentageCourse(critIndex)];
                end
            end
            
            for ievent = 2:events-1
                respIndex = find(pressList(:, simCourseShort(ievent)) & (pressSecs > (simSecsShort(ievent)-simDurs(ievent-1))), 1);
                nextEvent = find(simCourseShort==simCourseShort(ievent) & (simSecsShort > (simSecsShort(ievent))), 1);
                
                allEventDurs = [allEventDurs, simDurs(ievent)]; %#ok<*AGROW>
                partic_indexEventDurs = [partic_indexEventDurs, igroup*100 + subject];
                if simCourseShort(ievent) == 2
                    type_indexEventDurs = [type_indexEventDurs, 2];
                else
                    type_indexEventDurs = [type_indexEventDurs, 1];
                end
                if isempty(respIndex) %&& simCourseShort(ievent) ~= 2
                    missedEvent = missedEvent + 1;
                    miss_indexEventDurs = [miss_indexEventDurs, 1];
                elseif ~isempty(nextEvent) && pressSecs(respIndex) > simSecsShort(nextEvent)
                    missedEvent = missedEvent + 1;
                    miss_indexEventDurs = [miss_indexEventDurs, 1];
                else
                    miss_indexEventDurs = [miss_indexEventDurs, 0];
                end
                
            end
            missedEventsTotal = missedEventsTotal + missedEvent;
            eventsTotal = eventsTotal + events-2;
        end
        
        
        group(igroup).type(trialtype, stimtype).critToMiddle(subject) = nanmean(critToMiddle);
        group(igroup).type(trialtype, stimtype).critFromMiddle(subject) = nanmean(critFromMiddle);
        group(igroup).type(trialtype, stimtype).percentageMissed(subject) = missedEventsTotal/eventsTotal;
        
        
    end
    
end


meanCritToMiddle = mean([group(igroup).type(trialtype, 1).critToMiddle; group(igroup).type(trialtype, 2).critToMiddle], 1);
meanCritFromMiddle = mean([group(igroup).type(trialtype, 1).critFromMiddle; group(igroup).type(trialtype, 2).critFromMiddle], 1);


group(igroup).critFromMiddleOutliers = meanCritFromMiddle > ( median(meanCritFromMiddle) + 2* iqr(meanCritFromMiddle) ) | meanCritFromMiddle < ( median(meanCritFromMiddle) - 2* iqr(meanCritFromMiddle) );
group(igroup).critToMiddleOutliers = meanCritToMiddle > ( median(meanCritToMiddle) + 2* iqr(meanCritToMiddle) ) | meanCritToMiddle < ( median(meanCritToMiddle) - 2* iqr(meanCritToMiddle) );

meanMisses{igroup} = mean([group(igroup).type(trialtype, 1).percentageMissed; group(igroup).type(trialtype, 2).percentageMissed], 1); %group(igroup).type(3, 1).percentageMissed; group(igroup).type(3, 2).percentageMissed], 1);
end

for igroup = 1:2
meanMisses{3} = [meanMisses{1}, meanMisses{2}];
group(igroup).meanOutliers3 = meanMisses{igroup} > ( median(meanMisses{3}) + 2.5* iqr(meanMisses{3}) );
end
