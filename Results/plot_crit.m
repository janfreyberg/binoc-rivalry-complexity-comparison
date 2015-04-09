

trialtype = 2;

colours = {[1 0 0], [0 0 1]};
titles = {'Color Images', 'B&W Lines'};
for stimtype = 1:2
    fig = figure;
    
    subplt = subplot(1, 2, 1);
    hold on
    boxplot( [group(1).type(trialtype, stimtype).critToMiddle(~group(1).type(3, stimtype).percentageMissedOutliers), group(2).type(trialtype, stimtype).critToMiddle(~group(2).type(3, stimtype).percentageMissedOutliers)], [0*group(1).type(trialtype, stimtype).critToMiddle(~group(1).type(3, stimtype).percentageMissedOutliers)'; 1 + 0*group(2).type(trialtype, stimtype).critToMiddle(~group(2).type(3, stimtype).percentageMissedOutliers)'], 'colors', [colours{1}; colours{2}] );
    title('Criterion (percentage) to report MIXTURE');
    set(gca, 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});
    
    subplt = subplot(1, 2, 2);
    hold on
    boxplot( [group(1).type(trialtype, stimtype).critFromMiddle(~group(1).type(3, stimtype).percentageMissedOutliers), group(2).type(trialtype, stimtype).critFromMiddle(~group(2).type(3, stimtype).percentageMissedOutliers)], [0*group(1).type(trialtype, stimtype).critFromMiddle(~group(1).type(3, stimtype).percentageMissedOutliers)'; 1 + 0*group(2).type(trialtype, stimtype).critFromMiddle(~group(2).type(3, stimtype).percentageMissedOutliers)'], 'colors', [colours{1}; colours{2}] );
    title('Criterion (percentage) to report DOMINANT');
    set(gca, 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});
    
%     subplt = subplot(1, 3, 3);
%     hold on
%     boxplot( [group(1).type(trialtype, stimtype).percentageMissed, group(2).type(trialtype, stimtype).percentageMissed], [0*group(1).type(trialtype, stimtype).rtFromMiddle'; 1 + 0*group(2).type(trialtype, stimtype).rtFromMiddle'], 'colors', [colours{1}; colours{2}] );
%     title('Percentage of Transitions Missed');
%     set(gca, 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});
    
    suptitle(titles(stimtype));
end