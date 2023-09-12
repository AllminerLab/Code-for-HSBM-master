function [value] = LogF1(x)
%  -- usage: value = LogF1(x)
    if x < 0
        fprintf('SOMETHING WRONG HAS OCCURRED STOP! x is below zero, x = %d \n',x)
    elseif x == 0
        value = 0;
    else
        value = log(x);
    end

end