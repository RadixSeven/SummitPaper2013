function [newpopa, newpopb] = learn_1_cycle( popa, popb, event, learn_rate )
% Does one cycle of the simple learning algorithm returning new vectors
%
% popa - matrix - the initial a population - rows are population members
%
% popb - matrix same size as popa - the initial b population - rows are
%    population members
%
% event - 2x1 vector - event(1) is the index of the population a member
%    that was observed and event(2) is the index of the population b member
%    that was observed.
%
% learn_rate - a non-negative scalar indicating how aggressive the learning
%    should be
% 
% newpopa - population a after the event
%
% newpopb - population b after the event

[popa(event(1),:) popb(event(2),:)]= ...
    increase_dot_product(popa(event(1),:), popb(event(2),:), learn_rate);

newpopa = popa;
newpopb = popb;

end

