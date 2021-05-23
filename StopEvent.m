function [value,isterminal,direction] = StopEvent(~,x)
value = (norm(x(4:6)) > 6778);%stop condition is at 400km altitude
direction = 0;
isterminal = 1;%enables stop condition to end simulation