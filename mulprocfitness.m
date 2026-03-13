function makespan = mulprocfitness(schedule, lengths)
% MULPROCFITNESS determines the fitness (makespan) of the given schedule.

nrows = size(schedule, 1);
timeToComplete = zeros(1, nrows);

for i = 1:nrows
    % Extract only the active tasks for this processor (ignores 0s)
    tasks = schedule(i, schedule(i, :) > 0);
    
    % Sum the lengths of these tasks using vector indexing
    timeToComplete(i) = sum(lengths(i, tasks));
end

% The fitness is the maximum time taken by any single processor
makespan = max(timeToComplete);
end