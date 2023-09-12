function [value] = LogFunction(x)
% º¯Êýb(x)=xlog(x)
%  -- usage: value = LogFunction(x)
    if x < 0
        fprintf('SOMETHING WRONG HAS OCCURRED STOP! x is below zero, x = %d \n',x)
    elseif x == 0
        value = 0;
    else
        value = x * log(x);
    end
%     if x <= 0
%         value = 0;
%     else
%         value = x * log(x);
%     end

end