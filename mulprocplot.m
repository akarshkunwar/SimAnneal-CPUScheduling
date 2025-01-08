function stop = mulprocplot(~,optimvalues,flag,lengths)
% STOP = MULPROCPLOT(OPTIONS,OPTIMVALUES,FLAG) where OPTIMVALUES is a
% structure with the following fields:
% x: current point
% fval: function value at x
% bestx: best point found so far
% bestfval: function value at bestx
% temperature: current temperature
% iteration: current iteration
% funccount: number of function evaluations
% t0: start time
% k: annealing parameter 'k'
% FLAG: Current state in which PlotFcn is called. Possible values are:
% init: initialization state
% iter: iteration state
% done: final state
% STOP: A boolean to stop the algorithm.

persistent thisTitle %#ok

stop = false;
switch flag
    case 'init'
        set(gca,'xlimmode','manual','zlimmode','manual', ...
            'alimmode','manual')
        titleStr = sprintf('Current Point - Iteration %d', optimvalues.iteration);
        thisTitle = title(titleStr,'interp','none');
        toplot = i_generatePlotData(optimvalues, lengths);
        ylabel('Time','interp','none');
        bar(toplot, 'stacked','edgecolor','none');
        Xlength = size(toplot,1);        
        set(gca,'xlim',[0,1 + Xlength])
    case 'iter'
        if ~rem(optimvalues.iteration, 100)
            toplot = i_generatePlotData(optimvalues, lengths);
            bar(toplot, 'stacked','edgecolor','none');
            titleStr = sprintf('Current Point - Iteration %d', optimvalues.iteration);
            thisTitle = title(titleStr,'interp','none');            
        end
end

function toplot = i_generatePlotData(optimvalues, lengths)

schedule = optimvalues.x;
nrows = size(schedule,1);
% Remove zero columns (all processes are idle)
maxlen = 0;
for i = 1:nrows
    if max(nnz(schedule(i,:))) > maxlen
        maxlen = max(nnz(schedule(i,:)));
    end
end
schedule = schedule(:,1:maxlen);

toplot = zeros(size(schedule));
[nrows, ncols] = size(schedule);
for i = 1:nrows
    for j = 1:ncols
        if schedule(i,j)==0 % idle process
            toplot(i,j) = 0;
        else
            toplot(i,j) = lengths(i,schedule(i,j));
        end
    end
end
