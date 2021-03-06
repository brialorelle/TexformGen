function [xout yout] = mkWinFunc(center,width,tWidth,range,wrapping,min,max)

%-----------------------------------------
% [xout yout] = mkWinFunc(enter,width,tWidth,range,wrapping,min,max)
%
% create a flat windowing function with raised
% cosine transition boundaries, suitable for
% use with interp1
%
% center: center of the flat portion of the function
% width: width of the flat portion of the function
% tWidth: width of the raised cosine transition region. 
% if a single number is passed, this width is used for 
% both sides. if two numbers are passed, they give the 
% lower and upper side widths. default is 1 and 1.
% range: range of values over which the function should be
% created. default is center +/- (width/2 + tWidth)
% wrapping: if 1, function will wrap around when it exceeds the
% range. if 0, function will be clipped. default is 1.
% min: minimum value of function
% max: maximum value of function
%
% xout: range of evaluated function
% yout: window function evaluated about xout
%
% freeman, 12/25/2008
%-----------------------------------------

% check arguments
if nargin < 2
	error('Need at least a center and a width')
end

if ~exist('tWidth','var') || isempty(tWidth)
	tWidth = [1 1];
elseif length(tWidth) == 1
	tWidth = [tWidth tWidth];
end

if ~exist('range','var') || isempty(range)
	range = [center-width/2-tWidth(1), center+width/2+tWidth(2)];
end

if ~exist('wrapping','var') || isempty(wrapping)
	wrapping = 1;
end

if ~exist('min','var') || isempty(min)
	min = 0;
end

if ~exist('max','var') || isempty(max)
	max = 1;
end

minmax = abs(range(2)-range(1));
[x1 y1] = rcosFn(tWidth(1),center-width/2-tWidth(1)/2,[min max]);
[x2 y2] = rcosFn(tWidth(2),center+width/2+tWidth(2)/2,[min max]);
y2 = -y2+(1+min);
x = [x1 x2];
y = [y1 y2];

if wrapping
	y = interp1(x,y,[range(1)-minmax:0.001:range(2)+minmax]);
	y(isnan(y)) = 0;
	x = [range(1)-minmax:0.001:range(2)+minmax];

	foo = find(x<range(2));
	foo = foo(end-length(y(find(y(x<range(1)))))+1:end);
	y(foo) = y(find(y(x<range(1))));

	foo = find(x>range(1));
	duh = y(x>range(2));
	foo = foo(1:length(duh(find(duh))));
	y(foo) = duh(find(duh));

	ind = find(x >= range(1) & x <= range(2));
	xout = x(ind);
	yout = y(ind);
else
	yout = interp1(x,y,[range(1):0.001:minmax],'linear','extrap');
	yout(isnan(yout)) = 0;
	xout = [range(1):0.001:range(2)];
end
