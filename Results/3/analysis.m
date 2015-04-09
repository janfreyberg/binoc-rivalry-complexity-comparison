% analyse the blocks!
mfiles = ls('*.mat');


for p = 1:size(mfiles, 1);
    
load(mfiles(p, :));

nblocks = size(block, 2);

for a = 1:nblocks
    
    for b = 1:block(a).n
        
        d = 0;
        block(a).switches(b) = 0;
        block(a).reversions(b) = 0;
        block(a).binnedSwitches(1:12, b) = 0;
        
        for c = 2:size(block(a).pressSecs(:, 1, b), 1)
            if ~(isequal(block(a).pressList(c, 1:3, b), [0 0 0]) || sum(block(a).pressList(c, 1:3, b))>1) && ~isequal(block(a).pressList(c, 1:3, b), block(a).pressList(c-1, 1:3, b))
                d = d + 1;
                
                block(a).transitionList(d, 1:3, b) = block(a).pressList(c, 1:3, b);
                block(a).transitionSecs(d, 1, b) = block(a).pressSecs(c, 1, b);
            end
        end
        
        
        last_ind = min([ find(block(a).transitionList(:, 1, b), 1), find(block(a).transitionList(:, 3, b), 1) ]);
        
        
        
        for e = 2:d
            if isequal(block(a).transitionList(e-1:e, 1:3, b), [1 0 0; 0 0 1]) || ( e>2 && isequal(block(a).transitionList(e-2:e, 1:3, b), [1 0 0; 0 1 0; 0 0 1]) )
                block(a).switches(b) = block(a).switches(b) + 1;
                block(a).binnedSwitches(ceil(block(a).transitionSecs(e, 1, b)/5), b) = block(a).binnedSwitches(ceil(block(a).transitionSecs(e, 1, b)/5), b) + 1;
                block(a).domDur(1, ceil(block(a).switches(b)/2), b) = block(a).transitionSecs(e, 1, b) - block(a).transitionSecs(last_ind, 1, b);
                last_ind = e;
            end
            
            if isequal(block(a).transitionList(e-1:e, 1:3, b), [0 0 1; 1 0 0]) || ( e>2 && isequal(block(a).transitionList(e-2:e, 1:3, b), [0 0 1; 0 1 0; 1 0 0]) )
                block(a).switches(b) = block(a).switches(b) + 1;
                block(a).binnedSwitches(ceil(block(a).transitionSecs(e, 1, b)/5), b) = block(a).binnedSwitches(ceil(block(a).transitionSecs(e, 1, b)/5), b) + 1;
                block(a).domDur(3, ceil(block(a).switches(b)/2), b) = block(a).transitionSecs(e, 1, b) - block(a).transitionSecs(last_ind, 1, b);
                last_ind = e;
            end
            
            if e>2 && (isequal(block(a).transitionList(e-2:e, 1:3, b), [0 0 1; 0 1 0; 1 0 0]) || isequal(block(a).transitionList(e-2:e, 1:3, b), [1 0 0; 0 1 0; 0 0 1]))
                block(a).reversions(b) = block(a).reversions(b) + 1;
            end
        end
        
        
        if find(block(a).transitionList(:, 1, b), 1, 'last') > last_ind
            block(a).domDur(1, ceil((block(a).switches(b)+1)/2), b) = block(a).transitionSecs(find(block(a).transitionList(:, 1, b), 1, 'last'), 1, b) - block(a).transitionSecs(last_ind, 1, b);
        elseif find(block(a).transitionList(:, 3, b), 1, 'last') > last_ind
            block(a).domDur(3, ceil((block(a).switches(b)+1)/2), b) = block(a).transitionSecs(find(block(a).transitionList(:, 1, b), 1, 'last'), 1, b) - block(a).transitionSecs(last_ind, 1, b);
        end
    end
    
end

figure('Position', [100, 200, 500, 600]);
axes('YLim', [0, 40], 'XLim', [0, 3], 'XTick', [1, 2], 'XTickLabel', {'Colour Images', 'B&W Gratings'}, 'Box', 'off');
hold on
ylabel('Number of Events');
suptitle(ID);
bardata = zeros(2, 2);
bardata(1, 1:2) = [mean(block(1).switches), mean(block(1).reversions)];
bardata(2, 1:2) = [mean(block(2).switches), mean(block(2).reversions)];
bplt = bar(bardata, 0.2, 'stacked');
set(bplt(1), 'FaceColor', [1, 0.4, 0.4]);
set(bplt(2), 'FaceColor', [1 1 1]);
legend('Switches', 'Reversions');

print(gcf, '-dpng', [ID, '-rivblock.png']);
close all
end