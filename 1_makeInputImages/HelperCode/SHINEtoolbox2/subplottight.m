function sh=subplottight(n,m,i,p)
% p is the percentage to shrink each subplot in from edges
if nargin<4
    p=0;
end

[c,r] = ind2sub([m n], i);
pos=[(c-1)/m, 1-(r)/n, 1/m, 1/n];
pw=pos(3)*p/2;
ph=pos(4)*p/2;
posnew=[pos(1)+pw pos(2)-ph pos(3)-2*pw pos(4)-2*ph];
sh=subplot('Position', posnew);