function timeToComplete = mulprocfitness(schedule, lengths)
% MULPROCFITNESS determines the fitness of the given schedule.

[nrows ncols] = size(schedule);
timeToComplete = zeros(1,nrows);
for i = 1:nrows
    timeToComplete(i) = 0;
    for j = 1:ncols
        if schedule(i,j)~=0
            timeToComplete(i) = timeToComplete(i)+lengths(i,schedule(i,j));
        else
            break
        end
    end
end
timeToComplete = max(timeToComplete);
