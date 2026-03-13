% Streamlined the i_generatePlotData function to use vectorized logic for 
% finding active tasks, matching the optimizations made in the fitness function.

function stop = mulprocplot(~, optimvalues, flag, lengths)
% Custom plot function for current schedule

persistent thisTitle %#ok
stop = false;

switch flag
    case 'init'
        set(gca, 'xlimmode', 'manual', 'zlimmode', 'manual', 'alimmode', 'manual');
        titleStr = sprintf('Current Point - Iteration %d', optimvalues.iteration);
        thisTitle = title(titleStr, 'interp', 'none');
        ylabel('Time', 'interp', 'none');
        
        toplot = i_generatePlotData(optimvalues.x, lengths);
        bar(toplot, 'stacked', 'edgecolor', 'none');
        set(gca, 'xlim', [0, size(toplot, 1) + 1]);
        
    case 'iter'
        if ~rem(optimvalues.iteration, 100)
            toplot = i_generatePlotData(optimvalues.x, lengths);
            bar(toplot, 'stacked', 'edgecolor', 'none');
            titleStr = sprintf('Current Point - Iteration %d', optimvalues.iteration);
            thisTitle = title(titleStr, 'interp', 'none');            
        end
end
end

function toplot = i_generatePlotData(schedule, lengths)
    activeCols = any(schedule > 0, 1);
    if any(activeCols)
        schedule = schedule(:, 1:find(activeCols, 1, 'last'));
    end

    nrows = size(schedule, 1);
    toplot = zeros(size(schedule));
    
    for i = 1:nrows
        tasks = schedule(i, schedule(i,:) > 0);
        toplot(i, 1:length(tasks)) = lengths(i, tasks);
    end
end