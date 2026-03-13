function schedule = mulprocpermute(optimValues, problemData)
% MULPROCPERMUTE Moves one random task to a different processor.

schedule = optimValues.x;

% FIX: Extract the max temperature to ensure it evaluates to a single scalar integer.
% simulannealbnd creates an array of temperatures matching the dimensions of the input matrix.
currentTemp = max(optimValues.temperature(:));
numChanges = floor(currentTemp) + 1;

[nrows, ncols] = size(schedule);

for i = 1:numChanges
    schedule = neighbor(schedule, nrows, ncols);
end
end

function schedule = neighbor(schedule, nrows, ncols)
% NEIGHBOR generates a single neighbor by moving one random task.

% 1. Find processors that actually have tasks to avoid infinite loops
tasksPerProc = sum(schedule > 0, 2);
validProcs = find(tasksPerProc > 0);

% Pick a random source processor and a random task from it
row1 = validProcs(randi(length(validProcs)));
col = randi(tasksPerProc(row1));

% 2. Pick a random destination processor (different from source)
row2 = randi(nrows);
while row1 == row2
    row2 = randi(nrows);
end

% 3. Move the task
taskToMove = schedule(row1, col);

% Insert into destination (at the first available empty slot)
destCol = tasksPerProc(row2) + 1;
schedule(row2, destCol) = taskToMove;

% Remove from source and shift remaining tasks left using array slicing
schedule(row1, col:ncols-1) = schedule(row1, col+1:ncols);
schedule(row1, ncols) = 0;
end