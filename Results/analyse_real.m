for igroup = 1:2;
for subject = 1:files(igroup).number
    
    load(fullfile(pwd, num2str(igroup-1), files(igroup).name(subject, :) ));
    
    % this is the 'real' trials
    trialtype = 1;
    
    
    for stimtype = 1:2;
        
        tempdom = [];
        tempright = [];
        tempmiddle = [];
        templeft = [];
        tempBins = zeros(6, 10);
        
        for trial = 1:6
            d = 0;
            dd = 0;
            switches = 0;
            reversions = 0;
            transitionListAll = [0, 0, 0];
            transitionSecsAll = 0;
            transitionList = [];
            transitionSecs = [];
            
            switchTimes = [];
            pressDur = [0, 0, 0];
            
            pressList = block(trialtype, stimtype).pressList(:, :, trial);
            pressSecs = block(trialtype, stimtype).pressSecs(:, :, trial);
            
            
            % get rid of every DUPLICATE event
            delObservations = [false; sum(pressList(2:end, 1:3) == pressList(1:end-1, 1:3), 2) == 3];
            pressList(delObservations, :) = [];
            pressSecs(delObservations, :) = [];
            observations = size(pressList, 1);
            
            for c = 2:observations
                
                
                if d == 0 && sum(pressList(c, 1:3)) == 1
                    d = d + 1;
                    transitionList(d, 1:3) = pressList(c, 1:3);
                    transitionSecs(d, 1, trial) = pressSecs(c, 1);
                elseif d > 0 && sum(pressList(c, 1:3)) == 1 && ~isequal(pressList(c, 1:3), transitionList(d, 1:3))
                    d = d + 1;
                    transitionList(d, 1:3) = pressList(c, 1:3);
                    transitionSecs(d, 1) = pressSecs(c, 1);
                end
                
                if dd == 0;
                    dd = dd + 1;
                    transitionListAll(dd, 1:3) = pressList(c, 1:3);
                    transitionSecsAll(dd, 1) = pressSecs(c, 1);
                elseif dd > 0 && ~isequal(pressList(c, 1:3), transitionListAll(dd, 1:3))
                    dd = dd + 1;
                    transitionListAll(dd, 1:3) = pressList(c, 1:3);
                    transitionSecsAll(dd, 1) = pressSecs(c, 1);
                end
                
            end
            
            firstDom = transitionSecsAll(min([ find(transitionListAll(:, 1), 1), find(transitionListAll(:, 3), 1) ]));
            if isempty(firstDom)
                firstDom = 40;
            end
            
            revertedtimes = [];
            for e = 2:d
                if (e>1 && (isequal(transitionList(e-1:e, 1:3), [1 0 0; 0 0 1]) || isequal(transitionList(e-1:e, 1:3), [0 0 1; 1 0 0]))) || ( e>2 && (isequal(transitionList(e-2:e, 1:3), [1 0 0; 0 1 0; 0 0 1]) || isequal(transitionList(e-2:e, 1:3), [0 0 1; 0 1 0; 1 0 0])) )
                    switches = switches + 1;
                    switchTimes(switches, 1) = transitionSecs(e, 1);
                end
                
                if e>2 && (isequal(transitionList(e-2:e, 1:3), [0 0 1; 0 1 0; 0 0 1]) || isequal(transitionList(e-2:e, 1:3), [1 0 0; 0 1 0; 1 0 0]))
                    reversions = reversions + 1;
                    reverTimes(reversions, 1) = transitionSecs(e, 1);
                    revertedtimes = [revertedtimes; transitionSecs(e-2, 1)];
                end
                
            end
            
            delindex = transitionSecsAll*0;
            for ee = 2:dd-1
                if sum(transitionListAll(ee, :)) ~= 1 && isequal(transitionListAll(ee-1, :), transitionListAll(ee+1, :))
                    delindex(ee, 1) = 1;
                end
                if sum(transitionSecsAll(ee, 1) == revertedtimes)
                    delindex(ee, 1) = 1;
                end
            end
            
            if sum(transitionListAll(end, :)) == 1
               delindex(end) = 1; 
            end
            
            delindex(max([find( sum(transitionListAll, 2) &  transitionListAll(:, 1), 1, 'last' ), find( sum(transitionListAll, 2) &  transitionListAll(:, 3), 1, 'last' )])) = 1;
            
            delindex = logical(delindex) | transitionSecsAll < 0;
            
            
            transitionListAll(delindex, :) = [];
            transitionSecsAll(delindex, :) = [];
            
            dd = size(transitionSecsAll, 1);
            
            z = 1;
            for ee = 2:dd
                if ~isequal(transitionListAll(ee, :), transitionListAll(ee-1, :))
                    if sum(transitionListAll(ee-1, :)) == 1;
                        buttonIndex = find(transitionListAll(ee-1, :), 1);
                        durindex = 1 + sum(pressDur(:, buttonIndex) ~=0);
                        pressDur(durindex, buttonIndex ) = transitionSecsAll(ee, 1) - transitionSecsAll(z, 1);
                        if pressDur(durindex, buttonIndex ) < 0.150;
                            pressDur(durindex, buttonIndex ) = 0;
                        end
                    end
                    
                    z = ee;
                end
            end
            
                
            tempdom = [tempdom; pressDur(pressDur(:, 1)>0.15, 1); pressDur(pressDur(:, 3)>0.15, 3)];
            domnr = size([pressDur(pressDur(:, 1)>0.15, 1); pressDur(pressDur(:, 3)>0.15, 3)], 1);
            temptrialdom(1:domnr) = [pressDur(pressDur(:, 1)>0.15, 1); pressDur(pressDur(:, 3)>0.15, 3)];

            templeft = [templeft; pressDur(pressDur(:, 1)>0.15, 1)];
            tempmiddle = [tempmiddle; pressDur(pressDur(:, 2)>0.15, 2)];
            tempright = [tempright; pressDur(pressDur(:, 3)>0.15, 3)];
            
            
            for bin = 1:10
                tempBins(trial, bin) = sum( switchTimes > (bin-1)*4 & switchTimes <= (bin)*4 );
                tempRelBins(trial, bin) = sum( switchTimes > firstDom + (bin-1)*4 & switchTimes <= firstDom + (bin)*4 );
                if firstDom + (bin)*4 > 40
                    tempRelBins(trial, bin) = NaN;
                end
            end
            
            group(igroup).type(trialtype, stimtype).switches(subject, trial) = switches;
            group(igroup).type(trialtype, stimtype).reversions(subject, trial) = reversions;
            
            
            
        end
        
        group(igroup).type(trialtype, stimtype).binnedSwitches(subject, :) = mean(tempBins, 1);
        group(igroup).type(trialtype, stimtype).binnedRelSwitches(subject, :) = nanmean(tempRelBins, 1);
        group(igroup).type(trialtype, stimtype).pressDur(subject, 1) = mean(templeft);
        group(igroup).type(trialtype, stimtype).pressDur(subject, 2) = mean(tempmiddle);
        group(igroup).type(trialtype, stimtype).pressDur(subject, 3) = mean(tempright);
        
        mixDur{igroup}(stimtype, subject) = mean(tempmiddle');
        domDur{igroup}(stimtype, subject) = mean([templeft', tempright']);
        mixSum{igroup}(stimtype, subject) = sum(tempmiddle');
        domSum{igroup}(stimtype, subject) = sum([templeft', tempright']);
        
        invmixDur{igroup}(stimtype, subject) = mean(1 ./ tempmiddle');
        invdomDur{igroup}(stimtype, subject) = mean(1 ./ [templeft', tempright']);
        
    end
end
end